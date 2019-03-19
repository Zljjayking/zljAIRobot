//
//  DeptChooseCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "DeptChooseCell.h"

@implementation DeptChooseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView{
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(25);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(20);
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
