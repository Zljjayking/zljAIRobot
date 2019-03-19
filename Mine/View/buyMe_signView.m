//
//  buyMe_signView.m
//  Financeteam
//
//  Created by Zccf on 2017/8/17.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMe_signView.h"

@implementation buyMe_signView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 10;
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(280);
        make.top.equalTo(self.mas_top).offset(30.75);
        make.bottom.equalTo(self.mas_bottom);
    }];

    
    self.topImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_top"]];
    [self addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(47);//754*148 188.5*37
    }];
    
    
    self.titleLB = [[UILabel alloc]init];
    [bgView addSubview:self.titleLB];
    self.titleLB.text = @"百人以上规模大客户，我们提供线下签约服务";
    self.titleLB.textColor = GRAY90;
    self.titleLB.font = [UIFont systemFontOfSize:11];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.top.equalTo(bgView.mas_top).offset(80);
        make.height.mas_equalTo(14);
    }];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:MYORANGE]];
    [bgView addSubview:leftImage];
    leftImage.layer.masksToBounds = YES;
    leftImage.layer.cornerRadius = 5;
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLB.mas_left).offset(-5);
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:MYORANGE]];
    [bgView addSubview:rightImage];
    rightImage.layer.masksToBounds = YES;
    rightImage.layer.cornerRadius = 5;
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(5);
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.width.height.mas_equalTo(10);
    }];
    
    UIView *lineViewOne = [[UIView alloc]init];
    [bgView addSubview:lineViewOne];
    lineViewOne.backgroundColor = GRAY229;
    [lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(12);
        make.right.equalTo(bgView.mas_right).offset(-12);
        make.top.equalTo(self.titleLB.mas_bottom).offset(50);
        make.height.mas_equalTo(0.5);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:@"暂不需要" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:GRAY200 forState:UIControlStateNormal];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(30.5);
        make.top.equalTo(lineViewOne.mas_bottom).offset(5);
        make.height.mas_equalTo(45);
    }];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.sureBtn];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:MYORANGE forState:UIControlStateNormal];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-30.5);
        make.top.equalTo(lineViewOne.mas_bottom).offset(5);
        make.height.mas_equalTo(45);
    }];
    
    UIView *lineViewTwo = [[UIView alloc]init];
    [bgView addSubview:lineViewTwo];
    lineViewTwo.backgroundColor = GRAY229;
    [lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.cancelBtn.mas_centerY);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(24);
    }];
}
- (void)cancelBtnClick:(UIButton *)sender {
    if (self.buyMeTopCancelBlock != nil) {
        self.buyMeTopCancelBlock();
    }
}
- (void)sureBtnClick:(UIButton *)sender {
    if (self.buyMeTopSureBlock != nil) {
        self.buyMeTopSureBlock();
    }   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
