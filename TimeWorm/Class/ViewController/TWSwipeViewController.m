//
//  TWSwipeViewController.m
//  TimeWorm
//
//  Created by macbook on 16/12/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWSwipeViewController.h"

static const CGFloat TWSwipeMinimumTranslation = 30.f;
@interface TWSwipeViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) TWSwipeVCDirection direction;
@end

@implementation TWSwipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载切换page手势
    [self loadSwitchVCPanGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- viewController panGesture
- (void)loadSwitchVCPanGesture {
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)recongnizer {
    CGPoint translation = [recongnizer translationInView: self.view];
    if (recongnizer.state == UIGestureRecognizerStateBegan) {
        self.direction = TWSwipeVCDirectionNone;
    } else if (recongnizer.state == UIGestureRecognizerStateChanged && self.direction == TWSwipeVCDirectionNone) {
        TWSwipeVCDirection tmp = self.direction;
        self.direction = [self determineDirectionIfNeeded:translation];
        // ok, now initiate movement in the direction indicated by the user's gesture
        [self directionChangedFrom:tmp to:self.direction];
    } else if (recongnizer.state == UIGestureRecognizerStateEnded) {
        // now tell the camera to stop
        //        DDLogInfo(@"stop");
    }
}

- (TWSwipeVCDirection)determineDirectionIfNeeded:(CGPoint)translation {
    TWSwipeVCDirection direction = self.direction;
    if (self.direction != TWSwipeVCDirectionNone) {
        return direction;
    }
    // determine if horizontal swipe only if you meet some minimum velocity
    if (fabs(translation.x) > TWSwipeMinimumTranslation) {
        BOOL gestureHorizontal = NO;
        if (translation.y == 0.0 ) {
            gestureHorizontal = YES;
        } else {
            gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
        }
        
        if (gestureHorizontal) {
            if (translation.x > 0.0 ) {
                return TWSwipeVCDirectionLeft;
            } else {
                return TWSwipeVCDirectionRight;
            }
        }
    } else if (fabs(translation.y) > TWSwipeMinimumTranslation) {
        // determine if vertical swipe only if you meet some minimum velocity
        BOOL gestureVertical = NO;
        if (translation.x == 0.0 ) {
            gestureVertical = YES;
        } else {
            gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        }
        if (gestureVertical) {
            if (translation.y > 0.0 ) {
                return TWSwipeVCDirectionUp;
            } else {
                return TWSwipeVCDirectionDown;
            }
        }
    }
    return direction;
}

- (void)directionChangedFrom:(TWSwipeVCDirection)from to:(TWSwipeVCDirection)to {
    //override
}
@end
