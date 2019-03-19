//
//  MyOrderModel.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MyOrderModel.h"

@implementation MyOrderModel

+(JSONKeyMapper *)keyMapper{
    //访问id这个属性时，访问kid
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"kid"}];
}
@end
