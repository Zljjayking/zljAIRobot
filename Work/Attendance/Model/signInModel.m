//
//  signInModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "signInModel.h"

@implementation signInModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.card_times = [NSString stringWithFormat:@"%@",dic[@"card_times"]];
        self.create_time = [NSString stringWithFormat:@"%@",dic[@"create_time"]];
        if (![Utils isBlankString:self.create_time]) {
            
            self.create_time = [Utils transportToDate:[self.create_time longLongValue] DateFormat:@"YYYY-MM-dd HH:mm:ss"];
        }
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.date = [NSString stringWithFormat:@"%@",dic[@"date"]];
        self.end_time = [NSString stringWithFormat:@"%@",dic[@"end_time"]];
        self.end_time_pm = [NSString stringWithFormat:@"%@",dic[@"end_time_pm"]];
        self.mech_id = [NSString stringWithFormat:@"%@",dic[@"mech_id"]];
        self.start_time = [NSString stringWithFormat:@"%@",dic[@"start_time"]];
        self.start_time_pm = [NSString stringWithFormat:@"%@",dic[@"start_time_pm"]];
        self.status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        self.tolerant_time = [NSString stringWithFormat:@"%@",dic[@"tolerant_time"]];
        
        
        /*
         @property (nonatomic, strong) NSString *late_time;
         @property (nonatomic, strong) NSString *leave_early;
         @property (nonatomic, strong) NSString *late_time_pm;
         @property (nonatomic, strong) NSString *leave_early_pm;
         @property (nonatomic, strong) NSString *late_minute;
         @property (nonatomic, strong) NSString *early_minute;
         @property (nonatomic, strong) NSString *absence_minute;
         */
        self.late_time = [NSString stringWithFormat:@"%@",dic[@"late_time"]];
        self.leave_early = [NSString stringWithFormat:@"%@",dic[@"leave_early"]];
        self.late_time_pm = [NSString stringWithFormat:@"%@",dic[@"late_time_pm"]];
        self.leave_early_pm = [NSString stringWithFormat:@"%@",dic[@"leave_early_pm"]];
        self.late_minute = [NSString stringWithFormat:@"%@",dic[@"late_minute"]];
        self.early_minute = [NSString stringWithFormat:@"%@",dic[@"early_minute"]];
        self.absence_minute = [NSString stringWithFormat:@"%@",dic[@"absence_minute"]];
        
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
