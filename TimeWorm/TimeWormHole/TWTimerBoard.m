//
//  TWTimerBoard.m
//  TimeWorm
//
//  Created by macbook on 16/12/15.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTimerBoard.h"

#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]
#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)
#define WBlue RGB(100, 190, 250)
#define Hbittersweet  RGB_HEX(0xFC6E51)
#define Hdarkgray     RGB_HEX(0x656D78)

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
    startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWTimerBoardStateBarWidth, 0, self.frame.size.width - TWTimerBoardStateBarWidth, 30)];
    startDateLabel.textAlignment = NSTextAlignmentCenter;
    startDateLabel.font = [UIFont systemFontOfSize:12];
    startDateLabel.text = NSLocalizedString(@"start: ", @"");
    startDateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:startDateLabel];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWTimerBoardStateBarWidth, 0, self.frame.size.width - TWTimerBoardStateBarWidth, self.frame.size.height - startDateLabel.frame.size.height)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:50];
    timeLabel.text = NSLocalizedString(@"00:00", @"");
    timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:timeLabel];
    
    [self setState:TWTimerBoardStateNone];
}

- (void)setState:(TWTimerBoardState)state {
    _state = state;
    switch (state) {
        case TWTimerBoardStateNone: {
            stateBar.backgroundColor = Hdarkgray;
            startDateLabel.text = @"";
            break;
        }
        case TWTimerBoardStateFlow: {
            stateBar.backgroundColor = WBlue;
            break;
        }
        case TWTimerBoardStatePause: {
            stateBar.backgroundColor = Hbittersweet;
            break;
        }
    }
}

- (void)setSeconds:(NSUInteger)seconds {
    _seconds = seconds;
    NSString *minStr;
    NSString *secStr;
    NSUInteger min = seconds/60;
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%lu",(unsigned long)min];
    } else {
        minStr = [NSString stringWithFormat:@"%lu",(unsigned long)min];
    }
    NSUInteger sec = seconds%60;
    if (sec < 10) {
        secStr = [NSString stringWithFormat:@"0%lu",(unsigned long)sec];
    } else {
        secStr = [NSString stringWithFormat:@"%lu",(unsigned long)sec];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@", minStr, secStr];
    timeLabel.text = timeStr;
}

- (void)setStartDate:(NSDate *)startDate {
    _startDate = startDate;
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd HH:mm:ss"];
    NSString * dateStr=[dateformatter stringFromDate:startDate];
    startDateLabel.text = [NSString stringWithFormat:@"start: %@", dateStr];
}
@end
