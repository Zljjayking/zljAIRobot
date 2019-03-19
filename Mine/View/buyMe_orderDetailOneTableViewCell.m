//
//  buyMe_orderDetailOneTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/8/18.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMe_orderDetailOneTableViewCell.h"

@implementation buyMe_orderDetailOneTableViewCell

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
    
    self.titleLB = [[UILabel alloc] init];
    [self addSubview:self.titleLB];
    self.titleLB.font = [UIFont systemFontOfSize:15];
    self.titleLB.textColor = GRAY140;
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    self.stateLB = [[UITextField alloc]init];
    self.stateLB.font = [UIFont systemFontOfSize:15];
    self.stateLB.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.stateLB];
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(15);
    }];
    
    self.star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:self.star];
    self.star.hidden = YES;
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.left.equalTo(self.titleLB.mas_right).offset(5);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    self.arrowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:self.arrowImage];
    [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLB.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
    
    self.seperator = [[UIView alloc]init];
    [self addSubview:self.seperator];
    self.seperator.backgroundColor = GRAY229;
    [self.seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.4);
        make.width.mas_equalTo(kScreenWidth);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
