//
//  TWTextView.m
//  TimeWorm
//
//  Created by macbook on 16/9/20.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWTextView.h"

@interface TWTextView () <UITextViewDelegate>
@property (nonatomic, strong, readwrite) UITextView *textView;
@property (nonatomic, strong) UILabel *wordsLabel;
@property (nonatomic, strong) NSString *text;

@end

@implementation TWTextView {
    BOOL showingPlaceholder;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    showingPlaceholder = YES;
    self.maxWords = 10;
    [self addSubview:self.textView];
    [self addSubview:self.wordsLabel];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.delegate = self;
        _textView.textColor = [UIColor lightGrayColor];
        _textView.text = self.placeHolder;
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.font = [UIFont systemFontOfSize:18];
    }
    return _textView;
}

- (UILabel *)wordsLabel {
    if (!_wordsLabel) {
        _wordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 24)];
        _wordsLabel.backgroundColor = [UIColor clearColor];
        _wordsLabel.font = [UIFont systemFontOfSize:14];
        _wordsLabel.textAlignment = NSTextAlignmentRight;
        _wordsLabel.text = [NSString stringWithFormat:@"%d/%lu",0,self.maxWords];
        [_wordsLabel sizeToFit];
    }
    return _wordsLabel;
}

- (void)layoutSubviews {
    CGRect frame = self.frame;
    self.textView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    frame = self.wordsLabel.frame;
    frame.origin.y = self.frame.size.height - self.wordsLabel.frame.size.height - 5;
    frame.origin.x = self.frame.size.width - self.wordsLabel.frame.size.width - 5;
    self.wordsLabel.frame = frame;
    
}

- (NSString *)text {
    return self.textView.text;
}

-(void)setMaxWords:(NSUInteger)maxWords {
    _maxWords = maxWords;
    self.wordsLabel.text = [NSString stringWithFormat:@"%lu/%lu", self.textView.text.length, self.maxWords];
    [self.wordsLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.textView.text = _placeHolder;
}

#pragma mark - UITextView Delegate Methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if(showingPlaceholder) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
        showingPlaceholder = NO;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    // Check the length and if it should add a placeholder
    if([[textView text] length] == 0 && !showingPlaceholder) {
        [textView setText:self.placeHolder];
        [textView setTextColor:[UIColor lightGrayColor]];
        showingPlaceholder = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES ;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > self.maxWords) {
        textView.text = [textView.text substringToIndex:self.maxWords];
    }
    self.wordsLabel.text = [NSString stringWithFormat:@"%lu/%lu", textView.text.length, self.maxWords];
    [self.wordsLabel sizeToFit];
    [self setNeedsLayout];
}

@end
