//
//  SetScreen.m
//  TimeWorm
//
//  Created by macbook on 16/11/4.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetScreen.h"
#import "HACPickerTableViewCell.h"
#import "HACSwitchTableViewCell.h"
#import "TWSet.h"

@interface SetScreen ()

@end

@implementation SetScreen

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
        
        [section addCell:[HACPickerTableViewCell cellWithTitle:@"主页" key:@"SH" handler:^(HACPickerTableViewCell * cell) {
            cell.itemCount = 5;
            cell.itemBlk = ^(NSUInteger index){
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.width, APPCONFIG_UI_TABLE_CELL_HEIGHT)];
                switch (index) {
                    case 0: {
                        label.backgroundColor = HlavanderD;
                        break;
                    }
                    case 1: {
                        label.backgroundColor = Hpinkrose;
                        break;
                    }
                    case 2: {
                        label.backgroundColor = HpinkroseD;
                        break;
                    }
                    case 3: {
                        label.backgroundColor = Hlightgray;
                        break;
                    }
                    case 4: {
                        label.backgroundColor = HlightgrayD;
                        break;
                    }
                    default:
                    break;
                }
                label.text = [NSString stringWithFormat:@"index: %ld", index];
                label.textAlignment = NSTextAlignmentCenter;
                return label;
            };
            cell.selectActionBlk = ^(NSUInteger index) {
                NSLog(@"select at: %ld", index);
                [TWSet updateSetColumn:@"homeTheme" withObj:@(index)];
            };
            [cell setSelectIndex:[TWSet currentSet].homeTheme];
        }]];
        
        [section addCell:[HACPickerTableViewCell cellWithTitle:@"工作" key:@"SW" handler:^(HACPickerTableViewCell * cell) {
            cell.itemCount = 5;
            cell.itemBlk = ^(NSUInteger index){
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.width, APPCONFIG_UI_TABLE_CELL_HEIGHT)];
                switch (index) {
                    case 0: {
                        label.backgroundColor = Hgrapefruit;
                        break;
                    }
                    case 1: {
                        label.backgroundColor = Hbittersweet;
                        break;
                    }
                    case 2: {
                        label.backgroundColor = Hsunflower;
                        break;
                    }
                    case 3: {
                        label.backgroundColor = Hgrass;
                        break;
                    }
                    case 4: {
                        label.backgroundColor = Haqua;
                        break;
                    }
                    default:
                    break;
                }
                label.text = [NSString stringWithFormat:@"index: %ld", index];
                label.textAlignment = NSTextAlignmentCenter;
                return label;
            };
            cell.selectActionBlk = ^(NSUInteger index) {
                NSLog(@"select at: %ld", index);
                [TWSet updateSetColumn:@"workTheme" withObj:@(index)];
            };
            [cell setSelectIndex:[TWSet currentSet].workTheme];
        }]];
        
        [section addCell:[HACPickerTableViewCell cellWithTitle:@"放松" key:@"SR" handler:^(HACPickerTableViewCell * cell) {
            cell.itemCount = 5;
            cell.itemBlk = ^(NSUInteger index){
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.width, APPCONFIG_UI_TABLE_CELL_HEIGHT)];
                switch (index) {
                    case 0: {
                        label.backgroundColor = Hgrapefruit;
                        break;
                    }
                    case 1: {
                        label.backgroundColor = Hbittersweet;
                        break;
                    }
                    case 2: {
                        label.backgroundColor = Hsunflower;
                        break;
                    }
                    case 3: {
                        label.backgroundColor = Hgrass;
                        break;
                    }
                    case 4: {
                        label.backgroundColor = Haqua;
                        break;
                    }
                    default:
                    break;
                }
                label.text = [NSString stringWithFormat:@"index: %ld", index];
                label.textAlignment = NSTextAlignmentCenter;
                return label;
            };
            cell.selectActionBlk = ^(NSUInteger index) {
                NSLog(@"select at: %ld", index);
                [TWSet updateSetColumn:@"relaxTheme" withObj:@(index)];
            };
            [cell setSelectIndex:[TWSet currentSet].relaxTheme];
        }]];
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"屏幕" handler:^(BOTableViewSection *section) {
        [section addCell:[HACSwitchTableViewCell cellWithTitle:@"屏幕常亮" key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].keepAwake;
            cell.changeBlk = ^(BOOL isOn) {
                NSLog(@"switch value: %d", isOn);
                [TWSet updateSetColumn:@"keepAwake" withObj:@(isOn)];
            };
        }]];
    }]];

}

@end
