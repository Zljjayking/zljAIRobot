//
//  dailyViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/19.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "dailyViewController.h"
#import "LoginPeopleModel.h"
#import "HttpRequestEngine.h"

#import "dailyAttendanceModel.h"

@interface dailyViewController ()<ChartViewDelegate>

@property (nonatomic, strong) UILabel *deptPeopleCountLB;
@property (nonatomic, strong) dailyAttendanceModel *dailyModel;
@property (nonatomic, strong) UIView *vi;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *dept_id;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) LoginPeopleModel *myInfoModel;
@end

@implementation dailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myInfoModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.mech_id = [NSString stringWithFormat:@"%ld",self.myInfoModel.jrqMechanismId];
    self.user_id = [NSString stringWithFormat:@"%ld",self.myInfoModel.userId];
    self.dept_id = [NSString stringWithFormat:@"%@",self.myInfoModel.dept_id];
    self.time = [NSString stringWithFormat:@"%@",[Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM-dd"]];
    
    [self requestData];
    
    
    
    // Do any additional setup after loading the view.
}
- (void)setupChartView {
    _chartView = [[PieChartView alloc]initWithFrame:CGRectMake(0, -40*KAdaptiveRateWidth, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_chartView];
    
    [self setupPieChartView:_chartView];
    
    _chartView.delegate = self;
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    
    [self updateChartData];
    
    for (id<IChartDataSet> set in _chartView.data.dataSets)
    {
        set.drawValuesEnabled = NO;
    }
    
    [_chartView animateWithYAxisDuration:1.4];
    
    CGPoint p = _chartView.centerCircleBox;
    
    self.vi = [[UIView alloc]initWithFrame:CGRectMake(p.x , p.y, 140*KAdaptiveRateWidth, 140*KAdaptiveRateWidth)];
    self.vi.center = p;
    self.vi.layer.masksToBounds = YES;
    self.vi.layer.cornerRadius = 70*KAdaptiveRateWidth;
    
    UIButton *imageBtn = [[UIButton alloc]init];
    [self.vi addSubview:imageBtn];
    [imageBtn setImage:[UIImage imageNamed:@"deptAttendance"] forState:UIControlStateNormal];
    [imageBtn setTitle:@"部门人数" forState:UIControlStateNormal];
    imageBtn.titleLabel.font = [UIFont systemFontOfSize:18];//dbdbdb   cdcdcd
    [imageBtn setTitleColor:UIColorFromRGB(0xcdcdcd, 1) forState:UIControlStateNormal];
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vi.mas_centerX);
        make.centerY.equalTo(self.vi.mas_centerY).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    self.deptPeopleCountLB = [[UILabel alloc]init];
    [self.vi addSubview:self.deptPeopleCountLB];
    if ([self.dailyModel.deptCount integerValue]) {
        self.deptPeopleCountLB.text = self.dailyModel.deptCount;
    } else {
        self.deptPeopleCountLB.text = @"0";
    }
    
    self.deptPeopleCountLB.font = [UIFont systemFontOfSize:30];
    self.deptPeopleCountLB.textColor = GRAY160;
    [self.deptPeopleCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vi.mas_centerX);
        make.centerY.equalTo(self.vi.mas_centerY).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    [_chartView addSubview:self.vi];
    self.vi.backgroundColor = [UIColor whiteColor];
    
    [_chartView setNeedsDisplay];
    
    
    
    self.dateChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.dateChooseBtn];
    [self.dateChooseBtn setImage:[UIImage imageNamed:@"tongJiRiLi"] forState:UIControlStateNormal];
    [self.dateChooseBtn setTitle:[NSString stringWithFormat:@" %@",[Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM-dd"]] forState:UIControlStateNormal];
    self.dateChooseBtn.titleLabel.font = [UIFont systemFontOfSize:16];//dbdbdb   cdcdcd
    [self.dateChooseBtn setTitleColor:GRAY50 forState:UIControlStateNormal];
    [self.dateChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30*KAdaptiveRateWidth);
        make.top.equalTo(self.view.mas_top).offset(6*KAdaptiveRateWidth);
        make.height.mas_equalTo(30);
    }];
    [self.dateChooseBtn addTarget:self action:@selector(dateChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *down = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（下）"]];
    [self.view addSubview:down];
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12*KAdaptiveRateWidth);
        make.centerY.equalTo(self.dateChooseBtn.mas_centerY);
        make.height.mas_equalTo(7);
        make.width.mas_equalTo(12);
    }];
}
- (void)requestData {
    
    [HttpRequestEngine deptDailyAttandenceWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dataDic = obj;
            DLog(@"%@",dataDic);
            self.dailyModel = [dailyAttendanceModel requestWithDic:dataDic];
            self.deptPeopleCountLB.text = self.dailyModel.deptCount;
            
            NSDictionary *absenceDic = @{@"type":@"8",@"name":@"缺勤",@"value":self.dailyModel.absence,@"color":UIColorFromRGB(0xe24923, 1),@"count":self.dailyModel.absenceValue};
            NSDictionary *business_travel = @{@"type":@"7",@"name":@"出差",@"value":self.dailyModel.business_travel,@"color":UIColorFromRGB(0xff5a6d, 1),@"count":self.dailyModel.business_travelValue};
            NSDictionary *go_out = @{@"type":@"4",@"name":@"外勤",@"value":self.dailyModel.go_out,@"color":UIColorFromRGB(0x4e7ac4, 1),@"count":self.dailyModel.go_outValue};
            NSDictionary *late_time = @{@"type":@"2",@"name":@"迟到",@"value":self.dailyModel.late_time,@"color":UIColorFromRGB(0x8dd4c1, 1),@"count":self.dailyModel.late_timeValue};
            NSDictionary *leave_early = @{@"type":@"3",@"name":@"早退",@"value":self.dailyModel.leave_early,@"color":UIColorFromRGB(0x8ec796, 1),@"count":self.dailyModel.leave_earlyValue};
            NSDictionary *leaves = @{@"type":@"6",@"name":@"请假",@"value":self.dailyModel.leaves,@"color":UIColorFromRGB(0xff7936, 1),@"count":self.dailyModel.leavesValue};
            NSDictionary *not_clock = @{@"type":@"5",@"name":@"未打卡",@"value":self.dailyModel.not_clock,@"color":UIColorFromRGB(0xfbce1a, 1),@"count":self.dailyModel.not_clockValue};
            NSDictionary *punch_clock = @{@"type":@"1",@"name":@"已打卡",@"value":self.dailyModel.punch_clock,@"color":UIColorFromRGB(0xc0e7ef, 1),@"count":self.dailyModel.punch_clockValue};
            self.dataArr = @[absenceDic,business_travel,go_out,late_time,leave_early,leaves,not_clock,punch_clock];
            [self setupChartView];
        }else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}

