//
//  UsinghelpViewController.m
//  Financeteam
//
//  Created by Zccf on 16/9/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "UsinghelpViewController.h"
#import "HelpDetailsViewController.h"
#import "payHeaderView.h"
#import "paySlipTableViewCell.h"
@interface UsinghelpViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SelectDateTimeDelegate,UIGestureRecognizerDelegate>{
    DateTimeSelectView *_MonthSelectView;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *NaviView;
@property (nonatomic, strong) UITableView *NaviTableView;
@property (nonatomic, strong) UIButton *NaviAppearBtn;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic) CAShapeLayer *maskLayer;
@property (nonatomic) CALayer *contentLayer;

@property (nonatomic,strong) UIScrollView *scrollv;//主scrollView
@property (nonatomic,strong) UILabel *titleLB;//titleView
@property (nonatomic, strong) payHeaderView *customView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *naviImageView;
@property (nonatomic, strong) UIView *whiteView;//当type为2时候遮挡 naviImageView
@property (nonatomic, strong) UIButton *dateChooseBtn;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *type;//第一次调用接口时候返回的type
@property (nonatomic, strong) NSString *timeStr;//第一次调用接口时候返回的time
@property (nonatomic, strong) UILabel *signLBThree;//显示月日的Label
@property (nonatomic, strong) UIButton *signBtnOne;
@property (nonatomic, assign) BOOL isShowSignLB;
@property (nonatomic, strong) UILabel *signLBFour;//显示提示信息的Label
@property (nonatomic, strong) NSString *yearAMonth;
@property (nonatomic, strong) UILabel *signLB;
@property (nonatomic, strong) UILabel *payCountLB;//本月工资总额
@property (nonatomic, strong) UILabel *signLBTwo;
@property (nonatomic, assign) CGPoint ImageVCenter;//imageV的center
@property (nonatomic, strong) NSArray *sectionOneArr;
@property (nonatomic, strong) NSArray *sectionTwoArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) NSDictionary *dataDic;//接收到的数据
@property (nonatomic, strong) NSString *shouldPayMoney;//应发工资
@property (nonatomic, strong) NSString *shouldDeduckMoney;//应扣工资
@property (nonatomic, strong) UIImageView *signImage;
@property (nonatomic, strong) UIImageView *markImageView;
@end

@implementation UsinghelpViewController

