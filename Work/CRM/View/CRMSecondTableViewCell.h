//
//  CRMSecondTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/6/14.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"
@interface CRMSecondTableViewCell : UITableViewCell
@property (retain,nonatomic) TreeViewNode *node;//data
@property (nonatomic) UILabel *titleLB;
@property (nonatomic) UITextField *contentTF;
@property (nonatomic) NSString *titleStr;
@property (nonatomic) UIImageView *arrowView;//箭头
@property (nonatomic) BOOL isSuper;
@end
