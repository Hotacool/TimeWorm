//
//  TWDBManager.h
//  TimeWorm
//
//  Created by macbook on 16/9/7.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface TWDBManager : NSObject

+ (BOOL)initializeDB ;

+ (FMDatabaseQueue*)dbQueue ;

+ (NSDictionary*)dbInformation ;
@end
