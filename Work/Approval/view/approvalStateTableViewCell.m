//
//  approvalStateTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalStateTableViewCell.h"

@implementation approvalStateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    
    self.stateV = [[UIView alloc]init];
    self.stateV.layer.cornerRadius = 10;
    [self addSubview:self.stateV];
    self.stateV.backgroundColor = [UIColor whiteColor];
    [self.stateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(5);
        make.left.equalTo(self.mas_left).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    self.stateLB = [[UILabel alloc]init];
    self.stateLB.font = [UIFont systemFontOfSize:13];
    self.stateLB.textColor = [UIColor whiteColor];
    self.stateLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.stateLB];
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(5);
        make.left.equalTo(self.mas_left).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    [self addSubview:self.titleLB];
    self.titleLB.font = [UIFont systemFontOfSize:15];
    self.titleLB.textAlignment = NSTextAlignmentRight;
    self.titleLB.textColor = GRAY110;
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(self.mas_centerY).offset(5);
        make.left.equalTo(self.stateV.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];

    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
