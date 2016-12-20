//
//  TWModelSet.h
//  TimeWorm
//
//  Created by macbook on 16/10/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModel.h"

@interface TWModelSet : TWModel
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int homeTheme;
@property (nonatomic, assign) int workTheme;
@property (nonatomic, assign) int relaxTheme;
@property (nonatomic, assign) BOOL keepAwake;
@property (nonatomic, assign) int defaultTimer;
@property (nonatomic, strong) NSString *defaultTimerName;
@property (nonatomic, strong) NSString *defaultTimerInf;
@property (nonatomic, strong) NSString *defaultEventName;
@property (nonatomic, assign) BOOL keepTimer;
@property (nonatomic, assign) BOOL isNotifyOn;
@property (nonatomic, assign) BOOL continueWork;
@property (nonatomic, assign) BOOL isVoiceOn;
@end
