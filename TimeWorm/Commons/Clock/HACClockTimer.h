//
//  HACClockTimer.h
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//
#import "QBFlatButton.h"

@interface HACClockDate : NSObject
@property (nonatomic, assign) NSUInteger hour;
@property (nonatomic, assign) NSUInteger minute;
@property (nonatomic, assign) NSUInteger second;
@property (nonatomic, assign) NSUInteger weekday;

- (instancetype)initWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second weekday:(NSUInteger)weekday;
- (void)updateWithHour:(NSUInteger)hour minute:(NSUInteger)minute second:(NSUInteger)second weekday:(NSUInteger)weekday;
- (void)reduce ;
- (NSUInteger)remainderSeconds ;
@end

@interface HACClockTimer : QBFlatButton
- (void)setClockDate:(HACClockDate*)date ;
- (void)setCLockDefaultDate:(HACClockDate*)date ;
@end
