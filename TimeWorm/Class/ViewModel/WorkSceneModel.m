//
//  WorkSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "WorkSceneModel.h"
#import "TWTimer.h"
#import "TWEvent.h"
#import "TWSet.h"
#import "HACLocalNotificationCenter.h"
#import "DateTools.h"

@interface WorkSceneModel() <TWTimerObserver>

@end

@implementation WorkSceneModel {
    BOOL isPause;//menu是否显示的是“暂停”
    NSDate *enterBackgroundTimestamp;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    //receive notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackgroudNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [TWTimer attatchObserver2Timer:self];
}

- (void)switchState:(WorkSceneModelState)state {
    switch (state) {
        case WorkSceneModelStateNone: {
            if (self.currentTimer) {
                [TWTimer cancelTimer:self.currentTimer];
                if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
                    [TWEvent stopEvent:[TWEvent currentEvent]];
                }
            }
            break;
        }
        case WorkSceneModelStateWorking: {
            if (self.currentTimer.state&TWTimerStatePause) {
                // pause -> working
                [TWEvent stopEvent:[TWEvent currentEvent]];
            } else if (self.currentTimer.state&TWTimerStateSilent) {
                // None(silent) -> working
            } else if (self.currentTimer.state&TWTimerStateFlow) {
                // has already been flowing. maybe from outside such as clock seting page
            } else {
                self.errorCode = WorkSceneErrorNeedNewTimer;
                return;
            }
            [TWTimer activeTimer:[TWTimer currentTimer]];
            break;
        }
        case WorkSceneModelStatePause: {
            if (self.currentTimer.state&TWTimerStateFlow) {
                // flow -> pause
                [TWTimer pauseTimer:[TWTimer currentTimer]];
                [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
            } else {
                self.errorCode = WorkSceneErrorNeedNewTimer;
                return;
            }
            break;
        }
        case WorkSceneModelStateEvent: {
            if (self.currentTimer.state&TWTimerStateFlow) {
                // working -> event
                [TWTimer pauseTimer:[TWTimer currentTimer]];
                [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
            } else if (self.currentTimer.state&TWTimerStatePause) {
                // pause -> event
            } else {
                self.errorCode = WorkSceneErrorNeedNewTimer;
                return;
            }
            break;
        }
        case WorkSceneModelStateReset: {
            if (self.currentTimer.state&TWTimerStateSilent) {
                // None(silent) -> reset
            } else if (self.currentTimer.state&TWTimerStateFlow) {
                // working -> reset
            } else if (self.currentTimer.state&TWTimerStatePause) {
                // pause -> reset
                [TWEvent stopEvent:[TWEvent currentEvent]];
            } else {
            }
            [TWTimer resetTimer:[TWTimer currentTimer]];
            break;
        }
        case WorkSceneModelStateEnd: {
            // timer auto stop, do nothing
            break;
        }
    }
    // set state
    self.state = state;
}

- (TWModelTimer *)currentTimer {
    return [TWTimer currentTimer];
}

- (void)clearData {
    [TWTimer removeObserverFromTimer:self];
    [TWTimer cancelTimer:[TWTimer currentTimer]];
    if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
        [TWEvent stopEvent:[TWEvent currentEvent]];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- timer
- (void)startTimer {
    //TWTimer
    [TWTimer createDefaultTimer];
    [self switchState:WorkSceneModelStateWorking];
}

- (void)stopTimer {
    if (self.currentTimer
        && !(self.currentTimer.state&TWTimerStateEnd)
        && !(self.currentTimer.state&TWTimerStateCancel)) {
        [TWTimer cancelTimer:self.currentTimer];
        if ([TWEvent currentEvent]
            && ![TWEvent currentEvent].stopDate) {
            [TWEvent stopEvent:[TWEvent currentEvent]];
        }
    }
}

- (void)tickTime {
    if (self.currentTimer.remainderSeconds <= 0) {
        [self switchState:WorkSceneModelStateEnd];
        self.remainderSeconds = 0;
    } else {
        self.remainderSeconds = self.currentTimer.remainderSeconds;
    }
}

#pragma mark -- command action
- (void)response2workSceneStart {
    sfuc
    [self switchState:WorkSceneModelStateWorking];
    isPause = NO;
}

- (void)response2workScenePause {
    sfuc
    if (isPause && self.currentTimer.state&TWTimerStatePause) {
        [self switchState:WorkSceneModelStateWorking];
    } else if (!isPause && self.currentTimer.state&TWTimerStateFlow) {
        [self switchState:WorkSceneModelStatePause];
    } else {
        self.errorCode = WorkSceneErrorNeedNewTimer;
        return;
    }
    isPause = isPause?NO:YES;
}

- (void)response2workSceneEvent {
    sfuc
    [self switchState:WorkSceneModelStateEvent];
    isPause = YES;
}

- (void)response2workSceneReset {
    sfuc
    [self switchState:WorkSceneModelStateReset];
    isPause = NO;
}

- (void)response2workSceneNone {
    sfuc
    [self switchState:WorkSceneModelStateNone];
    isPause = NO;
}

#pragma mark -- 前后台
- (void)becomeActiveNotification:(NSNotification*)notify {
    sfuc
    if (!enterBackgroundTimestamp) {
        DDLogError(@"enterBackgroundTimestamp is nil");
        return;
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:enterBackgroundTimestamp];
    int seconds = interval;
    if ([TWSet currentSet].keepTimer) {
        if (self.currentTimer && (self.currentTimer.state&TWTimerStateFlow)) {
            self.currentTimer.remainderSeconds -= seconds;
        }
    } else {
        // edit event
        NSMutableString *information = [NSMutableString stringWithString:[TWEvent currentEvent].information?:@""];
        [information appendFormat:@"\n comming back after %d seconds", seconds];
        [TWEvent currentEvent].information = information;
        [TWEvent updateEvent:[TWEvent currentEvent]];
    }
    enterBackgroundTimestamp = nil;
    if ([TWSet currentSet].isNotifyOn) {
        // cancel local notification
        [[HACLocalNotificationCenter defaultCenter] cancelHACLocalNotificationByType:HACLocalNotificationTypeTimer];
        [[HACLocalNotificationCenter defaultCenter] cancelHACLocalNotificationByType:HACLocalNotificationTypeLeaving];
    }
    
}
- (void)enterBackgroudNotification:(NSNotification*)notify {
    sfuc
    HACLocalNotification *localNotify;
    if ([TWSet currentSet].keepTimer) {
        enterBackgroundTimestamp = [NSDate date];
        if ([TWSet currentSet].isNotifyOn) {
            //add local notification
            NSDate *fireDate = [enterBackgroundTimestamp dateByAddingSeconds:[TWTimer currentTimer].remainderSeconds];
            localNotify = [[HACLocalNotification alloc] initWithFireDate:fireDate
                                                                   title:[TWTimer currentTimer].name
                                                             information:NSLocalizedString(@"timer complete", @"")
                                                                    type:HACLocalNotificationTypeTimer];
        }
        // share data for today extension
        [TWUtility shareAppgroupData:@{@"remainderSeconds": @([TWTimer currentTimer].remainderSeconds)
                                       ,@"timerId":@([TWTimer currentTimer].ID)
                                       ,@"state":@([TWTimer currentTimer].state)
                                       ,@"start":[TWTimer currentTimer].startDate
                                       ,@"enterBack":enterBackgroundTimestamp}];
    } else {
        //自动生成event
        if (self.currentTimer.state&TWTimerStateFlow) {
            enterBackgroundTimestamp = [NSDate date];
            // working -> event
            [TWTimer pauseTimer:[TWTimer currentTimer]];
            TWModelEvent *event = [TWModelEvent new];
            event.timerId = self.currentTimer.ID;
            event.startDate = enterBackgroundTimestamp;
            event.name = NSLocalizedString(@"enter background", @"");
            [TWEvent createEvent:event];
            self.state = WorkSceneModelStatePause;
            isPause = YES;
            if ([TWSet currentSet].isNotifyOn) {
                //add local notification
                NSDate *fireDate = [enterBackgroundTimestamp dateByAddingSeconds:[TWTimer currentTimer].remainderSeconds];
                localNotify = [[HACLocalNotification alloc] initWithFireDate:fireDate
                                                                       title:NSLocalizedString(@"appName", @"")
                                                                 information:NSLocalizedString(@"you have a timer not completed", @"")
                                                                        type:HACLocalNotificationTypeLeaving];
            }
            // share data for today extension
            [TWUtility shareAppgroupData:@{@"remainderSeconds": @([TWTimer currentTimer].remainderSeconds)
                                           ,@"timerId":@([TWTimer currentTimer].ID)
                                           ,@"state":@([TWTimer currentTimer].state)
                                           ,@"start":[TWTimer currentTimer].startDate
                                           ,@"enterBack":enterBackgroundTimestamp}];
        }
    }
    // send notification to queue
    if (localNotify) {
        [[HACLocalNotificationCenter defaultCenter] addHACLocalNotification:localNotify];
    }
}

@end
