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
#import "HACircleButton.h"
#import "OLImageView.h"
#import <STPopup/STPopup.h>
#import <pop/POP.h>

@interface HomeViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) HomeViewControllerModel *hvm;

@property (nonatomic, strong) TWBaseScene *currentScene;
@property (nonatomic, strong) HACircleButton *menuBtn;
@end

@implementation HomeViewController {
    NSArray *menuTextArray;
}

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
    //加载场景
    [self loadScene];
    //初始化弹出界面navigationBar
    [self popupViewNavigationBarInit];
    //加载菜单按钮
    [self.view addSubview:self.menuBtn];
    [self.menuBtn addObserver:self forKeyPath:@"isActive" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- API
- (void)changeMenuButtonText:(NSString*)val atIndex:(NSUInteger)index {
    if (menuTextArray&&val) {
        if (menuTextArray.count > index) {
            NSMutableArray *tmp = [NSMutableArray arrayWithArray:menuTextArray];
            [tmp replaceObjectAtIndex:index withObject:val];
            menuTextArray = tmp;
            [self.menuBtn setImageArray:nil andTextArray:menuTextArray];
        }
    }
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
            NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"CalenderRound"],[UIImage imageNamed:@"CompleteRound"],[UIImage imageNamed:@"SendRound"],[UIImage imageNamed:@"MarkRound"],nil];
            menuTextArray = [NSArray arrayWithObjects:
                                  NSLocalizedString(@"menuBtn2", @""),
                                  NSLocalizedString(@"menuBtn4", @""),
                                  NSLocalizedString(@"menuBtn3", @""),
                                  NSLocalizedString(@"menuBtn1", @""), nil];
            [self.menuBtn setImageArray:IconArray andTextArray:menuTextArray];
            [self.menuBtn setTransitionAniOffArr:@[@(NO)
                                                   ,@(NO)
                                                   ,@(NO)
                                                   ,@(NO)]];
            [self.menuBtn setMode:HACircleButtonModeMultiple];
            break;
        }
        case TWHomeVCSceneWork: {
            menuTextArray = @[NSLocalizedString(@"wMenuBtn2", @"")
                              ,NSLocalizedString(@"wMenuBtn4", @"")
                              ,NSLocalizedString(@"wMenuBtn3", @"")
                              ,NSLocalizedString(@"wMenuBtn1", @"")];
            [self.menuBtn setImageArray:nil
                           andTextArray:menuTextArray];
            [self.menuBtn setTransitionAniOffArr:@[@(YES)
                                                   ,@(NO)
                                                   ,@(YES)
                                                   ,@(YES)]];
            [self.menuBtn setMode:HACircleButtonModeMultiple];
            break;
        }
        case TWHomeVCSceneRelax: {
            break;
        }
        case TWHomeVCSceneRecord: {
            [self.menuBtn setMode:HACircleButtonModeSingle];
            break;
        }
        default:
            break;
    }
}

- (HACircleButton *)menuBtn {
    if (!_menuBtn) {
        NSArray *IconArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"SendRound"],[UIImage imageNamed:@"CompleteRound"],[UIImage imageNamed:@"CalenderRound"],[UIImage imageNamed:@"MarkRound"],nil];
        menuTextArray = [NSArray arrayWithObjects:
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
        _menuBtn = [[HACircleButton alloc] initWithCenterPoint:CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height - 100 )
                                                                ButtonIcon:[UIImage imageNamed:@"send"]
                                                               SmallRadius:30.0f
                                                                 BigRadius:100
                                                              ButtonNumber:4
                                                                ButtonIcon:IconArray
                                                                ButtonText:menuTextArray
                                                              ButtonTarget:TargetArray
                                                               UseParallex:YES
                                                         ParallaxParameter:100
                                                     RespondViewController:self];
        _menuBtn.title = NSLocalizedString(@"menuBtn", @"");
    }
    return _menuBtn;
}

- (void)popupViewNavigationBarInit {
    [STPopupNavigationBar appearance].barTintColor = Hdarkgray;
    [STPopupNavigationBar appearance].tintColor = [UIColor whiteColor];
    [STPopupNavigationBar appearance].barStyle = UIBarStyleDefault;
    [STPopupNavigationBar appearance].titleTextAttributes = @{ NSFontAttributeName: [UIFont fontWithName:@"Cochin" size:18],
                                                               NSForegroundColorAttributeName: [UIColor whiteColor] };
}

#pragma mark -- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.menuBtn) {
        
    } else if (object == self.hvm) {
        if ([keyPath isEqualToString:@"scene"]) {
            if (self.currentScene == self.hvm.currentScene) {
                return;
            } else {
                [self loadScene];
                [self loadUIComponents];
                if (self.hvm.scene == TWHomeVCSceneRecord) {
                    [self raiseMenu:NO];
                } else {
                    [self raiseMenu:YES];
                }
            }
        }
    }
}
#pragma mark -- menu btn clicked
- (void)ButtonOne {
    NSLog(@"BUtton 1 Seleted");
    [self.menuBtn completeWithMessage:@"Start"];
    [self.hvm postMenuClickCommandWithBtnIndex:1];
}
- (void)ButtonTwo {
    NSLog(@"BUtton 2 Seleted");
    [self.menuBtn completeWithMessage:@"Start"];
    [self.hvm postMenuClickCommandWithBtnIndex:2];
}
- (void)ButtonThree {
    NSLog(@"BUtton 3 Seleted");
    [self.menuBtn completeWithMessage:@"Start"];
    [self.hvm postMenuClickCommandWithBtnIndex:3];
}
- (void)ButtonFour {
    NSLog(@"BUtton 4 Seleted");
    [self.menuBtn completeWithMessage:@"Start"];
    [self.hvm postMenuClickCommandWithBtnIndex:4];
}
- (void)circleBttonTouchDown {
    sfuc
    [self.menuBtn completeWithMessage:@"Start"];
    [self.hvm postMenuClickCommandWithBtnIndex:5];
}
#pragma mark - menu position animation
- (void)raiseMenu:(BOOL)r {
    if (r) {
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        ani.fromValue = [NSValue valueWithCGPoint:self.menuBtn.center];
        ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height - 100)];
        ani.springSpeed = 6;
        ani.springBounciness = 16;
        [self.menuBtn pop_addAnimation:ani forKey:@"raiseMenu"];
    } else {
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        ani.fromValue = [NSValue valueWithCGPoint:self.menuBtn.center];
        ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width / 2 , self.view.frame.size.height - self.menuBtn.height/2 - 1)];
        ani.springSpeed = 6;
        ani.springBounciness = 16;
        [self.menuBtn pop_addAnimation:ani forKey:@"raiseMenuDown"];
    }
}
@end
