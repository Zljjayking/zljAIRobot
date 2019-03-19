//
//  FunctionTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "FunctionTableViewCell.h"

@implementation FunctionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView {
    
    self.DaGou = [[UIImageView alloc]init];
    [self addSubview:self.DaGou];
    [self.DaGou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    self.nameLB = [[UILabel alloc]init];
    self.nameLB.text = @"全选";
    self.nameLB.font = [UIFont systemFontOfSize:14];
    self.nameLB.tintColor = TABBAR_BASE_COLOR;
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.DaGou.mas_right).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
