//
//  searchApprovalViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "approvalDetailModel.h"
typedef void (^refreshDataBlock)();
@interface ApprovalDetailViewController : BaseViewController

@property (nonatomic) NSInteger type;//1.新建  2.详情  3.从消息点击进入详情

@property (nonatomic, strong) NSString *application_id;
@property (nonatomic, strong) refreshDataBlock refreshBlock;
@property (nonatomic, strong) NSString *seq_id;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) NSInteger indexID;//1.我提交的   2.待我审批   3.通知我的
@property (nonatomic, strong) approvalDetailModel *detailModel;

@end
