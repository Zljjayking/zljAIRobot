//
//  dailyAttendanceModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dailyAttendanceModel : NSObject
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
@property (nonatomic, strong) NSString *absence;
@property (nonatomic, strong) NSString *business_travel;
@property (nonatomic, strong) NSString *go_out;
@property (nonatomic, strong) NSString *late_time;
@property (nonatomic, strong) NSString *leave_early;
@property (nonatomic, strong) NSString *leaves;
@property (nonatomic, strong) NSString *not_clock;
@property (nonatomic, strong) NSString *punch_clock;

@property (nonatomic, strong) NSString *absenceValue;
@property (nonatomic, strong) NSString *business_travelValue;
@property (nonatomic, strong) NSString *go_outValue;
@property (nonatomic, strong) NSString *late_timeValue;
@property (nonatomic, strong) NSString *leave_earlyValue;
@property (nonatomic, strong) NSString *leavesValue;
@property (nonatomic, strong) NSString *not_clockValue;
@property (nonatomic, strong) NSString *punch_clockValue;
@property (nonatomic, strong) NSString *deptCount;
+(id)requestWithDic:(NSDictionary*)dic;
@end
