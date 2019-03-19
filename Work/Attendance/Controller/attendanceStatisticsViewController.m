//
//  attendanceStatisticsViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/14.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceStatisticsViewController.h"
#import "deptAttendanceViewController.h"
@interface attendanceStatisticsViewController ()

@end

@implementation attendanceStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤统计";
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
        make.bottom.equalTo(self.view.mas_centerY).offset(-70*KAdaptiveRateWidth+NaviHeight);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnOne addTarget:self action:@selector(btnOneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attandenceTwo"]];
    [btnOne addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnOne.mas_centerY);
        make.left.equalTo(btnOne.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(100*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UILabel *titleOne = [[UILabel alloc] init];
    [btnOne addSubview:titleOne];
    titleOne.text = @"部门考勤统计";
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
    contentOne.text = @"查看部门成员的考勤记录";
    contentOne.textColor = GRAY110;
    contentOne.numberOfLines = 3;
    contentOne.font = [UIFont systemFontOfSize:13];
    [contentOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageOne.mas_right).offset(15*KAdaptiveRateWidth);
        //make.top.equalTo(titleOne.mas_bottom).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordOne.mas_left).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(btnOne.mas_bottom).offset(-20*KAdaptiveRateWidth);
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
        make.top.equalTo(self.view.mas_centerY).offset(20*KAdaptiveRateWidth+NaviHeight);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnTwo addTarget:self action:@selector(btnTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attandenceOne"]];
    [btnTwo addSubview:imageTwo];
    [imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnTwo.mas_centerY);
        make.left.equalTo(btnTwo.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(100*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UILabel *titleTwo = [[UILabel alloc] init];
    [btnTwo addSubview:titleTwo];
    titleTwo.text = @"我的考勤统计";
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
    contentTwo.text = @"查看自己的考勤情况";
    contentTwo.textColor = GRAY110;
    contentTwo.numberOfLines = 3;
    contentTwo.font = [UIFont systemFontOfSize:13];
    [contentTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageTwo.mas_right).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordTwo.mas_left).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(btnTwo.mas_bottom).offset(-20*KAdaptiveRateWidth);
    }];
    
    
}
- (void)btnOneClick:(UIButton *)sender {
    deptAttendanceViewController *dept = [deptAttendanceViewController new];
    [self.navigationController pushViewController:dept animated:YES];
}
- (void)btnTwoClick:(UIButton *)sender {
    
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
