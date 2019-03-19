//
//  approvalDetailModel.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalDetailModel.h"

@implementation approvalDetailModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        self.nextUserId = [NSString stringWithFormat:@"%@",dic[@"nextUserId"]];
        self.apply_name = [NSString stringWithFormat:@"%@",dic[@"apply_name"]];
        self.application_name = [NSString stringWithFormat:@"%@",dic[@"application_name"]];
        self.application_id = [NSString stringWithFormat:@"%@",dic[@"application_id"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.businessAddress = [NSString stringWithFormat:@"%@",dic[@"businessAddress"]];
        self.goodsPurchased = [NSString stringWithFormat:@"%@",dic[@"goodsPurchased"]];
        self.handover = [NSString stringWithFormat:@"%@",dic[@"handover"]];
        self.reimbursement_amount = [NSString stringWithFormat:@"%@",dic[@"reimbursement_amount"]];
        self.specificationModel = [NSString stringWithFormat:@"%@",dic[@"specificationModel"]];
        self.title = [NSString stringWithFormat:@"%@",dic[@"title"]];
        self.flow_name = [NSString stringWithFormat:@"%@",dic[@"flow_name"]];
        
        self.seq_id = [NSString stringWithFormat:@"%@",dic[@"seq_id"]];
        self.apply_id = [NSString stringWithFormat:@"%@",dic[@"apply_id"]];
        
        self.clock_time = [NSString stringWithFormat:@"%@",dic[@"clock_time"]];
        if (![Utils isBlankString:self.clock_time]) {
            self.clock_time = [Utils transportToDate:[self.clock_time longLongValue]];
        }
        
        self.start_time = [NSString stringWithFormat:@"%@",dic[@"start_time"]];
        if (![Utils isBlankString:self.start_time]) {
            self.start_time = [Utils transportToDate:[self.start_time longLongValue]];
        }
        
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            self.create_time = [Utils transportToTime:[self.create_time longLongValue]];
        }
        
        self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
        if (![Utils isBlankString:self.end_time]) {
            self.end_time = [Utils transportToDate:[self.end_time longLongValue]];
        }
        
        if ([self.application_id isEqualToString:@"5"] || [self.application_id isEqualToString:@"10"] || [self.application_id isEqualToString:@"2"]) {
            self.start_time = [NSString stringWithFormat:@"%@",dic[@"start_time"]];
            if (![Utils isBlankString:self.start_time]) {
                self.start_time = [Utils transportToDate:[self.start_time longLongValue] DateFormat:@"YYYY-MM-dd HH:mm"];
            }
            
            self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
            if (![Utils isBlankString:self.end_time]) {
                self.end_time = [Utils transportToDate:[self.end_time longLongValue] DateFormat:@"YYYY-MM-dd HH:mm"];
            }
            
        }
        
        /**
         @property (nonatomic) NSString *apply_name;
         @property (nonatomic) NSString *application_id;
         @property (nonatomic) NSString *application_name;
         @property (nonatomic) NSString *create_time;
         @property (nonatomic) NSString *end_time;
         @property (nonatomic) NSString *businessAddress;
         @property (nonatomic) NSString *clock_time;
         @property (nonatomic) NSString *goodsPurchased;
         @property (nonatomic) NSString *handover;
         @property (nonatomic) NSString *leave_type_name;
         @property (nonatomic) NSString *nowUserId;
         @property (nonatomic) NSString *number;
         @property (nonatomic) NSString *position;
         @property (nonatomic) NSString *reason;
         
         @property (nonatomic) NSString *reimbursement_amount;
         
         @property (nonatomic) NSString *specificationModel;
         @property (nonatomic) NSString *start_time;
         @property (nonatomic) NSString *state_type;
         @property (nonatomic) NSString *title;
         
         @property (nonatomic) NSString *toUser;
         @property (nonatomic) NSString *toUserName;
         
         @property (nonatomic) NSString *flow_id;
         
         @property (nonatomic) NSString *leave_reason;
         @property (nonatomic) NSString *leave_type_id;
         @property (nonatomic) NSString *hour;
         @property (nonatomic) NSString *icon;
         @property (nonatomic) NSString *nextNickName;
         @property (nonatomic) NSString *nick_name;
         @property (nonatomic) NSString *deptName;
         @property (nonatomic) NSString *Id;
         */
        self.flow_id = [NSString stringWithFormat:@"%@",dic[@"flow_id"]];
        self.leave_reason = [NSString stringWithFormat:@"%@",dic[@"leave_reason"]];
        self.leave_type_id = [NSString stringWithFormat:@"%@",dic[@"leave_type_id"]];
        self.leave_type_name = [NSString stringWithFormat:@"%@",dic[@"leave_type_name"]];
        self.toUser = [NSString stringWithFormat:@"%@",dic[@"toUser"]];
        self.toUserName = [NSString stringWithFormat:@"%@",dic[@"toUserName"]];
        self.nowUserId = [NSString stringWithFormat:@"%@",dic[@"nowUserId"]];
        self.number = [NSString stringWithFormat:@"%@",dic[@"number"]];
        self.position = [NSString stringWithFormat:@"%@",dic[@"position"]];
        self.reason = [NSString stringWithFormat:@"%@",dic[@"reason"]];
        
        
        self.hour = [NSString stringWithFormat:@"%@",dic[@"hour"]];
        self.nextNickName = [NSString stringWithFormat:@"%@",dic[@"nextNickName"]];
        self.nick_name = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
        self.state_type = [NSString stringWithFormat:@"%@",dic[@"state_type"]];
        self.deptName = [NSString stringWithFormat:@"%@",dic[@"deptName"]];
        
//        if (![Utils isBlankString:self.deptName]) {
//            self.deptName = [NSString stringWithFormat:@"- %@",self.deptName];
//        }
        
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
                    self.state_type = [NSString stringWithFormat:@"审批中"];
                    break;
                case 4:
                    self.state_type = [NSString stringWithFormat:@"驳回"];
                    break;
                case 5:
                    self.state_type = [NSString stringWithFormat:@"通过"];
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
