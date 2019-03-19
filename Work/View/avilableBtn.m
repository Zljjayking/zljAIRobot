//
//  avilableBtn.m
//  Financeteam
//
//  Created by Zccf on 16/5/23.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "avilableBtn.h"

@implementation avilableBtn
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self addSubview:self.deleteBtn];
        [self layoutIfNeeded];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.layer.masksToBounds = YES;
    [self.imageView.layer setCornerRadius:3];
//    self.imageView.frame = CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.width-4);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.left.equalTo(self.mas_left).offset(2);
        make.right.equalTo(self.mas_right).offset(-2);
        make.height.mas_equalTo(self.frame.size.width-4);
    }];
//    self.titleLabel.frame = CGRectMake(2, self.frame.size.width, self.frame.size.width-4, 20);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(3);
        make.left.equalTo(self.mas_left).offset(2);
        make.right.equalTo(self.mas_right).offset(-2);
        make.height.mas_equalTo(7);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
//    self.imageEdgeInsets =  UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
