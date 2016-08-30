//
//  TWBaseViewController.m
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWBaseViewController.h"

@interface TWBaseViewController ()

@end

@implementation TWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TWBaseViewModel *)viewModel {
    if (!_viewModel) {
        NSString *viewModelClassStr = [NSStringFromClass([self class]) stringByAppendingString:@"Model"];
        _viewModel = [NSClassFromString(viewModelClassStr) new];
    }
    return _viewModel;
}

@end
