//
//  employeeSixTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/26.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeSixTableViewCell.h"

@implementation employeeSixTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.textColor = GRAY90;
    self.nameLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    self.womenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.womenBtn];
    [self.womenBtn setBackgroundImage:[UIImage imageNamed:@"women_1"] forState:UIControlStateNormal];
    [self.womenBtn setBackgroundImage:[UIImage imageNamed:@"women_2"] forState:UIControlStateSelected];
    [self.womenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    //[self.womenBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
    
    self.manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.manBtn];
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"man_1"] forState:UIControlStateNormal];
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"man_2"] forState:UIControlStateSelected];
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.womenBtn.mas_left).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    //[self.manBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];

    self.starImage = [[UIImageView alloc] init];
    self.starImage.image = [UIImage imageNamed:@"星号"];
    [self addSubview:self.starImage];
    [self.starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
