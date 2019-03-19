//
//  CRMDetailsTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMDetailsTwoTableViewCell.h"

@implementation CRMDetailsTwoTableViewCell

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
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.textColor = [UIColor grayColor];
    self.titleLB.font = [UIFont systemFontOfSize:16];
    
    [self addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(75);
    }];
    
    self.contentTF = [[UITextField alloc] init];
    [self addSubview:self.contentTF];
    [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(5*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    self.unitLB = [[UILabel alloc] init];
    [self addSubview:self.unitLB];
    self.unitLB.font = [UIFont systemFontOfSize:14];
    [self.unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTF.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(16);
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
