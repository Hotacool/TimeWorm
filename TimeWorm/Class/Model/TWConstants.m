//
//  TWConstants.m
//  TimeWorm
//
//  Created by macbook on 16/12/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWConstants.h"

#define twcons [TWConstants shareInstance]
@implementation TWConstants {
    id messageList;
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static TWConstants *instance;
    dispatch_once(&onceToken, ^{
        instance = [TWConstants new];
    });
    return instance;
}

+ (void)initializeConstrants {
    HACBackground(^{
        [self loadMessageList];
    });
}

+ (void)loadMessageList {
    if (!twcons->messageList) {
        twcons->messageList = [TWUtility readJsonName:@"tips"];
    }
}

+ (id)getMessageList {
    [self loadMessageList];
    return twcons->messageList;
}
@end
