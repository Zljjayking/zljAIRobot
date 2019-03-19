//
//  completionStatusTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/3.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "completionStatusTableViewCell.h"

@implementation completionStatusTableViewCell

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
    self.topSeparatoerLine = [[UIView alloc] init];
    self.topSeparatoerLine.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:self.topSeparatoerLine];
    [self.topSeparatoerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    self.bottomSeparatoerLine = [[UIView alloc] init];
    self.bottomSeparatoerLine.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:self.bottomSeparatoerLine];
    [self.bottomSeparatoerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    self.leftSeparatoerLine = [[UIView alloc] init];
    self.leftSeparatoerLine.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:self.leftSeparatoerLine];
    [self.leftSeparatoerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(kScreenWidth/3.0);
        
        make.width.mas_equalTo(1);
    }];
    
    self.rightSeparatoerLine = [[UIView alloc] init];
    self.rightSeparatoerLine.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:self.rightSeparatoerLine];
    [self.rightSeparatoerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(2*kScreenWidth/3.0);
        
        make.width.mas_equalTo(1);
    }];
    
    self.nameLb = [[UILabel alloc] init];
    self.nameLb.font = [UIFont systemFontOfSize:15];
    self.nameLb.textColor = [UIColor grayColor];
    self.nameLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3.0);
    }];
    
    self.statusLb = [[UILabel alloc] init];
    self.statusLb.font = [UIFont systemFontOfSize:15];
//    self.statusLb.textColor = [UIColor grayColor];
//    [self.statusLb setTextColor:[UIColor redColor]];
    self.statusLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.statusLb];
    [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb.mas_right).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3.0);
    }];

//    self.statusLb1 = [[UILabel alloc] init];
//    self.statusLb1.font = [UIFont systemFontOfSize:15];
//    //    self.statusLb.textColor = [UIColor grayColor];
//    [self.statusLb1 setTextColor:[UIColor grayColor]];
//    self.statusLb1.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.statusLb1];
//    [self.statusLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLb.mas_right).offset(0);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.width.mas_equalTo(kScreenWidth/3.0);
//    }];
    
    self.countLb = [[UILabel alloc] init];
    self.countLb.font = [UIFont systemFontOfSize:15];
    self.countLb.textColor = [UIColor grayColor];
    self.countLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countLb];
    [self.countLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLb.mas_right).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenWidth/3.0);
    }];
    
    self.titleLb = [[UILabel alloc] init];
    self.titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLb.textColor = [UIColor grayColor];
    [self addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenWidth-20);
    }];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
