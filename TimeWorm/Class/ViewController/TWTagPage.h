//
//  TWTagPage.h
//  TimeWorm
//
//  Created by macbook on 16/9/19.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWSwipeViewController.h"

@class TWTagPage;
@protocol TWTagPageDelegate <NSObject>
- (void)tagPage:(TWTagPage*)tagPage addTag:(NSString*)tag ;

- (void)tagPage:(TWTagPage*)tagPage removeTag:(NSString*)tag ;

@end

@interface TWTagPage : TWSwipeViewController
@property (nonatomic, strong, readonly) NSMutableArray <NSString*>*tagsArr;
@property (nonatomic, strong, readonly) NSMutableSet <NSString*>*selectedTags;
@property (nonatomic, weak) id<TWTagPageDelegate> delegate;

- (void)setMaxSelectedTagNumber:(NSUInteger)max ;
- (void)setTagsArr:(NSMutableArray<NSString *> *)tagsArr ;
- (void)setDefaultSelectedTags:(NSArray <NSString*>*)tags ;
@end
