//
//  EditPeopleAndTimeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditPeopleAndTimeTableViewCell.h"

@implementation EditPeopleAndTimeTableViewCell

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
- (void) setupView {
    self.TypeImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.TypeImage];
    self.TypeImage.frame = CGRectMake(0, 0, 22*KAdaptiveRateWidth, 22*KAdaptiveRateWidth);
    self.TypeImage.center = CGPointMake(27*KAdaptiveRateWidth, self.center.y);

    
    self.TypeNameLb = [[UILabel alloc] init];
    self.TypeNameLb.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.TypeNameLb];
    self.TypeNameLb.textColor = [UIColor grayColor];
    self.TypeNameLb.frame = CGRectMake(0, 52 * KAdaptiveRateWidth, 70*KAdaptiveRateWidth, 17*KAdaptiveRateWidth);
    self.TypeNameLb.center = CGPointMake(87*KAdaptiveRateWidth, self.center.y);
    
    self.contentLb = [[UILabel alloc]init];
    [self.contentView addSubview:self.contentLb];
    
    self.contentLb.textAlignment = NSTextAlignmentRight;
    self.contentLb.font = [UIFont systemFontOfSize:16];
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
//        make.top.equalTo(self.mas_top).offset(12*KAdaptiveRateHeight);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.TypeNameLb.mas_right).offset(10);
        make.height.mas_equalTo(20*KAdaptiveRateHeight);
    }];
    
    self.separetor = [[UIView alloc] init];
    self.separetor.backgroundColor = GRAY229;
    [self addSubview:self.separetor];
    [self.separetor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
