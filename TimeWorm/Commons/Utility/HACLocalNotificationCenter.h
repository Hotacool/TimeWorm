//
//  HACLocalNotificationCenter.h
//  TimeWorm
//
//  Created by macbook on 16/12/13.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HACLocalNotificationType) {
    HACLocalNotificationTypeDefault,
    HACLocalNotificationTypeTimer,
    HACLocalNotificationTypeLeaving
};

@interface HACLocalNotification : NSObject
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *information;
@property (nonatomic, assign) HACLocalNotificationType type;

@end

@interface HACLocalNotificationCenter : NSObject

+ (instancetype)defaultCenter ;

- (BOOL)registerLocalNotification ;

- (BOOL)addHACLocalNotification:(HACLocalNotification*)notifictation;

- (void)cancelHACLocalNotificationByIdentifier:(NSString*)identifier;

- (void)cancelHACLocalNotificationByType:(HACLocalNotificationType)type;

- (void)cancelAllHACLocalNotifications;

- (NSArray<HACLocalNotification*> *)existHACLocalNotifications;

- (HACLocalNotification*)existHACLocalNotificationForIdentifier:(NSString*)identifier;
@end
