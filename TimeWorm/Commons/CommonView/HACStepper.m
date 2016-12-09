//
//  HACStepper.m
//  TimeWorm
//
//  Created by macbook on 16/11/25.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACStepper.h"
#define HACStepperBorderWidth 1.0f
#define HACStepperCornerRadious 3.0
#define HACStepperBtnSize CGSizeMake(35.0, 30.0)

@implementation HACStepper {
    UIColor *stepperColor, *stepperDisableColor;
    
    UIButton *minBtn;
    UIButton *maxBtn;
    UILabel *textLabel;
    
    id target;
    SEL action;
    
    //长按
    float repeatRate;
    float repeatDelaySec;
    NSTimer *repeatTimer;
    BOOL changflg;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Set Initial value
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _minimumValue = 0;
        _maximumValue = 10;
        _value = 0;
        _stepValue = 1;
        _wraps = NO;
        _cornerRadious = HACStepperCornerRadious;
        stepperColor = [UIColor blueColor];
        stepperDisableColor = [UIColor lightGrayColor];
        repeatRate = 15.0;
        repeatDelaySec = .8f;
        _formart = @"%.0f";
        
        // Create Buttons to change values
        // Create Decrease value button on left side
        minBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [minBtn setBackgroundImage:[self getHighlitedImageWithColor:stepperColor] forState:UIControlStateHighlighted];
        [minBtn setTitle:@"-" forState:UIControlStateNormal];
        [minBtn setFrame:CGRectMake(0.0, 0.0, HACStepperBtnSize.width, frame.size.height)];
        [minBtn setContentEdgeInsets:UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
        [minBtn setTitleColor:stepperColor forState:UIControlStateNormal];
        [minBtn setTitleColor:stepperDisableColor forState:UIControlStateDisabled];
        [minBtn setEnabled:NO]; // Set it disable because minRange==defaultValue (both are=0)
        [minBtn addTarget:self action:@selector(minBtnTouchDown) forControlEvents:UIControlEventTouchDown];
        [minBtn addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [minBtn addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:minBtn];
        
        // Create Increase value button on right side
        maxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [maxBtn setBackgroundImage:[self getHighlitedImageWithColor:stepperColor] forState:UIControlStateHighlighted];
        [maxBtn setTitle:@"+" forState:UIControlStateNormal];
        [maxBtn setFrame:CGRectMake(frame.size.width-HACStepperBtnSize.width, 0.0, HACStepperBtnSize.width, frame.size.height)];
        [maxBtn setContentEdgeInsets:UIEdgeInsetsMake(-2.0, 0.0, 0.0, 0.0)];
        [maxBtn setTitleColor:stepperColor forState:UIControlStateNormal];
        [maxBtn setTitleColor:stepperDisableColor forState:UIControlStateDisabled];
        [maxBtn addTarget:self action:@selector(maxBtnTouchDown) forControlEvents:UIControlEventTouchDown];
        [maxBtn addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [maxBtn addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:maxBtn];
        
        // Setup TextLabel to show value
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(HACStepperBtnSize.width, 0.0, frame.size.width-HACStepperBtnSize.width*2.0, frame.size.height)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]]; //HelveticaNeue-Thin
        [textLabel setText:[NSString stringWithFormat:_formart, _value]];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Draw border of stepper view
    self.layer.borderColor = stepperColor.CGColor;
    self.layer.borderWidth = HACStepperBorderWidth;
    self.layer.cornerRadius = self.cornerRadious;
    
    // Draw seperator lines to seperate buttons and text
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [stepperColor CGColor]);
    CGContextSetLineWidth(context, HACStepperBorderWidth);
    
    // Draw first line
    CGContextMoveToPoint(context, HACStepperBtnSize.width, 0.0);
    CGContextAddLineToPoint(context, HACStepperBtnSize.width, self.frame.size.height);
    
    // Draw second line
    CGContextMoveToPoint(context, self.frame.size.width-HACStepperBtnSize.width, 0.0);
    CGContextAddLineToPoint(context, self.frame.size.width-HACStepperBtnSize.width, self.frame.size.height);
    CGContextDrawPath(context, kCGPathStroke);
    
}

#pragma mark - Private methods

- (UIImage *)getHighlitedImageWithColor:(UIColor *)color{
    return [self imageWithColor:[self getLightColor:color]];
}

