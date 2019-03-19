//
//  AddressButtonCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "AddressButtonCell.h"

@implementation AddressButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addressLabel.textColor = GRAY90;
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(18);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.height.mas_equalTo(17);
//    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
