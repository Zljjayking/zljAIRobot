//
//  employeeInfoModel.h
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface employeeInfoModel : NSObject
/**
 
 "address": "null",
 "birthday": null,
 "company_address": "null",
 "company_name": "null",
 "contacts": [
 {
 "name": "null",
 "relation": "null",
 "telephone": "null"
 }
 ],
 "education": null,
 "home_address": "null",
 "jrq_id_card": "null",
 "marital_status": null,
 "mobile": "19999999999",
 "post_name": "null",
 "real_name": "a苹果端有问题可向此号反馈",
 "sex": 1,
 "telephone": "null",
 "userId": 1
 */

@property (nonatomic) NSString *address;
@property (nonatomic) NSString *birthday;
@property (nonatomic) NSString *company_address;
@property (nonatomic) NSString *company_name;
@property (nonatomic) NSString *education;
@property (nonatomic) NSString *home_address;
@property (nonatomic) NSString *jrq_id_card;
@property (nonatomic) NSString *marital_status;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSString *post_name;
@property (nonatomic) NSString *real_name;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSString *telephone;
@property (nonatomic) NSString *userId;
+(id)requestWithDic:(NSDictionary *)dic;
@end
