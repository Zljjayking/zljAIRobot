//
//  paySetTitleTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySetTitleTableViewCell.h"

@implementation paySetTitleTableViewCell

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
    
    self.hehe = [[UIView alloc] init];
    self.hehe.backgroundColor = kMyColor(44, 244, 243);
    [self addSubview:self.hehe];
    [self.hehe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0*KAdaptiveRateWidth);
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.width.mas_equalTo(5*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
    
    self.heheLB = [[UILabel alloc]init];
    [self addSubview:self.heheLB];
    self.heheLB.text = @"基础设置";
    self.heheLB.textColor = GRAY138;
    self.heheLB.font = [UIFont systemFontOfSize:14];
    [self.heheLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hehe.mas_centerY);
        make.left.equalTo(self.hehe.mas_right).offset(5*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
