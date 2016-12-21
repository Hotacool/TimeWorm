//
//  TWTipsViewController.m
//  TimeWorm
//
//  Created by macbook on 16/12/20.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTipsViewController.h"
#import "JNExpandableTableView.h"
#import "TWTipsExpandCell.h"

static NSString * const TWTipsCellIdentifier = @"TWTipsCellIdentifier";
static NSString * const TWTipsExpandCellIdentifier = @"TWTipsExpandCellIdentifier";
@interface TWTipsViewController () <JNExpandableTableViewDelegate, JNExpandableTableViewDataSource>
@property (nonatomic, strong) JNExpandableTableView *tableView;

@end

@implementation TWTipsViewController {
    NSMutableArray <NSDictionary*>* dataDicArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataDicArr = [NSMutableArray array];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_STATUSBAR_HEIGHT+APPCONFIG_UI_NAVIGATIONBAR_HEIGHT)];
    navBar.translucent = NO;
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setBarTintColor:HdarkgrayD];
    UINavigationItem *backItem = [[UINavigationItem alloc] initWithTitle:@"Tips"];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(backToHome)];
    backItem.rightBarButtonItem = backBtn;
    [navBar pushNavigationItem:backItem animated:YES];
    [self.view addSubview:navBar];
    
    CGFloat originY = APPCONFIG_UI_STATUSBAR_HEIGHT+APPCONFIG_UI_NAVIGATIONBAR_HEIGHT;
    self.tableView.frame = CGRectMake(0, originY, APPCONFIG_UI_SCREEN_FWIDTH, APPCONFIG_UI_SCREEN_FHEIGHT-originY);
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self readData];
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
    }
    return _tableView;
}

- (void)directionChangedFrom:(TWSwipeVCDirection)from to:(TWSwipeVCDirection)to {
    if (from == TWSwipeVCDirectionNone && to == TWSwipeVCDirectionLeft) {
        [self backToHome];
    }
}

- (void)backToHome {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)readData {
    HACBackground(^{
        id data = [TWUtility readJsonName:@"intro"];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = data;
            [dataDicArr removeAllObjects];
            [dataDicArr addObjectsFromArray:[dic allValues]];
            HACMain(^{
                [self.tableView reloadData];
            });
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.tableView.expandedContentIndexPath]) {
        NSIndexPath * adjustedIndexPath = [self.tableView adjustedIndexPathFromTable:indexPath];
        if (dataDicArr.count > adjustedIndexPath.row) {
            NSDictionary *dic = dataDicArr[adjustedIndexPath.row];
            NSString *text = dic[@"content"];
            NSString *imageName = dic[@"image"];
            return [TWTipsExpandCell heightWithSize:CGSizeMake(self.tableView.width, APPCONFIG_UI_SCREEN_FHEIGHT) Text:text hasImage:!HACObjectIsEmpty(imageName)];
        }
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return JNExpandableTableViewNumberOfRowsInSection((JNExpandableTableView *)tableView,section,dataDicArr.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSIndexPath * adjustedIndexPath = [self.tableView adjustedIndexPathFromTable:indexPath];
    NSDictionary *dic = dataDicArr[adjustedIndexPath.row];
    NSString *text = dic[@"content"];
    NSString *imageName = dic[@"image"];
    NSString *title = dic[@"title"];
    if ([self.tableView.expandedContentIndexPath isEqual:indexPath]) {
        TWTipsExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:TWTipsExpandCellIdentifier];
        if (!cell) {
            cell = [[TWTipsExpandCell alloc] init];
        }
        [cell setText:text];
        if (!HACObjectIsEmpty(imageName)) {
            [cell setImageName:imageName];
        }
        [cell setNeedsUpdateConstraints];
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.textLabel.text = title;
        
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
}
- (void)tableView:(JNExpandableTableView *)tableView willCollapse:(NSIndexPath *)indexPath
{
}
@end
