//
//  TWTimer.h
//  TimeWorm
//
//  Created by macbook on 16/9/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWModelTimer.h"

@protocol TWTimerObserver <NSObject>
@required
- (void)tickTime;

@end

@interface TWTimer : NSObject

@property (nonatomic, strong) TWModelTimer *curTimer;

+ (TWModelTimer*)currentTimer ;

+ (TWModelTimer*)createTimerWithName:(NSString*)name seconds:(int)seconds;
/**
 *  激活timer
 *
 *  @param timer 目前只支持当前timer
 */
+ (void)activeTimer:(TWModelTimer*)timer;
/**
 *  暂停timer
 *
 *  @param timer 目前只支持当前timer
 */
+ (void)pauseTimer:(TWModelTimer*)timer;
/**
 *  取消timer
 *
 *  @param timer 目前只支持当前timer
 */
+ (void)cancelTimer:(TWModelTimer*)timer;
/**
 *  重置timer，当前timer设置为nil
 *
 *  @param timer 目前只支持当前timer
 */
+ (void)resetTimer:(TWModelTimer*)timer ;
/**
 *  更新timer
 *
 *  @param timer 目前只支持当前timer
 */
+ (void)updateTimer:(TWModelTimer*)timer ;

+ (void)attatchObserver2Timer:(id<TWTimerObserver>)observer timer:(TWModelTimer*)timer ;

+ (void)removeObserverFromTimer:(id<TWTimerObserver>)observer timer:(TWModelTimer*)timer ;

+ (void)attatchObserver2Timer:(id<TWTimerObserver>)observer;
+ (void)removeObserverFromTimer:(id<TWTimerObserver>)observer;


@end
