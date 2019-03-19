//
//  FunctionNameTwoTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "FunctionNameTwoTableViewCell.h"

@implementation FunctionNameTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView {
    
    self.DaGou = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
    [self addSubview:self.DaGou];
    [self.DaGou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(22);
    }];
    
    self.nameLB = [[UILabel alloc]init];
    self.nameLB.tintColor = TABBAR_BASE_COLOR;
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.DaGou.mas_right).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    UIView *seperator = [[UIView alloc]init];
    [self addSubview:seperator];
    seperator.backgroundColor = GRAY240;
    [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(65);
        make.top.equalTo(self.mas_bottom).offset(-0.4);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
