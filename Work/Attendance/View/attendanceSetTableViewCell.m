//
//  attendanceSetTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/7.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceSetTableViewCell.h"

@implementation attendanceSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.titleLB = [[UILabel alloc]init];
    [self addSubview:self.titleLB];
    self.titleLB.font = [UIFont systemFontOfSize:17];
    self.titleLB.textColor = GRAY50;
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    self.signLB = [[UILabel alloc]init];
    [self addSubview:self.signLB];
    self.signLB.font = [UIFont systemFontOfSize:13];
    self.signLB.textColor = GRAY120;
    [self.signLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
