//
//  payGroupTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/28.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "payGroupTwoTableViewCell.h"

@implementation payGroupTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    bgView.layer.cornerRadius = 5*KAdaptiveRateWidth;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(7*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-7*KAdaptiveRateWidth);
    }];

    UIView *hehe = [[UIView alloc] init];
    hehe.backgroundColor = kMyColor(253, 159, 42);
    [self addSubview:hehe];
    [hehe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateWidth);
        make.left.equalTo(self.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(5*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
    
    UILabel *heheLB = [[UILabel alloc]init];
    [self addSubview:heheLB];
    heheLB.text = @"提成方式选择";
    heheLB.textColor = GRAY138;
    heheLB.font = [UIFont systemFontOfSize:14];
    [heheLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hehe.mas_centerY);
        make.left.equalTo(hehe.mas_right).offset(5*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    [self addSubview:scroll];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(100*4, 0);
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(heheLB.mas_bottom).offset(7*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-7*KAdaptiveRateWidth);
    }];
    
    self.jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jianBtn.layer.masksToBounds = YES;
    self.jianBtn.layer.cornerRadius = 10;
    self.jianBtn.layer.borderWidth = 0.3;
    self.jianBtn.layer.borderColor = GRAY200.CGColor;
    [scroll addSubview:self.jianBtn];
    [self.jianBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.jianBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateSelected];
    [self.jianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scroll.mas_top).offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(110);
        make.left.equalTo(scroll.mas_left).offset(5);
    }];
    
    UIImageView *imageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"件彩图"]];
    [self.jianBtn addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jianBtn.mas_centerX);
        make.top.equalTo(self.jianBtn.mas_top).offset(5);
        make.width.mas_equalTo(117/2.0);
        make.height.mas_equalTo(86/2.0);
    }];
    
    UILabel *titleOneLB = [[UILabel alloc] init];
    titleOneLB.text = @"件";
    titleOneLB.textColor = GRAY50;
    titleOneLB.font = KFONT(17, 0.1);
    [self.jianBtn addSubview:titleOneLB];
    [titleOneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jianBtn.mas_centerX);
        make.top.equalTo(imageOne.mas_bottom).offset(10);
    }];
    
    UILabel *contentOneLB = [[UILabel alloc]init];
    contentOneLB.text = @"成功的订单";
    contentOneLB.textColor = GRAY90;
    contentOneLB.font = [UIFont systemFontOfSize:11];
    [self.jianBtn addSubview:contentOneLB];
    [contentOneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jianBtn.mas_centerX);
        make.top.equalTo(titleOneLB.mas_bottom).offset(8);
    }];
    
    
    
    self.liangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.liangBtn.layer.masksToBounds = YES;
    self.liangBtn.layer.cornerRadius = 10;
    self.liangBtn.layer.borderWidth = 0.3;
    self.liangBtn.layer.borderColor = GRAY200.CGColor;
    [scroll addSubview:self.liangBtn];
    [self.liangBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.liangBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateSelected];
    [self.liangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scroll.mas_top).offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(110);
        make.left.equalTo(self.jianBtn.mas_right).offset(10);
    }];
    
    UIImageView *imageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"量彩图"]];
    [self.liangBtn addSubview:imageTwo];
    [imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.liangBtn.mas_centerX);
        make.top.equalTo(self.liangBtn.mas_top).offset(5);
        make.width.mas_equalTo(117/2.0);
        make.height.mas_equalTo(86/2.0);
    }];
    
    UILabel *titleTwoLB = [[UILabel alloc] init];
    titleTwoLB.text = @"量";
    titleTwoLB.textColor = GRAY50;
    titleTwoLB.font = KFONT(17, 0.1);
    [self.liangBtn addSubview:titleTwoLB];
    [titleTwoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.liangBtn.mas_centerX);
        make.top.equalTo(imageTwo.mas_bottom).offset(10);
    }];
    
    UILabel *contentTwoLB = [[UILabel alloc]init];
    contentTwoLB.text = @"意向客户";
    contentTwoLB.textColor = GRAY90;
    contentTwoLB.font = [UIFont systemFontOfSize:11];
    [self.liangBtn addSubview:contentTwoLB];
    [contentTwoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.liangBtn.mas_centerX);
        make.top.equalTo(titleTwoLB.mas_bottom).offset(8);
    }];
    
    
    
    self.seviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.seviceBtn.layer.masksToBounds = YES;
    self.seviceBtn.layer.cornerRadius = 10;
    self.seviceBtn.layer.borderWidth = 0.3;
    self.seviceBtn.layer.borderColor = GRAY200.CGColor;
    [scroll addSubview:self.seviceBtn];
    [self.seviceBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.seviceBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateSelected];
    [self.seviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scroll.mas_top).offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(110);
        make.left.equalTo(self.liangBtn.mas_right).offset(10);
    }];
    
    UIImageView *imageThree = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"服务费彩图"]];
    [self.seviceBtn addSubview:imageThree];
    [imageThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.seviceBtn.mas_centerX);
        make.top.equalTo(self.seviceBtn.mas_top).offset(5);
        make.width.mas_equalTo(117/2.0);
        make.height.mas_equalTo(86/2.0);
    }];
    
    UILabel *titleThreeLB = [[UILabel alloc] init];
    titleThreeLB.text = @"服务费";
    titleThreeLB.textColor = GRAY50;
    titleThreeLB.font = KFONT(17, 0.1);
    [self.seviceBtn addSubview:titleThreeLB];
    [titleThreeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.seviceBtn.mas_centerX);
        make.top.equalTo(imageTwo.mas_bottom).offset(10);
    }];
    
    UILabel *contentThreeLB = [[UILabel alloc]init];
    contentThreeLB.text = @"订单的百分比";
    contentThreeLB.textColor = GRAY90;
    contentThreeLB.font = [UIFont systemFontOfSize:11];
    [self.seviceBtn addSubview:contentThreeLB];
    [contentThreeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.seviceBtn.mas_centerX);
        make.top.equalTo(titleTwoLB.mas_bottom).offset(8);
    }];
    
    
    self.fangKuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fangKuanBtn.layer.masksToBounds = YES;
    self.fangKuanBtn.layer.cornerRadius = 10;
    self.fangKuanBtn.layer.borderWidth = 0.3;
    self.fangKuanBtn.layer.borderColor = GRAY200.CGColor;
    [scroll addSubview:self.fangKuanBtn];
    [self.fangKuanBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.fangKuanBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateSelected];
    [self.fangKuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scroll.mas_top).offset(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(110);
        make.left.equalTo(self.seviceBtn.mas_right).offset(10);
    }];
    
    UIImageView *imageFour = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"放款总额"]];
    [self.fangKuanBtn addSubview:imageFour];
    [imageFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fangKuanBtn.mas_centerX);
        make.top.equalTo(self.fangKuanBtn.mas_top).offset(5);
        make.width.mas_equalTo(110/2.0);
        make.height.mas_equalTo(94/2.0);
    }];
    
    UILabel *titleFourLB = [[UILabel alloc] init];
    titleFourLB.text = @"放款总额";
    titleFourLB.textColor = GRAY50;
    titleFourLB.font = KFONT(17, 0.1);
    [self.fangKuanBtn addSubview:titleFourLB];
    [titleFourLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fangKuanBtn.mas_centerX);
        make.top.equalTo(imageTwo.mas_bottom).offset(10);
    }];
    
    UILabel *contentFourLB = [[UILabel alloc]init];
    contentFourLB.text = @"放款总额百分比";
    contentFourLB.textColor = GRAY90;
    contentFourLB.font = [UIFont systemFontOfSize:11];
    [self.fangKuanBtn addSubview:contentFourLB];
    [contentFourLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.fangKuanBtn.mas_centerX);
        make.top.equalTo(titleTwoLB.mas_bottom).offset(8);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
