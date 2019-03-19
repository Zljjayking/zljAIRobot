//
//  dailyTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "dailyTwoTableViewCell.h"

@implementation dailyTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.headerImage = [[UIImageView alloc]init];
    [self addSubview:self.headerImage];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 20*KAdaptiveRateWidth;
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10*KAdaptiveRateWidth);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(40*KAdaptiveRateWidth);
        make.height.mas_equalTo(40*KAdaptiveRateWidth);
    }];
    
    self.titleLb = [[UILabel alloc]init];
    [self addSubview:self.titleLb];
    self.titleLb.textColor = [UIColor whiteColor];
    self.titleLb.font = [UIFont systemFontOfSize:15];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.equalTo(self.headerImage.mas_centerY).offset(-10*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    self.contentLb = [[UILabel alloc]init];
    [self addSubview:self.contentLb];
    self.contentLb.textColor = GRAY210;
    self.contentLb.font = [UIFont systemFontOfSize:14];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.equalTo(self.headerImage.mas_centerY).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(16);
    }];
    
    self.contentLbTwo = [[UILabel alloc]init];
    [self addSubview:self.contentLbTwo];
    self.contentLbTwo.textColor = GRAY210;
    self.contentLbTwo.font = [UIFont systemFontOfSize:14];
    [self.contentLbTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLb.mas_right).offset(20*KAdaptiveRateWidth);
        make.centerY.equalTo(self.headerImage.mas_centerY).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(16);
    }];
    
    UIView *line = [[UIView alloc]init];
    [self addSubview:line];
    line.backgroundColor = GRAY210;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-0.3);
        make.height.mas_equalTo(0.5);
        make.right.equalTo(self.mas_right);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
