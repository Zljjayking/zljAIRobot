//
//  reamrkModel.h
//  Financeteam
//
//  Created by Zccf on 2017/10/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reamrkModel : NSObject
@property (nonatomic,retain) NSString *create_time;
@property (nonatomic,retain) NSString *customer_id;
@property (nonatomic,retain) NSString *remarkId;
@property (nonatomic,retain) NSString *real_name;
@property (nonatomic,retain) NSString *remark;

+(id)requestWithDic:(NSDictionary*)dic;
@end
