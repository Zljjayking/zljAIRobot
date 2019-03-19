//
//  approvalImageTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalImageTableViewCell.h"

@implementation approvalImageTableViewCell

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
    self.titleLB = [[UILabel alloc]init];
    [self addSubview:self.titleLB];
    self.titleLB.textColor = GRAY140;
    self.titleLB.font = [UIFont systemFontOfSize:15];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
//    self.star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
//    [self addSubview:self.star];
//    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleLB.mas_centerY);
//        make.left.equalTo(self.titleLB.mas_right).offset(5);
//        make.width.mas_equalTo(8);
//        make.height.mas_equalTo(8);
//    }];
    
//    self.ImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:self.ImageBtn];
//    [self.ImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-40);
//        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
//        make.bottom.equalTo(self.mas_bottom).offset(0);
//        make.left.equalTo(self.mas_left).offset(0);
//    }];
    
//    UIView *seperator1 = [[UIView alloc]init];
//    [self addSubview:seperator1];
//    seperator1.backgroundColor = GRAY229;
//    [seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).offset(-1);
//        make.height.mas_equalTo(0.3);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