- (UIColor *)getLightColor:(UIColor *)color{
    
    const CGFloat* colors = CGColorGetComponents( color.CGColor );
    UIColor *newColor = [UIColor colorWithRed:colors[0] green:colors[1] blue:colors[2] alpha:0.2];
    return newColor;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Vaue change handlers
- (void)minBtnTouchDown {
    // Start the timer?
    if(self.autorepeat && repeatRate > 0.0f && repeatDelaySec > 0.0f ) {
        changflg = NO;
        repeatTimer = [NSTimer scheduledTimerWithTimeInterval:repeatDelaySec
                                                        target:self
                                                      selector:@selector(repeatDelayTimerFired:)
                                                      userInfo:nil
                                                       repeats:NO];
    }
}

- (void)maxBtnTouchDown {
    // Start the timer?
    if(self.autorepeat && repeatRate > 0.0f && repeatDelaySec > 0.0f ) {
        changflg = YES;
        repeatTimer = [NSTimer scheduledTimerWithTimeInterval:repeatDelaySec
                                                       target:self
                                                     selector:@selector(repeatDelayTimerFired:)
                                                     userInfo:nil
                                                      repeats:NO];
    }
}

- (void)btnTouchUp {
    // Kill the timer
    [repeatTimer invalidate];
    repeatTimer = nil;
    //default 1
    [self autoRepeatTimerFired:nil];
    
    if (!self.continuous) {
        if ([target respondsToSelector:action]) {
            [target performSelector:action];
        }
    }
}

- (void) repeatDelayTimerFired:(NSTimer *)a_timer {
    // Kill the delay timer and start repeat timer
    [repeatTimer invalidate];
    repeatTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0f/repeatRate)
                                                    target:self
                                                  selector:@selector(autoRepeatTimerFired:)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void) autoRepeatTimerFired:(NSTimer *) a_timer {
    if (changflg) {
        [self increaseValue:nil];
    } else {
        [self decreaseValue:nil];
    }
    if (self.continuous) {
        if ([target respondsToSelector:action]) {
            [target performSelector:action];
        }
    }
}

- (void)decreaseValue:(id)sender{
    _value -= self.stepValue;
    if (_value<self.minimumValue) {
        if (self.wraps) {
            _value = self.maximumValue;
        } else {
            _value = self.minimumValue;
            [minBtn setEnabled:NO];
        }
    }
    [maxBtn setEnabled:YES];
    
    [textLabel setText:[NSString stringWithFormat:_formart, _value]];
}

- (void)increaseValue:(id)sender{
    _value += self.stepValue;
    if (_value>self.maximumValue) {
        if (self.wraps) {
            _value = self.minimumValue;
        } else {
            _value = self.maximumValue;
            [maxBtn setEnabled:NO];
        }
    }
    [minBtn setEnabled:YES];
    
    [textLabel setText:[NSString stringWithFormat:_formart, _value]];
}

#pragma mark - Stepper Configration methods
- (void)setStepperColor:(UIColor *)color withDisableColor:(UIColor *)disColor{
    stepperColor = (color) ? color : stepperColor;
    stepperDisableColor = (disColor) ? disColor : stepperDisableColor;
    
    [minBtn setTitleColor:stepperColor forState:UIControlStateNormal];
    [maxBtn setTitleColor:stepperColor forState:UIControlStateNormal];
    
    [minBtn setTitleColor:stepperDisableColor forState:UIControlStateDisabled];
    [maxBtn setTitleColor:stepperDisableColor forState:UIControlStateDisabled];
    
    [minBtn setBackgroundImage:[self getHighlitedImageWithColor:stepperColor] forState:UIControlStateHighlighted];
    [maxBtn setBackgroundImage:[self getHighlitedImageWithColor:stepperColor] forState:UIControlStateHighlighted];
}

- (void)setTextLabelFont:(UIFont *)font{
    if (font) [textLabel setFont:font];
}

- (void)setTextColor:(UIColor *)color{
    if (color) [textLabel setTextColor:color];
}

- (void)setStepperRange:(int)minValue andMaxValue:(int)maxValue{
    if (minValue>=maxValue){
        return;
    }
    else{
        self.minimumValue = minValue;
        self.maximumValue = maxValue;
        
        if (_value<self.minimumValue || _value>self.maximumValue) {
            _value = self.minimumValue;
            [textLabel setText:[NSString stringWithFormat:_formart, _value]];
        }
    }
}

- (void)setValue:(double)defValue {
    if (defValue<self.minimumValue || defValue>self.maximumValue) {
        return;
    }
    else{
        _value = defValue;
        [textLabel setText:[NSString stringWithFormat:_formart, _value]];
        
        if (_value<=self.minimumValue){
            if (!self.wraps) {
                [minBtn setEnabled:NO];
            }
            [maxBtn setEnabled:YES];
        }
        else if (_value>=self.maximumValue){
            if (!self.wraps) {
                [maxBtn setEnabled:NO];
            }
            [minBtn setEnabled:YES];
        }
        else{
            [minBtn setEnabled:YES];
            [maxBtn setEnabled:YES];
        }
    }
}

- (void)addTarget:(id)target_ action:(SEL)action_ {
    target = target_;
    action = action_;
}
@end
