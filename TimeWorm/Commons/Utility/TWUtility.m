//
//  TWUtility.m
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWUtility.h"

@implementation TWUtility

+ (CAGradientLayer *)getCAGradientLayerWithFrame:(CGRect)frame colors:(NSArray *)colors locations:(NSArray *)locs startPoint:(CGPoint)sP endPoint:(CGPoint)eP {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = sP;
    gradientLayer.endPoint = eP;
    gradientLayer.colors = colors;
    gradientLayer.locations = locs;
    return gradientLayer;
}

#pragma mark -- tool method
+ (NSString*)transformTags2String:(NSArray<NSString*>*)tags {
    NSMutableString __block *ret;
    if (tags) {
        [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx==0) {
                ret = [NSMutableString stringWithString:obj];
            } else {
                [ret appendFormat:@",%@",obj];
            }
        }];
    }
    return ret;
}

+ (NSArray<NSString*>*)transformString2Tags:(NSString*)str {
    if (str) {
         return [str componentsSeparatedByString:@","];
    }
    return nil;
}
@end
