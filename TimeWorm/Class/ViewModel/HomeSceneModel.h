//
//  HomeSceneModel.h
//  TimeWorm
//
//  Created by macbook on 16/9/1.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewModel.h"

typedef  NS_ENUM(NSUInteger, HomeSceneModelState) {
    HomeSceneModelStateNone = 0,
    HomeSceneModelStateWaiting
};

@interface HomeSceneModel : TWBaseViewModel
@property (nonatomic, assign) HomeSceneModelState state;
@property (nonatomic, assign) NSUInteger shiftDirection;

@end
