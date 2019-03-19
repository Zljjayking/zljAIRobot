//
//  EditRightViewController.h
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnIsRefreshRightBlock)(NSString *returnIsRefrshRight);
//全选状态枚举
typedef NS_ENUM(NSUInteger, SelectStatus) {
    SelectStatusNone = 0,//未选
    SelectStatusAll//全选
};
//父权限状态枚举
typedef NS_ENUM(NSUInteger, SelectType) {
    SelectTypeNo = 0,//未选
    SelectTypeYes//全选
};
//产品是否展开枚举
typedef NS_ENUM(NSUInteger, isProductAddModel) {
    ProductAddModelNo = 0,//不展开
    ProductAddModelYes//展开
};
//任务是否展开枚举
typedef NS_ENUM(NSUInteger, isTaskAddModel) {
    TaskAddModelNo = 0,//不展开
    TaskAddModelYes//展开
};
//电销是否展开枚举
typedef NS_ENUM(NSUInteger, isDianXiaoAddModel) {
    DianXiaoAddModelNo = 0,//不展开
    DianXiaoAddModelYes//展开
};
//权限是否展开枚举
typedef NS_ENUM(NSUInteger, isRightAddModel) {
    RightAddModelNo = 0,//不展开
    RightAddModelYes//展开
};
//CRM是否展开枚举
typedef NS_ENUM(NSUInteger, isCRMAddModel) {
    CRMAddModelNo = 0,//不展开
    CRMAddModelYes//展开
};
//订单是否展开枚举
typedef NS_ENUM(NSUInteger, isOrderAddModel) {
    OrderAddModelNo = 0,//不展开
    OrderAddModelYes//展开
};
//公告是否展开枚举
typedef NS_ENUM(NSUInteger, isGongGaoAddModel) {
    GongGaoAddModelNo = 0,//不展开
    GongGaoAddModelYes//展开
};
//提升等级是否展开枚举
typedef NS_ENUM(NSUInteger, isUpGradeAddModel) {
    UpGradeAddModelNo = 0,//不展开
    UpGradeAddModelYes//展开
};
//部门管理是否展开枚举
typedef NS_ENUM(NSUInteger, isDepartmentAddModel) {
    DepartmentAddModelNo = 0,//不展开
    DepartmentAddModelYes//展开
};
//执行力是否展开枚举
typedef NS_ENUM(NSUInteger, isExecutiveAddModel) {
    ExecutiveAddModelNo = 0,//不展开
    ExecutiveAddModelYes//展开
};
//好友机构是否展开枚举
typedef NS_ENUM(NSUInteger, isFriendMgrAddModel) {
    FriendMgrAddModelNo = 0,//不展开
    FriendMgrAddModelYes//展开
};
//考勤管理是否展开枚举
typedef NS_ENUM(NSUInteger, isAttendanceMgrAddModel) {
    AttendanceMgrAddModelNo = 0,//不展开
    AttendanceMgrAddModelYes//展开
};
//员工管理是否展开枚举
typedef NS_ENUM(NSUInteger, isEMAddModel) {
    EMAddModelNo = 0,//不展开
    EMAddModelYes//展开
};
//财务管理是否展开枚举
typedef NS_ENUM(NSUInteger, isFMAddModel) {
    FMAddModelNo = 0,//不展开
    FMAddModelYes//展开
};

@interface EditRightViewController : BaseViewController
@property (nonatomic) ReturnIsRefreshRightBlock isRefreshRight;//用于刷新上级页面列表 1 则刷新
@property (nonatomic) NSInteger seType;//
@property (nonatomic,copy) NSString *powerId;
@property (nonatomic, strong) UITextField *rightNameTF;
@property (nonatomic, strong) NSString *rightName;
@property (nonatomic, strong) NSMutableArray *FunctionsArr;
@property (nonatomic)SelectStatus selectStatus;
@property (nonatomic)SelectType selectType;
@property (nonatomic)isProductAddModel isProductAdd;
@property (nonatomic)isTaskAddModel isTaskAdd;
@property (nonatomic)isDianXiaoAddModel isDianXiaoAdd;
@property (nonatomic)isRightAddModel isRightAdd;
@property (nonatomic)isCRMAddModel isCRMAdd;
@property (nonatomic)isOrderAddModel isOrderAdd;
@property (nonatomic)isGongGaoAddModel isGongGaoAdd;
@property (nonatomic)isUpGradeAddModel isUpGradeAdd;
@property (nonatomic)isDepartmentAddModel isDepartmentAdd;
@property (nonatomic)isExecutiveAddModel isExecutiveAdd;
@property (nonatomic)isFriendMgrAddModel isFriendMgrAdd;
@property (nonatomic)isAttendanceMgrAddModel isAttendanceAdd;
@property (nonatomic)isEMAddModel isEMAdd;
@property (nonatomic)isFMAddModel isFMAdd;
- (void)returnIsRefreshRight:(ReturnIsRefreshRightBlock)block;
@end
