//
//  City.h
//  dasjdkasj
//
//  Created by kpkj-ios on 15/9/25.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Area.h"
@interface City : NSObject
@property (nonatomic) NSInteger cityId;
@property (nonatomic,strong) NSString * cityName;
@property (nonatomic,strong) NSMutableArray * areaArray;
@property (nonatomic)BOOL areasExists;
+(id)requestWithDic:(NSDictionary*)dic;

@end
