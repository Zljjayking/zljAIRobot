//
//  Area.h
//  dasjdkasj
//
//  Created by kpkj-ios on 15/9/25.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject
@property (nonatomic) NSInteger areaId;
@property (nonatomic,strong) NSString * areaName;
+(id)requestWithDic:(NSDictionary*)dic;

@end
