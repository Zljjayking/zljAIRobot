//
//  SearchOneCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SearchOneCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchOneTextField.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    self.searchOneTextField.layer.borderWidth = 0.4f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
