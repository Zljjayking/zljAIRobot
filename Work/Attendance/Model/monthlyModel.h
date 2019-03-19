//
//  monthlyModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface monthlyModel : NSObject
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
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *not_clock;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *Normal;
@property (nonatomic, strong) NSString *absence;
@property (nonatomic, strong) NSString *business_travel;
@property (nonatomic, strong) NSString *go_out;
@property (nonatomic, strong) NSString *late_time;
@property (nonatomic, strong) NSString *leave_early;
@property (nonatomic, strong) NSString *leaves_time;
@property (nonatomic, strong) NSString *overtime;
@property (nonatomic, strong) NSDictionary *dataDic;
+(id)requestWithDic:(NSDictionary*)dic;
@end
