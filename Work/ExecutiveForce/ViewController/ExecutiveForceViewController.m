//
//  ExecutiveForceViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/26.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExecutiveForceViewController.h"
#import "ExecuOneCell.h"
#import "ExecuTwoCell.h"

#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"

#import "ExecutiveResultViewController.h"
#import "chooseViewController.h"
#import "ContactModel.h"

#import "chooseDeptViewController.h"
#import "DeptModel.h"

#import "ExeResultViewController.h"

@interface ExecutiveForceViewController ()<UITableViewDelegate,UITableViewDataSource,SelectDateTimeDelegate>

{
    DateTimeSelectView *_dateTimeSelectView;
    LoginPeopleModel * loginPeople;
}

@property(nonatomic,strong)UITableView * exeForceTableview;

@property(nonatomic,strong)UIButton * sureSearchBtn;

@property(nonatomic,strong)NSMutableArray * personArray;

@property(nonatomic,strong)NSMutableArray * deptArray;

@property(nonatomic,strong)NSString * mechName;
@property(nonatomic,strong)NSString * realName;

@property(nonatomic,strong)NSString * mechId;
@property(nonatomic,strong)NSString * deptId;
@property(nonatomic,strong)NSString * userId;
@property(nonatomic,strong)NSString * startTime;
@property(nonatomic,strong)NSString * endTime;

@property(nonatomic,strong)NSString * MstartTime;
@property(nonatomic,strong)NSString * MendTime;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *leftYearLB;

@property (nonatomic, strong) UILabel *leftMonthLB;

@property (nonatomic, strong) UILabel *leftDayLB;

@property (nonatomic, strong) UILabel *rightYearLB;

@property (nonatomic, strong) UILabel *rightMonthLB;

@property (nonatomic, strong) UILabel *rightDayLB;

@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentDay;

@end

@implementation ExecutiveForceViewController

static NSString *startLTime;
static NSString *endRTime;

static NSInteger temp;

- (void)viewDidLoad {
    [super viewDidLoad];
    loginPeople = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];

    self.mechName = @"公司";
    self.realName = @"员工";
    
    self.navigationItem.title = @"执行力";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    startLTime = @"点击选择";
    endRTime = @"点击选择";
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    _year = [components year];
    _month = [components month];
    _currentDay = [components day];

    _day = 1;
    _currentYear = _year;
    _currentMonth = _month;
