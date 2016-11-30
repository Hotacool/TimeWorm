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
#import "TWModelTimer.h"
#import "STPopupController+HAC.h"
#import <pop/POP.h>
#import "HomeViewController.h"
#import "TWEventList.h"

static NSString *const WorkSceneClockAniCenter = @"WorkSceneClockAniCenter";
@interface WorkScene ()
@property (nonatomic, strong) WorkSceneModel *wsm;
@property (nonatomic, strong) HACClockTimer *clock;
@property (nonatomic, strong) UIButton *event;

@end

@implementation WorkScene {
    HeroSprite *hero;
    HACClockDate *date;
}

- (void)dealloc {
    if (self.wsm) {
        [self.wsm attatchCommand:NO];
        [self.wsm removeObserver:self forKeyPath:@"state"];
        [self.wsm removeObserver:self forKeyPath:@"remainderSeconds"];
        [self.wsm removeObserver:self forKeyPath:@"errorCode"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _wsm = (WorkSceneModel *)self.viewModel;
        [_wsm addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [_wsm addObserver:self forKeyPath:@"remainderSeconds" options:NSKeyValueObservingOptionNew context:nil];
        [_wsm addObserver:self forKeyPath:@"errorCode" options:NSKeyValueObservingOptionNew context:nil];
        [_wsm attatchCommand:YES];
        [self setUIComponents];
    }
    return self;
}

- (void)show {
    [self.wsm setState:WorkSceneModelStateNone];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSprite:hero];
        [hero doRandomActionWithLoopCount:5];
        [self showClock];
        //自动启动
        [_wsm startTimer];
    });
}

- (void)setUIComponents {
    hero = [[HeroSprite alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 20)];
    
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                               colors:@[(__bridge id)WBlue.CGColor, (__bridge id)LBlue.CGColor]
                                                            locations:@[@(0.5f), @(1.0f)]
                                                           startPoint:CGPointMake(0.5, 0)
                                                             endPoint:CGPointMake(0.5, 1)]
                       atIndex:0];
    self.event.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 50, 50, 50);
    [self addSubview:self.event];
}

- (void)addSprite:(TWBaseSprite *)sprite {
    [super addSprite:sprite];
}

- (void)showClock {
    if (![self.clock superview]) {
        [self addSubview:self.clock];
    }
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, -self.clock.frame.size.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.clock.frame.size.height/2+APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.clock pop_addAnimation:ani forKey:WorkSceneClockAniCenter];
}

- (HACClockTimer *)clock {
    if (!_clock) {
        _clock = [[HACClockTimer alloc]initWithFrame:CGRectMake(0, -200, self.frame.size.width-50, 130)];
        _clock.faceColor = Hmorange;
        _clock.sideColor = HmorangeD;
        _clock.radius = 6.0;
        _clock.margin = 7.0;
        _clock.depth = 6.0;
        [_clock addTarget:self action:@selector(clockClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_clock setCLockDefaultDate:[[HACClockDate alloc] initWithHour:0 minute:0 second:0 weekday:1]];
    }
    return _clock;
}

- (UIButton *)event {
    if (!_event) {
        _event = [[UIButton alloc] init];
        [_event setImage:[UIImage imageNamed:@"CalenderRound"] forState:UIControlStateNormal];
        [_event addTarget:self action:@selector(gotoEventList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _event;
}

- (void)gotoEventList:(id)sender {
    TWEventList *ret = [TWEventList new];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:ret];
    popupController.containerView.layer.cornerRadius = 4;
    popupController.transitionStyle = STPopupTransitionStyleSlideVertical;
    [popupController presentInViewController:self.ctrl];
    [ret bindTimer:_wsm.currentTimer];
}

- (void)clockClicked:(id)sender {
    [STPopupController popupViewControllerName:@"TWClockSetting" inViewController:self.ctrl];
}
//clean
- (void)removeFromSuperview {
    [_wsm clearData];
    [MozTopAlertView hideFromWindow];
    [super removeFromSuperview];
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.wsm.state) {
            case WorkSceneModelStateNone: {
                break;
            }
            case WorkSceneModelStateWorking: {
                [hero performAction:@"think" withEnd:nil];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"暂停" atIndex:3];
                [self.clock switchInfoLabel2State:1];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeInfo text:NSLocalizedString(@"work start", @"") doText:nil doBlock:nil];
                break;
            }
            case WorkSceneModelStatePause: {
                [hero performAction:@"applaud" withEnd:nil];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"继续" atIndex:3];
                [self.clock switchInfoLabel2State:2];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"pause", @"") doText:nil doBlock:nil];
                break;
            }
            case WorkSceneModelStateEvent: {
                [hero performAction:@"applaud" withEnd:nil];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"继续" atIndex:3];
                [self.clock switchInfoLabel2State:2];
                [STPopupController popupViewControllerName:@"TWEventSetting" inViewController:self.ctrl];
                break;
            }
            case WorkSceneModelStateReset: {
                [self.clock setCLockDefaultDate:[[HACClockDate alloc] initWithHour:0 minute:0 second:0 weekday:1]];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"暂停" atIndex:3];
                [self.clock switchInfoLabel2State:3];
                [STPopupController popupViewControllerName:@"TWClockSetting" inViewController:self.ctrl];
                [hero performAction:@"think" withEnd:nil];
                break;
            }
            case WorkSceneModelStateEnd: {
                [self.clock switchInfoLabel2State:3];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"timer finish!", @"") doText:nil doBlock:nil];
                break;
            }
        }
    } else if ([keyPath isEqualToString:@"remainderSeconds"]) {
        if (!date) {
            date = [[HACClockDate alloc] initWithHour:0 minute:_wsm.remainderSeconds/60 second:_wsm.remainderSeconds%60 weekday:1];
        } else{
            [date updateWithHour:0 minute:_wsm.remainderSeconds/60 second:_wsm.remainderSeconds%60 weekday:1];
        }
        [self.clock setClockDate:date];
    } else if ([keyPath isEqualToString:@"errorCode"]) {
        if (_wsm.errorCode == WorkSceneErrorNeedNewTimer) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"create a new timer", @"") doText:nil doBlock:nil];
        }
    }
}
@end
