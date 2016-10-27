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
#import "RecordScene.h"

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
        _currentScene = [self createScene:_scene];
    }
    return self;
}

- (NSMutableDictionary<NSNumber *,TWBaseScene *> *)sceneDic {
    if (!_sceneDic) {
        _sceneDic = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return _sceneDic;
}

- (void)postMenuClickCommandWithBtnIndex:(NSUInteger)index {
    switch (index) {
        case 1: {
            switch (self.scene) {
                case TWHomeVCSceneHome: {
                    [self switchScene:TWHomeVCSceneWork];
                    break;
                }
                case TWHomeVCSceneWork: {
                    [TWCommandCenter doActionWithCommand:@"workScenePause"];
                    break;
                }
                case TWHomeVCSceneRecord: {
                    break;
                }
                case TWHomeVCSceneRelax: {
                    break;
                }
            }
            break;
        }
        case 2: {
            switch (self.scene) {
                case TWHomeVCSceneHome: {
                    break;
                }
                case TWHomeVCSceneWork: {
                    [TWCommandCenter doActionWithCommand:@"workSceneEvent"];
                    break;
                }
                case TWHomeVCSceneRecord: {
                    break;
                }
                case TWHomeVCSceneRelax: {
                    break;
                }
            }
            break;
        }
        case 3: {
            switch (self.scene) {
                case TWHomeVCSceneHome: {
                    [self switchScene:TWHomeVCSceneRecord];
                    break;
                }
                case TWHomeVCSceneWork: {
                    [TWCommandCenter doActionWithCommand:@"workSceneReset"];
                    break;
                }
                case TWHomeVCSceneRecord: {
                    break;
                }
                case TWHomeVCSceneRelax: {
                    break;
                }
            }
            break;
        }
        case 4: {
            switch (self.scene) {
                case TWHomeVCSceneHome: {
                    break;
                }
                case TWHomeVCSceneWork: {
                    [self switchScene:TWHomeVCSceneHome];
                    break;
                }
                case TWHomeVCSceneRecord: {
                    
                    break;
                }
                case TWHomeVCSceneRelax: {
                    
                    break;
                }
            }
            break;
        }
        case 5: {
            [self switchScene:TWHomeVCSceneHome];
        }
    }
}

- (void)switchScene:(TWHomeVCScene)scene {
    if (self.scene == scene) {
        return;
    }
    _currentScene = [self createScene:scene];
    self.scene = scene;
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
            case TWHomeVCSceneRecord: {
                ret = [[RecordScene alloc] initWithFrame:[UIScreen mainScreen].bounds];
                break;
            }
        }
        if (/* DISABLES CODE */ (0)) {
            [self.sceneDic setObject:ret forKey:@(scene)];
        }
    }
    return ret;
}

#pragma mark -- command action
- (void)response2selectScene {
    DDLogInfo(@"%s", __func__);
}

@end
