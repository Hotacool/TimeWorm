//
//  TWSwipeViewController.h
//  TimeWorm
//
//  Created by macbook on 16/12/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewController.h"

typedef NS_ENUM(NSUInteger, TWSwipeVCDirection) {
    TWSwipeVCDirectionNone = 0,
    TWSwipeVCDirectionUp,
    TWSwipeVCDirectionDown,
    TWSwipeVCDirectionLeft,
    TWSwipeVCDirectionRight
};


@interface TWSwipeViewController : TWBaseViewController

- (void)directionChangedFrom:(TWSwipeVCDirection)from to:(TWSwipeVCDirection)to ;
@end
