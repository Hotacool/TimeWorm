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
        TWAction *action0 = [TWAction new];
        action0.key = @"think";
        action0.action = (OLImage*)[OLImage imageNamed:@"思考"];
        [self addAction:action0.key withAction:action0];
    }
    return self;
}

- (void)think {
    [self performAction:@"think" withLoopCount:5 end:nil];
}
@end
