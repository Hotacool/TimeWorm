//
//  HACFoldTableView.h
//  TestConstraint
//
//  Created by macbook on 16/10/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HACFoldTableView;
@protocol HACFoldTableViewDataSource <NSObject>
- (NSInteger)numberOfSectionsInTableView:(HACFoldTableView *)tableView ;
- (NSInteger)tableView:(HACFoldTableView *)tableView numberOfRowsInSection:(NSInteger)section ;
- (void)tableView:(HACFoldTableView *)tableView cell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath ;
- (CGFloat)tableView:(HACFoldTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath ;
- (UIView*)tableView:(HACFoldTableView *)tableView detailForRowAtIndexPath:(NSIndexPath *)indexPath ;
@end
@protocol HACFoldTableViewDelegate <NSObject>
- (void)tableView:(HACFoldTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;
- (void)tableView:(HACFoldTableView *)tableView willOpenAtIndexPath:(NSIndexPath *)indexPath ;
- (void)tableView:(HACFoldTableView *)tableView didOpenAtIndexPath:(NSIndexPath *)indexPath ;
- (void)tableView:(HACFoldTableView *)tableView willFoldAtIndexPath:(NSIndexPath *)indexPath ;
- (void)tableView:(HACFoldTableView *)tableView didFoldAtIndexPath:(NSIndexPath *)indexPath ;
@end

@interface HACFoldTableView : UIView
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<HACFoldTableViewDelegate> delegate;
@property (nonatomic, weak) id<HACFoldTableViewDataSource> dataSource;
- (void)openCellAtIndexPath:(NSIndexPath *)indexPath ;
- (void)foldCell ;
- (void)reload;
@end
