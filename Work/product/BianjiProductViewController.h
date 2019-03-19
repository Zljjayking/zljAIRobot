//
//  BianjiProductViewController.h
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productModel.h"
#import "LocationView.h"
#import "BaseViewController.h"
typedef void (^ReturnIsRefreshXiaJiaBlock)(NSString *returnIsRefrshXiaJia);

typedef void (^ReturnIsRefreshBianJiBlock)(NSArray *returnModelArr);

@interface BianjiProductViewController : BaseViewController

@property (nonatomic,retain) productModel * product;
@property (nonatomic,strong) LocationView * locaView;

@property (nonatomic,copy) ReturnIsRefreshXiaJiaBlock isRefreshXiaJia;//用于刷新上级页面列表 1 则刷新
@property (nonatomic,copy) ReturnIsRefreshBianJiBlock isRefreshBianji;

- (void)returnIsRefreshXiaJia:(ReturnIsRefreshXiaJiaBlock)block;

- (void)returnIsRefreshBianJi:(ReturnIsRefreshBianJiBlock)block;

@end
