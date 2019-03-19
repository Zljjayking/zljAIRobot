//
//  DYVCSegmentThree.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTwoViewController.h"
#import "approvalModel.h"
typedef void (^pushThree)(approvalModel *model);
@interface DYVCSegmentThree : BaseTwoViewController
@property (nonatomic) pushThree pushBlock;
-(void)siftingDataWithDic:(NSMutableDictionary *)dic;
@end