- (UITableView *)NaviTableView {
    if (!_NaviTableView) {
        _NaviTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _NaviTableView.dataSource = self;
        _NaviTableView.delegate = self;
        _NaviTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_NaviTableView registerClass:[paySlipTableViewCell class] forCellReuseIdentifier:@"paySlip"];
        _NaviTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [_NaviTableView.header endRefreshing];
        }];
        _NaviTableView.header.tintColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _NaviTableView.tableFooterView = view;
    }
    return _NaviTableView;
}
- (UIView*)NaviView {
    if (!_NaviView) {
        _NaviView = [[UIView alloc] init];
        _NaviView.alpha = 1;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0,0, 200*KAdaptiveRateWidth,kScreenHeight);
        [_NaviView addSubview:effectView];
        
        UILabel *naviTitle = [[UILabel alloc] initWithFrame:CGRectMake(10*KAdaptiveRateWidth, 50, 150*KAdaptiveRateWidth, 18)];
        naviTitle.textAlignment = NSTextAlignmentCenter;
        naviTitle.textColor = [UIColor grayColor];
        naviTitle.font = [UIFont systemFontOfSize:18];
        naviTitle.text = @"全部帮助";
        [_NaviView addSubview:naviTitle];
        self.NaviTableView.frame = CGRectMake(4, 85, 160*KAdaptiveRateWidth, 450);
        self.NaviTableView.backgroundColor = [UIColor clearColor];
        [_NaviView addSubview:self.NaviTableView];
        UIButton *NaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NaviBtn.frame = CGRectMake(170*KAdaptiveRateWidth, kScreenHeight/2.0-30*KAdaptiveRateWidth, 30*KAdaptiveRateWidth, 60*KAdaptiveRateWidth);
        NaviBtn.backgroundColor = [UIColor clearColor];
        [_NaviView addSubview:NaviBtn];
        [NaviBtn addTarget:self action:@selector(naviHide) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NaviBack"]];
        image.frame = CGRectMake(0, 0, 25*KAdaptiveRateWidth, 25*KAdaptiveRateWidth);
        image.center = CGPointMake(12.5*KAdaptiveRateWidth, 30*KAdaptiveRateWidth);
        [NaviBtn addSubview:image];
        
        
    }
    return _NaviView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    self.sectionOneArr = @[@"基本工资",@"提成金额",@"全勤奖",@"加班费",@"报销费用",@"过节费",@"补工资",@"综合补贴"];
    self.sectionTwoArr = @[@"迟到早退",@"缺勤",@"请假",@"旷工",@"社保医保",@"个人所得税",@"借支",@"罚款",@"公积金",@"其他扣款"];
    self.sectionArr = @[@"1",@"2"];
    [self setupView];
    self.yearAMonth = [Utils beforeOrLaterWithDate:[NSDate date] monthCount:0];
    [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:@"" completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dataDic = obj;
            self.type = [NSString stringWithFormat:@"%@",dataDic[@"type"]];
            self.timeStr = [NSString stringWithFormat:@"%@",[dataDic[@"time"] substringToIndex:10]];
            self.blankV.hidden = YES;
            if ([self.type isEqualToString:@"0"]) {
                self.yearAMonth = [Utils dateToString:[NSDate date] withDateFormat:@"yyyy-MM"];
                NSDate *ss = [Utils stringToDate:self.timeStr withDateFormat:@"yyyy-MM-dd"];
                NSString *yearAndMonth = [Utils dateToString:ss withDateFormat:@"yyyy年MM月dd日"];
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],yearAndMonth];
                self.payCountLB.font = KFONT(35, 0.1);
                self.signLB.hidden = NO;
                self.signLBTwo.hidden = NO;
                self.signLBThree.hidden = NO;
                self.signBtnOne.hidden = NO;
                [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:self.yearAMonth completion:^(id obj, NSString *errorStr) {
                    [self handleDataWithData:obj error:errorStr];
                }];
            } else if ([self.type isEqualToString:@"1"]){
                self.yearAMonth = [Utils beforeOrLaterWithDate:[NSDate date] monthCount:-1];
                
                NSInteger days = [Utils daysInMonth:[Utils stringToDate:self.yearAMonth withDateFormat:@"yyyy-MM"]];
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@月%02ld日",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],days];
                self.payCountLB.font = KFONT(35, 0.1);
                self.signLB.hidden = NO;
                self.signLBTwo.hidden = NO;
                self.signLBThree.hidden = NO;
                self.signBtnOne.hidden = NO;
                [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:self.yearAMonth completion:^(id obj, NSString *errorStr) {
                    [self handleDataWithData:obj error:errorStr];
                }];
            } else {
                
                self.blankV.hidden = YES;
                self.sectionArr = @[];
                NSInteger days = [Utils daysInMonth:[Utils stringToDate:self.yearAMonth withDateFormat:@"yyyy-MM"]];
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@月%02ld日",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],days];
                self.payCountLB.text = @"该月无历史工资条";
                self.payCountLB.font = KFONT(30, 0.1);
                self.signLB.hidden = YES;
                self.signLBTwo.hidden = YES;
                self.signLBThree.hidden = YES;
                self.signBtnOne.hidden = YES;
                [self.NaviTableView reloadData];
            }
            [self.dateChooseBtn setTitle:[NSString stringWithFormat:@"%@",self.yearAMonth] forState:UIControlStateNormal];
        } else {
            
            [self.dateChooseBtn setTitle:self.yearAMonth forState:UIControlStateNormal];
            self.blankV.hidden = NO;
            self.sectionArr = @[];
            [self.NaviTableView reloadData];
            NSInteger days = [Utils daysInMonth:[Utils stringToDate:self.yearAMonth withDateFormat:@"yyyy-MM"]];
            self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@月%02ld日",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],days];
            [MBProgressHUD showError:@"暂无工资条数据"];
        }
        
    }];
    
}

