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
- (UIView *)tableView:(HACFoldTableView *)tableView cellContrentViewForRowAtIndexPath:(NSIndexPath *)indexPath ;
@end
@protocol HACFoldTableViewDelegate <NSObject>
- (void)tableView:(HACFoldTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath ;

@end

@interface HACFoldTableView : UIView
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, weak) id<HACFoldTableViewDelegate> delegate;
@property (nonatomic, weak) id<HACFoldTableViewDataSource> dataSource;
- (void)openCellAtIndexPath:(NSIndexPath *)indexPath ;
- (void)foldCell ;
@end
