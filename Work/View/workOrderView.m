//
//  workOrderView.m
//  Financeteam
//
//  Created by Zccf on 2017/6/13.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "workOrderView.h"

@implementation workOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btn];
        self.btn.frame = CGRectMake(0, 0, kScreenWidth, frame.size.height);
        [self.btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self.btn setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
        
        UIView *bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        bgView.userInteractionEnabled = NO;
        bgView.layer.cornerRadius = (self.frame.size.height - 10*KAdaptiveRateWidth) *0.5;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(kScreenWidth-20);
            make.height.mas_equalTo(self.frame.size.height - 10*KAdaptiveRateWidth);
        }];
        bgView.backgroundColor = GRAY240;
        bgView.layer.borderColor = VIEW_BASE_COLOR.CGColor;
        bgView.layer.borderWidth = 0.3;
        bgView.layer.shadowOpacity = 0.5f;// 阴影透明度
        bgView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
        bgView.layer.shadowRadius = 2;// 阴影扩散的范围控制
        bgView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
        
        UIView *bgTwoView = [[UIView alloc]init];
        [bgView addSubview:bgTwoView];
        bgTwoView.userInteractionEnabled = NO;
        bgTwoView.backgroundColor = [UIColor whiteColor];
        bgTwoView.layer.cornerRadius = (self.frame.size.height - 10*KAdaptiveRateWidth) *0.5;
        [bgTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left);
            make.centerY.equalTo(bgView.mas_centerY);
            make.height.mas_equalTo(self.frame.size.height - 10*KAdaptiveRateWidth);
            make.width.mas_equalTo(100*KAdaptiveRateWidth);
        }];
        
        UIView *bgThreeView = [[UIView alloc]init];
        [bgView addSubview:bgThreeView];
        bgThreeView.userInteractionEnabled = NO;
        bgThreeView.backgroundColor = [UIColor whiteColor];
        [bgThreeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(50);
            make.centerY.equalTo(bgView.mas_centerY);
            make.height.mas_equalTo(self.frame.size.height - 10*KAdaptiveRateWidth);
            make.right.equalTo(bgView.mas_right).offset(-80*KAdaptiveRateWidth);
        }];
        
        self.lineOneView = [[UIView alloc]init];
        [self addSubview:self.lineOneView];
        self.lineOneView.userInteractionEnabled = NO;
        self.lineOneView.backgroundColor = [UIColor greenColor];
        [self.lineOneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView.mas_right).offset(-80*KAdaptiveRateWidth);
            make.width.mas_equalTo(1);
            make.top.equalTo(bgView.mas_top);
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        
        self.imageV = [[UIImageView alloc]init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageV];
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = 5;
        self.imageV.userInteractionEnabled = NO;
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(13*KAdaptiveRateWidth);
            make.centerY.equalTo(bgView.mas_centerY);
            make.width.mas_equalTo(self.frame.size.height-15*KAdaptiveRateWidth);
            make.height.mas_equalTo(self.frame.size.height-15*KAdaptiveRateWidth);
        }];
        
        self.orderNameLB = [[UILabel alloc]init];
        [self addSubview:self.orderNameLB];
        self.orderNameLB.userInteractionEnabled = NO;
        self.orderNameLB.font = [UIFont systemFontOfSize:14];
        [self.orderNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(10*KAdaptiveRateWidth);
            make.centerY.equalTo(bgThreeView.mas_centerY).offset(-8*KAdaptiveRateWidth);
            make.height.mas_equalTo(14);
        }];
        
        self.orderIdLB = [[UILabel alloc]init];
        [self addSubview:self.orderIdLB];
        self.orderIdLB.userInteractionEnabled = NO;
        self.orderIdLB.font = [UIFont systemFontOfSize:13];
        self.orderIdLB.textColor = GRAY120;
        [self.orderIdLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(10*KAdaptiveRateWidth);
            make.centerY.equalTo(bgThreeView.mas_centerY).offset(10*KAdaptiveRateWidth);
            make.height.mas_equalTo(13);
        }];
        
        
        self.stateLB = [[UILabel alloc]init];
        [self addSubview:self.stateLB];
        self.stateLB.userInteractionEnabled = NO;
        self.stateLB.textAlignment = NSTextAlignmentCenter;
        self.stateLB.font = [UIFont systemFontOfSize:14];
        [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lineOneView.mas_left);
            make.right.equalTo(bgView.mas_right).offset(-8*KAdaptiveRateWidth);
            make.centerY.equalTo(bgThreeView.mas_centerY);
            make.height.mas_equalTo(self.frame.size.height);
        }];
        
        
    }
    return self;
}

@end
