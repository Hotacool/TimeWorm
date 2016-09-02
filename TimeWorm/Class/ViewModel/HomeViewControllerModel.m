//
//  HomeViewControllerModel.m
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeViewControllerModel.h"
#import "HomeScene.h"
#import "WorkScene.h"

@interface HomeViewControllerModel () {
    NSString *_title;
}

@property (nonatomic, assign, readwrite) TWHomeVCScene scene;
@property (nonatomic, strong, readwrite) TWBaseScene *currentScene;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, TWBaseScene*> *sceneDic;
@end

@implementation HomeViewControllerModel
@synthesize title=_title;
- (instancetype)init {
    if (self = [super init]) {
        _title = @"Home";
        _scene = TWHomeVCSceneHome;
    }
    return self;
}

- (TWBaseScene *)currentScene {
    _currentScene = [self createScene:self.scene];
    return _currentScene;
}

- (NSMutableDictionary<NSNumber *,TWBaseScene *> *)sceneDic {
    if (!_sceneDic) {
        _sceneDic = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return _sceneDic;
}

- (void)postSwitchVCCommandWithDirection:(TWHomeVCDirection)direction {
    switch (direction) {
        case TWHomeVCDirectionUp: {
            [TWCommandCenter doActionWithCommand:@"upShift"];
            break;
        }
        case TWHomeVCDirectionDown: {
            [TWCommandCenter doActionWithCommand:@"downShift"];
            break;
        }
        case TWHomeVCDirectionLeft: {
            [TWCommandCenter doActionWithCommand:@"leftShift"];
            break;
        }
        case TWHomeVCDirectionRight: {
            [TWCommandCenter doActionWithCommand:@"rightShift"];
            break;
        }
        case TWHomeVCDirectionNone: {
            
            break;
        }
    }
}

- (void)switchScene:(TWHomeVCScene)scene {
    if (self.scene == scene) {
        return;
    }
    self.scene = scene;
    [self createScene:scene];
}

- (void)switchScene:(TWHomeVCScene)scene withCompleteBlock:(void (^)(void))complete {
    
}

- (TWBaseScene*)createScene:(TWHomeVCScene)scene {
    TWBaseScene *ret;
    if ([self.sceneDic.allKeys containsObject:@(scene)]) {
        ret = [self.sceneDic objectForKey:@(scene)];
    } else {
        switch (scene) {
            case TWHomeVCSceneHome: {
                ret = [[HomeScene alloc] initWithFrame:[UIScreen mainScreen].bounds];
                break;
            }
            case TWHomeVCSceneWork: {
                ret = [[WorkScene alloc] initWithFrame:[UIScreen mainScreen].bounds];
                break;
            }
            case TWHomeVCSceneRelax: {
                
                break;
            }
            case TWHomeVCSceneTimer: {
                
                break;
            }
        }
        [self.sceneDic setObject:ret forKey:@(scene)];
    }
    return ret;
}

#pragma mark -- command action
- (void)response2selectScene {
    DDLogInfo(@"%s", __func__);
}

@end
