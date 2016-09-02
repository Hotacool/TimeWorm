//
//  CCDateView.m
//  testTime
//
//  Created by admin on 16/1/16.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "CCDateView.h"
#import <DateTools.h>

@interface CCDateView ()

@property (nonatomic, strong)NSArray *digitViews;
@property (nonatomic, strong)NSArray *colonViews;
@property (nonatomic, strong)NSArray *weekArray;




@end

@implementation CCDateView{
      NSTimer *tickTimer;
}


- (NSArray *)digitViews{
    
    if (_digitViews==nil) {
        
        CGFloat margx=5;
        CGFloat width=(self.frame.size.width-7*margx)/8.0;
        CGFloat centerY=(self.frame.size.height-width)/2.0;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, centerY, width, width)];
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
        
        CGFloat view6X=CGRectGetMaxX(view5.frame)+margx;
        UIView *view6=[[UIView alloc]initWithFrame:CGRectMake(view6X, centerY, width, width)];
        view6.backgroundColor=[UIColor clearColor];
        [self addSubview:view6];
        
        CGFloat view7X=CGRectGetMaxX(view6.frame)+margx;
        UIView *view7=[[UIView alloc]initWithFrame:CGRectMake(view7X, centerY, width, width)];
        view7.backgroundColor=[UIColor clearColor];
        [self addSubview:view7];
        
        CGFloat view8X=CGRectGetMaxX(view7.frame)+margx;
        UIView *view8=[[UIView alloc]initWithFrame:CGRectMake(view8X, centerY, width, width)];
        view8.backgroundColor=[UIColor clearColor];
        [self addSubview:view8];
        
        
        /**
         *  weekLabel init
         */
        
        CGFloat labelW=self.frame.size.width/7.0f;
        
        CGFloat labelH=centerY/2.0f;
        
        CGFloat labelY=(centerY-labelH)/2.0f;
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, labelY, labelW, labelH)];
        label1.text=@"SUN";
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label1];
        
        CGFloat label2X=CGRectGetMaxX(label1.frame);
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(label2X, labelY, labelW, labelH)];
        label2.text=@"MON";
        label2.textColor=[UIColor whiteColor];
        label2.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label2];
        
        CGFloat label3X=CGRectGetMaxX(label2.frame);
        UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(label3X, labelY, labelW, labelH)];
        label3.text=@"TUE";
        label3.textColor=[UIColor whiteColor];
        label3.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label3];
        
        CGFloat label4X=CGRectGetMaxX(label3.frame);
        UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(label4X, labelY, labelW, labelH)];
        label4.text=@"WED";
        label4.textColor=[UIColor whiteColor];
        label4.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label4];
        
        CGFloat label5X=CGRectGetMaxX(label4.frame);
        UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(label5X, labelY, labelW, labelH)];
        label5.text=@"THU";
        label5.textColor=[UIColor whiteColor];
        label5.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label5];
        
        CGFloat label6X=CGRectGetMaxX(label5.frame);
        UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(label6X, labelY, labelW, labelH)];
        label6.text=@"FRI";
        label6.textColor=[UIColor whiteColor];
        label6.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label6];
        
        CGFloat label7X=CGRectGetMaxX(label6.frame);
        UILabel *label7=[[UILabel alloc]initWithFrame:CGRectMake(label7X, labelY, labelW, labelH)];
        label7.text=@"SAT";
        label7.textColor=[UIColor whiteColor];
        label7.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label7];
        
        _weekArray=@[label1,label2,label3,label4,label5,label6,label7];
        _digitViews=@[view1,view2,view4,view5,view7,view8];
        _colonViews=@[view3,view6];
        
        
    }
    return _digitViews;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self initDigitView];
        [self initColonView];
        [self onTickTimer];
    }
    return self;
}
- (void)initDigitView
{
    UIImage *digits = [UIImage imageNamed:@"Digits"];
    for (UIView *view in self.digitViews) {
        [view.layer setContents:(__bridge id)digits.CGImage];
        [view.layer setContentsRect:CGRectMake(0, 0, 1.0f/11.0f, 1.0)];
        [view.layer setContentsGravity:kCAGravityResizeAspect];
        [view.layer setMagnificationFilter:kCAFilterNearest];
    }
}

/**
 *  initial ColonView
 */
- (void)initColonView
{
    UIImage *digits = [UIImage imageNamed:@"Digits"];
    for (UIView *view in self.colonViews) {
        [view.layer setContents:(__bridge id)digits.CGImage];
        [view.layer setContentsRect:CGRectMake(10.0f/11.0f, 0, 1.0f/11.0f, 1.0)];
        [view.layer setContentsGravity:kCAGravityResizeAspect];
        [view.layer setMagnificationFilter:kCAFilterNearest];
    }
}
- (void)onTickTimer
{
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(tick)
                                               userInfo:nil
                                                repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:tickTimer forMode:NSRunLoopCommonModes];
}


- (void)tick
{
    NSDate *date = [NSDate date];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        [self setDigit:date.hour / 10 forView:self.digitViews[0]];
        [self setDigit:date.hour % 10 forView:self.digitViews[1]];
        [self setDigit:date.minute / 10 forView:self.digitViews[2]];
        [self setDigit:date.minute % 10 forView:self.digitViews[3]];
        [self setDigit:date.second / 10 forView:self.digitViews[4]];
        [self setDigit:date.second % 10 forView:self.digitViews[5]];
        [self setWeekday:date.weekday];
        [self setColon];
    }];
}
- (void)setWeekday:(NSInteger)weekday
{
    for (UILabel *weekdayLabel in self.weekArray) {
        if (self.weekArray[weekday-1] == weekdayLabel) {
            [self.weekArray[weekday-1] setAlpha:1.0f];
        } else {
            [weekdayLabel setAlpha:0.2f];
        }
    }
}

- (void)setColon
{
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
- (void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    [view.layer setContentsRect:CGRectMake(digit * 1.0f / 11.0f, 0, 1.0f/11.0f, 1.0f)];
}





@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com