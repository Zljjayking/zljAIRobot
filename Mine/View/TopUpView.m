//
//  TopUpView.m
//  365ChengRongWang
//
//  Created by 张正飞 on 16/12/21.
//  Copyright © 2016年 Zccf. All rights reserved.
//

#import "TopUpView.h"
#import "HttpRequestEngine.h"
#import "LoginPeopleModel.h"
@interface TopUpView ()

{
    UIButton * _surePayBtn;
    UIView *hehe;
}

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *topView;
@end

@implementation TopUpView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallBackResaults" object:nil];
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-300)];
        
        _topView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHid)];
        [_topView addGestureRecognizer:tap];
    }
    return _topView;
}
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _alertView.backgroundColor = customBackColor;
        
        hehe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80*KAdaptiveRateWidth, 120*KAdaptiveRateWidth)];
        hehe.backgroundColor = [UIColor whiteColor];
        CGPoint p = self.center;
        hehe.center = CGPointMake(p.x, kScreenHeight/2.0-30);
        [_alertView addSubview:hehe];
        //        hehe.layer.masksToBounds = YES;
        [hehe.layer setCornerRadius:10];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_alertView addSubview:image];
        image.image = [UIImage imageNamed:@"120-gou"];
        CGPoint p1 = hehe.center;
        
        image.center = CGPointMake(p.x, p1.y-20);
        UILabel *stateLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_alertView addSubview:stateLb];
        stateLb.textAlignment = NSTextAlignmentCenter;
        stateLb.text = @"充值成功!";
        stateLb.center = CGPointMake(p.x, p1.y+30);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertView addSubview:btn];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.center = CGPointMake(p.x+(kScreenWidth-80*KAdaptiveRateWidth)/2.0-20, kScreenHeight/2.0-30-(120*KAdaptiveRateHeight)/2.0+20);
        [btn setBackgroundImage:[UIImage imageNamed:@"closeView"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzhengIsSeccess) name:@"CallBackResault" object:nil];
        [self initView];
    }
    return  self;
}

-(void)initView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-40, 25)];
    titleLB.text = @"充值金额";
    titleLB.font = [UIFont systemFontOfSize:15];
    titleLB.textColor = GRAY90;
    [self addSubview:titleLB];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"钱"]];
    image.frame = CGRectMake(20, 47.5, 30, 30);
    [self addSubview:image];
    
    self.moneyTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 45, kScreenWidth - 40, 35)];
    self.moneyTF.delegate = self;
    self.moneyTF.font = [UIFont systemFontOfSize:16];
    self.moneyTF.textColor = GRAY70;
    self.moneyTF.placeholder = @"输入充值金额:(元)";
    self.moneyTF.tintColor = GRAY70;
    self.moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyTF.returnKeyType = UIReturnKeyDone;
    [self.moneyTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.moneyTF];
    
    UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, kScreenWidth-40, 20)];
    one.text = @"充值限额:单笔10元起";
    one.font = [UIFont systemFontOfSize:13];
    one.textColor = GRAY200;
    [self addSubview:one];
    
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 120, kScreenWidth-20*KAdaptiveRateWidth, 2)];
    // 调用方法 返回的iamge就是虚线
    lineImg.image = [self drawLineOfDashByImageView:lineImg];
    // 添加到控制器的view上
    [self addSubview:lineImg];
    
    UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(10, 132, kScreenWidth-40, 25)];
    payType.text = @"支付方式";
    payType.font = [UIFont systemFontOfSize:15];
    payType.textColor = GRAY90;
    [self addSubview:payType];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 167, 90, 34)];
    imageV.image = [UIImage imageNamed:@"alipay"];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageV];
    
    UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, kScreenWidth-40, 15)];
    two.text = @"暂时只支持支付宝付款，带来不便，敬请见谅!";
    two.textColor = GRAY200;
    two.font = [UIFont systemFontOfSize:12];
    [self addSubview:two];
    
    _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _surePayBtn.frame = CGRectMake(20, 240, kScreenWidth - 40, 40);
    [self addSubview:_surePayBtn];
    [_surePayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_surePayBtn setBackgroundColor:MYORANGE];
    [_surePayBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_surePayBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [_surePayBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateHighlighted];
    [_surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _surePayBtn.layer.cornerRadius = 5;
    _surePayBtn.layer.masksToBounds = YES;
    [_surePayBtn addTarget:self action:@selector(surePayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _bgView.backgroundColor = customBackColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHid)];
    [_bgView addGestureRecognizer:tap];

}

- (void)tapToHid {
    _isPopBlock();
    [self.moneyTF resignFirstResponder];
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 300);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    self.moneyTF.text = @"";
    self.money = @"";
}

