//
//  paySetTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySetTwoTableViewCell.h"

@implementation paySetTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = VIEW_BASE_COLOR;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview: bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-7*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIView *bgViewTwo = [[UIView alloc] init];
    bgViewTwo.backgroundColor = kMyColor(249, 249, 249);
    bgViewTwo.layer.cornerRadius = 5*KAdaptiveRateWidth;
    [self addSubview: bgViewTwo];
    [bgViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-19*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    UIView *bgViewThree = [[UIView alloc] init];
    bgViewThree.backgroundColor = kMyColor(249, 249, 249);
    [self addSubview: bgViewThree];
    [bgViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-19*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom);
    }];

    self.nameLB = [[UILabel alloc] init];
    self.nameLB.text = @"";
    //self.nameLB.textColor = GRAY90;
    [self addSubview:self.nameLB];
    self.nameLB.font = [UIFont systemFontOfSize:16];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    self.unitLB = [[UILabel alloc] init];
    self.unitLB.text = @"百分比(%)";
    self.unitLB.textColor = GRAY120;
    [self addSubview:self.unitLB];
    self.unitLB.font = [UIFont systemFontOfSize:14];
    [self.unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(20);
    }];

    self.salaryLB = [[UILabel alloc]init];
    self.salaryLB.numberOfLines = 0;
    self.salaryLB.text = @"基础提成方案";
    self.salaryLB.textColor = GRAY138;
    self.salaryLB.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.salaryLB];
    [self.salaryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40*KAdaptiveRateWidth);
        make.top.equalTo(self.nameLB.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-40);
        
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
