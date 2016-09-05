//
//  UIView+STAnimation.h
//  STClockDemo
//
//  Created by zhenlintie on 15/7/30.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>

#define STSafeBlock(block,...)  \
if (block){\
block(__VA_ARGS__);\
}

#define STCLOCK_BG_COLOR STRGB(253, 253, 253)
#define STCLOCK_TEXT_COLOR STRGB(137, 140, 149)

#define STCLOCK_ALPHA_ANIMATION_DURATION 0.35
typedef NS_ENUM(NSUInteger, STTimingFunctionType) {
    STLinear,
    STEaseIn,
    STEaseOut,
    STEaseInOut,
    
    STCustomEaseOut
};

@protocol STClockAnimation <NSObject>

@optional
- (void)animatePropertyName:(NSString *)propName
                  fromValue:(id)fromValue
                    toValue:(id)toValue
                   duration:(CGFloat)duration
             timingFumction:(STTimingFunctionType)functionType
                 completion:(void(^)(BOOL finished))completion;

- (void)alphaTo:(CGFloat)alpha duration:(CGFloat)duration completion:(void(^)(BOOL finished))completion;
- (void)positionTo:(CGPoint)position duration:(CGFloat)duration timingFumction:(STTimingFunctionType)functionType completion:(void(^)(BOOL finished))completion;
- (void)rotateFrom:(CGFloat)fromAngle to:(CGFloat)toAngle  duration:(CGFloat)duration timingFumction:(STTimingFunctionType)functionType completion:(void(^)(BOOL finished))completion;

@end

@interface UIView (STAnimation) <STClockAnimation>

@end

@interface NSArray (STAnimation) <STClockAnimation>

@end