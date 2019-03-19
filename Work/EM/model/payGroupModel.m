//
//  payGroupModel.m
//  Financeteam
//
//  Created by Zccf on 17/4/27.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "payGroupModel.h"

@implementation payGroupModel
- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.Id = [NSString stringWithFormat:@"%@",dic[@"Id"]];
        self.commission = [NSString stringWithFormat:@"%@",dic[@"commission"]];
        if (![Utils isBlankString:self.commission]) {
            switch ([self.commission intValue]) {
                case 1:
                    self.commission = @"件";
                    break;
                case 2:
                    self.commission = @"量";
                    break;
                case 3:
                    self.commission = @"服务费";
                    break;
                case 4:
                    self.commission = @"放款总额";
                    break;
            }
        }
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            self.create_time = [Utils transportToDate:[self.create_time longLongValue]];
        }
        
        self.mech_id = [NSString stringWithFormat:@"%@",dic[@"mech_id"]];
        self.perNum = [NSString stringWithFormat:@"%@",dic[@"perNum"]];
        self.performance = [NSString stringWithFormat:@"%@",dic[@"performance"]];
        self.salary = [NSString stringWithFormat:@"%@",dic[@"salary"]];
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}
@end
