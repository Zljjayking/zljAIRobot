//
//  RedLabelCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/15.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPITreeViewNode.h"

@interface RedLabelCell : UITableViewCell

@property(retain,strong,nonatomic)CPITreeViewNode * node;
@property (weak, nonatomic) IBOutlet UILabel *leftRedLabel;
@property (weak, nonatomic) IBOutlet UILabel *redLabel;
@property (weak, nonatomic) IBOutlet UITextView *redText;

@end
