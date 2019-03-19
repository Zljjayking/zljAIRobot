//
//  buyMeOrderModel.h
//  Financeteam
//
//  Created by Zccf on 2017/8/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface buyMeOrderModel : NSObject
@property (nonatomic)NSString *Id;
@property (nonatomic) NSString *createTime;
@property (nonatomic) NSString *money;
@property (nonatomic) NSString *orderNo;
@property (nonatomic) NSString *state;//状态（0：成功、1：失败、2：待支付）
@property (nonatomic) NSString *vipTime;
@property (nonatomic) NSString *flag;//1 初始支付 2 时间扩容 3 人数扩容 4 购买设备
@property (nonatomic) NSString *personSize;
+(id)requestWithDic:(NSDictionary *)dic;
@end
