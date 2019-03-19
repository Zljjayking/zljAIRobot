//
//  CRMDetailsViewController.h
//  Financeteam
//
//  Created by Zccf on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "CRMDetailsModel.h"
#import "CRMListModel.h"
typedef void (^ReturnIsRefreshCRMBlock)(NSString *returnIsRefrshCRM);
typedef void (^returnCRMModelBlcok)(CRMListModel *CRMListModel);
typedef void (^returnCRMStateBlock)(NSString *CRMState);
typedef void (^returnCRMStarBlock)(NSString *CRMStar);
//个人信息是否展开枚举
typedef NS_ENUM(NSUInteger, isPersonalInfoExpand) {
    isExpandedNo = 0,//不展开
    isExpandedYes//展开
};
//资产信息是否展开枚举
typedef NS_ENUM(NSUInteger, isAssetInfoExpand) {
    isAssetExpandedNo = 0,//不展开
    isAssetExpandedYes//展开
};
//房产信息是否展开枚举
typedef NS_ENUM(NSUInteger, isHouseInfoExpand) {
    isHouseExpandedNo = 0,//不展开
    isHouseExpandedYes//展开
};
//车辆信息是否展开枚举
typedef NS_ENUM(NSUInteger, isCarInfoExpand) {
    isCarExpandedNo = 0,//不展开
    isCarExpandedYes//展开
};
//工作信息是否展开枚举
typedef NS_ENUM(NSUInteger, isWorkInfoExpand) {
    isWorkExpandedNo = 0,//不展开
    isWorkExpandedYes//展开
};
////商业贷款信息是否展开枚举
//typedef NS_ENUM(NSUInteger, isLoansInfoExpand) {
//    isLoansExpandedNo = 0,//不展开
//    isLoansExpandedYes//展开
//};
//联系人信息是否展开枚举
typedef NS_ENUM(NSUInteger, isContactsInfoExpand) {
    isContactsExpandedNo = 0,//不展开
    isContactsExpandedYes//展开
};
//配偶直系信息是否展开枚举
typedef NS_ENUM(NSUInteger, isMatesInfoExpand) {
    isMatesExpandedNo = 0,//不展开
    isMatesExpandedYes//展开
};
//亲属信息是否展开枚举
typedef NS_ENUM(NSUInteger, isRelativesInfoExpand) {
    isRelativesExpandedNo = 0,//不展开
    isRelativesExpandedYes//展开
};
//同事信息是否展开枚举
typedef NS_ENUM(NSUInteger, isWorkmatesInfoExpand) {
    isWorkmatesExpandedNo = 0,//不展开
    isWorkmatesExpandedYes//展开
};
//其他联系人是否展开枚举
typedef NS_ENUM(NSUInteger, isOtherContactsInfoExpand) {
    isOtherContactsExpandedNo = 0,//不展开
    isOtherContactsExpandedYes//展开
};
//备注是否展开枚举
typedef NS_ENUM(NSUInteger, isRemarkExpand) {
    isRemarkExpandNo = 0,//不展开
    isRemarkExpandYes//展开
};
//备注是否展开枚举
typedef NS_ENUM(NSUInteger, isProjectExpand) {
    isProjectExpandNo = 0,//不展开
    isProjectExpandYes//展开
};
@interface CRMDetailsViewController : BaseViewController
@property (nonatomic) returnCRMStateBlock returnStateBlock;
@property (nonatomic) returnCRMStarBlock returnStarBlock;
@property (nonatomic) ReturnIsRefreshCRMBlock isRefreshCRM;//用于刷新上级页面列表 1 则刷新
@property (nonatomic) returnCRMModelBlcok CRMListModelBlock;
@property (nonatomic) NSString *customerId;
@property (nonatomic) NSInteger seType;//1.客户详情 2.信息采集 3.present过来的信息采集
@property (nonatomic) isPersonalInfoExpand isPersonalInfo;
@property (nonatomic) isAssetInfoExpand isAssetInfo;
@property (nonatomic) isHouseInfoExpand isHouseInfo;
@property (nonatomic) isCarInfoExpand isCarInfo;
@property (nonatomic) isWorkInfoExpand isWorkInfo;
//@property (nonatomic) isLoansInfoExpand isLoansInfo;
@property (nonatomic) isContactsInfoExpand isContactsInfo;
@property (nonatomic) isMatesInfoExpand isMatesInfo;
@property (nonatomic) isRelativesInfoExpand isRelativeInfo;
@property (nonatomic) isWorkmatesInfoExpand isWorkmatesInfo;
@property (nonatomic) isOtherContactsInfoExpand isOtherContactsInfo;
@property (nonatomic) isRemarkExpand isRemark;
@property (nonatomic) isProjectExpand isProject;
@property (nonatomic) BOOL isChangeState;
@property (nonatomic) BOOL isUpdateCRM;
@property (nonatomic) BOOL isDelCRM;
@property (nonatomic) BOOL isCreateOrderCRM;
@property (nonatomic) NSString *uid;
@property (nonatomic) NSString *iconURL;
@property (nonatomic) NSString *userSign;
@property (nonatomic) NSString *adviserId;
@property (nonatomic) NSString *createPsId;
- (void)returnIsRefreshCRM:(ReturnIsRefreshCRMBlock)block;
@end
