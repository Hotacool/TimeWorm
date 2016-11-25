//
//  HACStepperTableViewCell.h
//  TimeWorm
//
//  Created by macbook on 16/11/25.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Bohr/Bohr.h>
#import "HACStepper.h"
typedef void(^HACStepperTableViewCellStepperChange)(double);

@interface HACStepperTableViewCell : BOTableViewCell

@property (nonatomic, readonly) HACStepper *stepper;
@property (nonatomic, strong) HACStepperTableViewCellStepperChange changeBlk;
@end
