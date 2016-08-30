//
//  TWBaseScene.h
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWBaseSprite.h"

@interface TWBaseScene : UIView

@property (nonatomic, strong, readonly) CALayer *contentLayer;
@property (nonatomic, strong)  UIImage *backgroundImage;
@property (nonatomic, strong, readonly) NSMutableArray<__kindof TWBaseSprite*> *sprites;

- (void)addSprite:(TWBaseSprite*)sprite ;
@end
