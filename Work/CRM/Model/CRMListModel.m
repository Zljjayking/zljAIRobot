//
//  CRMListModel.m
//  Financeteam
//
//  Created by Zccf on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMListModel.h"

@implementation CRMListModel
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        self.ID = [NSString stringWithFormat:@"%@",dic[@"Id"]];
        self.user_name = dic[@"user_name"];
        self.user_sex= [dic[@"user_sex"] integerValue];
        self.createPsId = [dic[@"createPsId"] integerValue];
        self.real_name   = dic[@"real_name"];//real_name
        if (self.createPsId == 0) {
            self.real_name   = dic[@"jrqMechName"];//real_name
        }
        self.state = [NSString stringWithFormat:@"%@",dic[@"state"]];
        self.createTime = dic[@"createTime"];
        self.user_mobile  = dic[@"user_mobile"];
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.systemAllocation = [NSString stringWithFormat:@"%@",dic[@"systemAllocation"]];
        self.adviserId = [NSString stringWithFormat:@"%@",dic[@"adviserId"]];
        self.userSign = [NSString stringWithFormat:@"%@",dic[@"userSign"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
