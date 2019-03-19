//
//  ApplyProductVC.h
//  Financeteam
//
//  Created by 张正飞 on 16/9/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "LocationView.h"
#import "productModel.h"
#import "CRMDetailsModel.h"

@interface ApplyProductVC : BaseViewController

@property (nonatomic, strong) CRMDetailsModel *PhotoModel;

@property (nonatomic,strong)LocationView * locaView;

@property (nonatomic,retain) productModel * product;

@property (nonatomic,assign) BOOL isUpdateCRM;

@end
