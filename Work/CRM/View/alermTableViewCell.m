//
//  alermTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/8/2.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "alermTableViewCell.h"

@implementation alermTableViewCell

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
- (void)setupView {
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.font = [UIFont systemFontOfSize:16];
    self.titleLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.titleLb];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLb = [[UILabel alloc] init];
    self.timeLb.font = [UIFont systemFontOfSize:14];
    self.timeLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLb];
    self.timeLb.textColor = [UIColor grayColor];
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLb1 = [[UILabel alloc] init];
    self.timeLb1.font = [UIFont systemFontOfSize:14];
    self.timeLb1.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLb1];
    self.timeLb1.textColor = [UIColor lightGrayColor];
    [self.timeLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
