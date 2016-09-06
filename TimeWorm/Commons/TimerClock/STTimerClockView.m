//
//  STTimerClockView.m
//  STClockDemo
//
//  Created by zhenlintie on 15/7/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//
//  modified by Hotacool. All rights reserved.

#import "STTimerClockView.h"
#import "STTimerRulerView.h"

@interface STTimerClockView () <STTimerRulerViewDelegate>

@property (strong, nonatomic) UIImageView *blackCenter;
@property (strong, nonatomic) UIImageView *redCenter;
@property (strong, nonatomic) UIImageView *hand;
@property (strong, nonatomic) UIImageView *handShadow;
@property (strong, nonatomic) UIImageView *degreeBg;
@property (strong, nonatomic) UIImageView *number60;
@property (strong, nonatomic) UIImageView *number15;

@property (nonatomic, strong, readwrite) QBFlatButton *timeBtn;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) STTimerRulerView *rulerView;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation STTimerClockView{
    NSInteger _leftSecond;
    
    BOOL _canUpdateTimeDown;
    BOOL _pause;
    CGFloat _handAngleBeforeShow;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        _leftSecond = 0;
        _canUpdateTimeDown = YES;
        _pause = NO;
    }
    return self;
}

- (void)loadUI{
    [super loadUI];
    
    self.degreeBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"degree_i6"]];
    self.blackCenter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_center_i6"]];
    self.redCenter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_center_red_middle_i6"]];
    self.hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minute_hand_i6"]];
    self.handShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minute_hand_shadow_i6"]];
    self.number60 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"d60"]];
    self.number15 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"d15"]];
    
    [self addSubview:self.degreeBg];
    [self addSubview:self.handShadow];
    [self addSubview:self.hand];
    [self addSubview:self.blackCenter];
    [self addSubview:self.redCenter];
    [self addSubview:self.number15];
    [self addSubview:self.number60];
    
    self.timeBtn = [[QBFlatButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.timeBtn.faceColor = Hmorange;
    self.timeBtn.sideColor = HmorangeD;
    self.timeBtn.radius = 6.0;
    self.timeBtn.margin = 7.0;
    self.timeBtn.depth = 6.0;
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
    self.timeLabel.textColor = RGB(172, 89, 89);
    self.timeLabel.font = HFont(23);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"00:00";
    [self.timeBtn addSubview:self.timeLabel];
    [self addSubview:self.timeBtn];
    
    self.rulerView = [[STTimerRulerView alloc] initWithFrame:CGRectMake(self.width-73, 20, 70, self.height-20)];
    self.rulerView.delegate = self;
    [self addSubview:self.rulerView];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self updateItems];
}

- (void)updateItems{
    self.degreeBg.center = self.clockPannel.center;
    self.blackCenter.center = self.clockPannel.center;
    self.hand.center = self.clockPannel.center;
    self.handShadow.center = self.clockPannel.center;
    self.redCenter.center = self.clockPannel.center;
    self.number60.origin = CGPointMake(self.clockPannel.center.x-self.number60.width/2, self.clockPannel.top+45);
    self.number15.right = self.clockPannel.right-38;
    self.number15.top = self.clockPannel.center.y-self.number15.height/2;
    
    self.timeBtn.center = CGPointMake(self.clockPannel.center.x, self.clockPannel.bottom+45-10);
    
    POPLayerSetTranslationX(self.handShadow.layer, 2);
    
    if (self.onWillShow){
        [self prepareToShow];
    }
}

- (void)prepareToShow{
    [[[self animatedAlphaItems] arrayByAddingObjectsFromArray:@[_rulerView]] alphaTo:0 duration:0 completion:nil];
    
    _handAngleBeforeShow = [self angleOfHandBySecond:_leftSecond]-M_PI/1.5;
    [@[self.hand, self.handShadow] rotateFrom:_handAngleBeforeShow to:_handAngleBeforeShow duration:0 timingFumction:0 completion:nil];
}

- (NSArray *)animatedAlphaItems{
    return @[self.blackCenter, self.redCenter, self.handShadow, self.hand, self.degreeBg, self.timeLabel, self.number15, self.number60];
}

#pragma mark - hand

- (CGFloat)angleOfHandBySecond:(NSInteger)second{
    return M_PI*2*(second/3600.0);
}

- (void)updateHandWithSecond:(NSInteger)second{
    [@[self.hand, self.handShadow] rotateFrom:POPLayerGetRotation(self.hand.layer) to:[self angleOfHandBySecond:second] duration:0 timingFumction:0 completion:nil];
}

#pragma mark - time

- (void)timeDown{
    _leftSecond--;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",_leftSecond/60,_leftSecond%60];
    
    if (_canUpdateTimeDown){
        [self.rulerView setSecond:_leftSecond];
        [self updateHandWithSecond:_leftSecond];
    }
    if (_leftSecond == 0){
        [self stopTime];
        [[[UIAlertView alloc] initWithTitle:@"倒计时时间到了！" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
    }
}

- (void)stopTime{
    [_timer invalidate];
    _timer = nil;
}

- (void)startTime{
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - ruler delegate

- (void)slideToSecond:(NSInteger)second{
    [self stopTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:00",second/60];
    [self updateHandWithSecond:second];
}

- (void)didBeginAtMinute:(NSInteger)minute{
    _leftSecond = minute*60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:00",minute];
    
    [@[self.hand, self.handShadow] rotateFrom:[self angleOfHandBySecond:_leftSecond] to:M_PI*2*(minute/60.0) duration:0.2 timingFumction:0 completion:nil];
    if (minute > 0 && !_pause){
        [self startTime];
    }
}

#pragma mark - transition

- (void)willShow{
    self.onWillShow = YES;
    [self prepareToShow];
}

- (void)transitionToHide:(void(^)())completion{
    _canUpdateTimeDown = NO;
    [_rulerView animateToHide];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_rulerView alphaTo:0 duration:0.1 completion:nil];
    });
    
    [@[self.hand, self.handShadow] rotateFrom:POPLayerGetRotation(self.hand.layer) to:POPLayerGetRotation(self.hand.layer)+M_PI_2 duration:0.5 timingFumction:STEaseInOut completion:nil];

}
- (void)transitionToShow:(void(^)())completion{
    _canUpdateTimeDown = NO;
    [_rulerView animateToShow];
    [self.rulerView alphaTo:1 duration:0.1 completion:nil];
    [[self animatedAlphaItems] alphaTo:1 duration:STCLOCK_ALPHA_ANIMATION_DURATION completion:nil];
    [@[self.hand, self.handShadow] rotateFrom:_handAngleBeforeShow to:[self angleOfHandBySecond:_leftSecond] duration:0.5 timingFumction:STCustomEaseOut completion:^(BOOL finished) {
        self.onWillShow = NO;
        STSafeBlock(completion)
        if (finished){
            _canUpdateTimeDown = YES;
        }
    }];
}


@end
