//
//  chooseDeptViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"


typedef void (^ReturnNSMutableArrayBlock)(NSMutableArray *returnMutableArray);

@interface chooseDeptViewController : BaseViewController

@property (nonatomic,copy) ReturnNSMutableArrayBlock returnNSMutableArrayBlock;
@property (nonatomic) NSInteger deptId;
@property (nonatomic) NSString *seType;

@property (nonatomic) NSString *startTime;
@property (nonatomic) NSString *endTime;

- (void)returnMutableArray:(ReturnNSMutableArrayBlock)block;


@end
