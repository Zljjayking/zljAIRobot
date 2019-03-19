//
//  EditTypeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/26.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditTypeTableViewCell.h"

@implementation EditTypeTableViewCell

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
    self.TypeLb = [[UILabel alloc]init];
    self.TypeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.TypeLb];
    self.TypeLb.textColor = [UIColor grayColor];
    [self.TypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
//        make.right.equalTo(self.TypeNameLb.mas_left).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17*KAdaptiveRateHeight);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    self.TypeNameLb = [[UILabel alloc]init];
    [self addSubview:self.TypeNameLb];
    self.TypeNameLb.font = [UIFont systemFontOfSize:16];
    self.TypeNameLb.numberOfLines = 2;
    self.TypeNameLb.textAlignment = NSTextAlignmentLeft;
    [self.TypeNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.TypeLb.mas_right).offset(12*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-20*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        
        make.height.mas_equalTo(30*KAdaptiveRateHeight);
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
