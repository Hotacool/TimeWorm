//
//  HACTextTableViewCell.m
//  TimeWorm
//
//  Created by macbook on 16/11/25.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACTextTableViewCell.h"

@implementation HACTextTableViewCell {
    NSString *text;
}

- (void)settingValueDidChange {
    self.textField.text = self.defaultValue;
    text = self.defaultValue;
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    return YES;
}

- (NSString *)textFieldTrimmedText {
    return [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *input = [self textFieldTrimmedText];
    if (input.length < self.minimumTextLength || input.length > self.maximumTextLength) {
    } else {
        text = input;
        self.changeBlk(text);
    }
    self.textField.text = text;
}
@end
