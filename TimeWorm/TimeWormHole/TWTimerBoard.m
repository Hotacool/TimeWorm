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
#define Hmediumgray   RGB_HEX(0xCCD1D9)
#define HmediumgrayD  RGB_HEX(0xAAB2BD)

@implementation TWTimerBoard {
    UIView *stateBar;
    UILabel *startDateLabel;
    UILabel *timeLabel;
    UIImageView *stateIcon;
    UILabel *tNameLabel;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    stateBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    [self addSubview:stateBar];
    startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateBar.frame.size.width-120, 0, 120, stateBar.frame.size.height)];
    startDateLabel.textAlignment = NSTextAlignmentCenter;
    startDateLabel.font = [UIFont systemFontOfSize:12];
    startDateLabel.text = @"";
    startDateLabel.backgroundColor = [UIColor clearColor];
    startDateLabel.textColor = Hmediumgray;
    [stateBar addSubview:startDateLabel];
    stateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 25, 25)];
    stateIcon.backgroundColor = [UIColor grayColor];
    [stateBar addSubview:stateIcon];
    tNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(stateIcon.frame)+4, 0, 180, stateBar.frame.size.height)];
    tNameLabel.font = [UIFont systemFontOfSize:16];
    tNameLabel.textAlignment = NSTextAlignmentLeft;
    [stateBar addSubview:tNameLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(stateBar.frame), self.frame.size.width-20, self.frame.size.height - stateBar.frame.size.height)];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.font = [UIFont systemFontOfSize:50];
    timeLabel.text = NSLocalizedString(@"00:00", @"");
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = Hmediumgray;
    [self addSubview:timeLabel];
    
    
    
    [self setState:TWTimerBoardStateNone];
}

- (void)setState:(TWTimerBoardState)state {
    _state = state;
    switch (state) {
        case TWTimerBoardStateNone: {
            stateIcon.image = [UIImage imageNamed:@"missionStop"];
            startDateLabel.text = NSLocalizedString(@"None mission", @"");
            break;
        }
        case TWTimerBoardStateFlow: {
            stateIcon.image = [UIImage imageNamed:@"missionPlay"];
            break;
        }
        case TWTimerBoardStatePause: {
            stateIcon.image = [UIImage imageNamed:@"missionPause"];
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
    startDateLabel.text = [NSString stringWithFormat:@"%@", dateStr];
}

- (void)setName:(NSString *)name {
    _name = name;
    tNameLabel.text = name;
}
@end
