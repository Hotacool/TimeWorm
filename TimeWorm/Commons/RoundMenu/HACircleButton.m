//
//  HACircleButton.m
//  TimeWorm
//
//  Created by macbook on 16/9/8.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "HACircleButton.h"
#import <QuartzCore/QuartzCore.h>
#import "OLImageView.h"
#import "OLImage.h"
#import <pop/POP.h>

@interface HACircleButton ()
@property (nonatomic) UIButton *SmallButton;
@property (nonatomic) UIView *BackgroundView;
@property (nonatomic) CGFloat SmallRadius;
@property (nonatomic) CGFloat BigRadius;
@property (nonatomic) CGPoint CenterPoint;
@property (nonatomic) UIImage* IconImage;
@property (nonatomic) CGFloat ParallexParameter;
@property (nonatomic) NSMutableArray* IconArray;
@property (nonatomic) NSMutableArray* InfoArray;
@property (nonatomic) NSMutableArray* ButtonTargetArray;
@property (nonatomic) BOOL isTouchDown;
@property (nonatomic) BOOL Parallex;
@property (nonatomic) BOOL isPerformingTouchUpInsideAnimation;
@property (nonatomic) CATextLayer* label;

@property (nonatomic) UIImageView *CallbackIcon;
@property (nonatomic) UILabel *CallbackMessage;
@property (nonatomic) UIImageView *loadingImageView;

@property (nonatomic) CGFloat FullPara;
@property (nonatomic) NSNumber *MidiumPara;
@property (nonatomic) NSNumber *SmallPara;

@end

@implementation HACircleButton {
    UIImageView *_loadingImageView;
    int indexTouchUpInsideButton;
}

@synthesize CircleColor,SmallRadius,BigRadius,CenterPoint,ParallexParameter;
@synthesize SmallButton,BackgroundView,IconImage,IconArray,label,InfoArray,ButtonTargetArray;
@synthesize isTouchDown,Parallex,isPerformingTouchUpInsideAnimation;
@synthesize CallbackMessage,CallbackIcon,loadingImageView;
@synthesize FullPara,MidiumPara,SmallPara;
@synthesize ResponderUIVC;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.mode = HACircleButtonModeMultiple;
    return self;
}

//Magic ....
-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (hitView == self) return nil;
    else return hitView;
}

