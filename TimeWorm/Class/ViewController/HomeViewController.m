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
#import "QBFlatButton.h"
#import "JZMultiChoicesCircleButton.h"

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

@property (nonatomic, strong) TWBaseScene *currentScene;
@property (nonatomic, strong) JZMultiChoicesCircleButton *menuBtn;
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
    self.view.backgroundColor = RGB_HEX(0xC3F8C8);
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
    
    self.currentScene = [[HomeScene alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.currentScene];
    
    [self.view addSubview:self.menuBtn];
    [self.menuBtn addObserver:self forKeyPath:@"isTouchDown" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.menuBtn) {
        if (self.menuBtn.isTouchDown) {
            [self.view removeGestureRecognizer:_panGesture];
        } else {
            [self.view addGestureRecognizer:_panGesture];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JZMultiChoicesCircleButton *)menuBtn {
    if (!_menuBtn) {
        NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"SendRound"],[UIImage imageNamed:@"CompleteRound"],[UIImage imageNamed:@"CalenderRound"],[UIImage imageNamed:@"MarkRound"],nil];
        NSArray *TextArray = [NSArray arrayWithObjects: [NSString stringWithFormat:@"Send"],[NSString stringWithFormat:@"Complete"],[NSString stringWithFormat:@"Calender"],[NSString stringWithFormat:@"Mark"], nil];
        NSArray *TargetArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"ButtonOne"],[NSString stringWithFormat:@"ButtonTwo"],[NSString stringWithFormat:@"ButtonThree"],[NSString stringWithFormat:@"ButtonFour"] ,nil];
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
    }
    return _menuBtn;
}

- (void)startGame:(UIButton*)sender {
    DDLogInfo(@"%s", __func__);
    
}

- (void)doStartGameAnimationWithPoint:(CGPoint)point {
    UIBezierPath* origionPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x , point.y, 0, 0)];
    
    CGFloat X = [UIScreen mainScreen].bounds.size.width - point.x;
    CGFloat Y = [UIScreen mainScreen].bounds.size.height - point.y;
    CGFloat radius = sqrtf(X * X + Y * Y);
    UIBezierPath* finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(point.x , point.y, 0, 0), -radius, -radius)];
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = finalPath.CGPath;
    layer.fillColor = [UIColor yellowColor].CGColor;
//    self.view.layer.mask = layer;
    [self.view.layer addSublayer:layer];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.delegate = self;
    animation.fromValue = (__bridge id _Nullable)(origionPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 0.25;
    [layer addAnimation:animation forKey:@"path"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    self.view.layer.mask = nil;
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recongnizer {
    if (self.menuBtn.isTouchDown) {
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

#pragma mark -- menu btn clicked
- (void)ButtonOne
{
    NSLog(@"BUtton 1 Seleted");
}
- (void)ButtonTwo
{
    NSLog(@"BUtton 2 Seleted");
}
- (void)ButtonThree
{
    NSLog(@"BUtton 3 Seleted");
}
- (void)ButtonFour
{
    NSLog(@"BUtton 4 Seleted");
}

#pragma mark -- command action
- (void)response2selectScene {
    DDLogInfo(@"%s", __func__);
}
@end
