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
    BOOL introPageShow;
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
    [NSNotifyCenter addObserver:twcons selector:@selector(introPageShow:) name:kTWIntroPageDidShowNotification object:nil];
    [NSNotifyCenter addObserver:twcons selector:@selector(introDidFinished:) name:kTWIntroPageDidDismissNotification object:nil];
    HACBackground(^{
        [self loadMessageList];
    });
}

+ (void)loadMessageList {
    if (!twcons->messageList) {
        twcons->messageList = [TWUtility readJsonName:@"tips"];
    }
}

#pragma mark -- out api
+ (id)getMessageList {
    [self loadMessageList];
    return twcons->messageList;
}

+ (BOOL)isIntroPageShowing {
    return twcons->introPageShow;
}

#pragma mark -- private
- (void)introPageShow:(id)n {
    introPageShow = YES;
}

- (void)introDidFinished:(id)n {
    introPageShow = NO;
}
@end
