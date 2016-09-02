//
//  TWBaseViewModel.m
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewModel.h"

@implementation TWBaseViewModel

- (void)attatchCommand:(BOOL)y {
    if (y) {
        [TWCommandCenter attache2Center:self];
    } else {
        [TWCommandCenter deattach:self];
    }
}
@end
