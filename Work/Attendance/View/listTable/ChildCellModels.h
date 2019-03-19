//
//  CellModel.h
//  PrecisionExperiment
//
//  Created by 张帅 on 17/3/21.
//  Copyright © 2017年 Mask. All rights reserved.
//

#import "RootModel.h"

@interface ChildCellModels : RootModel
@property (nonatomic,retain) NSMutableArray *CellContents;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,strong) NSString *count;
@end
