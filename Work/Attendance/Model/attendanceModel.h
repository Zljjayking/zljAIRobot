//
//  attendanceModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/6.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface attendanceModel : NSObject
/**
 "card_time": 1496647327000,
 "id": 19,
 "real_name": "安卓",
 "user_id": 55,
 "verify": 1
 */
@property (nonatomic, strong) NSString *card_time;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *verify;
+(id)requestWithDic:(NSDictionary*)dic;
@end
