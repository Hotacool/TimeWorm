//
//  TWTimer.m
//  TimeWorm
//
//  Created by macbook on 16/9/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTimer.h"
#import "TWDBManager.h"

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
    newTimer.allSeconds = seconds;
    newTimer.remainderSeconds = seconds;
    newTimer.state = TWTimerStateSilent;
    //db save
    [[self sharedTWTimer] insertNewTimer:newTimer];
    
    [TWTimer sharedTWTimer].curTimer = newTimer;
    return newTimer;
}

+ (BOOL)activeTimer:(TWModelTimer*)timer {
    if (timer!=[TWTimer sharedTWTimer].curTimer) {
        DDLogError(@"暂只支持同时存在一个timer.");
        return NO;
    }
    if ((timer.state&TWTimerStateSilent)
        ||(timer.state&TWTimerStatePause)) {
        [[TWTimer sharedTWTimer] startTime];
        timer.state = TWTimerStateFlow;
        timer.startDate = [NSDate date];
        //db save
        [[self sharedTWTimer] updateTimer:timer];
        DDLogInfo(@"active timer: %@", timer);
        return YES;
    } else {
        DDLogWarn(@"cannot active timer for state: %lu", (unsigned long)timer.state);
    }
    return NO;
}

+ (BOOL)pauseTimer:(TWModelTimer*)timer {
    if (timer.state&TWTimerStateFlow) {
        [[TWTimer sharedTWTimer] stopTime];
        timer.state = TWTimerStatePause;
        //db save
        [[self sharedTWTimer] updateTimer:timer];
        DDLogInfo(@"pause timer: %@", timer);
        return YES;
    } else {
        DDLogWarn(@"cannot pause timer for state: %lu", (unsigned long)timer.state);
    }
    return NO;
}

+ (BOOL)cancelTimer:(TWModelTimer*)timer {
    if ((timer.state&TWTimerStateFlow)
        ||(timer.state&TWTimerStatePause)
        ||(timer.state&TWTimerStateSilent)) {
        DDLogInfo(@"cancel timer: %@", timer);
        [[TWTimer sharedTWTimer] stopTime];
        timer.state = TWTimerStateCancel;
        //db save
        [[self sharedTWTimer] updateTimer:timer];
        return YES;
    } else {
        DDLogWarn(@"cannot cancel timer for state: %lu", (unsigned long)timer.state);
    }
    return NO;
}

+ (BOOL)resetTimer:(TWModelTimer*)timer {
    if (timer.state&TWTimerStateEnd) {
        DDLogInfo(@"timer has already been ended.");
    } else {
        [self cancelTimer:timer];
        [TWTimer sharedTWTimer].curTimer = nil;
        return YES;
    }
    return NO;
}

+ (BOOL)updateTimer:(TWModelTimer*)timer {
    if ((timer.state&TWTimerStateFlow)
        ||(timer.state&TWTimerStatePause)
        ||(timer.state&TWTimerStateSilent)) {
        DDLogInfo(@"update timer: %@", timer);
        [[self sharedTWTimer] updateTimer:timer];
        return YES;
    } else {
        DDLogWarn(@"cannot update timer for state: %lu", timer.state);
    }
    return NO;
}

+ (BOOL)endTimer:(TWModelTimer*)timer {
    if (timer.state&TWTimerStateFlow) {
        DDLogInfo(@"end timer: %@", timer);
        timer.state = TWTimerStateEnd;
        timer.fireDate = [NSDate date];
        [[self sharedTWTimer] updateTimer:timer];
        return YES;
    } else {
        DDLogWarn(@"cannot end timer for state: %lu", timer.state);
    }
    return NO;
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
    self.curTimer.remainderSeconds--;
    [self.observers enumerateObjectsUsingBlock:^(id<TWTimerObserver>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj tickTime];
    }];
    
    if (self.curTimer.remainderSeconds==0) {
        [TWTimer endTimer:self.curTimer];
        [self stopTime];
    }
}
#pragma mark -- db ope
- (void)insertNewTimer:(TWModelTimer*)timer {
    [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"INSERT INTO TWTimer('name','information','allSeconds', 'remainderSeconds','startDate','state') VALUES('%@','%@','%@','%@','%@','%@')"
                               ,timer.name
                               ,timer.information
                               ,@(timer.allSeconds)
                               ,@(timer.remainderSeconds)
                               ,timer.startDate
                               ,@(timer.state)];
        BOOL ret = [db executeUpdate:updateSql];
        if (ret) {
            NSString * sql = @"select max(seq) as id from sqlite_sequence where name='TWTimer'";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                timer.ID = [rs intForColumn:@"id"];
            }
            DDLogInfo(@"insert suucessed.");
        } else {
            DDLogError(@"insert failed!");
        }
    }];
    
}

- (void)updateTimer:(TWModelTimer*)timer {
    [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE 'TWTimer' SET 'name' = '%@', 'information'='%@', 'startDate'='%@', 'allSeconds'='%@', 'remainderSeconds'='%@', 'state'='%@', 'fireDate'='%@' WHERE id = '%@'"
                               , timer.name
                               , timer.information
                               , timer.startDate
                               , @(timer.allSeconds)
                               , @(timer.remainderSeconds)
                               , @(timer.state)
                               , timer.fireDate?:@""
                               , @(timer.ID)];
        BOOL ret = [db executeUpdate:updateSql];
        if (ret) {
            DDLogInfo(@"update successed.");
        } else {
            DDLogError(@"update failed!");
        }
    }];
}
@end
