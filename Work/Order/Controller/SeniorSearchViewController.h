//
//  SeniorSearchViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@protocol SeniorSearchViewControllerDelegate <NSObject>

//-(void)searchBarSearchButtonClicked:(NSString *)textString;

@end
typedef void (^ReturnSearchListBlock)(NSDictionary *returnSearchDic);
@interface SeniorSearchViewController : BaseViewController

@property(nonatomic,assign) id<SeniorSearchViewControllerDelegate> delegate;
@property (nonatomic) NSInteger seType;//0:搜索我的订单 1:搜索审批订单

@property (nonatomic,copy) ReturnSearchListBlock returnSearchListBlock;
- (void)returnSearchList:(ReturnSearchListBlock)block;
@end
