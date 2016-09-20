//
//  TWTagView.h
//  TimeWorm
//
//  Created by macbook on 16/9/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTagView : UIScrollView
@property(nonatomic, assign) BOOL editable;// default is false, if true, editor has a input label, can delete
@property(nonatomic, assign) CGFloat tagSpace;// space between two tag, default is 10
@property(nonatomic, assign) CGFloat tagFontSize; // default is 12
@property(nonatomic) UIEdgeInsets padding; // container inner spacing, default is {10, 10, 10, 10}
@property(nonatomic) UIEdgeInsets tagTextPadding; // tag text inner spaces, default is {3, 5, 3, 5}

- (void)addTag:(NSString *)tag;
- (void)addTags:(NSArray *)tags;

- (void)removeTag:(NSString *)tag;
- (void)removeTags:(NSArray *)tags;

- (void)selectTag:(NSString *)tag;
- (void)selectTags:(NSArray *)tags;

- (void)unSelectTag:(NSString *)tag;
- (void)unSelectTags:(NSArray *)tags;

// you can monitor viewcontroller's view's tab event, call this function, and auto add the editing tag
- (void)autoAddEdtingTag;
- (NSArray *)allTags;
@end
