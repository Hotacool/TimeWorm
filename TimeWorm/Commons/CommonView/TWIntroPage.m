//
//  TWIntroPage.m
//  TimeWorm
//
//  Created by macbook on 16/12/17.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWIntroPage.h"
#import "EAIntroView.h"

NSString *const kTWIntroPageDidDismissNotification = @"kTWIntroPageDidDismissNotification";
NSString *const kTWIntroPageDidShowNotification = @"kTWIntroPageDidShowNotification";

@interface TWIntroPage () <EAIntroDelegate>
@end
@implementation TWIntroPage

HAC_SINGLETON_IMPLEMENT(TWIntroPage)

+ (UIView*)showIntroPageInView:(UIView*)view {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"周 边";
    page1.desc = @"饿了？无聊了？寂寞了？刷周边。列表＋地图，周边吃喝玩乐信息大汇总。总有一家适合你";
    page1.bgImage = [UIImage imageNamed:@"2"];
    page1.titleImage = [UIImage imageNamed:@"original"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"详情＋收藏";
    page2.desc = @"点击商户，查看商家详情。看评分，听评论，有图有真相。满意商家就收藏，下次还来容易找";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"supportcat"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"导航";
    page3.desc = @"好地方，方便去。点击详细地图，公交／步行／自驾行，条条大路通罗马。";
    page3.bgImage = [UIImage imageNamed:@"2"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_SIZE.width, APPCONFIG_UI_SCREEN_SIZE.height) andPages:@[page1,page2,page3]];
    intro.delegate = [TWIntroPage sharedTWIntroPage];
    [intro showInView:view animateDuration:0.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTWIntroPageDidDismissNotification object:nil];
    return intro;
}

+ (void)launchShowIntro {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    BOOL show = [userDefaults boolForKey:[NSString stringWithFormat:@"TWVersion_%@", version]];
    if (!show) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (window) {
            [self showIntroPageInView:window];
            [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"TWVersion_%@", version]];
            [userDefaults synchronize];
        }
    }

}

+ (void)recordInVersion:(NSString *)version {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:[NSString stringWithFormat:@"TWVersion_%@", version]];
    [userDefaults synchronize];
}

#pragma mark -- EAIntroDelegate
- (void)introDidFinish {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTWIntroPageDidDismissNotification object:nil];
}
@end
