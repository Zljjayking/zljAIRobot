//
//  approcalLBTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/23.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approcalLBTwoTableViewCell.h"

@implementation approcalLBTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = GRAY140;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(7);
        make.height.mas_equalTo(15);
    }];
    
    self.star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:self.star];
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    self.heheLB = [[UILabel alloc]init];
    [self addSubview:_heheLB];
    self.heheLB.textAlignment = NSTextAlignmentRight;
    self.heheLB.font = [UIFont systemFontOfSize:15];
    self.heheLB.numberOfLines = 0;
    [self.heheLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
    }];
    
    self.arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:self.arrow];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.heheLB.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    UIView *seperator1 = [[UIView alloc]init];
    [self addSubview:seperator1];
    seperator1.backgroundColor = GRAY229;
    [seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(0.3);
        make.width.mas_equalTo(kScreenWidth);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
