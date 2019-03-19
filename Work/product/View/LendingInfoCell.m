//
//  LendingInfoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "LendingInfoCell.h"

@implementation LendingInfoCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.LendingLabel.font = [UIFont systemFontOfSize:15];
    self.LendingLabel.textColor = MYGRAY;
    
    self.minTextField.font = [UIFont systemFontOfSize:15];
    [self.maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeAndMoneyLabel.mas_left).offset(-10);
        make.width.mas_equalTo(70);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.maxTextField.mas_left).offset(0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lineLB.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(70);
    }];
    self.maxTextField.font = [UIFont systemFontOfSize:15];
    
    self.timeAndMoneyLabel.font = [UIFont systemFontOfSize:15];
    
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
