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
@end
