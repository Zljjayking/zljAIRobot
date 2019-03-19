//
//  DYVCSegmentFour.h
//  Financeteam
//
//  Created by Zccf on 2017/7/4.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseTwoViewController.h"
#import "approvalModel.h"
typedef void (^pushFour)(approvalModel *model);
@interface DYVCSegmentFour : BaseTwoViewController
@property (nonatomic) pushFour pushBlock;
-(void)siftingDataWithDic:(NSMutableDictionary *)dic;
@end
