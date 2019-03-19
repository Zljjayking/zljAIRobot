//
//  dailyAttendanceModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "dailyAttendanceModel.h"

@implementation dailyAttendanceModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         "absence": 2,//缺勤
         "business_travel": 0,//出差
         "go_out": 0,//外勤
         "late_time": 0,//迟到
         "leave_early": 0,//早退
         "leaves": 0,//请假
         "not_clock": 0,//未打卡
         "punch_clock": 2//已打卡
         */
        
        self.deptCount = [NSString stringWithFormat:@"%@",dic[@"deptCount"]];
        
        self.absence = [NSString stringWithFormat:@"%g",[dic[@"absence"] intValue]/([self.deptCount intValue]*1.0)];
        self.business_travel = [NSString stringWithFormat:@"%g",[dic[@"business_travel"] intValue]/([self.deptCount intValue]*1.0)];
        self.go_out = [NSString stringWithFormat:@"%g",[dic[@"go_out"] intValue]/([self.deptCount intValue]*1.0)];
        self.late_time = [NSString stringWithFormat:@"%g",[dic[@"late_time"] intValue]/([self.deptCount intValue]*1.0)];
        self.leave_early = [NSString stringWithFormat:@"%g",[dic[@"leave_early"] intValue]/([self.deptCount intValue]*1.0)];
        self.leaves = [NSString stringWithFormat:@"%g",[dic[@"leaves"] intValue]/([self.deptCount intValue]*1.0)];
        self.not_clock = [NSString stringWithFormat:@"%g",[dic[@"not_clock"] intValue]/([self.deptCount intValue]*1.0)];
        self.punch_clock = [NSString stringWithFormat:@"%g",[dic[@"punch_clock"] intValue]/([self.deptCount intValue]*1.0)];
        
        self.absenceValue = [NSString stringWithFormat:@"%d",[dic[@"absence"] intValue]];
        self.business_travelValue = [NSString stringWithFormat:@"%d",[dic[@"business_travel"] intValue]];
        self.go_outValue = [NSString stringWithFormat:@"%d",[dic[@"go_out"] intValue]];
        self.late_timeValue = [NSString stringWithFormat:@"%d",[dic[@"late_time"] intValue]];
        self.leave_earlyValue = [NSString stringWithFormat:@"%d",[dic[@"leave_early"] intValue]];
        self.leavesValue = [NSString stringWithFormat:@"%d",[dic[@"leaves"] intValue]];
        self.not_clockValue = [NSString stringWithFormat:@"%d",[dic[@"not_clock"] intValue]];
        self.punch_clockValue = [NSString stringWithFormat:@"%d",[dic[@"punch_clock"] intValue]];
        
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
