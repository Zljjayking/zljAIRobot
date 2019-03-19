//
//  approvalHistoryModel.m
//  Financeteam
//
//  Created by Zccf on 2017/5/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalHistoryModel.h"

@implementation approvalHistoryModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            self.create_time = [Utils transportToTime:[self.create_time longLongValue]];
        }
        self.approvalName = [NSString stringWithFormat:@"%@",dic[@"approvalName"]];
        self.nick_name = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
        self.reason = [NSString stringWithFormat:@"%@",dic[@"reason"]];
        self.state_type = [NSString stringWithFormat:@"%@",dic[@"state_type"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
