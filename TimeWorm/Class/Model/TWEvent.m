//
//  TWEvent.m
//  TimeWorm
//
//  Created by macbook on 16/9/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEvent.h"
#import "TWDBManager.h"

@interface TWEvent ()
@property (nonatomic, strong) TWModelEvent *curEvent;

@end

@implementation TWEvent {
}

HAC_SINGLETON_IMPLEMENT(TWEvent)

+ (TWModelEvent*)currentEvent {
    return [TWEvent sharedTWEvent].curEvent;
}
+ (TWModelEvent*)createEvent:(TWModelEvent*)event {
    if (event) {
        DDLogInfo(@"create event:%@",event);
        [[self sharedTWEvent] insertNewEvent:event];
        [self sharedTWEvent].curEvent = event;
    } else {
        DDLogError(@"event is nil.");
    }
    return event;
}
+ (TWModelEvent*)createDefaultEventWithTimerId:(int)tid {
    TWModelEvent *event = [TWModelEvent new];
    event.timerId = tid;
    event.startDate = [NSDate date];
//    event.name = [NSString stringWithFormat:@"%@_Pause",[NSDate date]];
    return [self createEvent:event];
}
+ (BOOL)updateEvent:(TWModelEvent*)event {
    if (event.stopDate) {
        DDLogError(@"event has been stoped.");
    } else {
        DDLogInfo(@"update event:%@",event);
        [[self sharedTWEvent] updateEvent:event];
        return YES;
    }
    return NO;
}

+ (BOOL)stopEvent:(TWModelEvent *)event {
    if (event.stopDate) {
        DDLogError(@"event has been stoped.");
    } else {
        event.stopDate = [NSDate date];
        DDLogInfo(@"stop event:%@",event);
        [[self sharedTWEvent] updateEvent:event];
        [self sharedTWEvent].curEvent = nil;
        return YES;
    }
    return NO;
}

#pragma mark -- db ope
- (void)insertNewEvent:(TWModelEvent*)event {
    [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"INSERT INTO TWEvent('name','information','timerId', 'startDate') VALUES('%@','%@','%@','%@')"
                               ,event.name
                               ,event.information
                               ,@(event.timerId)
                               ,event.startDate];
        BOOL ret = [db executeUpdate:updateSql];
        if (ret) {
            NSString * sql = @"select max(seq) as id from sqlite_sequence where name='TWEvent'";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                event.ID = [rs intForColumn:@"id"];
            }
            DDLogInfo(@"insert suucessed.");
        } else {
            DDLogError(@"insert failed!");
        }
    }];
    
}

- (void)updateEvent:(TWModelEvent*)event {
    [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE 'TWEvent' SET 'name' = '%@', 'information'='%@', 'stopDate'='%@' WHERE id = '%@'"
                               , event.name
                               , event.information
                               , event.stopDate
                               , @(event.ID)];
        BOOL ret = [db executeUpdate:updateSql];
        if (ret) {
            DDLogInfo(@"update successed.");
        } else {
            DDLogError(@"update failed!");
        }
    }];
}

@end
