//
//  ExecuOneCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExecuOneCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExecuOneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.execuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.execuBtn.backgroundColor = VIEW_BASE_COLOR;
    [self.execuBtn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    self.execuBtn.layer.cornerRadius = 5.0;
    self.execuBtn.layer.masksToBounds = YES;
    
    [self.execuBtn.layer setBorderWidth:0.5];
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){125/255.0,125/255.0,125/255.0,1});
    [self.execuBtn.layer setBorderColor:color];


    [self addSubview:self.execuBtn];
    
    [self.execuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(40);
        
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
