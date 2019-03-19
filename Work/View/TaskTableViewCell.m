//
//  TaskTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

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
    self.headImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.headImage];
    self.headImage.layer.masksToBounds = YES;
    [self.headImage.layer setCornerRadius:5];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(40*KAdaptiveRateHeight);
        make.width.mas_equalTo(40*KAdaptiveRateHeight);
    }];
    self.NameLb = [[UILabel alloc] init];
    [self addSubview:self.NameLb];
    self.NameLb.font = [UIFont systemFontOfSize:17];
    [self.NameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        make.height.mas_equalTo(17);
    }];
    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:sword];
    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(10);
    }];
    
    self.SignLb = [[UILabel alloc] init];
    [self addSubview:self.SignLb];
    self.SignLb.font = [UIFont systemFontOfSize:14];
    self.SignLb.textColor = MYGRAY;
    [self.SignLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY).offset(15);
        make.right.equalTo(sword.mas_left).offset(-2);
        make.height.mas_equalTo(15);
    }];
    
    self.TimeLb = [[UILabel alloc]init];
    self.TimeLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.TimeLb];
    self.TimeLb.textColor = MYGRAY;
    [self.TimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sword.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(14);
    }];
    
    UIView *separator = [[UIView alloc]init];
    separator.backgroundColor = GRAY229;
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.2);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
