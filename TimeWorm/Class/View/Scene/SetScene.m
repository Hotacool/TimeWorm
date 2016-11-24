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
#import "SetScreen.h"
#import "SetDefault.h"
#import "SetNotification.h"
#import "TWSet.h"

static NSString *const SetSceneSegmentAniCenter = @"RecordSceneCalendarAniCenter";
static NSString *const SetSceneSetTableAniCenter = @"RecordSceneTimerTableAniCenter";
static NSString *const SetSceneSetTableID = @"RecordSceneTimerTableID";
static const CGFloat SetSceneSegmentHeight = 80;
static const int SetSceneSegmentCount = 5;
@interface SetScene () <RS3DSegmentedControlDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) RS3DSegmentedControl *segment;
@property (nonatomic, strong) UIScrollView *setScrollView;

@end

@implementation SetScene {
    NSMutableArray *sets;
    NSMutableDictionary *subViewDic;
    NSMutableArray *scrollSubViews;
    NSMutableArray *scrollSubViewCtrl;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadData];
        [self setUIComponents];
    }
    return self;
}

- (void)loadData {
    [TWSet initializeTWSet];
    subViewDic = [NSMutableDictionary dictionaryWithCapacity:SetSceneSegmentCount];
    scrollSubViews = [NSMutableArray arrayWithCapacity:3];
    scrollSubViewCtrl = [NSMutableArray arrayWithCapacity:5];
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
        [self showSetScroll];
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

- (void)showSetScroll {
    if (![self.setScrollView superview]) {
        [self addSubview:self.setScrollView];
    }
    CGFloat marginY = APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT + SetSceneSegmentHeight + 2;
    POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    ani.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.setScrollView.center.x, self.height+self.setScrollView.height/2)];
    ani.toValue = [NSValue valueWithCGPoint:CGPointMake(self.setScrollView.center.x, marginY+self.setScrollView.height/2)];
    ani.springSpeed = 6;
    ani.springBounciness = 16;
    [self.setScrollView pop_addAnimation:ani forKey:SetSceneSetTableAniCenter];
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

- (UIScrollView *)setScrollView {
    if (!_setScrollView) {
        CGFloat marginY = APPCONFIG_UI_STATUSBAR_HEIGHT + APPCONFIG_UI_TOOLBAR_HEIGHT + SetSceneSegmentHeight + 2;
        _setScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 0, self.width-4, self.height-marginY-2)];
        _setScrollView.pagingEnabled = YES;
        _setScrollView.center = self.center;
        _setScrollView.delegate = self;
        //load content
        int count = 3;
        _setScrollView.contentSize = CGSizeMake(_setScrollView.width*count, _setScrollView.height);
        [@[@4,@0,@1] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *t = [self loadPageViewAtSegmentIndex:[obj intValue]];
            t.frame = CGRectMake(idx*_setScrollView.width, 0, _setScrollView.width, _setScrollView.height);
            [_setScrollView addSubview:t];
            [scrollSubViews addObject:t];
        }];
        _setScrollView.contentOffset = CGPointMake(_setScrollView.width, 0);
    }
    return _setScrollView;
}

- (NSUInteger)numberOfSegmentsIn3DSegmentedControl:(RS3DSegmentedControl *)segmentedControl
{
    return SetSceneSegmentCount;
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
    UIView *t = scrollSubViews[1];
    if (segmentIndex != t.tag) {
        [scrollSubViews replaceObjectAtIndex:1 withObject:[self loadPageViewAtSegmentIndex:segmentIndex]];
        [self scrollViewDidEndDecelerating:self.setScrollView];
    }
}

#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.setScrollView) {
        //[self.segment setContentOffset:CGSizeMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.setScrollView) {
        NSUInteger index = scrollView.contentOffset.x / scrollView.width;
        UIView *t = scrollSubViews[index];
        int previous = (int)t.tag - 1;
        if (previous<0) {
            previous += SetSceneSegmentCount;
        }
        int next = (int)t.tag + 1;
        if (next>SetSceneSegmentCount-1) {
            next -= SetSceneSegmentCount;
        }
        [scrollSubViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [@[[self loadPageViewAtSegmentIndex:previous]
           ,t
           ,[self loadPageViewAtSegmentIndex:next]] enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               obj.frame = CGRectMake(idx*self.setScrollView.width, 0, self.setScrollView.width, self.setScrollView.height);
               [scrollSubViews replaceObjectAtIndex:idx withObject:obj];
               [self.setScrollView addSubview:obj];
           }];
        self.setScrollView.contentOffset = CGPointMake(_setScrollView.width, 0);
        [self.segment setSelectedSegmentIndex:t.tag];
    }
}

- (UIView*)loadPageViewAtSegmentIndex:(NSUInteger)index {
    UIView *view;
    if (!(view = [subViewDic objectForKey:@(index)])) {
        if (index == 0) {
            UIViewController *ctrl = [SetScreen new];
            [scrollSubViewCtrl addObject:ctrl];
            view = ctrl.view;
        } else if (index == 1) {
            UIViewController *ctrl = [SetDefault new];
            [scrollSubViewCtrl addObject:ctrl];
            view = ctrl.view;
        } else if (index == 2) {
            UIViewController *ctrl = [SetNotification new];
            [scrollSubViewCtrl addObject:ctrl];
            view = ctrl.view;
        }
        else {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.setScrollView.width, self.setScrollView.height)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            label.center = view.center;
            [view addSubview:label];
            label.text = [NSString stringWithFormat:@"page: %lu", index];
        }
        switch (index) {
            case 0: {
                view.backgroundColor = Hgrapefruit;
                break;
            }
            case 1: {
                view.backgroundColor = HgrapefruitD;
                break;
            }
            case 2: {
                view.backgroundColor = Hbittersweet;
                break;
            }
            case 3: {
                view.backgroundColor = HbittersweetD;
                break;
            }
            case 4: {
                view.backgroundColor = Hsunflower;
                break;
            }
            default:
                break;
        }
        view.tag = index;
        [subViewDic setObject:view forKey:@(index)];
    }
    return view;
}
@end
