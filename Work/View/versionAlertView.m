//
//  versionAlertView.m
//  Financeteam
//
//  Created by Zccf on 2017/7/4.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "versionAlertView.h"

@implementation versionAlertView
- (instancetype)initWithFrame:(CGRect)frame version:(NSString *)version title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat Height = [title heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:280];
        UIView *bgV = [[UIView alloc]init];
        bgV.layer.masksToBounds = YES;
        bgV.layer.cornerRadius = 25;
        bgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgV];
        [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(100);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(Height+65+90);
        }];
        
        self.imageV = [[UIImageView alloc]init];
        [self addSubview:self.imageV];
        self.imageV.image = [UIImage imageNamed:@"newVersion"];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(0);
            make.width.mas_equalTo(280);
            make.height.mas_equalTo(185.5);
        }];
        
        
        
        self.versionLB = [[UILabel alloc]init];
        self.versionLB.font = [UIFont systemFontOfSize:13];
        self.versionLB.text = title;
        self.versionLB.numberOfLines = 0;
        self.versionLB.textColor = GRAY150;
        [bgV addSubview:self.versionLB];
        [self.versionLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageV.mas_bottom).offset(10);
            make.left.equalTo(bgV.mas_left).offset(10);
            make.right.equalTo(bgV.mas_right).offset(-10);
            make.height.mas_equalTo(Height);
        }];
        
        UILabel *numerLB = [[UILabel alloc]init];
        numerLB.textColor = [UIColor whiteColor];
        numerLB.font = [UIFont systemFontOfSize:12];
        numerLB.textAlignment = NSTextAlignmentCenter;
        numerLB.text = [NSString stringWithFormat:@"V%@",version];
        numerLB.backgroundColor = TABBAR_BASE_COLOR;
        [self.imageV addSubview:numerLB];
        [numerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageV.mas_right).offset(-15);
            make.bottom.equalTo(self.imageV.mas_bottom).offset(-0);
            make.height.mas_equalTo(18);
        }];
        numerLB.layer.masksToBounds = YES;
        numerLB.layer.cornerRadius = 9;
        [self layoutIfNeeded];
        CGFloat width = numerLB.frame.size.width+10;
        [numerLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [self layoutIfNeeded];
        
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgV addSubview:self.btn];
        [self.btn setBackgroundImage:[UIImage imageWithColor:GRAY110] forState:UIControlStateHighlighted];
        [self.btn setBackgroundImage:[UIImage imageWithColor:TABBAR_BASE_COLOR] forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btn setTitle:@"立即更新" forState:UIControlStateNormal];
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgV.mas_left).offset(10);
            make.right.equalTo(bgV.mas_right).offset(-10);
            make.bottom.equalTo(bgV.mas_bottom).offset(-10);
            make.height.mas_equalTo(40);
        }];
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.cornerRadius = 20;
        [self.btn addTarget:self action:@selector(updateImmediately) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)updateImmediately{
    self.block();
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
