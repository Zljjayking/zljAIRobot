//
//  MyOrderTableViewCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MyOrderTableViewCell.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.nameLabel.textColor = GRAY70;
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    CGRect rect = self.nameLabel.frame;
    rect.size.width = 60*KAdaptiveRateWidth;
    self.nameLabel.frame = rect;
    [self updateConstraintsIfNeeded];
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
    //裁剪一个角
    self.speedLabel.layer.masksToBounds = YES;
    self.speedLabel.layer.cornerRadius = 5;
    self.speedLabel.textColor = [UIColor whiteColor];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
