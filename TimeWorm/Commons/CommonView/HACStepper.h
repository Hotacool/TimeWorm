//
//  HACStepper.h
//  TimeWorm
//
//  Created by macbook on 16/11/25.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HACStepper : UIView

@property(nonatomic,getter=isContinuous) BOOL continuous; // if YES, value change events are sent any time the value changes during interaction. default = YES
@property(nonatomic) BOOL autorepeat;                     // if YES, press & hold repeatedly alters value. default = YES
@property(nonatomic) BOOL wraps;                          // if YES, value wraps from min <-> max. default = NO

@property(nonatomic) double value;                        // default is 0. sends UIControlEventValueChanged. clamped to min/max
@property(nonatomic) double minimumValue;                 // default 0. must be less than maximumValue
@property(nonatomic) double maximumValue;                 // default 100. must be greater than minimumValue
@property(nonatomic) double stepValue;                    // default 1. must be greater than 0
@property(nonatomic) CGFloat cornerRadious;
@property(nonatomic, copy) NSString *formart;

#pragma mark - Stepper Configration methods
- (void)setStepperColor:(UIColor *)color withDisableColor:(UIColor *)disColor;
- (void)setTextLabelFont:(UIFont *)font;
- (void)setTextColor:(UIColor *)color;
- (void)setStepperRange:(int)minValue andMaxValue:(int)maxValue;
- (void)addTarget:(id)target action:(nonnull SEL)action;
@end
