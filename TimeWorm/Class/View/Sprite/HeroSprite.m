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
    [self addAction:[[TWAction alloc] initWithKey:@"think" action:(OLImage*)[OLImage imageNamed:@"思考"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"applaud" action:(OLImage*)[OLImage imageNamed:@"鼓掌"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"shy" action:(OLImage*)[OLImage imageNamed:@"害羞"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"drink" action:(OLImage*)[OLImage imageNamed:@"喝水"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"surprise" action:(OLImage*)[OLImage imageNamed:@"惊吓"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"cry" action:(OLImage*)[OLImage imageNamed:@"哭"]]];
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
