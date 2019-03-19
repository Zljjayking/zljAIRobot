//
//  DYVCSegmentOne.h
//  DYScrollSegmentDemo
//
//  Created by Daniel Yao on 17/4/10.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTwoViewController.h"
#import "approvalModel.h"
typedef void (^pushOne)(approvalModel *model);
@interface DYVCSegmentOne : BaseTwoViewController
@property (nonatomic) pushOne pushBlock;
-(void)siftingDataWithDic:(NSMutableDictionary *)dic;

@end
