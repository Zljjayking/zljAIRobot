//
//  CRMSecondTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/14.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMSecondTableViewCell.h"

@implementation CRMSecondTableViewCell

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
    }];
    
    self.contentTF = [[UITextField alloc] init];
    [self addSubview:self.contentTF];
    self.contentTF.font = [UIFont systemFontOfSize:16 weight:0.2];
    self.contentTF.textColor = GRAY90;
    [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(5*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    
    self.arrowView = [[UIImageView alloc] init];
    self.arrowView.image = [UIImage imageNamed:@"箭头（下）"];
    [self addSubview:self.arrowView];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(8);
        make.width.mas_equalTo(13);
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
