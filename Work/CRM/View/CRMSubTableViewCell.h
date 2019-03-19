//
//  CRMSubTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/6/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"
@interface CRMSubTableViewCell : UITableViewCell
@property (retain,nonatomic) TreeViewNode *node;//data
@property (nonatomic) UILabel *titleLB;
@property (nonatomic) NSArray *BtnArr;

@end
