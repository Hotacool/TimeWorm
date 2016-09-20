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
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, assign) int allSeconds;
@property (nonatomic, assign) int remainderSeconds;
@property (nonatomic, assign) TWTimerState state;
@end
