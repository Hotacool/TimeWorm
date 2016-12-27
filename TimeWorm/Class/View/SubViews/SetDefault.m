//
//  SetDefault.m
//  TimeWorm
//
//  Created by macbook on 16/11/24.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetDefault.h"
#import "HACSwitchTableViewCell.h"
#import "HACStepperTableViewCell.h"
#import "HACTextTableViewCell.h"
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
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:NSLocalizedString(@"Background", @"") handler:^(BOTableViewSection *section) {
        [section addCell:[HACSwitchTableViewCell cellWithTitle:NSLocalizedString(@"Keep timing", @"") key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].keepTimer;
            cell.changeBlk = ^(BOOL isOn) {
                [TWSet updateSetColumn:@"keepTimer" withObj:@(isOn)];
            };
        }]];
    }]];
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:NSLocalizedString(@"Mission", @"") handler:^(BOTableViewSection *section) {
        [section addCell:[HACStepperTableViewCell cellWithTitle:NSLocalizedString(@"Default time", @"") key:nil handler:^(HACStepperTableViewCell * cell) {
            cell.stepper.wraps = YES;
            cell.stepper.continuous = NO;
            cell.stepper.formart = @"%.0f";
            cell.stepper.autorepeat = YES;
            [cell.stepper setStepperRange:1 andMaxValue:60];
            [cell.stepper setStepperColor:Haqua withDisableColor:Hmediumgray];
            cell.stepper.value = [TWSet currentSet].defaultTimer;
            cell.changeBlk = ^(double value) {
                [TWSet updateSetColumn:@"defaultTimer" withObj:@((int)value)];
            };
        }]];
        
        [section addCell:[HACTextTableViewCell cellWithTitle:NSLocalizedString(@"Mission name", @"") key:nil handler:^(HACTextTableViewCell * cell) {
            cell.minimumTextLength = 2;
            cell.maximumTextLength = 10;
            cell.defaultValue = [TWSet currentSet].defaultTimerName;
            cell.changeBlk = ^(NSString *input) {
                [TWSet updateSetColumn:@"defaultTimerName" withObj:input];
            };
        }]];
        
        [section addCell:[HACTextTableViewCell cellWithTitle:NSLocalizedString(@"Event name", @"") key:nil handler:^(HACTextTableViewCell * cell) {
            cell.minimumTextLength = 2;
            cell.maximumTextLength = 10;
            cell.defaultValue = [TWSet currentSet].defaultEventName;
            cell.changeBlk = ^(NSString *input) {
                [TWSet updateSetColumn:@"defaultEventName" withObj:input];
            };
        }]];
        
        [section addCell:[HACSwitchTableViewCell cellWithTitle:NSLocalizedString(@"Voice", @"") key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].isVoiceOn;
            cell.changeBlk = ^(BOOL isOn) {
                [TWSet updateSetColumn:@"isVoiceOn" withObj:@(isOn)];
            };
        }]];
        
        [section addCell:[HACSwitchTableViewCell cellWithTitle:NSLocalizedString(@"Next mission", @"") key:nil handler:^(HACSwitchTableViewCell * cell) {
            cell.defaultSwitchValue = [TWSet currentSet].continueWork;
            cell.changeBlk = ^(BOOL isOn) {
                [TWSet updateSetColumn:@"continueWork" withObj:@(isOn)];
            };
        }]];
    }]];
    
}

@end
