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

@implementation AppConfigManager

+ (void)loadConfig {
    [self config];
    [self loadCommands];
    [self loadDB];
    [self loadDefaultSet];
    [self loadAdmob];
}

+ (void)config {
    //ddlog
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    //flex
//    [[FLEXManager sharedManager] showExplorer];
    [[HACLocalNotificationCenter defaultCenter] registerLocalNotification];
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

+ (void)loadAdmob {
    [GADMobileAds disableAutomatedInAppPurchaseReporting];
    [GADMobileAds disableSDKCrashReporting];
}
@end
