//
//  cusrecordListModel.h
//  Financeteam
//
//  Created by Zccf on 16/7/11.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cusrecordListModel : NSObject
/*
 content = "瀚承鸿澜 重新选择了顾问为：郭千里";
 cusId = 17;
 id = 5;
 time = "2016-07-08 15:45:53";
 userId = 1;
 */
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *cusId;
@property (nonatomic) NSString *ID;
@property (nonatomic) NSString *time;
@property (nonatomic) NSString *userId;
+(id)requestWithDic:(NSDictionary*)dic;
@end
