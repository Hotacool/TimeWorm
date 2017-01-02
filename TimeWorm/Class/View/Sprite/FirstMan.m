//
//  FirstMan.m
//  TimeWorm
//
//  Created by macbook on 16/12/22.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "FirstMan.h"

@implementation FirstMan
- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position {
    if (self = [super initWithSize:size position:position]) {
        [self setUpActions];
    }
    return self;
}

- (void)setUpActions {
    [self addAction:[[TWAction alloc] initWithKey:@"whalecome" action:(OLImage*)[OLImage imageNamed:@"f001.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"lazypanda" action:(OLImage*)[OLImage imageNamed:@"f002.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"fightpenguin" action:(OLImage*)[OLImage imageNamed:@"f003.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"rainpenguin" action:(OLImage*)[OLImage imageNamed:@"f004.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"flagpenguin" action:(OLImage*)[OLImage imageNamed:@"f005.gif"]]];
}

// override
- (NSString *)doRandomActionWithLoopCount:(NSUInteger)count {
    NSString *actionKey;
    do {
        int rdIdx = [self getRandomNumber:0 to:(int)self.actions.count];
        actionKey = self.actions.allKeys[rdIdx];
    } while ([actionKey isEqualToString:self.performAction]);
    if ([actionKey isEqualToString:@"whalecome"]) {
        count = 2;
    } else if ([actionKey isEqualToString:@"lazypanda"]) {
        count = 5;
    }
    [self performAction:actionKey withLoopCount:count end:nil];
    return actionKey;
}
@end
