//
//  HomeSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/1.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeSceneModel.h"
#import "TWConstants.h"

@implementation HomeSceneModel {
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray *)messageList {
    if (!_messageList) {
        id msg = [TWConstants getMessageList];
        if ([msg isKindOfClass:[NSArray class]]) {
            _messageList = msg;
        } else if ([msg isKindOfClass:[NSDictionary class]]) {
            _messageList = [((NSDictionary*)msg) allValues];
        }
    }
    return _messageList;
}

- (void)setState:(HomeSceneModelState)state {
    switch (state) {
        case HomeSceneModelStateNone: {
            break;
        }
        case HomeSceneModelStateApothegm: {
            break;
        }
        case HomeSceneModelStateNormal: {
            break;
        }
        case HomeSceneModelStateAction: {
            break;
        }
    }
    _state = state;
//    if (state == HomeSceneModelStateWaiting) {
//        [self addTimer];
//    } else if (state == HomeSceneModelStateNone) {
//        [self removeTimer];
//    }
}

- (void)spriteActionStopped {
    sfuc
    if (self.state == HomeSceneModelStateApothegm) {
        [self setValue:@(HomeSceneModelStateNormal) forKey:@"state"];
    } else if (self.state == HomeSceneModelStateAction) {
        [self setValue:@(HomeSceneModelStateNormal) forKey:@"state"];
    }
}
@end
