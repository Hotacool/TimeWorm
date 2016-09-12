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

@interface TWClockSetting ()

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
    self.clockView = [[STTimerClockView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height)];
    [self.view addSubview:self.clockView];
    [self.clockView.timeBtn addTarget:self action:@selector(setClockTime:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.clockView bindCurrentTimer];
    [self.clockView transitionToShow:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.clockView transitionToHide:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextBtnDidTap {
//    [self.popupController pushViewController:[PopupViewController3 new] animated:YES];
}

- (void)setClockTime:(id)sender {
    sfuc
    
}
@end
