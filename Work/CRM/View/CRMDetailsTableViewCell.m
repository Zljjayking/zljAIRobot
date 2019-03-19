//
//  CRMDetailsTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMDetailsTableViewCell.h"

@implementation CRMDetailsTableViewCell

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
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.textColor = [UIColor grayColor];
    self.titleLB.font = [UIFont systemFontOfSize:17];
    
    [self addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    self.contentTF = [[UITextField alloc] init];
    self.contentTF.font = [UIFont systemFontOfSize:17];
    self.contentTF.textColor = GRAY90;
    [self addSubview:self.contentTF];
    [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB.mas_right).offset(10*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    
    self.arrowView = [[UIImageView alloc] init];
    self.arrowView.image = [UIImage imageNamed:@"箭头（下）"];
    [self addSubview:self.arrowView];

    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(8);
        make.width.mas_equalTo(13);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
