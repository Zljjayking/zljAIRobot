//
//  employeeOneTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeeOneTableViewCell.h"

@implementation employeeOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    [self.nameLB removeFromSuperview];
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.textColor = GRAY90;
    self.nameLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    [self.textField removeFromSuperview];
    
    self.textField = [[UITextField alloc] init];
    self.textField.enabled = YES;
    self.textField.textColor = GRAY70;
    self.textField.delegate = self;
    self.textField.placeholder = @"请填写";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(44);
        make.left.equalTo(self.nameLB.mas_right);
    }];
    
    [self.starImage removeFromSuperview];
    self.starImage = [[UIImageView alloc] init];
    self.starImage.image = [UIImage imageNamed:@"星号"];
    [self addSubview:self.starImage];
    [self.starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(5);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
