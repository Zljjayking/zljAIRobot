//
//  signInModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface signInModel : NSObject
/**
 "card_times": "",//打卡次数
 "create_time": 1496803856000,
 "date": "2017-06-07",//当前时间
 "end_time": "",
 "end_time_pm": "",
 "id": 1,
 "mech_id": 9,
 "start_time": "",
 "start_time_pm": "",
 "status": 0,
 "tolerant_time": null
 */
@property (nonatomic, strong) NSString *card_times;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *end_time_pm;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *start_time_pm;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *tolerant_time;

@property (nonatomic, strong) NSString *late_time;
@property (nonatomic, strong) NSString *leave_early;
@property (nonatomic, strong) NSString *late_time_pm;
@property (nonatomic, strong) NSString *leave_early_pm;
@property (nonatomic, strong) NSString *late_minute;
@property (nonatomic, strong) NSString *early_minute;
@property (nonatomic, strong) NSString *absence_minute;
+(id)requestWithDic:(NSDictionary*)dic;
@end
