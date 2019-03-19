//
//  LevelOneCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/14.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPITreeViewNode.h"

@interface LevelOneCell : UITableViewCell

@property(retain,strong,nonatomic)CPITreeViewNode * node;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;//箭头
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
