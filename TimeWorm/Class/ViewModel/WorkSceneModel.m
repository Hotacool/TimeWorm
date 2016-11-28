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

- (void)setState:(WorkSceneModelState)state {
    switch (state) {
        case WorkSceneModelStateNone: {
            break;
        }
        case WorkSceneModelStateWorking: {
            if ([TWTimer currentTimer].state) {
                <#statements#>
            }
            if ([TWTimer currentTimer].state&TWTimerStatePause) {
                //pause->restart，stop event(complete).
                [TWEvent stopEvent:[TWEvent currentEvent]];
            }
            [TWTimer activeTimer:[TWTimer currentTimer]];
            break;
        }
        case WorkSceneModelStatePause: {
            if (!([TWTimer currentTimer].state&TWTimerStateFlow)) {
                return;
            }
            [TWTimer pauseTimer:[TWTimer currentTimer]];
            [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
            break;
        }
        case WorkSceneModelStateEvent: {
            switch ([TWTimer currentTimer].state) {
                case TWTimerStateFlow: {
                    [TWTimer pauseTimer:[TWTimer currentTimer]];
                    [TWEvent createDefaultEventWithTimerId:[TWTimer currentTimer].ID];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case WorkSceneModelStateReset: {
            if ([TWTimer currentTimer].state&TWTimerStateEnd) {
                return;
            }
            [TWTimer resetTimer:[TWTimer currentTimer]];
            if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
                //previous event not complete normally, stop it.
                [TWEvent stopEvent:[TWEvent currentEvent]];
            }
            break;
        }
    }
    // set state
    _state = state;
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
    [self setState:WorkSceneModelStateWorking];
}

- (void)tickTime {
    self.remainderSeconds = [TWTimer currentTimer].remainderSeconds;
}

#pragma mark -- command action
- (void)response2workScenePause {
    DDLogInfo(@"%s", __func__);
    if (isPause) {
        self.state = WorkSceneModelStateWorking;
    } else {
        self.state = WorkSceneModelStatePause;
    }
    isPause = isPause?NO:YES;
}

- (void)response2workSceneEvent {
    DDLogInfo(@"%s", __func__);
    self.state = WorkSceneModelStateEvent;
    isPause = YES;
}

- (void)response2workSceneReset {
    DDLogInfo(@"%s", __func__);
    self.state = WorkSceneModelStateReset;
    isPause = NO;
}

#pragma mark -- DB Ope

@end
