//
//  HACSwitchTableViewCell.h
//  TimeWorm
//
//  Created by macbook on 16/11/24.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Bohr/Bohr.h>

typedef void(^HACSwitchTableViewCellSwitchChange)(BOOL);

@interface HACSwitchTableViewCell : BOSwitchTableViewCell
@property (nonatomic, assign) BOOL defaultSwitchValue;
@property (nonatomic, strong) HACSwitchTableViewCellSwitchChange changeBlk;

@end
