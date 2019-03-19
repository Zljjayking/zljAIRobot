//
//  calendarModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/12.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "calendarModel.h"

@implementation calendarModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.time = [NSString stringWithFormat:@"%@",dic[@"time"]];
        if (![Utils isBlankString:self.time]) {
            
            self.time = [Utils transportToDate:[self.time longLongValue] DateFormat:@"YYYY-MM-dd"];
        }
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.mech_id = [NSString stringWithFormat:@"%@",dic[@"mech_id"]];
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        self.type = [NSString stringWithFormat:@"%@",dic[@"type"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
