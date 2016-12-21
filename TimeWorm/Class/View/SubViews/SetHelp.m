//
//  SetHelp.m
//  TimeWorm
//
//  Created by macbook on 16/12/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetHelp.h"
#import "TWIntroPage.h"

@interface SetHelp ()

@end

@implementation SetHelp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.title = @"SetHelp";
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"帮助" handler:^(BOTableViewSection *section) {
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Tips" key:nil handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{
                [TWUtility jump2Tips];
            };
        }]];
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"引导" key:nil handler:^(BOButtonTableViewCell* cell) {
            cell.actionBlock = ^{                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                if (window) {
                    [TWIntroPage showIntroPageInView:window];
                }
            };
        }]];
    }]];
    
}

@end
