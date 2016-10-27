//
//  TWEventList.m
//  TimeWorm
//
//  Created by macbook on 16/10/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEventList.h"
#import <STPopup/STPopup.h>
#import "HACFoldTableView.h"
#import "TWDBManager.h"
#import "TWModelEvent.h"
#import "TWTimer.h"

@interface TWEventList () <HACFoldTableViewDelegate, HACFoldTableViewDataSource>
@property (nonatomic, strong) HACFoldTableView *tableView;

@end

@implementation TWEventList {
    NSMutableArray <TWModelEvent*>*eventArr;
    TWModelTimer *curTimer;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Event Set", @"");
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

- (HACFoldTableView *)tableView {
    if (!_tableView) {
        _tableView = [[HACFoldTableView alloc] initWithFrame:CGRectMake(2, 1, self.contentSizeInPopup.width-4, self.contentSizeInPopup.height-2)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.tableView reload];
}

#pragma mark -- HACFoldTableViewDelegate, HACFoldTableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(HACFoldTableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(HACFoldTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventArr.count;
}
- (void)tableView:(HACFoldTableView *)tableView cell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *label;
    if (!(label = [cell.contentView viewWithTag:1001])) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.tag = 1001;
        label.center = cell.contentView.center;
        [cell.contentView addSubview:label];
    }
    [label setText:eventArr[indexPath.row].name];
}

- (UIView*)tableView:(HACFoldTableView *)tableView detailForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height)];
    detailView.backgroundColor = Hmediumgray;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = eventArr[indexPath.row].information;
    label.center = detailView.center;
    [detailView addSubview:label];
    return detailView;
}

- (CGFloat)tableView:(HACFoldTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(HACFoldTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView openCellAtIndexPath:indexPath];
}
- (void)tableView:(HACFoldTableView *)tableView willOpenAtIndexPath:(NSIndexPath *)indexPath {
    sfuc
}
- (void)tableView:(HACFoldTableView *)tableView didOpenAtIndexPath:(NSIndexPath *)indexPath {
    sfuc
}
- (void)tableView:(HACFoldTableView *)tableView willFoldAtIndexPath:(NSIndexPath *)indexPath {
    sfuc
}
- (void)tableView:(HACFoldTableView *)tableView didFoldAtIndexPath:(NSIndexPath *)indexPath {
    sfuc
}

@end