- (void)updateChartData
{
    
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    [self setDataCount:8 range:100];
}

- (void)reloadData {
    self.time = [self.dateChooseBtn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [HttpRequestEngine deptDailyAttandenceWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dataDic = obj;
            DLog(@"%@",dataDic);
            self.dailyModel = [dailyAttendanceModel requestWithDic:dataDic];
            self.deptPeopleCountLB.text = self.dailyModel.deptCount;
            
            NSDictionary *absenceDic = @{@"type":@"8",@"name":@"缺勤",@"value":self.dailyModel.absence,@"color":UIColorFromRGB(0xe24923, 1),@"count":self.dailyModel.absenceValue};
            NSDictionary *business_travel = @{@"type":@"7",@"name":@"出差",@"value":self.dailyModel.business_travel,@"color":UIColorFromRGB(0xff5a6d, 1),@"count":self.dailyModel.business_travelValue};
            NSDictionary *go_out = @{@"type":@"4",@"name":@"外勤",@"value":self.dailyModel.go_out,@"color":UIColorFromRGB(0x4e7ac4, 1),@"count":self.dailyModel.go_outValue};
            NSDictionary *late_time = @{@"type":@"2",@"name":@"迟到",@"value":self.dailyModel.late_time,@"color":UIColorFromRGB(0x8dd4c1, 1),@"count":self.dailyModel.late_timeValue};
            NSDictionary *leave_early = @{@"type":@"3",@"name":@"早退",@"value":self.dailyModel.leave_early,@"color":UIColorFromRGB(0x8ec796, 1),@"count":self.dailyModel.leave_earlyValue};
            NSDictionary *leaves = @{@"type":@"6",@"name":@"请假",@"value":self.dailyModel.leaves,@"color":UIColorFromRGB(0xff7936, 1),@"count":self.dailyModel.leavesValue};
            NSDictionary *not_clock = @{@"type":@"5",@"name":@"未打卡",@"value":self.dailyModel.not_clock,@"color":UIColorFromRGB(0xfbce1a, 1),@"count":self.dailyModel.not_clockValue};
            NSDictionary *punch_clock = @{@"type":@"1",@"name":@"已打卡",@"value":self.dailyModel.punch_clock,@"color":UIColorFromRGB(0xc0e7ef, 1),@"count":self.dailyModel.punch_clockValue};
            
            self.dataArr = @[absenceDic,business_travel,go_out,late_time,leave_early,leaves,not_clock,punch_clock];
            
            
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            NSMutableArray *colors = [[NSMutableArray alloc] init];
            for (int i = 0; i < self.dataArr.count; i++)
            {
                NSDictionary *dic = self.dataArr[i];
                NSString *value  = dic[@"value"];
                NSString *count = dic[@"count"];
                UIColor *color = dic[@"color"];
                if (![value isEqualToString:@"0"]) {
                    [values addObject:[[PieChartDataEntry alloc] initWithValue:[value doubleValue] label:[NSString stringWithFormat:@"%@人",count] icon: [UIImage imageNamed:@"icon"] data:dic]];
                    [colors addObject:color];
                }
            }
//            UIColor *col = UIColorFromRGB(0xc0e7ef, 1);
            PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
            
            dataSet.drawIconsEnabled = NO;
            
            dataSet.sliceSpace = 5.0;
            
            dataSet.iconsOffset = CGPointMake(0, 40);
            
            // add a lot of colors
            
            //    [colors addObject:kMyColor(191, 41, 83)];
            //    [colors addObject:kMyColor(252, 102, 33)];
            //    [colors addObject:kMyColor(253, 141, 158)];
            //    [colors addObject:kMyColor(215, 83, 138)];
            //    [colors addObject:kMyColor(144, 234, 254)];
            //    [colors addObject:kMyColor(252, 148, 40)];
            //    [colors addObject:kMyColor(108, 166, 135)];
            //    [colors addObject:kMyColor(63, 194, 208)];
            //254 207 144
            //144 234 254
            //253 141 158
            //215 83 138
            //252 148 40
            //108 166 135
            //63 194 208
            //191 41 83
            //252 103 33
            dataSet.colors = colors;
            
            PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
            
            NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
            pFormatter.numberStyle = NSNumberFormatterPercentStyle;
            pFormatter.maximumFractionDigits = 1;
            pFormatter.multiplier = @1.f;
            pFormatter.percentSymbol = @" %";
            [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
            [data setValueTextColor:UIColor.whiteColor];
            
            _chartView.data = data;
            [_chartView highlightValues:nil];
            [_chartView setNeedsDisplay];
            
            CGPoint p = _chartView.centerCircleBox;
            
            self.vi.center = p;
            
            for (id<IChartDataSet> set in _chartView.data.dataSets)
            {
                set.drawValuesEnabled = NO;
            }
            [_chartView animateWithYAxisDuration:1.4];
            [_chartView setNeedsDisplay];
            
        }else {
            [MBProgressHUD showError:errorStr];
        }
    }];
    
    
}

