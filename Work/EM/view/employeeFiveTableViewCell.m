//
//  employeeFiveTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/26.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeFiveTableViewCell.h"

@implementation employeeFiveTableViewCell

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
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.textColor = GRAY90;
    self.nameLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    self.textField = [[UITextView alloc] init];
    self.textField.textColor = GRAY70;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(55);
        make.left.equalTo(self.nameLB.mas_right);
    }];
    
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.textColor = GRAY150;
    self.placeholderLabel.alpha = 0.6;
    self.placeholderLabel.font = [UIFont systemFontOfSize:16];
    self.placeholderLabel.enabled = NO;
    [self addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.textField.mas_right).offset(-1);
        make.top.equalTo(self.textField.mas_top).offset(0);
        make.bottom.equalTo(self.textField.mas_bottom).offset(0);
    }];
    
    
    
    /**
     
     self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"清除输入内容"] forState:UIControlStateNormal];
     [self addSubview:self.deleteBtn];
     [self mas_makeConstraints:^(MASConstraintMaker *make) {
     make.right.equalTo(self.placeholderLabel.mas_right).offset(-5);
     make.top.equalTo(self.textField.mas_top).offset(0);
     make.height.mas_equalTo(5);
     make.width.mas_equalTo(5);
     }];
     
     */
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
