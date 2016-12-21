//
//  TWTipsExpandCell.m
//  TimeWorm
//
//  Created by macbook on 16/12/21.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTipsExpandCell.h"

static const CGFloat TWTipsExpandCellDefaultImageHeight = 200.f;
static const CGFloat TWTipsExpandCellImageTopMargin = 4.f;
static const CGFloat TWTipsExpandCellImageBottomMargin = 8.f;
@implementation TWTipsExpandCell {
    UIImageView *imageView;
    UILabel *textLabel;
    
    NSLayoutConstraint *textLabelTopConstraint;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:TWTipsExpandCellImageTopMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:TWTipsExpandCellDefaultImageHeight]];
    textLabel = [[UILabel alloc] init];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.numberOfLines = 0;
    [self addSubview:textLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:-TWTipsExpandCellImageBottomMargin]];
    textLabelTopConstraint = [NSLayoutConstraint constraintWithItem:textLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:2];
    [self addConstraint:textLabelTopConstraint];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.translatesAutoresizingMaskIntoConstraints = NO;
    leftLine.backgroundColor = Haqua;
    [self addSubview:leftLine];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:textLabel
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:leftLine
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:textLabel
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.translatesAutoresizingMaskIntoConstraints = NO;
    rightLine.backgroundColor = Haqua;
    [self addSubview:rightLine];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:textLabel
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1
                                                      constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:rightLine
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:textLabel
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1
                                                      constant:0]];
    
}

- (void)setText:(NSString *)text {
    _text = text;
    textLabel.attributedText = [TWTipsExpandCell attributeStringWithText:text];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}

- (void)updateConstraints {
    if (HACObjectIsEmpty(self.imageName)) {
        imageView.hidden = YES;
        [self removeConstraint:textLabelTopConstraint];
        textLabelTopConstraint = [NSLayoutConstraint constraintWithItem:textLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1
                                                               constant:TWTipsExpandCellImageTopMargin];
        [self addConstraint:textLabelTopConstraint];
        
    } else {
        [self removeConstraint:textLabelTopConstraint];
        textLabelTopConstraint = [NSLayoutConstraint constraintWithItem:textLabel
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:imageView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:2];
        [self addConstraint:textLabelTopConstraint];
    }
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithSize:(CGSize)size Text:(NSString *)text hasImage:(BOOL)hasImage {
    if (HACObjectIsEmpty(text)) {
        return 0;
    }
    CGFloat height;
    if (hasImage) {
        height += (TWTipsExpandCellDefaultImageHeight +  2);
    }
    NSMutableAttributedString *attrStr = [self attributeStringWithText:text];
    CGRect rect = [attrStr boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    height += TWTipsExpandCellImageTopMargin + TWTipsExpandCellImageBottomMargin + rect.size.height;
    return height;
}

+ (NSMutableAttributedString*)attributeStringWithText:(NSString*)text {
    NSMutableAttributedString *attrStr;
    if (text) {
        attrStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:HdarkgrayD
                        range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:18.0f]
                        range:NSMakeRange(0, attrStr.length)];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 4;
        paragraph.paragraphSpacing = 6;
        paragraph.firstLineHeadIndent = 4;
        paragraph.alignment = NSTextAlignmentLeft;
        [attrStr addAttribute:NSParagraphStyleAttributeName
                        value:paragraph
                        range:NSMakeRange(0, attrStr.length)];
    }
    return attrStr;
}

@end
