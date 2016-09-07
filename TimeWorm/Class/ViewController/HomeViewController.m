//
//  HomeViewController.m
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewControllerModel.h"
#import "QBFlatButton.h"
#import "JZMultiChoicesCircleButton.h"
#import "OLImageView.h"


@interface HomeViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) HomeViewControllerModel *hvm;
@property (nonatomic, strong) NSMutableDictionary *viewControllerDic;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) TWHomeVCDirection direction;
@property (nonatomic, assign) TWHomeVCDirection activeDirection;

@property (nonatomic, strong) TWBaseScene *currentScene;
@property (nonatomic, strong) JZMultiChoicesCircleButton *menuBtn;
@end

@implementation HomeViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hvm = (HomeViewControllerModel*)self.viewModel;
        [self.hvm addObserver:self forKeyPath:@"scene" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.hvm attatchCommand:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.hvm attatchCommand:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_HEX(0xC3F8C8);
    //加载切换page手势
    [self loadSwitchVCPanGesture];
    //加载场景
    [self loadScene];
    //加载菜单按钮
    [self.view addSubview:self.menuBtn];
    [self.menuBtn addObserver:self forKeyPath:@"isActive" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Scene load
- (void)loadScene {
    if ([self.currentScene superview]) {
        [self.currentScene removeFromSuperview];
    }
    self.currentScene = self.hvm.currentScene;
    self.currentScene.ctrl = self;
    [self.view insertSubview:self.currentScene atIndex:0];
    [self.currentScene show];
}

#pragma mark -- ui components
- (void)loadUIComponents {
    switch (self.hvm.scene) {
        case TWHomeVCSceneHome: {
            NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"SendRound"],[UIImage imageNamed:@"CompleteRound"],[UIImage imageNamed:@"CalenderRound"],[UIImage imageNamed:@"MarkRound"],nil];
            NSArray *TextArray = [NSArray arrayWithObjects:
                                  NSLocalizedString(@"menuBtn2", @""),
                                  NSLocalizedString(@"menuBtn4", @""),
                                  NSLocalizedString(@"menuBtn3", @""),
                                  NSLocalizedString(@"menuBtn1", @""), nil];
            [self.menuBtn setImageArray:IconArray andTextArray:TextArray];
            break;
        }
        case TWHomeVCSceneWork: {
            [self.menuBtn setImageArray:nil
                           andTextArray:@[NSLocalizedString(@"wMenuBtn2", @"")
                                                           ,NSLocalizedString(@"wMenuBtn4", @"")
                                                           ,NSLocalizedString(@"wMenuBtn3", @"")
                                                           ,NSLocalizedString(@"wMenuBtn1", @"")]];
            break;
        }
        case TWHomeVCSceneRelax: {
            
            break;
        }
        case TWHomeVCSceneTimer: {
            
            break;
        }
        default:
            break;
    }
}

- (JZMultiChoicesCircleButton *)menuBtn {
    if (!_menuBtn) {
        NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"SendRound"],[UIImage imageNamed:@"CompleteRound"],[UIImage imageNamed:@"CalenderRound"],[UIImage imageNamed:@"MarkRound"],nil];
        NSArray *TextArray = [NSArray arrayWithObjects:
                              NSLocalizedString(@"menuBtn2", @""),
                              NSLocalizedString(@"menuBtn4", @""),
                              NSLocalizedString(@"menuBtn3", @""),
                              NSLocalizedString(@"menuBtn1", @""), nil];
        NSArray *TargetArray = [NSArray arrayWithObjects:
                                [NSString stringWithFormat:@"ButtonTwo"],
                                [NSString stringWithFormat:@"ButtonFour"],
                                [NSString stringWithFormat:@"ButtonThree"] ,
                                [NSString stringWithFormat:@"ButtonOne"],
                                nil];
        _menuBtn = [[JZMultiChoicesCircleButton alloc] initWithCenterPoint:CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height - 100 )
                                                                ButtonIcon:[UIImage imageNamed:@"send"]
                                                               SmallRadius:30.0f
                                                                 BigRadius:100
                                                              ButtonNumber:4
                                                                ButtonIcon:IconArray
                                                                ButtonText:TextArray
                                                              ButtonTarget:TargetArray
                                                               UseParallex:YES
                                                         ParallaxParameter:100
                                                     RespondViewController:self];
        _menuBtn.title = NSLocalizedString(@"menuBtn", @"");
    }
    return _menuBtn;
}
//Pages
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
            ctrl.view.backgroundColor = RGB_HEX(0xC3F8C8);
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
#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.menuBtn) {
        if (self.menuBtn.isActive) {
            [self.view removeGestureRecognizer:_panGesture];
        } else {
            [self.view addGestureRecognizer:_panGesture];
        }
    } else if (object == self.hvm) {
        if ([keyPath isEqualToString:@"scene"]) {
            if (self.currentScene == self.hvm.currentScene) {
                return;
            } else {
                [self loadScene];
                [self loadUIComponents];
            }
        }
    }
}
#pragma mark -- viewController panGesture
- (void)loadSwitchVCPanGesture {
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recongnizer {
    if (self.menuBtn.isActive) {
        return;
    }
    CGPoint translation = [recongnizer translationInView: self.view];
    if (recongnizer.state == UIGestureRecognizerStateBegan) {
        self.direction = TWHomeVCDirectionNone;
    } else if (recongnizer.state == UIGestureRecognizerStateChanged && self.direction == TWHomeVCDirectionNone) {
        self.direction = [self determineDirectionIfNeeded:translation];
        // ok, now initiate movement in the direction indicated by the user's gesture
        [self switchViewController];
    } else if (recongnizer.state == UIGestureRecognizerStateEnded) {
        // now tell the camera to stop
//        DDLogInfo(@"stop");
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
//    DDLogInfo(@"direction: %lu", (unsigned long)self.direction);
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
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
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
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
            }
            break;
        }
        case TWHomeVCDirectionDown: {
            if (self.activeDirection == TWHomeVCDirectionUp) {
                self.activeDirection = TWHomeVCDirectionNone;
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
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
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
            }
            break;
        }
        case TWHomeVCDirectionLeft: {
            if (self.activeDirection == TWHomeVCDirectionRight) {
                self.activeDirection = TWHomeVCDirectionNone;
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
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
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
            }
            break;
        }
        case TWHomeVCDirectionRight: {
            if (self.activeDirection == TWHomeVCDirectionLeft) {
                self.activeDirection = TWHomeVCDirectionNone;
                [self resetView2CenterWithDirection:self.activeDirection];
                self.activeDirection = TWHomeVCDirectionNone;
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
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
                [self.hvm postSwitchVCCommandWithDirection:self.direction];
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
#pragma mark -- menu btn clicked
- (void)ButtonOne {
    NSLog(@"BUtton 1 Seleted");
    [self.hvm postMenuClickCommandWithBtnIndex:1];
    [self.menuBtn completeWithMessage:@"Start"];
}
- (void)ButtonTwo {
    NSLog(@"BUtton 2 Seleted");
    [self.hvm postMenuClickCommandWithBtnIndex:2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.menuBtn completeWithMessage:@"Start"];
    });
}
- (void)ButtonThree {
    NSLog(@"BUtton 3 Seleted");
    [self.hvm postMenuClickCommandWithBtnIndex:3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.menuBtn completeWithMessage:@"Start"];
    });
}
- (void)ButtonFour {
    NSLog(@"BUtton 4 Seleted");
    [self.hvm postMenuClickCommandWithBtnIndex:4];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.menuBtn completeWithMessage:@"Start"];
    });
}
@end
