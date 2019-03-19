//
//  LookOrderInfoViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

#import "MyOrderModel.h"
typedef void (^refreshMyOrderBlock) ();
@interface LookOrderInfoViewController : BaseViewController

@property(nonatomic,strong)NSNumber * orderID;

@property(nonatomic)BOOL isAssignedApprover;
@property (nonatomic) NSString *myPushId;
@property (nonatomic) NSString *ptpId;

@property (nonatomic) refreshMyOrderBlock refreshBlcok;

@property (nonatomic) MyOrderModel *orderModel;

@property (nonatomic, strong) NSString *publicity_mech_id;
@property (nonatomic, strong) NSString *jrq_mechanism_id;
//推送企业及创始人信息
@property (nonatomic, strong) NSString *ptpMechUserId;
@property (nonatomic, strong) NSString *ptpMechId;
@property (nonatomic, strong) NSString *ptpMechUserIcon;
@property (nonatomic, strong) NSString *mechanism_other_id;//推送至什么企业的id
@property (nonatomic) BOOL ispush;
@end
