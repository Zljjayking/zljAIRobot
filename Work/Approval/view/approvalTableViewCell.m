//
//  approvalTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalTableViewCell.h"

@implementation approvalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.headImage = [[UIImageView alloc] init];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 25;
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    
    self.nameLb = [[UILabel alloc] init];
    [self addSubview:self.nameLb];
    self.nameLb.textColor = GRAY100;
    self.nameLb.font = [UIFont systemFontOfSize:17];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_top).offset(2);
        make.left.equalTo(self.headImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(18);
    }];
    
    self.deptNameLb = [[UILabel alloc] init];
    [self addSubview:self.deptNameLb];
    self.deptNameLb.textColor = GRAY150;
    self.deptNameLb.font = [UIFont systemFontOfSize:15];
    [self.deptNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_top).offset(2);
        make.left.equalTo(self.nameLb.mas_right).offset(3*KAdaptiveRateWidth);
        make.height.mas_equalTo(18);
    }];
    
    self.timeLb = [[UILabel alloc] init];
    [self addSubview:self.timeLb];
    self.timeLb.textColor = GRAY150;
    self.timeLb.font = [UIFont systemFontOfSize:12];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_top).offset(2);
        make.right.equalTo(self.mas_right).offset(-6*KAdaptiveRateWidth);
        make.height.mas_equalTo(18);
    }];
    
    self.typeLb = [[UILabel alloc] init];
    [self addSubview:self.typeLb];
    self.typeLb.font = [UIFont systemFontOfSize:17];
    [self.typeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImage.mas_bottom).offset(0);
        make.left.equalTo(self.headImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(18);
    }];
    
    self.stateLb = [[UILabel alloc] init];
    [self addSubview:self.stateLb];
    self.stateLb.textColor = kMyColor(47, 137, 201);
    self.stateLb.font = [UIFont systemFontOfSize:17];
    [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLb.mas_bottom).offset(10);
        make.left.equalTo(self.headImage.mas_right).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(18);
    }];
    

    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
