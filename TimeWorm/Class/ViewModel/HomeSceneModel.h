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
    HomeSceneModelStateApothegm,
    HomeSceneModelStateNormal,
    HomeSceneModelStateAction
};

@interface HomeScenePpMsg : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *dispatchClassName;

@end

@interface HomeSceneModel : TWBaseViewModel
@property (nonatomic, assign) HomeSceneModelState state;
@property (nonatomic, strong) NSMutableArray <HomeScenePpMsg*>*messageList;

- (void)spriteActionStopped;

- (HomeScenePpMsg*)createRandomMessageToShow ;

- (HomeScenePpMsg*)currentMessage;
@end
