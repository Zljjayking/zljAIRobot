//
//  monthlyModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "monthlyModel.h"

@implementation monthlyModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         "icon":"",
         "not_clock":3,
         "name":"123",
         "Normal": 8,//正常
         "absence": 5,//缺勤
         "business_travel": 0,//出差
         "go_out": 0,//外勤
         "late_time": 0,//迟到
         "leave_early": 0,//早退
         "leaves_time": 0,//请假
         "overtime": 0//加班
         */
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.not_clock = [NSString stringWithFormat:@"%@",dic[@"not_clock"]];
        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        self.Normal = [NSString stringWithFormat:@"%@",dic[@"Normal"]];
        self.absence = [NSString stringWithFormat:@"%.1f",[dic[@"absence"] floatValue]*0.5];
        self.business_travel = [NSString stringWithFormat:@"%.1f",[dic[@"business_travel"] floatValue]/8];
        self.go_out = [NSString stringWithFormat:@"%.1f",[dic[@"go_out"] floatValue]*0.5];
        self.late_time = [NSString stringWithFormat:@"%@",dic[@"late_time"]];
        self.leave_early = [NSString stringWithFormat:@"%@",dic[@"leave_early"]];
        self.leaves_time = [NSString stringWithFormat:@"%.1f",[dic[@"leaves_time"] floatValue]/8];
        self.overtime = [NSString stringWithFormat:@"%@",dic[@"overtime"]];
        //@"出勤(天)",@"迟到(次)",@"早退(次)",@"缺勤(天)",@"请假(天)",@"外勤(天)",@"加班(小时)",@"出差(天)"
        self.dataDic = @{@"出勤(天)":self.Normal,@"迟到(次)":self.late_time,@"早退(次)":self.leave_early,@"缺勤(天)":self.absence,@"请假(天)":self.leaves_time,@"外勤(小时)":self.go_out,@"加班(小时)":self.overtime,@"出差(天)":self.business_travel,@"旷工(天)":self.not_clock};
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
