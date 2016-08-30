//
//  HomeViewController.m
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewControllerModel.h"
#import "HomeScene.h"

typedef NS_ENUM(NSUInteger, TWHomeVCDirection) {
    TWHomeVCDirectionNone = 0,
    TWHomeVCDirectionUp,
    TWHomeVCDirectionDown,
    TWHomeVCDirectionLeft,
    TWHomeVCDirectionRight
};

@interface HomeViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) HomeViewControllerModel *hvm;
@property (nonatomic, strong) NSMutableDictionary *viewControllerDic;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) TWHomeVCDirection direction;
@property (nonatomic, assign) TWHomeVCDirection activeDirection;
@end

@implementation HomeViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hvm = (HomeViewControllerModel*)self.viewModel;
    }
    return self;
}

- (NSMutableDictionary *)viewControllerDic {
    if (!_viewControllerDic) {
        _viewControllerDic = [NSMutableDictionary dictionaryWithCapacity:4];
        for (int i = 1; i <= 4; i++) {
            UIViewController *ctrl = [[UIViewController alloc] init];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
            label.center = ctrl.view.center;
            label.backgroundColor = [UIColor yellowColor];
            label.text = [@"viewController_" stringByAppendingFormat:@"%d",i];
            [ctrl.view addSubview:label];
            [_viewControllerDic setObject:ctrl forKey:@(i)];
        }
    }
    return _viewControllerDic;
}

