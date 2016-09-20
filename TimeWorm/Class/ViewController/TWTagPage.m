//
//  TWTagPage.m
//  TimeWorm
//
//  Created by macbook on 16/9/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTagPage.h"
#import <STPopup/STPopup.h>

@interface TWTagPage ()

@end

@implementation TWTagPage

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"tag select";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Haqua;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
