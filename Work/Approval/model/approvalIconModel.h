//
//  approvalIconModel.h
//  Financeteam
//
//  Created by Zccf on 2017/5/18.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface approvalIconModel : NSObject
/**
 "approval_id" = 38;
 "create_time" = 1495014799000;
 icon = "/mechpro/mpro1495014789462.jpg";
 id = 2;
 status = 0;
 */
@property (nonatomic) NSString *approval_id;
@property (nonatomic) NSString *create_time;
@property (nonatomic) NSString *icon;
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *status;
+(id)requestWithDic:(NSDictionary*)dic;
@end
