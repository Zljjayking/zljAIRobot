//
//  signInChangeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "signInChangeTableViewCell.h"

@implementation signInChangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = VIEW_BASE_COLOR;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    UIView *bgview = [[UIView alloc]init];
    [self addSubview:bgview];
    bgview.backgroundColor = [UIColor whiteColor];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-7*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.changeBtn];
    self.changeBtn.layer.masksToBounds = YES;
    self.changeBtn.layer.cornerRadius = 7;
    [self.changeBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [self.changeBtn setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.centerY.equalTo(self.mas_centerY).offset(6);
        make.width.mas_equalTo(kScreenWidth-80);
        make.height.mas_equalTo(45);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
