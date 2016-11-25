//
//  HACTextTableViewCell.h
//  TimeWorm
//
//  Created by macbook on 16/11/25.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Bohr/Bohr.h>

typedef void(^HACTextTableViewCellTextChange)(NSString*);

@interface HACTextTableViewCell : BOTextTableViewCell

@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic) NSInteger maximumTextLength;
@property (nonatomic, strong) HACTextTableViewCellTextChange changeBlk;
@end
