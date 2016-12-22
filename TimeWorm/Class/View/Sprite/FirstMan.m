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

- (void)whalecome {
    [self performAction:@"whalecome" withLoopCount:5 end:nil];
}

- (void)lazypanda {
    [self performAction:@"lazypanda" withLoopCount:5 end:nil];
}

- (void)fightpenguin {
    [self performAction:@"fightpenguin" withLoopCount:5 end:nil];
}

- (void)rainpenguin {
    [self performAction:@"rainpenguin" withLoopCount:5 end:nil];
}

- (void)flagpenguin {
    [self performAction:@"flagpenguin" withLoopCount:5 end:nil];
}
@end
