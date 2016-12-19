//
//  TWTagPage.m
//  TimeWorm
//
//  Created by macbook on 16/9/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTagPage.h"
#import <STPopup/STPopup.h>

@interface TWTagPage () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TWTagPage {
    NSUInteger maxTagsNum;
    NSUInteger diffTagsNum;
}

@synthesize selectedTags, tagsArr;

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"tag select";
        self.contentSizeInPopup = TWPopViewControllerSize;
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
        
        selectedTags = [NSMutableSet set];
    }
    return self;
}

- (void)setTagsArr:(NSMutableArray<NSString *> *)tagsArr_ {
    tagsArr = tagsArr_;
}

- (void)setDefaultSelectedTags:(NSArray <NSString*>*)tags {
    if (tags) {
        [tags enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self isTagsArrContaindsTag:obj] >= 0) {
                [selectedTags addObject:obj];
            }
        }];
        diffTagsNum = tags.count - selectedTags.count;
    }
}

- (NSInteger)isTagsArrContaindsTag:(NSString*)tag {
    NSInteger __block index = -1;
    [tagsArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:tag]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)setMaxSelectedTagNumber:(NSUInteger)max {
    maxTagsNum = max;
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentSizeInPopup.width, self.contentSizeInPopup.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.clipsToBounds = YES;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tagsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"Multi-Selection Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *item = tagsArr[indexPath.row];
    
    cell.textLabel.text = item;
    cell.accessoryType = [selectedTags containsObject:item] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *item = tagsArr[indexPath.row];
    if (![selectedTags containsObject:item]) {
        if (selectedTags.count + diffTagsNum >= maxTagsNum) {
            [MozTopAlertView showOnWindowWithType:MozAlertTypeError text:NSLocalizedString(@"cannot select more", @"") doText:nil doBlock:nil];
            return;
        }
        [selectedTags addObject:item];
        if ([self.delegate respondsToSelector:@selector(tagPage:addTag:)]) {
            [self.delegate tagPage:self addTag:item];
        }
    } else {
        [selectedTags removeObject:item];
        if ([self.delegate respondsToSelector:@selector(tagPage:removeTag:)]) {
            [self.delegate tagPage:self removeTag:item];
        }
    }
    [tableView reloadData];
}

#pragma mark - gesture
- (void)directionChangedFrom:(TWSwipeVCDirection)from to:(TWSwipeVCDirection)to {
    if (from == TWSwipeVCDirectionNone && to == TWSwipeVCDirectionLeft) {
        [self.popupController popViewControllerAnimated:YES];
    }
}
@end
