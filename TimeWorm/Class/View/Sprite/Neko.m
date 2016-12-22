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
    [self addAction:[[TWAction alloc] initWithKey:@"swing" action:(OLImage*)[OLImage imageNamed:@"neko001.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"eat" action:(OLImage*)[OLImage imageNamed:@"neko002.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"catch" action:(OLImage*)[OLImage imageNamed:@"neko003.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"write" action:(OLImage*)[OLImage imageNamed:@"neko004.gif"]]];
    [self addAction:[[TWAction alloc] initWithKey:@"sleep" action:(OLImage*)[OLImage imageNamed:@"neko005.gif"]]];
}

- (void)swing {
    [self performAction:@"swing" withLoopCount:5 end:nil];
}
- (void)eat {
    [self performAction:@"eat" withLoopCount:5 end:nil];
}
- (void)catch {
    [self performAction:@"catch" withLoopCount:5 end:nil];
}
- (void)write {
    [self performAction:@"write" withLoopCount:5 end:nil];
}
- (void)sleep {
    [self performAction:@"sleep" withLoopCount:5 end:nil];
}

@end
