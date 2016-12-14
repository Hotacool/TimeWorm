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
    //主题
    NSArray *themeArr = @[@"SkyBlue"
                          ,@"Grapefruit"
                          ,@"Bittersweet"
                          ,@"Sunflower"
                          ,@"Grass"];
    //cell size
    CGSize size = CGSizeMake(self.view.width, APPCONFIG_UI_TABLE_CELL_HEIGHT);
    SBWS(weakSelf)
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"主题" handler:^(BOTableViewSection *section) {
        
        [section addCell:[HACPickerTableViewCell cellWithTitle:@"主页" key:@"SH" handler:^(HACPickerTableViewCell * cell) {
            cell.itemCount = 5;
            cell.rowSize = size;
            cell.itemBlk = ^(NSUInteger index){
                UIView *itemCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                CGFloat roundWidth = 30;
                UIView *round = [[UIView alloc] initWithFrame:CGRectMake(itemCell.width/2-50-roundWidth, (itemCell.height-roundWidth)/2, roundWidth, roundWidth)];
                round.layer.cornerRadius = round.width/2;
                [itemCell addSubview:round];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, size.height)];
                label.center = itemCell.center;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = themeArr[index];
                [itemCell addSubview:label];
                switch (index) {
                    case 0: {
                        round.backgroundColor = WBlue;
                        break;
                    }
                    case 1: {
                        round.backgroundColor = Hgrapefruit;
                        break;
                    }
                    case 2: {
                        round.backgroundColor = Hbittersweet;
                        break;
                    }
                    case 3: {
                        round.backgroundColor = Hsunflower;
                        break;
                    }
                    case 4: {
                        round.backgroundColor = Hgrass;
                        break;
                    }
                    default:
                    break;
                }
                return itemCell;
            };
            __weak typeof(cell) weakCell = cell;
            cell.selectActionBlk = ^(NSUInteger index) {
                NSLog(@"select at: %ld", index);
                weakCell.detailTextLabel.text = themeArr[index];
                [TWSet updateSetColumn:@"homeTheme" withObj:@(index)];
            };
            int idx = [TWSet currentSet].homeTheme;
            if (idx < themeArr.count) {
                [cell setSelectIndex:idx];
                cell.detailTextLabel.text = themeArr[idx];
            }
        }]];
        
        [section addCell:[HACPickerTableViewCell cellWithTitle:@"工作" key:@"SW" handler:^(HACPickerTableViewCell * cell) {
            cell.itemCount = 5;
            cell.rowSize = size;
            cell.itemBlk = ^(NSUInteger index){
                UIView *itemCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                CGFloat roundWidth = 30;
                UIView *round = [[UIView alloc] initWithFrame:CGRectMake(itemCell.width/2-50-roundWidth, (itemCell.height-roundWidth)/2, roundWidth, roundWidth)];
                round.layer.cornerRadius = round.width/2;
                [itemCell addSubview:round];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, size.height)];
                label.center = itemCell.center;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = themeArr[index];
                [itemCell addSubview:label];
                switch (index) {
                    case 0: {
                        round.backgroundColor = WBlue;
                        break;
                    }
                    case 1: {
                        round.backgroundColor = Hgrapefruit;
                        break;
                    }
                    case 2: {
                        round.backgroundColor = Hbittersweet;
                        break;
                    }
                    case 3: {
                        round.backgroundColor = Hsunflower;
                        break;
                    }
                    case 4: {
                        round.backgroundColor = Hgrass;
                        break;
                    }
                    default:
                        break;
                }
                return itemCell;
            };
            __weak typeof(cell) weakCell = cell;
            cell.selectActionBlk = ^(NSUInteger index) {
                NSLog(@"select at: %ld", index);
                weakCell.detailTextLabel.text = themeArr[index];
                [TWSet updateSetColumn:@"workTheme" withObj:@(index)];
            };
            int idx = [TWSet currentSet].workTheme;
            if (idx < themeArr.count) {
                [cell setSelectIndex:idx];
                cell.detailTextLabel.text = themeArr[idx];
            }
        }]];
        
        [section addCell:[HACPickerTableViewCell cellWithTitle:@"放松" key:@"SR" handler:^(HACPickerTableViewCell * cell) {
            cell.itemCount = 5;
            cell.rowSize = size;
            cell.itemBlk = ^(NSUInteger index){
                UIView *itemCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                CGFloat roundWidth = 30;
                UIView *round = [[UIView alloc] initWithFrame:CGRectMake(itemCell.width/2-50-roundWidth, (itemCell.height-roundWidth)/2, roundWidth, roundWidth)];
                round.layer.cornerRadius = round.width/2;
                [itemCell addSubview:round];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, size.height)];
                label.center = itemCell.center;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = themeArr[index];
                [itemCell addSubview:label];
                switch (index) {
                    case 0: {
                        round.backgroundColor = WBlue;
                        break;
                    }
                    case 1: {
                        round.backgroundColor = Hgrapefruit;
                        break;
                    }
                    case 2: {
                        round.backgroundColor = Hbittersweet;
                        break;
                    }
                    case 3: {
                        round.backgroundColor = Hsunflower;
                        break;
                    }
                    case 4: {
                        round.backgroundColor = Hgrass;
                        break;
                    }
                    default:
                        break;
                }
                return itemCell;
            };
            __weak typeof(cell) weakCell = cell;
            cell.selectActionBlk = ^(NSUInteger index) {
                NSLog(@"select at: %ld", index);
                weakCell.detailTextLabel.text = themeArr[index];
                [TWSet updateSetColumn:@"relaxTheme" withObj:@(index)];
            };
            int idx = [TWSet currentSet].relaxTheme;
            if (idx < themeArr.count) {
                [cell setSelectIndex:idx];
                cell.detailTextLabel.text = themeArr[idx];
            }
        }]];
    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"屏幕" handler:^(BOTableViewSection *section) {
        [section addCell:[HACSwitchTableViewCell cellWithTitle:@"屏幕常亮" key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].keepAwake;
            cell.changeBlk = ^(BOOL isOn) {
                NSLog(@"switch value: %d", isOn);
                [TWSet updateSetColumn:@"keepAwake" withObj:@(isOn)];
                if (isOn) {
                    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                } else {
                    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                }
            };
        }]];
    }]];

}

@end
