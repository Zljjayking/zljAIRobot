//
//  proOneTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/7/26.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "proOneTableViewCell.h"

@implementation proOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
- (void)initView {
    
    UIImageView *imageBG = [[UIImageView alloc]init];
    imageBG.image = [UIImage imageNamed:@"proBGV"];
    [self addSubview:imageBG];
    [imageBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(-5);
//        make.height.mas_equalTo(kScreenWidth*(312/772.0));
        make.height.mas_equalTo(170);
    }];
    
    self.mechProIcon = [[UIImageView alloc]init];
    [self addSubview:self.mechProIcon];
    self.mechProIcon.layer.masksToBounds = YES;
    [self.mechProIcon.layer setCornerRadius:6.5];
    [self.mechProIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(20+17*KAdaptiveRateWidth);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    self.mechProNameLB = [[UILabel alloc]init];
    [self addSubview:self.mechProNameLB];
    self.mechProNameLB.textColor = GRAY50;
    self.mechProNameLB.font = [UIFont systemFontOfSize:16];
    [self.mechProNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mechProIcon.mas_centerY);
        make.left.equalTo(self.mechProIcon.mas_right).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(16);
    }];
    
    self.signImageView = [[UIImageView alloc]init];
    [self addSubview:self.signImageView];
    self.signImageView.hidden = YES;
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *RateLB = [[UILabel alloc]init];
    [self addSubview:RateLB];
    RateLB.font = [UIFont systemFontOfSize:12];
    RateLB.text = @"月利率：";
    RateLB.textColor = MYGRAY;
    [RateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-10-17*KAdaptiveRateWidth);
        make.height.mas_equalTo(12);
    }];
    
    self.tabInterestRateLB = [[UILabel alloc]init];
    [self addSubview:self.tabInterestRateLB];
    self.tabInterestRateLB.font = [UIFont systemFontOfSize:34];
    self.tabInterestRateLB.textColor = kMyColor(140, 215, 206);
    [self.tabInterestRateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(RateLB.mas_right).offset(0*KAdaptiveRateWidth);
        make.bottom.equalTo(RateLB.mas_bottom).offset(4);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *persantLB = [[UILabel alloc]init];
    [self addSubview:persantLB];
    persantLB.font = [UIFont systemFontOfSize:12];
    persantLB.text = @"%";
    persantLB.textColor = MYGRAY;
    [persantLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabInterestRateLB.mas_right).offset(5*KAdaptiveRateWidth);
        make.bottom.equalTo(RateLB.mas_bottom).offset(0);
        make.height.mas_equalTo(12);
    }];
    
    self.mechProTypeLB = [[UILabel alloc]init];
    [self addSubview:self.mechProTypeLB];
    self.mechProTypeLB.font = [UIFont systemFontOfSize:10];
    self.mechProTypeLB.textColor = customBlue;
    [self.mechProTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-150);
        make.bottom.equalTo(RateLB.mas_bottom).offset(-45);
        make.height.mas_equalTo(10);
    }];
    
    self.dayLB = [[UILabel alloc]init];
    [self addSubview:self.dayLB];
    self.dayLB.font = [UIFont systemFontOfSize:10];
    self.dayLB.textColor = MYGRAY;
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-150);
        make.top.equalTo(self.mechProTypeLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *dLB = [[UILabel alloc]init];
    [self addSubview:dLB];
    dLB.font = [UIFont systemFontOfSize:10];
    dLB.text = @"（天）";
    dLB.textColor = GRAY180;
    [dLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLB.mas_right).offset(0*KAdaptiveRateWidth);
        make.top.equalTo(self.mechProTypeLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    self.cashLB = [[UILabel alloc]init];
    [self addSubview:self.cashLB];
    self.cashLB.font = [UIFont systemFontOfSize:10];
    self.cashLB.textColor = MYGRAY;
    [self.cashLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-150);
        make.top.equalTo(self.dayLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *cLB = [[UILabel alloc]init];
    [self addSubview:cLB];
    cLB.font = [UIFont systemFontOfSize:10];
    cLB.text = @"（万元）";
    cLB.textColor = GRAY180;
    [cLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cashLB.mas_right).offset(0*KAdaptiveRateWidth);
        make.top.equalTo(self.dayLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    self.methodLB = [[UILabel alloc]init];
    [self addSubview:self.methodLB];
    self.methodLB.font = [UIFont systemFontOfSize:11];
    self.methodLB.textColor = MYGRAY;
    [self.methodLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-150);
        make.top.equalTo(self.cashLB.mas_bottom).offset(5);
        make.height.mas_equalTo(11);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
