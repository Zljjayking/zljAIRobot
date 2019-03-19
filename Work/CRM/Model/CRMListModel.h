//
//  CRMListModel.h
//  Financeteam
//
//  Created by Zccf on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMListModel : NSObject

@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *user_name;
@property (nonatomic) NSInteger user_sex;
@property (nonatomic) NSInteger createPsId;
@property (nonatomic) NSString *state;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *user_mobile;
@property (nonatomic, strong) NSString *systemAllocation;
@property (nonatomic, strong) NSString *adviserId;
@property (nonatomic, strong) NSString *userSign;

+(id)requestWithDic:(NSDictionary*)dic;

@end
