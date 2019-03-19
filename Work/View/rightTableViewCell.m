//
//  rightTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "rightTableViewCell.h"

@implementation rightTableViewCell
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
    
    self.rightNameLB = [[UILabel alloc] init];
//    self.rightNameLB.font = [UIFont systemFontOfSize:15];
    
    [self addSubview:self.rightNameLB];
    self.rightNameLB.font = [UIFont systemFontOfSize:17];
    [self.rightNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17*KAdaptiveRateHeight);
    }];
    
//    UIImageView *sword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
//    [self addSubview:sword];
//    [sword mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
//        make.height.mas_equalTo(14*KAdaptiveRateWidth);
//        make.width.mas_equalTo(10*KAdaptiveRateWidth);
//    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
