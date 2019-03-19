//
//  OrderDetailFourCell.m
//  Financeteam
//
//  Created by Zccf on 16/11/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OrderDetailFourCell.h"

@implementation OrderDetailFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.TopLabel.textColor = GRAY90;
    self.BottomTextView.scrollEnabled = YES;
    self.BottomTextView.editable = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
