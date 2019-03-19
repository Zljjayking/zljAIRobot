//
//  BankModel.m
//  Financeteam
//
//  Created by Zccf on 17/4/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if ([super init]) {
        self.bankId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.bankName = [NSString stringWithFormat:@"%@",dic[@"bankName"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}
@end
