//
//  LongLabelCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/15.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPITreeViewNode.h"

@interface LongLabelCell : UITableViewCell

@property(retain,strong,nonatomic)CPITreeViewNode * node;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UITextView *longTextView;

@end
