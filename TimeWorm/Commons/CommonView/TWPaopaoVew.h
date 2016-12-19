//
//  TWPaopaoVew.h
//  TimeWorm
//
//  Created by macbook on 16/12/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWPaopaoVew : UIView
@property (nonatomic, copy) NSString *text;

+ (CGSize)fitPaopaoSizeWithText:(NSString*)text ;
@end
