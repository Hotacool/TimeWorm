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
#import "HACLocalNotificationCenter.h"
@import GoogleMobileAds;
#import "DateTools.h"

@implementation AppConfigManager

+ (void)loadConfig {
    [self config];
    [self loadCommands];
    [self loadDB];
    [self loadDefaultSet];
    [self loadAdmob];
}

+ (void)applicationWillTerminate {
    // 设置离开后的第二天11点提醒
    NSDate *now = [NSDate date];
    NSDate *fireDate = [[NSDate dateWithYear:now.year month:now.month day:now.day hour:11 minute:0 second:0] dateByAddingDays:1];
    HACLocalNotification *localNotify = [[HACLocalNotification alloc] initWithFireDate:fireDate
                                                           title:NSLocalizedString(@"appName", @"")
                                                     information:NSLocalizedString(@"set timer to work~", @"")
                                                            type:HACLocalNotificationTypePrompting];
    [HACLNCenter addHACLocalNotification:localNotify];
}

+ (void)config {
    //ddlog
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    //flex
//    [[FLEXManager sharedManager] showExplorer];
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
