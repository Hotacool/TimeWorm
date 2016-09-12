//
//  HACWordsBoard.h
//  TimeWorm
//
//  Created by macbook on 16/9/9.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HACWordsBoard : UIView

@property (nonatomic, strong, readonly) NSMutableArray *messageArr;
@property (nonatomic, assign) NSUInteger speed;

- (void)start;
- (void)stop;
- (void)stopRightAway;

- (void)addMessage:(NSString*)message;
- (void)addMessageWithArray:(NSArray<NSString*>*)mesArr;
@end
