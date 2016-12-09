//
//  RelaxScene.m
//  TimeWorm
//
//  Created by macbook on 16/10/28.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "RelaxScene.h"
@import GoogleMobileAds;
#import "GameView.h"

@interface RelaxScene () <GADBannerViewDelegate>
@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) GameView *gameView;

@end

@implementation RelaxScene

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUIComponents];
    }
    return self;
}

- (void)setUIComponents {
    //渐变背景
    [self.layer insertSublayer:[TWUtility getCAGradientLayerWithFrame:self.bounds
                                                               colors:@[(__bridge id)WBlue.CGColor, (__bridge id)LBlue.CGColor]
                                                            locations:@[@(0.5f), @(1.0f)]
                                                           startPoint:CGPointMake(0.5, 0)
                                                             endPoint:CGPointMake(0.5, 1)]
                       atIndex:0];
    //advertisements
    [self addSubview:self.bannerView];
    //game view
    [self addSubview:self.gameView];
}

- (GADBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0, APPCONFIG_UI_STATUSBAR_HEIGHT)];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

- (GameView *)gameView {
    if (!_gameView) {
        CGFloat originY = CGRectGetMaxY(self.bannerView.frame)+2;
        _gameView = [[GameView alloc] initWithFrame:CGRectMake(2, originY, self.width - 4, self.height - originY - 2)];
    }
    return _gameView;
}

- (void)show {
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self.ctrl;
    [self.bannerView loadRequest:[GADRequest request]];
}

#pragma mark -- ad delegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    sfuc
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    sfuc
}
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    sfuc
}
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    sfuc
}
- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    sfuc
}
- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    sfuc
}

@end
