//
//  GetOrderDetailViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailModel.h"
#import "LocationView.h"
#import "productModel.h"
#import "CRMDetailsModel.h"

@interface GetOrderDetailViewController : BaseViewController

@property(nonatomic,strong)OrderDetailModel * orderDetail;
@property(nonatomic,strong)LocationView * locaView;

@property (nonatomic,assign) BOOL isUpdateCRM;

@property (nonatomic, strong) CRMDetailsModel *PhotoModel;

@property (nonatomic,retain) productModel * product;

@end
