//
//  HomeScene.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeScene.h"
#import "HeroSprite.h"

@implementation HomeScene {
    HeroSprite *hero;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        hero = [[HeroSprite alloc] initWithSize:CGSizeMake(200, 200) position:CGPointMake(frame.size.width/2, frame.size.height/2)];
        [self addSprite:hero];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        button.titleLabel.text = @"think";
        button.backgroundColor = [UIColor yellowColor];
        [self addSubview:button];
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addSprite:(TWBaseSprite *)sprite {
    [super addSprite:sprite];
    [self.contentLayer addSublayer:hero.contentLayer];
}

- (void)clicked:(id)sender {
    DDLogInfo(@"clicked");
    [hero think];
    [TWCommandCenter doActionWithCommand:@"selectScene"];
}
@end
