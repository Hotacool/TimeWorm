//
//  SetDefault.m
//  TimeWorm
//
//  Created by macbook on 16/11/24.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetDefault.h"
#import "HACSwitchTableViewCell.h"
#import "TWSet.h"

@interface SetDefault ()

@end

@implementation SetDefault

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
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"主题" handler:^(BOTableViewSection *section) {
        
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"后台" handler:^(BOTableViewSection *section) {
        [section addCell:[HACSwitchTableViewCell cellWithTitle:@"保持计时" key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].keepTimer;
            cell.changeBlk = ^(BOOL isOn) {
                NSLog(@"switch value: %d", isOn);
                [TWSet updateSetColumn:@"keepTimer" withObj:@(isOn)];
            };
        }]];
    }]];
    
}

@end
