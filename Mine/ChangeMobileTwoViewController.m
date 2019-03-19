//
//  ChangeMobileTwoViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/14.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "ChangeMobileTwoViewController.h"

@interface ChangeMobileTwoViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *mobileTF;
@property (nonatomic) NSString *mobile;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic) NSString *pwd;
@property (nonatomic, strong) UIButton *GetYanZheng;
@property (nonatomic, strong) UILabel *TiShi;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) NSString *identifyingCode;

@property (nonatomic, strong) UIView *bgV;
@property (nonatomic, strong) UIView *www;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, assign) BOOL isGetYanZheng;
@end

@implementation ChangeMobileTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更换登录手机号码";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView {
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5+NaviHeight, kScreenWidth-20, 20)];
    titleLB.text = @"更换手机号码后，下次登录需要使用新的手机号码";
    titleLB.font = [UIFont systemFontOfSize:13*KAdaptiveRateWidth];
    titleLB.textColor = GRAY160;
    [self.view addSubview:titleLB];
    
    self.isGetYanZheng = 1;
    
    _bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 45+NaviHeight, kScreenWidth, 90)];
    _bgV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgV];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"手机"]];
    image.frame = CGRectMake(17.5, 7.5, 25, 27.5);
    [_bgV addSubview:image];
    
    self.mobileTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, kScreenWidth - 50, 45)];
    self.mobileTF.delegate = self;
    self.mobileTF.font = [UIFont systemFontOfSize:16];
    self.mobileTF.textColor = GRAY70;
    self.mobileTF.placeholder = @"输入手机号码";
    self.mobileTF.tintColor = GRAY70;
    self.mobileTF.keyboardType = UIKeyboardTypeNumberPad;
    self.mobileTF.returnKeyType = UIReturnKeyDone;
    [self.mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgV addSubview:self.mobileTF];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 45, kScreenWidth-20, 1)];
    line.backgroundColor = VIEW_BASE_COLOR;
    [_bgV addSubview:line];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"验证码"]];
    image1.frame = CGRectMake(17.5, 50, 25, 30);
    [self.bgV addSubview:image1];
    
    self.pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 45, kScreenWidth - 170, 45)];
    self.pwdTF.delegate = self;
    self.pwdTF.font = [UIFont systemFontOfSize:16];
    self.pwdTF.textColor = GRAY70;
    self.pwdTF.placeholder = @"输入验证码";
    self.pwdTF.tintColor = GRAY70;
    self.pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    self.pwdTF.returnKeyType = UIReturnKeyDone;
    [self.pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgV addSubview:self.pwdTF];
    
    self.GetYanZheng = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bgV addSubview:self.GetYanZheng];
    self.GetYanZheng.tag = 1001;
    self.GetYanZheng.layer.masksToBounds = YES;
    [self.GetYanZheng.layer setCornerRadius:3];
    [self.GetYanZheng setBackgroundColor:[UIColor lightGrayColor]];
    [self.GetYanZheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bgV.mas_right).offset(-10);
        make.top.equalTo(self.pwdTF.mas_top).offset(5);
        make.bottom.equalTo(self.pwdTF.mas_bottom).offset(-5);
        make.width.mas_equalTo(110);
    }];
    
    [self.GetYanZheng addTarget:self action:@selector(verifyEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.GetYanZheng.enabled = NO;
    
    _TiShi = [[UILabel alloc]init];
    _TiShi.text = @"获取验证码";
    [self.GetYanZheng addSubview:_TiShi];
    _TiShi.textColor = [UIColor whiteColor];
    _TiShi.font = [UIFont systemFontOfSize:14];
    _TiShi.textAlignment = NSTextAlignmentCenter;
    _TiShi.backgroundColor = [UIColor clearColor];
    _TiShi.frame = CGRectMake(0, 0, 110, 35);
    
    
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_changeBtn];
    [_changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgV.mas_bottom).offset(30*KAdaptiveRateWidth);
        make.left.equalTo(self.view.mas_left).offset(20*KAdaptiveRateWidth);
        make.right.equalTo(self.view.mas_right).offset(-20*KAdaptiveRateWidth);
        make.height.mas_equalTo(45);
    }];
    _changeBtn.enabled = NO;
    [_changeBtn setTitle:@"提   交" forState:UIControlStateNormal];
    [_changeBtn setBackgroundColor:MYORANGE];
    
    [_changeBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_changeBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [_changeBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateHighlighted];
    
    [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _changeBtn.layer.cornerRadius = 5;
    _changeBtn.layer.masksToBounds = YES;
    [_changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)initBgvUIs {
    
    
    _www = [[UIView alloc] init];
    _www.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_www];
    _www.frame = CGRectMake(0, 45+NaviHeight, kScreenWidth, 180*KAdaptiveRateWidth);
    
    UIImageView *simImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sim-card"]];
    [self.view addSubview:simImage];
    [simImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgV.mas_centerX);
        make.top.equalTo(self.bgV.mas_top).offset(20*KAdaptiveRateWidth);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UILabel *a = [[UILabel alloc]init];
    [_www addSubview:a];
    a.text = @"当前绑定的手机号码:";
    a.textColor = [UIColor lightGrayColor];
    a.textAlignment = NSTextAlignmentCenter;
    a.font = [UIFont systemFontOfSize:15];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(simImage.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.left.equalTo(self.bgV.mas_left);
        make.right.equalTo(self.bgV.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    UILabel * mobileLb = [[UILabel alloc]init];
    [_www addSubview:mobileLb];
    mobileLb.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    mobileLb.textColor = kMyColor(7, 91, 128);
    mobileLb.textAlignment = NSTextAlignmentCenter;
    mobileLb.font = [UIFont systemFontOfSize:18];
    [mobileLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(a.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.left.equalTo(self.bgV.mas_left);
        make.right.equalTo(self.bgV.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_www.mas_bottom).offset(30*KAdaptiveRateWidth);
        make.left.equalTo(self.view.mas_left).offset(20*KAdaptiveRateWidth);
        make.right.equalTo(self.view.mas_right).offset(-20*KAdaptiveRateWidth);
        make.height.mas_equalTo(45);
    }];
    [_sureBtn setTitle:@"确    定" forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:MYORANGE];
    
    [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_sureBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [_sureBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateHighlighted];
    
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
    [_sureBtn addTarget:self action:@selector(ClickToBack:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)verifyEvent:(UIButton *)sender {
    if ([self.mobileTF.text checkPhoneNumInput]) {
        self.mobile = self.mobileTF.text;
        [HttpRequestEngine checkMobileWithMobile:self.mobile completion:^(id obj, NSString *errorStr) {
            if (![Utils isBlankString:errorStr]) {
                [MBProgressHUD showError:errorStr];
            } else {
                [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:60] afterDelay:0];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                
                NSDictionary *parameters = @{@"inter": @"sentSms",@"mobile":self.mobile};
                [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *data = [NSDictionary changeType:responseObject];
                    NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                    if ([code isEqualToString:@"1"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                    } else {
                        self.identifyingCode = [NSString stringWithFormat:@"%@",data[@"vcode"]];
                        NSLog(@"%@",self.identifyingCode);
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                }];
            }
        }];
        
    } else{
        [MBProgressHUD showError:@"手机号码有误"];
    }

}

//倒数

- (void)reflashGetKeyBt:(NSNumber *)second

{
    
    if ([second integerValue] == 0) {
        
        //[self.registerView.checkBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_02"] forState:UIControlStateNormal];
        self.GetYanZheng.backgroundColor = kMyColor(250, 170, 150);
        self.GetYanZheng.enabled = YES;
        self.isGetYanZheng = 1;
        _TiShi.text = @"获取验证码";
        if (self.mobileTF.text.length == 11) {
            self.GetYanZheng.enabled = YES;
            [self.GetYanZheng setBackgroundColor:kMyColor(250, 170, 150)];
        } else {
            [self.GetYanZheng setBackgroundColor:[UIColor lightGrayColor]];
            _changeBtn.enabled = NO;
        }
    }
    
    else
        
    {
        
        //[self.registerView.checkBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_01"] forState:UIControlStateNormal];
        self.isGetYanZheng = 0;
        self.GetYanZheng.enabled = NO;
        self.GetYanZheng.backgroundColor = [UIColor lightGrayColor];
        
        int i = [second intValue];
        
        if (i == 60) {
            _TiShi.text=[NSString stringWithFormat:@"验证码已发送"];
        } else {
            _TiShi.text=[NSString stringWithFormat:@"%i秒后重发",i];
        }
        
        
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
        
    }
    
    
}


- (void)changeClick:(UIButton *)sender {
    if ([self.mobileTF.text isEqualToString:self.mobile]) {
        if ([self.pwd isEqualToString:self.identifyingCode]) {
            [HttpRequestEngine changeMobileWithNewPhone:self.mobile vcode:self.identifyingCode completion:^(id obj, NSString *errorStr) {
                if (![Utils isBlankString:errorStr]) {
                    [MBProgressHUD showError:errorStr];
                } else {
                    [[NSUserDefaults standardUserDefaults] setObject:self.mobile forKey:@"name"];
                    [self changeSuccessed];
                    
                    [MBProgressHUD showSuccess:@"更换成功"];
                    [HttpRequestEngine againLoginWithName:self.mobile pwd:[[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"] completion:^(id obj, NSString *errorStr) {
                        
                    }];
                }
            }];
            
        } else {
            [MBProgressHUD showError:@"验证码不正确"];
        }
    } else {
        [MBProgressHUD showError:@"手机号码已改变"];
    }
    
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _mobileTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
        if (textField.text.length == 11) {
            if (self.isGetYanZheng) {
                self.GetYanZheng.enabled = YES;
                [self.GetYanZheng setBackgroundColor:kMyColor(250, 170, 150)];
            }
        } else {
            [self.GetYanZheng setBackgroundColor:[UIColor lightGrayColor]];
            _changeBtn.enabled = NO;
        }
        
    } else if (textField == _pwdTF) {
        if (textField.text.length > 6) {
            textField.text = [textField.text substringToIndex:6];
        }
        if (textField.text.length < 6) {
            _changeBtn.enabled = NO;
        }
        self.pwd = textField.text;
    }
    if (_mobileTF.text.length == 11 && _pwdTF.text.length == 6) {
        if ([_mobileTF.text checkPhoneNumInput]) {
            _changeBtn.enabled = YES;
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _mobileTF) {
        NSString *mobile = _mobileTF.text;
        if (mobile.length == 11) {
//            self.mobile = mobile;
        } else {
            
        }
    } else if (textField == _pwdTF) {
        self.pwd = _pwdTF.text;
    }
}
- (void)changeSuccessed {
    self.bgV.hidden = YES;
    self.changeBtn.hidden = YES;
    [self initBgvUIs];
}
- (void)ClickToBack:(UIButton *)sender {
    self.block();
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