- (instancetype)initWithCenterPoint:(CGPoint)Point
                         ButtonIcon:(UIImage*)Icon
                        SmallRadius:(CGFloat)SRadius
                          BigRadius:(CGFloat)BRadius
                       ButtonNumber:(NSInteger)Number
                         ButtonIcon:(NSArray *)ImageArray
                         ButtonText:(NSArray *)TextArray
                       ButtonTarget:(NSArray *)TargetArray
                        UseParallex:(BOOL)isParallex
                  ParallaxParameter:(CGFloat)ParallexPara
              RespondViewController:(UIResponder *)VC
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    
    self.SmallRadius = SRadius;
    self.BigRadius = BRadius;
    self.isTouchDown = NO;
    self.CenterPoint = Point;
    self.IconImage = Icon;
    self.ParallexParameter = ParallexPara;
    self.Parallex = isParallex;
    self.ResponderUIVC = VC;
    
    BackgroundView = [[UIView alloc] initWithFrame:CGRectMake(Point.x - SRadius,Point.y - SRadius, SRadius * 2, SRadius * 2)];
    BackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    BackgroundView.layer.cornerRadius = SRadius;
    [self addSubview:BackgroundView];
    
    SmallButton = [[UIButton alloc] initWithFrame:CGRectMake(Point.x - SRadius,Point.y - SRadius, SRadius * 2, SRadius * 2)];
    SmallButton.layer.cornerRadius = SRadius;
    SmallButton.layer.backgroundColor = [[UIColor colorWithRed:252.0/255.0 green:81.0/255.0 blue:106.0/255.0 alpha:1.0]CGColor];
    SmallButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    SmallButton.layer.shadowOffset = CGSizeMake(0.0, 6.0);
    SmallButton.layer.shadowOpacity = 0.3;
    SmallButton.layer.shadowRadius = 4.0;
    SmallButton.layer.zPosition = BRadius;
    
    [SmallButton setImage:IconImage forState:UIControlStateNormal];
    
    [SmallButton addTarget:self action:@selector(TouchDown) forControlEvents:UIControlEventTouchDown];
    [SmallButton addTarget:self action:@selector(TouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [SmallButton addTarget:self action:@selector(TouchDrag:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [SmallButton addTarget:self action:@selector(TouchUpInside:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [SmallButton addTarget:self action:@selector(TouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:SmallButton];
    
    ButtonTargetArray = [NSMutableArray arrayWithArray:TargetArray];
    InfoArray = [NSMutableArray arrayWithArray:TextArray];
    
    label = [[CATextLayer alloc] init];
    [label setFontSize:9.0f];
    [label setString:self.title?:[NSString stringWithFormat:@"Choose:"]];
    label.fontSize = 40;
    label.font = (__bridge CFTypeRef)@"ArialMT";
    label.alignmentMode = kCAAlignmentCenter;
    [label setForegroundColor:[[UIColor colorWithWhite:1.0 alpha:0.0]CGColor]];
    [label setFrame:CGRectMake(-SmallRadius*3, -52, SmallRadius * 8,100)];
    
    
    CGFloat UnScaleFactor = SmallRadius/BigRadius;
    label.transform = CATransform3DMakeScale(UnScaleFactor, UnScaleFactor, 1.0f);
    [SmallButton.layer addSublayer:label];
    
    CGFloat TransformPara = BigRadius / SmallRadius;
    CGFloat MultiChoiceRadius = (BigRadius + SmallRadius)/8/TransformPara;
    IconArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < Number; i++)
    {
        
        CGFloat XOffest = 4 * MultiChoiceRadius * cos(2*M_PI*i/Number);
        CGFloat YOffest = 4 * MultiChoiceRadius * sin(2*M_PI*i/Number);
        
        
        UIImageView *IconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SRadius + XOffest - MultiChoiceRadius , SRadius + YOffest - MultiChoiceRadius, MultiChoiceRadius * 2, MultiChoiceRadius * 2)];
        if ([[ImageArray objectAtIndex:i] isKindOfClass:[UIImage class]])
        {
            IconImageView.image = [ImageArray objectAtIndex:i];
            IconImageView.alpha = 0.0f;
            [IconImageView setHidden:YES];
            [self.SmallButton addSubview:IconImageView];
            [self.SmallButton bringSubviewToFront:IconImageView];
            IconImageView.layer.contentsScale = [[UIScreen mainScreen] scale]*BigRadius/SmallRadius;
            [IconArray addObject:IconImageView];
        }
    }
    
    
    CGFloat UnFullFactor = SmallRadius/self.frame.size.height;
    CallbackIcon = [[UIImageView alloc] initWithFrame:CGRectMake((SmallButton.frame.size.width - BigRadius)/2, (SmallButton.frame.size.height - BigRadius)/2, BigRadius, BigRadius)];
    CallbackIcon.layer.transform = CATransform3DMakeScale(UnFullFactor, UnFullFactor, 1.0f);
    
    CallbackIcon.image = [UIImage imageNamed:@"CallbackSuccess"];
    
    [CallbackIcon setAlpha:0.0f];
    [SmallButton addSubview:CallbackIcon];
    
    CallbackMessage = [[UILabel alloc] init];
    CallbackMessage.text = @"";
    CallbackMessage.alpha = 0.0f;
    CallbackMessage.font = [UIFont systemFontOfSize:20];
    CallbackMessage.layer.transform = CATransform3DMakeScale(UnFullFactor, UnFullFactor, 1.0f);
    CallbackMessage.textColor = [UIColor whiteColor];
    CallbackMessage.textAlignment = NSTextAlignmentCenter;
    [CallbackMessage setFrame:CGRectMake((SmallButton.frame.size.width - SmallRadius/2)/2, (SmallButton.frame.size.height - SmallRadius/4)/2+ 6, SmallRadius/2, SmallRadius/4)];
    [SmallButton addSubview: CallbackMessage];
    //loading image
    loadingImageView = [[OLImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingImageView.center = CGPointMake(APPCONFIG_UI_SCREEN_FWIDTH/2, APPCONFIG_UI_SCREEN_FHEIGHT/2);
    
    FullPara = self.frame.size.height/SmallRadius;
    MidiumPara = [SmallButton.layer valueForKeyPath:@"transform.scale"];
    SmallPara = [NSNumber numberWithFloat:1.0f];
    
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title) {
        [label setString:title];
    }
}

- (void)TouchDown
{
    if (self.isPerformingTouchUpInsideAnimation) {
        return;
    }
    
    if (!isTouchDown)
    {
        if (self.mode == HACircleButtonModeMultiple) {
            [self TouchDownAnimation];
            [label setForegroundColor:[[UIColor colorWithWhite:1.0 alpha:1.0]CGColor]];
        }
    }
    self.isTouchDown = YES;
    self.isActive = YES;
    
}

- (void)TouchDownAnimation
{
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ [SmallButton.imageView setAlpha:0.0]; } completion:^(BOOL finished){ if (finished) {
        [SmallButton setImage:nil forState:UIControlStateNormal];
    }}];
    
    CABasicAnimation *ButtonScaleBigCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleBigCABasicAnimation.duration = 0.1f;
    ButtonScaleBigCABasicAnimation.autoreverses = NO;
    ButtonScaleBigCABasicAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    ButtonScaleBigCABasicAnimation.toValue = [NSNumber numberWithFloat:BigRadius / SmallRadius];
    ButtonScaleBigCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleBigCABasicAnimation.removedOnCompletion = NO;
    
    [SmallButton.layer addAnimation:ButtonScaleBigCABasicAnimation forKey:@"ButtonScaleBigCABasicAnimation"];
    
    CABasicAnimation *BackgroundViewScaleBigCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    BackgroundViewScaleBigCABasicAnimation.duration = 0.1f;
    BackgroundViewScaleBigCABasicAnimation.autoreverses = NO;
    BackgroundViewScaleBigCABasicAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    BackgroundViewScaleBigCABasicAnimation.toValue = [NSNumber numberWithFloat:self.frame.size.height / SmallRadius];
    BackgroundViewScaleBigCABasicAnimation.fillMode = kCAFillModeForwards;
    BackgroundViewScaleBigCABasicAnimation.removedOnCompletion = NO;
    
    [BackgroundView.layer addAnimation:BackgroundViewScaleBigCABasicAnimation forKey:@"BackgroundViewScaleBigCABasicAnimation"];
    
    for (UIImageView *Icon in IconArray)
    {
        [self.layer removeAllAnimations];
        [Icon setHidden:NO];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ Icon.alpha = 0.7f; } completion:^(BOOL finished){}];
    }
}
-(void)TouchDrag:(UIButton *)sender withEvent:(UIEvent *)event
{
    if (self.mode == HACircleButtonModeSingle) {
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint Point = [touch locationInView:self];
    //NSLog(@"TouchDrag:%@", NSStringFromCGPoint(Point));
    
    //UP: XOffest = MAX MakeRotation (xoffest,1,0,0)
    //RIGHT: YOffest = MAX MakeRotation (yoffest,0,1,0)
    CGFloat XOffest = Point.x - CenterPoint.x;
    CGFloat YOffest = Point.y - CenterPoint.y;
    //NSLog(@"XOffest %f    YOffest %f",XOffest,YOffest);
    
    CGFloat XDegress = XOffest / self.frame.size.width;
    CGFloat YDegress = YOffest / self.frame.size.height;
    //NSLog(@"XDegress %f    YDegress %f",XDegress,YDegress);
    
    CATransform3D Rotate = CATransform3DConcat(CATransform3DMakeRotation(XDegress, 0, 1, 0), CATransform3DMakeRotation(-YDegress, 1, 0, 0));
    if (Parallex)
    {
        SmallButton.layer.transform = CATransform3DPerspect(Rotate, CGPointMake(0, 0), BigRadius+ParallexParameter);
    }
    else
    {
        //Do nothing ^_^
    }
    
    NSUInteger count = 0;
    NSString *infotext;
    for (UIImageView *Icon in IconArray)
    {
        
        // Child center relative to parent
        CGPoint childPosition = [Icon.layer.presentationLayer position];
        
        // Parent center relative to UIView
        CGPoint parentPosition = [SmallButton.layer.presentationLayer position];
        CGPoint parentCenter = CGPointMake(SmallButton.bounds.size.width/2.0, SmallButton.bounds.size.height /2.0);
        
        // Child center relative to parent center
        CGPoint relativePos = CGPointMake(childPosition.x - parentCenter.x, childPosition.y - parentCenter.y);
        
        // Transformed child position based on parent's transform (rotations, scale etc)
        CGPoint transformedChildPos = CGPointApplyAffineTransform(relativePos, [SmallButton.layer.presentationLayer affineTransform]);
        
        // And finally...
        CGPoint positionInView = CGPointMake(parentPosition.x +transformedChildPos.x, parentPosition.y + transformedChildPos.y);
        
        //NSLog(@"positionInView %@",NSStringFromCGPoint(positionInView));
        
        //NSLog(@"View'S position %@",NSStringFromCGPoint(self.layer.position));
        
        CGFloat XOffest = (positionInView.x - self.CenterPoint.x)/SmallRadius*BigRadius;
        CGFloat YOffest = (positionInView.y - self.CenterPoint.y)/SmallRadius*BigRadius;
        
        CGRect IconCGRectinWorld = CGRectMake(self.CenterPoint.x + XOffest - (BigRadius + SmallRadius)/4, self.CenterPoint.y + YOffest - (BigRadius + SmallRadius)/4, (BigRadius + SmallRadius)/2, (BigRadius + SmallRadius)/2);
        
        //UIView *DEBUGVIEW = [[UIView alloc] initWithFrame:IconCGRectinWorld];
        //DEBUGVIEW.backgroundColor = [UIColor blackColor];
        //[self addSubview:DEBUGVIEW];
        
        if (CGRectContainsPoint(IconCGRectinWorld, Point))
        {
            //NSLog(@"Selected A button");
            [Icon setAlpha:1.0f];
            
            if ([[InfoArray objectAtIndex:count] isKindOfClass:[NSString class]])
            {
                //NSLog(@"INFO ");
                infotext = InfoArray[count];
            }
            
            
        }
        else
        {
            [Icon setAlpha:0.7f];
        }
        
        count++;
    }
    if (infotext)
    {
        [label setString:infotext];
    }
    else
    {
        [label setString:self.title?:[NSString stringWithFormat:@"Choose:"]];
    }
    
}


- (void)TouchUpInside:(UIButton *)sender withEvent:(UIEvent *)event
{
    if (self.mode == HACircleButtonModeSingle) {
        [SmallButton.imageView setAlpha:0.0];
        [SmallButton setImage:nil forState:UIControlStateNormal];
        [self TouchUpInsideAnimation];
        if (ResponderUIVC) {
            SEL selector = NSSelectorFromString(@"circleBttonTouchDown");
            IMP imp = [ResponderUIVC methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(ResponderUIVC, selector);
        }
        self.isTouchDown = NO;
        return;
    }
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint Point = [touch locationInView:self];
    //NSLog(@"TouchUpInside:%@", NSStringFromCGPoint(Point));
    
    [label setForegroundColor:[[UIColor colorWithWhite:1.0 alpha:0.0]CGColor]];
    
    BOOL isTouchUpInsideButton = NO;
    indexTouchUpInsideButton = 0;
    int count = 0;
    
    if (isTouchDown)
    {
        
        for (UIImageView *Icon in IconArray)
        {
            
            // Child center relative to parent
            CGPoint childPosition = [Icon.layer.presentationLayer position];
            
            // Parent center relative to UIView
            CGPoint parentPosition = [SmallButton.layer.presentationLayer position];
            CGPoint parentCenter = CGPointMake(SmallButton.bounds.size.width/2.0, SmallButton.bounds.size.height /2.0);
            
            // Child center relative to parent center
            CGPoint relativePos = CGPointMake(childPosition.x - parentCenter.x, childPosition.y - parentCenter.y);
            
            // Transformed child position based on parent's transform (rotations, scale etc)
            CGPoint transformedChildPos = CGPointApplyAffineTransform(relativePos, [SmallButton.layer.presentationLayer affineTransform]);
            
            // And finally...
            CGPoint positionInView = CGPointMake(parentPosition.x +transformedChildPos.x, parentPosition.y + transformedChildPos.y);
            
            //NSLog(@"positionInView %@",NSStringFromCGPoint(positionInView));
            
            //NSLog(@"View'S position %@",NSStringFromCGPoint(self.layer.position));
            
            CGFloat XOffest = (positionInView.x - self.CenterPoint.x)/SmallRadius*BigRadius;
            CGFloat YOffest = (positionInView.y - self.CenterPoint.y)/SmallRadius*BigRadius;
            
            CGRect IconCGRectinWorld = CGRectMake(self.CenterPoint.x + XOffest - (BigRadius + SmallRadius)/4, self.CenterPoint.y + YOffest - (BigRadius + SmallRadius)/4, (BigRadius + SmallRadius)/2, (BigRadius + SmallRadius)/2);
            
            //UIView *DEBUGVIEW = [[UIView alloc] initWithFrame:IconCGRectinWorld];
            //DEBUGVIEW.backgroundColor = [UIColor blackColor];
            //[self addSubview:DEBUGVIEW];
            if (CGRectContainsPoint(IconCGRectinWorld, Point))
            {
                isTouchUpInsideButton = YES;
                indexTouchUpInsideButton = count;
            }
            
            count++;
        }
        
        if (isTouchUpInsideButton)
        {
            if ([self needShowTransitionAni]) {
                [self TouchUpInsideAnimation];
            } else {
                [self TouchUpInsideAnimationWithoutTransition];
            }
            if ([ButtonTargetArray[indexTouchUpInsideButton] isKindOfClass:[NSString class]])
            {
                if (ResponderUIVC)
                {
                    SEL selector = NSSelectorFromString(ButtonTargetArray[indexTouchUpInsideButton]);
                    IMP imp = [ResponderUIVC methodForSelector:selector];
                    void (*func)(id, SEL) = (void *)imp;
                    func(ResponderUIVC, selector);
                }
            }
        }
        else
        {
            [self TouchUpAnimation];
        }
    }
    self.isTouchDown = NO;
    self.isActive = isTouchUpInsideButton;
    
}
- (void)TouchUpOutside
{
    if (self.mode == HACircleButtonModeSingle) {
        return;
    }
    if (isTouchDown)
    {
        [self TouchUpAnimation];
        [label setForegroundColor:[[UIColor colorWithWhite:1.0 alpha:0.0]CGColor]];
    }
    self.isTouchDown = NO;
    self.isActive = NO;
}

- (void)TouchUpInsideAnimation
{
    self.isPerformingTouchUpInsideAnimation = YES;
    SmallButton.enabled = NO;
    
    for (UIImageView *Icon in IconArray)
    {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ Icon.alpha = 0.0f; } completion:^(BOOL finished){if (finished) {[Icon setHidden:YES];}}];
    }
    
    CABasicAnimation *BackgroundViewScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    BackgroundViewScaleSmallCABasicAnimation.duration = 0.1f;
    BackgroundViewScaleSmallCABasicAnimation.autoreverses = NO;
    BackgroundViewScaleSmallCABasicAnimation.toValue = SmallPara;
    BackgroundViewScaleSmallCABasicAnimation.fromValue = MidiumPara;
    BackgroundViewScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    BackgroundViewScaleSmallCABasicAnimation.removedOnCompletion = NO;
    BackgroundViewScaleSmallCABasicAnimation.beginTime = 0.0f;
    [BackgroundView.layer addAnimation:BackgroundViewScaleSmallCABasicAnimation forKey:@"BackgroundViewScaleSmallCABasicAnimation"];
    
    CABasicAnimation *ButtonScaleFullCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleFullCABasicAnimation.duration = 0.2f;
    ButtonScaleFullCABasicAnimation.autoreverses = NO;
    ButtonScaleFullCABasicAnimation.toValue = @(FullPara);
    ButtonScaleFullCABasicAnimation.fromValue = MidiumPara;
    ButtonScaleFullCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleFullCABasicAnimation.removedOnCompletion = NO;
    ButtonScaleFullCABasicAnimation.beginTime = 0.0f;
    
    //[SmallButton.layer addAnimation:ButtonScaleFullCABasicAnimation forKey:@"ButtonScaleAnimation"];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:ButtonScaleFullCABasicAnimation, nil];
    animGroup.duration = 0.4f;
    animGroup.removedOnCompletion = NO;
    animGroup.autoreverses = NO;
    animGroup.fillMode = kCAFillModeForwards;
    
    [CATransaction begin];
    SBWS(weakSelf)
    [CATransaction setCompletionBlock:^
     {
         if (weakSelf.isPerformingTouchUpInsideAnimation) {
             weakSelf.isPerformingTouchUpInsideAnimation = NO;
             [weakSelf addLoadingViewWithImage:[OLImage imageNamed:@"跳舞"]];
         }
     }];
    [SmallButton.layer addAnimation:animGroup forKey:@"ButtonScaleAnimation"];
    [CATransaction commit];
    
    
    CATransform3D Rotate = CATransform3DConcat(CATransform3DMakeRotation(0, 0, 1, 0), CATransform3DMakeRotation(0, 1, 0, 0));
    if (Parallex)
    {
        SmallButton.layer.transform = CATransform3DPerspect(Rotate, CGPointMake(0, 0), BigRadius+ParallexParameter);
    }
    else
    {
        //Do nothing ^_^
    }
    
    
}

