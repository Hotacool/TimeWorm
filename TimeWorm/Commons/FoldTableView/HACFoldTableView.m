//
//  HACFoldTableView.m
//  TestConstraint
//
//  Created by macbook on 16/10/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACFoldTableView.h"

static NSString * const HACFoldTableViewCellID = @"HACFoldTableViewCellID";
static const float HACFoldTableViewAniDuration = 0.5;
@interface HACFoldTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation HACFoldTableView {
    UIView *openCellContent;
    NSIndexPath *openCellIndexPath;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    [self addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HACFoldTableViewCellID];
    }
    return _tableView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognize:)];
    }
    return _tapGesture;
}

#pragma mark -- table delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSource numberOfSectionsInTableView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [self.dataSource tableView:self numberOfRowsInSection:section];
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HACFoldTableViewCellID];
    if ([self.dataSource respondsToSelector:@selector(tableView:cellContrentViewForRowAtIndexPath:)]) {
        [cell addSubview:[self.dataSource tableView:self cellContrentViewForRowAtIndexPath:indexPath]];
    } else {
        //
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self openCellAtIndexPath:indexPath];
}

- (void)tapGestureRecognize:(UITapGestureRecognizer*)tapGesture {
    [self foldCell];
}

#pragma mark -- API
- (void)openCellAtIndexPath:(NSIndexPath *)indexPath {
    if (openCellIndexPath) {
        DDLogError(@"openCellIndexPath: %@", openCellIndexPath);
        return;
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    openCellContent = cell.contentView;
    openCellIndexPath = indexPath;
    [openCellContent removeFromSuperview];
    openCellContent.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - self.tableView.contentOffset.y, openCellContent.frame.size.width, openCellContent.frame.size.height);
    openCellContent.backgroundColor = [UIColor lightGrayColor];
    [openCellContent addGestureRecognizer:self.tapGesture];
    [self addSubview:openCellContent];
    [UIView animateWithDuration:HACFoldTableViewAniDuration animations:^{
        openCellContent.frame = CGRectMake(0, 0, openCellContent.frame.size.width, openCellContent.frame.size.height);
        self.tableView.alpha = 0;
    }];
}
- (void)foldCell {
    if (!openCellIndexPath) {
        DDLogError(@"has no openCell.");
        return;
    }
    if (openCellContent) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:openCellIndexPath];
        [UIView animateWithDuration:HACFoldTableViewAniDuration animations:^{
            openCellContent.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - self.tableView.contentOffset.y, openCellContent.frame.size.width, openCellContent.frame.size.height);
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {
            [openCellContent removeFromSuperview];
            [cell addSubview:openCellContent];
            openCellContent.backgroundColor = self.tableView.backgroundColor;
            [openCellContent removeGestureRecognizer:self.tapGesture];
            openCellIndexPath = nil;
            openCellContent = nil;
        }];
    }
}

@end
