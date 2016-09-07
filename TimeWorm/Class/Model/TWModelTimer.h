//
//  TWModelTimer.h
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModel.h"

typedef NS_OPTIONS(NSUInteger, TWTimerState) {
    TWTimerStateSilent = 1<<0,
    TWTimerStateFlow   = 1<<1,
    TWTimerStatePause  = 1<<2,
    TWTimerStateEnd    = 1<<3,
    TWTimerStateCancel = 1<<4
};
@interface TWModelTimer : TWModel
@property (nonatomic, assign) int ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) TWTimerState state;
@end

@protocol TWTimerObserver <NSObject>
@required
- (void)tickTime;

@end

@interface TWTimer : NSObject

@property (nonatomic, strong) TWModelTimer *curTimer;

+ (TWModelTimer*)currentTimer ;

+ (TWModelTimer*)createTimerWithName:(NSString*)name seconds:(int)seconds;

+ (void)activeTimer:(TWModelTimer*)timer;

+ (void)pauseTimer:(TWModelTimer*)timer;

+ (void)cancelTimer:(TWModelTimer*)timer;

+ (void)attatchObserver2Timer:(id<TWTimerObserver>)observer timer:(TWModelTimer*)timer ;

+ (void)removeObserverFromTimer:(id<TWTimerObserver>)observer timer:(TWModelTimer*)timer ;

+ (void)attatchObserver2Timer:(id<TWTimerObserver>)observer;
+ (void)removeObserverFromTimer:(id<TWTimerObserver>)observer;


@end
