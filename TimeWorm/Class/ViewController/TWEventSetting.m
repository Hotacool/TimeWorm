//
//  TWEventSetting.m
//  TimeWorm
//
//  Created by macbook on 16/9/12.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEventSetting.h"
#import <STPopup/STPopup.h>

@interface TWEventSetting ()

@end

@implementation TWEventSetting

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Event Set", @"");
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnDidTap)];
    self.view.backgroundColor = Haqua;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextBtnDidTap {
    [MozTopAlertView showOnWindowWithType:MozAlertTypeInfo text:NSLocalizedString(@"done", @"") doText:nil doBlock:nil];
}

@end
