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

- (void)setUIComponents {
    hero = [[HeroSprite alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 50)];
    [self addSprite:hero];
    [hero doRandomActionWithLoopCount:5];
    
    [self addSubview:self.clock];
}

- (void)addSprite:(TWBaseSprite *)sprite {
    [super addSprite:sprite];
    [self.contentLayer addSublayer:hero.contentLayer];
}

- (HACClockTimer *)clock {
    if (!_clock) {
        _clock = [[HACClockTimer alloc]initWithFrame:CGRectMake(25, APPCONFIG_UI_STATUSBAR_HEIGHT, self.frame.size.width-50, 130)];
        _clock.backgroundColor=[UIColor orangeColor];
        _clock.layer.cornerRadius=10;
        
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
@end
