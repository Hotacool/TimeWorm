//
//  TWModelEvent.h
//  TimeWorm
//
//  Created by macbook on 16/9/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWModel.h"

@interface TWModelEvent : TWModel
@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int timerId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *information;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *stopDate;
@end
