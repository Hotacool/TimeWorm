//
//  TWMoreInfoPage.m
//  TimeWorm
//
//  Created by macbook on 16/9/14.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWMoreInfoPage.h"
#import <STPopup/STPopup.h>
#import "MKTagView.h"
#import "MKTagItem.h"
#import "QBFlatButton.h"
#import "TWTagPage.h"

static NSInteger TWEditorViewTag = 1;
@interface TWMoreInfoPage () <MKTagViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MKTagView *tagEditor;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TWMoreInfoPage {
    CGFloat height;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Keyboard";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        height = 44;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Haqua;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _tableView;
}

- (MKTagView *)tagEditor {
    if (!_tagEditor) {
        _tagEditor = [[MKTagView alloc] init];
        _tagEditor.editable = YES;
        _tagEditor.delegate = self;
        _tagEditor.tag = TWEditorViewTag;
        _tagEditor.backgroundColor = [UIColor whiteColor];
        _tagEditor.frame = CGRectMake(0, 0, self.contentSizeInPopup.width-50, 0);
    }
    return _tagEditor;
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"UITableViewCellIdentifierKey";
    UITableViewCell *cell;
    NSString *tmpId = [cellIdentifier stringByAppendingFormat:@"_%lu", indexPath.section];
    cell=[tableView dequeueReusableCellWithIdentifier:tmpId];
    if (cell) {
        
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tmpId];
        if (indexPath.section == 0) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:self.tagEditor];
        } else {
            
        }
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"title";
    }
    return @"information";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 20;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 100;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        [self.popupController pushViewController:[TWTagPage new] animated:YES];
    }
}

#pragma mark - delegate functions

- (void)mkTagView:(MKTagView *)tagview sizeChange:(CGRect)newSize {
    if (newSize.size.height > 44) {
        height = 88;
    } else {
        height = 44;
    }
    [self.tableView reloadData];
}

- (void)mkTagView:(MKTagView *)tagview onSelect:(MKTagLabel *)tagLabel {
}

- (void)mkTagView:(MKTagView *)tagview onRemove:(MKTagLabel *)tagLabel {
}
@end