//    _currentDay = _day;
    self.startTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld",_currentYear,_currentMonth,_day];
    self.MstartTime = self.startTime;
    self.endTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld",_currentYear,_currentMonth,_currentDay];
    self.MendTime = self.endTime;
    [self setupView];
    
    // 选择时间界面
    
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMdd"];
    _dateTimeSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
}
- (void)tapBgView {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}
- (void)setupView {
    //0aad06
    UIView *dateView = [[UIView alloc]init];
    [self.view addSubview:dateView];
    dateView.layer.borderWidth = 1.3;
    dateView.layer.borderColor = kMyColor(169, 210, 202).CGColor;
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NaviHeight+16);
        make.left.equalTo(self.view.mas_left).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-5);
        make.height.mas_equalTo(35);
    }];
    
    UIButton *leftDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateView addSubview:leftDateBtn];
    leftDateBtn.tag = 310;
    [leftDateBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftDateBtn.frame = CGRectMake(0, 0, kScreenWidth/2.0-5, 35);
    
    UIButton *rightDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateView addSubview:rightDateBtn];
    rightDateBtn.tag = 320;
    [rightDateBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightDateBtn.frame = CGRectMake((kScreenWidth-10)/2.0, 0, (kScreenWidth-10)/2.0, 35);
    
    
    
    UILabel *startTimeLb = [[UILabel alloc]init];
    [leftDateBtn addSubview:startTimeLb];
    startTimeLb.text = @"开始日期";
    startTimeLb.textColor = GRAY110;
    startTimeLb.font = [UIFont systemFontOfSize:10];
    if (kScreenWidth > 320) {
        [startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftDateBtn.mas_left).offset(5*KAdaptiveRateWidth);
            make.centerY.equalTo(leftDateBtn.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    } else {
        [startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftDateBtn.mas_left).offset(5);
            make.centerY.equalTo(leftDateBtn.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    }
    
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"双下"]];
    leftImage.backgroundColor = VIEW_BASE_COLOR;
    leftImage.userInteractionEnabled = NO;
    leftImage.contentMode = UIViewContentModeScaleAspectFill;
    leftImage.frame = CGRectMake(17, NaviHeight+1, 28, 28);
//    CGPoint p = leftImage.center;
//    p.x = startTimeLb.center.x;
//    leftImage.center = p;
    [self.view addSubview:leftImage];
    
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"双下"]];
    rightImage.backgroundColor = VIEW_BASE_COLOR;
    rightImage.userInteractionEnabled = NO;
    rightImage.contentMode = UIViewContentModeScaleAspectFill;
    rightImage.frame = CGRectMake(kScreenWidth/2.0+12, NaviHeight+1, 28, 28);
    [self.view addSubview:rightImage];
    
    UILabel *dayLBOne = [[UILabel alloc]init];
    [leftDateBtn addSubview:dayLBOne];
    dayLBOne.text = @"日";
    dayLBOne.font = [UIFont systemFontOfSize:13];
    if (kScreenWidth > 320) {
        [dayLBOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftDateBtn.mas_right).offset(-10*KAdaptiveRateWidth);
            make.centerY.equalTo(leftDateBtn.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    } else {
        [dayLBOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftDateBtn.mas_right).offset(0);
            make.centerY.equalTo(leftDateBtn.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    }
    
    
    
    self.leftDayLB = [[UILabel alloc]init];
    [leftDateBtn addSubview:self.leftDayLB];
    self.leftDayLB.text = @"01";
    self.leftDayLB.textAlignment = NSTextAlignmentCenter;
    self.leftDayLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [self.leftDayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dayLBOne.mas_left).offset(0);
        make.centerY.equalTo(leftDateBtn.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *monthLBOne = [[UILabel alloc]init];
    [leftDateBtn addSubview:monthLBOne];
    monthLBOne.text = @"月";
    monthLBOne.font = [UIFont systemFontOfSize:13];
    [monthLBOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftDayLB.mas_left).offset(0);
        make.centerY.equalTo(leftDateBtn.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    self.leftMonthLB = [[UILabel alloc]init];
    [leftDateBtn addSubview:self.leftMonthLB];
    self.leftMonthLB.text = [NSString stringWithFormat:@"%ld",_currentMonth];
    if (_currentMonth < 10) {
        self.leftMonthLB.text = [NSString stringWithFormat:@"0%ld",_currentMonth];
    }
    self.leftMonthLB.textAlignment = NSTextAlignmentCenter;
    self.leftMonthLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [self.leftMonthLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(monthLBOne.mas_left).offset(0);
        make.centerY.equalTo(leftDateBtn.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *yearLBOne = [[UILabel alloc]init];
    [leftDateBtn addSubview:yearLBOne];
    yearLBOne.text = @"年";
    yearLBOne.font = [UIFont systemFontOfSize:13];
    [yearLBOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.leftMonthLB.mas_left).offset(0);
        make.centerY.equalTo(leftDateBtn.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    self.leftYearLB = [[UILabel alloc]init];
    [leftDateBtn addSubview:self.leftYearLB];
    self.leftYearLB.text = [NSString stringWithFormat:@"%ld",_year];
    self.leftYearLB.textAlignment = NSTextAlignmentCenter;
    self.leftYearLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [self.leftYearLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yearLBOne.mas_left).offset(0);
        make.centerY.equalTo(leftDateBtn.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    
    
    
    
    UILabel *endTimeLb = [[UILabel alloc]init];
    [dateView addSubview:endTimeLb];
    endTimeLb.text = @"结束日期";
    endTimeLb.textColor = GRAY110;
    endTimeLb.font = [UIFont systemFontOfSize:10];
    
    if (kScreenWidth > 320) {
        [endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightDateBtn.mas_left).offset(5*KAdaptiveRateWidth);
            make.centerY.equalTo(dateView.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    } else {
        [endTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(rightDateBtn.mas_left).offset(5);
            make.centerY.equalTo(dateView.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    }
    
    
    UILabel *dayLBTwo = [[UILabel alloc]init];
    [dateView addSubview:dayLBTwo];
    dayLBTwo.text = @"日";
    dayLBTwo.font = [UIFont systemFontOfSize:13];
    if (kScreenWidth > 320) {
        [dayLBTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightDateBtn.mas_right).offset(-10*KAdaptiveRateWidth);
            make.centerY.equalTo(dateView.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    }else {
        [dayLBTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightDateBtn.mas_right).offset(0);
            make.centerY.equalTo(dateView.mas_centerY);
            make.height.mas_equalTo(35);
        }];
    }
    
    
    self.rightDayLB = [[UILabel alloc]init];
    [dateView addSubview:self.rightDayLB];
    self.rightDayLB.text = [NSString stringWithFormat:@"%ld",_currentDay];
    if (_currentDay < 10) {
        self.rightDayLB.text = [NSString stringWithFormat:@"0%ld",_currentDay];
    }
    self.rightDayLB.textAlignment = NSTextAlignmentCenter;
    self.rightDayLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [self.rightDayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dayLBTwo.mas_left).offset(0);
        make.centerY.equalTo(dateView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *monthLBTwo = [[UILabel alloc]init];
    [dateView addSubview:monthLBTwo];
    monthLBTwo.text = @"月";
    monthLBTwo.font = [UIFont systemFontOfSize:13];
    [monthLBTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightDayLB.mas_left).offset(0);
        make.centerY.equalTo(dateView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    self.rightMonthLB = [[UILabel alloc]init];
    [dateView addSubview:self.rightMonthLB];
    self.rightMonthLB.text = @"06";
    self.rightMonthLB.text = [NSString stringWithFormat:@"%ld",_currentMonth];
    if (_currentMonth < 10) {
        self.rightMonthLB.text = [NSString stringWithFormat:@"0%ld",_currentMonth];
    }
    self.rightMonthLB.textAlignment = NSTextAlignmentCenter;
    self.rightMonthLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [self.rightMonthLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(monthLBTwo.mas_left).offset(0);
        make.centerY.equalTo(dateView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    UILabel *yearLBTwo = [[UILabel alloc]init];
    [dateView addSubview:yearLBTwo];
    yearLBTwo.text = @"年";
    yearLBTwo.font = [UIFont systemFontOfSize:13];
    [yearLBTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightMonthLB.mas_left).offset(0);
        make.centerY.equalTo(dateView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    self.rightYearLB = [[UILabel alloc]init];
    [dateView addSubview:self.rightYearLB];
    self.rightYearLB.text = [NSString stringWithFormat:@"%ld",_currentYear];
    self.rightYearLB.textAlignment = NSTextAlignmentCenter;
    self.rightYearLB.font = [UIFont systemFontOfSize:14 weight:0.2];
    [self.rightYearLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yearLBTwo.mas_left).offset(0);
        make.centerY.equalTo(dateView.mas_centerY);
        make.height.mas_equalTo(35);
    }];
    
    [self.view layoutIfNeeded];
    
    CGRect rectOne = self.leftDayLB.frame;
    [self.leftDayLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rectOne.size.width *KAdaptiveRateWidth+2);
    }];
    CGRect rectTwo = self.leftMonthLB.frame;
    [self.leftMonthLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rectTwo.size.width *KAdaptiveRateWidth+2);
    }];
    CGRect rectThree = self.leftYearLB.frame;
    [self.leftYearLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rectThree.size.width *KAdaptiveRateWidth+4);
    }];
    
    CGRect rectFour = self.rightDayLB.frame;
    [self.rightDayLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rectFour.size.width *KAdaptiveRateWidth+2);
    }];
    CGRect rectFive = self.rightMonthLB.frame;
    [self.rightMonthLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rectFive.size.width *KAdaptiveRateWidth+2);
    }];
    CGRect rectSix = self.rightYearLB.frame;
    [self.rightYearLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rectSix.size.width *KAdaptiveRateWidth+4);
    }];
    
    [self.view layoutIfNeeded];
    
    
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    btnOne.layer.masksToBounds = YES;
    btnOne.layer.cornerRadius = 15;
    [btnOne setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [btnOne setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.view addSubview:btnOne];
    [btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-100*KAdaptiveRateWidth+64);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnOne addTarget:self action:@selector(btnOneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *imageOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"executiveOne"]];
    [btnOne addSubview:imageOne];
    [imageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnOne.mas_centerY);
        make.left.equalTo(btnOne.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(100*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UIImageView *swordOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [btnOne addSubview:swordOne];
    [swordOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnOne.mas_centerY);
        make.right.equalTo(btnOne.mas_right).offset(-7*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
        make.width.mas_equalTo(8*KAdaptiveRateWidth);
    }];
    
    UILabel *titleOne = [[UILabel alloc] init];
    [btnOne addSubview:titleOne];
    titleOne.text = @"Company";
    titleOne.textColor = GRAY70;
    titleOne.textAlignment = NSTextAlignmentCenter;
    titleOne.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    [titleOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageOne.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(btnOne.mas_top).offset(30*KAdaptiveRateWidth);
        make.right.equalTo(swordOne.mas_left).offset(-10*KAdaptiveRateWidth);
        make.height.mas_equalTo(22*KAdaptiveRateWidth);
    }];
    
    
    
    UILabel *contentOne = [[UILabel alloc] init];
    [btnOne addSubview:contentOne];
    contentOne.text = @"公司";
    contentOne.textColor = GRAY70;
    contentOne.textAlignment = NSTextAlignmentCenter;
    contentOne.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    [contentOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageOne.mas_right).offset(15*KAdaptiveRateWidth);
        //make.top.equalTo(titleOne.mas_bottom).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordOne.mas_left).offset(-10*KAdaptiveRateWidth);
        make.top.equalTo(titleOne.mas_bottom).offset(10*KAdaptiveRateWidth);
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
        make.centerY.equalTo(self.view.mas_centerY).offset(64-10*KAdaptiveRateWidth);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnTwo addTarget:self action:@selector(btnTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"executiveTwo"]];
    [btnTwo addSubview:imageTwo];
    [imageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnTwo.mas_centerY);
        make.left.equalTo(btnTwo.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(100*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    
    UIImageView *swordTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [btnTwo addSubview:swordTwo];
    [swordTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnTwo.mas_centerY);
        make.right.equalTo(btnTwo.mas_right).offset(-7*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
        make.width.mas_equalTo(8*KAdaptiveRateWidth);
    }];
    
    UILabel *titleTwo = [[UILabel alloc] init];
    [btnTwo addSubview:titleTwo];
    titleTwo.text = @"Department";
    titleTwo.textColor = GRAY70;
    titleTwo.textAlignment = NSTextAlignmentCenter;
    titleTwo.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    [titleTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageTwo.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(btnTwo.mas_top).offset(30*KAdaptiveRateWidth);
        make.right.equalTo(swordTwo.mas_left).offset(-10*KAdaptiveRateWidth);
        make.height.mas_equalTo(22*KAdaptiveRateWidth);
    }];
    
    
    UILabel *contentTwo = [[UILabel alloc] init];
    [btnTwo addSubview:contentTwo];
    contentTwo.text = @"部门";
    contentTwo.textColor = GRAY70;
    contentTwo.textAlignment = NSTextAlignmentCenter;
    contentTwo.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    [contentTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageTwo.mas_right).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordTwo.mas_left).offset(-10*KAdaptiveRateWidth);
        make.top.equalTo(titleTwo.mas_bottom).offset(10*KAdaptiveRateWidth);
    }];
    
    UIButton *btnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThree.layer.masksToBounds = YES;
    btnThree.layer.cornerRadius = 15;
    //    btnTwo.layer.borderWidth = 1;
    //    btnTwo.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
    [btnThree setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [btnThree setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.view addSubview:btnThree];
    [btnThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(130*KAdaptiveRateWidth + 64);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(270*KAdaptiveRateWidth);
        make.height.mas_equalTo(110*KAdaptiveRateWidth);
    }];
    [btnThree addTarget:self action:@selector(btnThreeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageThree = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"executiveThree"]];
    [btnThree addSubview:imageThree];
    [imageThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnThree.mas_centerY);
        make.left.equalTo(btnThree.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(100*KAdaptiveRateWidth);
        make.height.mas_equalTo(80*KAdaptiveRateWidth);
    }];
    
    UIImageView *swordThree = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（右）"]];
    [btnThree addSubview:swordThree];
    [swordThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnThree.mas_centerY);
        make.right.equalTo(btnThree.mas_right).offset(-7*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
        make.width.mas_equalTo(8*KAdaptiveRateWidth);
    }];
    
    UILabel *titleThree = [[UILabel alloc] init];
    [btnThree addSubview:titleThree];
    titleThree.text = @"Staff";
    titleThree.textColor = GRAY70;
    titleThree.textAlignment = NSTextAlignmentCenter;
    titleThree.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    [titleThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageThree.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(btnThree.mas_top).offset(30*KAdaptiveRateWidth);
        make.right.equalTo(swordThree.mas_left).offset(-10*KAdaptiveRateWidth);
        make.height.mas_equalTo(22*KAdaptiveRateWidth);
    }];
    
    
    UILabel *contentThree = [[UILabel alloc] init];
    [btnThree addSubview:contentThree];
    contentThree.text = @"员工";
    contentThree.textColor = GRAY70;
    contentThree.textAlignment = NSTextAlignmentCenter;
    contentThree.font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    [contentThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageThree.mas_right).offset(15*KAdaptiveRateWidth);
        make.right.equalTo(swordThree.mas_left).offset(-10*KAdaptiveRateWidth);
        make.top.equalTo(titleThree.mas_bottom).offset(10*KAdaptiveRateWidth);
    }];
}

