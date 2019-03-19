//
//  City.m
//  dasjdkasj
//
//  Created by kpkj-ios on 15/9/25.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import "City.h"

@implementation City
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        _cityId = [dic[@"id"] integerValue];
        _cityName = dic[@"name"];
        if ([dic[@"adList"] count]>0)
        {
            _areasExists = YES;
            _areaArray = dic[@"adList"];
        }
        else
        {
            _areasExists = NO;
        }
    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}


@end