- (void)handleDataWithData:(id)Data error:(NSString *)error {
    self.sectionArr = @[@"1",@"2"];
    NSDictionary *dataDic = Data;
    NSString *type = [NSString stringWithFormat:@"%@",dataDic[@"type"]];
    if ([type isEqualToString:@"2"]) {
        self.blankV.hidden = YES;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
        NSString * awardFloatStr = @"0";
        NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
        string = [Utils stringToMoneyWithValue:0];
        self.payCountLB.text = [string substringFromIndex:1];
        self.sectionArr = @[];
        self.markImageView.hidden = YES;
        self.payCountLB.text = @"该月无历史工资条";
        self.payCountLB.font = KFONT(30, 0.1);
        self.signLB.hidden = YES;
        self.signLBTwo.hidden = YES;
        self.signLBThree.hidden = YES;
        self.signBtnOne.hidden = YES;
        [self.NaviTableView reloadData];
    } else {
        self.payCountLB.font = KFONT(35, 0.1);
        self.signLB.hidden = NO;
        self.signLBTwo.hidden = NO;
        self.signLBThree.hidden = NO;
        self.signBtnOne.hidden = NO;
        if ([Utils isBlankString:error]) {
            NSDictionary *dic = Data;
            NSString *opera = [NSString stringWithFormat:@"%@",dic[@"opera"]];
            switch ([opera integerValue]) {
                case 0:
                    self.signLB.text = @"本月核算工资(元)";
                    self.markImageView.hidden = NO;
                    self.markImageView.image = [UIImage imageNamed:@"印章-核算中"];
                    break;
                case 1:
                    self.signLB.text = @"本月核发工资(元)";
                    self.markImageView.hidden = NO;
                    self.markImageView.image = [UIImage imageNamed:@"印章-已核发"];
                    break;
                default:
                    self.signLB.text = @"本月实时工资(元)";
                    self.markImageView.hidden = YES;
                    break;
            }
            NSString *festivalMoney = [NSString stringWithFormat:@"%.2f",[dic[@"festivalMoney"] floatValue]];
            NSString *reimbursementMoney = [NSString stringWithFormat:@"%.2f",[dic[@"reimbursementMoney"] floatValue]];
            NSString *absenceMoney = [NSString stringWithFormat:@"%.2f",[dic[@"absenceMoney"] floatValue]];
            NSString *absenteeismMoney = [NSString stringWithFormat:@"%.2f",[dic[@"absenteeismMoney"] floatValue]];
            
            NSString *accumulationMoney = [NSString stringWithFormat:@"%.2f",[dic[@"accumulationMoney"] floatValue]];
            NSString *attendance = [NSString stringWithFormat:@"%.2f",[dic[@"attendance"] floatValue]];
            NSString *borrowMoney = [NSString stringWithFormat:@"%.2f",[dic[@"borrowMoney"] floatValue]];
            NSString *commissionMoney = [NSString stringWithFormat:@"%.2f",[dic[@"commissionMoney"] floatValue]];
            
            NSString *fineMoney = [NSString stringWithFormat:@"%.2f",[dic[@"fineMoney"] floatValue]];
            NSString *generalSubsidies = [NSString stringWithFormat:@"%.2f",[dic[@"generalSubsidies"] floatValue]];
            NSString *individualMoney = [NSString stringWithFormat:@"%.2f",[dic[@"individualMoney"] floatValue]];
            NSString *lateLeaveEarly = [NSString stringWithFormat:@"%.2f",[dic[@"lateLeaveEarly"] floatValue]];
            NSString *leavesMoney = [NSString stringWithFormat:@"%.2f",[dic[@"leavesMoney"] floatValue]];
            
            NSString *otherMoney = [NSString stringWithFormat:@"%.2f",[dic[@"otherMoney"] floatValue]];
            NSString *overtimeMoney = [NSString stringWithFormat:@"%.2f",[dic[@"overtimeMoney"] floatValue]];
            NSString *repairWages = [NSString stringWithFormat:@"%.2f",[dic[@"repairWages"] floatValue]];
            NSString *salary = [NSString stringWithFormat:@"%.2f",[dic[@"salary"] floatValue]];
            NSString *socialMoney = [NSString stringWithFormat:@"%.2f",[dic[@"socialMoney"] floatValue]];
            
            NSString *payrollMoney = [NSString stringWithFormat:@"%.2f",[dic[@"payrollMoney"] floatValue]];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
            NSString * awardFloatStr = payrollMoney;
            NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
            string = [Utils stringToMoneyWithValue:[payrollMoney doubleValue]];
            self.payCountLB.text = [string substringFromIndex:1];
            
            if ([dic[@"payrollMoney"] floatValue]<0) {
                self.payCountLB.text = [NSString stringWithFormat:@"-%@",[[string substringFromIndex:1] substringFromIndex:1]];
            }
            
            self.dataDic = @{@"基本工资":salary,@"提成金额":commissionMoney,@"全勤奖":attendance,@"加班费":overtimeMoney,@"报销费用":reimbursementMoney,@"过节费":festivalMoney,@"补工资":repairWages,@"综合补贴":generalSubsidies,@"迟到早退":lateLeaveEarly,@"缺勤":absenceMoney,@"请假":leavesMoney,@"旷工":absenteeismMoney,@"社保医保":socialMoney,@"个人所得税":individualMoney,@"借支":borrowMoney,@"罚款":fineMoney,@"公积金":accumulationMoney,@"其他扣款":otherMoney};
            self.shouldPayMoney = [NSString stringWithFormat:@"%g",[salary floatValue]+[commissionMoney floatValue]+[attendance floatValue]+[overtimeMoney floatValue]+[reimbursementMoney floatValue]+[festivalMoney floatValue]+[repairWages floatValue]+[generalSubsidies floatValue]];
            self.shouldDeduckMoney = [NSString stringWithFormat:@"%g",[lateLeaveEarly floatValue]+[absenceMoney floatValue]+[leavesMoney floatValue]+[absenteeismMoney floatValue]+[socialMoney floatValue]+[individualMoney floatValue]+[borrowMoney floatValue]+[fineMoney floatValue]+[accumulationMoney floatValue]+[otherMoney floatValue]];
            [self.NaviTableView reloadData];
        } else {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
            NSString * awardFloatStr = @"0";
            NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
            string = [Utils stringToMoneyWithValue:0];
            self.payCountLB.text = [string substringFromIndex:1];
            self.blankV.hidden = NO;
            self.sectionArr = @[];
            self.markImageView.hidden = YES;
            [self.NaviTableView reloadData];
            [MBProgressHUD showError:error];
        }
    }
    
}

