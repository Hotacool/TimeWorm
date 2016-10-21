//
//  STPopupController+HAC.h
//  TimeWorm
//
//  Created by macbook on 16/9/12.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <STPopup/STPopup.h>

@interface STPopupController (HAC)

+ (UIViewController*)popupViewControllerName:(NSString*)name inViewController:(UIViewController*)ctrl ;
+ (UIViewController *)popupViewControllerName:(NSString *)name inViewController:(UIViewController *)ctrl withStyle:(STPopupTransitionStyle)style ;
@end
