//
//  HACLocalNotificationCenter.m
//  TimeWorm
//
//  Created by macbook on 16/12/13.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACLocalNotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import "DateTools.h"

#define HACUNCenter [UNUserNotificationCenter currentNotificationCenter]

@implementation HACLocalNotification
- (instancetype)init {
    if (self = [super init]) {
        _identifier = [NSString stringWithFormat:@"%p", self];
        _title = @"";
        _information = @"";
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString*)identifier {
    if (self = [super init]) {
        _identifier = identifier;
        _title = @"";
        _information = @"";
    }
    return self;
}
@end

@interface HACLocalNotificationCenter () <UNUserNotificationCenterDelegate>

@end
@implementation HACLocalNotificationCenter

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken;
    static HACLocalNotificationCenter *instance;
    dispatch_once(&onceToken, ^{
        instance = [HACLocalNotificationCenter new];
    });
    return instance;
}

- (BOOL)registerLocalNotification {
    if ([HACSystemVersion floatValue] >= 10.0f) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center setDelegate:self];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                DDLogInfo(@"iOS10注册通知成功");
            } else {
                DDLogInfo(@"iOS10注册通知失败");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            DDLogInfo(@"%@",settings);
        }];
        return YES;
    } else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            return YES;
        }
        
    }
    return NO;
}

- (BOOL)addHACLocalNotification:(HACLocalNotification*)notifictation {
    if (HACObjectIsNull(notifictation)) {
        return NO;
    }
    if ([HACSystemVersion floatValue] >= 10.0f) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = notifictation.title;
        content.body = notifictation.information;
        content.userInfo = @{@"identifier": notifictation.identifier,
                             @"title": notifictation.title,
                             @"information": notifictation.information,
                             @"type": @(notifictation.type)};
        content.sound = [UNNotificationSound defaultSound];
        DTTimePeriod *period = [[DTTimePeriod alloc] initWithStartDate:[NSDate date] endDate:notifictation.fireDate];
        int seconds = [period durationInSeconds];
        if (seconds < 1) {
            DDLogError(@"seconds: %d", seconds);
            return NO;
        }
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:seconds repeats:NO];
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:notifictation.identifier
                                                                              content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }];
        return YES;
    } else {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UILocalNotification *noti = [[UILocalNotification alloc] init];
            if (noti) {
                noti.fireDate = notifictation.fireDate;
                noti.timeZone = [NSTimeZone defaultTimeZone];
                noti.repeatInterval = 0;
                noti.soundName = UILocalNotificationDefaultSoundName;
                noti.alertBody = notifictation.information;
                noti.applicationIconBadgeNumber = 1;
                noti.userInfo = @{@"identifier": notifictation.identifier,
                                  @"title": notifictation.title,
                                  @"information": notifictation.information,
                                  @"type": @(notifictation.type)};
                UIApplication *app = [UIApplication sharedApplication];
                [app scheduleLocalNotification:noti];
                return YES;
            }
        }
    }
    return NO;
}

- (void)cancelHACLocalNotificationByIdentifier:(NSString *)identifier {
    if ([HACSystemVersion floatValue] >= 10.0f) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if(settings) {
                if([settings authorizationStatus] == UNAuthorizationStatusAuthorized) {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
                }
            }
        }];
    } else {
        UILocalNotification *__block notify;
        [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ide = [obj.userInfo objectForKey:@"identifier"];
            if (ide && [ide isEqualToString:identifier]) {
                notify = obj;
                *stop = YES;
            }
        }];
        [[UIApplication sharedApplication] cancelLocalNotification:notify];
    }
}

- (void)cancelHACLocalNotificationByType:(HACLocalNotificationType)type {
    if ([HACSystemVersion floatValue] >= 10.0) {
        NSMutableArray <NSString*>*__block arr = [NSMutableArray array];
        [[self existHACLocalNotifications] enumerateObjectsUsingBlock:^(HACLocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == type) {
                [arr addObject:obj.identifier];
            }
        }];
        if (arr.count > 0) {
            [HACUNCenter removeDeliveredNotificationsWithIdentifiers:arr];
        }
    } else {
        NSMutableArray *__block arr = [NSMutableArray array];
        [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HACLocalNotificationType t = [[obj.userInfo objectForKey:@"type"] integerValue];
            if (t == type) {
                [arr addObject:obj];
            }
        }];
        if (arr.count > 0) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[UIApplication sharedApplication] cancelLocalNotification:obj];
            }];
        }
    }
}

- (void)cancelAllHACLocalNotifications {
    if ([HACSystemVersion floatValue] >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (NSArray<HACLocalNotification*> *)existHACLocalNotifications {
    NSMutableArray <HACLocalNotification*> *__block retArr = [NSMutableArray array];
    if ([HACSystemVersion floatValue] >= 10.0f) {
        [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            [requests enumerateObjectsUsingBlock:^(UNNotificationRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UNNotificationContent *content = obj.content;
                HACLocalNotification *notify = [[HACLocalNotification alloc] initWithIdentifier:obj.identifier];
                notify.title = content.title;
                notify.information = content.body;
                notify.type = [content.userInfo[@"type"] integerValue];
                [retArr addObject:notify];
            }];
        }];
    } else {
        [[[UIApplication sharedApplication] scheduledLocalNotifications] enumerateObjectsUsingBlock:^(UILocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HACLocalNotification *notify = [[HACLocalNotification alloc] initWithIdentifier:obj.userInfo[@"identifier"]];
            notify.title = obj.userInfo[@"title"];
            notify.information = obj.userInfo[@"information"];
            notify.type = [obj.userInfo[@"type"] integerValue];
            [retArr addObject:notify];
        }];
    }
    return retArr;
}

- (HACLocalNotification *)existHACLocalNotificationForIdentifier:(NSString *)identifier {
    if (HACObjectIsNull(identifier)) {
        return nil;
    }
    HACLocalNotification *__block ret;
    [[self existHACLocalNotifications] enumerateObjectsUsingBlock:^(HACLocalNotification * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            ret = obj;
            *stop = YES;
        }
    }];
    return ret;
}

#pragma mark - ----------------------10.0之后接收推送消息的回调--------------------
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    completionHandler(UNNotificationPresentationOptionNone);
}

@end
