//
//  Province.m
//  dasjdkasj
//
//  Created by kpkj-ios on 15/9/25.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import "Province.h"

@implementation Province
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        _provinceId = [dic[@"id"] integerValue];
        _provinceName = dic[@"name"];
        _cityArray = dic[@"adList"];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}

@end
