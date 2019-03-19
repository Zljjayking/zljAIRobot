//
//  calendarViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/9.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "calendarViewController.h"
#import "calendarModel.h"

#define KCol 7
#define KBtnW 44*KAdaptiveRateWidth
#define KBtnH 44*KAdaptiveRateWidth
#define KMaxCount 37
#define KBtnTag 100
#define KTipsW 6*KAdaptiveRateWidth
#define KShowYearsCount 100
#define KMainColor [UIColor colorWithRed:0.0f green:139/255.0f blue:125/255.0f alpha:1.0f]
#define KbackColor [UIColor colorWithRed:173/255.0f green:212/255.0f blue:208/255.0f alpha:1.0f]
@interface calendarViewController ()

@property (nonatomic, strong) NSMutableArray *dateArr;

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, weak) UIView *calendarView;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentMonth;
@property (nonatomic, assign) NSInteger currentDay;
@property (nonatomic, strong) UILabel *YAndMLB;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSMutableArray *JanuaryArr;
@property (nonatomic, strong) NSMutableArray *FebruaryArr;
@property (nonatomic, strong) NSMutableArray *MarchArr;
@property (nonatomic, strong) NSMutableArray *AprilArr;
@property (nonatomic, strong) NSMutableArray *MayArr;
@property (nonatomic, strong) NSMutableArray *JuneArr;
@property (nonatomic, strong) NSMutableArray *JulyArr;
@property (nonatomic, strong) NSMutableArray *AugustArr;
@property (nonatomic, strong) NSMutableArray *SeptemberArr;
@property (nonatomic, strong) NSMutableArray *OctoberArr;
@property (nonatomic, strong) NSMutableArray *NovemberArr;
@property (nonatomic, strong) NSMutableArray *DecemberArr;

@property (nonatomic, strong) UIButton *setBtn;
@end

@implementation calendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤日期管理";
    
    self.dateArr = [NSMutableArray arrayWithCapacity:0];
    
    self.JanuaryArr = [NSMutableArray arrayWithCapacity:0];
    self.FebruaryArr = [NSMutableArray arrayWithCapacity:0];
    self.MarchArr = [NSMutableArray arrayWithCapacity:0];
    self.AprilArr = [NSMutableArray arrayWithCapacity:0];
    self.MayArr = [NSMutableArray arrayWithCapacity:0];
    self.JuneArr = [NSMutableArray arrayWithCapacity:0];
    self.JulyArr = [NSMutableArray arrayWithCapacity:0];
    self.AugustArr = [NSMutableArray arrayWithCapacity:0];
    self.SeptemberArr = [NSMutableArray arrayWithCapacity:0];
    self.OctoberArr = [NSMutableArray arrayWithCapacity:0];
    self.NovemberArr = [NSMutableArray arrayWithCapacity:0];
    self.DecemberArr = [NSMutableArray arrayWithCapacity:0];
    
    self.YAndMLB = [[UILabel alloc]init];
    [self.view addSubview:self.YAndMLB];
    self.YAndMLB.textColor = kMyColor(208, 88, 79);
    self.YAndMLB.font = [UIFont systemFontOfSize:18];
    [self.YAndMLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NaviHeight+20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(30);
    }];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBtn setTitleColor:GRAY70 forState:UIControlStateNormal];
    
    [self.leftBtn addTarget:self action:@selector(preBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.centerY.equalTo(self.YAndMLB.mas_centerY);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lastMonth"]];
    [self.leftBtn addSubview:leftImage];
    leftImage.frame = CGRectMake(10, 10, 20, 20);
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setTitleColor:GRAY70 forState:UIControlStateNormal];

    [self.rightBtn addTarget:self action:@selector(nextBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.centerY.equalTo(self.YAndMLB.mas_centerY);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    UIImageView *rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nextMonth"]];
    [self.rightBtn addSubview:rightImage];
    rightImage.frame = CGRectMake(10, 10, 20, 20);
    
    //获取当前时间
    [self getCurrentDate];
    
    [self setDefaultInfo];
    
    [self setupView];
    
    [self reloadData];
    // Do any additional setup after loading the view.
}

//上一月按钮点击事件
- (void)preBtnOnClick
{
    if (_month == _currentMonth && _year == _currentYear) {
        self.leftBtn.hidden = YES;
        return;
    }else {
        self.rightBtn.hidden = NO;
        _month --;
    }
    
    [self reloadData];
}

//下一月按钮点击事件
- (void)nextBtnOnClick
{
    if (_month == 11) {
        self.rightBtn.hidden = YES;
    }
    if (_month == 12 ) {
#pragma mark == 这里是否需要两年的时间 是就 _year == _currentYear + 1
        if (_year == _currentYear ) {
            
            return;
        } else {
            _year ++;
        }
    }else {
        self.leftBtn.hidden = NO;
        _month ++;
    }
    
    [self reloadData];
}

- (void)setDefaultInfo
{
    _currentYear = _year;
    _currentMonth = _month;
    _currentDay = _day;
}
- (void)setupView {
    self.weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, NaviHeight+60, kScreenWidth, kScreenHeight-NaviHeight-60)];
    [self.view addSubview:self.baseView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatControl];
}
- (void)creatControl{
    
    //星期标签
    for (int i = 0; i < self.weekArray.count; i++) {
        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake( KTipsW + KBtnH * i, 10, KBtnH, KBtnH)];
        week.textAlignment = NSTextAlignmentCenter;
        week.text = self.weekArray[i];
        week.textColor = GRAY110;
//        week.font = [UIFont fontWithName:@"MicrosoftYaHei" size:16];//PingFangHK-Regular  MicrosoftYaHei
        [self.baseView addSubview:week];
    }
    
    //日历核心视图
    UIView *calendarView = [[UIView alloc] initWithFrame:CGRectMake(KTipsW, KBtnH + 10, KBtnW * 7, (KBtnH+10) * 6-10)];
    [self.baseView addSubview:calendarView];
    self.calendarView = calendarView;
    
    //每一个日期用一个按钮去创建，当一个月的第一天是星期六并且有31天时为最多个数，5行零2个，共37个
    for (int i = 0; i < KMaxCount; i++) {
        CGFloat btnX = i % KCol * KBtnW+2.5+2*KAdaptiveRateWidth;
        CGFloat btnY = i / KCol * (KBtnH+10)+2.5+2*KAdaptiveRateWidth;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, KBtnW-5-4*KAdaptiveRateWidth, KBtnH-5-4*KAdaptiveRateWidth)];
        btn.tag = i + KBtnTag;
        btn.layer.cornerRadius = (KBtnW-5-4*KAdaptiveRateWidth) * 0.5;
        btn.layer.masksToBounds = YES;
