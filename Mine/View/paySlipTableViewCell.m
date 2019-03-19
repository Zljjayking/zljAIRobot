//
//  paySlipTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/7/13.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySlipTableViewCell.h"

@implementation paySlipTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeLB = [[UILabel alloc]init];
        [self addSubview:self.typeLB];
        self.typeLB.textColor = GRAY160;
        self.typeLB.font = [UIFont systemFontOfSize:16];
        [self.typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        self.moneyLB = [[UILabel alloc]init];
        [self addSubview:self.moneyLB];
        [self.moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-20);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(20);
        }];
//        self.moneyLB.font = [UIFont systemFontOfSize:15];
        
        UIView *seperator = [[UIView alloc]init];
        [self addSubview:seperator];
        seperator.backgroundColor = GRAY229;
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(0.4);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
