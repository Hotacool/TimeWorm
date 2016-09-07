//
//  HACClockTimer.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACClockTimer.h"
#import <DateTools.h>

@implementation HACClockDate
- (instancetype)initWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second weekday:(NSUInteger)weekday{
    if (self = [super init]) {
        _hour = hour;
        _minute = minute;
        _second = second;
        _weekday = weekday;
    }
    return self;
}

- (void)updateWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second weekday:(NSUInteger)weekday {
    self.hour = hour;
    self.minute = minute;
    self.second = second;
    self.weekday = weekday;
}

- (void)reduce {
    int r = (int)self.second - 1;
    if (r<0) {
        if (self.minute == 0) {
            self.second = 0;
        } else {
            self.second = 59;
            r = (int)self.minute - 1;
            if (r<0) {
                if (self.hour == 0) {
                    self.minute = 0;
                } else {
                    self.minute = 59;
                    r = (int)self.hour - 1;
                    if (r<0) {
                        self.hour = 0;
                    } else {
                        self.hour -= 1;
                    }
                }
            } else {
                self.minute -= 1;
            }
        }
    } else {
        self.second -= 1;
    }
}

- (NSUInteger)remainderSeconds {
    NSUInteger seconds;
    seconds = self.hour*3600+self.minute*60+self.second;
    return seconds;
}

@end

@interface HACClockTimer ()
@property (nonatomic, strong)NSArray *digitViews;
@property (nonatomic, strong)NSArray *colonViews;
@property (nonatomic, strong)NSArray *weekArray;
@end

@implementation HACClockTimer

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initDigitView];
        [self initColonView];
    }
    return self;
}
- (void)initDigitView {
    UIImage *digits = [UIImage imageNamed:@"Digits"];
    for (UIView *view in self.digitViews) {
        [view.layer setContents:(__bridge id)digits.CGImage];
        [view.layer setContentsRect:CGRectMake(0, 0, 1.0f/11.0f, 1.0)];
        [view.layer setContentsGravity:kCAGravityResizeAspect];
        [view.layer setMagnificationFilter:kCAFilterNearest];
        view.userInteractionEnabled = NO;
    }
}

/**
 *  initial ColonView
 */
- (void)initColonView {
    UIImage *digits = [UIImage imageNamed:@"Digits"];
    for (UIView *view in self.colonViews) {
        [view.layer setContents:(__bridge id)digits.CGImage];
        [view.layer setContentsRect:CGRectMake(10.0f/11.0f, 0, 1.0f/11.0f, 1.0)];
        [view.layer setContentsGravity:kCAGravityResizeAspect];
        [view.layer setMagnificationFilter:kCAFilterNearest];
        view.userInteractionEnabled = NO;
    }
}

- (NSArray *)digitViews {
    if (!_digitViews) {
        CGFloat margx=1;
        NSUInteger count = 5;
        CGFloat startX = 20;
        CGFloat width=(self.frame.size.width-startX*2-(count-1)*margx)/count;
        CGFloat centerY=(self.frame.size.height-width)/2.0;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(startX, centerY, width, width)];
        view1.backgroundColor=[UIColor clearColor];
        [self addSubview:view1];
        
        CGFloat view2X=CGRectGetMaxX(view1.frame)+margx;
        UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(view2X, centerY, width, width)];
        view2.backgroundColor=[UIColor clearColor];
        [self addSubview:view2];
        
        CGFloat view3X=CGRectGetMaxX(view2.frame)+margx;
        UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(view3X, centerY, width, width)];
        view3.backgroundColor=[UIColor clearColor];
        [self addSubview:view3];
        
        CGFloat view4X=CGRectGetMaxX(view3.frame)+margx;
        UIView *view4=[[UIView alloc]initWithFrame:CGRectMake(view4X, centerY, width, width)];
        view4.backgroundColor=[UIColor clearColor];
        [self addSubview:view4];
        
        CGFloat view5X=CGRectGetMaxX(view4.frame)+margx;
        UIView *view5=[[UIView alloc]initWithFrame:CGRectMake(view5X, centerY, width, width)];
        view5.backgroundColor=[UIColor clearColor];
        [self addSubview:view5];
        
        /**
         *  weekLabel init
         */
        NSUInteger labelCount = 3;
        CGFloat labelW=50.f;
        CGFloat labelH=centerY/2.0f;
        CGFloat labelY=(centerY-labelH)/2.0f;
        
        CGFloat originX = self.frame.size.width - labelW*labelCount - 5;
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelW, labelH)];
        label1.text=NSLocalizedString(@"cstart", @"");
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label1];
        
        CGFloat label2X=CGRectGetMaxX(label1.frame);
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(label2X, labelY, labelW, labelH)];
        label2.text=NSLocalizedString(@"cpause", @"");
        label2.textColor=[UIColor whiteColor];
        label2.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label2];
        
        CGFloat label3X=CGRectGetMaxX(label2.frame);
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(label3X, labelY, labelW, labelH)];
        label3.text=NSLocalizedString(@"cstop", @"");
        label3.textColor=[UIColor whiteColor];
        label3.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label3];
        
        _weekArray=@[label1,label2,label3];
        _digitViews=@[view1,view2,view4,view5];
        _colonViews=@[view3];
    }
    return _digitViews;
}

- (void)setWeekday:(NSInteger)weekday {
    if (weekday<1) {
        return;
    }
    for (UILabel *weekdayLabel in self.weekArray) {
        if (self.weekArray[weekday-1] == weekdayLabel) {
            [self.weekArray[weekday-1] setAlpha:1.0f];
        } else {
            [weekdayLabel setAlpha:0.2f];
        }
    }
}

- (void)setColon {
    for (UIView *view in self.colonViews) {
        CGFloat alpha = [view alpha];
        if (alpha == 0.0f) {
            alpha = 1.0f;
        } else {
            alpha = 0.0f;
        }
        [view setAlpha:alpha];
    }
}
- (void)setDigit:(NSInteger)digit forView:(UIView *)view {
    [view.layer setContentsRect:CGRectMake(digit * 1.0f / 11.0f, 0, 1.0f/11.0f, 1.0f)];
}

#pragma mark -- API
- (void)setClockDate:(HACClockDate*)date {
    [UIView animateWithDuration:1.0 animations:^{
        [self setDigit:date.minute / 10 forView:self.digitViews[0]];
        [self setDigit:date.minute % 10 forView:self.digitViews[1]];
        [self setDigit:date.second / 10 forView:self.digitViews[2]];
        [self setDigit:date.second % 10 forView:self.digitViews[3]];
        [self setWeekday:date.weekday];
        [self setColon];
    }];
}

- (void)setCLockDefaultDate:(HACClockDate*)date {
    [self setClockDate:date];
    [self.colonViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 1;
    }];
}
@end