-(void)surePayBtnClick:(UIButton *)sender{
    /**
     
     
     */
    if (self.money.length > 0 && ([self isPureFloat:self.money] || [self isPureInt:self.money])) {
#pragma mark == 充值
        NSLog(@"充值");
        NSDictionary *dic = [LocalMeManager sharedPersonalInfoManager].loginPeopleInfo;
        LoginPeopleModel *model = [LoginPeopleModel requestWithDic:dic];
        NSString *userId = [NSString stringWithFormat:@"%ld",model.userId];
        NSLog(@"userId == %@",userId);
        
        [HttpRequestEngine rechargeWithUserId:userId money:self.money completion:^(id obj, NSString *errorStr) {
            if (errorStr.length == 0) {
                NSDictionary *data = [NSDictionary changeType:obj];
                NSLog(@"data == %@",data);
                self.orderNo = [NSString stringWithFormat:@"%@",[data objectForKey:@"orderNo"]];
                self.payInfo = data[@"payInfo"];
                NSString *appScheme = @"RongEOA.alipay.com";
                [[AlipaySDK defaultService] payOrder:self.payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                    
                    NSLog(@"resultStatus == %@",resultStatus);
                    if([resultStatus  isEqualToString: @"9000"]){
                        [self yanzhengIsSeccess];
                        
                    } else {
                        [MBProgressHUD showError:@"充值失败"];
                    }
                }];
                
            } else {
                
            }
            
        }];
    } else {
        if ([self isPureFloat:self.money] || [self isPureInt:self.money]) {
            
        } else {
            [MBProgressHUD showError:@"输入充值金额有误"];
        }
    }

}
//判断字符串是否为浮点数
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
- (void)yanzhengIsSeccess {
    /**
     
     */
    [HttpRequestEngine queryRechargeWithOrderNo:self.orderNo completion:^(id obj, NSString *errorStr) {
        if (errorStr.length == 0) {
            NSLog(@"obj == %@",obj);
            NSDictionary *dic = [NSDictionary changeType:obj];
            NSString *state = [NSString stringWithFormat:@"%@",dic[@"state"]];
            if ([state isEqualToString:@"0"]) {
                
                /**
                 [HttpEngineManager friendDetailInfoRequestWithUserID:[LocalMeManager sharedPersonalInfoManager].getUserID andAid:1 completion:^(id obj, NSString *errorStr) {
                 
                 
                 }];
                 */
                self.isSuccessBlock();
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self yanzheng];
                });
            }
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}

#pragma mark -- 充值成功显示界面
- (void)yanzheng {
    
    [[UIApplication sharedApplication].keyWindow insertSubview:self.alertView aboveSubview:self];
}

- (void)closeAlert {
    [self.alertView removeFromSuperview];

    [self tapToHid];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /**
     NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
     [futureString  insertString:string atIndex:range.location];
     
     NSInteger flag=0;
     const NSInteger limited = 2;
     for (int i = (int)futureString.length-1; i>=0; i--) {
     
     if ([futureString characterAtIndex:i] == '.') {
     
     if (flag > limited) {
     return NO;
     }
     break;
     }
     flag++;
     }
     */
    
    
    return [self validateNumber:string text:textField.text floatCount:2];;
}

- (BOOL)validateNumber:(NSString*)number text:(NSString *)textFieldText floatCount:(NSInteger)floatCount {
    
    BOOL res = YES;
    
    
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    int i = 0;
    
    if (number.length==0) {
        
        //允许删除
        
        return  YES;
        
    }
    
    while (i < number.length) {
        
        //确保是数字
        
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        
        if (range.length == 0) {
            
            res = NO;
            
            break;
            
        }
        
        i++;
        
    }
    
    
    if (textFieldText.length==0) {
        
        //第一个不能是0和.
        
        if ([number isEqualToString:@"0"]||[number isEqualToString:@"."]) {
            
            return NO;
            
        }
        
    }
    
    NSArray *array = [textFieldText componentsSeparatedByString:@"."];
    
    NSInteger count = [array count] ;
    
    //小数点只能有一个
    
    if (count>1&&[number isEqualToString:@"."]) {
        
        return NO;
        
    }
    
    //控制小数点后面的字数
    
    if ([textFieldText rangeOfString:@"."].location!=NSNotFound) {
        
        if (textFieldText.length-[textFieldText rangeOfString:@"."].location>floatCount) {
            
            return NO;
            
        }
        
    }
    
    if (textFieldText.length >= 11) {
        return NO;
    }
    
    return res;
    
}



- (void)textFieldDidChange:(UITextField *)textField {
    
    
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

#pragma mark -屏幕恢复
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.money = textField.text;
    if ([self.money floatValue] < 10.0) {
        self.money = @"10";
        textField.text = @"10";
    }
    
    //滑动效果
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //恢复屏幕
    self.frame = CGRectMake(0.0f,  kScreenHeight-300, self.frame.size.width, self.frame.size.height);//64-216
    
    self.bgView.frame = CGRectMake(0.0f,  0.0f, self.bgView.frame.size.width, self.bgView.frame.size.height);//64-216
    
    
    [UIView commitAnimations];
}

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,3};
    
    CGContextSetStrokeColorWithColor(line, GRAY210.CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 1000, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
