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

@interface TodayViewController () <NCWidgetProviding>
@property (nonatomic, strong) TWTimerBoard *timeBoard;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDefaultsDidChange:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
    self.preferredContentSize = CGSizeMake(0, 110);
    [self.view addSubview:self.timeBoard];
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNumberLabelText];
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateNumberLabelText];
}

- (void)updateNumberLabelText {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.TimeWorm"];
    id obj = [defaults objectForKey:@"TWUserDic"];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *userDic = obj;
        NSUInteger state = [[userDic objectForKey:@"state"] integerValue];
        NSDate *startDate = [userDic objectForKey:@"start"];
        NSUInteger seconds = [[userDic objectForKey:@"remainderSeconds"] integerValue];
        [self.timeBoard setSeconds:seconds];
        [self.timeBoard setState:state];
        [self.timeBoard setStartDate:startDate];
    }
}

- (void)tapMe:(UITapGestureRecognizer*)gesture {
    NSLog(@"%s", __func__);
    [self.extensionContext openURL:[NSURL URLWithString:@"TWWidgetApp://action=GotoHomePage"] completionHandler:^(BOOL success) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TWTimerBoard *)timeBoard {
    if (!_timeBoard) {
        _timeBoard = [[TWTimerBoard alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 110)];
    }
    return _timeBoard;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

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
