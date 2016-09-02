//
//  TWBaseSprite.h
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OLImage.h"

@interface TWAction : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) OLImage* action;
- (instancetype)initWithKey:(NSString*)key action:(OLImage*)action ;
@end

@interface TWBaseSprite : NSObject
@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, assign, readonly) CGPoint position;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *,TWAction *> *actions;
@property (nonatomic, strong, readonly) NSString *performAction;
@property (nonatomic, strong, readonly) CALayer *contentLayer;

- (instancetype)initWithSize:(CGSize)size position:(CGPoint)position ;
- (void)addAction:(NSString*)key withAction:(TWAction*)action ;
- (void)addAction:(TWAction*)action;
- (void)performAction:(NSString*)key withEnd:(void(^)(void)) block ;
- (void)performAction:(NSString*)key withLoopCount:(NSUInteger)count end:(void(^)(void)) block ;
- (void)stopCurrentAction;
- (void)showDefaultImage ;
- (void)showDefaultAction ;
- (void)setSize:(CGSize)size ;
- (void)setPosition:(CGPoint)position ;
- (NSString *)doRandomActionWithLoopCount:(NSUInteger)count;
@end
