//
//  HomeSceneModel.m
//  TimeWorm
//
//  Created by macbook on 16/9/1.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeSceneModel.h"
#import "TWConstants.h"

@implementation HomeScenePpMsg
@end

@implementation HomeSceneModel {
    HomeScenePpMsg *currentMsg;
}

- (instancetype)init {
    if (self = [super init]) {
        self.messageList = [NSMutableArray array];
    }
    return self;
}

- (NSMutableArray<HomeScenePpMsg *> *)messageList {
    if (HACObjectIsEmpty(_messageList)) {
        id msg = [TWConstants getMessageList];
        if ([msg isKindOfClass:[NSArray class]]) {
            DDLogError(@"paopao message list is not dic but array!");
        } else if ([msg isKindOfClass:[NSDictionary class]]) {
            NSArray *tmpMsgList = [((NSDictionary*)msg) allValues];
            [tmpMsgList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *msgDic = obj;
                    HomeScenePpMsg *ppMsg = [HomeScenePpMsg new];
                    ppMsg.message = [msgDic objectForKey:@"content"];
                    ppMsg.dispatchClassName = [msgDic objectForKey:@"className"];
                    [_messageList addObject:ppMsg];
                }
            }];
        }
    }
    return _messageList;
}

- (HomeScenePpMsg*)createRandomMessageToShow {
    if (self.messageList) {
        // 注: 随机决定是否显示message
        int count = (int)self.messageList.count;
        int random = (int)(0 + (arc4random() % (count+2-0)));
        if (random <= count-1) {
            currentMsg = self.messageList[random];
        } else {
            currentMsg = nil;
        }
    } else {
        currentMsg = nil;
    }
    return currentMsg;
}

- (HomeScenePpMsg*)currentMessage {
    return currentMsg;
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