- (void)setupView {
//    self.type = @"2";
    self.scrollv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.scrollv.backgroundColor = VIEW_BASE_COLOR;
    self.scrollv.bounces = NO;
    self.scrollv.contentSize = CGSizeMake(0, kScreenHeight);
    [self.view addSubview:self.scrollv];
    
    self.naviImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"payBanner"]];
    self.naviImageView.userInteractionEnabled = YES;
    self.naviImageView.frame = CGRectMake(0, 0, kScreenWidth, 2*kScreenWidth*(92/108.0));
    
    [self.scrollv addSubview:self.naviImageView];
    
    self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenWidth*(92/108.0), kScreenWidth, kScreenHeight)];
    
    [self.scrollv addSubview:self.whiteView];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    UIImageView *rightImage = [[UIImageView alloc]init];
    rightImage.center = rightView.center;
    [rightView addSubview:rightImage];
    rightImage.image = [UIImage imageNamed:@"xiangxia"];
    rightImage.frame = CGRectMake(87, 13.5, 13, 13);
//    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(rightView.mas_right);
//        make.centerY.equalTo(rightView.mas_centerY);
//        make.height.mas_equalTo(13);
//        make.width.mas_equalTo(13);
//    }];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    self.titleLB.textColor = [UIColor whiteColor];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.font = KFONT(18, 0.3);
    self.titleLB.text = @"工资条";
    self.titleLB.alpha = 0;
    
    self.dateChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView addSubview:self.dateChooseBtn];
    self.dateChooseBtn.frame = CGRectMake(10, 0, 80, 40);
    self.dateChooseBtn.titleLabel.font = [UIFont systemFontOfSize:17];//dbdbdb   cdcdcd
    
