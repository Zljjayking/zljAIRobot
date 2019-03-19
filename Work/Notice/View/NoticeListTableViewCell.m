//
//  NoticeListTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "NoticeListTableViewCell.h"

@implementation NoticeListTableViewCell

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
    
    self.NameLb = [[UILabel alloc] init];
    self.NameLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.NameLb];
    [self.NameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(220*KAdaptiveRateWidth);
        make.centerY.equalTo(self.mas_centerY).offset(-12);
        make.height.mas_equalTo(19);
    }];
    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:sword];
    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateHeight);
        make.width.mas_equalTo(10*KAdaptiveRateWidth);
    }];
    
    self.SignLb = [[UILabel alloc] init];
    [self addSubview:self.SignLb];
    self.SignLb.font = [UIFont systemFontOfSize:15];
    self.SignLb.textColor = MYGRAY;
    [self.SignLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY).offset(12);
        make.width.mas_equalTo(200*KAdaptiveRateWidth);
        make.height.mas_equalTo(15*KAdaptiveRateWidth);
    }];
    
    self.TimeLb = [[UILabel alloc]init];
    self.TimeLb.font = [UIFont systemFontOfSize:14];
    self.TimeLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.TimeLb];
    self.TimeLb.textColor = MYGRAY;
    [self.TimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sword.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(15*KAdaptiveRateWidth);
//        make.width.mas_equalTo(60);
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
