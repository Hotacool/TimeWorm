//
//  TWDBManager.m
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWDBManager.h"

#define CORE_DATABASE_NAME @"TWDatabase.sqlite"
#define DB_INITIALIZE_SQL  @"db_initialize"
#define DB_UPDATE_SQL      @"db_update"

@implementation TWDBManager

static FMDatabaseQueue* dbqueue;
+ (FMDatabaseQueue *)dbQueue {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        NSString *documentPath	= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *databasePath	= [documentPath stringByAppendingPathComponent:CORE_DATABASE_NAME];
        DDLogInfo(@"databasePath: %@", databasePath);
        dbqueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    }) ;
    return dbqueue;
}

+ (BOOL)initializeDB {
    BOOL __block ret;
    if ([TWDBManager dbQueue]) {
        [dbqueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            int version = -1;
            FMResultSet *s = [db executeQuery:@"SELECT version FROM TWVersion"];
            if ([s next]) {
                version = [s intForColumnIndex:0];
            }
            int app_ver = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] intValue];
            NSString *sqlPath;
            if (version==app_ver) {
                DDLogInfo(@"database is latest.");
                ret = YES;
            } else {
                if (version < 0) {
                    DDLogInfo(@"initialize db...");
                    sqlPath = [[NSBundle mainBundle] pathForResource:DB_INITIALIZE_SQL ofType:@"sql"];
                } else {
                    if (version < app_ver) {
                        DDLogInfo(@"update db...");
                        sqlPath = [[NSBundle mainBundle] pathForResource:DB_UPDATE_SQL ofType:@"sql"];
                    }
                }
                NSString *sql  = [[NSString alloc] initWithContentsOfFile:sqlPath encoding:NSUTF8StringEncoding error:nil];
                if ([db executeStatements:sql]) {
                    ret = YES;
                    //update version
                    if ([db executeUpdate:@"REPLACE INTO TWVersion VALUES ( ? )", @(app_ver)]) {
                        DDLogInfo(@"update TWVersion to %d", app_ver);
                    }
                    
                } else {
                    DDLogError(@"%s, error: %@", __func__, [db lastErrorMessage]);
                }
            }
            
        }];
    }
    return ret;
}

+ (NSDictionary *)dbInformation {
    return nil;
}

@end
