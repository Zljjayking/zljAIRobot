//
//  rankingModel.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "rankingModel.h"

@implementation rankingModel
- (id) initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        /**
         "count": 5,
         "icon": "/usericon/uic1494986114354.jpg",
         "name": "安卓"
         */
        self.icon = [NSString stringWithFormat:@"%@",dic[@"icon"]];
        self.count = [NSString stringWithFormat:@"%@",dic[@"count"]];
        self.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        
    }
    return self;
}
+ (id)requestWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}
@end
