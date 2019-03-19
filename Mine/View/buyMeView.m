//
//  buyMeView.m
//  Financeteam
//
//  Created by Zccf on 2017/8/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeView.h"
#import "HttpRequestEngine.h"
#import "citiesViewController.h"
@interface buyMeView ()<UITextFieldDelegate,UITextViewDelegate>

{
    UIButton * _surePayBtn;
    UIView *hehe;
}
@property (nonatomic, strong) UIView *alertView;
@end
@implementation buyMeView
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
        stateLb.text = @"支付成功!";
        stateLb.center = CGPointMake(p.x, p1.y+30);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertView addSubview:btn];
        btn.frame = CGRectMake(0, 0, 20, 20);
        btn.center = CGPointMake(p.x+(kScreenWidth-80*KAdaptiveRateWidth)/2.0-20, kScreenHeight/2.0-30-(120*KAdaptiveRateHeight)/2.0+20);
        [btn setBackgroundImage:[UIImage imageNamed:@"closeView"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertView;
}
- (instancetype)initWithFrame:(CGRect)frame paramaters:(NSDictionary *)paramaters money:(NSString *)money mechineCount:(NSInteger)mechineCount{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzhengIsSeccess) name:@"CallBackResault" object:nil];
        self.paramaters = paramaters;
        self.money = money;
        self.isMechine = 0;
        if (mechineCount) {
            self.isMechine = 1;
            [self setupView];
        } else {
            [self initView];
        }
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *receivingNoteLb = [[UILabel alloc]init];
    receivingNoteLb.text = @"收货信息";
    receivingNoteLb.textColor = GRAY180;
    receivingNoteLb.font = [UIFont systemFontOfSize:14];
    [self addSubview:receivingNoteLb];
    [receivingNoteLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    
    UILabel *receiverLB = [[UILabel alloc] init];
    receiverLB.text = @"收件人姓名:";
    receiverLB.font = [UIFont systemFontOfSize:15];
    receiverLB.textColor = GRAY160;
    [self addSubview:receiverLB];
    [receiverLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(receivingNoteLb.mas_bottom).offset(15);
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
    
    self.receiverTF = [[UITextField alloc]init];
    [self addSubview:self.receiverTF];
    self.receiverTF.placeholder = @"请输入收件人姓名";
    self.receiverTF.delegate = self;
    self.receiverTF.textAlignment = NSTextAlignmentRight;
    self.receiverTF.tag = 1;
    self.receiverTF.font = [UIFont systemFontOfSize:15];
    [self.receiverTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiverLB.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(receiverLB.mas_centerY);
        make.height.mas_equalTo(30);
    }];

    UILabel *receiverMobileLB = [[UILabel alloc] init];
    receiverMobileLB.text = @"收件人电话:";
    receiverMobileLB.font = [UIFont systemFontOfSize:15];
    receiverMobileLB.textColor = GRAY160;
    [self addSubview:receiverMobileLB];
    [receiverMobileLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.receiverTF.mas_bottom).offset(15);
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
    
    self.receiverMobileTF = [[UITextField alloc]init];
    [self addSubview:self.receiverMobileTF];
    self.receiverMobileTF.delegate = self;
    self.receiverMobileTF.tag = 2;
    self.receiverMobileTF.keyboardType = UIKeyboardTypePhonePad;
    self.receiverMobileTF.placeholder = @"请输入收件人电话";
    self.receiverMobileTF.textAlignment = NSTextAlignmentRight;
    self.receiverMobileTF.font = [UIFont systemFontOfSize:15];
    [self.receiverMobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(receiverMobileLB.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(receiverMobileLB.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *addressLB = [[UILabel alloc] init];
    addressLB.text = @"收件地区:";
    addressLB.font = [UIFont systemFontOfSize:15];
    addressLB.textColor = GRAY160;
    [self addSubview:addressLB];
    [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.receiverMobileTF.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(70);
    }];
    
    UIImageView *starThree = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:starThree];
    [starThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addressLB.mas_left).offset(-2.5);
        make.centerY.equalTo(addressLB.mas_centerY);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(7);
    }];
    
    self.addressTF = [[UITextField alloc]init];
    [self addSubview:self.addressTF];
    self.addressTF.placeholder = @"点击选择";
    self.addressTF.enabled = NO;
    self.addressTF.font = [UIFont systemFontOfSize:15];
    self.addressTF.userInteractionEnabled = NO;
    self.addressTF.textAlignment = NSTextAlignmentRight;
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLB.mas_right).offset(10);
        make.centerY.equalTo(addressLB.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    self.addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.addressBtn];
    [self.addressBtn addTarget:self action:@selector(chooseArea) forControlEvents:UIControlEventTouchUpInside];
    self.addressBtn.backgroundColor = [UIColor clearColor];
    self.addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.addressBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.addressBtn setTitleColor:GRAY200 forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLB.mas_right).offset(10);
        make.centerY.equalTo(addressLB.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"箭头（右）"];
    [self addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressBtn.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-6);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(8);
    }];

    
    UILabel *postCodeLB = [[UILabel alloc] init];
    postCodeLB.text = @"详细地址:";
    postCodeLB.font = [UIFont systemFontOfSize:15];
    postCodeLB.textColor = GRAY160;
    [self addSubview:postCodeLB];
    [postCodeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.top.equalTo(self.addressBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(70);
    }];
    
    UIImageView *starFour = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"星号"]];
    [self addSubview:starFour];
    [starFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(postCodeLB.mas_left).offset(-2.5);
        make.centerY.equalTo(postCodeLB.mas_centerY);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(7);
    }];
    
    self.postcodeTF = [[UITextField alloc]init];
    [self addSubview:self.postcodeTF];
    self.postcodeTF.placeholder = @"请输入详细地址";
    self.postcodeTF.textAlignment = NSTextAlignmentRight;
    self.postcodeTF.enabled = NO;
    self.postcodeTF.font = [UIFont systemFontOfSize:15];
    self.postcodeTF.userInteractionEnabled = NO;
    [self.postcodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(postCodeLB.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(postCodeLB.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    
    self.postcodeTV = [[UITextView alloc]init];
    [self addSubview:self.postcodeTV];
    self.postcodeTV.textAlignment = NSTextAlignmentRight;
    self.postcodeTV.backgroundColor = [UIColor clearColor];
    self.postcodeTV.delegate = self;
    self.postcodeTV.tag = 4;
    self.postcodeTV.font = [UIFont systemFontOfSize:15];
    [self.postcodeTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(postCodeLB.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-17);
        make.top.equalTo(self.postcodeTF.mas_top).offset(-2);
        make.height.mas_equalTo(50);
    }];
    
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(00, 190, kScreenWidth-0*KAdaptiveRateWidth, 2)];
    // 调用方法 返回的iamge就是虚线
    lineImg.image = [self drawLineOfDashByImageView:lineImg];
    // 添加到控制器的view上
    [self addSubview:lineImg];
    
    UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, kScreenWidth-40, 20)];
    payType.text = @"支付方式";
    payType.font = [UIFont systemFontOfSize:14];
    payType.textColor = GRAY180;
    [self addSubview:payType];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 228, 90, 34)];
    imageV.image = [UIImage imageNamed:@"alipay"];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageV];
    
    UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(20, 270, kScreenWidth-40, 15)];
    two.text = @"暂时只支持支付宝付款，带来不便，敬请见谅!";
    two.textColor = GRAY200;
    two.font = [UIFont systemFontOfSize:12];
    [self addSubview:two];
    
    _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _surePayBtn.frame = CGRectMake(20, 295, kScreenWidth - 40, 40);
    [self addSubview:_surePayBtn];
    NSString *btnTitle = [NSString stringWithFormat:@"确认支付 %@元",self.money];
    [_surePayBtn setTitle:btnTitle forState:UIControlStateNormal];
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
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    UILabel *payType = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-40, 20)];
    payType.text = @"支付方式";
    payType.font = [UIFont systemFontOfSize:15];
    payType.textColor = GRAY90;
    [self addSubview:payType];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 90, 34)];
    imageV.image = [UIImage imageNamed:@"alipay"];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageV];
    
    UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, kScreenWidth-40, 15)];
    two.text = @"暂时只支持支付宝付款，带来不便，敬请见谅!";
    two.textColor = GRAY200;
    two.font = [UIFont systemFontOfSize:12];
    [self addSubview:two];
    
    _surePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _surePayBtn.frame = CGRectMake(20, 120, kScreenWidth - 40, 40);
    [self addSubview:_surePayBtn];
    NSString *btnTitle = [NSString stringWithFormat:@"确认支付 %@元",self.money];
    [_surePayBtn setTitle:btnTitle forState:UIControlStateNormal];
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
    
    self.bgView.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isMechine) {
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 350);
        } else {
            self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 180);
        }
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
-(void)surePayBtnClick:(UIButton *)sender{
    if (self.isMechine) {
        self.mutableParamaters = [NSMutableDictionary dictionaryWithDictionary:self.paramaters];
        self.mutableParamaters[@"area_pro_id"] = self.proId;
        self.mutableParamaters[@"area_city_id"] = self.cityId;
        self.mutableParamaters[@"area_area_id"] = self.areaId;
        self.mutableParamaters[@"address"] = self.addressStr;
        self.mutableParamaters[@"userName"] = self.receiverStr;
        self.mutableParamaters[@"userMobile"] = self.receiverMobileStr;
        self.paramaters = self.mutableParamaters;
        if ([Utils isBlankString:self.receiverStr] || [Utils isBlankString:self.receiverMobileStr] || [Utils isBlankString:self.proId] || [Utils isBlankString:self.cityId] || [Utils isBlankString:self.areaId] || [Utils isBlankString:self.addressStr]) {
            [MBProgressHUD showError:@"请填写完整收货信息"];
            return ;
        }
    }
    [HttpRequestEngine buyMeWithDic:self.paramaters completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            self.orderNo = [NSString stringWithFormat:@"%@",[obj objectForKey:@"orderNo"]];
            self.payInfo = [NSString stringWithFormat:@"%@",[obj objectForKey:@"payInfo"]];
            NSString *appScheme = @"RongEOA.alipay.com";
            [[AlipaySDK defaultService] payOrder:self.payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                
                NSLog(@"resultStatus == %@",resultStatus);
                if([resultStatus  isEqualToString: @"9000"]){
                    [self yanzhengIsSeccess];
                    NSLog(@"充值成功");
                } else {
                    [MBProgressHUD showError:@"支付失败"];
                }
            }];
        }
    }];
    
}
- (void)closeAlert {
    [self.alertView removeFromSuperview];
    [self tapToHid];
    
    [self.delegate clickToPayAndReturnTheResualt:@"1"];
}
- (void)yanzhengIsSeccess {
    /**
     
     */
    
    [HttpRequestEngine queryRechargeBuyMeWithOrderNo:self.orderNo completion:^(id obj, NSString *errorStr) {
        if (errorStr.length == 0) {
            
            NSDictionary *dic = [NSDictionary changeType:obj];
            NSString *state = [NSString stringWithFormat:@"%@",dic[@"state"]];
            if ([state isEqualToString:@"0"]) {
                
                /**
                 [HttpEngineManager friendDetailInfoRequestWithUserID:[LocalMeManager sharedPersonalInfoManager].getUserID andAid:1 completion:^(id obj, NSString *errorStr) {
                 
                 
                 }];
                 */
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self yanzheng];
                });
            } else {
                [MBProgressHUD showError:@"支付出错，请联系客服！"];
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CallBackResaults" object:nil];
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
- (void)textFieldDidChande:(UITextField *)tf {
    if (tf.text.length > 6) {
        tf.text = [tf.text substringToIndex:6];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;
    switch (textField.tag) {
        case 1:
        {
            self.receiverStr = text;
        }
            break;
        case 2:
        {
            self.receiverMobileStr = text;
        }
            break;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        self.postcodeTF.text = @"   ";
    } else {
        self.postcodeTF.text = @"";
    }
    self.addressStr = textView.text;
}
- (void)chooseArea {
    UIViewController *vc = [Utils getCurrentVC:self];
    citiesViewController *citiesVC = [[citiesViewController alloc]init];
    citiesVC.type = 5;
    citiesVC.limited = 2;
    citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
        self.proId = selectedProID;
        self.cityId = selectedCityID;
        self.areaId = selectedAreaID;
        
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
        self.addressTF.text = str;
    };
    citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [vc presentViewController:citiesVC animated:YES completion:nil];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
