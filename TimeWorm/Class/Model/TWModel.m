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
//- (NSString *)description {
//    NSString *ret = NSStringFromClass([self class]);
//    unsigned int outCount = 0;
//    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
//    for (unsigned int i = 0; i < outCount; i ++) {
//        objc_property_t property = properties[i];
//        //属性名
//        const char * name = property_getName(property);
//        //属性描述
//        const char * propertyAttr = property_getAttributes(property);
//        [ret stringByAppendingFormat:@"属性描述为 %s 的 %s ", propertyAttr, name];
//        //属性的特性
//        unsigned int attrCount = 0;
//        objc_property_attribute_t * attrs = property_copyAttributeList(property, &attrCount);
//        for (unsigned int j = 0; j < attrCount; j ++) {
//            objc_property_attribute_t attr = attrs[j];
//            const char * name = attr.name;
//            const char * value = attr.value;
//            [ret stringByAppendingFormat:@"属性的描述：%s 值：%s", name, value];
//        }
//        free(attrs);
//        [ret stringByAppendingString:@"\n"];
//    }
//    free(properties);
//    return ret;
//}

@end
