//
//  RelaxScene.m
//  TimeWorm
//
//  Created by macbook on 16/10/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "RelaxScene.h"
#import "GameView.h"
#import "DateTools.h"
#import "TWADHelp.h"
#import "TWSet.h"

static const CGFloat RelaxSceneBannerHeight = 50;
static const int RelaxSceneDefaultDuration = 1;
@interface RelaxScene ()
@property (nonatomic, strong) GameView *gameView;

@end

@implementation RelaxScene {
    NSDate *enterDate;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUIComponents];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUIComponents {
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                              skinSet:[TWSet currentSet].relaxTheme]
                       atIndex:0];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:@"gameOverNotification" object:nil];
}

- (GameView *)gameView {
    if (!_gameView) {
        CGFloat originY = RelaxSceneBannerHeight+2;
        _gameView = [[GameView alloc] initWithFrame:CGRectMake(2, originY, self.width - 4, self.height - originY - 2 - RelaxSceneBannerHeight)];
    }
    return _gameView;
}

- (void)show {
    enterDate = [NSDate date];
    
    //advertisements
    UIView *bannerTop = [TWADHelp createBannerViewWithAdSize:CGSizeMake(self.width, RelaxSceneBannerHeight) ViewController:self.ctrl];
    UIView *bannerBottom = [TWADHelp createBannerViewWithAdSize:CGSizeMake(self.width, RelaxSceneBannerHeight) ViewController:self.ctrl];
    bannerTop.center = CGPointMake(self.width/2, 25);
    bannerTop.center = CGPointMake(self.width/2, self.height-25);
    [self addSubview:bannerTop];
    [self addSubview:bannerBottom];
    //game view
    [self addSubview:self.gameView];
}

- (void)gameOver {
    if (enterDate) {
        int minutes = [[DTTimePeriod timePeriodWithStartDate:enterDate endDate:[NSDate date]] durationInMinutes];
        if (minutes > RelaxSceneDefaultDuration) {
            DDLogInfo(@"start ads");
            [TWADHelp createInterstitialAndShowInViewController:self.ctrl];
            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Relax %d mins", @""), minutes];
            [MozTopAlertView showOnWindowWithType:MozAlertTypeWarning text:msg doText:nil doBlock:nil];
        }
    }
}

@end
