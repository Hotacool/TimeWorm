//
//  WorkSceneModel.h
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewModel.h"

typedef  NS_ENUM(NSUInteger, WorkSceneModelState) {
    WorkSceneModelStateNone = 0,
    WorkSceneModelStateWorking,
    WorkSceneModelStatePause,
    WorkSceneModelStateEvent,
    WorkSceneModelStateReset
};
@interface WorkSceneModel : TWBaseViewModel
@property (nonatomic, assign) WorkSceneModelState state;
@end
