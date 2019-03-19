//
//  paySetOneTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySetOneTableViewCell.h"

@implementation paySetOneTableViewCell

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
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-19*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.text = @"件";
    //self.nameLB.textColor = GRAY90;
    [self addSubview:self.nameLB];
    self.nameLB.font = [UIFont systemFontOfSize:16];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    self.unitLB = [[UILabel alloc] init];
    self.unitLB.text = @"元/件";
    self.unitLB.textColor = GRAY120;
    [self addSubview:self.unitLB];
    self.unitLB.font = [UIFont systemFontOfSize:14];
    [self.unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    self.salaryLB = [[UILabel alloc]init];
    self.salaryLB.numberOfLines = 0;
    self.salaryLB.text = @"基础提成方案";
    self.salaryLB.textColor = GRAY138;
    self.salaryLB.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.salaryLB];
    [self.salaryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40*KAdaptiveRateWidth);
        make.top.equalTo(self.nameLB.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-90*KAdaptiveRateWidth);
        
    }];
    
    self.salaryTF = [[UITextField alloc] init];
    self.salaryTF.placeholder = @"输入金额";
    self.salaryTF.textColor = GRAY70;
    self.salaryTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.salaryTF.textAlignment = NSTextAlignmentRight;
    self.salaryTF.font = [UIFont systemFontOfSize:14];
    [self.salaryTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.salaryTF];
    [self.salaryTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
        make.centerY.equalTo(self.salaryLB.mas_centerY);
        //make.bottom.equalTo(self.salaryLB.mas_bottom);
        //make.left.equalTo(self.nameLB.mas_right).offset(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 8) {
        textField.text = [textField.text substringToIndex:8];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
