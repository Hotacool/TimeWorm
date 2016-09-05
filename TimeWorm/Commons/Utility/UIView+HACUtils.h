//
//  UIView+HACUtils.h
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取屏幕尺寸
//extern CGRect  screenBounds();
//extern CGSize  screenSize();
//extern CGFloat screenWidth();
//extern CGFloat screenHeight();

@interface UIView (HACUtils)
@property (nonatomic) CGFloat left;// x
@property (nonatomic) CGFloat top;// y
@property (nonatomic) CGFloat right;// x+width
@property (nonatomic) CGFloat bottom;// y+height
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, readonly) CGFloat inScreenViewX;
@property (nonatomic, readonly) CGFloat inScreenViewY;
@property (nonatomic, readonly) CGRect inScreenFrame;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@end
