//
//  WorkSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "WorkSceneModel.h"
#import "TWTimer.h"
#import "TWEvent.h"

@interface WorkSceneModel() <TWTimerObserver>

@end

@implementation WorkSceneModel {
    BOOL isPause;//menu是否显示的是“暂停”
}

- (void)switchState:(WorkSceneModelState)state {
    switch (state) {
        case WorkSceneModelStateNone: {
            break;
        }
        case WorkSceneModelStateWorking: {
            if (self.currentTimer.state&TWTimerStatePause) {
                // pause -> working
                [TWEvent stopEvent:[TWEvent currentEvent]];
            } else if (self.currentTimer.state&TWTimerStateSilent) {
                // None(silent) -> working
            } else {
                self.errorCode = WorkSceneErrorNeedNewTimer;
                return;
            }
            [TWTimer activeTimer:[TWTimer currentTimer]];
            break;
        }
        case WorkSceneModelStatePause: {
            if (self.currentTimer.state&TWTimerStateFlow) {
                // flow -> pause
                [TWTimer pauseTimer:[TWTimer currentTimer]];
                [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
            } else {
                self.errorCode = WorkSceneErrorNeedNewTimer;
                return;
            }
            break;
        }
        case WorkSceneModelStateEvent: {
            if (self.currentTimer.state&TWTimerStateFlow) {
                // working -> event
                [TWTimer pauseTimer:[TWTimer currentTimer]];
                [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
            } else if (self.currentTimer.state&TWTimerStatePause) {
                // pause -> event
            } else {
                self.errorCode = WorkSceneErrorNeedNewTimer;
                return;
            }
            break;
        }
        case WorkSceneModelStateReset: {
            if (self.currentTimer.state&TWTimerStateSilent) {
                // None(silent) -> reset
            } else if (self.currentTimer.state&TWTimerStateFlow) {
                // working -> reset
            } else if (self.currentTimer.state&TWTimerStatePause) {
                // pause -> reset
                [TWEvent stopEvent:[TWEvent currentEvent]];
            } else {
            }
            [TWTimer resetTimer:[TWTimer currentTimer]];
            break;
        }
        case WorkSceneModelStateEnd: {
            // timer auto stop, do nothing
            break;
        }
    }
    // set state
    self.state = state;
}

- (TWModelTimer *)currentTimer {
    return [TWTimer currentTimer];
}

- (void)clearData {
    [TWTimer removeObserverFromTimer:self];
    [TWTimer cancelTimer:[TWTimer currentTimer]];
    if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
        [TWEvent stopEvent:[TWEvent currentEvent]];
    }
}

#pragma mark -- timer
- (void)startTimer {
    //TWTimer
    [TWTimer createDefaultTimer];
    [TWTimer attatchObserver2Timer:self];
    [self switchState:WorkSceneModelStateWorking];
}

- (void)tickTime {
    self.remainderSeconds = [TWTimer currentTimer].remainderSeconds;
    if (self.remainderSeconds == 0) {
        [self switchState:WorkSceneModelStateEnd];
    }
}

#pragma mark -- command action
- (void)response2workScenePause {
    DDLogInfo(@"%s", __func__);
    if (isPause && self.currentTimer.state&TWTimerStatePause) {
        [self switchState:WorkSceneModelStateWorking];
    } else if (!isPause && self.currentTimer.state&TWTimerStateFlow) {
        [self switchState:WorkSceneModelStatePause];
    } else {
        self.errorCode = WorkSceneErrorNeedNewTimer;
        return;
    }
    isPause = isPause?NO:YES;
}

- (void)response2workSceneEvent {
    DDLogInfo(@"%s", __func__);
    [self switchState:WorkSceneModelStateEvent];
    isPause = YES;
}

- (void)response2workSceneReset {
    DDLogInfo(@"%s", __func__);
    [self switchState:WorkSceneModelStateReset];
    isPause = NO;
}

#pragma mark -- DB Ope

@end
