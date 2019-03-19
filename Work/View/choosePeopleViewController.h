//
//  choosePeopleViewController.h
//  Financeteam
//
//  Created by Zccf on 16/7/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
//全选状态枚举
typedef NS_ENUM(NSUInteger, selectStatus) {
    selectStatusNone = 0,//未选
    selectStatusAll//全选
};
typedef void (^ReturnNSMutableArrayBlock)(NSMutableArray *returnMutableArray);
typedef void (^ReturnAvilableNSMutableArrayBlock)(NSMutableArray *returnAvilableMutableArray);
@interface choosePeopleViewController : BaseViewController
@property (nonatomic,copy) ReturnNSMutableArrayBlock returnNSMutableArrayBlock;
@property (nonatomic,copy) ReturnAvilableNSMutableArrayBlock returnAvilableNSMutableArrayBlock;
- (void)returnMutableArray:(ReturnNSMutableArrayBlock)block;
- (void)returnAvilableMutableArray:(ReturnAvilableNSMutableArrayBlock)block;
@property (nonatomic)NSInteger seType;
@property (nonatomic)NSInteger limited;
@property (nonatomic) NSArray *limitArr;//传过来的人员id用于过滤不需要的人员
@end
