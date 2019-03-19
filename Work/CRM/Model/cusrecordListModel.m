//
//  cusrecordListModel.m
//  Financeteam
//
//  Created by Zccf on 16/7/11.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "cusrecordListModel.h"

@implementation cusrecordListModel
- (id)initWithDic:(NSDictionary*)dic {
    self = [super init];
    if (self) {
        self.content = [NSString stringWithFormat:@"%@",dic[@"content"]];
        self.cusId = [NSString stringWithFormat:@"%@",dic[@"cusId"]];
        self.ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.time = [NSString stringWithFormat:@"%@",dic[@"time"]];
        self.userId = [NSString stringWithFormat:@"%@",dic[@"userId"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
