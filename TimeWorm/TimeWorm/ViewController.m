//
//  ViewController.m
//  TimeWorm
//
//  Created by macbook on 16/8/26.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "ViewController.h"
#import "MozTopAlertView.h"
#import "OLImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    OLImage *image = [OLImage imageNamed:@"思考"];
    [self.imageView setImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBt:(id)sender {
    [MozTopAlertView showWithType:MozAlertTypeWarning text:@"Warning! cannot do it!" doText:@"OK" doBlock:^{
        DDLogWarn(@"cancel it.");
        [MozTopAlertView hideViewWithParentView:self.view];
    } parentView:self.view];
    
    [self.imageView startAnimating];
}
@end
