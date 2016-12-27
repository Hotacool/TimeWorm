//
//  RecordScene.m
//  TimeWorm
//
//  Created by macbook on 16/10/27.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "RecordScene.h"
#import "CLWeeklyCalendarView.h"
#import <pop/POP.h>
#import "TWTimer.h"
#import <DateTools/DateTools.h>
#import "TWTimerInfoPage.h"
#import <STPopup/STPopup.h>

static NSString *const RecordSceneCalendarAniCenter = @"RecordSceneCalendarAniCenter";
static NSString *const RecordSceneTimerTableAniCenter = @"RecordSceneTimerTableAniCenter";
static NSString *const RecordSceneTimerTableID = @"RecordSceneTimerTableID";
static const CGFloat RecordSceneCalendarHeight = 130;
static const CGFloat RecordSceneTableCellHeight = 44;
@interface RecordScene () <CLWeeklyCalendarViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CLWeeklyCalendarView *calendar;
@property (nonatomic, strong) UITableView *timerTable;
@end

@implementation RecordScene {
    NSMutableArray <TWModelTimer*>* timerArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUIComponents];
    }
    return self;
}

- (void)setUIComponents {
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                               colors:@[(__bridge id)WBlue.CGColor, (__bridge id)LBlue.CGColor]
                                                            locations:@[@(0.5f), @(1.0f)]
                                                           startPoint:CGPointMake(0.5, 0)
                                                             endPoint:CGPointMake(0.5, 1)]
                       atIndex:0];
}

- (CLWeeklyCalendarView *)calendar {
    if (!_calendar) {
        _calendar = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, -200, self.width, RecordSceneCalendarHeight)];
        _calendar.delegate = self;
    }
    return _calendar;
}

- (UITableView *)timerTable {
    if (!_timerTable) {
        CGFloat marginY = APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT + RecordSceneCalendarHeight + 2;
        _timerTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 0, self.width-4, self.height-marginY-2) style:UITableViewStylePlain];
        _timerTable.center = self.center;
        _timerTable.delegate = self;
        _timerTable.dataSource = self;
        [_timerTable registerClass:[UITableViewCell class] forCellReuseIdentifier:RecordSceneTimerTableID];
        timerArr = [NSMutableArray array];
    }
    return _timerTable;
}

- (void)show {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showCalendar];
        [self showTimerTable];
    });
}

- (void)showCalendar {
    if (![self.calendar superview]) {
        [self addSubview:self.calendar];
    }
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, -self.calendar.frame.size.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.calendar.frame.size.height/2+APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.calendar pop_addAnimation:ani forKey:RecordSceneCalendarAniCenter];
}

- (void)showTimerTable {
    if (![self.timerTable superview]) {
        [self addSubview:self.timerTable];
    }
    CGFloat marginY = APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT + RecordSceneCalendarHeight + 2;
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.timerTable.center.x, self.height+self.timerTable.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.timerTable.center.x, marginY+self.timerTable.height/2)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.timerTable pop_addAnimation:ani forKey:RecordSceneTimerTableAniCenter];
}

#pragma mark - CLWeeklyCalendarViewDelegate
- (NSDictionary *)CLCalendarBehaviorAttributes {
    return @{
             CLCalendarWeekStartDay : @1,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}



- (void)dailyCalendarViewDidSelect:(NSDate *)date {
    DDLogInfo(@"date: %@", date);
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month day:date.day];
     
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [timerArr removeAllObjects];
        [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
            NSString * sql = [NSString stringWithFormat:@"select * from TWTimer where startDate BETWEEN '%@' and '%@'", startDate, [NSDate dateWithTimeInterval:86400 sinceDate:startDate]];
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                TWModelTimer *timer = [[TWModelTimer alloc] initWithFMResultSet:rs];
                [timerArr addObject:timer];
            }
        }];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.timerTable reloadData];
        });
    });
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return timerArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RecordSceneTableCellHeight;
}

static const int RecordSceneCellTag = 1000;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordSceneTimerTableID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //bind data
    UILabel *cellTag = [cell viewWithTag:RecordSceneCellTag + 1];
    UIView *line = [cell viewWithTag:RecordSceneCellTag + 2];
    UILabel *titleLabel = [cell viewWithTag:RecordSceneCellTag + 3];
    if (!cellTag) {
        cellTag = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, 40, RecordSceneTableCellHeight - 2)];
        cellTag.tag = RecordSceneCellTag + 1;
        cellTag.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:cellTag];
    }
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cellTag.frame), 1, 2, RecordSceneTableCellHeight - 2)];
        line.tag = RecordSceneCellTag + 2;
        [cell addSubview:line];
    }
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 1, 200, RecordSceneTableCellHeight - 2)];
        titleLabel.tag = RecordSceneCellTag + 3;
        titleLabel.font = HFont(16);
        [cell addSubview:titleLabel];
    }
    TWModelTimer *timer = timerArr[indexPath.row];
    cellTag.text = [NSString stringWithFormat:@"%d%@", timer.allSeconds/60, NSLocalizedString(@"m", @"")];
    if (timer.state&TWTimerStateEnd) {
        line.backgroundColor = HgrassD;
    } else if (timer.state&TWTimerStateCancel) {
        line.backgroundColor = HpinkroseD;
    } else {
        line.backgroundColor = HmorangeD;
    }
    titleLabel.text = timer.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TWModelTimer *timer;
    if ((timer = timerArr[indexPath.row])) {
        TWTimerInfoPage *ret = [TWTimerInfoPage new];
        ret.title = NSLocalizedString(@"Mission Detail", @"");
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:ret];
        popupController.containerView.layer.cornerRadius = 4;
        popupController.transitionStyle = STPopupTransitionStyleSlideVertical;
        [popupController presentInViewController:self.ctrl];
        [ret bindTimer:timer];
    }
}
@end
