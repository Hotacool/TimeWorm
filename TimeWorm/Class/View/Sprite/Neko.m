//
//  Neko.m
//  TimeWorm
//
//  Created by macbook on 16/12/22.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "Neko.h"

@implementation Neko
- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position {
    if (self = [super initWithSize:size position:position]) {
        [self setUpActions];
    }
    return self;
}

- (void)setUpActions {
    [self addAction:[[TWAction alloc] initWithKey:@"catch" action:(OLImage*)[OLImage imageNamed:@"neko003.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"swing" action:(OLImage*)[OLImage imageNamed:@"neko001.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"eat" action:(OLImage*)[OLImage imageNamed:@"neko002.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"write" action:(OLImage*)[OLImage imageNamed:@"neko004.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"sleep" action:(OLImage*)[OLImage imageNamed:@"neko005.gif"]]];
}

- (NSString *)doRandomWorkActionWithLoopCount:(NSUInteger)count {
    NSString *actionKey;
    int random = 1 + arc4random()%2;
    if (random==1) {
        actionKey = @"catch";
    } else if (random==2) {
        actionKey = @"write";
    }
    if (actionKey) {
        [self performAction:actionKey withLoopCount:count end:nil];
    }
    return actionKey;
}

- (NSString *)doRandomPauseActionWithLoopCount:(NSUInteger)count {
    NSString *actionKey;
    int random = 1 + arc4random()%2;
    if (random==1) {
        actionKey = @"eat";
    } else if (random==2) {
        actionKey = @"sleep";
    }
    if (actionKey) {
        [self performAction:actionKey withLoopCount:count end:nil];
    }
    return actionKey;

}

- (NSString *)doRandomStopActionWithLoopCount:(NSUInteger)count {
    NSString *actionKey = @"swing";
    if (actionKey) {
        [self performAction:actionKey withLoopCount:count end:nil];
    }
    return actionKey;
}

@end
