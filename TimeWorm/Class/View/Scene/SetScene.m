//
//  SetScene.m
//  TimeWorm
//
//  Created by macbook on 16/10/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetScene.h"
#import "RS3DSegmentedControl.h"
#import <pop/POP.h>

static NSString *const SetSceneSegmentAniCenter = @"RecordSceneCalendarAniCenter";
static NSString *const SetSceneSetTableAniCenter = @"RecordSceneTimerTableAniCenter";
static NSString *const SetSceneSetTableID = @"RecordSceneTimerTableID";
static const CGFloat SetSceneSegmentHeight = 80;
@interface SetScene () <RS3DSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) RS3DSegmentedControl *segment;
@property (nonatomic, strong) UITableView *setTable;

@end

@implementation SetScene {
    NSMutableArray *sets;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadData];
        [self setUIComponents];
    }
    return self;
}

- (void)loadData {
    
}

- (void)setUIComponents {
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                               colors:@[(__bridge id)WBlue.CGColor, (__bridge id)LBlue.CGColor]
                                                            locations:@[@(0.5f), @(1.0f)]
                                                           startPoint:CGPointMake(0.5, 0)
                                                             endPoint:CGPointMake(0.5, 1)]
                       atIndex:0];
}

- (void)show {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showSegment];
        [self showSetTable];
    });
}

- (void)showSegment {
    if (![self.segment superview]) {
        [self addSubview:self.segment];
    }
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, -self.segment.frame.size.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.segment.frame.size.height/2+APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.segment pop_addAnimation:ani forKey:SetSceneSegmentAniCenter];
}

- (void)showSetTable {
    if (![self.setTable superview]) {
        [self addSubview:self.setTable];
    }
    CGFloat marginY = APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT + SetSceneSegmentHeight + 2;
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.setTable.center.x, self.height+self.setTable.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.setTable.center.x, marginY+self.setTable.height/2)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.setTable pop_addAnimation:ani forKey:SetSceneSetTableAniCenter];
}

- (RS3DSegmentedControl *)segment {
    if (!_segment) {
        _segment = [[RS3DSegmentedControl alloc] initWithFrame:CGRectMake(0, -200, self.width, SetSceneSegmentHeight)];
        _segment.delegate = self;
        _segment.textFont = [UIFont systemFontOfSize:24];
        //_segment.backgroundColor = LBlue;
        //_segment.textColor = [UIColor whiteColor];
        [_segment setSelectedSegmentIndex:0];
    }
    return _segment;
}

- (UITableView *)setTable {
    if (!_setTable) {
        CGFloat marginY = APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT + SetSceneSegmentHeight + 2;
        _setTable = [[UITableView alloc] initWithFrame:CGRectMake(2, 0, self.width-4, self.height-marginY-2) style:UITableViewStylePlain];
        _setTable.center = self.center;
        _setTable.delegate = self;
        _setTable.dataSource = self;
        [_setTable registerClass:[UITableViewCell class] forCellReuseIdentifier:SetSceneSetTableID];
    }
    return _setTable;
}

- (NSUInteger)numberOfSegmentsIn3DSegmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    return 5;
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segmentIndex segmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    switch (segmentIndex) {
        case 0:
            return NSLocalizedString(@"Screen", @"");
        case 1:
            return NSLocalizedString(@"Default", @"");
        case 2:
            return NSLocalizedString(@"Notification", @"");
        case 3:
            return NSLocalizedString(@"Account", @"");
        case 4:
            return NSLocalizedString(@"About", @"");
            
        default:
            return @"";
    }
}


- (void)didSelectSegmentAtIndex:(NSUInteger)segmentIndex segmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    
}
#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetSceneSetTableID];
    cell.text = @"lll";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
@end
