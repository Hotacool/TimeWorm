//
//  GameView.m
//  TimeWorm
//
//  Created by macbook on 16/12/9.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "GameView.h"
#import "SKMainScene.h"

#import <QuartzCore/QuartzCore.h>

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)dealloc {
    DDLogInfo(@"GameView disappear...");
}

- (void)setUp {
    self.showsFPS = YES;
    self.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [SKMainScene sceneWithSize:self.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self presentScene:scene];
    
    UIImage *image = [UIImage imageNamed:@"BurstAircraftPause"];
    UIButton *button = [[UIButton alloc]init];
    [button setFrame:CGRectMake(10, 25, image.size.width,image.size.height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:@"gameOverNotification" object:nil];
}

- (void)gameOver{
    
    UIView *backgroundView =  [[UIView alloc]initWithFrame:self.bounds];
    
    UIButton *button = [[UIButton alloc]init];
    [button setBounds:CGRectMake(0,0,200,30)];
    [button setCenter:backgroundView.center];
    [button setTitle:NSLocalizedString(@"Start a new game", @"") forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.layer setBorderWidth:2.0];
    [button.layer setCornerRadius:15.0];
    [button.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button];
    [backgroundView setCenter:self.center];
    
    [self addSubview:backgroundView];
}

- (void)pause{
    
    self.paused = YES;
    
    UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 200)];
    
    UIButton *button1 = [[UIButton alloc]init];
    [button1 setFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 100,50,200,30)];
    [button1 setTitle:NSLocalizedString(@"Continue", @"") forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1.layer setBorderWidth:2.0];
    [button1.layer setCornerRadius:15.0];
    [button1.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button1 addTarget:self action:@selector(continueGame:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]init];
    [button2 setFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 100,100,200,30)];
    [button2 setTitle:NSLocalizedString(@"Start a new game", @"") forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2.layer setBorderWidth:2.0];
    [button2.layer setCornerRadius:15.0];
    [button2.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [button2 addTarget:self action:@selector(restart:) forControlEvents:UIControlEventTouchUpInside];
    [pauseView addSubview:button2];
    
    pauseView.center = self.center;
    
    [self addSubview:pauseView];
    
}

- (void)restart:(UIButton *)button{
    [button.superview removeFromSuperview];
    self.paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"restartNotification" object:nil];
}

- (void)continueGame:(UIButton *)button{
    [button.superview removeFromSuperview];
    self.paused = NO;
}
@end
