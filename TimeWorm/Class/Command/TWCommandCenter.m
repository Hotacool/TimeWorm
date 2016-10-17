//
//  TWCommandCenter.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWCommandCenter.h"

@implementation TWCommandCenter {
    NSMutableArray *observers;
    NSMutableArray <TWBaseCommand *> *commands;
}

HAC_SINGLETON_IMPLEMENT(TWCommandCenter);

- (instancetype)init {
    if (self = [super init]) {
        observers = [NSMutableArray array];
        commands = [NSMutableArray array];
    }
    return self;
}

+ (BOOL)attache2Center:(id)observer {
    BOOL ret = NO;
    if (observer) {
        NSMutableArray *arr = [TWCommandCenter sharedTWCommandCenter]->observers;
        if (![arr containsObject:observer]) {
            [arr addObject:observer];
        }
        ret = YES;
    }
    return ret;
}

+ (void)deattach:(id)observer {
    NSMutableArray *arr = [TWCommandCenter sharedTWCommandCenter]->observers;
    [arr removeObject:observer];
}

+ (void)loadCommad:(TWBaseCommand *)command {
    if (command) {
        NSMutableArray *arr = [TWCommandCenter sharedTWCommandCenter]->commands;
        if (![arr containsObject:command]) {
            [arr addObject:command];
        }
    }
}

+ (void)doActionWithCommand:(NSString *)command {
    NSMutableArray *commands = [TWCommandCenter sharedTWCommandCenter]->commands;
    [commands enumerateObjectsUsingBlock:^(TWBaseCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.commands containsObject:command]) {
            [obj doActionWithCommand:command withCompleteBlock:^(id obj) {
                [[TWCommandCenter sharedTWCommandCenter] response2ObserverWithCommand:command];
            }];
            *stop = YES;
        }
    }];
}

+ (void)doActionWithCommand:(NSString *)command object:(NSObject *)obj {
}

- (void)response2ObserverWithCommand:(NSString*)commandStr {
    NSMutableArray *arr = [TWCommandCenter sharedTWCommandCenter]->observers;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *selectorName = [NSString stringWithFormat:TWCommandResponseSelectorFormat, commandStr];
        if ([obj respondsToSelector:NSSelectorFromString(selectorName)]) {
            [obj performSelector:NSSelectorFromString(selectorName)];
        }
    }];
}
@end
