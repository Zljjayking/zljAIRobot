//
//  MemberImageCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/19.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MemberImageCell.h"

@implementation MemberImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
    [self.leftBtn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    

    self.centerImage = [[UIImageView alloc]init];
    [self addSubview:self.centerImage];
    [self.centerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBtn.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerImage.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(50);
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
