//
//  TWUtility.h
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TWUtility : NSObject

+ (void)jump2Tips ;
#pragma mark - skin
+ (CAGradientLayer*)getCAGradientLayerWithFrame:(CGRect)frame skinSet:(int)set ;

+ (CAGradientLayer*)getCAGradientLayerWithFrame:(CGRect)frame colors:(NSArray*)colors locations:(NSArray*)locs startPoint:(CGPoint)sP endPoint:(CGPoint)ep ;

+ (UIImage *)gradientImageWithBounds:(CGRect)bounds colors:(NSArray *)colors ;

+ (UIColor*)getColorBySkinSet:(int)set ;
#pragma mark - string format
+ (NSString*)transformTags2String:(NSArray<NSString*>*)tags ;
+ (NSArray<NSString*>*)transformString2Tags:(NSString*)str ;
#pragma mark - user defaults
+ (void)shareAppgroupData:(NSDictionary*)dic ;
#pragma mark - local file
+ (id)readJsonName:(NSString*)name ;
@end
