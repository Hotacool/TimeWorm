//
//  TWCommandWorkScene.m
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWCommandWorkScene.h"

@implementation TWCommandWorkScene
- (NSArray<NSString *> *)commands {
    return @[WorkSceneCommand_start
             ,WorkSceneCommand_pause
             ,WorkSceneCommand_event
             ,WorkSceneCommand_reset
             ,WorkSceneCommand_none];
}

- (void)doActionWithCommand:(NSString *)command withCompleteBlock:(void (^)(id))complete {
    if (complete) {
        complete(nil);
    }
}

@end
