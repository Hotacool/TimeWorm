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
#import "TWTimer.h"
#import "TWEvent.h"
#import "STPopupController+HAC.h"
#import <pop/POP.h>
#import "HomeViewController.h"

static NSString *const WorkSceneClockAniCenter = @"WorkSceneClockAniCenter";
@interface WorkScene () <TWTimerObserver>
@property (nonatomic, strong) WorkSceneModel *wsm;
@property (nonatomic, strong) HACClockTimer *clock;

@end

@implementation WorkScene {
    HeroSprite *hero;
    HACClockDate *date;
}

- (void)dealloc {
    if (self.wsm) {
        [self.wsm attatchCommand:NO];
        [self.wsm removeObserver:self forKeyPath:@"state"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _wsm = (WorkSceneModel *)self.viewModel;
        [_wsm addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
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
        [self startTimer];
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

- (void)tickTime {
    if (!date) {
        date = [[HACClockDate alloc] initWithHour:0 minute:[TWTimer currentTimer].remainderSeconds/60 second:[TWTimer currentTimer].remainderSeconds%60 weekday:1];
    } else{
        [date updateWithHour:0 minute:[TWTimer currentTimer].remainderSeconds/60 second:[TWTimer currentTimer].remainderSeconds%60 weekday:1];
    }
    [self.clock setClockDate:date];
}

- (void)clockClicked:(id)sender {
    [STPopupController popupViewControllerName:@"TWClockSetting" inViewController:self.ctrl];
}
//clean
- (void)removeFromSuperview {
    [TWTimer removeObserverFromTimer:self];
    [TWTimer cancelTimer:[TWTimer currentTimer]];
    if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
        [TWEvent stopEvent:[TWEvent currentEvent]];
    }
    [MozTopAlertView hideFromWindow];
    [super removeFromSuperview];
}
#pragma mark -- timer
- (void)startTimer {
    //TWTimer
    [TWTimer createTimerWithName:@"biubiubiu" seconds:100];
    [TWTimer currentTimer].information = @"testtesttesttesttest";
    [TWTimer attatchObserver2Timer:self];
    [self.wsm setState:WorkSceneModelStateWorking];
}
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        switch (self.wsm.state) {
            case WorkSceneModelStateNone: {
                break;
            }
            case WorkSceneModelStateWorking: {
                if ([TWTimer currentTimer].state&TWTimerStatePause) {
                    //pause->restart，stop event(complete).
                    [TWEvent stopEvent:[TWEvent currentEvent]];
                }
                [TWTimer activeTimer:[TWTimer currentTimer]];
                [hero performAction:@"think" withEnd:nil];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"暂停" atIndex:3];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeInfo text:NSLocalizedString(@"work start", @"") doText:nil doBlock:nil];
                break;
            }
            case WorkSceneModelStatePause: {
                if (!([TWTimer currentTimer].state&TWTimerStateFlow)) {
                    return;
                }
                [TWTimer pauseTimer:[TWTimer currentTimer]];
                [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
                [hero performAction:@"applaud" withEnd:nil];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"继续" atIndex:3];
                [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"pause", @"") doText:nil doBlock:nil];
                break;
            }
            case WorkSceneModelStateEvent: {
                switch ([TWTimer currentTimer].state) {
                    case TWTimerStateFlow: {
                        [TWTimer pauseTimer:[TWTimer currentTimer]];
                        [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
                        break;
                    }
                    case TWTimerStatePause: {
                        break;
                    }
                    default:
                        [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:NSLocalizedString(@"create a new timer!", @"") doText:nil doBlock:nil];
                        return;
                }
                [hero performAction:@"applaud" withEnd:nil];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"继续" atIndex:3];
                [STPopupController popupViewControllerName:@"TWEventSetting" inViewController:self.ctrl];
                break;
            }
            case WorkSceneModelStateReset: {
                [TWTimer resetTimer:[TWTimer currentTimer]];
                if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
                    //previous event not complete normally, stop it.
                    [TWEvent stopEvent:[TWEvent currentEvent]];
                }
                [self.clock setCLockDefaultDate:[[HACClockDate alloc] initWithHour:0 minute:0 second:0 weekday:1]];
                [(HomeViewController*)self.ctrl changeMenuButtonText:@"暂停" atIndex:3];
                [STPopupController popupViewControllerName:@"TWClockSetting" inViewController:self.ctrl];
                [hero performAction:@"think" withEnd:nil];
                break;
            }
        }
    }
}
@end
