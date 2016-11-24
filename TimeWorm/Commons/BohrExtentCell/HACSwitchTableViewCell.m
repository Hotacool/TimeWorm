//
//  HACSwitchTableViewCell.m
//  TimeWorm
//
//  Created by macbook on 16/11/24.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACSwitchTableViewCell.h"

@implementation HACSwitchTableViewCell

- (NSString *)footerTitle {
    return self.defaultSwitchValue ? self.onFooterTitle : self.offFooterTitle;
}

- (void)toggleSwitchValueDidChange {
    self.changeBlk(self.toggleSwitch.on);
}

- (void)settingValueDidChange {
    [self.toggleSwitch setOn:self.defaultSwitchValue animated:[UIView areAnimationsEnabled]];
}

@end
