//
//  choosePeopleTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/31.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "choosePeopleTableViewCell.h"

@implementation choosePeopleTableViewCell

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
-(void)setupView {
    
    self.DaGouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.DaGouBtn];
    [self.DaGouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(70*KAdaptiveRateHeight);
        make.width.mas_equalTo(30*KAdaptiveRateWidth);
    }];
    
    self.DaGouImage = [[UIImageView alloc] init];
    [self.DaGouBtn addSubview:self.DaGouImage];
    [self.DaGouImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.DaGouBtn.center);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
        make.width.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
    self.headerImage = [[UIImageView alloc]init];
    [self addSubview:self.headerImage];
    self.headerImage.layer.masksToBounds = YES;
    [self.headerImage.layer setCornerRadius:22.5];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.DaGouBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(45);
    }];
    
    self.nameLB = [[UILabel alloc]init];
    self.nameLB.textColor = GRAY50;
    [self addSubview:self.nameLB];
    self.nameLB.font = customFont(16);
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
