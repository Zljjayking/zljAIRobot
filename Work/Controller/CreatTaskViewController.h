//
//  CreatTaskViewController.h
//  Financeteam
//
//  Created by Zccf on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnIsRefreshTaskBlock)(NSString *returnIsRefrshTask);
@interface CreatTaskViewController : BaseViewController
@property (nonatomic)NSInteger seType;
@property (nonatomic) ReturnIsRefreshTaskBlock isRefreshTask;//用于刷新上级页面列表 1 则刷新
- (void)returnIsRefreshTask:(ReturnIsRefreshTaskBlock)block;
@property (nonatomic)NSInteger limite;
@end
