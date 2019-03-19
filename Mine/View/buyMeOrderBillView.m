//
//  buyMeOrderBillView.m
//  Financeteam
//
//  Created by Zccf on 2017/8/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeOrderBillView.h"
@interface buyMeOrderBillView ()<UITextFieldDelegate,UITextViewDelegate>

{
    UIButton * _surePayBtn;
}
@property (nonatomic, strong) UIView *alertView;
@end
@implementation buyMeOrderBillView
- (instancetype)initWithFrame:(CGRect)frame ID:(NSString *)ID type:(NSInteger)type{
    if (self = [super initWithFrame:frame]) {
        self.ID = ID;
        if (type == 0) {
            [self setupView];
        } else {
            
        }
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *receiverLB = [[UILabel alloc] init];
    receiverLB.text = @"发票抬头";
    receiverLB.font = [UIFont systemFontOfSize:15];
    receiverLB.textColor = GRAY160;
    [self addSubview:receiverLB];
    [receiverLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.mas_top).offset(15);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *starOne = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:starOne];
    [starOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(receiverLB.mas_left).offset(-2.5);
        make.centerY.equalTo(receiverLB.mas_centerY);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(7);
    }];
    
    self.titleTF = [[UITextField alloc]init];
    [self addSubview:self.titleTF];
    self.titleTF.placeholder = @"请填写企业名称";
    self.titleTF.delegate = self;
    self.titleTF.textAlignment = NSTextAlignmentRight;
    self.titleTF.tag = 1;
    self.titleTF.font = [UIFont systemFontOfSize:15];
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiverLB.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(receiverLB.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *receiverMobileLB = [[UILabel alloc] init];
    receiverMobileLB.text = @"税号";
    receiverMobileLB.font = [UIFont systemFontOfSize:15];
    receiverMobileLB.textColor = GRAY160;
    [self addSubview:receiverMobileLB];
    [receiverMobileLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.titleTF.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(85);
    }];
    
    UIImageView *starTwo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:starTwo];
    [starTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(receiverMobileLB.mas_left).offset(-2.5);
        make.centerY.equalTo(receiverMobileLB.mas_centerY);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(7);
    }];
    
    self.TaxNumberTF = [[UITextField alloc]init];
    [self addSubview:self.TaxNumberTF];
    self.TaxNumberTF.delegate = self;
    self.TaxNumberTF.tag = 2;
    self.TaxNumberTF.keyboardType = UIKeyboardTypePhonePad;
    self.TaxNumberTF.placeholder = @"请填写企业税号";
    self.TaxNumberTF.textAlignment = NSTextAlignmentRight;
    self.TaxNumberTF.font = [UIFont systemFontOfSize:15];
    [self.TaxNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiverMobileLB.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(receiverMobileLB.mas_centerY);
        make.height.mas_equalTo(30);
    }];

    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor = customBackColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHid)];
    [_bgView addGestureRecognizer:tap];
    
    UILabel *two = [[UILabel alloc] init];
    NSString * signText = @"开票须知：\n应国家税务局要求，自2017年7月1日起，开具增值税普通发票，须同时提供企业抬头及税号";
    two.text = signText;
    two.textColor = GRAY200;
    two.numberOfLines = 0;
    two.font = [UIFont systemFontOfSize:10];
    [self addSubview:two];
    [two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(self.mas_left).offset(30*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-30*KAdaptiveRateWidth);
    }];
    
    _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_surePayBtn];
    [_surePayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(two.mas_top).offset(-10);
        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-20*KAdaptiveRateWidth);
        make.height.mas_equalTo(40);
    }];
    [_surePayBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_surePayBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_surePayBtn setBackgroundColor:MYORANGE];
    //    [_surePayBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [_surePayBtn setBackgroundImage:[UIImage imageWithColor:MYSELECTEDORANGE] forState:UIControlStateHighlighted];
    [_surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _surePayBtn.layer.cornerRadius = 5;
    _surePayBtn.layer.masksToBounds = YES;
    [_surePayBtn addTarget:self action:@selector(sureSubmitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.height = [signText heightWithFont:[UIFont systemFontOfSize:10] constrainedToWidth:kScreenWidth-40*KAdaptiveRateWidth] + 20 + 40 + 15 + 75;
}
- (void)tapToHid {
    
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.height);
    }completion:^(BOOL finished) {
        self.submmitBlock();
        [self removeFromSuperview];
    }];
    
}
- (void)sureSubmitBtnClick:(UIButton *)sender {
    if ([Utils isBlankString:self.titleStr]) {
        [MBProgressHUD showError:@"请填写发票抬头"];
        return ;
    } else if ([Utils isBlankString:self.TaxNumber]) {
        [MBProgressHUD showError:@"请填写税号"];
        return ;
    } else {
        [HttpRequestEngine isNeedToTakeBillWithId:self.ID type:@"1" title:self.titleStr taxNo:self.TaxNumber completion:^(id obj, NSString *errorStr) {
            if ([Utils isBlankString:errorStr]) {
                if (self.submmitBlock != nil) {
                    self.submmitBlock();
                }
            } else {
                [MBProgressHUD showError:errorStr];
            }
        }];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.titleTF) {
        self.titleStr = textField.text;
    } else {
        self.TaxNumber = textField.text;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
