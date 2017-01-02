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
#import "TWNotificationManager.h"

@implementation AppConfigManager

+ (void)loadConfig {
    [self config];
    [self loadLocalNotification];
    [self loadGuide];
    [self loadCommands];
    [self loadDB];
    [self loadDefaultSet];
    [self loadAdmob];
    [TWNotificationManager load];
}

+ (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[TWNotificationManager sharedTWNotificationManager] applicationDidBecomeActive:application];
}

+ (void)applicationDidEnterBackground:(UIApplication *)application {
    [[TWNotificationManager sharedTWNotificationManager] applicationDidEnterBackground:application];
}

+ (void)applicationWillTerminate {
    [[TWNotificationManager sharedTWNotificationManager] applicationWillTerminate];
}

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString* prefix = @"TWWidgetApp://timerId=";
    if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
        NSString* timerId = [[url absoluteString] substringFromIndex:prefix.length];
        NSUInteger identifir = [timerId integerValue];
        if ([TWTimer currentTimer] && identifir != [TWTimer currentTimer].ID) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"Mission lost", @"") doText:nil doBlock:nil];
        } else if (![TWTimer currentTimer]) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"Create a new Mission!", @"") doText:nil doBlock:nil];
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
