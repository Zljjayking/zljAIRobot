//
//  MineTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/13.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MineTableViewCell.h"

@implementation MineTableViewCell
static NSString *identifier = @"cell";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellWithTableView:(UITableView *)tableView {
    
    // 1.缓存中取
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[MineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    
    self.InfoImage = [[UIImageView alloc]init];
    [self addSubview:self.InfoImage];
    self.InfoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.InfoImage.layer.masksToBounds = YES;
    [self.InfoImage.layer setCornerRadius:5*KAdaptiveRateWidth];    
    [self.InfoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(26*KAdaptiveRateWidth);
        make.height.mas_equalTo(26*KAdaptiveRateWidth);
    }];
    
    self.InfoLB = [[UILabel alloc] init];
    [self addSubview:self.InfoLB];
    self.InfoLB.font = [UIFont systemFontOfSize:16];
    [self.InfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.InfoImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17*KAdaptiveRateWidth);
    }];
    
    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:sword];
    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
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
