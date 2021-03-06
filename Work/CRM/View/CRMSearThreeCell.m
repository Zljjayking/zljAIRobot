//
//  CRMSearThreeCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/11.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMSearThreeCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CRMSearThreeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView{
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.leftLabel];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(5);
        // make.centerY.mas_equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top).offset(4);
        make.bottom.equalTo(self.mas_bottom).offset(-4);
        make.width.mas_equalTo(85);
        
    }];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightBtn.layer.borderWidth = 0.42f;
    self.rightBtn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftLabel.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-45);
        // make.centerY.mas_equalTo(self.mas_centerY);
        // make.height.mas_equalTo(24);
        make.top.equalTo(self.mas_top).offset(4);
        make.bottom.equalTo(self.mas_bottom).offset(-4);

        
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
