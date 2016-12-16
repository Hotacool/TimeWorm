//
//  TWShareDataModel.m
//  TimeWorm
//
//  Created by macbook on 16/12/16.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWShareDataModel.h"

@implementation TWShareDataModel

- (instancetype)initWithUserDic:(NSDictionary *)userDic {
    if (self = [super init]) {
        _identifier = [userDic objectForKey:@"timerId"];
        _state = [[userDic objectForKey:@"state"] integerValue];
        _startDate = [userDic objectForKey:@"start"];
        _seconds = [[userDic objectForKey:@"remainderSeconds"] integerValue];
        _enterBack = [userDic objectForKey:@"enterBack"];

    }
    return self;
}

- (NSDictionary *)userDic {
    return @{@"remainderSeconds": @(self.seconds)
             ,@"timerId":self.identifier
             ,@"state":@(self.state)
             ,@"start":self.startDate
             ,@"enterBack":self.enterBack};
}

@end