//        [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
        [btn setTitleColor:GRAY110 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:KMainColor forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:KbackColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:KbackColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(dateBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [calendarView addSubview:btn];
    }

    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.baseView addSubview:self.setBtn];
    self.setBtn.layer.masksToBounds = YES;
    self.setBtn.layer.cornerRadius = 7;
    [self.setBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [self.setBtn setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView.mas_centerX);
        make.top.equalTo(self.calendarView.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(kScreenWidth-100*KAdaptiveRateWidth);
        make.height.mas_equalTo(45);
    }];
    self.setBtn.hidden = YES;
}

//刷新数据
- (void)reloadData
{
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld",_year,_month];
    if (_month < 10) {
        timeStr = [NSString stringWithFormat:@"%ld-0%ld",_year,_month];
    }
    
    NSString *mechId = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    
    
    
    [HttpRequestEngine getCalendarWithTime:timeStr mech_id:mechId completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *arr = obj;
            [self.dateArr addObjectsFromArray:arr];
//            [self.dateArr removeAllObjects];
//            for (int i=0; i<=arr.count; i++) {
//                if (i == arr.count) {
//                    [self reloadDate];
//                } else {
//                    NSDictionary *dic = arr[i];
//                    calendarModel *model = [calendarModel requestWithDic:dic];
//                    [self.dateArr addObject:model];
//                }
//            }

            switch (_month) {
                case 1:
                {
                    if (!self.JanuaryArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.JanuaryArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 2:
                {
                    if (!self.FebruaryArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.FebruaryArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 3:
                {
                    if (!self.MarchArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.MarchArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 4:
                {
                    if (!self.AprilArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.AprilArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 5:
                {
                    if (!self.MayArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.MayArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 6:
                {
                    if (!self.JuneArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.JuneArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 7:
                {
                    if (!self.JulyArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.JulyArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 8:
                {
                    if (!self.AugustArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.AugustArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 9:
                {
                    if (!self.SeptemberArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.SeptemberArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 10:
                {
                    if (!self.OctoberArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.OctoberArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 11:
                {
                    if (!self.NovemberArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.NovemberArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                case 12:
                {
                    if (!self.DecemberArr.count) {
                        for (int i=0; i<=arr.count; i++) {
                            if (i == arr.count) {
                                [self reloadDate];
                            } else {
                                NSDictionary *dic = arr[i];
                                calendarModel *model = [calendarModel requestWithDic:dic];
                                [self.DecemberArr addObject:model];
                            }
                        }
                    }
                }
                    break;
                default:
                    break;
            }
            [self reloadDate];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (void)reloadDate {
    
    NSInteger totalDays = [self numberOfDaysInMonth];
    NSInteger firstDay = [self firstDayOfWeekInMonth];
    
    self.YAndMLB.text = [NSString stringWithFormat:@"%ld-%ld",_year,_month];
    if (_month < 10) {
        self.YAndMLB.text = [NSString stringWithFormat:@"%ld-0%ld",_year,_month];
    }
    
    for (int i = 0; i < KMaxCount; i++) {
        UIButton *btn = (UIButton *)[self.calendarView viewWithTag:i + KBtnTag];
        btn.selected = NO;
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        if (i < firstDay - 1 || i > totalDays + firstDay - 2) {
            btn.enabled = NO;
            [btn setTitle:@"" forState:UIControlStateNormal];
        }else {
            if (_year == _currentYear && _month == _currentMonth) {
                self.leftBtn.hidden = YES;
                if (btn.tag - KBtnTag - (firstDay - 2) == _currentDay) {
//                    btn.selected = YES;
                    _day = _currentDay;
                    //                    _weekLabel.text = [NSString stringWithFormat:@"星期%@", self.weekArray[(btn.tag - KBtnTag) % 7]];
                    //                    _dayLabel.text = [NSString stringWithFormat:@"%ld", _day];
                }
            }else {
                if (i == firstDay - 1) {
//                    btn.selected = YES;
                    _day = btn.tag - KBtnTag - (firstDay - 2);
                    //                    _weekLabel.text = [NSString stringWithFormat:@"星期%@", self.weekArray[(btn.tag - KBtnTag) % 7]];
                    //                    _dayLabel.text = [NSString stringWithFormat:@"%ld", _day];
                }
            }
            if (self.dateArr.count) {
                switch (_month) {
                    case 1:
                    {
                        calendarModel *model = self.JanuaryArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 2:
                    {
                        calendarModel *model = self.FebruaryArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 3:
                    {
                        calendarModel *model = self.MarchArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 4:
                    {
                        calendarModel *model = self.AprilArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 5:
                    {
                        calendarModel *model = self.MayArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 6:
                    {
                        calendarModel *model = self.JuneArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 7:
                    {
                        calendarModel *model = self.JulyArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 8:
                    {
                        calendarModel *model = self.AugustArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 9:
                    {
                        calendarModel *model = self.SeptemberArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 10:
                    {
                        calendarModel *model = self.OctoberArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 11:
                    {
                        calendarModel *model = self.NovemberArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    case 12:
                    {
                        calendarModel *model = self.DecemberArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
                        NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
                        if ([DayStr isEqualToString:@"2"]) {
                            [btn setBackgroundImage:[UIImage imageWithColor:GRAY240] forState:UIControlStateNormal];
                        }else {
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
//            if (self.dateArr.count) {
//                calendarModel *model = self.dateArr[btn.tag - KBtnTag - (firstDay - 2) - 1];
//                NSString *DayStr = [NSString stringWithFormat:@"%@",model.type];
//                if ([DayStr isEqualToString:@"2"]) {
//                    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//                }else {
//                    [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
//                }
//            }
            self.setBtn.hidden = YES;
            btn.enabled = YES;
            btn.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:19];//PingFangHK-Regular  MicrosoftYaHei
            [btn setTitle:[NSString stringWithFormat:@"%ld", i - (firstDay - 1) + 1] forState:UIControlStateNormal];
        }
    }

}
//获取当前时间
- (void)getCurrentDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    _year = [components year];
    _month = [components month];
    _day = [components day];
    _hour = [components hour];
    _minute = [components minute];
}

//根据选中日期，获取相应NSDate
- (NSDate *)getSelectDate
{
    //初始化NSDateComponents，设置为选中日期
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = _year;
    dateComponents.month = _month;
    
    return [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:dateComponents];
}
//获取目标月份的天数
- (NSInteger)numberOfDaysInMonth
{
    //获取选中日期月份的天数
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self getSelectDate]].length;
}

//获取目标月份第一天星期几
- (NSInteger)firstDayOfWeekInMonth
{
    //获取选中日期月份第一天星期几，因为默认日历顺序为“日一二三四五六”，所以这里返回的1对应星期日，2对应星期一，依次类推
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:[self getSelectDate]];
}
//选中日期时调用
- (void)dateBtnOnClick:(UIButton *)btn
{
    _day = btn.tag - KBtnTag - ([self firstDayOfWeekInMonth] - 2);
    
//    _weekLabel.text = [NSString stringWithFormat:@"星期%@", _weekArray[(btn.tag - KBtnTag) % 7]];
//    _dayLabel.text = [NSString stringWithFormat:@"%ld", _day];
    
    if (btn.selected) return;
    
    for (int i = 0; i < KMaxCount; i++) {
        UIButton *button = [self.calendarView viewWithTag:i + KBtnTag];
        button.selected = NO;
    }
    
    btn.selected = YES;
    
    self.setBtn.hidden = NO;
    self.setBtn.tag = 1000*_day;
    [self.setBtn addTarget:self action:@selector(clickToSet:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (_month) {
        case 1:
        {
            calendarModel *model = self.JanuaryArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 2:
        {
            calendarModel *model = self.FebruaryArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 3:
        {
            calendarModel *model = self.MarchArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 4:
        {
            calendarModel *model = self.AprilArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 5:
        {
            calendarModel *model = self.MayArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 6:
        {
            calendarModel *model = self.JuneArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 7:
        {
            calendarModel *model = self.JulyArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 8:
        {
            calendarModel *model = self.AugustArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 9:
        {
            calendarModel *model = self.SeptemberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 10:
        {
            calendarModel *model = self.OctoberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 11:
        {
            calendarModel *model = self.NovemberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
        case 12:
        {
            calendarModel *model = self.DecemberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                [self.setBtn setTitle:@"设为工作日" forState:UIControlStateNormal];
            } else {
                [self.setBtn setTitle:@"设为休息日" forState:UIControlStateNormal];
            }
        }
            break;
            
        default:
            break;
    }
    
}
- (void)clickToSet:(UIButton *)sender {
    calendarModel *model;
    switch (_month) {
        case 1:
        {
            model = self.JanuaryArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 2:
        {
            model = self.FebruaryArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 3:
        {
            model = self.MarchArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 4:
        {
            model = self.AprilArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 5:
        {
            model = self.MayArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 6:
        {
            model = self.JuneArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 7:
        {
            model = self.JulyArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 8:
        {
            model = self.AugustArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 9:
        {
            model = self.SeptemberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 10:
        {
            model = self.OctoberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 11:
        {
            model = self.NovemberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
        case 12:
        {
            model = self.DecemberArr[_day-1];
            if ([model.type isEqualToString:@"1"]) {
                model.type = @"2";
            } else {
                model.type = @"1";
            }
        }
            break;
            
        default:
            break;
    }
    [self setCalendar:model];
}
- (void)setCalendar:(calendarModel *)model {
    NSDictionary *dic;
    dic = @{@"inter":@"insertCalendar",@"id":model.Id,@"mech_id":[NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId],@"time":model.time,@"type":model.type};
    if ([Utils isBlankString:model.Id]) {
        dic = @{@"inter":@"insertCalendar",@"mech_id":[NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId],@"time":model.time,@"type":model.type};
    }
    
    [HttpRequestEngine setWorkOrRestWithDic:dic completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            [MBProgressHUD showSuccess:@"设置成功"];
            [self reloadData];
            
            [self setSueccess];
        }else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
//设置成功执行
- (void)setSueccess {
    
    switch (_month) {
        case 1:
        {
            [self.JanuaryArr removeAllObjects];
            
        }
            break;
        case 2:
        {
            [self.FebruaryArr removeAllObjects];
        }
            break;
        case 3:
        {
            [self.MarchArr removeAllObjects];
        }
            break;
        case 4:
        {
            [self.AprilArr removeAllObjects];
        }
            break;
        case 5:
        {
            [self.MayArr removeAllObjects];
        }
            break;
        case 6:
        {
            [self.JuneArr removeAllObjects];
        }
            break;
        case 7:
        {
            [self.JulyArr removeAllObjects];
        }
            break;
        case 8:
        {
            [self.AugustArr removeAllObjects];
        }
            break;
        case 9:
        {
            [self.SeptemberArr removeAllObjects];
        }
            break;
        case 10:
        {
            [self.OctoberArr removeAllObjects];
        }
            break;
        case 11:
        {
            [self.NovemberArr removeAllObjects];
        }
            break;
        case 12:
        {
            [self.DecemberArr removeAllObjects];
        }
            break;
            
        default:
            break;
    }
    [self reloadData];
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
