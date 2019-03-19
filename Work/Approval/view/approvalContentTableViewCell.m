//
//  approvalContentTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/16.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalContentTableViewCell.h"

@implementation approvalContentTableViewCell

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
    
    self.chooseTF = [[UITextView alloc]init];
    [self addSubview:_chooseTF];
    self.chooseTF.scrollEnabled = NO;
    self.chooseTF.textAlignment = NSTextAlignmentLeft;
    self.chooseTF.font = [UIFont systemFontOfSize:15];
    [_chooseTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.titleLabel.mas_left).offset(10);
    }];
    
    self.placeholder = [[UILabel alloc]init];
    [self addSubview:self.placeholder];
    self.placeholder.textColor = kMyColor(200, 200, 200);
    self.placeholder.font = [UIFont systemFontOfSize:16];
    [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseTF.mas_left).offset(5);
        make.top.equalTo(self.chooseTF.mas_top).offset(9);
        make.height.mas_equalTo(16);
    }];
//    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（右）"]];
//    [self addSubview:arrow];
//    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.chooseTF.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.width.mas_equalTo(7);
//        make.height.mas_equalTo(12);
//    }];
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
