//
//  reamrkModel.m
//  Financeteam
//
//  Created by Zccf on 2017/10/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "reamrkModel.h"

@implementation reamrkModel
-(id)initWithDic:(NSDictionary*)dic
{
    if (self = [super init])
    {
        self.create_time = [dic objectForKey:@"create_time"];
        self.create_time = [Utils transportToTime:[self.create_time longLongValue]];
        self.customer_id = [dic objectForKey:@"customer_id"];
        self.remarkId= [dic objectForKey:@"id"];
        self.real_name = [dic objectForKey:@"real_name"];
        self.remark   = [dic objectForKey:@"remark"];
    }
    return self;
}
+(id)requestWithDic:(NSDictionary*)dic
{
    return [[self alloc] initWithDic:dic];
}
@end
