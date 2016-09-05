//
//  UIView+HACUtils.m
//  TimeWorm
//
//  Created by macbook on 16/9/5.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "UIView+HACUtils.h"

CGRect screenBounds(){
    return [UIScreen mainScreen].bounds;
}

CGSize screenSize(){
    return screenBounds().size;
}

CGFloat screenWidth(){
    return screenSize().width;
}

CGFloat screenHeight(){
    return screenSize().height;
}

@implementation UIView (HACUtils)

#pragma mark - getter

- (CGFloat)width{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)top{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)bottom{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)left{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)right{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)inScreenViewX {
    return CGRectGetMinX([self inScreenFrame]);
}

- (CGFloat)inScreenViewY {
    return CGRectGetMinY([self inScreenFrame]);
}

- (CGRect)inScreenFrame {
    if (!self.superview){
        return self.frame;
    }
    return [[[UIApplication sharedApplication] keyWindow] convertRect:self.frame fromView:self.superview];
}

- (CGPoint)origin {
    return self.frame.origin;
}


- (CGSize)size {
    return self.frame.size;
}

#pragma mark - setter

- (void)setWidth:(CGFloat)width{
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

- (void)setHeight:(CGFloat)height{
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

- (void)setTop:(CGFloat)top{
    CGRect newFrame = self.frame;
    newFrame.origin.y = top;
    self.frame = newFrame;
}

- (void)setBottom:(CGFloat)bottom{
    CGRect newFrame = self.frame;
    newFrame.origin.y = bottom-CGRectGetHeight(newFrame);
    self.frame = newFrame;
}

- (void)setLeft:(CGFloat)left{
    CGRect newFrame = self.frame;
    newFrame.origin.x = left;
    self.frame = newFrame;
}

- (void)setRight:(CGFloat)right{
    CGRect newFrame = self.frame;
    newFrame.origin.x = right-CGRectGetWidth(newFrame);
    self.frame = newFrame;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

@end
