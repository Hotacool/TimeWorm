//
//  TWNotificationManager.m
//  TimeWorm
//
//  Created by macbook on 16/12/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWNotificationManager.h"
#import "HACLocalNotificationCenter.h"
#import "TWTimer.h"
#import "TWEvent.h"
#import "TWSet.h"
#import "DateTools.h"

NSString *const kTWApplicationDidEnterBackgroundNotification = @"kTWApplicationDidEnterBackgroundNotification";

@implementation TWNotificationManager {
    NSDate *enterBackgroundTimestamp;
}

HAC_SINGLETON_IMPLEMENT(TWNotificationManager)

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- notification handler
- (void)applicationDidBecomeActive:(UIApplication *)application {
    sfuc
    [self setNotificationWithTimer:[TWTimer currentTimer] action:NO];
    [self setTimer:[TWTimer currentTimer] action:NO];
    [self resetUserDefaultsWithTimer:[TWTimer currentTimer]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    sfuc
    // 状态改变前，发通知给WorkSceneModel
    [[NSNotificationCenter defaultCenter] postNotificationName:kTWApplicationDidEnterBackgroundNotification object:nil];
    [self setTimer:[TWTimer currentTimer] action:1];
    [self resetUserDefaultsWithTimer:[TWTimer currentTimer]];
    [self setNotificationWithTimer:[TWTimer currentTimer] action:1];
}

- (void)applicationWillTerminate {
    // update today extension data
    [TWUtility shareAppgroupData:@{@"state": @0}];
    // 取消所有通知
    [HACLNCenter cancelAllHACLocalNotifications];
    // 设置离开后的第二天11点提醒
    NSDate *now = [NSDate date];
    NSDate *fireDate = [[NSDate dateWithYear:now.year month:now.month day:now.day hour:11 minute:0 second:0] dateByAddingDays:1];
    HACLocalNotification *localNotify = [[HACLocalNotification alloc] initWithFireDate:fireDate
                                                                                 title:NSLocalizedString(@"appName", @"")
                                                                           information:NSLocalizedString(@"Leave too long", @"")
                                                                                  type:HACLocalNotificationTypePrompting];
    [HACLNCenter addHACLocalNotification:localNotify];
}

#pragma mark -- private logic
- (void)resetUserDefaultsWithTimer:(TWModelTimer*)curTimer {
    if (HACObjectIsNull(curTimer)) {
        [TWUtility shareAppgroupData:@{@"state": @(0)}];
    } else {
        if (curTimer.state&TWTimerStateCancel
            || curTimer.state&TWTimerStateSilent) {
            [TWUtility shareAppgroupData:@{@"state": @(0)}];
        } else {
            [TWUtility shareAppgroupData:@{@"remainderSeconds": @(curTimer.remainderSeconds)
                                           ,@"timerId":@(curTimer.ID)
                                           ,@"state":@(curTimer.state)
                                           ,@"start":curTimer.startDate
                                           ,@"enterBack":[NSDate date]
                                           ,@"timerName":curTimer.name}];
        }
    }
}

- (void)setTimer:(TWModelTimer*)curTimer action:(BOOL)action {
    if (HACObjectIsNull(curTimer)) {
        DDLogError(@"curTimer is nil.");
        return;
    }
    if (action) { //enter background
        if (curTimer.state&TWTimerStateFlow
            || curTimer.state&TWTimerStatePause) {
            // keep timer
            if ([TWSet currentSet].keepTimer) {
                enterBackgroundTimestamp = [NSDate date];
            } else {
                //自动生成event
                if (curTimer.state&TWTimerStateFlow) {
                    enterBackgroundTimestamp = [NSDate date];
                    // working -> event
                    [TWTimer pauseTimer:[TWTimer currentTimer]];
                    TWModelEvent *event = [TWModelEvent new];
                    event.timerId = curTimer.ID;
                    event.startDate = enterBackgroundTimestamp;
                    event.name = NSLocalizedString(@"Enter background", @"");
                    [TWEvent createEvent:event];
                }
            }
        }
    } else { // become active
        if (HACObjectIsNull(enterBackgroundTimestamp)) {
            DDLogError(@"enterBackgroundTimestamp is nil");
        } else {
            if (curTimer.state&TWTimerStateCancel
                || curTimer.state&TWTimerStateEnd
                || curTimer.state&TWTimerStateSilent) {
                
            } else {
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:enterBackgroundTimestamp];
                int seconds = interval;
                if ([TWSet currentSet].keepTimer) {
                    if (curTimer && (curTimer.state&TWTimerStateFlow)) {
                        curTimer.remainderSeconds -= seconds;
                    }
                } else {
                    // edit event
                    NSMutableString *information = [NSMutableString stringWithString:[TWEvent currentEvent].information?:@""];
                    [information appendFormat:NSLocalizedString(@"Back after seconds", @""), seconds];
                    [TWEvent currentEvent].information = information;
                    [TWEvent updateEvent:[TWEvent currentEvent]];
                }
            }
        }
        enterBackgroundTimestamp = nil;
    }
}

- (void)setNotificationWithTimer:(TWModelTimer*)curTimer action:(BOOL)action {
    if (!action) {
        //cancel all local notification
        [[HACLocalNotificationCenter defaultCenter] cancelHACLocalNotificationByType:HACLocalNotificationTypeTimer];
        [[HACLocalNotificationCenter defaultCenter] cancelHACLocalNotificationByType:HACLocalNotificationTypeLeaving];
    } else {
        if (HACObjectIsNull(curTimer)) {
            DDLogError(@"curTimer is nil.");
            return;
        }
        if (curTimer.state&TWTimerStateSilent
            || curTimer.state&TWTimerStateCancel
            || curTimer.state&TWTimerStateEnd) {
            DDLogError(@"curTimer.state is %lu", (unsigned long)curTimer.state);
            return;
        }
        if ([TWSet currentSet].isNotifyOn) {
            // notification 大于3秒才通知
            if (curTimer.remainderSeconds > 3) {
                NSString *locInfor = @"";
                if (curTimer.state&TWTimerStatePause) {
                    locInfor = NSLocalizedString(@"Mission not complete", @"");
                } else if (curTimer.state&TWTimerStateFlow) {
                    locInfor = NSLocalizedString(@"Mission complete!", @"");
                }
                //add local notification
                NSDate *fireDate = [[NSDate date] dateByAddingSeconds:curTimer.remainderSeconds];
                HACLocalNotification *localNotify = [[HACLocalNotification alloc] initWithFireDate:fireDate
                                                                                             title:[TWTimer currentTimer].name
                                                                                       information:locInfor
                                                                                              type:HACLocalNotificationTypeTimer];
                [[HACLocalNotificationCenter defaultCenter] addHACLocalNotification:localNotify];
            }
        }
        
    }
}
@end
