//
//  Area.m
//  dasjdkasj
//
//  Created by kpkj-ios on 15/9/25.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import "Area.h"

@implementation Area
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        self.areaId = [dic[@"id"] integerValue];
        self.areaName = dic[@"name"];

    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
