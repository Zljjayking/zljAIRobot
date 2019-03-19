//
//  ExecuTwoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExecuTwoCell.h"

@implementation ExecuTwoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.leftLabel = [[UILabel alloc]init];
  //  self.leftLabel.backgroundColor = TABBAR_BASE_COLOR;
    self.leftLabel.text = @"日期:";
    self.leftLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset((kScreenWidth-280)/2.0);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(25);
        
    }];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.backgroundColor = VIEW_BASE_COLOR;
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    self.leftBtn.layer.borderWidth = 0.5f;
    self.leftBtn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftLabel.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(25);
        
        
    }];
    
    self.rightLabel = [[UILabel alloc]init];
  //  self.rightLabel.backgroundColor = TABBAR_BASE_COLOR;
    self.rightLabel.text = @"至";
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftBtn.mas_right).offset(2);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(25);
    }];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.backgroundColor = VIEW_BASE_COLOR;
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    self.rightBtn.layer.borderWidth = 0.5f;
    self.rightBtn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;

    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rightLabel.mas_right).offset(2);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(25);
        
    }];
    
    self.bottomLabel = [[UILabel alloc]init];
    self.bottomLabel.text = @"请先输入查询时间，再选择查询选项!";
    self.bottomLabel.textColor = [UIColor grayColor];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.leftBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(15);
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
