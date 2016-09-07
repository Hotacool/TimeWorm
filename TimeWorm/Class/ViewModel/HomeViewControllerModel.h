//
//  HomeViewControllerModel.h
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewModel.h"
#import "TWBaseScene.h"

typedef NS_ENUM(NSUInteger, TWHomeVCDirection) {
    TWHomeVCDirectionNone = 0,
    TWHomeVCDirectionUp,
    TWHomeVCDirectionDown,
    TWHomeVCDirectionLeft,
    TWHomeVCDirectionRight
};

typedef NS_ENUM(NSUInteger, TWHomeVCScene) {
    TWHomeVCSceneHome = 0,
    TWHomeVCSceneWork,
    TWHomeVCSceneRelax,
    TWHomeVCSceneTimer
};

static const CGFloat HomeGestureMinimumTranslation = 20.0;
static const CGFloat HomeViewRemainderLength = 180;
static const CGFloat HomeViewAnimationDuration = 0.4f;

@interface HomeViewControllerModel : TWBaseViewModel

@property (nonatomic, assign, readonly) TWHomeVCScene scene;
@property (nonatomic, strong, readonly) TWBaseScene *currentScene;

- (void)postSwitchVCCommandWithDirection:(TWHomeVCDirection)direction ;
- (void)postMenuClickCommandWithBtnIndex:(NSUInteger)index ;
- (void)switchScene:(TWHomeVCScene)scene ;
- (void)switchScene:(TWHomeVCScene)scene withCompleteBlock:(void(^)(void))complete;
@end
