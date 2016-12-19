//
//  AppConfigManager.m
//  TimeWorm
//
//  Created by macbook on 16/11/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "AppConfigManager.h"
#import "TWCommandHomeScene.h"
#import "TWCommandWorkScene.h"
#import "TWCommandCommon.h"
#import "TWDBManager.h"
#import "DDTTYLogger.h"
#import "FLEXManager.h"
#import "TWSet.h"
#import "TWTimer.h"
#import "HACLocalNotificationCenter.h"
@import GoogleMobileAds;
#import "DateTools.h"
#import "TWIntroPage.h"

@implementation AppConfigManager

+ (void)loadConfig {
    [self config];
    [self loadGuide];
    [self loadCommands];
    [self loadDB];
    [self loadDefaultSet];
    [self loadAdmob];
}

+ (void)applicationDidEnterBackground:(UIApplication *)application {
    // update today extension data
    if (([TWTimer currentTimer] && [TWTimer currentTimer].state&TWTimerStateCancel)
        || ![TWTimer currentTimer]) {
        [TWUtility shareAppgroupData:@{@"state": @0}];
    }
}

+ (void)applicationWillTerminate {
    // update today extension data
    [TWUtility shareAppgroupData:@{@"state": @0}];
    // 取消所有通知
    [HACLNCenter cancelAllHACLocalNotifications];
    // 设置离开后的第二天11点提醒
    NSDate *now = [NSDate date];
    NSDate *fireDate = [[NSDate dateWithYear:now.year month:now.month day:now.day hour:11 minute:0 second:0] dateByAddingDays:1];
    HACLocalNotification *localNotify = [[HACLocalNotification alloc] initWithFireDate:fireDate
                                                           title:NSLocalizedString(@"appName", @"")
                                                     information:NSLocalizedString(@"set timer to work~", @"")
                                                            type:HACLocalNotificationTypePrompting];
    [HACLNCenter addHACLocalNotification:localNotify];
}

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString* prefix = @"TWWidgetApp://timerId=";
    if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
        NSString* timerId = [[url absoluteString] substringFromIndex:prefix.length];
        NSUInteger identifir = [timerId integerValue];
        if ([TWTimer currentTimer] && identifir != [TWTimer currentTimer].ID) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"Timer has been discarded.", @"") doText:nil doBlock:nil];
        } else if (![TWTimer currentTimer]) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"set a new timer.", @"") doText:nil doBlock:nil];
        }
    }
    return YES;
}

+ (void)config {
    //ddlog
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    //flex
    [[FLEXManager sharedManager] showExplorer];
}

+ (void)loadGuide {
    //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
    [TWIntroPage launchShowIntro];
}

+ (void)loadCommands {
    [TWCommandCenter loadCommad:[TWCommandHomeScene new]] ;
    [TWCommandCenter loadCommad:[TWCommandCommon new]] ;
    [TWCommandCenter loadCommad:[TWCommandWorkScene new]];
}

+ (void)loadDB {
    [TWDBManager initializeDB];
}

+ (void)loadDefaultSet {
    //load set
    [TWSet initializeTWSet];
    if ([TWSet currentSet].keepAwake) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}

+ (void)loadLocalNotification {
    [HACLNCenter registerLocalNotification];
    HACBackground(^{
        [HACLNCenter cancelAllHACLocalNotifications];
    });
}

+ (void)loadAdmob {
    [GADMobileAds disableAutomatedInAppPurchaseReporting];
    [GADMobileAds disableSDKCrashReporting];
}
@end
