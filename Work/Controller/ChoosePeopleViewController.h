//
//  ChoosePeopleViewController.h
//  Financeteam
//
//  Created by Zccf on 16/5/31.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
//全选状态枚举
typedef NS_ENUM(NSUInteger, selectStatus) {
    selectStatusNone = 0,//未选
    selectStatusAll//全选
};
//父权限状态枚举
typedef NS_ENUM(NSUInteger, selectType) {
    selectTypeNo = 0,//未选
    selectTypeYes//全选
};
//产品是否展开枚举
typedef NS_ENUM(NSUInteger, isproductAddModel) {
    productAddModelNo = 0,//不展开
    productAddModelYes//展开
};

typedef void (^ReturnNSMutableArrayBlock)(NSMutableArray *returnMutableArray);
typedef void (^ReturnAvilableNSMutableArrayBlock)(NSMutableArray *returnAvilableMutableArray);
@interface ChoosePeopleViewController : BaseViewController
@property (nonatomic)NSInteger seType;
@property (nonatomic)selectStatus selectStatus;
@property (nonatomic)selectType selectType;
@property (nonatomic)isproductAddModel isProductAdd;
@property (nonatomic,copy) ReturnNSMutableArrayBlock returnNSMutableArrayBlock;
@property (nonatomic,copy) ReturnAvilableNSMutableArrayBlock returnAvilableNSMutableArrayBlock;
- (void)returnMutableArray:(ReturnNSMutableArrayBlock)block;
- (void)returnAvilableMutableArray:(ReturnAvilableNSMutableArrayBlock)block;
@property (nonatomic)NSInteger limited;
@property (nonatomic) NSArray *limitArr;//传过来的人员id用于过滤不需要的人员
@end
