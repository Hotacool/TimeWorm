//
//  TWModel.h
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWDBManager.h"

@interface TWModel : NSObject

- (instancetype)initWithFMResultSet:(FMResultSet*)resultSet ;

- (NSString*)createFullUpdateSql ;
@end
