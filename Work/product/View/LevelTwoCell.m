//
//  LevelTwoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/14.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "LevelTwoCell.h"

@implementation LevelTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = GRAY90;
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