- (void)btnOneClick:(UIButton *)sender {
    if (self.MyUserInfoModel.level != 1) {
        [MBProgressHUD showError:@"您暂无此权限"];
    } else {
        
        self.mechId = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
        self.deptId = @"";
        self.userId = @"";
        [self sureSearchOnClick];
    }
}
- (void)btnTwoClick:(UIButton *)sender {
    if (loginPeople.level >2) {
        [MBProgressHUD showError:@"您暂无此权限"];
    } else {
        if (loginPeople.level == 1) {
            chooseDeptViewController * chooseDeptVC = [[chooseDeptViewController alloc]init];
            chooseDeptVC.startTime = self.startTime;
            chooseDeptVC.endTime = self.endTime;
            
            [chooseDeptVC returnMutableArray:^(NSMutableArray *returnMutableArray) {
                self.deptArray = returnMutableArray;
                
                DeptModel * model = self.deptArray[0];
                
                self.deptId = [NSString stringWithFormat:@"%ld",model.deptId];
                self.mechId = @"";
                self.userId = @"";
            }];
            
            [self.navigationController pushViewController:chooseDeptVC animated:YES];
            
        } else {
#pragma mark  ---- 这里是部门负责人查看自己部门的执行力
            
            chooseDeptViewController * chooseDeptVC = [[chooseDeptViewController alloc]init];
            chooseDeptVC.seType = @"1";
            chooseDeptVC.deptId = [loginPeople.dept_id integerValue];
            chooseDeptVC.startTime = self.startTime;
            chooseDeptVC.endTime = self.endTime;
            [chooseDeptVC returnMutableArray:^(NSMutableArray *returnMutableArray) {
                self.deptArray = returnMutableArray;
                DeptModel * model = self.deptArray[0];
                self.deptId = [NSString stringWithFormat:@"%ld",model.deptId];
                self.mechId = @"";
                self.userId = @"";
//                [btn2 setTitle:[NSString stringWithFormat:@"%@",model.deptName] forState:UIControlStateNormal];
            }];
            [self.navigationController pushViewController:chooseDeptVC animated:YES];
            

        }
    }
}
- (void)btnThreeClick:(UIButton *)sender {
    if (loginPeople.level == 3) {
#pragma mark  ---- 这里是只能查看自己的执行力
        
        self.userId = [NSString stringWithFormat:@"%ld",loginPeople.userId];
        self.mechId = @"";
        self.deptId = @"";
        [self sureSearchOnClick];
        
    } else if (loginPeople.level == 1) {
#pragma mark == 这里是机构创始人查看全部员工的执行力
        if (self.startTime.length == 0 || self.endTime.length == 0) {
            
            JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertV show] ;
        }else{
            UIButton * btn1 = [_exeForceTableview viewWithTag:100];
            btn1.backgroundColor = VIEW_BASE_COLOR;
            self.mechName = @"公司";
            [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            
            UIButton * btn2 = [_exeForceTableview viewWithTag:200];
            btn2.backgroundColor = VIEW_BASE_COLOR;
            [btn2 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            
            UIButton * btn3 = [_exeForceTableview viewWithTag:300];
            btn3.backgroundColor = TABBAR_BASE_COLOR;
            [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
            chooseViewController * choosePeople = [[chooseViewController alloc]init];
            choosePeople.seType = 1;
            choosePeople.limited = 1;
            choosePeople.isExecutive = 1;
            choosePeople.startTime = self.startTime;
            choosePeople.endTime = self.endTime;
            [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
                self.personArray = returnMutableArray;
                
                ContactModel * model = self.personArray[0];
                
                self.userId = [NSString stringWithFormat:@"%ld",model.userId];
                self.mechId = @"";
                self.deptId = @"";
                [btn3 setTitle:[NSString stringWithFormat:@"%@",model.realName] forState:UIControlStateNormal];
                
            }];
            
            [self.navigationController pushViewController:choosePeople animated:YES];
        }
    } else {
#pragma mark -- 这里是部门负责人查看自己部门员工的执行力
        if (self.startTime.length == 0 || self.endTime.length == 0) {
            
            JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertV show] ;
        }else{
            UIButton * btn1 = [_exeForceTableview viewWithTag:100];
            btn1.backgroundColor = VIEW_BASE_COLOR;
            self.mechName = @"公司";
            [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            
            UIButton * btn2 = [_exeForceTableview viewWithTag:200];
            btn2.backgroundColor = VIEW_BASE_COLOR;
            [btn2 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            
            UIButton * btn3 = [_exeForceTableview viewWithTag:300];
            btn3.backgroundColor = TABBAR_BASE_COLOR;
            [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self getDetpIdArrWithDeptId:loginPeople.dept_id];
            //                chooseViewController * choosePeople = [[chooseViewController alloc]init];
            //                choosePeople.seType = 1;
            //                choosePeople.limited = 3;
            //                choosePeople.deptId = [loginPeople.dept_id integerValue];
            //                [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
            //                    self.personArray = returnMutableArray;
            //
            //                    ContactModel * model = self.personArray[0];
            //
            //                    self.userId = [NSString stringWithFormat:@"%ld",model.userId];
            //                    self.mechId = @"";
            //                    self.deptId = @"";
            //                    [btn3 setTitle:[NSString stringWithFormat:@"%@",model.realName] forState:UIControlStateNormal];
            //
            //                }];
            //
            //                [self.navigationController pushViewController:choosePeople animated:YES];
            
        }
    }
}
-(void)creatUI{
    
    _exeForceTableview = [[UITableView alloc]init];
    _exeForceTableview.delegate = self;
    _exeForceTableview.dataSource = self;
    _exeForceTableview.bounces = NO;
    
    _exeForceTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_exeForceTableview];
    
    [_exeForceTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 60, 0));
    }];
    
    [_exeForceTableview registerClass:[ExecuOneCell class] forCellReuseIdentifier:@"ExecuOneCellID"];
    [_exeForceTableview registerClass:[ExecuTwoCell class] forCellReuseIdentifier:@"ExecuTwoCellID"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.exeForceTableview setTableFooterView:view];
    
    _sureSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40)];
    [_sureSearchBtn setBackgroundColor:TABBAR_BASE_COLOR];
    [_sureSearchBtn setTitle:@"确认查询" forState:UIControlStateNormal];
    [_sureSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureSearchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _sureSearchBtn.layer.cornerRadius = 5.0;
    _sureSearchBtn.layer.masksToBounds = YES;
    [self.view addSubview:_sureSearchBtn];
    [_sureSearchBtn addTarget:self action:@selector(sureSearchOnClick) forControlEvents:UIControlEventTouchUpInside];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 30*KAdaptiveRateWidth;
    } else {
        return 60*KAdaptiveRateWidth;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.row == 1) {
        
        ExecuOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExecuOneCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ExecuOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExecuOneCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.execuBtn setTitle:self.mechName forState:UIControlStateNormal];
        
        cell.execuBtn.tag = 100;
        
        [cell.execuBtn addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];
               
        return cell;
    }else if (indexPath.row == 2){
        
        ExecuOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExecuOneCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ExecuOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExecuOneCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.execuBtn setTitle:@"部门" forState:UIControlStateNormal];
        cell.execuBtn.tag = 200;
        
        [cell.execuBtn addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
    }else if (indexPath.row == 3){
        
        ExecuOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExecuOneCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ExecuOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExecuOneCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell.execuBtn setTitle:self.realName forState:UIControlStateNormal];
        cell.execuBtn.tag = 300;
        
        [cell.execuBtn addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];

   
        return cell;

    }else if (indexPath.row == 4){
        
        ExecuTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ExecuTwoCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[ExecuTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExecuTwoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.leftBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.leftBtn setTitle:startLTime forState:UIControlStateNormal];
        cell.leftBtn.tag = 310;
        
        [cell.rightBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightBtn setTitle:endRTime forState:UIControlStateNormal];
        cell.rightBtn.tag = 320;
        
        return cell;
    }

    return cell;
}

