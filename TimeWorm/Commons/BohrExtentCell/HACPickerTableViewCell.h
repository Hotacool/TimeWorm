//
//  HACPickerTableViewCell.h
//  Bohr
//
//  Created by macbook on 16/11/4.
//
//

#import <Bohr/Bohr.h>

typedef UIView*(^HACPickerTableViewCellItemBlock)(NSUInteger);
typedef void(^HACPickerTableViewCellSelectAction)(NSUInteger);

@interface HACPickerTableViewCell : BOTableViewCell
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) HACPickerTableViewCellItemBlock itemBlk;
@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, strong) HACPickerTableViewCellSelectAction selectActionBlk;
@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, assign) CGSize rowSize;
@end
