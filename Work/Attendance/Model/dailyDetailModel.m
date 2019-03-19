//
//  dailyDetailModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "dailyDetailModel.h"

@implementation dailyDetailModel
/**
 "businessAddress":"",
 "icon": "/usericon/uic1494986114354.jpg",
 "leave_reason": "吃多了，肚子疼",
 "leave_type_name": "病假",
 "real_name": "安卓"
 */
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         "businessAddress":"",
         "icon": "/usericon/uic1494986114354.jpg",
         "leave_reason": "吃多了，肚子疼",
         "leave_type_name": "病假",
         "real_name": "安卓"
         */
        self.businessAddress = [NSString stringWithFormat:@"%@",dic[@"businessAddress"]];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.leave_reason = [NSString stringWithFormat:@"%@",dic[@"leave_reason"]];
        self.leave_type_name = [NSString stringWithFormat:@"%@",dic[@"leave_type_name"]];
        self.real_name = [NSString stringWithFormat:@"%@",dic[@"real_name"]];
        
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
