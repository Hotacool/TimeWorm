//
//  TWBaseCommand.h
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCommandCenter.h"

@interface TWBaseCommand : NSObject

- (NSArray<NSString*>*)commands;

- (void)doActionWithCommand:(NSString *)command withCompleteBlock:(void(^)(id))complete;
@end