- (UIViewController*)viewControllerAtDirection:(TWHomeVCDirection)direction {
    UIViewController *ret;
    if (direction > 0&&self.viewControllerDic.count >= direction) {
        ret = self.viewControllerDic[@(direction)];
    }
    return ret;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TWCommandCenter attache2Center:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TWCommandCenter deattach:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    DDLogInfo(self.title);
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
    
    HomeScene *scene = [[HomeScene alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scene.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scene];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recongnizer {
    CGPoint translation = [recongnizer translationInView: self.view];
    if (recongnizer.state == UIGestureRecognizerStateBegan) {
        self.direction = TWHomeVCDirectionNone;
    } else if (recongnizer.state == UIGestureRecognizerStateChanged && self.direction == TWHomeVCDirectionNone) {
        self.direction = [self determineDirectionIfNeeded:translation];
        // ok, now initiate movement in the direction indicated by the user's gesture
        [self switchViewController];
    } else if (recongnizer.state == UIGestureRecognizerStateEnded) {
        // now tell the camera to stop
        DDLogInfo(@"stop");
    }
}

- (TWHomeVCDirection)determineDirectionIfNeeded:(CGPoint)translation {
    TWHomeVCDirection direction = self.direction;
    if (self.direction != TWHomeVCDirectionNone) {
        return direction;
    }
    // determine if horizontal swipe only if you meet some minimum velocity
    if (fabs(translation.x) > HomeGestureMinimumTranslation) {
        BOOL gestureHorizontal = NO;
        if (translation.y == 0.0 ) {
            gestureHorizontal = YES;
        } else {
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        }
        
        if (gestureHorizontal) {
            if (translation.x > 0.0 ) {
                return TWHomeVCDirectionLeft;
            } else {
                return TWHomeVCDirectionRight;
            }
        }
    } else if (fabs(translation.y) > HomeGestureMinimumTranslation) {
        // determine if vertical swipe only if you meet some minimum velocity
        BOOL gestureVertical = NO;
        if (translation.x == 0.0 ) {
            gestureVertical = YES;
        } else {
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        }
        if (gestureVertical) {
            if (translation.y > 0.0 ) {
                return TWHomeVCDirectionUp;
            } else {
                return TWHomeVCDirectionDown;
            }
        }
    }
    return direction;
}

- (void)switchViewController {
    DDLogInfo(@"direction: %lu", (unsigned long)self.direction);
    CGRect rect = [UIScreen mainScreen].bounds;
    if (self.activeDirection == self.direction) {
        return;
    }
    UIViewController *ctrl;
    switch (self.direction) {
        case TWHomeVCDirectionUp: {
            if (self.activeDirection == TWHomeVCDirectionDown) {
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
            } else if (self.activeDirection == TWHomeVCDirectionNone) {
                self.activeDirection = self.direction;
                ctrl = self.viewControllerDic[@(self.direction)];
                [self addChildViewController:ctrl];
                [self.view addSubview:ctrl.view];
                ctrl.view.frame = CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height);
                [ctrl didMoveToParentViewController:self];
                
                [UIView animateWithDuration:HomeViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.view.frame = CGRectMake(0, rect.size.height - HomeViewRemainderLength, rect.size.width, rect.size.height);
                } completion:^(BOOL finished) {
                }];
            }
            break;
        }
        case TWHomeVCDirectionDown: {
            if (self.activeDirection == TWHomeVCDirectionUp) {
                self.activeDirection = TWHomeVCDirectionNone;
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
            } else if (self.activeDirection == TWHomeVCDirectionNone) {
                self.activeDirection = self.direction;
                ctrl = self.viewControllerDic[@(self.direction)];
                [self addChildViewController:ctrl];
                [self.view addSubview:ctrl.view];
                ctrl.view.frame = CGRectMake(0, rect.size.height, rect.size.width, rect.size.height);
                [ctrl didMoveToParentViewController:self];
                
                [UIView animateWithDuration:HomeViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.view.frame = CGRectMake(0, HomeViewRemainderLength - rect.size.height, rect.size.width, rect.size.height);
                } completion:^(BOOL finished) {
                }];
            }
            break;
        }
        case TWHomeVCDirectionLeft: {
            if (self.activeDirection == TWHomeVCDirectionRight) {
                self.activeDirection = TWHomeVCDirectionNone;
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
            } else if (self.activeDirection == TWHomeVCDirectionNone) {
                self.activeDirection = self.direction;
                ctrl = self.viewControllerDic[@(self.direction)];
                [self addChildViewController:ctrl];
                [self.view addSubview:ctrl.view];
                ctrl.view.frame = CGRectMake(-rect.size.width, 0, rect.size.width, rect.size.height);
                [ctrl didMoveToParentViewController:self];
                
                [UIView animateWithDuration:HomeViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.view.frame = CGRectMake(HomeViewRemainderLength, 0, rect.size.width, rect.size.height);
                } completion:^(BOOL finished) {
                }];
            }
            break;
        }
        case TWHomeVCDirectionRight: {
            if (self.activeDirection == TWHomeVCDirectionLeft) {
                self.activeDirection = TWHomeVCDirectionNone;
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
            } else if (self.activeDirection == TWHomeVCDirectionNone) {
                self.activeDirection = self.direction;
                ctrl = self.viewControllerDic[@(self.direction)];
                [self addChildViewController:ctrl];
                [self.view addSubview:ctrl.view];
                ctrl.view.frame = CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height);
                [ctrl didMoveToParentViewController:self];
                
                [UIView animateWithDuration:HomeViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.view.frame = CGRectMake(HomeViewRemainderLength - rect.size.width, 0, rect.size.width, rect.size.height);
                } completion:^(BOOL finished) {
                }];

            }
            break;
        }
        case TWHomeVCDirectionNone: {
            break;
        }
    }
}

- (void)resetView2CenterWithDirection:(TWHomeVCDirection)direction {
    CGRect rect = [UIScreen mainScreen].bounds;
    UIViewController *ctrl = self.viewControllerDic[@(direction)];
    [UIView animateWithDuration:HomeViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    } completion:^(BOOL finished) {
        [ctrl willMoveToParentViewController:nil];
        [ctrl.view removeFromSuperview];
        [ctrl removeFromParentViewController];
    }];
}

#pragma mark -- command action
- (void)response2selectScene {
    DDLogInfo(@"%s", __func__);
}
@end
