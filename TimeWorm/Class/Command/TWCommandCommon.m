//
//  TWCommandCommon.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWCommandCommon.h"

@implementation TWCommandCommon

- (NSArray<NSString *> *)commands {
    return @[TWCommandCommon_selectScene
             ,TWCommandCommon_tureRelax];
}

- (void)doActionWithCommand:(NSString *)command withCompleteBlock:(void (^)(id))complete {
    if (complete) {
        complete(nil);
    }
}
@end
