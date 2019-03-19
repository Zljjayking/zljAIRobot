//
//  CRMSearTwoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/10.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMSearTwoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CRMSearTwoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }return self;
}

-(void)setView{
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(24);
        
    }];
    
    self.leftTF = [[UITextField alloc]init];
    self.leftTF.borderStyle = UITextBorderStyleNone;
    self.leftTF.font = [UIFont systemFontOfSize:14];
    
    self.leftTF.layer.borderWidth = 0.42f;
    self.leftTF.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [self addSubview:self.leftTF];
    
    [self.leftTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(70);
    }];
    
    self.midLabel = [[UILabel alloc]init];
    self.midLabel.font = [UIFont systemFontOfSize:13];
    self.midLabel.textAlignment = NSTextAlignmentCenter;
 //   self.midLabel.backgroundColor = TABBAR_BASE_COLOR;
    [self addSubview:self.midLabel];
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftTF.mas_right).offset(2);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(40);
        
    }];
    
    self.rightTF = [[UITextField alloc]init];
    self.rightTF.borderStyle = UITextBorderStyleNone;
    self.rightTF.font = [UIFont systemFontOfSize:14];
    
    self.rightTF.layer.borderWidth = 0.42f;
    self.rightTF.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [self addSubview:self.rightTF];
    
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.midLabel.mas_right).offset(2);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(70);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.rightTF.mas_right).offset(2);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(40);
        
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
