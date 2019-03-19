//
//  DYVCSegmentTwo.h
//  DYScrollSegmentDemo
//
//  Created by Daniel Yao on 17/4/10.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTwoViewController.h"
#import "approvalModel.h"
typedef void (^pushTwo)(approvalModel *model);
@interface DYVCSegmentTwo : BaseTwoViewController
@property (nonatomic) pushTwo pushBlock;
-(void)siftingDataWithDic:(NSMutableDictionary *)dic;
@end
