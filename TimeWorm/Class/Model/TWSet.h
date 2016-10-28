//
//  TWSet.h
//  TimeWorm
//
//  Created by macbook on 16/10/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWModelSet.h"
@interface TWSet : NSObject

+ (TWModelSet*)currentSet ;

+ (BOOL)updateSet:(TWModelSet*)set ;

+ (BOOL)updateSetColumn:(NSString*)column withObj:(id)obj ;
@end
