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
#import <pop/POP.h>
#import "TWEventDetailView.h"
#import "DateTools.h"

static const NSUInteger TWEventListCellTag = 1000;
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
    UIView *content, *colorLine;
    UILabel *label;
    if (!(content = [cell.contentView viewWithTag:TWEventListCellTag])) {
        content = [[UIView alloc] initWithFrame:cell.bounds];
        content.tag = TWEventListCellTag;
        [cell.contentView addSubview:content];
        colorLine = [[UIView alloc] initWithFrame:CGRectZero];
        colorLine.tag = TWEventListCellTag + 1;
        [content addSubview:colorLine];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = TWEventListCellTag + 2;
        [content addSubview:label];
    } else {
        colorLine = [content viewWithTag:TWEventListCellTag + 1];
        label = [content viewWithTag:TWEventListCellTag + 2];
    }
    
    colorLine.frame = CGRectMake(0, 0, 5, cell.height);
    if (indexPath.row % 2 == 0) {
        colorLine.backgroundColor = HmintD;
    } else {
        colorLine.backgroundColor = Hbluejeans;
    }
    label.frame = CGRectMake(colorLine.width, 0, cell.width-colorLine.width, cell.height);
    label.font = HFont(16);
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = Hlightgray;
    [label setText:eventArr[indexPath.row].name];
}

- (UIView*)tableView:(HACFoldTableView *)tableView detailForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWEventDetailView *detailView = [[TWEventDetailView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height)];
    detailView.backgroundColor = Hmediumgray;
    NSDate *sDate = eventArr[indexPath.row].startDate;
    NSDate *eDate = eventArr[indexPath.row].stopDate;
    NSString *sdStr;
    NSString *edStr;
//    if (sDate) {
//        if ([sDate isKindOfClass:[NSString class]]) {
//            sDate = [NSDate dateWithString:(NSString *)sDate formatString:@"yyyy-MM-dd HH:mm:ss"];
//        }
//        sdStr = [sDate formattedDateWithStyle:NSDateFormatterFullStyle];
//    }
//    if (eDate) {
//        if ([eDate isKindOfClass:[NSString class]]) {
//            eDate = [NSDate dateWithString:(NSString *)eDate formatString:@"yyyy-MM-dd HH:mm:ss"];
//        }
//        edStr = [eDate formattedDateWithStyle:NSDateFormatterFullStyle];
//    }
//    detailView.startTime =[@"start: " stringByAppendingString:sdStr];
//    detailView.endTime = [@"start: " stringByAppendingString:edStr];
    detailView.content = eventArr[indexPath.row].information;
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
    UIView *content = [tableView getOpenContent];
    UIView *colorLine = [content viewWithTag:TWEventListCellTag+1];
    UILabel *label = [content viewWithTag:TWEventListCellTag+2];
    if (colorLine) {
        colorLine.backgroundColor = Hlavander;
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        ani.fromValue = [NSValue valueWithCGRect:colorLine.frame];
        ani.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, content.width, content.height)];
        ani.springSpeed = 6;
        ani.springBounciness = 16;
        [colorLine pop_addAnimation:ani forKey:@"TWEventListColorLine"];
    }
    if (label) {
        CGRect tempRect = [label.text boundingRectWithSize:content.bounds.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: HFont(18)}
                                                   context:nil];
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        ani.fromValue = [NSValue valueWithCGPoint:label.center];
        ani.toValue = [NSValue valueWithCGPoint:CGPointMake(content.width/2 - tempRect.size.width/2 + label.width/2, content.height/2)];
        ani.springSpeed = 6;
        ani.springBounciness = 16;
        [label pop_addAnimation:ani forKey:@"TWEventListLabel"];
        label.backgroundColor = [UIColor clearColor];
        label.font = HFont(18);
    }
}
- (void)tableView:(HACFoldTableView *)tableView willFoldAtIndexPath:(NSIndexPath *)indexPath {
    sfuc
}
- (void)tableView:(HACFoldTableView *)tableView didFoldAtIndexPath:(NSIndexPath *)indexPath {
    sfuc
}

@end
