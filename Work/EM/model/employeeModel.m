//
//  employeeModel.m
//  Financeteam
//
//  Created by Zccf on 17/4/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeModel.h"

@implementation employeeModel
/**
 @property (nonatomic) NSString *dataFlag;
 @property (nonatomic) NSString *icon;
 @property (nonatomic) NSString *mobile;
 @property (nonatomic) NSString *real_name;
 @property (nonatomic) NSString *sex;
 @property (nonatomic) NSString *userId;
 */
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.dataFlag = [NSString stringWithFormat:@"%@",dic[@"dataFlag"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.mobile = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
        self.real_name = [NSString stringWithFormat:@"%@",dic[@"real_name"]];
        self.sex = [NSString stringWithFormat:@"%@",dic[@"sex"]];
        self.userId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
