//
//  TWNotificationManager.h
//  TimeWorm
//
//  Created by macbook on 16/12/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const kTWApplicationDidEnterBackgroundNotification;
@interface TWNotificationManager : NSObject

HAC_SINGLETON_DEFINE(TWNotificationManager)

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillTerminate;
@end
