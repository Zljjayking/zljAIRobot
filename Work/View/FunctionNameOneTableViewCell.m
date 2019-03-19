//
//  FunctionNameOneTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "FunctionNameOneTableViewCell.h"

@implementation FunctionNameOneTableViewCell

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
    
    self.arrow = [[UIImageView alloc]init];
    if (self.isAdd) {
        self.arrow.image = [UIImage imageNamed:@"箭头（上）"];
    } else {
        self.arrow.image = [UIImage imageNamed:@"箭头（下）"];
    }
    [self addSubview:self.arrow];
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(15);
    }];
    
    self.DaGou = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
    [self.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
//    [self.DaGou addTarget:self action:@selector(DaGou:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.DaGou];
    [self.DaGou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.arrow.mas_right).offset(15);
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
        make.left.equalTo(self.mas_left).offset(50);
        make.top.equalTo(self.mas_bottom).offset(-0.4);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}
//- (void)DaGou:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    NSLog(@"qqqqqqqqqqqqq");
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
