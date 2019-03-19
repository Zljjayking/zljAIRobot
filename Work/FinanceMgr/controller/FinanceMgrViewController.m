//
//  FinanceMgrViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "FinanceMgrViewController.h"
#import "paySetViewController.h"
#import "StatisticsViewController.h"
@interface FinanceMgrViewController ()

@end

@implementation FinanceMgrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"财务管理";
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView {
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOne.layer.masksToBounds = YES;
    btnOne.layer.cornerRadius = 15;
//    btnOne.layer.borderWidth = 1;
//    btnOne.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [btnOne setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [btnOne setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.view addSubview:btnOne];
    [btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-70*KAdaptiveRateWidth+64);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnOne addTarget:self action:@selector(btnOneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fmImageOne"]];
    [btnOne addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnOne.mas_centerY);
        make.left.equalTo(btnOne.mas_left).offset(15*KAdaptiveRateWidth);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UILabel *titleOne = [[UILabel alloc] init];
    [btnOne addSubview:titleOne];
    titleOne.text = @"薪资设置";
    titleOne.textColor = GRAY70;
    titleOne.font = [UIFont systemFontOfSize:17];
    [titleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageOne.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(btnOne.mas_top).offset(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(18*KAdaptiveRateWidth);
    }];
    
    UIImageView *swordOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [btnOne addSubview:swordOne];
    [swordOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnOne.mas_centerY);
        make.right.equalTo(btnOne.mas_right).offset(-7*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
        make.width.mas_equalTo(8*KAdaptiveRateWidth);
    }];
    
    UILabel *contentOne = [[UILabel alloc] init];
    [btnOne addSubview:contentOne];
    contentOne.text = @"查看、编辑员工的薪资及提成等的基本信息。";
    contentOne.textColor = GRAY110;
    contentOne.numberOfLines = 3;
    contentOne.font = [UIFont systemFontOfSize:13];
    [contentOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageOne.mas_right).offset(15*KAdaptiveRateWidth);
        //make.top.equalTo(titleOne.mas_bottom).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordOne.mas_left).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(imageOne.mas_bottom);
    }];
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTwo.layer.masksToBounds = YES;
    btnTwo.layer.cornerRadius = 15;
//    btnTwo.layer.borderWidth = 1;
//    btnTwo.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [btnTwo setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [btnTwo setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.view addSubview:btnTwo];
    [btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY).offset(20*KAdaptiveRateWidth+64);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnTwo addTarget:self action:@selector(btnTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fmImageTwo"]];
    [btnTwo addSubview:imageTwo];
    [imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnTwo.mas_centerY);
        make.left.equalTo(btnTwo.mas_left).offset(15*KAdaptiveRateWidth);
        make.width.mas_equalTo(80*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UILabel *titleTwo = [[UILabel alloc] init];
    [btnTwo addSubview:titleTwo];
    titleTwo.text = @"统计";
    titleTwo.textColor = GRAY70;
    titleTwo.font = [UIFont systemFontOfSize:17];
    [titleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageTwo.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(btnTwo.mas_top).offset(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(18*KAdaptiveRateWidth);
    }];
    
    UIImageView *swordTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [btnTwo addSubview:swordTwo];
    [swordTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnTwo.mas_centerY);
        make.right.equalTo(btnTwo.mas_right).offset(-7*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
        make.width.mas_equalTo(8*KAdaptiveRateWidth);
    }];
    
    UILabel *contentTwo = [[UILabel alloc] init];
    [btnTwo addSubview:contentTwo];
    contentTwo.text = @"可进行查看企业员工的考勤等统计数据。";
    contentTwo.textColor = GRAY110;
    contentTwo.numberOfLines = 3;
    contentTwo.font = [UIFont systemFontOfSize:13];
    [contentTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageTwo.mas_right).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordTwo.mas_left).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(imageTwo.mas_bottom);
    }];
    
    
}
- (void)btnOneClick:(UIButton *)sender {
    paySetViewController *paySetVC = [paySetViewController new];
    [self.navigationController pushViewController:paySetVC animated:YES];
}
- (void)btnTwoClick:(UIButton *)sender {
    [MBProgressHUD showToastText:@"功能敬请期待!"];
//    StatisticsViewController *StatisticsVC = [StatisticsViewController new];
//    [self.navigationController pushViewController:StatisticsVC animated:YES];
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
