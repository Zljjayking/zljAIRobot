//
//  approvalDetailTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalDetailTableViewCell.h"

@implementation approvalDetailTableViewCell

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
    
    self.timeLB = [[UILabel alloc]init];
    [self addSubview:self.timeLB];
    self.timeLB.textColor = GRAY140;
    self.timeLB.font = [UIFont systemFontOfSize:14];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(15);
    }];

    self.orderNumLB = [[UILabel alloc]init];
    [self addSubview:self.orderNumLB];
    self.orderNumLB.textColor = GRAY140;
    self.orderNumLB.backgroundColor = [UIColor clearColor];
    self.orderNumLB.font = [UIFont systemFontOfSize:14];
    [self.orderNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(20);
        make.height.mas_equalTo(15);
    }];

    UIView *seperator = [[UIView alloc]init];
    [self addSubview:seperator];
    seperator.backgroundColor = GRAY229;
    [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom).offset(5);
        make.height.mas_equalTo(0.3);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    self.headerImage = [[UIImageView alloc] init];
    [self addSubview:self.headerImage];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 25;
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(seperator.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    self.nameLB = [[UILabel alloc]init];
    [self addSubview:self.nameLB];
    self.nameLB.font = [UIFont systemFontOfSize:15];
    self.nameLB.textColor = GRAY90;
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImage.mas_top).offset(5);
        make.left.equalTo(self.headerImage.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    self.numberLB = [[UILabel alloc] init];
    [self addSubview:self.numberLB];
    self.numberLB.font = [UIFont systemFontOfSize:13];
    self.numberLB.textColor = GRAY140;
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerImage.mas_bottom).offset(-1);
        make.left.equalTo(self.headerImage.mas_right).offset(10);
        make.height.mas_equalTo(13);
    }];
    
    self.dayLB = [[UILabel alloc]init];
    [self addSubview:self.dayLB];
    self.dayLB.font = [UIFont systemFontOfSize:20];
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerImage.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    self.seperator1 = [[UIView alloc]init];
    [self addSubview:self.seperator1];
    self.seperator1.backgroundColor = GRAY229;
    [self.seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
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
