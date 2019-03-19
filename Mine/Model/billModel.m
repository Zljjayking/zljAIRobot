//
//  billModel.m
//  Financeteam
//
//  Created by Zccf on 17/4/13.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "billModel.h"

@implementation billModel
- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         @property (nonatomic)NSString *Id;
         @property (nonatomic) NSString *createTime;
         @property (nonatomic) NSString *money;
         @property (nonatomic) NSString *moneyStatus;//0是收入 1是消费
         @property (nonatomic) NSString *operation;
         */
        self.Id = [NSString stringWithFormat:@"%@",dic[@"Id"]];
        self.createTime = [self ConvertMessageTime:[dic[@"createTime"] integerValue]/1000.0];
        self.money = [NSString stringWithFormat:@"%@",dic[@"money"]];
        self.moneyStatus = [NSString stringWithFormat:@"%@",dic[@"moneyStatus"]];
        self.operation = [NSString stringWithFormat:@"%@",dic[@"operation"]];
    }
    return self;
}
#pragma mark - private
- (NSString *)ConvertMessageTime:(long long)secs {
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:secs];
    
    //    DebugLog(@"messageDate==>%@",messageDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *strMsgDay = [formatter stringFromDate:messageDate];
    
    
    return strMsgDay;
    
}


+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
