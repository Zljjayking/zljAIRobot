//
//  SearchTwoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SearchTwoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.searchSecondLTF.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    self.searchSecondLTF.layer.borderWidth = 0.42f;
    
    self.searchSecondRTF.layer.borderWidth = 0.4f;
    self.searchSecondRTF.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
