//
//  TWEventList.m
//  TimeWorm
//
//  Created by macbook on 16/10/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEventList.h"
#import "TWDBManager.h"
#import "TWModelEvent.h"
#import "TWTimer.h"
#import "TWEventDetailView.h"
#import "DateTools.h"
#import <STPopup/STPopup.h>
#import "JNExpandableTableView.h"

static NSString * const TWEventListCellIdentifier = @"TWEventListCellIdentifier";
static NSString * const TWEventListExpandCellIdentifier = @"TWEventListExpandCellIdentifier";
static const CGFloat TWEventListExpandCellHeight = 300.f;
static const CGFloat TWEventListCellHeight = 40.f;
static const CGFloat TWEventListCellIconHeight = 20.f;
static const CGFloat TWEventListCellLabelHeight = 30.f;
@interface TWEventList () <JNExpandableTableViewDelegate, JNExpandableTableViewDataSource>
@property (nonatomic, strong) JNExpandableTableView *tableView;
@end

@implementation TWEventList {
    NSMutableArray <TWModelEvent*>*eventArr;
    TWModelTimer *curTimer;
}

- (instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = TWPopViewControllerSize;
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
        eventArr = [NSMutableArray array];
    }
    return self;
}

- (void)bindTimer:(TWModelTimer *)timer {
    curTimer = timer;
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height);
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JNExpandableTableView *)tableView {
    if (!_tableView) {
        _tableView = [[JNExpandableTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = Haqua;
    }
    return _tableView;
}

- (TWEventDetailView*)createEventDetailView {
    TWEventDetailView *detailView = [[TWEventDetailView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, TWEventListExpandCellHeight)];
    detailView.backgroundColor = Hclear;
    return detailView;
}

#pragma mark -- data
- (void)requestData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [eventArr removeAllObjects];
        [[TWDBManager dbQueue] inDatabase:^(FMDatabase *db) {
            NSString * sql = [@"select * from TWEvent where timerId=" stringByAppendingFormat:@"%d", curTimer.ID];
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                TWModelEvent *event = [[TWModelEvent alloc] initWithFMResultSet:rs];
                [eventArr addObject:event];
            }
        }];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self finishLoadData];
        });
    });
}

- (void)finishLoadData {
    [self.tableView reloadData];
}

#pragma mark - gesture
- (void)directionChangedFrom:(TWSwipeVCDirection)from to:(TWSwipeVCDirection)to {
    if (from == TWSwipeVCDirectionNone && to == TWSwipeVCDirectionLeft) {
        [self.popupController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.tableView.expandedContentIndexPath]) {
        return TWEventListExpandCellHeight;
    }
    return TWEventListCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return JNExpandableTableViewNumberOfRowsInSection((JNExpandableTableView *)tableView,section,eventArr.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //实际选中indexpath转化为一级或二级indexpath
    NSIndexPath * adjustedIndexPath = [self.tableView adjustedIndexPathFromTable:indexPath];
    TWModelEvent *event = eventArr[adjustedIndexPath.row];
    TWEventDetailView *detailView;
    if ([self.tableView.expandedContentIndexPath isEqual:indexPath]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TWEventListExpandCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = Hclear;
            detailView = [self createEventDetailView];
            detailView.tag = 1001;
            [cell addSubview:detailView];
        } else {
            detailView = [cell viewWithTag:1001];
        }
        NSDate *sDate = event.startDate;
        NSDate *eDate = event.stopDate;
        NSString *sdStr = @"";
        NSString *edStr = @"";
        if (sDate && ![sDate isKindOfClass:[NSNull class]]) {
            if ([sDate isKindOfClass:[NSString class]]) {
                sDate = [NSDate dateWithString:(NSString *)sDate formatString:@"yyyy-MM-dd HH:mm:ss Z"];
            }
            sdStr = sDate?[sDate formattedDateWithFormat:@"yyyy/MM/dd HH:mm:ss"]:@"";
        }
        if (eDate && ![eDate isKindOfClass:[NSNull class]]) {
            if ([eDate isKindOfClass:[NSString class]]) {
                eDate = [NSDate dateWithString:(NSString *)eDate formatString:@"yyyy-MM-dd HH:mm:ss Z"];
            }
            edStr = eDate?[eDate formattedDateWithFormat:@"yyyy/MM/dd HH:mm:ss"]:@"";
        }
        detailView.startTime =[NSLocalizedString(@"e_start_date", @"") stringByAppendingString:sdStr];
        detailView.endTime = [NSLocalizedString(@"e_end_date", @"") stringByAppendingString:edStr];
        detailView.content = event.information;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TWEventListCellIdentifier];
        UIImageView *imageView;
        UILabel *nameLabel;
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = Hlightgray;
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"event"]];
            imageView.frame = CGRectMake(10, TWEventListCellHeight/2 - TWEventListCellIconHeight/2, TWEventListCellIconHeight, TWEventListCellIconHeight);
            imageView.tag = 1001;
            [cell addSubview:imageView];
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+5, TWEventListCellHeight/2 - TWEventListCellLabelHeight/2, cell.width, TWEventListCellLabelHeight)];
            nameLabel.tag = 1002;
            nameLabel.font = HFont(18);
            nameLabel.textAlignment = NSTextAlignmentLeft;
            [nameLabel setAdjustsFontSizeToFitWidth:YES];
            [cell addSubview:nameLabel];
        } else {
            imageView = [cell viewWithTag:1001];
            nameLabel = [cell viewWithTag:1002];
        }
        nameLabel.text = event.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark JNExpandableTableView DataSource
- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(JNExpandableTableView *)tableView willExpand:(NSIndexPath *)indexPath {
}
- (void)tableView:(JNExpandableTableView *)tableView willCollapse:(NSIndexPath *)indexPath {
}
@end