- (void)setDataCount:(int)count range:(double)range
{
    [_chartView setNeedsDisplay];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArr.count; i++)
    {
        NSDictionary *dic = self.dataArr[i];
        NSString *value  = dic[@"value"];
        NSString *count = dic[@"count"];
        UIColor *color = dic[@"color"];
        if (![value isEqualToString:@"0"]) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:[value doubleValue] label:[NSString stringWithFormat:@"%@人",count] icon: [UIImage imageNamed:@"icon"] data:dic]];
            [colors addObject:color];
        }
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    
    dataSet.drawIconsEnabled = NO;
    
    dataSet.sliceSpace = 5.0;
    
    dataSet.iconsOffset = CGPointMake(0, 40);
    
    // add a lot of colors
    
    
//    [colors addObject:kMyColor(191, 41, 83)];
//    [colors addObject:kMyColor(252, 102, 33)];
//    [colors addObject:kMyColor(253, 141, 158)];
//    [colors addObject:kMyColor(215, 83, 138)];
//    [colors addObject:kMyColor(144, 234, 254)];
//    [colors addObject:kMyColor(252, 148, 40)];
//    [colors addObject:kMyColor(108, 166, 135)];
//    [colors addObject:kMyColor(63, 194, 208)];
    //254 207 144
    //144 234 254
    //253 141 158
    //215 83 138
    //252 148 40
    //108 166 135
    //63 194 208
    //191 41 83
    //252 103 33
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
    
    
    for (int i=0; i<self.dataArr.count; i++) {
        UIColor *color = [self.dataArr[i] objectForKey:@"color"];
        UIImageView *SlicedImage = [[UIImageView alloc]initWithImage:[UIImage imageWithColor:color]];
        [self.view addSubview:SlicedImage];
        SlicedImage.layer.masksToBounds = YES;
        SlicedImage.layer.cornerRadius = 4;
        [SlicedImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(40*KAdaptiveRateWidth+(kScreenWidth-40*KAdaptiveRateWidth)/4.0 * ((i%4))-4);
            make.top.equalTo(self.view.mas_bottom).offset(-100*KAdaptiveRateWidth + (i/4)*30*KAdaptiveRateWidth);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(8);
        }];
        
        NSDictionary *dic = self.dataArr[i];
        NSString *name = dic[@"name"];
        
        UILabel *lB = [[UILabel alloc]init];
        lB.text = name;
        [self.view addSubview:lB];
        lB.textColor = GRAY70;
        lB.font = [UIFont systemFontOfSize:13];
        [lB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(SlicedImage.mas_centerY);
            make.left.equalTo(SlicedImage.mas_right).offset(4);
            make.height.mas_equalTo(15);
        }];
    }

}

- (void)dateChooseBtnClick:(UIButton *)sender {
    self.showDate();
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
//    NSString *e = [NSString stringWithFormat:@"%@",entry.data];
//    [MBProgressHUD showToastText:e];
    NSDictionary *dic = entry.data;
    self.dailyblock(dic,self.time);
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
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