//    [self.dateChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(rightImage.mas_left).offset(-5);
//        make.centerY.equalTo(rightImage.mas_centerY);
//        make.height.mas_equalTo(40);
//    }];
    [self.dateChooseBtn addTarget:self action:@selector(dateChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    self.customView = [[payHeaderView alloc]initWithFrame:CGRectMake(0, kScreenWidth*(92/108.0) - 64 - 30, kScreenWidth, 30)];
    self.NaviTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    self.NaviTableView.backgroundColor = [UIColor clearColor];
    self.NaviTableView.bounces = NO;
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*(92/108.0)-64)];
    
    self.headerView.backgroundColor = [UIColor clearColor];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenWidth*(92/108.0))];
    imageV.image = [UIImage imageNamed:@"payBanner"];
    [self.headerView addSubview:self.customView];
    if (IS_IPHONE_X) {
        self.naviImageView.frame = CGRectMake(0, 0, kScreenWidth, 2*kScreenWidth*(92/108.0)+24);
        self.whiteView.frame = CGRectMake(0, kScreenWidth*(92/108.0)+24, kScreenWidth, kScreenHeight);
        self.NaviTableView.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
    }
    self.customView.ssheight = 50;
    [self.scrollv addSubview:self.NaviTableView];
    self.NaviTableView.tableHeaderView = self.headerView;
    
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(0, self.NaviTableView.center.y/2.0+100, kScreenWidth, kScreenWidth/2.0) imageName:@"noData" title:@"暂无工资条信息"];
    [self.NaviTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
    
    self.signLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.signLB.center = CGPointMake(imageV.center.x, imageV.center.y-30*KAdaptiveRateWidth);
    [self.headerView addSubview:self.signLB];
    self.signLB.textAlignment = NSTextAlignmentCenter;
    self.signLB.textColor = [UIColor whiteColor];
    self.signLB.font = [UIFont systemFontOfSize:13];
    self.signLB.text = @"本月实时预计工资(元)";
    
    self.payCountLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    self.payCountLB.center = CGPointMake(imageV.center.x, imageV.center.y+0*KAdaptiveRateWidth);;
    [self.headerView addSubview:self.payCountLB];
    self.payCountLB.textAlignment = NSTextAlignmentCenter;
    self.payCountLB.textColor = [UIColor whiteColor];
    self.payCountLB.font = KFONT(35, 0.1);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
    NSString * awardFloatStr = @"0";
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
    string = [Utils stringToMoneyWithValue:0];
    self.payCountLB.text = [string substringFromIndex:1];
    
    self.signLBTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.signLBTwo.center = CGPointMake(imageV.center.x, imageV.center.y+60*KAdaptiveRateWidth);
    [self.headerView addSubview:self.signLBTwo];
    self.signLBTwo.textAlignment = NSTextAlignmentCenter;
    self.signLBTwo.textColor = [UIColor whiteColor];
    self.signLBTwo.font = [UIFont systemFontOfSize:13];
    self.signLBTwo.text = @"工资结算周期";
    
    
    self.ImageVCenter = imageV.center;
    
    self.signLBThree = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.signLBThree.center = CGPointMake(imageV.center.x, imageV.center.y+80*KAdaptiveRateWidth);
    [self.headerView addSubview:self.signLBThree];
    self.signLBThree.textAlignment = NSTextAlignmentCenter;
    self.signLBThree.textColor = [UIColor whiteColor];
    self.signLBThree.font = [UIFont systemFontOfSize:13];
    self.signLBThree.text = @"年 月 日 - 年 月 日";
    
    self.signBtnOne = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signBtnOne addTarget:self action:@selector(signOneClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.signBtnOne setBackgroundImage:[UIImage imageNamed:@"tixing"] forState:UIControlStateNormal];
    [self.headerView addSubview:self.signBtnOne];
    self.signBtnOne.frame = CGRectMake(kScreenWidth-35, imageV.center.y+65*KAdaptiveRateWidth, 28, 28);
    self.isShowSignLB = NO;
    self.signImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tixing"]];
    [self.signBtnOne addSubview:self.signImage];
    self.signImage.frame = CGRectMake(5, 5, 18, 18);
    
    self.markImageView = [[UIImageView alloc]init];
    [self.headerView addSubview:self.markImageView];
    self.markImageView.frame = CGRectMake(10, kScreenWidth/2.0, 80.2*KAdaptiveRateWidth, 64.8*KAdaptiveRateWidth);
    self.markImageView.hidden = YES;
    
    self.signLBFour = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-60*KAdaptiveRateWidth, 200)];
    self.signLBFour.numberOfLines = 0;
    self.signLBFour.textColor = [UIColor whiteColor];
    self.signLBFour.font = [UIFont systemFontOfSize:11];
    //    self.signLBFour.textAlignment = NSTextAlignmentCenter;
    self.signLBFour.text = @"1. 社保医保、公积金、个人所得税计算方法均为所在企业自行设置金额，本软件不提供算法\n2. '预计工资'为实时统计数据，数据结果仅供参考\n3. 状态为'核算中'时，如对工资有任何疑问请向企业相关负责人反馈/核对\n4. 状态为'已核发'时，说明该月工资已经正确发放\n5. 如对实发/预记工资有任何疑问，请向企业相关负责人反馈";
    self.signLBFour.center = CGPointMake(imageV.center.x, imageV.center.y+160*KAdaptiveRateWidth);
    [self.headerView addSubview:self.signLBFour];
    self.signLBFour.alpha = 0;
    
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _MonthSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMM"];
    _MonthSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_MonthSelectView];
    _MonthSelectView.hidden = YES;
    
}
- (void)tapBgView {
    [UIView animateWithDuration:animateTime animations:^{
        _MonthSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _MonthSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}
#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@",dictDate[@"date"]];
    
    self.yearAMonth = dateStr;
    NSInteger days = [Utils daysInMonth:[Utils stringToDate:self.yearAMonth withDateFormat:@"yyyy-MM"]];
    self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@月%02ld日",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],days];
    
    BOOL isNowLatter = [Utils compareTwoDateWithMinDate:dateStr DateFormat:@"yyyy-MM" MaxDate:[Utils dateToString:[NSDate date] withDateFormat:@"yyyy-MM"]];
    if (isNowLatter) {
        self.sectionArr = @[@"1",@"2"];
        //所选时间小于等于当前时间
        self.blankV.hidden = YES;
        if ([dateStr isEqualToString:[Utils dateToString:[NSDate date] withDateFormat:@"yyyy-MM"]]) {
            if ([self.type isEqualToString:@"0"]) {
                NSDate *ss = [Utils stringToDate:self.timeStr withDateFormat:@"yyyy-MM-dd"];
                NSString *yearAndMonth = [Utils dateToString:ss withDateFormat:@"yyyy年MM月dd日"];
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],yearAndMonth];
                [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:self.yearAMonth completion:^(id obj, NSString *errorStr) {
                    [self handleDataWithData:obj error:errorStr];
                }];
            } else if ([self.type isEqualToString:@"1"]) {
                NSDate *ss = [Utils stringToDate:self.timeStr withDateFormat:@"yyyy-MM-dd"];
                NSString *yearAndMonth = [Utils dateToString:ss withDateFormat:@"yyyy年MM月dd日"];
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],yearAndMonth];
                [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:self.yearAMonth completion:^(id obj, NSString *errorStr) {
                    [self handleDataWithData:obj error:errorStr];
                }];
            } else {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
                NSString * awardFloatStr = @"0";
                NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
                string = [Utils stringToMoneyWithValue:0];
                self.payCountLB.text = [string substringFromIndex:1];
                self.sectionArr = @[];
                self.blankV.hidden = NO;
                [self.NaviTableView reloadData];
            }
            
        }else{
            if ([self.type isEqualToString:@"0"]) {
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@月%02ld日",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],days];
                [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:self.yearAMonth completion:^(id obj, NSString *errorStr) {
                    [self handleDataWithData:obj error:errorStr];
                }];
            }else if ([self.type isEqualToString:@"1"]) {
                self.signLBThree.text = [NSString stringWithFormat:@"%@月01日 - %@月%02ld日",[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],[self.yearAMonth stringByReplacingOccurrencesOfString:@"-" withString:@"年"],days];
                [HttpRequestEngine getpaySlipWithMech_id:self.myMech_Id user_id:self.myUser_Id time:self.yearAMonth completion:^(id obj, NSString *errorStr) {
                    [self handleDataWithData:obj error:errorStr];
                }];
            } else {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
                NSString * awardFloatStr = @"0";
                NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
                string = [Utils stringToMoneyWithValue:0.0];
                self.payCountLB.text = [string substringFromIndex:1];
                self.sectionArr = @[];
                self.blankV.hidden = NO;
                [self.NaviTableView reloadData];
            }
        }
        
    } else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
        NSString * awardFloatStr = @"0";
        NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
        string = [Utils stringToMoneyWithValue:0];
        self.payCountLB.text = [string substringFromIndex:1];
