//
//  UpgradeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/23.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "UpgradeTableViewCell.h"

@implementation UpgradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    self.headerImage = [[UIImageView alloc] init];
    [self addSubview:self.headerImage];
    self.headerImage.layer.masksToBounds = YES;
    [self.headerImage.layer setCornerRadius:5];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(40*KAdaptiveRateWidth);
        make.width.mas_equalTo(40*KAdaptiveRateWidth);
    }];
    
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.font = [UIFont systemFontOfSize:17];
    self.nameLB.textColor = GRAY70;
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.headerImage.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    self.signLB = [[UILabel alloc] init];
    self.signLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.signLB];
    self.signLB.textColor = [UIColor grayColor];
    [self.signLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.headerImage.mas_centerY);
        make.height.mas_equalTo(17);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
