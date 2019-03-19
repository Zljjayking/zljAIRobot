//
//  BankModel.h
//  Financeteam
//
//  Created by Zccf on 17/4/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject
@property (nonatomic) NSString *bankId;
@property (nonatomic) NSString *bankName;
+(id)requestWithDic:(NSDictionary *)dic;
@end
