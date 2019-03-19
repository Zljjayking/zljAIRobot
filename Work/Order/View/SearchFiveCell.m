//
//  SearchFiveCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/4.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SearchFiveCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.searchFiveLBtn.layer.borderWidth = 0.4f;
    self.searchFiveLBtn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    
    self.searchFiveRBtn.layer.borderWidth = 0.4f;
    self.searchFiveRBtn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
