//
//  HomeSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/1.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeSceneModel.h"

@implementation HomeSceneModel {
    NSTimer *timer;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setState:(HomeSceneModelState)state {
    _state = state;
    if (state == HomeSceneModelStateWaiting) {
        [self addTimer];
    } else if (state == HomeSceneModelStateNone) {
        [self removeTimer];
    }
}

- (void)addTimer {
    [self removeTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
}

- (void)removeTimer {
    if (timer&&timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerFire:(NSTimer*)timer {
    if (self.state == HomeSceneModelStateWaiting) {
        [self setValue:@(HomeSceneModelStateNone) forKey:@"state"];
    }
}

#pragma mark -- command action
- (void)response2upShift {
    DDLogInfo(@"%s", __func__);
    self.shiftDirection = 1;
}

- (void)response2downShift {
    DDLogInfo(@"%s", __func__);
    self.shiftDirection = 2;
}

- (void)response2leftShift {
    DDLogInfo(@"%s", __func__);
    self.shiftDirection = 3;
}

- (void)response2rightShift {
    DDLogInfo(@"%s", __func__);
    self.shiftDirection = 4;
}
@end
