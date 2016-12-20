//
//  WorkSceneModel.h
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewModel.h"
#import "TWModelTimer.h"

static const NSUInteger WorkSceneErrorNeedNewTimer = 1001;

typedef  NS_ENUM(NSUInteger, WorkSceneModelState) {
    WorkSceneModelStateNone = 0,
    WorkSceneModelStateWorking,
    WorkSceneModelStatePause,
    WorkSceneModelStateEvent,
    WorkSceneModelStateReset,
    WorkSceneModelStateEnd
};
@interface WorkSceneModel : TWBaseViewModel
@property (nonatomic, assign) WorkSceneModelState state;
@property (nonatomic, assign) int errorCode;
@property (nonatomic, assign) NSUInteger remainderSeconds;

- (TWModelTimer*)currentTimer;
- (void)startTimer;
- (void)stopTimer;
- (void)clearData ;
@end
