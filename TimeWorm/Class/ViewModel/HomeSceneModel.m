//
//  HomeSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/1.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeSceneModel.h"
#import "TWConstants.h"

@implementation HomeSceneModel {
    NSTimer *timer;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray *)messageList {
    if (!_messageList) {
        id msg = [TWConstants getMessageList];
        if ([msg isKindOfClass:[NSArray class]]) {
            _messageList = msg;
        } else if ([msg isKindOfClass:[NSDictionary class]]) {
            _messageList = [((NSDictionary*)msg) allValues];
        }
    }
    return _messageList;
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
@end
