//
//  employeeModel.h
//  Financeteam
//
//  Created by Zccf on 17/4/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface employeeModel : NSObject
/**
 "dataFlag": 0, //0未完善 1 已完善
 "icon": "/usericon/uic1449548754192.jpg",
 "mobile": "15261864301",
 "real_name": "郭千里",
 "sex": null //0未知 1男2女
 */
@property (nonatomic) NSString *dataFlag;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *mobile;
@property (nonatomic) NSString *real_name;
@property (nonatomic) NSString *sex;
@property (nonatomic) NSString *userId;
+(id)requestWithDic:(NSDictionary*)dic;
@end
