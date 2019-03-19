//
//  CRMDetailFourTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 17/3/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"
@interface CRMDetailFourTableViewCell : UITableViewCell
@property (retain,nonatomic) TreeViewNode *node;//data
@property (nonatomic) UILabel *titleLB;
@property (nonatomic) NSArray *BtnArr;

@end
