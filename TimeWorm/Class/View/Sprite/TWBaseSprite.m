//
//  TWBaseSprite.m
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseSprite.h"

const NSTimeInterval kABCSpriteMaxTimeStep = 1; // note: To avoid spiral-o-death
@implementation TWAction
@end

@interface TWBaseSprite () {
    NSString *_runLoopMode;
}
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, TWAction *> *actions;
@property (nonatomic, strong, readwrite) NSString *performAction;

@property (nonatomic, strong) TWAction *activeAction;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval accumulator;
@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic) NSUInteger loopCountdown;
@property (nonatomic) NSUInteger loopCount;
@property (nonatomic, copy) NSString *runLoopMode;
@end

@implementation TWBaseSprite

- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position {
    if (self = [super init]) {
        _size = size;
        _position = position;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _contentLayer = [CALayer layer];
    _contentLayer.frame = CGRectMake(0, 0, _size.width, _size.height);
    _contentLayer.position = _position;
    _contentLayer.delegate = self;
}

- (NSMutableDictionary<NSString *,TWAction *> *)actions {
    if (!_actions) {
        _actions = [NSMutableDictionary dictionary];
    }
    return _actions;
}

- (void)setSize:(CGSize)size {
    _size = size;
    self.contentLayer.bounds = CGRectMake(self.contentLayer.bounds.origin.x, self.contentLayer.bounds.origin.y, size.width, size.height);
}

- (void)setPosition:(CGPoint)position {
    _position = position;
    self.contentLayer.position = position;
}

- (void)addAction:(NSString *)key withAction:(TWAction *)action {
    if (key && action) {
        [self.actions setObject:action forKey:key];
    }
}

- (void)performAction:(NSString *)key withEnd:(void (^)(void))block {
    if (key) {
        if ([self.actions.allKeys containsObject:key]) {
            self.performAction = key;
            [self startAnimating];
        }
    }
}

- (void)performAction:(NSString *)key withLoopCount:(NSUInteger)count end:(void (^)(void))block {
    self.loopCount = count;
    [self performAction:key withEnd:block];
}

- (void)stopCurrentAction {
    if (self.activeAction) {
        [self stopAnimating];
    }
}

- (void)showDefaultImage {
    if (self.actions&&self.actions.count>0) {
        self.contentLayer.contents = (__bridge id _Nullable)(((TWAction*)self.actions.allValues[0]).action.CGImage);
        [self.contentLayer setNeedsDisplay];
    }
}

#pragma mark - perform animation
- (BOOL)isAnimating {
    return (self.displayLink && !self.displayLink.isPaused);
}

- (void)stopAnimating {
    self.loopCountdown = 0;
    self.displayLink.paused = YES;
}

- (void)startAnimating {
    if (![self initializeAnimation]) {
        DDLogError(@"initializeAnimation failed!");
        return;
    }
    if (self.isAnimating) {
        return;
    }
    if (self.loopCount > 0) {
        self.loopCountdown = self.loopCount;
        self.loopCount = 0;
    } else {
        self.loopCountdown = self.activeAction.action.loopCount ?: NSUIntegerMax;
    }
    self.displayLink.paused = NO;
}

- (BOOL)initializeAnimation {
    [self stopAnimating];
    
    if (self.performAction&&(self.activeAction = self.actions[self.performAction])) {
        self.currentFrameIndex = 0;
        self.accumulator = 0;
        self.loopCountdown = 0;
        return YES;
    }
    return NO;
}

- (NSString *)runLoopMode {
    return _runLoopMode ?: NSDefaultRunLoopMode;
}

- (void)setRunLoopMode:(NSString *)runLoopMode {
    if (runLoopMode != _runLoopMode) {
        [self stopAnimating];
        
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        [self.displayLink removeFromRunLoop:runloop forMode:_runLoopMode];
        [self.displayLink addToRunLoop:runloop forMode:runLoopMode];
        
        _runLoopMode = runLoopMode;
        
        [self startAnimating];
    }
}

- (CADisplayLink *)displayLink {
    if (self.contentLayer.superlayer) {
        if (!_displayLink && self.activeAction) {
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeKeyframe:)];
            _displayLink.paused = YES;
            [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    return _displayLink;
}

- (void)changeKeyframe:(CADisplayLink *)displayLink {
    OLImage *animatedImage = self.activeAction.action;
    if (self.currentFrameIndex >= [animatedImage.images count] && [animatedImage isPartial]) {
        return;
    }
    self.accumulator += fmin(displayLink.duration, kABCSpriteMaxTimeStep);
    
    while (self.accumulator >= animatedImage.frameDurations[self.currentFrameIndex]) {
        self.accumulator -= animatedImage.frameDurations[self.currentFrameIndex];
        if (++self.currentFrameIndex >= [animatedImage.images count] && ![animatedImage isPartial]) {
            if (--self.loopCountdown == 0) {
                [self stopAnimating];
                return;
            }
            self.currentFrameIndex = 0;
            //            [self delegateDidLoop];
        }
        self.currentFrameIndex = MIN(self.currentFrameIndex, [animatedImage.images count] - 1);
        [self.contentLayer setNeedsDisplay];
    }
}

- (void)displayLayer:(CALayer *)layer {
    OLImage *animatedImage = self.activeAction.action;
    if (!animatedImage || [animatedImage.images count] == 0) {
        return;
    }
    layer.contents = (__bridge id)([[animatedImage.images objectAtIndex:self.currentFrameIndex] CGImage]);
}

@end
