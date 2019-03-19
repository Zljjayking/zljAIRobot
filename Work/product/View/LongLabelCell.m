//
//  LongLabelCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/15.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "LongLabelCell.h"

@implementation LongLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.longLabel.textColor = GRAY90;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
