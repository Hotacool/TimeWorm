//
//  HACStepperTableViewCell.m
//  TimeWorm
//
//  Created by macbook on 16/11/25.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACStepperTableViewCell.h"

@implementation HACStepperTableViewCell

- (void)setup {
    _stepper = [[HACStepper alloc] initWithFrame:CGRectMake(0, 0, 120, 38)];
    [self.stepper addTarget:self action:@selector(stepperValueDidChange)];
    self.accessoryView = self.stepper;
}

- (void)updateAppearance {
    [self.stepper setStepperColor:self.secondaryColor withDisableColor:nil];
}

- (NSString *)footerTitle {
    return [NSString stringWithFormat:@"%.f", self.stepper.value];
}

- (void)stepperValueDidChange {
    self.changeBlk(self.stepper.value);
}

- (void)settingValueDidChange {
    
}

@end
