//
//  TWShareDataModel.h
//  TimeWorm
//
//  Created by macbook on 16/12/16.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 NSUInteger state = [[userDic objectForKey:@"state"] integerValue];
 NSDate *startDate = [userDic objectForKey:@"start"];
 NSUInteger seconds = [[userDic objectForKey:@"remainderSeconds"] integerValue];
 
 
 */
@interface TWShareDataModel : NSObject
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSUInteger state;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, strong) NSDate *enterBack;
@property (nonatomic, copy) NSString *timerName;

- (instancetype)initWithUserDic:(NSDictionary*)userDic ;

- (NSDictionary*)userDic;

@end
