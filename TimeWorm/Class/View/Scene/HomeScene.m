//
//  HomeScene.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeScene.h"
#import "HeroSprite.h"
#import "HomeSceneModel.h"

@interface HomeScene ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) HomeSceneModel *hsm;
@end

@implementation HomeScene {
    HeroSprite *hero;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _hsm = (HomeSceneModel*)self.viewModel;
        [_hsm addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [_hsm addObserver:self forKeyPath:@"shiftDirection" options:NSKeyValueObservingOptionNew context:nil];
        //attatch command
        [_hsm attatchCommand:YES];
        
        hero = [[HeroSprite alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(frame.size.width/2, frame.size.height/2 - 50)];
        //add tap gesture
        [self addGestureRecognizer:self.tapGesture];
        //渐变背景
        [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                                   colors:@[(__bridge id)WPink.CGColor, (__bridge id)WPurple.CGColor]
                                                                locations:@[@(0.5f), @(1.0f)]
                                                               startPoint:CGPointMake(0.5, 0)
                                                                 endPoint:CGPointMake(0.5, 1)]
                           atIndex:0];
        
    }
    return self;
}

- (void)show {
    [self addSprite:hero];
    //启动timer
    [self timerFire:nil];
}

- (void)removeFromSuperview {
    [hero removeFromScene];
    [super removeFromSuperview];
}

- (void)dealloc {
    if (self.hsm) {
        [self.hsm attatchCommand:NO];
    }
}

- (void)addSprite:(TWBaseSprite *)sprite {
    [super addSprite:sprite];
    [self.contentLayer addSublayer:hero.contentLayer];
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    }
    return _tapGesture;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer*)tapGesture {
    DDLogInfo(@"%s", __func__);
    if (self.hsm.state==HomeSceneModelStateNone) {
        self.hsm.state = HomeSceneModelStateWaiting;
    } else {
        self.hsm.state = HomeSceneModelStateNone;
    }
}

- (void)timerFire:(NSTimer*)timer {
    [self setTimerPause];
    [hero doRandomActionWithLoopCount:5];
    _timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)setTimerPause {
    if (_timer&&_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.hsm.state) {
            case HomeSceneModelStateNone: {
                [self timerFire:nil];
                break;
            }
            case HomeSceneModelStateWaiting: {
                [self setTimerPause];
                [hero performAction:@"surprise" withLoopCount:2 end:nil];
                break;
            }
        }
    } else if ([keyPath isEqualToString:@"shiftDirection"]) {
        [self shiftHeroWithDirection:self.hsm.shiftDirection];
    }
}

#pragma mark -- API
- (void)shiftHeroWithDirection:(NSUInteger)direction {
    DDLogInfo(@"%s, %lu",__func__, (unsigned long)direction);
    CGPoint point = hero.position;
    switch (direction) {
//        case 1: {
//            point.y -= 100;
//            [hero setPosition:point];
//            break;
//        }
//        case 2: {
//            point.y += 100;
//            [hero setPosition:point];
//            break;
//        }
        case 3: {
            point.x -= 100;
            [hero setPosition:point];
            break;
        }
        case 4: {
            point.x += 100;
            [hero setPosition:point];
            break;
        }
        default:
            break;
    }
    
}
@end
