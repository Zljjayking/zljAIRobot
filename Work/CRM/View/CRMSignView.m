//
//  CRMSignView.m
//  Financeteam
//
//  Created by Zccf on 2017/10/10.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "CRMSignView.h"

@implementation CRMSignView
- (HStartSelectView *)selectView {
    
    if (!_selectView) {
        
        CGFloat width = 200;
        _selectView = [[HStartSelectView alloc] initWithFrame:CGRectMake((293*KAdaptiveRateWidth-width)/2.0, 60, width, 25) block:^(NSString *score) {
            self.signCode = score;
        } enable:YES];
    }
    
    return _selectView;
}
- (id)initWithFrame:(CGRect)frame signCode:(NSString *)signCode  customID:(NSString *)customID{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = customBackColor;
        self.signCode = signCode;
        self.customID = customID;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 293*KAdaptiveRateWidth, 200)];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 15;
    bgView.backgroundColor = MYWhite;
    [self addSubview:bgView];
    bgView.center = self.center;
    
    [bgView addSubview:self.selectView];
    if ([self.signCode isEqualToString:@"6"]) {
        self.signCode = @"0";
    }
    self.selectView.score = self.signCode;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 7;
    cancelBtn.frame = CGRectMake(17*KAdaptiveRateWidth, 135, 75*KAdaptiveRateWidth, 45);
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.backgroundColor = GRAY240;
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:customBlueColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *giveUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    giveUpBtn.layer.masksToBounds = YES;
    giveUpBtn.layer.cornerRadius = 7;
    giveUpBtn.frame = CGRectMake(109*KAdaptiveRateWidth, 135, 75*KAdaptiveRateWidth, 45);
    giveUpBtn.layer.masksToBounds = YES;
    giveUpBtn.backgroundColor = GRAY240;
    [giveUpBtn setTitle:@"放 弃" forState:UIControlStateNormal];
    [giveUpBtn setTitleColor:customRedColor forState:UIControlStateNormal];
    [giveUpBtn addTarget:self action:@selector(giveUpClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:giveUpBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 7;
    sureBtn.frame = CGRectMake(201*KAdaptiveRateWidth, 135, 75*KAdaptiveRateWidth, 45);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = GRAY240;
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:customGreenColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sureBtn];
    
}
- (void)cancelClick {
    if (self.cancelblock != nil) {
        self.cancelblock();
    }
    [self removeFromSuperview];
}
- (void)giveUpClick {
    self.signCode = @"6";
    [self sureClick];
}
- (void)sureClick {
    [self updateCrmSignWithCustomID:self.customID signCode:self.signCode];
}
- (void)updateCrmSignWithCustomID:(NSString *)customID signCode:(NSString *)signCode {
    [MBProgressHUD showMessage:@"正在处理..."];
    [HttpRequestEngine updateCrmSignWithCustomID:customID type:signCode completion:^(id obj, NSString *errorStr) {
        [MBProgressHUD hideHUD];
        if (errorStr == nil) {
            [MBProgressHUD showSuccess:@"设置成功"];
            if (self.block != nil) {
                self.block(self.signCode);
            }
            [self removeFromSuperview];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
@end
