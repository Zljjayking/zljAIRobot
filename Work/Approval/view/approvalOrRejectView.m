//
//  approvalOrRejectView.m
//  Financeteam
//
//  Created by Zccf on 2017/5/24.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalOrRejectView.h"
#import "HttpRequestEngine.h"
@implementation approvalOrRejectView
+(id)initWithTitle:(NSString *)title ID:(NSString *)ID seqID:(NSString *)seqID mech_id:(NSString *)mech_id nowUserId:(NSString *)nowUserId frame:(CGRect)frame {
    return [[self alloc]initWithTitle:title ID:ID seqID:seqID mech_id:mech_id nowUserId:nowUserId frame:frame];
}
-(instancetype)initWithTitle:(NSString *)title ID:(NSString *)ID seqID:(NSString *)seqID mech_id:(NSString *)mech_id nowUserId:(NSString *)nowUserId frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.ID = ID;
        self.seqID = seqID;
        self.mechID = mech_id;
        self.nowUserId = nowUserId;
        [self initView];
    }
    return self;
}
-(void)initView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-40, 25)];
    self.titleLB.text = [NSString stringWithFormat:@"%@说明",self.title];
//    self.titleLB.font = [UIFont systemFontOfSize:18];
    self.titleLB.textColor = GRAY120;
    [self addSubview:self.titleLB];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"passWord"]];
    image.frame = CGRectMake(20, 50, 25, 25);
//    [self addSubview:image];
    
    self.pwdTF = [[UITextView alloc] initWithFrame:CGRectMake(20, 45, kScreenWidth - 40, 135)];
    self.pwdTF.delegate = self;
    self.pwdTF.font = [UIFont systemFontOfSize:17];
    self.pwdTF.textColor = GRAY70;
    self.pwdTF.tintColor = GRAY70;
    self.pwdTF.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.pwdTF];
    
    self.placeHolderLB = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 200, 17)];
    self.placeHolderLB.textColor = GRAY190;
    self.placeHolderLB.text = [NSString stringWithFormat:@"请填写%@说明",self.title];
    [self.pwdTF addSubview:self.placeHolderLB];
    
    self.approveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.approveBtn.frame = CGRectMake(20*KAdaptiveRateWidth, 200, kScreenWidth - 40*KAdaptiveRateWidth, 40);
    [self addSubview:self.approveBtn];
    if ([self.title isEqualToString:@"驳回"]) {
        [self.approveBtn setTitle:@"驳   回" forState:UIControlStateNormal];
    } else {
        [self.approveBtn setTitle:@"批   准" forState:UIControlStateNormal];
    }
    
    [self.approveBtn setBackgroundColor:MYORANGE];
    [self.approveBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.approveBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [self.approveBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateHighlighted];
    [self.approveBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateDisabled];
    [self.approveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.approveBtn.layer.cornerRadius = 5;
    self.approveBtn.layer.masksToBounds = YES;
    [self.approveBtn addTarget:self action:@selector(surePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.approveBtn.enabled = NO;
    
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"inter"] = @"insertNextApproval";
    if (![Utils isBlankString:self.pwd]) {
        dic[@"reason"] = self.pwd;
    }
    if ([self.title isEqualToString:@"驳回"]) {
        dic[@"state_type"] = @"4";
    } else {
        dic[@"state_type"] = @"3";
    }
    if (![Utils isBlankString:self.ID]) {
        dic[@"id"] = self.ID;
    }
    if (![Utils isBlankString:self.seqID]) {
        dic[@"seq_id"] = self.seqID;
    }
    if (![Utils isBlankString:self.mechID]) {
        dic[@"mech_id"] = self.mechID;
    }
    if (![Utils isBlankString:self.nowUserId]) {
//        dic[@"nowUserId"] = self.nowUserId;
    }
    [HttpRequestEngine approveWithDic:dic completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            self.isSuccessBlock();
            [self tapToHid];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
    
}
#pragma mark - 屏幕上弹
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动，以使下面腾出地方用于软键盘的显示
    self.frame = CGRectMake(0.0f,  kScreenHeight-360, self.frame.size.width, self.frame.size.height);//64-216
    self.bgView.frame = CGRectMake(0.0f,  -140, self.bgView.frame.size.width, self.bgView.frame.size.height);//64-216
    [UIView commitAnimations];
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeHolderLB.hidden = YES;
    } else {
        self.placeHolderLB.hidden = NO;
    }
}
#pragma mark -屏幕恢复
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.pwd = textView.text;
    
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.frame = CGRectMake(0.0f,  kScreenHeight-260, self.frame.size.width, self.frame.size.height);//64-216
    
    self.bgView.frame = CGRectMake(0.0f,  0.0f, self.bgView.frame.size.width, self.bgView.frame.size.height);//64-216
    
    
    [UIView commitAnimations];
}

@end
