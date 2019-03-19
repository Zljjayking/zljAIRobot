//
//  choosePeopleViewController.h
//  Financeteam
//
//  Created by Zccf on 16/7/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
//全选状态枚举
typedef NS_ENUM(NSUInteger, peopleSelectStatus) {
    peopleSelectStatusNone = 0,//未选
    peopleSelectStatusAll//全选
};

typedef void (^ReturnNSMutableArrayBlock)(NSMutableArray *returnMutableArray);
typedef void (^ReturnAvilableNSMutableArrayBlock)(NSMutableArray *returnAvilableMutableArray);
@interface chooseViewController : BaseViewController<UISearchDisplayDelegate, UISearchBarDelegate>
{
    
    NSMutableArray *searchResults;
    UISearchBar *contactsSearchBar;
    UISearchDisplayController *searchDisplayController;
    
}
@property (nonatomic,copy) ReturnNSMutableArrayBlock returnNSMutableArrayBlock;
@property (nonatomic,copy) ReturnAvilableNSMutableArrayBlock returnAvilableNSMutableArrayBlock;
- (void)returnMutableArray:(ReturnNSMutableArrayBlock)block;
- (void)returnAvilableMutableArray:(ReturnAvilableNSMutableArrayBlock)block;
@property (nonatomic)peopleSelectStatus selectStatus;
@property (nonatomic) NSInteger seType;//1.单选 2.多选
@property (nonatomic) NSInteger limited;//1 去除已分配的 2 去除创建人 345 6去除自己和显示上个页面传过来的数组 7 去除自己并显示未分配人员
@property (nonatomic) NSArray *limitArr;//传过来的人员id用于过滤不需要的人员
@property (nonatomic) NSArray *deleteArr;//用于在上个页面删除的人员传递过来拼接
@property (nonatomic) NSArray *addArr;//用于在此页面已经被添加过去的人员下次将剔除掉
@property (nonatomic) NSInteger deptId;
@property (nonatomic) NSArray *deptArr;//子部门ID数组
//这里是执行力需要的几个参数
@property (nonatomic, assign) BOOL isExecutive;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;

@end
