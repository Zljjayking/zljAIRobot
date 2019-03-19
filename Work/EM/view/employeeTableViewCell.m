//
//  employeeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeTableViewCell.h"

@implementation employeeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.headImage = [[UIImageView alloc] init];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    self.sexImage = [[UIImageView alloc] init];
    self.sexImage.layer.masksToBounds = YES;
    [self addSubview:self.sexImage];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headImage.mas_right).offset(0);
        make.bottom.equalTo(self.headImage.mas_bottom);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(15);
    }];
    
    self.nameLb = [[UILabel alloc] init];
    [self addSubview:self.nameLb];
    self.nameLb.textColor = GRAY70;
    self.nameLb.font = [UIFont systemFontOfSize:17];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_top).offset(4);
        make.left.equalTo(self.headImage.mas_right).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(18);
    }];
    
    self.mobileLb = [[UILabel alloc] init];
    [self addSubview:self.mobileLb];
    self.mobileLb.textColor = GRAY90;
    self.mobileLb.font = [UIFont systemFontOfSize:15];
    [self.mobileLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImage.mas_bottom).offset(-4);
        make.left.equalTo(self.headImage.mas_right).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(15);
    }];
    
    self.signImage = [[UIImageView alloc] init];
    [self addSubview:self.signImage];
    [self.signImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
