//
//  MineInfoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MineInfoTableViewCell.h"

@implementation MineInfoTableViewCell

static NSString *identifier = @"cell";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellWithTableView:(UITableView *)tableView {
    
    // 1.缓存中取
    MineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MineInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        
    }
    return self;
}
- (void)setupView {

    
    self.InfoName = [[UILabel alloc] init];
    [self addSubview:self.InfoName];
    self.InfoName.textColor = GRAY120;
    self.InfoName.font = [UIFont systemFontOfSize:17];
    [self.InfoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    
    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:sword];
    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(8);
    }];
    
    self.InfoLB = [[UILabel alloc] init];
    [self addSubview:self.InfoLB];
    self.InfoLB.textColor = GRAY70;
    self.InfoLB.font = [UIFont systemFontOfSize:17];
    [self.InfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(sword.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
    }];

    UIView *separatorLine_bottom = [[UIView alloc]init];
    [self addSubview:separatorLine_bottom];
    separatorLine_bottom.backgroundColor = VIEW_BASE_COLOR;
    [separatorLine_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