- (void)setImageArray:(NSArray *)imageArray andTextArray:(NSArray *)textArray {
    if (imageArray&&imageArray.count==IconArray.count) {
        [IconArray enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.image = imageArray[idx];
        }];
    } else {
        DDLogWarn(@"cannot set image array for obj: %@", imageArray);
    }
    if (textArray&&textArray.count==InfoArray.count) {
        [InfoArray removeAllObjects];
        [InfoArray addObjectsFromArray:textArray];
    } else {
        DDLogWarn(@"cannot set text array for obj: %@", textArray);
    }
}

- (void)completeWithMessage:(NSString*)message {
    if (![self needShowTransitionAni]) {
        return;
    }
    if (self.isPerformingTouchUpInsideAnimation) {
        self.isPerformingTouchUpInsideAnimation = NO;
    }
    [self addLoadingViewWithImage:[OLImage imageNamed:@"高兴"]];
    
    CABasicAnimation *ButtonScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleSmallCABasicAnimation.duration = 0.2f;
    ButtonScaleSmallCABasicAnimation.autoreverses = NO;
    ButtonScaleSmallCABasicAnimation.fromValue = @(FullPara);
    ButtonScaleSmallCABasicAnimation.toValue = SmallPara;
    ButtonScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleSmallCABasicAnimation.removedOnCompletion = NO;
    ButtonScaleSmallCABasicAnimation.beginTime = 0.0f;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(900 *NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self removeLoadingViewImage];
        SBWS(weakSelf)
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:0.1 animations:^(void){ [CallbackIcon setAlpha:0.0]; } completion:^(BOOL finished){}];
            [UIView animateWithDuration:0.1 animations:^(void){ CallbackMessage.alpha = 0.0;  } completion:^(BOOL finished){}];
            [SmallButton setImage:IconImage forState:UIControlStateNormal];
            SmallButton.enabled = YES;
            weakSelf.isActive = NO;
            [UIView animateWithDuration:0.1 animations:^(void){ [SmallButton.imageView setAlpha:1.0]; } completion:^(BOOL finished){}];
        }];
        [SmallButton.layer addAnimation:ButtonScaleSmallCABasicAnimation forKey:@"ButtonScaleAnimation"];
        [CATransaction commit];
    });
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

