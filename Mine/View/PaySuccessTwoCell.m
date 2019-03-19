//
//  PaySuccessTwoCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "PaySuccessTwoCell.h"

@implementation PaySuccessTwoCell

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
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    //    make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(60);
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
