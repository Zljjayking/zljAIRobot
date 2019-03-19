//
//  EditJoinPeopleTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/26.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditJoinPeopleTableViewCell.h"

@implementation EditJoinPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setupView];
    }
    return self;
}
- (void) setupView {
    self.TypeImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.TypeImage];
    self.TypeImage.frame = CGRectMake(0, 0, 25*KAdaptiveRateWidth, 25*KAdaptiveRateWidth);
    self.TypeImage.center = CGPointMake(27*KAdaptiveRateWidth, 25*KAdaptiveRateHeight);
    

    
    self.TypeNameLb = [[UILabel alloc] init];
    self.TypeNameLb.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.TypeNameLb];
    self.TypeNameLb.textColor = [UIColor grayColor];
    self.TypeNameLb.frame = CGRectMake(45*KAdaptiveRateWidth, 12.5*KAdaptiveRateHeight, 17*KAdaptiveRateHeight, 70*KAdaptiveRateWidth);
//    [self.TypeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.TypeImage.mas_right).offset(12*KAdaptiveRateWidth);
//        make.center.mas_equalTo(self.TypeImage.mas_centerY);
////        make.top.equalTo(self.mas_top).offset(10*KAdaptiveRateHeight);
//        make.height.mas_equalTo(17*KAdaptiveRateWidth);
//    }];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
