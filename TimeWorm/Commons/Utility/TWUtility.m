//
//  TWUtility.m
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWUtility.h"

@implementation TWUtility

+ (CAGradientLayer*)getCAGradientLayerWithFrame:(CGRect)frame skinSet:(int)set {
    CAGradientLayer *gradientLayer;
    switch (set) {
        case 0: {
            gradientLayer = [self getCAGradientLayerWithFrame:frame
                                                            colors:@[(__bridge id)WBlue.CGColor, (__bridge id)LBlue.CGColor]
                                                         locations:@[@(0.5f), @(1.0f)]
                                                        startPoint:CGPointMake(0.5, 0)
                                                          endPoint:CGPointMake(0.5, 1)];
            break;
        }
        case 1: {
            gradientLayer = [self getCAGradientLayerWithFrame:frame
                                                       colors:@[(__bridge id)Hgrapefruit.CGColor, (__bridge id)HgrapefruitD.CGColor]
                                                    locations:@[@(0.5f), @(1.0f)]
                                                   startPoint:CGPointMake(0.5, 0)
                                                     endPoint:CGPointMake(0.5, 1)];
            break;
        }
        case 2: {
            gradientLayer = [self getCAGradientLayerWithFrame:frame
                                                       colors:@[(__bridge id)Hbittersweet.CGColor, (__bridge id)HbittersweetD.CGColor]
                                                    locations:@[@(0.5f), @(1.0f)]
                                                   startPoint:CGPointMake(0.5, 0)
                                                     endPoint:CGPointMake(0.5, 1)];
            break;
        }
        case 3: {
            gradientLayer = [self getCAGradientLayerWithFrame:frame
                                                       colors:@[(__bridge id)Hsunflower.CGColor, (__bridge id)HsunflowerD.CGColor]
                                                    locations:@[@(0.5f), @(1.0f)]
                                                   startPoint:CGPointMake(0.5, 0)
                                                     endPoint:CGPointMake(0.5, 1)];
            break;
        }
        case 4: {
            gradientLayer = [self getCAGradientLayerWithFrame:frame
                                                       colors:@[(__bridge id)Hgrass.CGColor, (__bridge id)HgrassD.CGColor]
                                                    locations:@[@(0.5f), @(1.0f)]
                                                   startPoint:CGPointMake(0.5, 0)
                                                     endPoint:CGPointMake(0.5, 1)];
            break;
        }
    }
    return gradientLayer;
}

+ (CAGradientLayer *)getCAGradientLayerWithFrame:(CGRect)frame colors:(NSArray *)colors locations:(NSArray *)locs startPoint:(CGPoint)sP endPoint:(CGPoint)eP {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.startPoint = sP;
    gradientLayer.endPoint = eP;
    gradientLayer.colors = colors;
    gradientLayer.locations = locs;
    return gradientLayer;
}

+ (UIImage *)gradientImageWithBounds:(CGRect)bounds colors:(NSArray *)colors {
    CALayer * bgGradientLayer = [self gradientBGLayerForBounds:bounds colors:colors];
    UIGraphicsBeginImageContext(bgGradientLayer.bounds.size);
    [bgGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * bgAsImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return bgAsImage;
}

+ (CALayer *)gradientBGLayerForBounds:(CGRect)bounds colors:(NSArray *)colors
{
    CAGradientLayer * gradientBG = [CAGradientLayer layer];
    gradientBG.frame = bounds;
    gradientBG.colors = colors;
    return gradientBG;
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

+ (void)shareAppgroupData:(NSDictionary *)dic {
    if (HACObjectIsEmpty(dic)) {
        return;
    }
    // share data for today extension
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.TimeWorm"];
    [shared setObject:dic forKey:@"TWUserDic"];
    [shared synchronize];
}
@end
