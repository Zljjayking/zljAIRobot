//
//  approvalTimeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalTimeTableViewCell.h"

@implementation approvalTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = kMyColor(249, 249, 249);
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    self.titleLB = [[UILabel alloc] init];
    [self addSubview:self.titleLB];
    self.titleLB.font = [UIFont systemFontOfSize:15];
    self.titleLB.textColor = GRAY140;
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    self.stateLB = [[UITextField alloc]init];
    self.stateLB.font = [UIFont systemFontOfSize:20];
    
    self.stateLB.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.stateLB];
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(20);
    }];
    
    self.star = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:self.star];
    [self.star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.left.equalTo(self.titleLB.mas_right).offset(5);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(8);
    }];
    
    UIView *seperator1 = [[UIView alloc]init];
    [self addSubview:seperator1];
    seperator1.backgroundColor = GRAY229;
    [seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(0.3);
        make.width.mas_equalTo(kScreenWidth);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
