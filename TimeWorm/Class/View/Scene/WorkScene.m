//
//  WorkScene.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "WorkScene.h"
#import "HeroSprite.h"
#import "WorkSceneModel.h"
#import "HACClockTimer.h"

#import "PopupViewController1.h"
#import <STPopup/STPopup.h>
#import <pop/POP.h>

static NSString *const WorkSceneClockAniCenter = @"WorkSceneClockAniCenter";
@interface WorkScene ()
@property (nonatomic, strong) WorkSceneModel *wsm;
@property (nonatomic, strong) HACClockTimer *clock;
@end

@implementation WorkScene {
    HeroSprite *hero;
    HACClockDate *date;
    NSTimer *tickTimer;
}

- (void)dealloc {
    [self.wsm attatchCommand:NO];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _wsm = (WorkSceneModel *)self.viewModel;
        [_wsm attatchCommand:YES];
        [self setUIComponents];
    }
    return self;
}

- (void)show {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSprite:hero];
        [hero doRandomActionWithLoopCount:5];
        [self showClock];
    });
}

- (void)setUIComponents {
    hero = [[HeroSprite alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 50)];
    
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                               colors:@[(__bridge id)WBlue.CGColor, (__bridge id)LBlue.CGColor]
                                                            locations:@[@(0.5f), @(1.0f)]
                                                           startPoint:CGPointMake(0.5, 0)
                                                             endPoint:CGPointMake(0.5, 1)]
                       atIndex:0];
}

- (void)addSprite:(TWBaseSprite *)sprite {
    [super addSprite:sprite];
    [self.contentLayer addSublayer:hero.contentLayer];
}

- (void)showClock {
    if (![self.clock superview]) {
        [self addSubview:self.clock];
    }
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, -self.clock.frame.size.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.clock.frame.size.height/2+APPCONFIG_UI_STATUSBAR_HEIGHT)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.clock pop_addAnimation:ani forKey:WorkSceneClockAniCenter];
}

- (HACClockTimer *)clock {
    if (!_clock) {
        _clock = [[HACClockTimer alloc]initWithFrame:CGRectMake(0, -200, self.frame.size.width-50, 130)];
        _clock.faceColor = [UIColor colorWithRed:243.0/255.0 green:152.0/255.0 blue:0 alpha:1.0];
        _clock.sideColor = [UIColor colorWithRed:170.0/255.0 green:105.0/255.0 blue:0 alpha:1.0];
        _clock.radius = 6.0;
        _clock.margin = 7.0;
        _clock.depth = 6.0;
        [_clock addTarget:self action:@selector(clockClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_clock setCLockDefaultDate:[[HACClockDate alloc] initWithHour:0 minute:0 second:0 weekday:1]];
        [self startTickTimer];
    }
    return _clock;
}

- (void)startTickTimer {
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(tick)
                                               userInfo:nil
                                                repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:tickTimer forMode:NSRunLoopCommonModes];
}


- (void)tick {
    if (!date) {
        date = [[HACClockDate alloc] initWithHour:0 minute:1 second:55 weekday:1];
    }
    [date reduce];
    [self.clock setClockDate:date];
}

- (void)clockClicked:(id)sender {
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[PopupViewController1 new]];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.transitionStyle = STPopupTransitionStyleFade;
    [popupController presentInViewController:self.ctrl];
}
//clean
- (void)removeFromSuperview {
    [hero stopCurrentAction];
    [hero removeFromScene];
    [self.clock removeFromSuperview];
    [super removeFromSuperview];
}
@end
