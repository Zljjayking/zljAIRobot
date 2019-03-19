//
//  MyOrderViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@interface MyOrderViewController : BaseViewController

@property(nonatomic,strong)UITableView * myOrderTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic)BOOL isAssignedApprover;

@property (nonatomic) BOOL ispush;
@end
