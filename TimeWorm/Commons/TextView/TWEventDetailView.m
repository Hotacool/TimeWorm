//
//  TWEventDetailView.m
//  TimeWorm
//
//  Created by macbook on 16/12/6.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWEventDetailView.h"

static const CGFloat TWEventDetailViewCellHeight = 40;
static const CGFloat TWEventDetailViewTopMargin = 2;
static const CGFloat TWEventDetailViewLeftMargin = 2;
static const NSUInteger TWEventDetailViewTag = 1000;
static const NSUInteger TWEventDetailViewFont = 14;
@implementation TWEventDetailView {
    UIScrollView *scrollView;
    UILabel *stLabel;
    UILabel *etLabel;
    UILabel *ctLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.seperatorColor = HlightgrayD;
    stLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWEventDetailViewLeftMargin, TWEventDetailViewTopMargin, self.width-2*TWEventDetailViewLeftMargin, TWEventDetailViewCellHeight)];
    stLabel.textAlignment = NSTextAlignmentLeft;
    stLabel.font = HFont(TWEventDetailViewFont);
    [self addSubview:stLabel];
    UIView *stLine = [[UIView alloc] initWithFrame:CGRectMake(1, stLabel.height-2, stLabel.width-2, 1)];
    stLine.backgroundColor = self.seperatorColor;
    [stLabel addSubview:stLine];
    etLabel = [[UILabel alloc] initWithFrame:CGRectMake(TWEventDetailViewLeftMargin, CGRectGetMaxY(stLabel.frame), self.width-2*TWEventDetailViewLeftMargin, TWEventDetailViewCellHeight)];
    etLabel.textAlignment = NSTextAlignmentLeft;
    etLabel.font = HFont(TWEventDetailViewFont);
    [self addSubview:etLabel];
    UIView *etLine = [[UIView alloc] initWithFrame:CGRectMake(1, etLabel.height-2, etLabel.width-2, 1)];
    etLine.backgroundColor = self.seperatorColor;
    [etLabel addSubview:etLine];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(TWEventDetailViewLeftMargin, CGRectGetMaxY(etLabel.frame), self.width - 2*TWEventDetailViewLeftMargin, self.height-2*TWEventDetailViewTopMargin-2*TWEventDetailViewCellHeight)];
    scrollView.clipsToBounds = YES;
    [self addSubview:scrollView];
}

- (void)setContent:(NSString *)content {
    _content = content;
    if (!ctLabel) {
        ctLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        ctLabel.numberOfLines = 0;
        ctLabel.font = HFont(TWEventDetailViewFont);
        [ctLabel.layer setCornerRadius:2];
        [scrollView addSubview:ctLabel];
    }
    CGFloat textH = [content boundingRectWithSize:scrollView.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: ctLabel.font}
                                           context:nil].size.height;
    ctLabel.frame = CGRectMake(0, 0, scrollView.width, textH);
    ctLabel.text = content;
    ctLabel.textColor = [UIColor blackColor];
}

- (void)setStartTime:(NSString *)startTime {
    _startTime = startTime;
    if (stLabel) {
        stLabel.text = startTime;
    }
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    if (etLabel) {
        etLabel.text = endTime;
    }
}

- (void)layoutSubviews {
    
}

@end
