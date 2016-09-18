//
//  STTimerClockView.h
//  STClockDemo
//
//  Created by zhenlintie on 15/7/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//
//  modified by Hotacool. All rights reserved.

#import "STClockView.h"
#import "QBFlatButton.h"

@class STClockView;
@protocol STClockViewDelegate <NSObject>

- (void)clockView:(STClockView*)clockView startTimerWithSeconds:(NSUInteger)seconds ;

- (void)stopTimerOfClockView:(STClockView*)clockView ;

@end

@interface STTimerClockView : STClockView

@property (nonatomic, weak) id<STClockViewDelegate> delegate;
@property (nonatomic, strong, readonly) QBFlatButton *timeBtn;

- (void)setClockSeconds:(NSUInteger)seconds ;
- (void)tickTime ;
@end
