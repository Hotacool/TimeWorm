//
//  TWModelTimer.m
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModelTimer.h"

@implementation TWModelTimer

@end

@interface TWTimer ()
@property (nonatomic, strong) NSMutableArray<id<TWTimerObserver>> *observers;
@property (nonatomic, strong) NSTimer *calculagraph;

@end

@implementation TWTimer

HAC_SINGLETON_IMPLEMENT(TWTimer)

+ (TWModelTimer*)currentTimer {
    return [TWTimer sharedTWTimer].curTimer;
}

+ (TWModelTimer*)createTimerWithName:(NSString*)name seconds:(int)seconds {
    if ([TWTimer currentTimer].state!=TWTimerStateEnd) {
        [TWTimer currentTimer].state = TWTimerStateCancel;
        [[TWTimer sharedTWTimer] stopTime];
    }
    TWModelTimer *newTimer = [TWModelTimer new];
    newTimer.name = name;
    newTimer.seconds = seconds;
    newTimer.state = TWTimerStateSilent;
    [TWTimer sharedTWTimer].curTimer = newTimer;
    return newTimer;
}

+ (void)activeTimer:(TWModelTimer*)timer {
    if (timer!=[TWTimer sharedTWTimer].curTimer) {
        DDLogError(@"暂只支持同时存在一个timer.");
        return;
    }
    if ((timer.state&TWTimerStateSilent)
        ||(timer.state&TWTimerStatePause)) {
        DDLogInfo(@"active timer: %@", timer.name);
        [[TWTimer sharedTWTimer] startTime];
        timer.state = TWTimerStateFlow;
    } else {
        DDLogWarn(@"cannot active timer for state: %lu", (unsigned long)timer.state);
    }
}

+ (void)pauseTimer:(TWModelTimer*)timer {
    if (timer.state&TWTimerStateFlow) {
        DDLogInfo(@"pause timer: %@", timer.name);
        [[TWTimer sharedTWTimer] stopTime];
        timer.state = TWTimerStatePause;
    } else {
        DDLogWarn(@"cannot pause timer for state: %lu", (unsigned long)timer.state);
    }
}

+ (void)cancelTimer:(TWModelTimer*)timer {
    if ((timer.state&TWTimerStateFlow)
        ||(timer.state&TWTimerStatePause)
        ||(timer.state&TWTimerStateSilent)) {
        DDLogInfo(@"cancel timer: %@", timer.name);
        [[TWTimer sharedTWTimer] stopTime];
        timer.state = TWTimerStateCancel;
    } else {
        DDLogWarn(@"cannot cancel timer for state: %lu", (unsigned long)timer.state);
    }
}

+ (void)attatchObserver2Timer:(id<TWTimerObserver>)observer timer:(TWModelTimer *)timer {
    NSMutableArray *arr = [TWTimer sharedTWTimer].observers;
    if (![arr containsObject:observer]) {
        [[TWTimer sharedTWTimer].observers addObject:observer];
    }
}

+ (void)removeObserverFromTimer:(id<TWTimerObserver>)observer timer:(TWModelTimer *)timer {
    NSMutableArray *arr = [TWTimer sharedTWTimer].observers;
    if ([arr containsObject:observer]) {
        [[TWTimer sharedTWTimer].observers removeObject:observer];
    }
}

+ (void)attatchObserver2Timer:(id<TWTimerObserver>)observer {
    [self attatchObserver2Timer:observer timer:nil];
}
+ (void)removeObserverFromTimer:(id<TWTimerObserver>)observer {
    [self removeObserverFromTimer:observer timer:nil];
}

#pragma  mark - instance method
- (NSMutableArray<id<TWTimerObserver>> *)observers {
    if (!_observers) {
        _observers = [NSMutableArray array];
    }
    return _observers;
}

- (void)stopTime{
    [self.calculagraph invalidate];
    self.calculagraph = nil;
}

- (void)startTime{
    self.calculagraph = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.calculagraph forMode:NSRunLoopCommonModes];
}

- (void)timeDown{
    self.curTimer.seconds--;
    [self.observers enumerateObjectsUsingBlock:^(id<TWTimerObserver>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj tickTime];
    }];
    
    if (self.curTimer.seconds==0) {
        self.curTimer.fireDate = [NSDate date];
        self.curTimer.state = TWTimerStateEnd;
        [self stopTime];
    }
}
@end
