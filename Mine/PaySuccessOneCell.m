//
//  PaySuccessOneCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "PaySuccessOneCell.h"

@implementation PaySuccessOneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    
    return self;
}

-(void)setView{
    
    self.leftImageView = [[UIImageView alloc]init];
    [self addSubview:self.leftImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        
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
