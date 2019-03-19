//
//  RemoveTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "RemoveTableViewCell.h"

@implementation RemoveTableViewCell

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
-(void)setupView {
    
    self.backgroundColor = VIEW_BASE_COLOR;
    self.removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.removeBtn setTitle:self.titleStr forState:UIControlStateNormal];
    [self.removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.removeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.removeBtn addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.removeBtn setBackgroundImage:[UIImage imageWithColor:customBlueColor] forState:UIControlStateNormal];
    [self.removeBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    self.removeBtn.layer.masksToBounds = YES;
    self.removeBtn.layer.cornerRadius = 5;
    [self addSubview:self.removeBtn];
    [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}
- (void)remove:(UIButton *)sender {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
