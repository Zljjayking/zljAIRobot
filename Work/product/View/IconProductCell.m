//
//  IconProductCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "IconProductCell.h"

@implementation IconProductCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconProLabel.font = [UIFont systemFontOfSize:15];
    self.iconProLabel.textColor = MYGRAY;
    self.addIconButton.layer.masksToBounds = YES;
    self.addIconButton.layer.cornerRadius = 5;
    CGRect p = self.addIconButton.frame;
    p.origin.x = kScreenWidth - 78;
    self.addIconButton.frame = p;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
