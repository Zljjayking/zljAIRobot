//
//  attendanceMachineSetModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/9.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceMachineSetModel.h"

@implementation attendanceMachineSetModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            
            self.create_time = [Utils transportToDate:[self.create_time longLongValue] DateFormat:@"YYYY-MM-dd HH:mm:ss"];
        }
        self.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.mech_id = [NSString stringWithFormat:@"%@",dic[@"mech_id"]];
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        self.sn = [NSString stringWithFormat:@"%@",dic[@"sn"]];
        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

@end
