//
//  TWTimerBoard.h
//  TimeWorm
//
//  Created by macbook on 16/12/15.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TWTimerBoardState) {
    TWTimerBoardStateNone,
    TWTimerBoardStateFlow,
    TWTimerBoardStatePause
};

@interface TWTimerBoard : UIView
@property (nonatomic, assign) TWTimerBoardState state;
@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, strong) NSDate *startDate;
@end
