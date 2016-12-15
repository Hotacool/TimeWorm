//
//  TWTimerBoard.m
//  TimeWorm
//
//  Created by macbook on 16/12/15.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTimerBoard.h"

static const CGFloat TWTimerBoardStateBarWidth = 20.f;

@implementation TWTimerBoard {
    UIView *stateBar;
    UILabel *startDateLabel;
    UILabel *timeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    stateBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TWTimerBoardStateBarWidth, self.frame.size.height)];
    [self addSubview:stateBar];
    startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWTimerBoardStateBarWidth, 0, self.frame.size.width - TWTimerBoardStateBarWidth, 20)];
    startDateLabel.textAlignment = NSTextAlignmentCenter;
    startDateLabel.font = [UIFont systemFontOfSize:12];
    startDateLabel.text = NSLocalizedString(@"start: ", @"");
    startDateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:startDateLabel];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWTimerBoardStateBarWidth, 0, self.frame.size.width - TWTimerBoardStateBarWidth, self.frame.size.height - startDateLabel.frame.size.height)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:20];
    timeLabel.text = NSLocalizedString(@"00:00", @"");
    timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:timeLabel];
    
    [self setState:TWTimerBoardStateNone];
}

- (void)setState:(TWTimerBoardState)state {
    _state = state;
    switch (state) {
        case TWTimerBoardStateNone: {
            stateBar.backgroundColor = [UIColor grayColor];
            break;
        }
        case TWTimerBoardStateFlow: {
            stateBar.backgroundColor = [UIColor greenColor];
            break;
        }
        case TWTimerBoardStatePause: {
            stateBar.backgroundColor = [UIColor redColor];
            break;
        }
    }
}

- (void)setSeconds:(NSUInteger)seconds {
    _seconds = seconds;
    NSUInteger min = seconds/60;
    NSUInteger sec = seconds%60;
    NSString *timeStr = [NSString stringWithFormat:@"%lu:%lu", (unsigned long)min, (unsigned long)sec];
    timeLabel.text = timeStr;
}

- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    startDateLabel.text = [NSString stringWithFormat:@"start: %@", startDate];
}


@end
