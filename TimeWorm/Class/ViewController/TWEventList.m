//
//  TWEventList.m
//  TimeWorm
//
//  Created by macbook on 16/10/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEventList.h"
#import <STPopup/STPopup.h>
#import "HACFoldTableView.h"
@interface TWEventList ()
@property (nonatomic, strong) HACFoldTableView *tableView;

@end

@implementation TWEventList

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Event Set", @"");
        self.contentSizeInPopup = TWPopViewControllerSize;
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (HACFoldTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HACFoldTableView alloc] initWithFrame:CGRectMake(2, 1, self.contentSizeInPopup.width-4, self.contentSizeInPopup.height-2)];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
