//
//  ChangeMobileViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/14.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "ChangeMobileViewController.h"
#import "checkPwdView.h"
#import "ChangeMobileTwoViewController.h"
@interface ChangeMobileViewController ()
@property (nonatomic, strong) LoginPeopleModel *loginModel;
@property (nonatomic, strong) checkPwdView *checkView;
@property (nonatomic, strong) UILabel *mobile;
@end

@implementation ChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BASE_COLOR;
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.title = @"更换登录手机号码";
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView {
    UIImageView *simImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"simCard"]];
    [self.view addSubview:simImage];
    [simImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-150*KAdaptiveRateWidth+64);
        make.width.mas_equalTo(150*KAdaptiveRateWidth);
        make.height.mas_equalTo(150*KAdaptiveRateWidth);
    }];
    
    UILabel *a = [[UILabel alloc]init];
    [self.view addSubview:a];
    a.text = @"当前绑定的手机号码:";
    a.textColor = [UIColor lightGrayColor];
    a.textAlignment = NSTextAlignmentCenter;
    a.font = [UIFont systemFontOfSize:15];
    [a mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(simImage.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.left.equalTo(simImage.mas_left);
        make.right.equalTo(simImage.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    _mobile = [[UILabel alloc]init];
    [self.view addSubview:_mobile];
    _mobile.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
    _mobile.textColor = kMyColor(7, 91, 128);
    _mobile.textAlignment = NSTextAlignmentCenter;
    _mobile.font = [UIFont systemFontOfSize:18];
    [_mobile mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(a.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.left.equalTo(simImage.mas_left);
        make.right.equalTo(simImage.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *bbbb = [[UILabel alloc] init];
    [self.view addSubview:bbbb];
    bbbb.text = @"手机号码可以用于登录和找回密码";
    bbbb.textColor = [UIColor lightGrayColor];
    bbbb.textAlignment = NSTextAlignmentCenter;
    bbbb.font = [UIFont systemFontOfSize:15];
    [bbbb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-10*KAdaptiveRateWidth);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bbbb.mas_top).offset(-10*KAdaptiveRateWidth);
        make.left.equalTo(self.view.mas_left).offset(20*KAdaptiveRateWidth);
        make.right.equalTo(self.view.mas_right).offset(-20*KAdaptiveRateWidth);
        make.height.mas_equalTo(40);
    }];
    [changeBtn setTitle:@"更换手机号码" forState:UIControlStateNormal];
    
    [changeBtn setBackgroundColor:MYORANGE];
    
    [changeBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [changeBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    [changeBtn setBackgroundImage:[UIImage imageWithColor:GRAY210] forState:UIControlStateHighlighted];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.layer.cornerRadius = 5;
    changeBtn.layer.masksToBounds = YES;
    [changeBtn addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeClick:(UIButton *)sender {
    
    self.checkView = [[checkPwdView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 160)];
    
    self.checkView.bgView.hidden = YES;
    
    [self.navigationController.view addSubview:self.checkView.bgView];
    [self.navigationController.view addSubview:self.checkView];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    self.checkView.bgView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.checkView.isPopBlock = ^(){
        weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    };
    self.checkView.isSuccessBlock = ^(){
        ChangeMobileTwoViewController *changeTwo = [ChangeMobileTwoViewController new];
        changeTwo.block = ^(){
            weakSelf.mobile.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"]];
        };
        [weakSelf.navigationController pushViewController:changeTwo animated:YES];
    };
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.checkView.frame = CGRectMake(0, kScreenHeight-160, kScreenWidth, 160);
        
    }];
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
