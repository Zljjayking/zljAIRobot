//
//  RowModels.h
//  PrecisionExperiment
//
//  Created by 张帅 on 17/3/21.
//  Copyright © 2017年 Mask. All rights reserved.
//

#import "RootModel.h"
@interface RowModels : RootModel
///评分列表
@property (nonatomic,retain) NSMutableArray *ChildCellModels;
///第几行
@property (nonatomic,copy) NSString * RowIndex;

@end
