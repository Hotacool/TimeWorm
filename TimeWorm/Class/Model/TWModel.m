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
        if (!resultSet) {
            return self;
        }
        @try {
            NSArray *allPros = [self allPropertyNames];
            [allPros enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id r = [resultSet objectForColumnName:obj];
                if (r) {
                    [self setValue:r forKey:obj];
                }
            }];
        } @catch (NSException *exception) {
            DDLogError(@"exception: %@", exception);
        } @finally {
        }
    }
    return self;
}

- (NSString *)createFullUpdateSql {
    NSMutableString *sql;
    
    return sql;
}

///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
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
