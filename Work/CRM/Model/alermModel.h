//
//  alermModel.h
//  Financeteam
//
//  Created by Zccf on 16/8/2.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface alermModel : NSObject
@property (nonatomic,retain) NSString *yearStr;
@property (nonatomic,retain) NSString *monthStr;
@property (nonatomic,retain) NSString *dayStr;
@property (nonatomic,retain) NSString *hourStr;
@property (nonatomic,retain) NSString *minuteStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic,retain) NSString *CRMID;
@property (nonatomic, strong) NSString *time;
@property (nonatomic,strong) NSString *title;
+(id)requestWithDic:(NSDictionary*)dic;
@end
