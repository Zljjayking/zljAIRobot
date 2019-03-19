//
//  billModel.h
//  Financeteam
//
//  Created by Zccf on 17/4/13.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface billModel : NSObject
@property (nonatomic)NSString *Id;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *money;
@property (nonatomic) NSString *moneyStatus;//0是收入 1是消费
@property (nonatomic) NSString *operation;
+(id)requestWithDic:(NSDictionary *)dic;
@end
