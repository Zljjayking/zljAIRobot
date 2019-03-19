//
//  payGroupModel.h
//  Financeteam
//
//  Created by Zccf on 17/4/27.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface payGroupModel : NSObject
/**
 "Id": 1,
 "commission": null, //1 件 2 量 3 服务费
 "create_time": null,//创建时间
 "mech_id": 1,//机构id
 "perNum": 0,//人数
 "performance": "1",//组名称
 "salary": null//薪资
 */
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *commission;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *perNum;
@property (nonatomic, strong) NSString *performance;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, strong) NSString *status;
+(id)requestWithDic:(NSDictionary *)dic;
@end
