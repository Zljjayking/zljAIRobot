//
//  ButtonsCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/15.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPITreeViewNode.h"

@interface ButtonsCell : UITableViewCell

@property(retain,strong,nonatomic)CPITreeViewNode * node;

@property (nonatomic) UILabel *titleLabel;

@end
