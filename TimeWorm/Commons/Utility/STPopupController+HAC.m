//
//  STPopupController+HAC.m
//  TimeWorm
//
//  Created by macbook on 16/9/12.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "STPopupController+HAC.h"

@implementation STPopupController (HAC)

+ (UIViewController *)popupViewControllerName:(NSString *)name inViewController:(UIViewController *)ctrl {
    return [self popupViewControllerName:name inViewController:ctrl withStyle:STPopupTransitionStyleFade];
}

+ (UIViewController *)popupViewControllerName:(NSString *)name inViewController:(UIViewController *)ctrl withStyle:(STPopupTransitionStyle)style {
    UIViewController *ret;
    if (NSClassFromString(name)) {
        ret = [NSClassFromString(name) new];
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:ret];
        popupController.containerView.layer.cornerRadius = 4;
        popupController.transitionStyle = style;
        [popupController presentInViewController:ctrl];
    }
    return ret;
}
@end
