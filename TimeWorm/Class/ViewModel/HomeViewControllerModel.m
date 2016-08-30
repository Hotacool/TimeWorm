//
//  HomeViewControllerModel.m
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeViewControllerModel.h"

@interface HomeViewControllerModel () {
    NSString *_title;
}

@end

@implementation HomeViewControllerModel
@synthesize title=_title;
- (instancetype)init {
    if (self = [super init]) {
        _title = @"Home";
    }
    return self;
}
@end
