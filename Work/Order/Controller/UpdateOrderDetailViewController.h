//
//  UpdateOrderDetailViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/13.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailModel.h"
#import "LocationView.h"

#import "productModel.h"
#import "CRMDetailsModel.h"

@interface UpdateOrderDetailViewController : BaseViewController

@property(nonatomic,strong)OrderDetailModel * orderDetail;
@property(nonatomic,strong)LocationView * locaView;

@property (nonatomic,retain) productModel * product;

@property (nonatomic,assign) BOOL isUpdateCRM;

@property (nonatomic, strong) CRMDetailsModel *PhotoModel;

@end
