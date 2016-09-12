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

- (TWBaseViewModel *)viewModel {
    if (!_viewModel) {
        NSString *viewModelClassStr = [NSStringFromClass([self class]) stringByAppendingString:@"Model"];
        _viewModel = [NSClassFromString(viewModelClassStr) new];
    }
    return _viewModel;
}

- (void)addSprite:(TWBaseSprite *)sprite {
    if (sprite) {
        if ([self.sprites containsObject:sprite]) {
            DDLogWarn(@"sprites already has a sprite: %@", sprite);
        } else {
            [self.sprites addObject:sprite];
            [self.contentLayer addSublayer:sprite.contentLayer];
        }
    }
}

- (void)removeSprite:(TWBaseSprite *)sprite {
    if (sprite) {
        if ([self.sprites containsObject:sprite]) {
            [self.sprites removeObject:sprite];
            [sprite.contentLayer removeFromSuperlayer];
        } else {
            DDLogWarn(@"sprites has no sprite: %@", sprite);
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
