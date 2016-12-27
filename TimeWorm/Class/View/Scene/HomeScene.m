//
//  HomeScene.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeScene.h"
#import "HomeSceneModel.h"
#import "TWSet.h"
#import "TWPaopaoVew.h"
#import "FirstMan.h"
#import "Mao.h"

@interface HomeScene () <TWBaseSpriteDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) HomeSceneModel *hsm;
@property (nonatomic, strong) TWPaopaoVew *paopao;
@end

@implementation HomeScene {
    FirstMan *apothegm;
    Mao *mao;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        _hsm = (HomeSceneModel*)self.viewModel;
        [_hsm addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        //attatch command
        [_hsm attatchCommand:YES];
        
        self.paopao.center = CGPointMake(self.width/2, self.paopao.height/2+65);
        [self addSubview:self.paopao];
        
        apothegm = [[FirstMan alloc] initWithSize:CGSizeMake(self.width, self.width) position:CGPointMake(frame.size.width/2, frame.size.height/2)];
        apothegm.delegate = self;
        mao = [[Mao alloc] initWithSize:CGSizeMake(300, 200) position:CGPointMake(frame.size.width/2, frame.size.height/2)];
        mao.delegate = self;
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
    self.hsm.state = HomeSceneModelStateApothegm;
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
    if (self.hsm.state==HomeSceneModelStateNormal) {
        self.hsm.state = HomeSceneModelStateAction;
    } else if (self.hsm.state == HomeSceneModelStateApothegm) {
        self.hsm.state = HomeSceneModelStateNormal;
    }
}

- (void)showMessage {
    if ([self.hsm createRandomMessageToShow]) {
        self.paopao.text = self.hsm.currentMessage.message;
        self.paopao.hidden = NO;
    } else {
        self.paopao.hidden = YES;
    }
}

- (TWPaopaoVew *)paopao {
    if (!_paopao) {
        _paopao = [[TWPaopaoVew alloc] initWithFrame:CGRectMake(0, 0, self.width-20, 150)];
        _paopao.hidden = YES;
        UITapGestureRecognizer *tapPao = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPaopao:)];
        [_paopao addGestureRecognizer:tapPao];
    }
    return _paopao;
}

- (void)tapPaopao:(id)sender {
    NSString *className = self.hsm.currentMessage.dispatchClassName;
    if (HACObjectIsEmpty(className)) {
        return;
    }
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *tipVC = [[class alloc] init];
        tipVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.ctrl presentViewController:tipVC animated:YES completion:^{
            // pause
        }];
    } else {
        DDLogError(@"no class: %@", className);
    }
}

#pragma mark - sprite delegate
- (void)sprite:(TWBaseSprite *)sprite willDoAction:(NSString *)actionKey {
    DDLogInfo(@"actionKey: %@", actionKey);
}

- (void)sprite:(TWBaseSprite *)sprite willStopAction:(NSString *)actionKey {
    DDLogInfo(@"actionKey: %@", actionKey);
    [self.hsm spriteActionStopped];
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.hsm.state) {
            case HomeSceneModelStateNone: {
                break;
            }
            case HomeSceneModelStateApothegm: {
                [self addSprite:apothegm];
                [apothegm doRandomActionWithLoopCount:1];
                break;
            }
            case HomeSceneModelStateNormal: {
                [self removeSprite:apothegm];
                [self addSprite:mao];
                [mao showDefaultAction];
                [self showMessage];
                break;
            }
            case HomeSceneModelStateAction: {
                [mao doRandomActionWithLoopCount:1];
                [self showMessage];
                break;
            }
        }
    }
}
@end
