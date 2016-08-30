//
//  TWCommandCenter.h
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWBaseCommand.h"

static NSString *const TWCommandResponseSelectorFormat = @"response2%@";

@interface TWCommandCenter : NSObject

HAC_SINGLETON_DEFINE(TWCommandCenter)

+ (BOOL)attache2Center:(id)observer ;
+ (void)deattach:(id)observer ;

+ (void)loadCommad:(TWBaseCommand*)command;
+ (void)doActionWithCommand:(NSString *)command;
@end
