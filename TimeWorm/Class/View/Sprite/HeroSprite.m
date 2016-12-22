//
//  HeroSprite.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HeroSprite.h"

@implementation HeroSprite

- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position {
    if (self = [super initWithSize:size position:position]) {
        [self setUpActions];
    }
    return self;
}

- (void)setUpActions {
    [self addAction:[[TWAction alloc] initWithKey:@"think" action:(OLImage*)[OLImage imageNamed:@"f001.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"applaud" action:(OLImage*)[OLImage imageNamed:@"f002.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"shy" action:(OLImage*)[OLImage imageNamed:@"f003.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"drink" action:(OLImage*)[OLImage imageNamed:@"f004.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"surprise" action:(OLImage*)[OLImage imageNamed:@"neko003.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"cry" action:(OLImage*)[OLImage imageNamed:@"neko004.gif"]]];
}

- (void)think {
    [self performAction:@"think" withLoopCount:5 end:nil];
}
- (void)applaud {
    [self performAction:@"applaud" withLoopCount:5 end:nil];
}
- (void)shy {
    [self performAction:@"shy" withLoopCount:5 end:nil];
}
- (void)drink {
    [self performAction:@"drink" withLoopCount:5 end:nil];
}
- (void)surprise {
    [self performAction:@"surprise" withLoopCount:5 end:nil];
}
- (void)lie {
    [self performAction:@"lie" withLoopCount:5 end:nil];
}
@end
