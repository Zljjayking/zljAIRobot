//
//  approvalHistoryTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalHistoryTableViewCell.h"

@implementation approvalHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = TABBAR_BASE_COLOR;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(25);
        make.width.mas_equalTo(2);
    }];
    
    self.stateImage = [[UIImageView alloc] init];
    [self addSubview:self.stateImage];
    [self.stateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.centerX.equalTo(lineView.mas_centerX);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    self.timeLB = [[UILabel alloc] init];
    [self addSubview:self.timeLB];
    self.timeLB.textColor = [UIColor whiteColor];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateImage.mas_centerY);
        make.left.equalTo(self.stateImage.mas_right).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 8;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
        make.left.equalTo(self.stateImage.mas_right).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    UIImageView *heheImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"approvalJiao"]];
    [self addSubview:heheImage];
//    heheImage.transform = CGAffineTransformMakeRotation(M_PI*0.05);
    [heheImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom).offset(10);
        make.left.equalTo(self.stateImage.mas_right).offset(3);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *peopleLB = [[UILabel alloc] init];
    [self addSubview:peopleLB];
    peopleLB.text = @"经办人";
    peopleLB.textColor = GRAY110;
    peopleLB.font = [UIFont systemFontOfSize:15];
    [peopleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.height.mas_equalTo(15);
    }];
    
    self.headerImage = [[UIImageView alloc] init];
    [self addSubview:self.headerImage];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 25;
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peopleLB.mas_bottom).offset(10);
        make.left.equalTo(peopleLB.mas_left).offset(12);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    self.nameLB = [[UILabel alloc] init];
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(20);
        make.centerY.equalTo(self.headerImage.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    self.signLB = [[UILabel alloc]init];
    self.signLB.numberOfLines = 0;
    [self addSubview:self.signLB];
    self.signLB.textColor = GRAY110;
    self.signLB.font = [UIFont systemFontOfSize:15];
    [self.signLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImage.mas_bottom).offset(10);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
    }];
    
    self.signImage = [[UIImageView alloc] init];
    [self addSubview:self.signImage];
    [self.signImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-20);
        make.width.mas_equalTo(79);
        make.height.mas_equalTo(64);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
