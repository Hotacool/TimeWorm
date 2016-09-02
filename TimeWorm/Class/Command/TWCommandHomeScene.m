//
//  TWCommandHomeScene.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWCommandHomeScene.h"

@implementation TWCommandHomeScene

- (NSArray<NSString *> *)commands {
    return @[HomeSceneCommand_think
             ,HomeSceneCommand_laugh
             ,HomeSceneCommand_upShift
             ,HomeSceneCommand_downShift
             ,HomeSceneCommand_leftShift
             ,HomeSceneCommand_rightShift];
}

- (void)doActionWithCommand:(NSString *)command withCompleteBlock:(void (^)(id))complete {
    if (complete) {
        complete(nil);
    }
}
@end
