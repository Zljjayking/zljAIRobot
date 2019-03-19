//
//  TouXiangTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "TouXiangTableViewCell.h"

@implementation TouXiangTableViewCell
static NSString *identifier = @"touxiang";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellWithTableView:(UITableView *)tableView {
    
    // 1.缓存中取
    TouXiangTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[TouXiangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    UIView *bgview = [[UIView alloc]init];
    [self addSubview:bgview];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(0);
        make.left.equalTo(self.mas_left).offset(-0);
        make.top.equalTo(self.mas_top).offset(-0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    UIImageView *bgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine-banner"]];
    [bgview addSubview:bgV];
    [bgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgview.mas_right).offset(2);
        make.left.equalTo(bgview.mas_left).offset(-2);
        make.top.equalTo(bgview.mas_top).offset(-2);
        make.bottom.equalTo(bgview.mas_bottom).offset(0);
    }];
    
    UIView *oo = [[UIView alloc]init];
    [self addSubview:oo];
    oo.backgroundColor = [UIColor whiteColor];
    [oo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgview.mas_right).offset(2);
        make.left.equalTo(bgview.mas_left).offset(-2);
        make.top.equalTo(bgview.mas_bottom).offset(-2);
        make.bottom.equalTo(bgview.mas_bottom).offset(0);
    }];
    
    self.InfoImage = [[UIImageView alloc]init];
    [self addSubview:self.InfoImage];
    self.InfoImage.layer.masksToBounds = YES;
    [self.InfoImage.layer setCornerRadius:30];
    [self.InfoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-10*KAdaptiveRateWidth);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    self.InfoLB = [[UILabel alloc] init];
    [self addSubview:self.InfoLB];
    self.InfoLB.font = [UIFont systemFontOfSize:17];
    self.InfoLB.textColor = GRAY50;
    [self.InfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.InfoImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.InfoImage.mas_centerY).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    self.mobileLB = [[UILabel alloc] init];
    [self addSubview:self.mobileLB];
    self.mobileLB.font = [UIFont systemFontOfSize:15];
    self.mobileLB.textColor = GRAY100;
    [self.mobileLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.InfoImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.InfoImage.mas_centerY).offset(15);
        make.height.mas_equalTo(20);
    }];

    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:sword];
    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.InfoImage.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(8);
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
