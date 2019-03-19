//
//  EditTaskViewController.h
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskListModel.h"
typedef void (^ReturnIsRefreshTaskBlock)(NSString *returnIsRefrshTask);
@interface EditTaskViewController : BaseViewController
@property (nonatomic) NSInteger seType;//1.任务详情 2.添加任务
@property (nonatomic) TaskListModel *model;
@property (nonatomic) BOOL isDelTask;
@property (nonatomic) ReturnIsRefreshTaskBlock isRefreshTask;//用于刷新上级页面列表 1 则刷新
- (void)returnIsRefreshTask:(ReturnIsRefreshTaskBlock)block;

@end
