//
//  SearchFourCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/4.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SearchFourCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.searchFourLTF.layer.borderWidth = 0.4f;
    self.searchFourLTF.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    
    self.searchFourRTF.layer.borderWidth = 0.4f;
    self.searchFourRTF.layer.borderColor = TABBAR_BASE_COLOR.CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
