//
//  MonthlyBaseModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthlyBaseModel : NSObject
/**
 "Normal": 10,
 "today": "2017-06-23"
 */
@property (nonatomic, strong) NSString *Normal;
@property (nonatomic, strong) NSString *today;
+(id)requestWithDic:(NSDictionary*)dic;
@end
