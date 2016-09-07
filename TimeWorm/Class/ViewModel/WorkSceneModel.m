//
//  WorkSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/2.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "WorkSceneModel.h"

@implementation WorkSceneModel
#pragma mark -- command action
- (void)response2workScenePause {
    DDLogInfo(@"%s", __func__);
    self.state = WorkSceneModelStatePause;
}

- (void)response2workSceneEvent {
    DDLogInfo(@"%s", __func__);
    self.state = WorkSceneModelStateEvent;
}

- (void)response2workSceneReset {
    DDLogInfo(@"%s", __func__);
    self.state = WorkSceneModelStateReset;
}
@end
