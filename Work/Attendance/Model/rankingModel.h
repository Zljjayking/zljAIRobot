//
//  rankingModel.h
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rankingModel : NSObject
/**
 "count": 5,
 "icon": "/usericon/uic1494986114354.jpg",
 "name": "安卓"
 */
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
+(id)requestWithDic:(NSDictionary*)dic;
@end
