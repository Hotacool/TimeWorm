//
//  TWBaseScene.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseScene.h"

@implementation TWBaseScene {
    NSMutableArray<__kindof TWBaseSprite*> *_sprites;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {

}

- (void)addSprite:(TWBaseSprite *)sprite {
    if (sprite) {
        if ([self.sprites containsObject:sprite]) {
            DDLogWarn(@"sprites already has a sprite: %@", sprite);
        } else {
            [self.sprites addObject:sprite];
        }
    }
}

- (CALayer *)contentLayer {
    return self.layer;
}

- (NSMutableArray<TWBaseSprite *> *)sprites {
    if (!_sprites) {
        _sprites = [NSMutableArray array];
    }
    return _sprites;
}
@end
