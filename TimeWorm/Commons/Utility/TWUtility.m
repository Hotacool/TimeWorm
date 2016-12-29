//
//  TWUtility.m
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWUtility.h"

@implementation TWUtility

+ (void)jump2Tips {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:NSClassFromString(@"HomeViewController")]) {
        UIViewController *tipsVC = [[NSClassFromString(@"TWTipsViewController") alloc] init];
        tipsVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [rootVC presentViewController:tipsVC animated:YES completion:nil];
    }
}

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

+ (UIColor *)getColorBySkinSet:(int)set {
    UIColor *retColor;
    switch (set) {
        case 0: {
            retColor = WBlue;
            break;
        }
        case 1: {
            retColor = Hgrapefruit;
            break;
        }
        case 2: {
            retColor = Hbittersweet;
            break;
        }
        case 3: {
            retColor = Hsunflower;
            break;
        }
        case 4: {
            retColor = Hgrass;
            break;
        }
    }
    return retColor;
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
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.hotacool"];
    [shared setObject:dic forKey:@"TWUserDic"];
    [shared synchronize];
}

+ (id)readJsonName:(NSString*)name {
    NSError*error;
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //格式化成json数据
    id jsonDic = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&error];
    return jsonDic;
}
@end
