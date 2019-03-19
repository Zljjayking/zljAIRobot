//
//  ApplyInfoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ApplyInfoCell.h"

@implementation ApplyInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    
    
    self.applyInfoLabel = [[UILabel alloc]init];
    self.applyInfoLabel.textColor = MYGRAY;
    self.applyInfoLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.applyInfoLabel];
    [self.applyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(18);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(15);
        
    }];
    
    self.applyInfoTextView = [[UITextView alloc]init];
    
    self.applyInfoTextView.font = [UIFont systemFontOfSize:15];
    self.applyInfoTextView.tintColor = TABBAR_BASE_COLOR;
    [self addSubview:self.applyInfoTextView];
    [self.applyInfoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.applyInfoLabel.mas_right).offset(8);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.mas_bottom).offset(-10);

    }];
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.textColor = GRAY160;
    self.placeholderLabel.alpha = 0.6;
    self.placeholderLabel.font = [UIFont systemFontOfSize:15];
    self.placeholderLabel.enabled = NO;
    [self.applyInfoTextView addSubview:self.placeholderLabel];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.applyInfoTextView.mas_left).offset(5);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo(150);
        
    }];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"清除输入内容"] forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    
    
    UIView *separator = [[UIView alloc]init];
    separator.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.4);
        make.height.mas_equalTo(0.4);
    }];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
