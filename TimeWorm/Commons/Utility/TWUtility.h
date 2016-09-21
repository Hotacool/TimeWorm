//
//  TWUtility.h
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWUtility : NSObject

+ (CAGradientLayer*)getCAGradientLayerWithFrame:(CGRect)frame colors:(NSArray*)colors locations:(NSArray*)locs startPoint:(CGPoint)sP endPoint:(CGPoint)ep ;

+ (NSString*)transformTags2String:(NSArray<NSString*>*)tags ;
+ (NSArray<NSString*>*)transformString2Tags:(NSString*)str ;
@end
