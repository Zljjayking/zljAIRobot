//
//  attendanceMachineSetModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/9.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface attendanceMachineSetModel : NSObject
/**
 "create_time": 1496817196000,
 "id": 1,
 "mech_id": 9,
 "sn": "123123",
 "status": 0
 */
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
+(id)requestWithDic:(NSDictionary*)dic;
@end
