//
//  TWModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModel.h"
#import <objc/runtime.h>

@implementation TWModel

- (instancetype)initWithFMResultSet:(FMResultSet *)resultSet {
    if (self = [self init]) {
        //
    }
    return self;
}

- (NSString *)description {
    NSMutableString *ret = [NSMutableString stringWithString:NSStringFromClass([self class])];
    unsigned int outCount = 0;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        const char * type = ivar_getTypeEncoding(ivar);
        NSString *value = [self valueForKey:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
        [ret appendFormat:@"\n %s, %s, %@", name, type, value];
    }
    free(ivars);
    return ret;
}

@end
