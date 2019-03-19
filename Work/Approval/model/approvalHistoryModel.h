//
//  approvalHistoryModel.h
//  Financeteam
//
//  Created by Zccf on 2017/5/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface approvalHistoryModel : NSObject
/**
 "approvalName": null,//审批人名字
 "create_time": 1495087177000,//创建
 "nick_name": "瀚承鸿澜",//申请人名字
 "reason": null,//理由
 "state_type": 3//状态
 */
@property (nonatomic, strong) NSString *approvalName;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *state_type;
@property (nonatomic, strong) NSString *icon;
+(id)requestWithDic:(NSDictionary*)dic;
@end
