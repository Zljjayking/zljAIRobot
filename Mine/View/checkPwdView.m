//
//  checkPwdView.m
//  Financeteam
//
//  Created by Zccf on 17/4/14.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "checkPwdView.h"

@implementation checkPwdView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}
-(void)initView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-40, 25)];
    titleLB.text = @"验证登录密码";
    titleLB.font = [UIFont systemFontOfSize:15];
    titleLB.textColor = GRAY120;
    [self addSubview:titleLB];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passWord"]];
    image.frame = CGRectMake(20, 50, 25, 25);
    [self addSubview:image];
    
    self.pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 45, kScreenWidth - 40, 35)];
    self.pwdTF.delegate = self;
    self.pwdTF.secureTextEntry = YES;
    self.pwdTF.font = [UIFont systemFontOfSize:16];
    self.pwdTF.textColor = GRAY70;
    self.pwdTF.placeholder = @"输入密码";
    self.pwdTF.tintColor = GRAY70;
    [self.pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.pwdTF.returnKeyType = UIReturnKeyDone;
    
    [self addSubview:self.pwdTF];
    
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    checkBtn.frame = CGRectMake(20*KAdaptiveRateWidth, 100, kScreenWidth - 40*KAdaptiveRateWidth, 40);
    
    [self addSubview:checkBtn];
    
    [checkBtn setTitle:@"立即验证" forState:UIControlStateNormal];
    
    [checkBtn setBackgroundColor:MYORANGE];
    
    [checkBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [checkBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [checkBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateHighlighted];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkBtn.layer.cornerRadius = 5;
    checkBtn.layer.masksToBounds = YES;
    [checkBtn addTarget:self action:@selector(surePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _bgView.backgroundColor = customBackColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHid)];
    [_bgView addGestureRecognizer:tap];
    
}
- (void)tapToHid {
    _isPopBlock();
    [self.pwdTF resignFirstResponder];
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 160);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.pwdTF.text = @"";
    self.pwd = @"";
}

-(void)surePayBtnClick:(UIButton *)sender{
    NSString *pwdString = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    [self.pwdTF resignFirstResponder];
    if ([self.pwd isEqualToString:pwdString]) {
        self.isSuccessBlock();
        [self tapToHid];
    } else {
        [MBProgressHUD showError:@"密码不正确"];
    }
}
#pragma mark - 屏幕上弹
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    //键盘高度216
    
    //滑动效果（动画）
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.frame = CGRectMake(0.0f,  kScreenHeight-360, self.frame.size.width, self.frame.size.height);//64-216
    
    self.bgView.frame = CGRectMake(0.0f,  -140, self.bgView.frame.size.width, self.bgView.frame.size.height);//64-216
    
    
    [UIView commitAnimations];
}
- (void)textFieldDidChange:(UITextField *)textField{
    self.pwd = textField.text;
}
#pragma mark -屏幕恢复
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.pwd = textField.text;
    
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.frame = CGRectMake(0.0f,  kScreenHeight-160, self.frame.size.width, self.frame.size.height);//64-216
    
    self.bgView.frame = CGRectMake(0.0f,  0.0f, self.bgView.frame.size.width, self.bgView.frame.size.height);//64-216
    
    
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}
@end
