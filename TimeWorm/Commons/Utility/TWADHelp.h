//
//  TWADHelp.h
//  TimeWorm
//
//  Created by macbook on 16/12/12.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWADHelp : NSObject

+ (UIView*)createBannerViewWithAdSize:(CGSize)size ViewController:(UIViewController*)ctrl ;

+ (NSObject*)createInterstitialAndShowInViewController:(UIViewController*)ctrl ;
@end