- (void)TouchUpAnimation
{
    for (UIImageView *Icon in IconArray)
    {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ Icon.alpha = 0.0f; } completion:^(BOOL finished){if (finished) {[Icon setHidden:YES];}}];
    }
    
    CABasicAnimation *ButtonScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleSmallCABasicAnimation.duration = 0.2f;
    ButtonScaleSmallCABasicAnimation.autoreverses = NO;
    ButtonScaleSmallCABasicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    ButtonScaleSmallCABasicAnimation.fromValue = [NSNumber numberWithFloat:BigRadius / SmallRadius];
    ButtonScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleSmallCABasicAnimation.removedOnCompletion = NO;
    
    [SmallButton.layer addAnimation:ButtonScaleSmallCABasicAnimation forKey:@"ButtonScaleSmallCABasicAnimation"];
    
    CABasicAnimation *BackgroundViewScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    BackgroundViewScaleSmallCABasicAnimation.duration = 0.1f;
    BackgroundViewScaleSmallCABasicAnimation.autoreverses = NO;
    BackgroundViewScaleSmallCABasicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    BackgroundViewScaleSmallCABasicAnimation.fromValue = [NSNumber numberWithFloat:self.frame.size.height / SmallRadius];
    BackgroundViewScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    BackgroundViewScaleSmallCABasicAnimation.removedOnCompletion = NO;
    
    [BackgroundView.layer addAnimation:BackgroundViewScaleSmallCABasicAnimation forKey:@"BackgroundViewScaleSmallCABasicAnimation"];
    
    CATransform3D Rotate = CATransform3DConcat(CATransform3DMakeRotation(0, 0, 1, 0), CATransform3DMakeRotation(0, 1, 0, 0));
    if (Parallex)
    {
        SmallButton.layer.transform = CATransform3DPerspect(Rotate, CGPointMake(0, 0), BigRadius+ParallexParameter);
    }
    else
    {
        //Do nothing ^_^
    }
    
    
    [SmallButton setImage:IconImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ [SmallButton.imageView setAlpha:1.0]; } completion:^(BOOL finished){}];
    
}

