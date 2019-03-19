//
//  approvalModel.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface approvalModel : NSObject
@property (nonatomic) NSString *application_name;
@property (nonatomic) NSString *create_time;
@property (nonatomic) NSString *end_time;
@property (nonatomic) NSString *hour;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *nextNickName;
@property (nonatomic) NSString *start_time;
@property (nonatomic) NSString *nick_name;
@property (nonatomic) NSString *state_type;
@property (nonatomic) NSString *deptName;
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *seq_id;
@property (nonatomic) NSString *mech_id;
+(id)requestWithDic:(NSDictionary*)dic;
@end
