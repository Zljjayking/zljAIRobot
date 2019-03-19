//
//  paySetSixTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySetSixTableViewCell.h"

@implementation paySetSixTableViewCell

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
    self.backgroundColor = VIEW_BASE_COLOR;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview: bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-7*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIView *bgViewTwo = [[UIView alloc] init];
    bgViewTwo.backgroundColor = kMyColor(249, 249, 249);
    bgViewTwo.layer.cornerRadius = 5*KAdaptiveRateWidth;
    [self addSubview: bgViewTwo];
    [bgViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(0*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-19*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    UIView *bgViewThree = [[UIView alloc] init];
    bgViewThree.backgroundColor = kMyColor(249, 249, 249);
    [self addSubview: bgViewThree];
    [bgViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-19*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.layer.masksToBounds = YES;
    [self.btn setBackgroundImage:[UIImage imageWithColor:kMyColor(234, 234, 234)] forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [self.btn setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateDisabled];
    self.btn.layer.cornerRadius = 5*KAdaptiveRateWidth;
    [self.btn setImage:[UIImage imageNamed:@"大加号"] forState:UIControlStateNormal];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-20);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
