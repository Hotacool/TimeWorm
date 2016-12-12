//
//  TWADHelp.m
//  TimeWorm
//
//  Created by macbook on 16/12/12.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWADHelp.h"
@import GoogleMobileAds;

@interface TWADHelp () <GADBannerViewDelegate, GADInterstitialDelegate>
@property (nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation TWADHelp

+ (instancetype)sharedTWADHelp {
    static TWADHelp *instance;
    if (!instance) {
        instance = [TWADHelp new];
        instance.interstitial = [instance createAndLoadInterstitial];
        instance.interstitial.delegate = instance;
    }
    return instance;
}

+ (UIView*)createBannerViewWithAdSize:(CGSize)size ViewController:(UIViewController*)ctrl {
    if (HACObjectIsNull(ctrl)) {
        DDLogError(@"ctrl is nil!");
        return nil;
    }
    GADBannerView *banner = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(size)];
    banner.delegate = [TWADHelp sharedTWADHelp];
    HACBackground(^{
        banner.adUnitID = @"ca-app-pub-7610638585158049/4302481415";
        banner.rootViewController = ctrl;
        [banner loadRequest:[GADRequest request]];
    });
    return banner;
}

+ (NSObject *)createInterstitialAndShowInViewController:(UIViewController *)ctrl {
    if (HACObjectIsNull(ctrl)) {
        DDLogError(@"ctrl is nil!");
        return nil;
    }
    if ([[TWADHelp sharedTWADHelp].interstitial isReady]) {
        [[TWADHelp sharedTWADHelp].interstitial presentFromRootViewController:ctrl];
    }
    return [TWADHelp sharedTWADHelp].interstitial;
}



- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-7610638585158049/8512355015"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
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
