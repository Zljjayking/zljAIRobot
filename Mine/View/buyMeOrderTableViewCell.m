//
//  buyMeOrderTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/8/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeOrderTableViewCell.h"

@implementation buyMeOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.createTimeLB = [[UILabel alloc]init];
    [self addSubview:self.createTimeLB];
    self.createTimeLB.textColor = GRAY90;
    self.createTimeLB.font = [UIFont systemFontOfSize:17];
    [self.createTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    self.stateLB = [[UILabel alloc]init];
    [self addSubview:self.stateLB];
    self.stateLB.font = [UIFont systemFontOfSize:14];
    self.stateLB.textColor = GRAY200;
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    self.timeLB = [[UILabel alloc]init];
    [self addSubview:self.timeLB];
    self.timeLB.textColor = GRAY110;
    self.timeLB.font = [UIFont systemFontOfSize:14];
    self.timeLB.textAlignment = NSTextAlignmentRight;
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    self.moneyLB = [[UILabel alloc]init];
    [self addSubview:self.moneyLB];
    self.moneyLB.textColor = customBlue;
    self.moneyLB.font = [UIFont systemFontOfSize:16];
    self.moneyLB.textAlignment = NSTextAlignmentRight;
    [self.moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = GRAY229;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
