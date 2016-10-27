//
//  TWModelTimer.m
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModelTimer.h"

@implementation TWModelTimer

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [self init]) {
        if (resultSet) {
            //TODO: use runtime to copy property
            self.ID = [resultSet intForColumn:@"id"];
            self.name = [resultSet stringForColumn:@"name"];
            self.information = [resultSet stringForColumn:@"information"];
            self.allSeconds = [resultSet intForColumn:@"allSec"];
            self.remainderSeconds = [resultSet intForColumn:@"rmdSec"];
            self.startDate = [resultSet dateForColumn:@"startDate"];
            self.fireDate = [resultSet dateForColumn:@"fireDate"];
            self.state = [resultSet intForColumn:@"state"];
        }
    }
    return self;
}
@end