-(void)selectOnClick:(UIButton *)sender{
    
    if (sender.tag == 100) {
        if (loginPeople.level != 1) {
            [MBProgressHUD showError:@"您暂无此权限"];
        } else {
            if (self.startTime.length == 0 || self.endTime.length == 0) {
                
                JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                [alertV show] ;
            }else{
                UIButton * btn1 = [_exeForceTableview viewWithTag:100];
                
                btn1.backgroundColor = TABBAR_BASE_COLOR;
                [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.mechName = loginPeople.mechName;
                self.mechId = [NSString stringWithFormat:@"%ld",loginPeople.jrqMechanismId];
                self.deptId = @"";
                self.userId = @"";
                
                UIButton * btn2 = [_exeForceTableview viewWithTag:200];
                btn2.backgroundColor = VIEW_BASE_COLOR;
                [btn2 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn3 = [_exeForceTableview viewWithTag:300];
                btn3.backgroundColor = VIEW_BASE_COLOR;
                [btn3 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            }
        }
    }
    if (sender.tag == 200) {
        if (loginPeople.level >2) {
            [MBProgressHUD showError:@"您暂无此权限"];
        } else {
            if (loginPeople.level == 1) {
                if (self.startTime.length == 0 || self.endTime.length == 0) {
                    
                    JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    
                    [alertV show] ;
                }else{
                    UIButton * btn1 = [_exeForceTableview viewWithTag:100];
                    btn1.backgroundColor = VIEW_BASE_COLOR;
                    self.mechName = @"公司";
                    self.realName = @"员工";
                    [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                    
                    UIButton * btn2 = [_exeForceTableview viewWithTag:200];
                    btn2.backgroundColor = TABBAR_BASE_COLOR;
                    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    UIButton * btn3 = [_exeForceTableview viewWithTag:300];
                    btn3.backgroundColor = VIEW_BASE_COLOR;
                    [btn3 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                    
                    chooseDeptViewController * chooseDeptVC = [[chooseDeptViewController alloc]init];
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"YYYY-MM-dd"];
                    NSDate *dt1 = [[NSDate alloc] init];
                    NSDate *dt2 = [[NSDate alloc] init];
                    
                    dt1 = [df dateFromString:self.MstartTime];
                    dt2 = [df dateFromString:self.MendTime];
                    
                    NSComparisonResult result = [dt1 compare:dt2];
                    
                    chooseDeptVC.startTime = self.startTime;
                    chooseDeptVC.endTime = self.endTime;
                    
                    [chooseDeptVC returnMutableArray:^(NSMutableArray *returnMutableArray) {
                        self.deptArray = returnMutableArray;
                        
                        DeptModel * model = self.deptArray[0];
                        
                        self.deptId = [NSString stringWithFormat:@"%ld",model.deptId];
                        self.mechId = @"";
                        self.userId = @"";
                        
                        [btn2 setTitle:[NSString stringWithFormat:@"%@",model.deptName] forState:UIControlStateNormal];
                        
                    }];
                    
                    if (result == NSOrderedDescending) {
                        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"您选择的时间有误!" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        
                        [alertV show] ;
                    } else {
                        [self.navigationController pushViewController:chooseDeptVC animated:YES];
                    }
                }
            } else {
#pragma mark  ---- 这里是部门负责人查看自己部门的执行力
                if (self.startTime.length == 0 || self.endTime.length == 0) {
                    
                    JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    
                    [alertV show] ;
                }else{
                    UIButton * btn1 = [_exeForceTableview viewWithTag:100];
                    btn1.backgroundColor = VIEW_BASE_COLOR;
                    self.mechName = @"公司";
                    self.realName = @"员工";

                    [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                    
                    UIButton * btn2 = [_exeForceTableview viewWithTag:200];
                    btn2.backgroundColor = TABBAR_BASE_COLOR;
                    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    UIButton * btn3 = [_exeForceTableview viewWithTag:300];
                    btn3.backgroundColor = VIEW_BASE_COLOR;
                    [btn3 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                    
                    chooseDeptViewController * chooseDeptVC = [[chooseDeptViewController alloc]init];
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    [df setDateFormat:@"YYYY-MM-dd"];
                    NSDate *dt1 = [[NSDate alloc] init];
                    NSDate *dt2 = [[NSDate alloc] init];
                    
                    dt1 = [df dateFromString:self.MstartTime];
                    dt2 = [df dateFromString:self.MendTime];
                    
                    NSComparisonResult result = [dt1 compare:dt2];
                    chooseDeptVC.seType = @"1";
                    chooseDeptVC.deptId = [loginPeople.dept_id integerValue];
                    chooseDeptVC.startTime = self.startTime;
                    chooseDeptVC.endTime = self.endTime;
                    [chooseDeptVC returnMutableArray:^(NSMutableArray *returnMutableArray) {
                        self.deptArray = returnMutableArray;
                        DeptModel * model = self.deptArray[0];
                        self.deptId = [NSString stringWithFormat:@"%ld",model.deptId];
                        self.mechId = @"";
                        self.userId = @"";
                        
                        [btn2 setTitle:[NSString stringWithFormat:@"%@",model.deptName] forState:UIControlStateNormal];
                        
                    }];
                    
                    if (result == NSOrderedDescending) {
                        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"您选择的时间有误!" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                        
                        [alertV show] ;
                    } else {
                        [self.navigationController pushViewController:chooseDeptVC animated:YES];
                    }
                    
                }
            }
        }
    }
    
    if (sender.tag == 300) {
        if (loginPeople.level == 3) {
#pragma mark  ---- 这里是只能查看自己的执行力
            if (self.startTime.length == 0 || self.endTime.length == 0) {
                JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertV show] ;
            }else{
                UIButton * btn1 = [_exeForceTableview viewWithTag:100];
                btn1.backgroundColor = VIEW_BASE_COLOR;
                self.mechName = @"公司";
                [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn2 = [_exeForceTableview viewWithTag:200];
                btn2.backgroundColor = VIEW_BASE_COLOR;
                [btn2 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn3 = [_exeForceTableview viewWithTag:300];
                btn3.backgroundColor = TABBAR_BASE_COLOR;
                [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.realName = loginPeople.realName;
                self.userId = [NSString stringWithFormat:@"%ld",loginPeople.userId];
                self.mechId = @"";
                self.deptId = @"";
                
            }
        } else if (loginPeople.level == 1) {
#pragma mark == 这里是机构创始人查看全部员工的执行力
            if (self.startTime.length == 0 || self.endTime.length == 0) {
                
                JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                [alertV show] ;
            }else{
                UIButton * btn1 = [_exeForceTableview viewWithTag:100];
                btn1.backgroundColor = VIEW_BASE_COLOR;
                self.mechName = @"公司";
                [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn2 = [_exeForceTableview viewWithTag:200];
                btn2.backgroundColor = VIEW_BASE_COLOR;
                [btn2 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn3 = [_exeForceTableview viewWithTag:300];
                btn3.backgroundColor = TABBAR_BASE_COLOR;
                [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
                chooseViewController * choosePeople = [[chooseViewController alloc]init];
                choosePeople.seType = 1;
                choosePeople.limited = 1;
                
                [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
                    self.personArray = returnMutableArray;
                    
                    ContactModel * model = self.personArray[0];
                    
                    self.userId = [NSString stringWithFormat:@"%ld",model.userId];
                    self.mechId = @"";
                    self.deptId = @"";
                    [btn3 setTitle:[NSString stringWithFormat:@"%@",model.realName] forState:UIControlStateNormal];
                    
                }];
                
                [self.navigationController pushViewController:choosePeople animated:YES];
            }
        } else {
#pragma mark -- 这里是部门负责人查看自己部门员工的执行力
            if (self.startTime.length == 0 || self.endTime.length == 0) {
                
                JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                [alertV show] ;
            }else{
                UIButton * btn1 = [_exeForceTableview viewWithTag:100];
                btn1.backgroundColor = VIEW_BASE_COLOR;
                self.mechName = @"公司";
                [btn1 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn2 = [_exeForceTableview viewWithTag:200];
                btn2.backgroundColor = VIEW_BASE_COLOR;
                [btn2 setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                UIButton * btn3 = [_exeForceTableview viewWithTag:300];
                btn3.backgroundColor = TABBAR_BASE_COLOR;
                [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self getDetpIdArrWithDeptId:loginPeople.dept_id];
//                chooseViewController * choosePeople = [[chooseViewController alloc]init];
//                choosePeople.seType = 1;
//                choosePeople.limited = 3;
//                choosePeople.deptId = [loginPeople.dept_id integerValue];
//                [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
//                    self.personArray = returnMutableArray;
//                    
//                    ContactModel * model = self.personArray[0];
//                    
//                    self.userId = [NSString stringWithFormat:@"%ld",model.userId];
//                    self.mechId = @"";
//                    self.deptId = @"";
//                    [btn3 setTitle:[NSString stringWithFormat:@"%@",model.realName] forState:UIControlStateNormal];
//                    
//                }];
//                
//                [self.navigationController pushViewController:choosePeople animated:YES];
                
            }
        }
    }
    
    [_exeForceTableview reloadData];
    
}

-(void)timeOnClicked:(UIButton *)sender{
    
    if (sender.tag == 310) {
        temp = 1;
    }else if (sender.tag == 320){
        temp = 2;
    }
    _dateTimeSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = timeViewRect;
    }];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *time = [NSString stringWithFormat:@"%@",dictDate[@"date"]];
    NSString * timeString = [time substringToIndex:(time.length-9)];
    
    if (temp == 1) {
        
        startLTime = time;
        [_exeForceTableview reloadData];
        
        self.startTime = startLTime;
        
        self.leftDayLB.text = [NSString stringWithFormat:@"%@",dictDate[@"day"]];
        self.leftMonthLB.text = [NSString stringWithFormat:@"%@",dictDate[@"month"]];
        self.leftYearLB.text = [NSString stringWithFormat:@"%@",dictDate[@"year"]];
        
        self.MstartTime = timeString;
        
        if (![Utils isBlankString:self.MstartTime] && ![Utils isBlankString:self.MendTime]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"YYYY-MM-dd"];
            NSDate *dt1 = [[NSDate alloc] init];
            NSDate *dt2 = [[NSDate alloc] init];
            
            dt1 = [df dateFromString:self.MstartTime];
            dt2 = [df dateFromString:self.MendTime];
            
            NSComparisonResult result = [dt1 compare:dt2];
            
            if (result == NSOrderedDescending ) {
                
                NSDate *date = [Utils stringToDate:self.endTime withDateFormat:@"YYYY-MM-dd"];
                NSDate *lastDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//前一天
                self.endTime = [Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd"];
                self.MendTime = self.endTime;
            }
        }
    }
    
    if (temp == 2) {
        
        endRTime = time;
        [_exeForceTableview reloadData];
        self.endTime = endRTime;
        
        self.rightDayLB.text = [NSString stringWithFormat:@"%@",dictDate[@"day"]];
        self.rightMonthLB.text = [NSString stringWithFormat:@"%@",dictDate[@"month"]];
        self.rightYearLB.text = [NSString stringWithFormat:@"%@",dictDate[@"year"]];
        
        self.MendTime = timeString;
        
        if (![Utils isBlankString:self.MstartTime] && ![Utils isBlankString:self.MendTime]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"YYYY-MM-dd"];
            NSDate *dt1 = [[NSDate alloc] init];
            NSDate *dt2 = [[NSDate alloc] init];
            
            dt1 = [df dateFromString:self.MstartTime];
            dt2 = [df dateFromString:self.MendTime];
            
            NSComparisonResult result = [dt1 compare:dt2];
            
            if (result == NSOrderedDescending ) {
                
                NSDate *date = [Utils stringToDate:self.startTime withDateFormat:@"YYYY-MM-dd"];
                NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
                self.startTime = [Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd"];
                self.MstartTime = self.startTime;
            }
        }
        
    }
    
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}
- (void)cancelDate {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}

-(void)getTimeToValue:(NSString *)theTimeStr{
    
//    NSString * timeString = [theTimeStr substringToIndex:(theTimeStr.length-9)];
//    
//    if (temp == 1) {
//        
//        startLTime = theTimeStr;
//        [_exeForceTableview reloadData];
//        
//        self.startTime = startLTime;
//        
//        self.MstartTime = timeString;
//    }
//    
//    if (temp == 2) {
//        
//        endRTime = theTimeStr;
//        [_exeForceTableview reloadData];
//        self.endTime = endRTime;
//        
//        self.MendTime = timeString;
//    }
    
}

-(void)sureSearchOnClick{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"inter"] = @"implementPower";
    
    dic[@"startTime"] = self.startTime;
    
    dic[@"endTime"] = self.endTime;
    
    if (self.mechId.length != 0) {
        dic[@"mechId"] = self.mechId;
    }
    
    if (self.deptId.length != 0) {
        
        dic[@"deptId"] = self.deptId;
    }
    
    if (self.userId.length != 0) {
        
        dic[@"userId"] = self.userId;

    }
    
    NSLog(@"dic:%@",dic);

    [MBProgressHUD showMessage:@"正在加载.."];
    
    [HttpRequestEngine searchExecutiveWithDic:dic completion:^(id obj, NSString *errorStr) {
        
        [MBProgressHUD hideHUD];
        //            NSLog(@"obj == %@",obj);
        if (errorStr == nil) {
            
            NSDictionary * dict = obj;
            
            
            ExeResultViewController * exeResultVC = [[ExeResultViewController alloc]init];
            
            exeResultVC.dataDic = dict;
            
            [self.navigationController pushViewController:exeResultVC animated:YES];
            
            
        }else{
            
            NSLog(@"%@",errorStr);
        }
    }];
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"YYYY-MM-dd"];
//    NSDate *dt1 = [[NSDate alloc] init];
//    NSDate *dt2 = [[NSDate alloc] init];
//    
//    dt1 = [df dateFromString:self.MstartTime];
//    dt2 = [df dateFromString:self.MendTime];
//
//    NSComparisonResult result = [dt1 compare:dt2];
//
//    if (self.startTime.length == 0 || self.endTime.length == 0) {
//        
//        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        
//        [alertV show] ;
//        
//
//    }else if (self.mechId.length == 0 && self.deptId.length == 0 && self.userId.length == 0){
//        
//        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择公司、部门、或人员" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        
//        [alertV show] ;
//
//        
//    } else if (result == NSOrderedDescending ) {
//        
//        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"您选择的时间不合法" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        
//        [alertV show] ;
//        
//    }else{
//        [MBProgressHUD showMessage:@"正在加载.."];
//        
//        [HttpRequestEngine searchExecutiveWithDic:dic completion:^(id obj, NSString *errorStr) {
//            
//            [MBProgressHUD hideHUD];
////            NSLog(@"obj == %@",obj);
//            if (errorStr == nil) {
//                
//                NSDictionary * dict = obj;
//            
//                
//                ExeResultViewController * exeResultVC = [[ExeResultViewController alloc]init];
//                
//                exeResultVC.dataDic = dict;
//                
//                [self.navigationController pushViewController:exeResultVC animated:YES];
//                
//
//            }else{
//                
//                NSLog(@"%@",errorStr);
//            }
//        }];
//    }
}


#pragma mark == 获取子部门ID数组
- (void)getDetpIdArrWithDeptId:(NSString *)deptId {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"inter"] = @"implementPowerDeptId";
    dic[@"deptId"] = deptId;
    [HttpRequestEngine getSonDeptIDWithDic:dic completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            chooseViewController * choosePeople = [[chooseViewController alloc]init];
            choosePeople.seType = 1;
            choosePeople.limited = 5;
            choosePeople.isExecutive = 1;
            choosePeople.startTime = self.startTime;
            choosePeople.endTime = self.endTime;
            choosePeople.deptId = [deptId integerValue];
            choosePeople.deptArr = (NSArray *)obj;
            [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
                self.personArray = returnMutableArray;
                
                ContactModel * model = self.personArray[0];
                
                self.userId = [NSString stringWithFormat:@"%ld",model.userId];
                self.mechId = @"";
                self.deptId = @"";
//                [btn3 setTitle:[NSString stringWithFormat:@"%@",model.realName] forState:UIControlStateNormal];
                
            }];
            
            [self.navigationController pushViewController:choosePeople animated:YES];
        }
        
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
