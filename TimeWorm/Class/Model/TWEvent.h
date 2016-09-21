//
//  TWEvent.h
//  TimeWorm
//
//  Created by macbook on 16/9/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWModelEvent.h"
@interface TWEvent : NSObject

+ (TWModelEvent*)currentEvent;
+ (TWModelEvent*)createEvent:(TWModelEvent*)event ;
+ (TWModelEvent*)createDefaultEventWithTimerId:(int)tid;
+ (BOOL)updateEvent:(TWModelEvent*)event;
+ (BOOL)stopEvent:(TWModelEvent*)event;
@end
