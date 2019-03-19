//
//  MineHeadImageTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MineHeadImageTableViewCell.h"

@implementation MineHeadImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
static NSString *identifier = @"touxiang";
- (instancetype)cellWithTableView:(UITableView *)tableView {
    
    // 1.缓存中取
    MineHeadImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MineHeadImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    self.InfoLB = [[UILabel alloc] init];
    [self addSubview:self.InfoLB];
    self.InfoLB.textColor = GRAY120;
    self.InfoLB.font = [UIFont systemFontOfSize:17];
    [self.InfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:sword];
    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(8);
    }];
    
    self.InfoImage = [[UIImageView alloc]init];
    [self addSubview:self.InfoImage];
    self.InfoImage.layer.masksToBounds = YES;
    [self.InfoImage.layer setCornerRadius:5*KAdaptiveRateWidth];
    [self.InfoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(sword.mas_left).offset(-16);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