//        self.payCountLB.text = [Utils stringToMoneyWithValue:0];
        self.sectionArr = @[];
        self.blankV.hidden = NO;
        [self.NaviTableView reloadData];
    }
    
    [UIView animateWithDuration:animateTime animations:^{
        _MonthSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        [self.dateChooseBtn setTitle:[NSString stringWithFormat:@"%@",self.yearAMonth] forState:UIControlStateNormal];
        _MonthSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
    
    
    
}

- (void)cancelDate {
    [UIView animateWithDuration:animateTime animations:^{
        _MonthSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _MonthSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
    
}
- (void)dateChooseBtnClick:(UIButton *)sender {
    _MonthSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:animateTime animations:^{
        _MonthSelectView.frame = timeViewRect;
    }];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)NaviAppearBtnClick {
    [UIView animateWithDuration:0.3 animations:^{
        self.NaviAppearBtn.hidden = YES;
        self.NaviView.frame = CGRectMake(0, 0, 200*KAdaptiveRateWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    }];
}
- (void)naviHide {
    [UIView animateWithDuration:0.3 animations:^{
        self.NaviView.frame = CGRectMake(-200*KAdaptiveRateWidth, 0, 200*KAdaptiveRateWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        self.NaviAppearBtn.hidden = NO;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.type isEqualToString:@"2"]) {
        return 0;
    } else {
        return self.sectionArr.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.type isEqualToString:@"2"]) {
        return 0;
    } else {
        if (section == 0) {
            return 8;
        }
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    footer.backgroundColor = [UIColor whiteColor];
    UILabel *moeyLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [footer addSubview:moeyLB];
    moeyLB.textAlignment = NSTextAlignmentCenter;
    if (![self.type isEqualToString:@"2"]) {
        footer.backgroundColor = VIEW_BASE_COLOR;
        if (section == 0) {
            NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"应发工资小记:"];
            NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:GRAY138,};
            [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
            NSString * awardFloatStr = self.shouldPayMoney;
            NSString *string = [Utils stringToMoneyWithValue:[awardFloatStr floatValue]];
            
            NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@",string]];
            NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:customGreenColor,};
            [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
            [firstPart appendAttributedString:secondPart];
            
            moeyLB.attributedText = firstPart;
        } else {
            NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"应扣工资小记:"];
            NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:GRAY138,};
            [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
            NSString * awardFloatStr = self.shouldDeduckMoney;
            NSString *string = [Utils stringToMoneyWithValue:[awardFloatStr floatValue]];
            
            NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"-%@",string]];
            NSDictionary * secondAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:customRedColor,};
            [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
            [firstPart appendAttributedString:secondPart];
            
            moeyLB.attributedText = firstPart;
        }
    }
    
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    paySlipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paySlip"];
    if (cell == nil) {
        cell = [[paySlipTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paySlip"];
    }
    
    if (indexPath.section == 0) {
        cell.moneyLB.textColor = customGreenColor;
        cell.typeLB.text = self.sectionOneArr[indexPath.row];
        
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
        NSString * awardFloatStr = [self.dataDic objectForKey:self.sectionOneArr[indexPath.row]];
//        NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
        
        cell.moneyLB.text = [NSString stringWithFormat:@"+%@",[[Utils stringToMoneyWithValue:[awardFloatStr floatValue]] substringFromIndex:1]];
    } else {
        cell.moneyLB.textColor = customRedColor;
        cell.typeLB.text = self.sectionTwoArr[indexPath.row];
        
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        formatter.numberStyle = NSNumberFormatterCurrencyStyle; //NSNumberFormatterDecimalStyle;
        NSString * awardFloatStr = [self.dataDic objectForKey:self.sectionTwoArr[indexPath.row]];
//        NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
        
        cell.moneyLB.text = [NSString stringWithFormat:@"-%@",[[Utils stringToMoneyWithValue:[awardFloatStr floatValue]] substringFromIndex:1]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat bottomOffset = scrollView.contentSize.height - offsetY;
//    DLog(@"offsetY == %f bottomOffset == %f",offsetY,bottomOffset);
    if (scrollView == self.NaviTableView) {
        if (offsetY > 0) {
            
            self.customView.ssheight = 50 - ((offsetY) / (kScreenWidth*(92/108.0)+70))*50.0;
            self.navigationItem.titleView = self.titleLB;
            self.titleLB.alpha = ((offsetY) / (kScreenWidth*(92/108.0)-64));
            
            if (offsetY >=  44*30 - kScreenWidth*(92/108.0)-64) {
                self.scrollv.bounces = NO;
            } else {
                self.scrollv.bounces = NO;
            }
        } else {
            
        }
    } else {
        
    }
    if (self.isShowSignLB) {
        self.isShowSignLB = NO;
        self.signImage.image = [UIImage imageNamed:@"tixing"];
        [UIView animateWithDuration:0.3 animations:^{
            self.whiteView.frame = CGRectMake(0, kScreenWidth*(92/108.0), kScreenWidth, kScreenHeight);
            if (IS_IPHONE_X) {
                self.whiteView.frame = CGRectMake(0, kScreenWidth*(92/108.0)+24, kScreenWidth, kScreenHeight);
            }
            self.blankV.frame = CGRectMake(0, self.NaviTableView.center.y/2.0+100, kScreenWidth, kScreenWidth/2.0);
            self.signBtnOne.frame = CGRectMake(kScreenWidth-35, self.ImageVCenter.y+65*KAdaptiveRateWidth, 28, 28);
            self.signLBFour.alpha = 0;
            self.customView.frame = CGRectMake(0, kScreenWidth*(92/108.0)-64- 30, kScreenWidth, 30);
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*(92/108.0)-64);
            [self.NaviTableView beginUpdates];
            [self.NaviTableView setTableHeaderView:self.headerView];// 关键是这句话
            [self.NaviTableView endUpdates];
        }];
    }
    
}

- (void)signOneClick {
    
    if (self.isShowSignLB) {
        self.isShowSignLB = NO;
        self.signImage.image = [UIImage imageNamed:@"tixing"];
        [UIView animateWithDuration:0.3 animations:^{
            self.whiteView.frame = CGRectMake(0, kScreenWidth*(92/108.0), kScreenWidth, kScreenHeight);
            if (IS_IPHONE_X) {
                self.whiteView.frame = CGRectMake(0, kScreenWidth*(92/108.0)+24, kScreenWidth, kScreenHeight);
            }
            self.blankV.frame = CGRectMake(0, self.NaviTableView.center.y/2.0+100, kScreenWidth, kScreenWidth/2.0);
            self.signBtnOne.frame = CGRectMake(kScreenWidth-35, self.ImageVCenter.y+65*KAdaptiveRateWidth, 28, 28);
            self.signLBFour.alpha = 0;
            self.customView.frame = CGRectMake(0, kScreenWidth*(92/108.0)-64- 30, kScreenWidth, 30);
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*(92/108.0)-64);
            [self.NaviTableView beginUpdates];
            [self.NaviTableView setTableHeaderView:self.headerView];// 关键是这句话
            [self.NaviTableView endUpdates];
        }];
        
    } else {
        self.isShowSignLB = YES;
        self.signImage.image = [UIImage imageNamed:@"shouqi"];
        [UIView animateWithDuration:0.3 animations:^{
            self.whiteView.frame = CGRectMake(0, kScreenWidth+64, kScreenWidth, kScreenHeight);
            if (IS_IPHONE_X) {
                self.whiteView.frame = CGRectMake(0, kScreenWidth+88, kScreenWidth, kScreenHeight);
            }
            self.blankV.frame = CGRectMake(0, self.NaviTableView.center.y/2.0+250, kScreenWidth, kScreenWidth/2.0);
            self.signBtnOne.frame = CGRectMake(kScreenWidth-35, self.ImageVCenter.y+180*KAdaptiveRateWidth, 28, 28);
            self.signLBFour.alpha = 1;
            
            self.customView.frame = CGRectMake(0, kScreenWidth- 30, kScreenWidth, 30);
            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
            [self.NaviTableView beginUpdates];
            [self.NaviTableView setTableHeaderView:self.headerView];// 关键是这句话
            [self.NaviTableView endUpdates];
        }];
    }
    
    
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
