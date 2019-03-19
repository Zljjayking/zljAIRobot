//
//  employeeContactModel.m
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeContactModel.h"

@implementation employeeContactModel
- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        self.relation = [NSString stringWithFormat:@"%@",dic[@"relation"]];
        self.telephone = [NSString stringWithFormat:@"%@",dic[@"telephone"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}
@end
