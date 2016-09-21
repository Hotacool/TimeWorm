//
//  TWTextView.h
//  TimeWorm
//
//  Created by macbook on 16/9/20.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTextView : UIView
@property (nonatomic, strong, readonly) UITextView *textView;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, assign) NSUInteger maxWords;
@end
