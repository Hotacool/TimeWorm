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
#import "TWSet.h"
#import "TWPaopaoVew.h"

@interface HomeScene ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) HomeSceneModel *hsm;
@property (nonatomic, strong) TWPaopaoVew *paopao;
@end

@implementation HomeScene {
    HeroSprite *hero;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _hsm = (HomeSceneModel*)self.viewModel;
        [_hsm addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        //attatch command
        [_hsm attatchCommand:YES];
        
        self.paopao.center = CGPointMake(self.width/2, self.paopao.height/2+65);
        
        hero = [[HeroSprite alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(frame.size.width/2, frame.size.height/2)];
        //add tap gesture
        [self addGestureRecognizer:self.tapGesture];
        //渐变背景
        [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                                  skinSet:[TWSet currentSet].homeTheme]
                           atIndex:0];
        
    }
    return self;
}

- (void)show {
    [self addSprite:hero];
    [self addSubview:self.paopao];
    //启动timer
    [self timerFire:nil];
}

- (void)removeFromSuperview {
    [MozTopAlertView hideFromWindow];
    [super removeFromSuperview];
}

- (void)dealloc {
    if (self.hsm) {
        [self.hsm attatchCommand:NO];
        [self.hsm removeObserver:self forKeyPath:@"state"];
    }
}

- (void)addSprite:(TWBaseSprite *)sprite {
    [super addSprite:sprite];
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
    [self showMessage];
    _timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)setTimerPause {
    if (_timer&&_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)showMessage {
    if (_hsm.messageList) {
        int count = (int)_hsm.messageList.count;
        int random = (int)(0 + (arc4random() % (count*2-0)));
        if (random > count-1) {
            self.paopao.hidden = YES;
        } else {
            NSString *showMsg = _hsm.messageList[random];
            if (!HACObjectIsEmpty(showMsg)) {
                self.paopao.hidden = NO;
                self.paopao.text = showMsg;
            }
        }
    }
}

- (TWPaopaoVew *)paopao {
    if (!_paopao) {
        _paopao = [[TWPaopaoVew alloc] initWithFrame:CGRectMake(0, 0, self.width-20, 150)];
    }
    return _paopao;
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
    }
}
@end
