//
//  TWTimerInfoPage.m
//  TimeWorm
//
//  Created by macbook on 16/12/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTimerInfoPage.h"
#import <STPopup/STPopup.h>
#import "TWEventList.h"
#import "TWEventDetailView.h"
#import "DateTools.h"

static const CGFloat TWTimerInfoPageTitleCellHeight = 40.f;
@interface TWTimerInfoPage ()
@property (nonatomic, strong) UIView *colorTag;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *stateIcon;
@property (nonatomic, strong) TWEventDetailView *detailView;

@end

@implementation TWTimerInfoPage {
    TWModelTimer *curTimer;
}


- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"ClockSetMore", @"");
        self.contentSizeInPopup = TWPopViewControllerSize;
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)bindTimer:(TWModelTimer *)timer {
    curTimer = timer;
    [self bindData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = Haqua;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Event List", @"") style:UIBarButtonItemStylePlain target:self action:@selector(gotoEventList:)];
    UIView *titleCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, TWTimerInfoPageTitleCellHeight)];
    titleCell.backgroundColor = Hlightgray;
    [self.view addSubview:titleCell];
    CGRect rect = CGRectMake(0, 0, 0, TWTimerInfoPageTitleCellHeight);
    rect.origin.x = 2;
    rect.size.width = 40;
    self.timeLabel.frame = rect;
    rect.origin.x = CGRectGetMaxX(self.timeLabel.frame);
    rect.size.width = 4;
    self.colorTag.frame = rect;
    rect.origin.x = CGRectGetMaxX(self.colorTag.frame)+4;
    rect.size.width = self.contentSizeInPopup.width - rect.origin.x - TWTimerInfoPageTitleCellHeight-10;
    self.titleLabel.frame = rect;
    rect.origin.x = CGRectGetMaxX(self.titleLabel.frame);
    rect.origin.y = (TWTimerInfoPageTitleCellHeight - 25)/2;
    rect.size.height = 25;
    rect.size.width = 25;
    self.stateIcon.frame = rect;
    
    [titleCell addSubview:self.colorTag];
    [titleCell addSubview:self.titleLabel];
    [titleCell addSubview:self.timeLabel];
    [titleCell addSubview:self.stateIcon];
    [self.view addSubview:self.detailView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindData {
    if (curTimer.state&TWTimerStateEnd) {
        self.colorTag.backgroundColor = HgrassD;
    } else {
        
    }
    switch (curTimer.state) {
        case TWTimerStateEnd: {
            self.colorTag.backgroundColor = HgrassD;
            self.stateIcon.image = [UIImage imageNamed:@"MissionComplete"];
            break;
        }
        case TWTimerStateCancel: {
            self.colorTag.backgroundColor = HpinkroseD;
            self.stateIcon.image = [UIImage imageNamed:@"MissionCancel"];
            break;
        }
        default: {
            self.colorTag.backgroundColor = HmorangeD;
            self.stateIcon.image = [UIImage imageNamed:@"MissionException"];
            break;
        }
    }
    self.titleLabel.text = curTimer.name;
    int allTime = curTimer.allSeconds;
    allTime = allTime/60;
    self.timeLabel.text = [NSString stringWithFormat:@"%dm", allTime];
    self.detailView.content = curTimer.information;
    NSDate *sDate = curTimer.startDate;
    NSDate *eDate = curTimer.fireDate;
    NSString *sdStr;
    NSString *edStr;
    if (sDate) {
        if ([sDate isKindOfClass:[NSString class]]) {
            sDate = [NSDate dateWithString:(NSString *)sDate formatString:@"yyyy-MM-dd HH:mm:ss Z"];
        }
        sdStr = sDate?[sDate formattedDateWithFormat:@"yyyy/MM/dd HH:mm:ss"]:@"";
    }
    if (eDate) {
        if ([eDate isKindOfClass:[NSString class]]) {
            eDate = [NSDate dateWithString:(NSString *)eDate formatString:@"yyyy-MM-dd HH:mm:ss Z"];
        }
        edStr = eDate?[eDate formattedDateWithFormat:@"yyyy/MM/dd HH:mm:ss"]:@"";
    }
    self.detailView.startTime =[NSLocalizedString(@"e_start_date", @"") stringByAppendingString:sdStr];
    self.detailView.endTime = [NSLocalizedString(@"e_end_date", @"") stringByAppendingString:edStr];

}

- (UIView *)colorTag {
    if (!_colorTag) {
        _colorTag = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _colorTag;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = HFont(15);
        [_titleLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_timeLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _timeLabel;
}

- (UIImageView *)stateIcon {
    if (!_stateIcon) {
        _stateIcon = [[UIImageView alloc] init];
    }
    return _stateIcon;
}

- (TWEventDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[TWEventDetailView alloc] initWithFrame:CGRectMake(0, 40, self.contentSizeInPopup.width, self.contentSizeInPopup.height-40)];
        _detailView.backgroundColor = Hclear;
    }
    return _detailView;
}

- (void)gotoEventList:(id)sender {
    TWEventList *ret = [TWEventList new];
    ret.title = NSLocalizedString(@"Event List", @"");
    [ret bindTimer:curTimer];
    [self.popupController pushViewController:ret animated:YES];
}

@end
