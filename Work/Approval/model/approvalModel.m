//
//  approvalModel.m
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalModel.h"

@implementation approvalModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.application_name = [NSString stringWithFormat:@"%@",dic[@"application_name"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        
        self.seq_id = [NSString stringWithFormat:@"%@",dic[@"seq_id"]];
        self.mech_id = [NSString stringWithFormat:@"%@",dic[@"mech_id"]];
        
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            self.create_time = [Utils transportToTime:[self.create_time longLongValue]];
        }
        
        self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
        if (![Utils isBlankString:self.end_time]) {
            self.end_time = [Utils transportToTime:[self.end_time longLongValue]];
        }
        self.hour = [NSString stringWithFormat:@"%@",dic[@"hour"]];
        self.nextNickName = [NSString stringWithFormat:@"%@",dic[@"nextNickName"]];
        self.nick_name = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
        self.start_time = [NSString stringWithFormat:@"%@",dic[@"start_time"]];
        self.state_type = [NSString stringWithFormat:@"%@",dic[@"state_type"]];
        self.deptName = [NSString stringWithFormat:@"%@",dic[@"deptName"]];
        
        if (![Utils isBlankString:self.deptName]) {
            self.deptName = [NSString stringWithFormat:@"- %@",self.deptName];
        }
        
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        
        if (![Utils isBlankString:self.state_type]) {
            switch ([self.state_type integerValue]) {
                case 1:
                    self.state_type = [NSString stringWithFormat:@"未提交"];
                    break;
                case 2:
                    self.state_type = [NSString stringWithFormat:@"撤回"];
                    break;
                case 3:
                    self.state_type = [NSString stringWithFormat:@"审批中 - %@",self.nextNickName];
                    break;
                case 4:
                    self.state_type = [NSString stringWithFormat:@"驳回"];
                    break;
                case 5:
                    self.state_type = [NSString stringWithFormat:@"审批通过"];
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
