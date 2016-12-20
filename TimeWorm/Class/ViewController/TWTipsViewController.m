//
//  TWTipsViewController.m
//  TimeWorm
//
//  Created by macbook on 16/12/20.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTipsViewController.h"
#import "JNExpandableTableView.h"

@interface TWTipsViewController () <JNExpandableTableViewDelegate, JNExpandableTableViewDataSource>
@property (nonatomic, strong) JNExpandableTableView *tableView;

@end

@implementation TWTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.frame = CGRectMake(0, 69, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_FHEIGHT-69);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"expandedCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)directionChangedFrom:(TWSwipeVCDirection)from to:(TWSwipeVCDirection)to {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.tableView.expandedContentIndexPath])
    {
        return 160.0f;
    }
    else
        return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return JNExpandableTableViewNumberOfRowsInSection((JNExpandableTableView *)tableView,section,10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath * adjustedIndexPath = [self.tableView adjustedIndexPathFromTable:indexPath];
    
    if ([self.tableView.expandedContentIndexPath isEqual:indexPath])
    {
        static NSString *CellIdentifier = @"expandedCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = @"expand...";
        
        return cell;
        
    }
    
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.textLabel.text = [NSString stringWithFormat:@"Index: %ld",(long)adjustedIndexPath.row];
        
        return cell;
    }
}
#pragma mark JNExpandableTableView DataSource
- (BOOL)tableView:(JNExpandableTableView *)tableView canExpand:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(JNExpandableTableView *)tableView willExpand:(NSIndexPath *)indexPath
{
    NSLog(@"Will Expand: %@",indexPath);
}
- (void)tableView:(JNExpandableTableView *)tableView willCollapse:(NSIndexPath *)indexPath
{
    NSLog(@"Will Collapse: %@",indexPath);
}
@end
