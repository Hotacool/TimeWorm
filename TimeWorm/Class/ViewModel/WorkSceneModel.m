//
//  WorkSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "WorkSceneModel.h"

@implementation WorkSceneModel {
    BOOL isPause;//menu是否显示的是“暂停”
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
@end
