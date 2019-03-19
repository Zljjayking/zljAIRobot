//
//  InputProductInfoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "InputProductInfoCell.h"

@implementation InputProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.inputproductLabel.font = [UIFont systemFontOfSize:15];
    self.inputproductLabel.textColor = MYGRAY;
    
    self.inputProductTextField.font = [UIFont systemFontOfSize:15];
    self.inputProductTextField.textAlignment = NSTextAlignmentRight;
    
    UIView *separator = [[UIView alloc]init];
    separator.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.4);
        make.height.mas_equalTo(0.4);
    }];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
