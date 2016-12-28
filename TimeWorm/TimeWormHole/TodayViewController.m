//
//  TodayViewController.m
//  TimeWormHole
//
//  Created by macbook on 16/12/14.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TWTimerBoard.h"
#import "TWShareDataModel.h"

static const CGFloat TodayViewDefaultHeightIniOS10 = 110;
@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) TWShareDataModel *shareData;
@property (nonatomic, strong) TWTimerBoard *timeBoard;
@end

@implementation TodayViewController {
    NSTimer *tickTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
    self.preferredContentSize = CGSizeMake(0, TodayViewDefaultHeightIniOS10);
    [self.view addSubview:self.timeBoard];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTickTimer];
    self.shareData.enterBack = [NSDate date];
    [self updateData];
}

- (void)updateNumberLabelText {
    [self refreshData];
    if (self.shareData) {
        self.timeBoard.name = self.shareData.timerName;
        if (self.shareData.state == 2) {
            [self.timeBoard setState:TWTimerBoardStateFlow];
            [self.timeBoard setSeconds:self.shareData.seconds];
            [self.timeBoard setStartDate:self.shareData.startDate];
            [self startTickTimer];
        } else if (self.shareData.state == 4 || self.shareData.state == 8) {
            [self.timeBoard setState:TWTimerBoardStatePause];
            [self.timeBoard setSeconds:self.shareData.seconds];
            [self.timeBoard setStartDate:self.shareData.startDate];
            [self stopTickTimer];
        } else {
            [self.timeBoard setState:TWTimerBoardStateNone];
            [self.timeBoard setSeconds:0];
            [self stopTickTimer];
        }
    }
}

- (void)tapMe:(UITapGestureRecognizer*)gesture {
    NSString *urlStr = [NSString stringWithFormat:@"TWWidgetApp://timerId=%@", self.shareData.identifier];
    [self.extensionContext openURL:[NSURL URLWithString:urlStr] completionHandler:^(BOOL success) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.TimeWorm"];
    id obj = [defaults objectForKey:@"TWUserDic"];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        self.shareData = [[TWShareDataModel alloc] initWithUserDic:obj];
        if (self.shareData.state == 2) {
            NSDate *now = [NSDate date];
            NSTimeInterval interval = [now timeIntervalSinceDate:self.shareData.enterBack];
            int remainder = self.shareData.seconds - interval;
            if (remainder < 0) {
                self.shareData.seconds = 0;
            } else {
                self.shareData.seconds = remainder;
            }
        }
    }
}

- (void)updateData {
    if (!self.shareData) {
        return;
    }
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.TimeWorm"];
    [shared setObject:[self.shareData userDic]
               forKey:@"TWUserDic"];
    [shared synchronize];
}

- (TWTimerBoard *)timeBoard {
    if (!_timeBoard) {
        _timeBoard = [[TWTimerBoard alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TodayViewDefaultHeightIniOS10)];
        [_timeBoard setState:TWTimerBoardStateNone];
    }
    return _timeBoard;
}

- (void)startTickTimer {
    [self stopTickTimer];
    if (self.shareData.seconds <= 0) {
        return;
    }
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        --self.shareData.seconds;
        [self.timeBoard setSeconds:self.shareData.seconds];
        if (self.shareData.seconds <= 0) {
            [timer invalidate];
        }
    }];
}

- (void)stopTickTimer {
    if (tickTimer && tickTimer.isValid) {
        [tickTimer invalidate];
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self updateNumberLabelText];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    } else if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(0, 400);
    }
}

@end
