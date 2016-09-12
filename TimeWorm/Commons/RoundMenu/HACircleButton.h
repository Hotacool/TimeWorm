//
//  HACircleButton.h
//  TimeWorm
//
//  Created by macbook on 16/9/8.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HACircleButton : UIView
@property (nonatomic, strong) NSString    *title;
@property (nonatomic,strong ) NSNumber    *CircleRadius;
@property (nonatomic,strong ) UIColor     *CircleColor;
@property (nonatomic,strong ) UIResponder *ResponderUIVC;
//每个按钮touchUpInside 的动画效果
@property (nonatomic, strong) NSMutableArray *transitionAniOffArr;
@property (nonatomic        ) BOOL        isActive;

- (instancetype)initWithCenterPoint:(CGPoint)Point
                         ButtonIcon:(UIImage*)Icon
                        SmallRadius:(CGFloat)SRadius
                          BigRadius:(CGFloat)BRadius
                       ButtonNumber:(NSInteger)Number
                         ButtonIcon:(NSArray *)ImageArray
                         ButtonText:(NSArray *)TextArray
                       ButtonTarget:(NSArray *)TargetArray
                        UseParallex:(BOOL)isParallex
                  ParallaxParameter:(CGFloat)Parallex
              RespondViewController:(UIResponder *)VC;

- (void)completeWithMessage:(NSString*)message;
- (void)setImageArray:(NSArray*)imageArray andTextArray:(NSArray*)textArray ;

@end
