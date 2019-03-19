//
//  EditNameTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/26.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditNameTableViewCell.h"

@implementation EditNameTableViewCell

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
    self.TypeLb = [[UILabel alloc]init];
    self.TypeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.TypeLb];
    self.TypeLb.textColor = [UIColor grayColor];
    [self.TypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        //        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateHeight);
        make.height.mas_equalTo(17*KAdaptiveRateHeight);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    self.NameTF = [[UITextField alloc]init];
    self.NameTF.font = [UIFont systemFontOfSize:16];
    self.NameTF.delegate = self;
    self.NameTF.returnKeyType = UIReturnKeyDone;

    [self addSubview:self.NameTF];
    [self.NameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.TypeLb.mas_right).offset(12*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12*KAdaptiveRateHeight);
        //        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateHeight);
//        make.width.mas_equalTo(kScreenWidth - 24*KAdaptiveRateWidth);
        make.height.mas_equalTo(40*KAdaptiveRateHeight);
    }];
    self.separetor = [[UIView alloc] init];
    self.separetor.backgroundColor = GRAY229;
    [self addSubview:self.separetor];
    [self.separetor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"按下return");
//    [UIView animateWithDuration:0.3 animations:^{
//        self.ChuangJianHuoDong.frame = CGRectMake(0.0f,kScreenHeight-400.5*self.MyDelegate.autoSizeScaleY , kScreenWidth, 400.5*self.MyDelegate.autoSizeScaleY);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
