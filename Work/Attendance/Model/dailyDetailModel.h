//
//  dailyDetailModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dailyDetailModel : NSObject
/**
 "businessAddress":"",
 "icon": "/usericon/uic1494986114354.jpg",
 "leave_reason": "吃多了，肚子疼",
 "leave_type_name": "病假",
 "real_name": "安卓"
 */
@property (nonatomic, strong) NSString *businessAddress;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *leave_reason;
@property (nonatomic, strong) NSString *leave_type_name;
@property (nonatomic, strong) NSString *real_name;
+(id)requestWithDic:(NSDictionary*)dic;
@end
