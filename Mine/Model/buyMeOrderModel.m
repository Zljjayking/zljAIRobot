//
//  buyMeOrderModel.m
//  Financeteam
//
//  Created by Zccf on 2017/8/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeOrderModel.h"

@implementation buyMeOrderModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         @property (nonatomic)NSString *Id;
         @property (nonatomic) NSString *createTime;
         @property (nonatomic) NSString *money;
         @property (nonatomic) NSString *orderNo;
         @property (nonatomic) NSString *state;//状态（0：成功、1：失败、2：待支付）
         @property (nonatomic) NSString *vipTime;
         */
        self.Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.createTime = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
//        [Utils stringToDate:self.createTime withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.money = [NSString stringWithFormat:@"%@",dic[@"money"]];
        self.orderNo = [NSString stringWithFormat:@"%@",dic[@"orderNo"]];
        self.state = [NSString stringWithFormat:@"%@",dic[@"state"]];
        self.vipTime = [NSString stringWithFormat:@"%@",dic[@"vipTime"]];
        self.flag = [NSString stringWithFormat:@"%@",dic[@"flag"]];
        self.personSize = [NSString stringWithFormat:@"%@",dic[@"personSize"]];
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
