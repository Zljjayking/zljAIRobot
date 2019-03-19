//
//  CompoundViewModel.h
//  PrecisionExperiment
//
//  Created by 张帅 on 17/3/21.
//  Copyright © 2017年 Mask. All rights reserved.
//

#import "RootModel.h"
#import "RowNameList.h"
#import "ColumnNamesList.h"
#import "RowModels.h"
#import "CellContents.h"
@interface CompoundViewModel : RootModel
///横向咧 个数 试材杂草个数
@property (nonatomic,copy) NSString *ColumnCount;
///横向咧 个数 试材杂草个数
@property (nonatomic,copy) NSString *RowCount;
///试材 model List 包括 杂草名 和 剂量
@property (nonatomic,retain) NSMutableArray * ColumnNamesList;
///对每个杂草的评分
@property (nonatomic,retain) NSMutableArray * RowModels;
///药剂梯度List
@property (nonatomic,retain) NSMutableArray *RowNameList;
@end





