//
//  AddProductViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "LocationView.h"

typedef void (^ReturnIsRefreshProductBlock)(NSString *returnIsRefrshProduct);

@interface AddProductViewController : BaseViewController

@property (nonatomic,strong)LocationView * locaView;
@property (nonatomic) ReturnIsRefreshProductBlock isRefreshProduct;//用于刷新上级页面列表 1 则刷新
- (void)returnIsRefreshProduct:(ReturnIsRefreshProductBlock)block;

@end
