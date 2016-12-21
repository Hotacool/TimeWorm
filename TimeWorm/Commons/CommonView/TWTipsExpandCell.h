//
//  TWTipsExpandCell.h
//  TimeWorm
//
//  Created by macbook on 16/12/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTipsExpandCell : UITableViewCell
@property (nonatomic, copy, readonly) NSString *imageName;
@property (nonatomic, copy, readonly) NSString *text;

- (void)setText:(NSString*)text ;

- (void)setImageName:(NSString *)imageName ;

+ (CGFloat)heightWithSize:(CGSize)size Text:(NSString *)text hasImage:(BOOL)hasImage ;
@end
