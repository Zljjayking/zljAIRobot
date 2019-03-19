//
//  billTableViewCell.m
//  365ChengRongWang
//
//  Created by Zccf on 16/12/29.
//  Copyright © 2016年 Zccf. All rights reserved.
//

#import "billTableViewCell.h"

@implementation billTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //高为80
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.typeLB = [[UILabel alloc]init];
    self.typeLB.textColor = MYGRAY;
    self.typeLB.font = KFONT(18, 0.1);
    [self addSubview:self.typeLB];
    [self.typeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    
    self.moneyLB = [[UILabel alloc]init];
    self.moneyLB.font = KFONT(16, 0.1);
    [self addSubview:self.moneyLB];
    [self.moneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.timeLB = [[UILabel alloc]init];
    self.timeLB.textColor = GRAY160;
    self.timeLB.font = KFONT(15, 0.1);
    [self addSubview:self.timeLB];
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.moneyLB.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    UIView *seperator = [[UIView alloc]init];
    [self addSubview:seperator];
    seperator.backgroundColor = GRAY240;
    [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_bottom).offset(-0.5);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.4);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
