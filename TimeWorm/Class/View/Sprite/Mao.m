//
//  mao.m
//  TimeWorm
//
//  Created by macbook on 16/12/22.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "Mao.h"

@implementation Mao

- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position {
    if (self = [super initWithSize:size position:position]) {
        [self setUpActions];
    }
    return self;
}

- (void)setUpActions {
    [self addAction:[[TWAction alloc] initWithKey:@"yaowei" action:(OLImage*)[OLImage imageNamed:@"yaowei.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"happy" action:(OLImage*)[OLImage imageNamed:@"happy.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"maodie" action:(OLImage*)[OLImage imageNamed:@"maodie.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"maolove" action:(OLImage*)[OLImage imageNamed:@"maolove.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"susi" action:(OLImage*)[OLImage imageNamed:@"susi.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"sleepy" action:(OLImage*)[OLImage imageNamed:@"sleepy.gif"]]];
}
@end
