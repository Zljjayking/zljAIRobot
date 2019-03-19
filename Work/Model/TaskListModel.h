//
//  TaskListModel.h
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskListModel : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *cpId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *cpName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *personId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *personName;
@property (nonatomic, strong) NSString *dxState;

@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *stopTime;
@property (nonatomic, strong) NSString *startTime;
@end
