//
//  TWClockSetting.m
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWClockSetting.h"
#import <STPopup/STPopup.h>
#import "STTimerClockView.h"
#import "TWMoreInfoPage.h"
#import "TWTimer.h"

@interface TWClockSetting () <STClockViewDelegate, TWTimerObserver>

@property (strong, nonatomic) STTimerClockView *clockView;
@end

@implementation TWClockSetting

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Time Set", @"");
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ClockSetMore", @"") style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
    self.view.backgroundColor = Haqua;
    [self.view addSubview:self.clockView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.clockView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.clockView willShow];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TWTimer attatchObserver2Timer:self];
    [self.clockView setClockSeconds:[TWTimer currentTimer].remainderSeconds];
    [self.clockView transitionToShow:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [TWTimer removeObserverFromTimer:self];
    [self.clockView transitionToHide:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextBtnDidTap {
    [self.popupController pushViewController:[TWMoreInfoPage new] animated:YES];
}

- (STTimerClockView *)clockView {
    if (!_clockView) {
        _clockView = [[STTimerClockView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height)];
        _clockView.delegate = self;
    }
    return _clockView;
}

#pragma mark -- STClockViewDelegate
- (void)clockView:(STClockView *)clockView startTimerWithSeconds:(NSUInteger)seconds {
    [TWTimer createTimerWithName:@"clockTimer" seconds:(int)seconds];
    [TWTimer activeTimer:[TWTimer currentTimer]];

}

- (void)stopTimerOfClockView:(STClockView *)clockView {
    [TWTimer cancelTimer:[TWTimer currentTimer]];
}

#pragma mark -- Timer
- (void)tickTime {
    [self.clockView tickTime];
}
@end
