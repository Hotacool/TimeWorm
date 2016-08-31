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
}

- (void)think {
    [self performAction:@"think" withLoopCount:5 end:nil];
}

- (void)applaud {
    [self performAction:@"applaud" withLoopCount:2 end:nil];
}
@end
