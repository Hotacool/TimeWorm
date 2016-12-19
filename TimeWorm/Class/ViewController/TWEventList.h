//
//  TWEventList.h
//  TimeWorm
//
//  Created by macbook on 16/10/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWSwipeViewController.h"
#import "TWModelTimer.h"
@interface TWEventList : TWSwipeViewController

- (void)bindTimer:(TWModelTimer *)timer;
@end
