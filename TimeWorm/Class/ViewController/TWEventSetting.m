//
//  TWEventSetting.m
//  TimeWorm
//
//  Created by macbook on 16/9/12.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEventSetting.h"
#import <STPopup/STPopup.h>
#import "MKTagView.h"
#import "MKTagItem.h"
#import "TWTextView.h"
#import "TWTimer.h"
#import "TWTagPage.h"
#import "TWEvent.h"

@interface TWEventSetting () <MKTagViewDelegate, UITableViewDelegate, UITableViewDataSource, TWTagPageDelegate>

@property (nonatomic, strong) MKTagView *tagEditor;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TWTextView *textView;

@end

@implementation TWEventSetting {
    NSArray *headerArr;
    NSMutableArray *rowHeightArr;
    NSMutableArray *headerHeightArr;
    TWModelTimer *curTimer;
    TWModelEvent *curEvent;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"Event Set", @"");
        self.contentSizeInPopup = TWPopViewControllerSize;
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
        headerArr = @[@"Title"
                      , @"description"];
        rowHeightArr = [NSMutableArray arrayWithArray:@[@(44)
                                                        ,@(150)]];
        headerHeightArr = [NSMutableArray arrayWithArray:@[@(40)
                                                           ,@(20)]];
        curTimer = [TWTimer currentTimer];
        if (curTimer.state&TWTimerStatePause) {
            curEvent = [TWEvent currentEvent];
        } else {
            curEvent = nil;
        }
    }
    return self;
}

- (void)bindTimer:(TWModelTimer *)timer {
    curTimer = timer;
    if (curTimer.state&TWTimerStatePause) {
        curEvent = [TWEvent currentEvent];
    } else {
        curEvent = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Haqua;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(2, 0, self.contentSizeInPopup.width-4, self.contentSizeInPopup.height) style:UITableViewStyleGrouped];
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
        _tagEditor.maxTagsNum = 1;
        _tagEditor.maxWordsNum = 15;
        _tagEditor.placeHolder = @"输入标签0/1";
        _tagEditor.backgroundColor = [UIColor whiteColor];
        _tagEditor.frame = CGRectMake(0, 0, self.contentSizeInPopup.width-50, 0);
    }
    return _tagEditor;
}

- (TWTextView *)textView {
    if (!_textView) {
        _textView = [[TWTextView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, 150)];
        _textView.placeHolder = @"最多输入100个字符";
        _textView.maxWords = 100;
    }
    return _textView;
}

- (void)done {
    if (curEvent) {
        curEvent.name = [TWUtility transformTags2String:[self.tagEditor allTags]];
        curEvent.information = self.textView.text;
        if ([TWEvent updateEvent:curEvent]) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeInfo text:NSLocalizedString(@"done", @"") doText:nil doBlock:nil];
        } else {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeInfo text:NSLocalizedString(@"event has been stoped.", @"") doText:nil doBlock:nil];
        }
    }
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return headerArr.count;
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
            [self.tagEditor addTags:[TWUtility transformString2Tags:curEvent.name]];
            [cell.contentView addSubview:self.tagEditor];
        } else {
            [self.textView.textView setText:curEvent.information];
            [cell.contentView addSubview:self.textView];
        }
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return headerArr[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [headerHeightArr[section] floatValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [rowHeightArr[indexPath.section] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        TWTagPage *tagPage = [TWTagPage new];
        [tagPage setDefaultSelectedTags:[self.tagEditor allTags]];
        [tagPage setMaxSelectedTagNumber:self.tagEditor.maxTagsNum];
        [tagPage setTagsArr:[NSMutableArray arrayWithArray:@[@"哈哈哈"
                                                             ,@"呵呵呵"
                                                             ,@"嚯嚯嚯"]]];
        tagPage.delegate = self;
        [self.popupController pushViewController:tagPage animated:YES];
    }
}

#pragma mark - delegate functions

- (void)mkTagView:(MKTagView *)tagview sizeChange:(CGRect)newSize {
    self.tagEditor.placeHolder = [NSString stringWithFormat:@"输入标签:(%lu/%lu)",[self.tagEditor allTags].count,self.tagEditor.maxTagsNum];
    //修正cell height
    if (newSize.size.height > 44) {
        [rowHeightArr replaceObjectAtIndex:0 withObject:@(newSize.size.height)];
    } else if (newSize.size.height < 44) {
        [rowHeightArr replaceObjectAtIndex:0 withObject:@(44)];
    }
    [self.tableView reloadData];
}

- (void)mkTagView:(MKTagView *)tagview onSelect:(MKTagLabel *)tagLabel {
}

- (void)mkTagView:(MKTagView *)tagview onRemove:(MKTagLabel *)tagLabel {
}
#pragma mark - TWTagPageDelegate
- (void)tagPage:(TWTagPage *)tagPage addTag:(NSString *)tag {
    if (tag&&tag.length>0) {
        [self.tagEditor addTag:tag];
    }
}

- (void)tagPage:(TWTagPage *)tagPage removeTag:(NSString *)tag {
    if (tag&&tag.length>0) {
        [self.tagEditor removeTag:tag];
    }
}
@end
