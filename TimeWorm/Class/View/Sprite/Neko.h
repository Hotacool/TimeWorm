//
//  Neko.h
//  TimeWorm
//
//  Created by macbook on 16/12/22.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseSprite.h"

@interface Neko : TWBaseSprite

- (NSString *)doRandomWorkActionWithLoopCount:(NSUInteger)count ;

- (NSString *)doRandomPauseActionWithLoopCount:(NSUInteger)count ;

- (NSString *)doRandomStopActionWithLoopCount:(NSUInteger)count ;
@end
