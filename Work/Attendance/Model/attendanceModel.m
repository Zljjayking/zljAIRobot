//
//  attendanceModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/6.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceModel.h"

@implementation attendanceModel
/**
 "card_time": 1496647327000,
 "id": 19,
 "real_name": "安卓",
 "user_id": 55,
 "verify": 1
 */
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.card_time = [NSString stringWithFormat:@"%@",dic[@"card_time"]];
        if (![Utils isBlankString:self.card_time]) {
            
            self.card_time = [Utils transportToDate:[self.card_time longLongValue] DateFormat:@"HH:mm:ss"];
        }
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.real_name = [NSString stringWithFormat:@"%@",dic[@"real_name"]];
        self.user_id = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
        self.verify = [NSString stringWithFormat:@"%@",dic[@"verify"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
