//
//  TWPaopaoVew.m
//  TimeWorm
//
//  Created by macbook on 16/12/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWPaopaoVew.h"

static const CGFloat TWPaopaoVewTextFont = 14.f;
static const CGFloat TWPaopaoVewMaxTextHeight = 150.f;
@interface TWPaopaoVew ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation TWPaopaoVew {
    UIImageView *background;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.height > 150) {
        frame.size.height = 150;
    }
    if (self = [super initWithFrame:frame]) {
        background = [[UIImageView alloc] initWithImage:self.image];
        [self addSubview:background];
        background.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:background
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:background
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:background
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:background
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:0]];
        [background addSubview:self.textLabel];
        [background addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:background
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:12]];
        [background addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:background
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:-20]];
        [background addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:background
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:10]];
        [background addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:background
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:-10]];
//        self.textLabel.backgroundColor = HmintD;
    }
    return self;
}


- (UIImage *)image {
    if (!_image) {
        _image = [UIImage imageNamed:@"paopao"];
        UIEdgeInsets insets = UIEdgeInsetsMake(30, 30, 30, 30);
        _image = [_image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return _image;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.font = HFont(TWPaopaoVewTextFont);
    }
    return _textLabel;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
    CGSize size = [TWPaopaoVew fitPaopaoSizeWithText:text];
    if (size.height < TWPaopaoVewTextFont) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        self.frame = CGRectMake(self.origin.x, self.origin.y, self.width, size.height+40);
    }
}

+ (CGSize)fitPaopaoSizeWithText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(APPCONFIG_UI_SCREEN_FWIDTH-20-32, TWPaopaoVewMaxTextHeight)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: HFont(TWPaopaoVewTextFont)}
                                     context:nil];
    return CGSizeMake(rect.size.width, rect.size.height);
}
@end