- (void)TouchUpInsideAnimationWithoutTransition
{
    for (UIImageView *Icon in IconArray)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ Icon.alpha = 0.0f; } completion:^(BOOL finished){if (finished) {[Icon setHidden:YES];}}];
    }
    
    CABasicAnimation *ButtonScaleSmallCABasicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleSmallCABasicAnimation1.duration = 0.2f;
    ButtonScaleSmallCABasicAnimation1.beginTime = 0.0f;
    ButtonScaleSmallCABasicAnimation1.autoreverses = NO;
    ButtonScaleSmallCABasicAnimation1.toValue = [NSNumber numberWithFloat:1.2 * BigRadius / SmallRadius];
    ButtonScaleSmallCABasicAnimation1.fromValue = [NSNumber numberWithFloat:BigRadius / SmallRadius];
    ButtonScaleSmallCABasicAnimation1.fillMode = kCAFillModeForwards;
    ButtonScaleSmallCABasicAnimation1.removedOnCompletion = NO;
    
    CABasicAnimation *ButtonScaleSmallCABasicAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleSmallCABasicAnimation2.duration = 0.1f;
    ButtonScaleSmallCABasicAnimation2.beginTime = 0.2f;
    ButtonScaleSmallCABasicAnimation2.autoreverses = NO;
    ButtonScaleSmallCABasicAnimation2.toValue = [NSNumber numberWithFloat:1.0f];
    ButtonScaleSmallCABasicAnimation2.fillMode = kCAFillModeForwards;
    ButtonScaleSmallCABasicAnimation2.removedOnCompletion = NO;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:ButtonScaleSmallCABasicAnimation1,ButtonScaleSmallCABasicAnimation2, nil];
    animGroup.duration = 0.3f;
    animGroup.removedOnCompletion = NO;
    animGroup.autoreverses = NO;
    animGroup.fillMode = kCAFillModeForwards;
    
    
    CABasicAnimation *BackgroundViewScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    BackgroundViewScaleSmallCABasicAnimation.duration = 0.1f;
    BackgroundViewScaleSmallCABasicAnimation.autoreverses = NO;
    BackgroundViewScaleSmallCABasicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    BackgroundViewScaleSmallCABasicAnimation.fromValue = [NSNumber numberWithFloat:self.frame.size.height / SmallRadius];
    BackgroundViewScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    BackgroundViewScaleSmallCABasicAnimation.removedOnCompletion = NO;
    
    
    [CATransaction begin];
    SBWS(weakSelf)
    [CATransaction setCompletionBlock:^{
         DDLogInfo(@"complete.");
         [SmallButton setImage:IconImage forState:UIControlStateNormal];
         SmallButton.enabled = YES;
         weakSelf.isActive = NO;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){ [SmallButton.imageView setAlpha:1.0]; } completion:^(BOOL finished){}];
     }];
    [SmallButton.layer addAnimation:animGroup forKey:@"ButtonScaleSmallCABasicAnimationxxx"];
    [BackgroundView.layer addAnimation:BackgroundViewScaleSmallCABasicAnimation forKey:@"BackgroundViewScaleSmallCABasicAnimation"];
    [CATransaction commit];
    
    CATransform3D Rotate = CATransform3DConcat(CATransform3DMakeRotation(0, 0, 1, 0), CATransform3DMakeRotation(0, 1, 0, 0));
    if (Parallex)
    {
        SmallButton.layer.transform = CATransform3DPerspect(Rotate, CGPointMake(0, 0), BigRadius+ParallexParameter);
    }
    else
    {
        //Do nothing ^_^
    }
    
}

