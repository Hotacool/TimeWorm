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
    page1.title = @"趣味首页";
    page1.desc = @"这里有猫在等你";
    page1.bgImage = [UIImage imageNamed:@"2"];
    page1.titleImage = [UIImage imageNamed:@"intro1"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"工作页面";
    page2.desc = @"有猫陪你做任务，打断事件实时跟踪";
    page2.bgImage = [UIImage imageNamed:@"2"];
    page2.titleImage = [UIImage imageNamed:@"intro2"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"记录界面";
    page3.desc = @"任务、事件，有猫帮你详细记录";
    page3.bgImage = [UIImage imageNamed:@"2"];
    page3.titleImage = [UIImage imageNamed:@"intro3"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"休息界面";
    page4.desc = @"休息时间，有猫陪你打飞机";
    page4.bgImage = [UIImage imageNamed:@"2"];
    page4.titleImage = [UIImage imageNamed:@"intro4"];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, APPCONFIG_UI_SCREEN_SIZE.width, APPCONFIG_UI_SCREEN_SIZE.height) andPages:@[page1,page2,page3,page4]];
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
