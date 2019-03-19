//
//  employeeContactModel.h
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface employeeContactModel : NSObject
/**
 "name": "null",
 "relation": "null",
 "telephone": "null"
 */
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *relation;
@property (nonatomic) NSString *telephone;
+(id)requestWithDic:(NSDictionary *)dic;
@end