- (void)addLoadingViewWithImage:(UIImage *)image {
    if (![self.loadingImageView superview]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.loadingImageView];
    }
    [self.loadingImageView setImage:image];
}

- (void)removeLoadingViewImage {
    if ([self.loadingImageView superview]) {
        [self.loadingImageView stopAnimating];
        [self.loadingImageView removeFromSuperview];
    }
}

#pragma mark -- nouse
- (void)SuccessCallBackWithMessage:(NSString *)String
{
    CallbackIcon.image = [UIImage imageNamed:@"CallbackSuccess"];
    CallbackMessage.text = String;
    [UIView animateWithDuration:0.3 animations:^(void){ CallbackMessage.alpha = 1.0; } completion:^(BOOL finished){}];
    [UIView animateWithDuration:0.3 animations:^(void){ [CallbackIcon setAlpha:1.0]; } completion:^(BOOL finished){}];
    
    CABasicAnimation *ButtonScaleKeepCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleKeepCABasicAnimation.duration = 2.0f;
    ButtonScaleKeepCABasicAnimation.autoreverses = NO;
    ButtonScaleKeepCABasicAnimation.fromValue = @(FullPara);
    ButtonScaleKeepCABasicAnimation.toValue = @(FullPara);
    ButtonScaleKeepCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleKeepCABasicAnimation.removedOnCompletion = NO;
    ButtonScaleKeepCABasicAnimation.beginTime = 0.0f;
    
    CABasicAnimation *ButtonScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleSmallCABasicAnimation.duration = 0.2f;
    ButtonScaleSmallCABasicAnimation.autoreverses = NO;
    ButtonScaleSmallCABasicAnimation.fromValue = @(FullPara);
    ButtonScaleSmallCABasicAnimation.toValue = SmallPara;
    ButtonScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleSmallCABasicAnimation.removedOnCompletion = NO;
    ButtonScaleSmallCABasicAnimation.beginTime = 2.0f;
    
    //[SmallButton.layer addAnimation:ButtonScaleSmallCABasicAnimation forKey:@"ButtonScaleAnimation"];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:ButtonScaleKeepCABasicAnimation,ButtonScaleSmallCABasicAnimation, nil];
    animGroup.duration = 2.2f;
    animGroup.removedOnCompletion = NO;
    animGroup.autoreverses = NO;
    animGroup.fillMode = kCAFillModeForwards;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^
     {
         [UIView animateWithDuration:0.1 animations:^(void){ [CallbackIcon setAlpha:0.0]; } completion:^(BOOL finished){}];
         [UIView animateWithDuration:0.1 animations:^(void){ CallbackMessage.alpha = 0.0;  } completion:^(BOOL finished){}];
         [SmallButton setImage:IconImage forState:UIControlStateNormal];
         [UIView animateWithDuration:0.1 animations:^(void){ [SmallButton.imageView setAlpha:1.0]; } completion:^(BOOL finished){}];
     }];
    [SmallButton.layer addAnimation:animGroup forKey:@"ButtonScaleAnimation"];
    [CATransaction commit];
    
}
- (void)FailedCallBackWithMessage:(NSString *)String
{
    CallbackIcon.image = [UIImage imageNamed:@"CallbackWrong"];
    CallbackMessage.text = String;
    [UIView animateWithDuration:0.3 animations:^(void){ [CallbackMessage setAlpha:1.0]; } completion:^(BOOL finished){}];
    [UIView animateWithDuration:0.3 animations:^(void){ [CallbackIcon setAlpha:1.0]; } completion:^(BOOL finished){}];
    
    CABasicAnimation *ButtonScaleKeepCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleKeepCABasicAnimation.duration = 2.0f;
    ButtonScaleKeepCABasicAnimation.autoreverses = NO;
    ButtonScaleKeepCABasicAnimation.fromValue = @(FullPara);
    ButtonScaleKeepCABasicAnimation.toValue = @(FullPara);
    ButtonScaleKeepCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleKeepCABasicAnimation.removedOnCompletion = NO;
    ButtonScaleKeepCABasicAnimation.beginTime = 0.0f;
    
    CABasicAnimation *ButtonScaleSmallCABasicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    ButtonScaleSmallCABasicAnimation.duration = 0.2f;
    ButtonScaleSmallCABasicAnimation.autoreverses = NO;
    ButtonScaleSmallCABasicAnimation.fromValue = @(FullPara);
    ButtonScaleSmallCABasicAnimation.toValue = SmallPara;
    ButtonScaleSmallCABasicAnimation.fillMode = kCAFillModeForwards;
    ButtonScaleSmallCABasicAnimation.removedOnCompletion = NO;
    ButtonScaleSmallCABasicAnimation.beginTime = 2.0f;
    
    //[SmallButton.layer addAnimation:ButtonScaleSmallCABasicAnimation forKey:@"ButtonScaleAnimation"];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:ButtonScaleKeepCABasicAnimation,ButtonScaleSmallCABasicAnimation, nil];
    animGroup.duration = 2.2f;
    animGroup.removedOnCompletion = NO;
    animGroup.autoreverses = NO;
    animGroup.fillMode = kCAFillModeForwards;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^
     {
         [UIView animateWithDuration:0.1 animations:^(void){ [CallbackIcon setAlpha:0.0]; } completion:^(BOOL finished){}];
         [UIView animateWithDuration:0.1 animations:^(void){ [CallbackMessage setAlpha:0.0]; } completion:^(BOOL finished){}];
         [SmallButton setImage:IconImage forState:UIControlStateNormal];
         [UIView animateWithDuration:0.1 animations:^(void){ [SmallButton.imageView setAlpha:1.0]; } completion:^(BOOL finished){}];
     }];
    [SmallButton.layer addAnimation:animGroup forKey:@"ButtonScaleAnimation"];
    [CATransaction commit];
    
    
}

- (BOOL)needShowTransitionAni {
    BOOL ret = YES;
    if (self.transitionAniOffArr&&self.transitionAniOffArr.count>indexTouchUpInsideButton) {
        BOOL transitionAniOff = [self.transitionAniOffArr[indexTouchUpInsideButton] boolValue];
        if (transitionAniOff) {
            ret = NO;
        } else {
        }
    } else {
    }
    return ret;
}

@end
