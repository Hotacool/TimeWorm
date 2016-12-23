//
//  WorkScene.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "WorkScene.h"
#import "Neko.h"
#import "WorkSceneModel.h"
#import "HACClockTimer.h"
#import "TWModelTimer.h"
#import "STPopupController+HAC.h"
#import <pop/POP.h>
#import "HomeViewController.h"
#import "TWEventList.h"
#import "TWCommandCommon.h"
#import "TWSet.h"
#import "TWAudioHelp.h"
#import "GUAAlertView.h"

static NSString *const WorkSceneClockAniCenter = @"WorkSceneClockAniCenter";
@interface WorkScene ()
@property (nonatomic, strong) WorkSceneModel *wsm;
@property (nonatomic, strong) HACClockTimer *clock;
@property (nonatomic, strong) UIButton *event;

@end

@implementation WorkScene {
    Neko *neko;
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
        [neko doRandomStopActionWithLoopCount:1];
        [self showClock];
        //自动启动
        [_wsm startTimer];
    });
}

- (void)setUIComponents {
    neko = [[Neko alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 20)];
    [self addSprite:neko];
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                              skinSet:[TWSet currentSet].workTheme]
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
    ret.title = NSLocalizedString(@"Event Set", @"");
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
                [self.clock setCLockDefaultDate:[[HACClockDate alloc] initWithHour:0 minute:0 second:0 weekday:1]];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"暂停" atIndex:3];
                [self.clock switchInfoLabel2State:3];
                break;
            }
            case WorkSceneModelStateWorking: {
                [neko doRandomWorkActionWithLoopCount:INTMAX_MAX];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"暂停" atIndex:3];
                [self.clock switchInfoLabel2State:1];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeInfo text:NSLocalizedString(@"work start", @"") doText:nil doBlock:nil];
                break;
            }
            case WorkSceneModelStatePause: {
                [neko doRandomPauseActionWithLoopCount:INTMAX_MAX];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"继续" atIndex:3];
                [self.clock switchInfoLabel2State:2];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"pause", @"") doText:nil doBlock:nil];
                break;
            }
            case WorkSceneModelStateEvent: {
                [neko doRandomPauseActionWithLoopCount:INTMAX_MAX];
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
                [neko doRandomStopActionWithLoopCount:INTMAX_MAX];
                break;
            }
            case WorkSceneModelStateEnd: {
                [self.clock switchInfoLabel2State:3];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"timer finish!", @"") doText:nil doBlock:nil];
                [TWAudioHelp playTimerComplete];
                [neko doRandomStopActionWithLoopCount:INTMAX_MAX];
                
                if ([TWSet currentSet].continueWork) {//连续计时
                    GUAAlertView *v = [GUAAlertView alertViewWithTitle:@"success"
                                                               message:@"continue a new timer?"
                                                           buttonTitle:@"OK"
                                                   buttonTouchedAction:^{
                                                       DDLogInfo(@"touched");
                                                       // continue to start a new timer
                                                       [self.wsm startTimer];
                                                   } dismissAction:^{
                                                       DDLogInfo(@"dismiss");
                                                   }];
                    [v setAlertBackgroudColor:Haqua];
                    [v show];
                } else {
                    //当计时器大于25分钟时，结束后询问是否放松
                    if (_wsm.currentTimer.allSeconds >= 60*25) {
                        GUAAlertView *v = [GUAAlertView alertViewWithTitle:@"success"
                                                                   message:@"need to relax?"
                                                               buttonTitle:@"OK"
                                                       buttonTouchedAction:^{
                                                           [TWCommandCenter doActionWithCommand:TWCommandCommon_tureRelax];
                                                       } dismissAction:^{
                                                           DDLogInfo(@"dismiss");
                                                       }];
                        [v setAlertBackgroudColor:Haqua];
                        [v show];
                    }
                }
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
