//
//  CRMSearchChooseViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/8/10.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnNSMutableArrayBlock)(NSMutableArray *returnMutableArray);
@interface CRMSearchChooseViewController : BaseViewController
@property (nonatomic,copy) ReturnNSMutableArrayBlock returnNSMutableArrayBlock;
- (void)returnMutableArray:(ReturnNSMutableArrayBlock)block;
@property (nonatomic, strong) NSArray *alreadyChooseItems;
@end
