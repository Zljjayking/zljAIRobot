//
//  ColumnNamesList.h
//  PrecisionExperiment
//
//  Created by 张帅 on 17/3/21.
//  Copyright © 2017年 Mask. All rights reserved.
//

#import "RootModel.h"

@interface ColumnNamesList : RootModel
@property (nonatomic,retain) NSMutableArray * ChildList;
//试材杂草ID
@property (nonatomic,copy) NSString * ColumnID;
//试材杂草名称
@property (nonatomic,copy) NSString *ColumnName;
@end
