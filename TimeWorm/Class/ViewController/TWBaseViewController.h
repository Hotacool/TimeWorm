//
//  TWBaseViewController.h
//  TimeWorm
//
//  Created by macbook on 16/8/29.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWBaseViewModel.h"

@interface TWBaseViewController : UIViewController {
    TWBaseViewModel *_viewModel;
}

@property (nonatomic, strong, readonly) TWBaseViewModel *viewModel;

@end
