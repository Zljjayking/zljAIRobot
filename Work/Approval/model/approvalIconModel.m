//
//  approvalIconModel.m
//  Financeteam
//
//  Created by Zccf on 2017/5/18.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalIconModel.h"

@implementation approvalIconModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            self.create_time = [Utils transportToTime:[self.create_time longLongValue]];
        }
        self.approval_id = [NSString stringWithFormat:@"%@",dic[@"approval_id"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
