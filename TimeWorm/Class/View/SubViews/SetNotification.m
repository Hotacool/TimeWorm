//
//  SetNotification.m
//  TimeWorm
//
//  Created by macbook on 16/11/24.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetNotification.h"
#import "HACSwitchTableViewCell.h"
#import "TWSet.h"

@interface SetNotification ()

@end

@implementation SetNotification

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    self.title = @"Bohr";
    
    SBWS(weakSelf)
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"通知" handler:^(BOTableViewSection *section) {
        [section addCell:[HACSwitchTableViewCell cellWithTitle:@"开启通知" key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].isNotifyOn;
            cell.changeBlk = ^(BOOL isOn) {
                NSLog(@"switch value: %d", isOn);
                [TWSet updateSetColumn:@"isNotifyOn" withObj:@(isOn)];
            };
        }]];
    }]];
    
}

@end
