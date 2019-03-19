//
//  alermModel.m
//  Financeteam
//
//  Created by Zccf on 16/8/2.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "alermModel.h"

@implementation alermModel
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        self.yearStr = [dic objectForKey:@"year"];
        self.monthStr = [dic objectForKey:@"month"];
        self.dayStr= [dic objectForKey:@"day"];
        self.hourStr = [dic objectForKey:@"hour"];
        self.minuteStr   = [dic objectForKey:@"minute"];
        self.CRMID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"crmID"]];
        self.timeStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"timeString"]];
        self.time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
        self.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
