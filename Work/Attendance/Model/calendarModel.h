//
//  calendarModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/12.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface calendarModel : NSObject
/**
 "id": 13506,
 "mech_id": 0,
 "status": 0,
 "time": 1483200000000,
 "type": 1//1 休 2工作
 */
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *type;
+(id)requestWithDic:(NSDictionary*)dic;
@end
