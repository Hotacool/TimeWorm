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
#import "TWEvent.h"
#import "TWSet.h"

@interface TWClockSetting () <STClockViewDelegate, TWTimerObserver>

@property (strong, nonatomic) STTimerClockView *clockView;
@end

@implementation TWClockSetting {
    TWModelTimer *curTimer;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Time Set", @"");
        self.contentSizeInPopup = TWPopViewControllerSize;
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        curTimer = [TWTimer currentTimer];
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
    [self.clockView setClockSeconds:curTimer.remainderSeconds];
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
    if (!curTimer) {
        [MozTopAlertView showOnWindowWithType:MozAlertTypeError text:NSLocalizedString(@"set a new Timer.", @"") doText:nil doBlock:nil];
        return;
    }
    TWMoreInfoPage *morePage = [TWMoreInfoPage new];
    [morePage bindTimer:curTimer];
    [self.popupController pushViewController:morePage animated:YES];
}

- (STTimerClockView *)clockView {
    if (!_clockView) {
        _clockView = [[STTimerClockView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height)];
        _clockView.delegate = self;
    }
    return _clockView;
}

- (void)bindTimer:(TWModelTimer *)timer {
    curTimer = timer;
}

#pragma mark -- STClockViewDelegate
- (void)clockView:(STClockView *)clockView startTimerWithSeconds:(NSUInteger)seconds {
    curTimer = [TWTimer createTimerWithName:[TWSet currentSet].defaultTimerName seconds:(int)seconds];
    [TWTimer activeTimer:curTimer];

}

- (void)stopTimerOfClockView:(STClockView *)clockView {
    [TWTimer cancelTimer:curTimer];
    if ([TWEvent currentEvent]&&![TWEvent currentEvent].stopDate) {
        [TWEvent stopEvent:[TWEvent currentEvent]];
    }
}

#pragma mark -- Timer
- (void)tickTime {
    int remainder = [TWTimer currentTimer].remainderSeconds <= 0 ? 0 : [TWTimer currentTimer].remainderSeconds;
    [self.clockView tickTime:remainder];
}
@end
