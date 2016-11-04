//
//  HACPickerTableViewCell.m
//  Bohr
//
//  Created by macbook on 16/11/4.
//
//

#import "HACPickerTableViewCell.h"

@interface HACPickerTableViewCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation HACPickerTableViewCell

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
    
- (void)setup {
    self.pickerView.backgroundColor = [UIColor clearColor];
    
    self.expansionView = self.pickerView;
}
    
- (CGFloat)expansionHeight {
    return 216;
}
    
- (void)settingValueDidChange {
    self.detailTextLabel.text = [NSString stringWithFormat:@"i: %ld", self.selectIndex];
    self.detailTextLabel.backgroundColor = self.itemBlk(self.selectIndex).backgroundColor;
}
    
- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    [self.pickerView selectRow:selectIndex inComponent:0 animated:NO];
}

#pragma mark - pickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
    
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.itemCount;
}
    
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    return self.itemBlk(row);
}
    
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectIndex = row;
    [self settingValueDidChange];
    self.selectActionBlk(row);
}
@end
