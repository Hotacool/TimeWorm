//
//  TWModelEvent.m
//  TimeWorm
//
//  Created by macbook on 16/9/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModelEvent.h"

@implementation TWModelEvent
- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [self init]) {
        if (resultSet) {
            //TODO: use runtime to copy property
            self.ID = [resultSet intForColumn:@"id"];
            self.name = [resultSet stringForColumn:@"name"];
            self.information = [resultSet stringForColumn:@"information"];
            self.timerId = [resultSet intForColumn:@"timerId"];
            self.startDate = [resultSet dateForColumn:@"startDate"];
            self.stopDate = [resultSet dateForColumn:@"stopDate"];
        }
    }
    return self;
}
@end
