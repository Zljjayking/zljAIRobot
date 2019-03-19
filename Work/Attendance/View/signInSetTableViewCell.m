//
//  signInSetTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/7.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "signInSetTableViewCell.h"

@implementation signInSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = VIEW_BASE_COLOR;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    UIView *bgview = [[UIView alloc]init];
    [self addSubview:bgview];
    bgview.backgroundColor = [UIColor whiteColor];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-7*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"passWord"]];
    [self addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(17);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = GRAY100;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    self.chooseTF = [[UITextField alloc]init];
    [self addSubview:_chooseTF];
    self.chooseTF.font = [UIFont systemFontOfSize:17];
    self.chooseTF.textAlignment = NSTextAlignmentRight;
    [_chooseTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
    }];
    
//    self.arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（右）"]];
//    [self addSubview:self.arrow];
//    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.chooseTF.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.width.mas_equalTo(7);
//        make.height.mas_equalTo(12);
//    }];
    
    self.star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:self.star];
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    
    UIView *seperator1 = [[UIView alloc]init];
    [self addSubview:seperator1];
    seperator1.backgroundColor = GRAY229;
    [seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(0.3);
        make.width.mas_equalTo(kScreenWidth-30);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
