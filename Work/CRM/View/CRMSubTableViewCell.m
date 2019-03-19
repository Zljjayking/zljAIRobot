//
//  CRMSubTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMSubTableViewCell.h"

@implementation CRMSubTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.textColor = [UIColor grayColor];
    self.titleLB.font = [UIFont systemFontOfSize:17];
    
    [self addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    UIView *separator = [[UIView alloc]init];
    separator.backgroundColor = [UIColor whiteColor];
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.2);
        make.height.mas_equalTo(0.5);
    }];
    
    
//    UIView *separator = [[UIView alloc]init];
//    separator.backgroundColor = GRAY229;
//    [cell addSubview:separator];
//    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(10);
//        make.right.equalTo(self.mas_right).offset(0);
//        make.bottom.equalTo(self.mas_bottom).offset(-0.2);
//        make.height.mas_equalTo(0.2);
//    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
