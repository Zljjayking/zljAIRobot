//
//  MonthlyBaseModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "MonthlyBaseModel.h"

@implementation MonthlyBaseModel
/**
 "Normal": 10,
 "today": "2017-06-23"
 */
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         "Normal": 10,
         "today": "2017-06-23"
         */
        self.Normal = [NSString stringWithFormat:@"%@",dic[@"Normal"]];
        self.today = [NSString stringWithFormat:@"%@",dic[@"today"]];
        
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
