//
//  TWSet.m
//  TimeWorm
//
//  Created by macbook on 16/10/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWSet.h"
#import "TWDBManager.h"

@implementation TWSet {
    TWModelSet *curSet;
}

HAC_SINGLETON_IMPLEMENT(TWSet)

+ (BOOL)initializeTWSet {
    BOOL ret = NO;
    [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {/*
        NSString *updateSql = [NSString stringWithFormat:
                               @"INSERT INTO TWTimer('name','information','allSeconds', 'remainderSeconds','startDate','state') VALUES('%@','%@','%@','%@','%@','%@')"
                               ,timer.name
                               ,timer.information
                               ,@(timer.allSeconds)
                               ,@(timer.remainderSeconds)
                               ,timer.startDate
                               ,@(timer.state)];
        */
        //ret = [db executeUpdate:updateSql];
        if (ret) {
            DDLogInfo(@"insert suucessed.");
        } else {
            DDLogError(@"insert failed!");
        }
    }];
    return ret;
}

+ (TWModelSet*)currentSet {
    TWModelSet * __block ret = [TWSet sharedTWSet]->curSet;
    if (!ret) {
        [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
            NSString * sql = @"select * from TWSet";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                ret = [[TWModelSet alloc] initWithFMResultSet:rs];
            }
        }];
        [TWSet sharedTWSet]->curSet = ret;
    }
    return ret;
}

+ (BOOL)updateSet:(TWModelSet*)set {
    BOOL ret = NO;
    if (!set) {
        return NO;
    }
    if ([self currentSet]) {
/*        [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
            NSString *updateSql = [NSString stringWithFormat:
                                   @"UPDATE 'TWTimer' SET 'name' = '%@', 'information'='%@', 'startDate'='%@', 'allSeconds'='%@', 'remainderSeconds'='%@', 'state'='%@', 'fireDate'='%@' WHERE id = '%@'"
                                   , timer.name
                                   , timer.information
                                   , timer.startDate
                                   , @(timer.allSeconds)
                                   , @(timer.remainderSeconds)
                                   , @(timer.state)
                                   , timer.fireDate?:@""
                                   , @(timer.ID)];
            BOOL ret = [db executeUpdate:updateSql];
            if (ret) {
                DDLogInfo(@"update successed.");
            } else {
                DDLogError(@"update failed!");
            }
        }];
        */
    } else {
        
    }
    return ret;
}

+ (BOOL)updateSetColumn:(NSString*)column withObj:(id)obj {
    BOOL ret = NO;
    if (!obj || !column) {
        return NO;
    }
    if ([self currentSet]) {
        [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
            NSString *updateSql = [NSString stringWithFormat:
                                   @"UPDATE 'TWSet' SET '%@' = '%@' WHERE id = '%@'"
                                   ,column
                                   ,obj
                                   ,@([self currentSet].ID)];
            BOOL ret = [db executeUpdate:updateSql];
            if (ret) {
                DDLogInfo(@"update successed.");
            } else {
                DDLogError(@"update failed!");
            }
        }];
    }
    return ret;
}

@end
