//
//  ProductManageViewController.h
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnIDNSMutableArrayBlock)(NSMutableArray *returnIDMutableArray);
typedef void (^ReturnNameNSMutableArrayBlock)(NSMutableArray *returnNameMutableArray);

//全选状态枚举
typedef NS_ENUM(NSUInteger, productSelectStatus) {
    productSelectStatusNone = 0,//未选
    producSelectStatusAll//全选
};

@interface ProductManageViewController : BaseViewController
@property (nonatomic) NSInteger seType;
@property (nonatomic) NSInteger limit;
@property (nonatomic) NSArray *limitArr;//传过来的产品id用于过滤不需要的产品
@property (nonatomic) NSArray *taskMechProIDArr;//传过来已经选中的产品id
@property (nonatomic) NSArray *taskMechProNameArr;//传过来已经选中的产品名称
//产品管理中的权限
@property (nonatomic) BOOL isAddPro;
@property (nonatomic) BOOL isUpdatePro;
@property (nonatomic) BOOL isPushPro;
//任务管理中的权限
@property (nonatomic) BOOL isAddTask;
@property (nonatomic) BOOL isUpdateTask;
@property (nonatomic) BOOL isDelTask;
//CRM中的权限
@property (nonatomic) BOOL isAddCRM;
@property (nonatomic) BOOL isUpdateCRM;
@property (nonatomic) BOOL isDelCRM;
@property (nonatomic) BOOL isUpStateCRM;
@property (nonatomic) BOOL isCreateOrderCRM;
//订单中的权限


@property (nonatomic,copy) ReturnIDNSMutableArrayBlock returnIDNSMutableArrayBlock;
@property (nonatomic,copy) ReturnNameNSMutableArrayBlock returnNameNSMutableArrayBlock;
- (void)returnIDMutableArray:(ReturnIDNSMutableArrayBlock)block;
- (void)returnNameMutableArray:(ReturnNameNSMutableArrayBlock)block;

//产品是否全选
@property (nonatomic)productSelectStatus selectStatus;
@end
