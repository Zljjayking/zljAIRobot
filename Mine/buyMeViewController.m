//
//  buyMeViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/8/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeViewController.h"

#import "buyMeView.h"
#import "buyMeOrderViewController.h"
#import "buyMeMechineView.h"
#import "protocolViewController.h"
#import "buyMe_signView.h"
typedef NS_ENUM(NSInteger, LRLablesStatus) {
    LRLablesStatusIdle,
    LRLablesStatusSpread,
    LRLablesStatusDrawIn,
};
@interface buyMeViewController ()<UIScrollViewDelegate,buyMeDelegate>
{
    UIView *_customNaviBarView;
    
    UILabel *_leftLabel;
    UILabel *_rightLabel;
    CGFloat _poleImageVOffX;
    int     _maxNum;
    
}
@property (assign, nonatomic) LRLablesStatus lrLablesStatus;

@property (nonatomic, assign) NSInteger pageIndex;//滚动到的页数

@property (nonatomic, strong) UILabel *peopleCountLB;//人数的label
@property (nonatomic, assign) NSInteger index;//人数选到什么档位

@property (nonatomic, assign) NSInteger peopleIndex;//已经购买的人数是什么档位

@property (nonatomic, strong) UIImageView *bgImage;//头部到尖角的图片
@property (nonatomic, strong) UIScrollView *mainScrollView;//滚动视图当人数达到110人时滚动
@property (nonatomic, assign) NSInteger monthIndex;//所选月份的index

@property (nonatomic, strong) UIView *viewOne;//加在滚动视图上的一个view
@property (nonatomic, strong) UIView *viewTwo;//加在滚动视图上的一个view
@property (nonatomic, strong) UIView *viewThree;//加在滚动视图上的一个view

@property (nonatomic, strong) UITextField *tf;//显示考勤机数量的控件
@property (nonatomic, strong) UITextField *tf1;//显示高拍数量的控件
@property (nonatomic, assign) NSInteger kaoQinCount;//点击添加的考勤机数量
@property (nonatomic, assign) NSInteger freeKaoQinCount;//免费的考勤机数量
@property (nonatomic, assign) NSInteger gaoPaiCount;//点击添加的高拍数量
@property (nonatomic, assign) NSInteger freeGaoPaiCount;//免费的高拍数量
@property (nonatomic, assign) double discount;//打的折扣
@property (nonatomic, strong) UIView *bgVOne;//考勤机背景
@property (nonatomic, strong) UIView *bgVTwo;//高拍背景
@property (nonatomic, strong) UILabel *moneyLb;//显示价钱的label
@property (nonatomic, strong) UILabel *moneyLbTwo;//显示价钱的label
@property (nonatomic, strong) UILabel *moneyLbThree;//显示价钱的label
@property (nonatomic, strong) buyMeView *buyMeV;//确认付款的界面
@property (nonatomic, strong) NSArray *discountArr;//折扣数据
@property (nonatomic, strong) NSArray *baseArr;//获取到的人头价格表
@property (nonatomic, assign) double baseMoneyPerPerson;//当前人头数下的单价
@property (nonatomic, assign) NSInteger baseMonth;//选择的月数
@property (nonatomic, assign) double baseMoney;//总价
@property (nonatomic, assign) double baseMoneyTwo;//总价
@property (nonatomic, assign) double baseMoneyThree;//总价
@property (nonatomic, assign) double kaoQinBaseMoney;//考勤机的价格
@property (nonatomic, assign) double kaoQinDiscount;//满多少钱送考勤机
@property (nonatomic, assign) NSInteger kaoQinBaseFreeCount;//送多少台考勤机
@property (nonatomic, assign) double gaoPaiBaseMoney;//高拍的价格
@property (nonatomic, assign) double gaoPaiDiscount;//满多少送高拍
@property (nonatomic, assign) NSInteger gaoPaiBaseFreeCount;//送多少台高拍
@property (nonatomic, assign) double mechineMoney;//机器的总价
@property (nonatomic, strong) UIImageView *complimentaryOne;//赠送的图片1 名字是 送一台
@property (nonatomic, strong) UIImageView *complimentaryTwo;//赠送的图片2
@property (nonatomic, assign) BOOL isFirstBuy;//是否第一次购买 1.是 0.否
@property (nonatomic, assign) BOOL isDilatation;//是否是扩容
@property (nonatomic, strong) UILabel *currentPeopleLB;
@property (nonatomic, strong) UILabel *stopTimeLabel;
@property (nonatomic, strong) FDAlertView *alertV;
@property (nonatomic, strong) NSString *specialIcon;
@end



@implementation buyMeViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"软件付费";
    self.index = 0;
    self.kaoQinCount = 0;
    self.gaoPaiCount = 0;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftView addSubview:leftBtn];
    UIImageView *leftBtnImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"返回（左）"]];
    leftBtnImage.frame = CGRectMake(0, 10, 12, 20);
    [leftBtn addTarget:self action:@selector(gobacklll) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftBtnImage];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 44, 44)];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 44, 44);
    [rightBtn setTitle:@"记录" forState:UIControlStateNormal];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightView addSubview:rightBtn];
    
    [rightBtn addTarget:self action:@selector(getPayOrder) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.discount = 1.0;
    
    self.isDilatation = NO;
    if (![Utils isBlankString:self.MyUserInfoModel.vipStopTime] && [[Utils stringToDate:self.MyUserInfoModel.vipStopTime withDateFormat:@"yyyy-MM-dd"] timeIntervalSinceDate:[NSDate date]]) {
        if ([Utils compareTwoDateWithMinDate:self.MyUserInfoModel.currentTime MaxDate:self.MyUserInfoModel.vipStopTime]) {
            self.isDilatation = YES;
        }
    }
    self.isFirstBuy = ![self.MyUserInfoModel.orderExists intValue];
    if (self.isFirstBuy) {
        self.isDilatation = NO;
    }
    self.isDilatation = NO;
    [MBProgressHUD showMessage:@"加载中..."];
    [self requestMoney];
    
    // Do any additional setup after loading the view.
}
#pragma mark == 扩容的界面
- (void)setupDilatationView {
    //这里 self.index 待赋值
    self.peopleIndex = 0;
    if ([self.MyUserInfoModel.personSize longLongValue]/10 > 0) {
        self.peopleIndex = [self.MyUserInfoModel.personSize longLongValue]/10;
    }
    self.index = 0;
    if (self.peopleIndex >= 1) {
        self.index = self.peopleIndex - 1;
    }
    
    self.pageIndex = 1;
    if (self.peopleIndex <= 10) {
        for (NSDictionary *dic in self.baseArr) {
            NSString *key = [NSString stringWithFormat:@"%@",dic[@"key"]];
            if ([key intValue] == self.index*10+10) {
                self.baseMoneyPerPerson = [[NSString stringWithFormat:@"%@",dic[@"value"]] integerValue];
            }
        }
    } else {
        for (NSDictionary *dic in self.baseArr) {
            NSString *key = [NSString stringWithFormat:@"%@",dic[@"key"]];
            if ([key isEqualToString:@"100"]) {
                self.baseMoneyPerPerson = [[NSString stringWithFormat:@"%@",dic[@"value"]] integerValue];
            }
        }

    }
    
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, (kScreenWidth/1200.0) * 531)];
    [self.view addSubview:self.bgImage];
    self.bgImage.image = [UIImage imageWithColor:VIEW_BASE_COLOR];
    self.bgImage.userInteractionEnabled = YES;
    
    UIView *bgView = [[UIView alloc]init];
    [self.bgImage addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.bgImage);
        make.bottom.equalTo(self.bgImage.mas_bottom).offset(-10-32.14*KAdaptiveRateWidth);
    }];
    bgView.layer.borderColor = VIEW_BASE_COLOR.CGColor;
    bgView.layer.borderWidth = 0.3;
    bgView.layer.shadowOpacity = 0.5f;// 阴影透明度
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    bgView.layer.shadowRadius = 2;// 阴影扩散的范围控制
    bgView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    
    UILabel *peopleCountLB = [[UILabel alloc]init];
    peopleCountLB.text = @"当前人数";
    [bgView addSubview:peopleCountLB];
    peopleCountLB.textColor = GRAY200;
    peopleCountLB.font = [UIFont systemFontOfSize:14];
    [peopleCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(15);
        make.top.equalTo(bgView.mas_top).offset(25*KAdaptiveRateWidth);
        make.height.mas_equalTo(15);
    }];
    
    self.currentPeopleLB = [[UILabel alloc]init];
    self.currentPeopleLB.text = [NSString stringWithFormat:@"%@／%@",self.MyUserInfoModel.mechSize,self.MyUserInfoModel.personSize];
    [bgView addSubview:self.currentPeopleLB];
    self.currentPeopleLB.textColor = customBlue;
    self.currentPeopleLB.font = [UIFont systemFontOfSize:25];
    [self.currentPeopleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(15);
        make.centerY.equalTo(bgView.mas_centerY).offset(15);
        make.height.mas_equalTo(26);
    }];
    
    UIView *line = [[UIView alloc]init];
    [bgView addSubview:line];
    line.backgroundColor = GRAY240;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bgView);
        make.top.equalTo(bgView.mas_top).offset(15);
        make.bottom.equalTo(bgView.mas_bottom).offset(-15);
        make.width.mas_equalTo(0.5);
    }];
    
    
    UILabel *stopTimeLB = [[UILabel alloc]init];
    stopTimeLB.text = @"截止时间";
    [bgView addSubview:stopTimeLB];
    stopTimeLB.textColor = GRAY200;
    stopTimeLB.font = [UIFont systemFontOfSize:14];
    [stopTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.top.equalTo(bgView.mas_top).offset(25*KAdaptiveRateWidth);
        make.height.mas_equalTo(15);
    }];
    
    self.stopTimeLabel = [[UILabel alloc]init];
    self.stopTimeLabel.text = [NSString stringWithFormat:@"%@",self.MyUserInfoModel.vipStopTime];
    [bgView addSubview:self.stopTimeLabel];
    self.stopTimeLabel.textColor = customRedColor;
    self.stopTimeLabel.font = [UIFont systemFontOfSize:25];
    [self.stopTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.centerY.equalTo(bgView.mas_centerY).offset(15);
        make.height.mas_equalTo(26);
    }];
    
    NSArray *arr = @[@"购买时长",@"人数扩容",@"购买设备"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgImage addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImage.mas_left).offset((kScreenWidth/3.0)*i);
            make.bottom.equalTo(self.bgImage.mas_bottom);
            make.height.mas_equalTo(32.14*KAdaptiveRateWidth);
            make.width.mas_equalTo(kScreenWidth/3.0);
        }];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.15];
        [btn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag = i+1;
        [btn setTitleColor:GRAY160 forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
        if (i == 0) {
            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateHighlighted];
        }
    }
    
    
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,(kScreenWidth/1200.0) * 531+NaviHeight, kScreenWidth, 80+120*KAdaptiveRateWidth)];
    self.mainScrollView.scrollEnabled = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(3*kScreenWidth, 0);
    [self.view addSubview:self.mainScrollView];
    
    
    self.viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80+120*KAdaptiveRateWidth)];
    self.viewOne.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.viewOne];
    
    [self setupViewOne];
    
    self.viewTwo = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, 80+120*KAdaptiveRateWidth)];
    self.viewTwo.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.viewTwo];
    
    [self setupViewTwo];
    
    self.viewThree = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, 80+120*KAdaptiveRateWidth)];//kScreenHeight-64-(kScreenWidth/1200.0) * 531
    self.viewThree.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:self.viewThree];
    
    [self setupViewThree];
    
    
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrollView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(130);
    }];
    
    UIView *lineTwo = [[UIView alloc]init];
    [bottomView addSubview:lineTwo];
    lineTwo.backgroundColor = GRAY240;
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.right.equalTo(bottomView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.moneyLb = [[UILabel alloc]init];
    self.moneyLb.textColor = customRedColor;
    [self.view addSubview:self.moneyLb];
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.mainScrollView.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoney];
    
    
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:signBtn];
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateNormal];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateHighlighted];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrollView.mas_bottom).offset(40);
        make.centerX.equalTo(self.viewOne.mas_centerX);
        make.height.mas_equalTo(15);
    }];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"支付即代表同意《瀚语智能购买协议》"];
    [attStr addAttributes:@{NSForegroundColorAttributeName:customBlue,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(7, 10)];//添加属性
    [attStr addAttributes:@{NSForegroundColorAttributeName:GRAY180,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 7)];//添加属性
    [signBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:payBtn];
    [payBtn addTarget:self action:@selector(clickToPay) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    payBtn.layer.masksToBounds = YES;
    payBtn.layer.cornerRadius = 5;
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(signBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(280*KAdaptiveRateWidth);
    }];
    
}

- (void)setupViewOne {
    for (int i = 0; i<=2; i++) {
        NSString *titleOne;
        NSString *titleTwo;
        if (i == 0) {
            titleOne = [NSString stringWithFormat:@"1"];
            titleTwo = [NSString stringWithFormat:@"1个月"];
        } else if (i == 1) {
            titleOne = [NSString stringWithFormat:@"2"];
            titleTwo = [NSString stringWithFormat:@"2个月"];
        } else if (i == 2){
            titleOne = @"3";
            titleTwo = @"3个月";
        } else if (i == 3){
            titleOne = @"12";
            titleTwo = @"12个月";
        } else if (i == 4){
            titleOne = @"24";
            titleTwo = @"24个月";
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i+1) * ((kScreenWidth-3*60*KAdaptiveRateWidth)/4.0)+i*60*KAdaptiveRateWidth, 40+45*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 40*KAdaptiveRateWidth);
        btn.tag = (i+1)*100;
        [btn addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:titleOne forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20*KAdaptiveRateWidth;
        [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i == 0) {
            self.monthIndex = 1;
            self.baseMonth = 12;
            for (NSDictionary *dic in self.discountArr) {
                if (self.baseMonth == [dic[@"time"] integerValue]) {
                    self.discount = [dic[@"discount"] doubleValue];
                }
            }
            self.baseMoney = self.baseMoneyPerPerson * self.baseMonth * (self.peopleIndex*10);
            self.freeKaoQinCount = 0;
            self.freeGaoPaiCount = 0;
            [btn setTitle:titleTwo forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            CGPoint p1 = btn.center;
            btn.frame = CGRectMake((i+1) * ((kScreenWidth-3*60*KAdaptiveRateWidth)/4.0)+i*60*KAdaptiveRateWidth, 40+(40-30*KAdaptiveRateWidth)/2.0, 100*KAdaptiveRateWidth, 40*KAdaptiveRateWidth);
            btn.center = p1;
        }
        [self.viewOne addSubview:btn];
    }
    
    

}

- (void)setupViewTwo {
    
    self.peopleCountLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100, 50)];
    [self.viewTwo addSubview:self.peopleCountLB];
    [self.peopleCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.viewTwo.mas_centerY);
        make.centerX.equalTo(self.viewTwo.mas_centerX);
        make.height.mas_equalTo(50);
    }];
    self.peopleCountLB.textAlignment = NSTextAlignmentCenter;
    self.peopleCountLB.text = [NSString stringWithFormat:@"%ld",[self.MyUserInfoModel.personSize integerValue]];
    self.peopleCountLB.textColor = GRAY70;
    self.peopleCountLB.font = [UIFont systemFontOfSize:50];
    
    UILabel *renLB = [[UILabel alloc]init];
    [self.viewTwo addSubview:renLB];
    renLB.text = @"条";
    renLB.font = [UIFont systemFontOfSize:10];
    [renLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peopleCountLB.mas_right);
        make.bottom.equalTo(self.peopleCountLB.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    
    for (NSDictionary *dic in self.baseArr) {
        NSString *key = [NSString stringWithFormat:@"%@",dic[@"key"]];
        if ([key isEqualToString:self.peopleCountLB.text]) {
            self.baseMoneyPerPerson = [[NSString stringWithFormat:@"%@",dic[@"value"]] integerValue];
        }
    }
//    NSInteger sec = [[Utils stringToDate:self.MyUserInfoModel.vipStopTime withDateFormat:@"yyyy-MM-dd"] timeIntervalSinceDate:[Utils stringToDate:[Utils dateToString:[NSDate date] withDateFormat:@"yyyy-MM-dd"] withDateFormat:@"yyyy-MM-dd"]];
    self.baseMoneyTwo = 0;
    UIButton *plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(20*KAdaptiveRateWidth, 100*KAdaptiveRateWidth, 40*KAdaptiveRateWidth, 40*KAdaptiveRateWidth)];
    [self.viewTwo addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.viewTwo.mas_left).offset(20*KAdaptiveRateWidth);
        make.centerY.equalTo(self.peopleCountLB.mas_centerY);
        make.width.height.mas_equalTo(40*KAdaptiveRateWidth);
    }];
    plusBtn.tag = 1;
    [plusBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(5*KAdaptiveRateWidth, 5*KAdaptiveRateWidth, 30*KAdaptiveRateWidth, 30*KAdaptiveRateWidth)];
    imageOne.contentMode = UIViewContentModeScaleAspectFit;
    imageOne.image = [UIImage imageNamed:@"buyMe_blackJian"];
    [plusBtn addSubview:imageOne];
    
    
    UIButton *plusBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60*KAdaptiveRateWidth, 100*KAdaptiveRateWidth, 40*KAdaptiveRateWidth, 40*KAdaptiveRateWidth)];
    [self.viewTwo addSubview:plusBtn1];
    [plusBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewTwo.mas_right).offset(-20*KAdaptiveRateWidth);
        make.centerY.equalTo(self.peopleCountLB.mas_centerY);
        make.width.height.mas_equalTo(40*KAdaptiveRateWidth);
    }];
    plusBtn1.tag = 2;
    [plusBtn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(5*KAdaptiveRateWidth, 5*KAdaptiveRateWidth, 30*KAdaptiveRateWidth, 30*KAdaptiveRateWidth)];
    imageTwo.image = [UIImage imageNamed:@"buyMe_blackJia"];
    [plusBtn1 addSubview:imageTwo];
    

}

- (void)setupViewThree {
    
    self.baseMoneyThree = 0.0;
    
    self.bgVOne = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 60*KAdaptiveRateWidth+20)];
    [self.viewThree addSubview:self.bgVOne];
    self.bgVOne.backgroundColor = [UIColor whiteColor];
    if (self.kaoQinCount) {
        self.bgVOne.backgroundColor = GRAY229;
    }
    self.bgVTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+60*KAdaptiveRateWidth, kScreenWidth, 60*KAdaptiveRateWidth+20)];
    [self.viewThree addSubview:self.bgVTwo];
    self.bgVTwo.backgroundColor = [UIColor whiteColor];
    if (self.gaoPaiCount) {
        self.bgVTwo.backgroundColor = GRAY229;
    }
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, 20+0*KAdaptiveRateWidth, kScreenWidth, 0.5f)];
    lineOne.backgroundColor = VIEW_BASE_COLOR;
//    [self.viewThree addSubview:lineOne];
    
    UIButton *kaoQinJi = [UIButton buttonWithType:UIButtonTypeCustom];
    kaoQinJi.tag = 1000;
    [kaoQinJi addTarget:self action:@selector(clickMechine:) forControlEvents:UIControlEventTouchUpInside];
    [kaoQinJi setBackgroundImage:[UIImage imageNamed:@"buyMe_kaoQinJi"] forState:UIControlStateNormal];
    kaoQinJi.frame = CGRectMake(15, 30+0*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth);
    [self.viewThree addSubview:kaoQinJi];
    
    UILabel *labelOne = [[UILabel alloc]init];
    [self.viewThree addSubview:labelOne];
    labelOne.textColor = GRAY100;
    labelOne.text = @"WiFi指纹考勤机";
    labelOne.font = [UIFont systemFontOfSize:15];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaoQinJi.mas_right).offset(10);
        make.top.equalTo(kaoQinJi.mas_top).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labelTwo = [[UILabel alloc]init];
    [self.viewThree addSubview:labelTwo];
    labelTwo.textColor = GRAY150;
    labelTwo.text = [NSString stringWithFormat:@"4.3英寸超大显示屏，急速打卡"];
    labelTwo.font = [UIFont systemFontOfSize:9];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaoQinJi.mas_right).offset(10);
        make.top.equalTo(labelOne.mas_bottom).offset(5);
        make.height.mas_equalTo(9);
    }];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle; //NSNumberFormatterDecimalStyle;
    NSString *kaoQinFloatStr = [NSString stringWithFormat:@"%.2f",self.kaoQinBaseMoney];
    NSString *kaoQinPrice = [formatter stringFromNumber:[NSNumber numberWithFloat:[kaoQinFloatStr floatValue]]];
    kaoQinPrice = [kaoQinPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![kaoQinPrice containsString:@"."]) {
        kaoQinPrice = [NSString stringWithFormat:@"%@.00",kaoQinPrice];
    }
    UILabel *labelFour = [[UILabel alloc]init];
    [self.viewThree addSubview:labelFour];
    labelFour.text = [NSString stringWithFormat:@"¥%@／台",kaoQinPrice];
    labelFour.textColor = customRedColor;
    labelFour.font = [UIFont systemFontOfSize:13];
    [labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaoQinJi.mas_right).offset(10);
        make.bottom.equalTo(kaoQinJi.mas_bottom).offset(-5);
        make.height.mas_equalTo(13);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewThree addSubview:addBtn];
    addBtn.tag = 100;
    [addBtn addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewThree.mas_right).offset(-10);
        make.bottom.equalTo(kaoQinJi.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    UIImageView *addImage3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jia"]];
    [addBtn addSubview:addImage3];
    [addImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn.mas_left);
        make.centerY.equalTo(addBtn.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    self.tf = [[UITextField alloc]init];
    self.tf.enabled = NO;
    self.tf.text = [NSString stringWithFormat:@"%ld",self.kaoQinCount];
    self.tf.font = [UIFont systemFontOfSize:15];
    [self.viewThree addSubview:self.tf];
    self.tf.textAlignment = NSTextAlignmentCenter;
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left);
        make.centerY.equalTo(addBtn.mas_centerY).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewThree addSubview:jianBtn];
    jianBtn.tag = 101;
    [jianBtn addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [jianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tf.mas_left).offset(0);
        make.bottom.equalTo(kaoQinJi.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    UIImageView *addImage4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jian"]];
    [jianBtn addSubview:addImage4];
    [addImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jianBtn.mas_right);
        make.centerY.equalTo(jianBtn.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 40+60*KAdaptiveRateWidth, kScreenWidth, 0.5f)];
    lineTwo.backgroundColor = GRAY229;
    
    UIButton *gaoPai = [UIButton buttonWithType:UIButtonTypeCustom];
    gaoPai.tag = 2000;
    [gaoPai addTarget:self action:@selector(clickMechine:) forControlEvents:UIControlEventTouchUpInside];
    [gaoPai setBackgroundImage:[UIImage imageNamed:@"buyMe_gaoPai"] forState:UIControlStateNormal];
    gaoPai.frame = CGRectMake(15, 50+60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth);
    [self.viewThree addSubview:gaoPai];
    
    
    UILabel *labelOne1 = [[UILabel alloc]init];
    [self.viewThree addSubview:labelOne1];
    labelOne1.textColor = GRAY100;
    labelOne1.text = @"便携式高拍仪";
    labelOne1.font = [UIFont systemFontOfSize:15];
    [labelOne1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gaoPai.mas_right).offset(10);
        make.top.equalTo(gaoPai.mas_top).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labelTwo1 = [[UILabel alloc]init];
    [self.viewThree addSubview:labelTwo1];
    labelTwo1.textColor = GRAY150;
    //    labelTwo1.text = @"(首次购买满16000免费赠送一台)";
    labelTwo1.text = [NSString stringWithFormat:@"1000万像素高清高速高拍仪"];
    labelTwo1.font = [UIFont systemFontOfSize:9];
    [labelTwo1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gaoPai.mas_right).offset(10);
        make.top.equalTo(labelOne1.mas_bottom).offset(5);
        make.height.mas_equalTo(9);
    }];
    
    NSString *gaoPaiFloatStr = [NSString stringWithFormat:@"%.2f",self.gaoPaiBaseMoney];
    NSString *gaoPaiPrice = [formatter stringFromNumber:[NSNumber numberWithFloat:[gaoPaiFloatStr floatValue]]];
    gaoPaiPrice = [gaoPaiPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![gaoPaiPrice containsString:@"."]) {
        gaoPaiPrice = [NSString stringWithFormat:@"%@.00",gaoPaiPrice];
    }
    UILabel *labelFour1 = [[UILabel alloc]init];
    [self.viewThree addSubview:labelFour1];
    labelFour1.text = [NSString stringWithFormat:@"¥%@／台",gaoPaiPrice];
    labelFour1.textColor = customRedColor;
    labelFour1.font = [UIFont systemFontOfSize:13];
    [labelFour1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gaoPai.mas_right).offset(10);
        make.bottom.equalTo(gaoPai.mas_bottom).offset(-5);
        make.height.mas_equalTo(13);
    }];
    
    UIButton *addBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewThree addSubview:addBtn1];
    addBtn1.tag = 102;
    [addBtn1 addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.viewThree.mas_right).offset(-10);
        make.bottom.equalTo(gaoPai.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    
    UIImageView *addImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jia"]];
    [addBtn1 addSubview:addImage1];
    [addImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn1.mas_left);
        make.centerY.equalTo(addBtn1.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    self.tf1 = [[UITextField alloc]init];
    self.tf1.enabled = NO;
    self.tf1.text = [NSString stringWithFormat:@"%ld",self.gaoPaiCount];
    self.tf1.font = [UIFont systemFontOfSize:15];
    [self.viewThree addSubview:self.tf1];
    self.tf1.textAlignment = NSTextAlignmentCenter;
    [self.tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn1.mas_left);
        make.centerY.equalTo(addBtn1.mas_centerY).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    UIButton *jianBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewThree addSubview:jianBtn1];
    jianBtn1.tag = 103;
    [jianBtn1 addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [jianBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tf1.mas_left).offset(0);
        make.bottom.equalTo(gaoPai.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    UIImageView *addImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jian"]];
    [jianBtn1 addSubview:addImage2];
    [addImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jianBtn1.mas_right);
        make.centerY.equalTo(jianBtn1.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}
- (void)gobacklll {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getPayOrder {
    buyMeOrderViewController *buyMeOrderVC = [buyMeOrderViewController new];
    [self.navigationController pushViewController:buyMeOrderVC animated:YES];
}
- (void)requestMoney {
    
    [HttpRequestEngine getPriceOneOfPersonCompletion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            self.baseArr = obj;
            if (self.baseArr.count) {
                for (NSDictionary *dic in self.baseArr) {
                    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                    if ([type isEqualToString:@"2"]) {
                        self.kaoQinBaseMoney = [dic[@"value"] integerValue];
                    }
                    if ([type isEqualToString:@"1"]) {
                        self.gaoPaiBaseMoney = [dic[@"value"] integerValue];
                    }
                }

//                if (self.isDilatation) {
//                    [self setupDilatationView];
//                } else {
//                    self.navBarView.backgroundColor = kMyColor(140, 140, 140);
//                    if (self.isFirstBuy) {
//                        [self requestDiscount];
//                    } else {
//                        [self setupView];
//                    }
//                }
#pragma mark ==== 对接语音机器人
                self.isDilatation = 0;
                self.navBarView.backgroundColor = kMyColor(140, 140, 140);
                self.navBarView.frame = CGRectMake(0, 0, kScreenWidth, NaviHeight*2);
                [self setupView];
                
                [MBProgressHUD hideHUD];
            } else {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求基本收费有误"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求基本收费有误"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
#pragma mark == 请求优惠活动
- (void)requestDiscount {
    [HttpRequestEngine getDisCountCompletion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            self.discountArr = obj;
            if (self.discountArr.count) {
                for (NSDictionary *dic in self.discountArr) {
                    NSString *attendanceMachine = [NSString stringWithFormat:@"%@",dic[@"attendanceMachine"]];
                    NSString *projection = [NSString stringWithFormat:@"%@",dic[@"projection"]];
                    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                    if ((![Utils isBlankString:attendanceMachine] && ![attendanceMachine isEqualToString:@"0"]) && ([Utils isBlankString:projection]  || [projection isEqualToString:@"0"])) {
                        self.kaoQinDiscount = [dic[@"value"] integerValue];
                        self.kaoQinBaseFreeCount = [dic[@"attendanceMachine"] integerValue];
                    }
                    if ((![Utils isBlankString:projection]  && ![projection isEqualToString:@"0"]) && (![Utils isBlankString:attendanceMachine] && ![attendanceMachine isEqualToString:@"0"])) {
                        self.gaoPaiDiscount = [dic[@"value"] integerValue];
                        self.kaoQinBaseFreeCount = [attendanceMachine integerValue];
                        self.gaoPaiBaseFreeCount = [projection integerValue];
                    }
                    if ([type isEqualToString:@"3"]) {
#pragma mark == 活动图片
                        self.specialIcon = dic[@"icon"];
                    }
                }
                self.isDilatation = 0;
                [self setupView];
                
            } else {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求基本收费有误"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请求基本收费有误"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}
- (void)setupView {
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, NaviHeight*2, kScreenWidth, (kScreenWidth/1500.0) * 531)];
    [self.view addSubview:self.bgImage];
    self.bgImage.image = [UIImage imageNamed:@"buyMe_shape"];
    self.bgImage.userInteractionEnabled = YES;
    [self createNumberFadedView];
    [self createLeftAndRightLabel];
    [self createScrollView];
    
}
- (void)createNumberFadedView
{
    NSMutableArray *strings = [NSMutableArray new];
    for (int i = 10; i <= 100; i = i+10) {
        NSString *numberString = [NSString stringWithFormat:@"%d", i];
        [strings addObject:numberString];
    }
    
//    _numberFadedView = [[CRNumberFaded alloc] initWithFrame:CGRectMake(0, 0,40*KAdaptiveRateWidth, 40*KAdaptiveRateWidth)];
//    _numberFadedView.font = [UIFont systemFontOfSize:40*KAdaptiveRateWidth weight:0.1];//[UIFont fontWithName:@"Helvetica-Bold" size:80]
//    _numberFadedView.textColor = [UIColor whiteColor];
//    _numberFadedView.strings = strings;
//    _numberFadedView.delegate = self;
//    _numberFadedView.backgroundColor = [UIColor clearColor];
////    [self.bgImage addSubview:_numberFadedView];
//    _numberFadedView.center = CGPointMake(self.bgImage.center.x, self.bgImage.center.y+20*KAdaptiveRateWidth);
    
    self.peopleCountLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,130, 45)];
    [self.bgImage addSubview:self.peopleCountLB];
    self.peopleCountLB.textAlignment = NSTextAlignmentRight;
    self.peopleCountLB.text = @"1";
    self.peopleCountLB.center = CGPointMake(self.view.center.x-50, self.bgImage.center.y-10-NaviHeight*2);
    self.peopleCountLB.textColor = [UIColor whiteColor];
    self.peopleCountLB.font = [UIFont systemFontOfSize:45];
    
#pragma mark ==== 获取单价
    NSDictionary *dic = self.baseArr[0];
    self.baseMoneyPerPerson = [[NSString stringWithFormat:@"%@",dic[@"value"]] doubleValue];
    
//    for (NSDictionary *dic in self.baseArr) {
//        NSString *key = [NSString stringWithFormat:@"%@",dic[@"key"]];
//        if ([key isEqualToString:@"10"]) {
//            self.baseMoneyPerPerson = [[NSString stringWithFormat:@"%@",dic[@"value"]] doubleValue];
//        }
//    }
    
    UIButton *plusBtn = [[UIButton alloc]initWithFrame:CGRectMake(20*KAdaptiveRateWidth, 100*KAdaptiveRateWidth, 40*KAdaptiveRateWidth, 40*KAdaptiveRateWidth)];
    [self.bgImage addSubview:plusBtn];
    CGPoint p = plusBtn.center;
    p.y = self.bgImage.center.y-10-NaviHeight*2;
    plusBtn.center = p;
    plusBtn.tag = 1;
    [plusBtn addTarget:self action:@selector(clickBtnTwo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(10*KAdaptiveRateWidth, 10*KAdaptiveRateWidth, 20*KAdaptiveRateWidth, 20*KAdaptiveRateWidth)];
    imageOne.contentMode = UIViewContentModeScaleAspectFit;
    imageOne.image = [UIImage imageNamed:@"减号"];
    [plusBtn addSubview:imageOne];
    
    
    UIButton *plusBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60*KAdaptiveRateWidth, 100*KAdaptiveRateWidth, 40*KAdaptiveRateWidth, 40*KAdaptiveRateWidth)];
    [self.bgImage addSubview:plusBtn1];
    CGPoint p1 = plusBtn1.center;
    p1.y = self.bgImage.center.y-10-NaviHeight*2;
    plusBtn1.center = p1;
    plusBtn1.tag = 2;
    [plusBtn1 addTarget:self action:@selector(clickBtnTwo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(10*KAdaptiveRateWidth, 10*KAdaptiveRateWidth, 20*KAdaptiveRateWidth, 20*KAdaptiveRateWidth)];
    imageTwo.image = [UIImage imageNamed:@"加号"];
    [plusBtn1 addSubview:imageTwo];
    
}

- (void)createScrollView {
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,(kScreenWidth/1500.0) * 531+30+NaviHeight, kScreenWidth, kScreenHeight-(kScreenWidth/1500.0) * 531)];
    self.mainScrollView.scrollEnabled = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, 0);
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImage.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.mainScrollView.mj_h)];
    self.viewOne.backgroundColor = VIEW_BASE_COLOR;
    [self.mainScrollView addSubview:self.viewOne];
//    [self createSubViewsInView:self.viewOne];
    
    self.index = 1;
    self.baseMonth = 12;
    self.discount = 1.0;
    self.baseMoney = self.baseMoneyPerPerson * self.index * self.discount;
    
    self.moneyLb = [[UILabel alloc]init];
    self.moneyLb.textColor = customRedColor;
    self.moneyLb.font = [UIFont systemFontOfSize:25];
    [self.viewOne addSubview:self.moneyLb];
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewOne.mas_centerX);
        make.top.equalTo(self.bgImage.mas_bottom).offset(20);
        make.height.mas_equalTo(25);
    }];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle; //NSNumberFormatterDecimalStyle;
    NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoney];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
    if (![string contains:@"."]) {
        string = [NSString stringWithFormat:@"%@.00",string];
    }
    self.moneyLb.text = [NSString stringWithFormat:@"¥%@",string];
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewOne addSubview:payBtn];
    [payBtn addTarget:self action:@selector(clickToPay) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    payBtn.layer.masksToBounds = YES;
    payBtn.layer.cornerRadius = 5;
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewOne.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-150);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(280*KAdaptiveRateWidth);
    }];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewOne addSubview:signBtn];
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateNormal];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateHighlighted];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(payBtn.mas_top).offset(-10);
        make.centerX.equalTo(self.viewOne.mas_centerX);
        make.height.mas_equalTo(15);
    }];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"支付即代表同意《瀚语智能购买协议》"];
    [attStr addAttributes:@{NSForegroundColorAttributeName:customBlue,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(7, 10)];//添加属性
    [attStr addAttributes:@{NSForegroundColorAttributeName:GRAY180,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 7)];//添加属性
    [signBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    UIView *viewTwo = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-30-(kScreenWidth/1500.0) * 531)];
    viewTwo.backgroundColor = VIEW_BASE_COLOR;
    [self.mainScrollView addSubview:viewTwo];
    
//    if (![Utils isBlankString:self.specialIcon]) {
//        FDAlertView *alertV = [[FDAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        alertV.backgroundColor = customBackColor;
//        UIImageView *specialImageV = [[UIImageView alloc]init];
//
//        [specialImageV sd_setImageWithURL:[NSURL URLWithString:self.specialIcon] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            specialImageV.frame = CGRectMake(0, 0, 280*KAdaptiveRateWidth, ((280*KAdaptiveRateWidth)/image.size.width*1.0)*image.size.height);
//            alertV.contentView = specialImageV;
//            [alertV showInView:self.navigationController.view];
//        }];
//
//    }
}
- (void)createSubViewsInView:(UIView *)view {
    
    UIImageView *imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"乘号"]];
    imagev.contentMode = UIViewContentModeScaleAspectFill;
    imagev.frame = CGRectMake( kScreenWidth/2.0-9, 10, 18, 18);
    [view addSubview:imagev];
    
    for (int i = 0; i<=2; i++) {
        NSString *titleOne;
        NSString *titleTwo;
        if (i == 0) {
            titleOne = [NSString stringWithFormat:@"1"];
            titleTwo = [NSString stringWithFormat:@"1年"];
        } else if (i == 1) {
            titleOne = [NSString stringWithFormat:@"2"];
            titleTwo = [NSString stringWithFormat:@"2年"];
        } else if (i == 2){
            titleOne = @"3";
            titleTwo = @"3年";
        } else if (i == 3){
            titleOne = @"4";
            titleTwo = @"4个月";
        } else if (i == 4){
            titleOne = @"24";
            titleTwo = @"24个月";
        }
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((i+1) * ((kScreenWidth-3*60*KAdaptiveRateWidth)/4.0)+i*60*KAdaptiveRateWidth, 40+(40-30*KAdaptiveRateWidth)/2.0, 60*KAdaptiveRateWidth, 40*KAdaptiveRateWidth);
        btn.tag = (i+1)*100;
        [btn addTarget:self action:@selector(monthClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:titleOne forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20*KAdaptiveRateWidth;
        [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (i == 0) {
            self.monthIndex = 1;
            self.baseMonth = 12;
            for (NSDictionary *dic in self.discountArr) {
                if (self.baseMonth == [dic[@"time"] integerValue]) {
                    self.discount = [dic[@"discount"] doubleValue];
                }
            }
            self.discount = 1.0;
            self.baseMoney = self.baseMoneyPerPerson * self.baseMonth * (10 + self.index*10) * self.discount;
            if (self.isFirstBuy) {
                if (self.baseMoney > self.kaoQinDiscount) {
                    self.freeKaoQinCount = self.kaoQinBaseFreeCount;
                }
                if (self.baseMoney > self.gaoPaiDiscount) {
                    self.freeGaoPaiCount = self.gaoPaiBaseFreeCount;
                }
            } else {
                self.freeKaoQinCount = 0;
                self.freeGaoPaiCount = 0;
            }
            
            [btn setTitle:titleTwo forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
            [btn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            CGPoint p1 = btn.center;
            btn.frame = CGRectMake((i+1) * ((kScreenWidth-3*55*KAdaptiveRateWidth)/4.0)+i*55*KAdaptiveRateWidth, 40+(40-30*KAdaptiveRateWidth)/2.0, 100*KAdaptiveRateWidth, 40*KAdaptiveRateWidth);
            btn.center = p1;
        }
        [view addSubview:btn];
        
        if (i == 3 || i == 4) {
            if (self.isFirstBuy) {
                UILabel *discountLB = [[UILabel alloc] init];
                discountLB.textColor = customRedColor;
                discountLB.font = [UIFont systemFontOfSize:9];
                [view addSubview:discountLB];
                [discountLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(btn.mas_right).offset(3);
                    make.top.equalTo(btn.mas_top).offset(-3);
                    make.height.mas_equalTo(10);
                }];
                if (i == 1) {
                    discountLB.text = @"8.5折";
                } else {
                    discountLB.text = @"7.5折";
                }
            }
            
        }
    }
    
    UIImageView *addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_add"]];
    [view addSubview:addImage];
    addImage.frame = CGRectMake( kScreenWidth/2.0-10, 50+50, 20, 20);
    
    self.bgVOne = [[UIView alloc]initWithFrame:CGRectMake(0, 80+50, kScreenWidth, 60*KAdaptiveRateWidth+20)];
    [view addSubview:self.bgVOne];
    self.bgVOne.backgroundColor = VIEW_BASE_COLOR;
    if (self.kaoQinCount) {
        self.bgVOne.backgroundColor = GRAY229;
    }
    self.bgVTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 150+60*KAdaptiveRateWidth, kScreenWidth, 60*KAdaptiveRateWidth+20)];
    [view addSubview:self.bgVTwo];
    self.bgVTwo.backgroundColor = VIEW_BASE_COLOR;
    if (self.gaoPaiCount) {
        self.bgVTwo.backgroundColor = GRAY229;
    }
    UIView *lineOne = [[UIView alloc]initWithFrame:CGRectMake(0, 130+0*KAdaptiveRateWidth, kScreenWidth, 0.5f)];
    lineOne.backgroundColor = GRAY229;
    [view addSubview:lineOne];
    
    UIButton *kaoQinJi = [UIButton buttonWithType:UIButtonTypeCustom];
    kaoQinJi.tag = 1000;
    [kaoQinJi addTarget:self action:@selector(clickMechine:) forControlEvents:UIControlEventTouchUpInside];
    [kaoQinJi setBackgroundImage:[UIImage imageNamed:@"buyMe_kaoQinJi"] forState:UIControlStateNormal];
    kaoQinJi.frame = CGRectMake(15, 140+0*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth);
    [view addSubview:kaoQinJi];
    
    UILabel *labelOne = [[UILabel alloc]init];
    [view addSubview:labelOne];
    labelOne.textColor = GRAY100;
    labelOne.text = @"WiFi指纹考勤机";
    labelOne.font = [UIFont systemFontOfSize:15];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaoQinJi.mas_right).offset(10);
        make.top.equalTo(kaoQinJi.mas_top).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labelTwo = [[UILabel alloc]init];
    [view addSubview:labelTwo];
    labelTwo.textColor = GRAY150;
    labelTwo.text = [NSString stringWithFormat:@"4.3英寸超大显示屏，急速打卡"];
    labelTwo.font = [UIFont systemFontOfSize:9];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaoQinJi.mas_right).offset(10);
        make.top.equalTo(labelOne.mas_bottom).offset(5);
        make.height.mas_equalTo(9);
    }];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle; //NSNumberFormatterDecimalStyle;
    NSString *kaoQinFloatStr = [NSString stringWithFormat:@"%.2f",self.kaoQinBaseMoney];
    NSString *kaoQinPrice = [formatter stringFromNumber:[NSNumber numberWithFloat:[kaoQinFloatStr floatValue]]];
    kaoQinPrice = [kaoQinPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![kaoQinPrice containsString:@"."]) {
        kaoQinPrice = [NSString stringWithFormat:@"%@.00",kaoQinPrice];
    }
    UILabel *labelFour = [[UILabel alloc]init];
    [view addSubview:labelFour];
    labelFour.text = [NSString stringWithFormat:@"¥%@／台",kaoQinPrice];
    labelFour.textColor = customRedColor;
    labelFour.font = [UIFont systemFontOfSize:13];
    [labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kaoQinJi.mas_right).offset(10);
        make.bottom.equalTo(kaoQinJi.mas_bottom).offset(-5);
        make.height.mas_equalTo(13);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:addBtn];
    addBtn.tag = 100;
    [addBtn addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.bottom.equalTo(kaoQinJi.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    UIImageView *addImage3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jia"]];
    [addBtn addSubview:addImage3];
    [addImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn.mas_left);
        make.centerY.equalTo(addBtn.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    self.tf = [[UITextField alloc]init];
    self.tf.enabled = NO;
    self.tf.text = [NSString stringWithFormat:@"%ld",self.kaoQinCount];
    self.tf.font = [UIFont systemFontOfSize:15];
    [view addSubview:self.tf];
    self.tf.textAlignment = NSTextAlignmentCenter;
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn.mas_left);
        make.centerY.equalTo(addBtn.mas_centerY).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:jianBtn];
    jianBtn.tag = 101;
    [jianBtn addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [jianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tf.mas_left).offset(0);
        make.bottom.equalTo(kaoQinJi.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    UIImageView *addImage4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jian"]];
    [jianBtn addSubview:addImage4];
    [addImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jianBtn.mas_right);
        make.centerY.equalTo(jianBtn.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    UIView *lineTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 150+60*KAdaptiveRateWidth, kScreenWidth, 0.5f)];
    lineTwo.backgroundColor = GRAY229;
    [view addSubview:lineTwo];
    
    UIButton *gaoPai = [UIButton buttonWithType:UIButtonTypeCustom];
    gaoPai.tag = 2000;
    [gaoPai addTarget:self action:@selector(clickMechine:) forControlEvents:UIControlEventTouchUpInside];
    [gaoPai setBackgroundImage:[UIImage imageNamed:@"buyMe_gaoPai"] forState:UIControlStateNormal];
    gaoPai.frame = CGRectMake(15, 160+60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth);
    [view addSubview:gaoPai];
    
    
    UILabel *labelOne1 = [[UILabel alloc]init];
    [view addSubview:labelOne1];
    labelOne1.textColor = GRAY120;
    labelOne1.text = @"便携式高拍仪";
    labelOne1.font = [UIFont systemFontOfSize:15];
    [labelOne1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gaoPai.mas_right).offset(10);
        make.top.equalTo(gaoPai.mas_top).offset(5);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labelTwo1 = [[UILabel alloc]init];
    [view addSubview:labelTwo1];
    labelTwo1.textColor = GRAY150;
    labelTwo1.text = [NSString stringWithFormat:@"1000万像素高清高速高拍仪"];
    labelTwo1.font = [UIFont systemFontOfSize:9];
    [labelTwo1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gaoPai.mas_right).offset(10);
        make.top.equalTo(labelOne1.mas_bottom).offset(5);
        make.height.mas_equalTo(9);
    }];
    
    NSString *gaoPaiFloatStr = [NSString stringWithFormat:@"%.2f",self.gaoPaiBaseMoney];
    NSString *gaoPaiPrice = [formatter stringFromNumber:[NSNumber numberWithFloat:[gaoPaiFloatStr floatValue]]];
    gaoPaiPrice = [gaoPaiPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
    if (![gaoPaiPrice containsString:@"."]) {
        gaoPaiPrice = [NSString stringWithFormat:@"%@.00",gaoPaiPrice];
    }
    UILabel *labelFour1 = [[UILabel alloc]init];
    [view addSubview:labelFour1];
    labelFour1.text = [NSString stringWithFormat:@"¥%@／台",gaoPaiPrice];
    labelFour1.textColor = customRedColor;
    labelFour1.font = [UIFont systemFontOfSize:13];
    [labelFour1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gaoPai.mas_right).offset(10);
        make.bottom.equalTo(gaoPai.mas_bottom).offset(-5);
        make.height.mas_equalTo(13);
    }];
    
    UIButton *addBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:addBtn1];
    addBtn1.tag = 102;
    [addBtn1 addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.bottom.equalTo(gaoPai.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    
    UIImageView *addImage1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jia"]];
    [addBtn1 addSubview:addImage1];
    [addImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addBtn1.mas_left);
        make.centerY.equalTo(addBtn1.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    self.tf1 = [[UITextField alloc]init];
    self.tf1.enabled = NO;
    self.tf1.text = [NSString stringWithFormat:@"%ld",self.gaoPaiCount];
    self.tf1.font = [UIFont systemFontOfSize:15];
    [view addSubview:self.tf1];
    self.tf1.textAlignment = NSTextAlignmentCenter;
    [self.tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addBtn1.mas_left);
        make.centerY.equalTo(addBtn1.mas_centerY).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(30);
    }];
    
    UIButton *jianBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:jianBtn1];
    jianBtn1.tag = 103;
    [jianBtn1 addTarget:self action:@selector(addOrJian:) forControlEvents:UIControlEventTouchUpInside];
    [jianBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tf1.mas_left).offset(0);
        make.bottom.equalTo(gaoPai.mas_bottom).offset(0);
        make.height.width.mas_equalTo(30);
    }];
    UIImageView *addImage2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyMe_jian"]];
    [jianBtn1 addSubview:addImage2];
    [addImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jianBtn1.mas_right);
        make.centerY.equalTo(jianBtn1.mas_centerY).offset(5);
        make.width.height.mas_equalTo(20);
    }];
    
    UIView *lineThree = [[UIView alloc]initWithFrame:CGRectMake(0, 170+120*KAdaptiveRateWidth, kScreenWidth, 0.5f)];
    lineThree.backgroundColor = GRAY229;
    [view addSubview:lineThree];
    
    
    self.complimentaryOne = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"送一台"]];
    self.complimentaryOne.hidden = YES;
    [view addSubview:self.complimentaryOne];
    [self.complimentaryOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgVOne.mas_centerY);
        make.centerX.equalTo(self.bgVOne.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    self.complimentaryTwo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"送一台"]];
    [view addSubview:self.complimentaryTwo];
    self.complimentaryTwo.hidden = YES;
    [self.complimentaryTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgVTwo.mas_centerY);
        make.centerX.equalTo(self.bgVTwo.mas_centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    if (self.freeKaoQinCount) {
        self.complimentaryOne.hidden = NO;
    }
    
    if (self.freeGaoPaiCount) {
        self.complimentaryTwo.hidden = NO;
    }
    
    self.moneyLb = [[UILabel alloc]init];
    self.moneyLb.textColor = customRedColor;
    [view addSubview:self.moneyLb];
    [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(lineThree.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
    }];
    
    
    NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoney];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
    if (![string contains:@"."]) {
        string = [NSString stringWithFormat:@"%@.00",string];
    }
    self.moneyLb.text = [NSString stringWithFormat:@"¥%@",string];
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:payBtn];
    [payBtn addTarget:self action:@selector(clickToPay) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [payBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:MYORANGE forState:UIControlStateHighlighted];
    payBtn.layer.masksToBounds = YES;
    payBtn.layer.cornerRadius = 5;
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(280*KAdaptiveRateWidth);
    }];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:signBtn];
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateNormal];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateHighlighted];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(payBtn.mas_top).offset(-10);
        make.centerX.equalTo(view.mas_centerX);
        make.height.mas_equalTo(15);
    }];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"支付即代表同意《瀚语智能购买协议》"];
    [attStr addAttributes:@{NSForegroundColorAttributeName:customBlue,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(7, 10)];//添加属性
    [attStr addAttributes:@{NSForegroundColorAttributeName:GRAY180,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 7)];//添加属性
    [signBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    
    
}
#pragma mark == 购买协议的点击方法
- (void)signBtnClick {
    protocolViewController *protocol = [protocolViewController new];
    protocol.type = 3;
    [self.navigationController pushViewController:protocol animated:YES];
}
#pragma mark == 选择机器
- (void)addOrJian:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 100 || tag == 101) {
        if (tag == 101) {
            self.kaoQinCount --;
            if (self.kaoQinCount <= 0) {
                self.kaoQinCount = 0;
            }
        } else {
            self.kaoQinCount ++;
            if (self.kaoQinCount >= 99) {
                self.kaoQinCount = 99;
            }
        }
        self.tf.text = [NSString stringWithFormat:@"%ld",self.kaoQinCount];
    } else {
        if (tag == 103) {
            self.gaoPaiCount --;
            if (self.gaoPaiCount <= 0) {
                self.gaoPaiCount = 0;
            }
        } else {
            self.gaoPaiCount ++;
            if (self.gaoPaiCount >= 99) {
                self.gaoPaiCount = 99;
            }
        }
        self.tf1.text = [NSString stringWithFormat:@"%ld",self.gaoPaiCount];
    }
    
    if (self.isDilatation) {
        self.bgVOne.backgroundColor = [UIColor whiteColor];
        if (self.kaoQinCount) {
            self.bgVOne.backgroundColor = VIEW_BASE_COLOR;
        }
        self.bgVTwo.backgroundColor = [UIColor whiteColor];
        if (self.gaoPaiCount) {
            self.bgVTwo.backgroundColor = VIEW_BASE_COLOR;
        }
        if (self.pageIndex == 3) {
            self.mechineMoney = self.kaoQinCount*self.kaoQinBaseMoney+self.gaoPaiCount*self.gaoPaiBaseMoney;
            self.baseMoneyThree = self.mechineMoney;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle; //NSNumberFormatterDecimalStyle;
            NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoneyThree];
            NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
            if (![string contains:@"."]) {
                string = [NSString stringWithFormat:@"%@.00",string];
            }
            if (![string contains:@"¥"]) {
                string = [NSString stringWithFormat:@"¥%@",string];
            }
            self.moneyLb.text = string;
        }
    } else {
        self.bgVOne.backgroundColor = VIEW_BASE_COLOR;
        if (self.kaoQinCount) {
            self.bgVOne.backgroundColor = GRAY240;
        }
        self.bgVTwo.backgroundColor = VIEW_BASE_COLOR;
        if (self.gaoPaiCount) {
            self.bgVTwo.backgroundColor = GRAY240;
        }
        self.discount = 1.0;
        self.mechineMoney = self.kaoQinCount*self.kaoQinBaseMoney+self.gaoPaiCount*self.gaoPaiBaseMoney;
        self.baseMoney = self.baseMoneyPerPerson * self.baseMonth * (10 + self.index*10) * self.discount + self.mechineMoney;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle; //NSNumberFormatterDecimalStyle;
        NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoney];
        NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
        if (![string contains:@"."]) {
            string = [NSString stringWithFormat:@"%@.00",string];
        }
        if (![string contains:@"¥"]) {
            string = [NSString stringWithFormat:@"¥%@",string];
        }
        self.moneyLb.text = string;
        
        if (self.isFirstBuy) {
            if (self.baseMoney > self.kaoQinDiscount) {
                self.freeKaoQinCount = self.kaoQinBaseFreeCount;
                self.complimentaryOne.hidden = NO;
            } else{
                self.freeKaoQinCount = 0;
                self.freeGaoPaiCount = 0;
                self.complimentaryOne.hidden = YES;
                self.complimentaryTwo.hidden = YES;
            }
            if (self.baseMoney > self.gaoPaiDiscount) {
                self.freeGaoPaiCount = self.gaoPaiBaseFreeCount;
                self.complimentaryTwo.hidden = NO;
            } else {
                self.freeGaoPaiCount = 0;
                self.complimentaryTwo.hidden = YES;
            }
        } else {
            self.freeKaoQinCount = 0;
            self.freeGaoPaiCount = 0;
        }
    }
    
}
#pragma mark == 选择月数
- (void)monthClick:(UIButton *)sender {
    self.monthIndex = sender.tag/100;
    UIButton *btn1 = [self.viewOne viewWithTag:100];
    CGRect rect1 = btn1.frame;
    CGPoint p1 = btn1.center;
    UIButton *btn2 = [self.viewOne viewWithTag:200];
    CGRect rect2 = btn2.frame;
    CGPoint p2 = btn2.center;
    UIButton *btn3 = [self.viewOne viewWithTag:300];
    CGRect rect3 = btn3.frame;
    CGPoint p3 = btn3.center;
    UIButton *btn4 = [self.viewOne viewWithTag:400];
    CGRect rect4 = btn4.frame;
    CGPoint p4 = btn4.center;
    UIButton *btn5 = [self.viewOne viewWithTag:500];
    CGRect rect5 = btn5.frame;
    CGPoint p5 = btn5.center;
    
    switch (sender.tag) {
        case 100:
        {
            
            rect1.size.width = 100*KAdaptiveRateWidth;
            btn1.frame = rect1;
            rect2.size.width = 60*KAdaptiveRateWidth;
            btn2.frame = rect2;
            rect3.size.width = 60*KAdaptiveRateWidth;
            btn3.frame = rect3;
            rect4.size.width = 60*KAdaptiveRateWidth;
            btn4.frame = rect4;
            rect5.size.width = 60*KAdaptiveRateWidth;
            btn5.frame = rect5;
            
            btn1.center = p1;
            btn2.center = p2;
            btn3.center = p3;
            btn4.center = p4;
            btn5.center = p5;
            

            [btn1 setTitle:@"1年" forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn2 setTitle:@"2" forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn3 setTitle:@"3" forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn4 setTitle:@"12" forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn5 setTitle:@"24" forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            self.baseMonth = 12;


        }
            break;
        case 200:
        {
            
            rect1.size.width = 60*KAdaptiveRateWidth;
            btn1.frame = rect1;
            rect2.size.width = 100*KAdaptiveRateWidth;
            btn2.frame = rect2;
            rect3.size.width = 60*KAdaptiveRateWidth;
            btn3.frame = rect3;
            rect4.size.width = 60*KAdaptiveRateWidth;
            btn4.frame = rect4;
            rect5.size.width = 60*KAdaptiveRateWidth;
            btn5.frame = rect5;
            
            btn1.center = p1;
            btn2.center = p2;
            btn3.center = p3;
            btn4.center = p4;
            btn5.center = p5;
            
            
            [btn1 setTitle:@"1" forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn2 setTitle:@"2年" forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn3 setTitle:@"3" forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn4 setTitle:@"4" forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn5 setTitle:@"24" forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

            self.baseMonth = 24;

        }
            break;
        case 300:
        {
            
            rect1.size.width = 60*KAdaptiveRateWidth;
            btn1.frame = rect1;
            rect2.size.width = 60*KAdaptiveRateWidth;
            btn2.frame = rect2;
            rect3.size.width = 100*KAdaptiveRateWidth;
            btn3.frame = rect3;
            rect4.size.width = 60*KAdaptiveRateWidth;
            btn4.frame = rect4;
            rect5.size.width = 35*KAdaptiveRateWidth;
            btn5.frame = rect5;
            
            btn1.center = p1;
            btn2.center = p2;
            btn3.center = p3;
            btn4.center = p4;
            btn5.center = p5;
            

            [btn1 setTitle:@"1" forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn2 setTitle:@"2" forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn3 setTitle:@"3年" forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn4 setTitle:@"4" forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn5 setTitle:@"5" forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

            self.baseMonth = 36;
        }
            break;
        case 400:
        {
            
            rect1.size.width = 35*KAdaptiveRateWidth;
            btn1.frame = rect1;
            rect2.size.width = 35*KAdaptiveRateWidth;
            btn2.frame = rect2;
            rect3.size.width = 35*KAdaptiveRateWidth;
            btn3.frame = rect3;
            rect4.size.width = 70*KAdaptiveRateWidth;
            btn4.frame = rect4;
            rect5.size.width = 35*KAdaptiveRateWidth;
            btn5.frame = rect5;
            
            btn1.center = p1;
            btn2.center = p2;
            btn3.center = p3;
            btn4.center = p4;
            btn5.center = p5;
            

            [btn1 setTitle:@"1" forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn2 setTitle:@"3" forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn3 setTitle:@"6" forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn4 setTitle:@"12个月" forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [btn5 setTitle:@"24" forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

            self.baseMonth = 12;
        }
            break;
        case 500:
        {
            
            
            
            rect1.size.width = 35*KAdaptiveRateWidth;
            btn1.frame = rect1;
            rect2.size.width = 35*KAdaptiveRateWidth;
            btn2.frame = rect2;
            rect3.size.width = 35*KAdaptiveRateWidth;
            btn3.frame = rect3;
            rect4.size.width = 35*KAdaptiveRateWidth;
            btn4.frame = rect4;
            rect5.size.width = 70*KAdaptiveRateWidth;
            btn5.frame = rect5;
            
            
            btn1.center = p1;
            btn2.center = p2;
            btn3.center = p3;
            btn4.center = p4;
            btn5.center = p5;
            

            [btn1 setTitle:@"1" forState:UIControlStateNormal];
            [btn1 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn2 setTitle:@"3" forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn3 setTitle:@"6" forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn4 setTitle:@"12" forState:UIControlStateNormal];
            [btn4 setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateNormal];
            [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            [btn5 setTitle:@"24个月" forState:UIControlStateNormal];
            [btn5 setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
            [btn5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.baseMonth = 24;
            
        }
            break;
            
        default:
            
            break;
    }
    
    for (NSDictionary *dic in self.discountArr) {
        if (self.baseMonth == [dic[@"time"] integerValue]) {
            self.discount = [dic[@"discount"] doubleValue];
            break;
        } else{
            self.discount = 1.0;
        }
    }
    self.discount = 1.0;
    if (self.isDilatation) {
        if (self.pageIndex == 1) {
            self.baseMoney = self.baseMoneyPerPerson * self.baseMonth * (self.peopleIndex*10);
        }
    } else {
        self.baseMoney = self.baseMoneyPerPerson * self.baseMonth * (10 + self.index*10) * self.discount + self.mechineMoney;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle; //NSNumberFormatterDecimalStyle;
    NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoney];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
    if (![string contains:@"."]) {
        string = [NSString stringWithFormat:@"%@.00",string];
    }
    self.moneyLb.text = [NSString stringWithFormat:@"¥%@",string];
    if (self.isFirstBuy) {
        if (self.baseMoney > self.kaoQinDiscount) {
            self.freeKaoQinCount = self.kaoQinBaseFreeCount;
            self.complimentaryOne.hidden = NO;
        } else{
            self.freeKaoQinCount = 0;
            self.freeGaoPaiCount = 0;
            self.complimentaryOne.hidden = YES;
            self.complimentaryTwo.hidden = YES;
        }
        if (self.baseMoney > self.gaoPaiDiscount) {
            self.freeGaoPaiCount = self.gaoPaiBaseFreeCount;
            self.complimentaryTwo.hidden = NO;
        } else {
            self.freeGaoPaiCount = 0;
            self.complimentaryTwo.hidden = YES;
        }
    } else {
        self.freeKaoQinCount = 0;
        self.freeGaoPaiCount = 0;
    }
}
#pragma mark ===== 选择条数
- (void)clickBtnTwo:(UIButton *)sender {
    
    if (sender.tag == 1) {
        self.index--;
        if (self.index <= 1) {
            self.index = 1;
        }
    } else {
        self.index++;
        if (self.index >= 10000) {
            self.index = 10000;
        }
    }
    self.baseMoney = self.baseMoneyPerPerson * self.index * self.discount;
    self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoney];
    self.peopleCountLB.text = [NSString stringWithFormat:@"%ld",self.index];
}


#pragma mark == 选择人数
- (void)clickBtn:(UIButton *)sender {
    
    if (sender.tag == 1) {
        self.index--;
        
        if (self.isDilatation) {
            if (self.peopleIndex >= 1) {
                if (self.index <= self.peopleIndex-1) {
                    self.index = self.peopleIndex-1;
                }
            } else {
                if (self.index <= 0) {
                    self.index = 0;
                }
            }
            
        } else {
            if (self.index == 9) {
                [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            if (self.index <= 0) {
                self.index = 0;
            }
        }
        
        
    } else {
        self.index++;
        if (self.isDilatation) {

            if (self.index >= 10) {
                //此处该有提示，提示联系大客户经理
                self.alertV = [[FDAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.alertV.isTapFailure = 1;
                self.alertV.backgroundColor = customBackColor;
                buyMe_signView *buyMeSign = [[buyMe_signView alloc]initWithFrame:CGRectMake(0, 0, 282, 225)];
                buyMeSign.buyMeTopCancelBlock = ^{
                    [self makeAppointmentWithType:@"2"];
                    [self.alertV hide];
                };
                buyMeSign.buyMeTopSureBlock = ^{
                    [self makeAppointmentWithType:@"1"];
                    [self.alertV hide];
                };
                self.alertV.contentView = buyMeSign;
                [self.alertV show];
                self.index = 9;
            }
        } else {
            
            if (self.index >= 10) {
                self.alertV = [[FDAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                self.alertV.isTapFailure = 1;
                self.alertV.backgroundColor = customBackColor;
                buyMe_signView *buyMeSign = [[buyMe_signView alloc]initWithFrame:CGRectMake(0, 0, 282, 225)];
                buyMeSign.buyMeTopCancelBlock = ^{
                    [self makeAppointmentWithType:@"2"];
                    [self.alertV hide];
                };
                buyMeSign.buyMeTopSureBlock = ^{
                    [self makeAppointmentWithType:@"1"];
                    [self.alertV hide];
                };
                self.alertV.contentView = buyMeSign;
                [self.alertV show];
                self.index = 9;
            }
        }
    }
    
    if (self.index < 10) {
        for (NSDictionary *dic in self.baseArr) {
            NSString *key = [NSString stringWithFormat:@"%@",dic[@"key"]];
            if ([key integerValue] == 10+self.index*10) {
                self.baseMoneyPerPerson = [[NSString stringWithFormat:@"%@",dic[@"value"]] integerValue];
            }
        }
        if (self.isDilatation) {
            if (self.pageIndex == 2) {
                NSInteger sec = [[Utils stringToDate:self.MyUserInfoModel.vipStopTime withDateFormat:@"yyyy-MM-dd"] timeIntervalSinceDate:[Utils stringToDate:[Utils dateToString:[NSDate date] withDateFormat:@"yyyy-MM-dd"] withDateFormat:@"yyyy-MM-dd"]];
                
                self.baseMoneyTwo = self.baseMoneyPerPerson * (sec/(3600.0*24)/30.0) * (self.index-self.peopleIndex+1)*10;
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = kCFNumberFormatterDecimalStyle;
                NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoneyTwo];
                NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
                if (![string contains:@"."]) {
                    string = [NSString stringWithFormat:@"%@.00",string];
                }
                self.moneyLb.text = [NSString stringWithFormat:@"¥%@",string];
            }
            self.peopleCountLB.text = [NSString stringWithFormat:@"%ld",10+self.index*10];
            if ([self.MyUserInfoModel.personSize integerValue] > 100) {
                self.baseMoneyTwo = 0;
                self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoneyTwo];
                self.peopleCountLB.text = self.MyUserInfoModel.personSize;
            }
        } else {
            self.discount = 1.0;
            self.baseMoney = self.baseMoneyPerPerson * self.baseMonth * (10 + self.index*10) * self.discount + self.mechineMoney;
//            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = kCFNumberFormatterDecimalStyle;
//            NSString * awardFloatStr = [NSString stringWithFormat:@"%.2f",self.baseMoney];
//            NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:[awardFloatStr floatValue]]];
//            if (![string contains:@"."]) {
//                string = [NSString stringWithFormat:@"%@.00",string];
//            }
//            self.moneyLb.text = [NSString stringWithFormat:@"¥%@",string];
            self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoney];
            if (self.isFirstBuy) {
                if (self.baseMoney > self.kaoQinDiscount) {
                    self.freeKaoQinCount = 1;
                    self.complimentaryOne.hidden = NO;
                } else{
                    self.freeKaoQinCount = 0;
                    self.freeGaoPaiCount = 0;
                    self.complimentaryOne.hidden = YES;
                    self.complimentaryTwo.hidden = YES;
                }
                if (self.baseMoney > self.gaoPaiDiscount) {
                    self.freeGaoPaiCount = 1;
                    self.complimentaryTwo.hidden = NO;
                } else {
                    self.freeGaoPaiCount = 0;
                    self.complimentaryTwo.hidden = YES;
                }
            } else {
                self.freeKaoQinCount = 0;
                self.freeGaoPaiCount = 0;
            }
            self.peopleCountLB.text = [NSString stringWithFormat:@"%ld",10+self.index*10];
        }
        
    }
    
}

- (void)clickMechine:(UIButton *)sender {
    FDAlertView *alert = [FDAlertView new];
    alert.backgroundView.backgroundColor = customBackColor;
    buyMeMechineView *mechineV;
    if (sender.tag == 1000) {
        mechineV = [[buyMeMechineView alloc]initWithFrame:CGRectMake(0, 0, 260*KAdaptiveRateWidth, 370*KAdaptiveRateWidth) type:1];
    } else {
        mechineV = [[buyMeMechineView alloc]initWithFrame:CGRectMake(0, 0, 260*KAdaptiveRateWidth, 370*KAdaptiveRateWidth) type:2];
    }
    alert.contentView = mechineV;
    [alert show];
}
- (void)createLeftAndRightLabel
{
    _leftLabel = [UILabel new];
    _leftLabel.font = [UIFont systemFontOfSize:16];
    _leftLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.peopleCountLB.mas_left);
        make.bottom.equalTo(self.peopleCountLB.mas_bottom);
        make.height.mas_equalTo(16);
    }];
    
    _rightLabel = [UILabel new];
    _rightLabel.text = @"条";
    _rightLabel.font = [UIFont systemFontOfSize:13];
    _rightLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peopleCountLB.mas_right).offset(0);
        make.bottom.equalTo(self.peopleCountLB.mas_bottom).offset(-5);
        make.height.mas_equalTo(14);
    }];
    
}
#pragma mark - LeftAndRightLabelAnimation
//- (void)leftAndRightLabelAnimationWithStatus:(LRLablesStatus)status string:(NSString *)string
//{
//    CGFloat during = 0.7;
//    CGFloat offX = 10;
//    CGFloat gapX = 10;
//    UIView *labelSuperView = _rightLabel.superview;
//    CGFloat halfSuperViewWidth = labelSuperView.frame.size.width / 2.0;
//    if (status == LRLablesStatusSpread) {
//        [UIView animateWithDuration:during delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            CGRect tempFrame = _leftLabel.frame;
//            tempFrame.origin.x = offX;
//            _leftLabel.frame = tempFrame;
//            
//            CGRect tempFrame1 = _rightLabel.frame;
//            tempFrame1.origin.x = labelSuperView.frame.size.width - offX - CGRectGetWidth(_rightLabel.frame);
//            _rightLabel.frame = tempFrame1;
//            
//        } completion:^(BOOL finished) {
//            nil;
//        }];
//    }else if (status == LRLablesStatusDrawIn) {
//        UILabel *tempLabel = [UILabel new];
//        tempLabel.text = string;
//        tempLabel.font = _numberFadedView.font;
//        [tempLabel sizeToFit];
//        CGFloat halfLabelWidth = tempLabel.frame.size.width / 2.0;
//        [UIView animateWithDuration:during delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            
//            CGRect tempFrame = _leftLabel.frame;
//            tempFrame.origin.x = halfSuperViewWidth - halfLabelWidth - gapX - CGRectGetWidth(_leftLabel.frame);
//            _leftLabel.frame = tempFrame;
//            
//            CGRect tempFrame1 = _rightLabel.frame;
//            tempFrame1.origin.x = halfSuperViewWidth + halfLabelWidth + gapX;
//            _rightLabel.frame = tempFrame1;
//        } completion:^(BOOL finished) {
//            nil;
//        }];
//    }
//}

#pragma mark - CRFadedViewDelegate
- (void)willShowLastOneFadeAnimationWithString:(NSString *)string index:(int)index
{
    if (self.lrLablesStatus != LRLablesStatusDrawIn) {
        self.lrLablesStatus = LRLablesStatusDrawIn;
//        [self leftAndRightLabelAnimationWithStatus:self.lrLablesStatus string:string];
    }
}

- (void)willStartFirstAnimationWithString:(NSString *)string index:(int)index
{
    if (self.lrLablesStatus != LRLablesStatusSpread) {
        self.lrLablesStatus = LRLablesStatusSpread;
//        [self leftAndRightLabelAnimationWithStatus:self.lrLablesStatus string:string];
    }
}

- (void)fadingAnimationWithString:(NSString *)string index:(int)index
{
//    [self changeGradientColorsWithCurrentIndex:index];
}

#pragma mark - Setter & Getter
- (void)setLrLablesStatus:(LRLablesStatus)lrLablesStatus
{
    _lrLablesStatus = lrLablesStatus;
}

- (void)clickToPay {
    if (self.isDilatation) {
        if (![Utils isBlankString:self.MyUserInfoModel.personSize]) {
            if ([self.MyUserInfoModel.personSize integerValue] > 100) {
                if (self.pageIndex == 3) {
                    NSDictionary *dic = [self getParamaters];
                    NSString *money = [NSString stringWithFormat:@"%.2f",self.baseMoney];
                    if (self.baseMoneyThree>0) {
                        money = [NSString stringWithFormat:@"%.2f",self.baseMoneyThree];
                        self.buyMeV = [[buyMeView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 350) paramaters:dic money:money mechineCount:self.kaoQinCount+self.gaoPaiCount];
                        self.buyMeV.bgView.hidden = YES;
                        [self.navigationController.view addSubview:self.buyMeV.bgView];
                        [self.navigationController.view addSubview:self.buyMeV];
                        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
                        self.buyMeV.bgView.hidden = NO;
                        self.buyMeV.delegate = self;
                        
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            self.buyMeV.frame = CGRectMake(0, kScreenHeight-350, kScreenWidth, 350);
                            
                        }];
                    } else {
                        [MBProgressHUD showError:@"请选择设备"];
                        return ;
                    }
                } else {
                    //此处该有提示，提示联系大客户经理
                    self.alertV = [[FDAlertView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    self.alertV.isTapFailure = 1;
                    self.alertV.backgroundColor = customBackColor;
                    buyMe_signView *buyMeSign = [[buyMe_signView alloc]initWithFrame:CGRectMake(0, 0, 262, 225)];
                    buyMeSign.buyMeTopCancelBlock = ^{
                        [self makeAppointmentWithType:@"2"];
                        [self.alertV hide];
                    };
                    buyMeSign.buyMeTopSureBlock = ^{
                        [self makeAppointmentWithType:@"1"];
                        [self.alertV hide];
                    };
                    self.alertV.contentView = buyMeSign;
                    [self.alertV show];
                }
            } else {
                [self readyToPay];
            }
        } else {
            [self readyToPay];
        }
    } else {
        [self readyToPay];
    }
    
}
- (void)readyToPay {
//    self.baseMoney = 0.01;
//    self.baseMoneyTwo = 0.01;
//    self.baseMoneyThree = 0.01;
    NSDictionary *dic = [self getParamater];
    NSString *money = [NSString stringWithFormat:@"%.2f",self.baseMoney];

    //充值
    if (self.isDilatation) {
        switch (self.pageIndex) {
            case 1:
            {
                self.buyMeV = [[buyMeView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 180) paramaters:dic money:money mechineCount:self.kaoQinCount+self.gaoPaiCount];
                
                [self.navigationController.view addSubview:self.buyMeV.bgView];
                [self.navigationController.view addSubview:self.buyMeV];
                self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
                self.buyMeV.bgView.hidden = NO;
                self.buyMeV.delegate = self;
                [UIView animateWithDuration:0.2 animations:^{
                    
                    self.buyMeV.frame = CGRectMake(0, kScreenHeight-180, kScreenWidth, 180);
                    
                }];
            }
                break;
            case 2:
            {
                money = [NSString stringWithFormat:@"%.2f",self.baseMoneyTwo];
                
                if ([money doubleValue] >0 ) {
                    self.buyMeV = [[buyMeView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 180) paramaters:dic money:money mechineCount:self.kaoQinCount+self.gaoPaiCount];
                    
                    [self.navigationController.view addSubview:self.buyMeV.bgView];
                    [self.navigationController.view addSubview:self.buyMeV];
                    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
                    self.buyMeV.bgView.hidden = NO;
                    self.buyMeV.delegate = self;
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        
                        self.buyMeV.frame = CGRectMake(0, kScreenHeight-180, kScreenWidth, 180);
                        
                    }];
                } else {
                    [MBProgressHUD showError:@"请选择扩容人数"];
                    return ;
                }
            }
                break;
            case 3:
            {
                if (self.baseMoneyThree>0) {
                    money = [NSString stringWithFormat:@"%.2f",self.baseMoneyThree];
                    self.buyMeV = [[buyMeView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 350) paramaters:dic money:money mechineCount:self.kaoQinCount+self.gaoPaiCount];
                    
                    [self.navigationController.view addSubview:self.buyMeV.bgView];
                    [self.navigationController.view addSubview:self.buyMeV];
                    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
                    self.buyMeV.bgView.hidden = NO;
                    self.buyMeV.delegate = self;
                    
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.buyMeV.frame = CGRectMake(0, kScreenHeight-350, kScreenWidth, 350);
                        
                    }];
                } else {
                    [MBProgressHUD showError:@"请选择设备"];
                    return ;
                }
            }
                break;
            default:
                break;
        }
    } else {
        if (self.kaoQinCount+self.gaoPaiCount+self.freeGaoPaiCount+self.freeKaoQinCount) {
            self.buyMeV = [[buyMeView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 350) paramaters:dic money:money mechineCount:self.kaoQinCount+self.gaoPaiCount+self.freeGaoPaiCount+self.freeKaoQinCount];
            
            [self.navigationController.view addSubview:self.buyMeV.bgView];
            [self.navigationController.view addSubview:self.buyMeV];
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
            self.buyMeV.bgView.hidden = NO;
            self.buyMeV.delegate = self;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                self.buyMeV.frame = CGRectMake(0, kScreenHeight-350, kScreenWidth, 350);
                
            }];
        } else {
            self.buyMeV = [[buyMeView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 180) paramaters:dic money:money mechineCount:self.kaoQinCount+self.gaoPaiCount];
            
            [self.navigationController.view addSubview:self.buyMeV.bgView];
            [self.navigationController.view addSubview:self.buyMeV];
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
            self.buyMeV.bgView.hidden = NO;
            self.buyMeV.delegate = self;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.buyMeV.frame = CGRectMake(0, kScreenHeight-180, kScreenWidth, 180);
                
            }];
        }
    }
}

- (NSDictionary *)getParamater {
    NSDictionary *dic;
    NSString *peopleCount = [NSString stringWithFormat:@"%ld",self.index];
    NSString *month = @"12";
    NSMutableArray *mechArr = [NSMutableArray arrayWithCapacity:0];
    dic = @{@"userId":self.myUser_Id,@"mech_id":self.myMech_Id,@"flag":@"1",@"money":@(self.baseMoney),@"personSize":peopleCount,@"vipTime":month,@"appOrderdealMachines":mechArr};
    return dic;
}

- (NSDictionary *)getParamaters {
    NSString *peopleCount = [NSString stringWithFormat:@"%ld",10+self.index*10];
    NSString *month = @"";
    switch (self.monthIndex) {
        case 1:
            month = @"1";
            break;
        case 2:
            month = @"3";
            break;
        case 3:
            month = @"6";
            break;
        case 4:
            month = @"12";
            break;
        case 5:
            month = @"24";
            break;
            
        default:
            break;
    }
    
    NSMutableArray *mechArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<_kaoQinCount; i++) {
        NSDictionary *dic = @{@"name":@"考勤机",@"type":@"2",@"preferential":@"0",@"money":@(self.kaoQinBaseMoney)};
        [mechArr addObject:dic];
    }
    
    for (int i = 0; i < self.freeKaoQinCount; i++) {
        NSDictionary *dic = @{@"name":@"考勤机",@"type":@"2",@"preferential":@"1",@"money":@"0"};
        [mechArr addObject:dic];
    }
    
    for (int i = 0; i<_gaoPaiCount; i++) {
        NSDictionary *dic = @{@"name":@"高拍",@"type":@"1",@"preferential":@"0",@"money":@(self.gaoPaiBaseMoney)};
        [mechArr addObject:dic];
    }
    
    for (int i = 0; i<self.freeGaoPaiCount; i++) {
        NSDictionary *dic = @{@"name":@"高拍",@"type":@"1",@"preferential":@"1",@"money":@"0"};
        [mechArr addObject:dic];
    }
    
    NSDictionary *dic;//,@"start_time":@"2017-08-07",@"end_time":@"2018-08-07"
    if (self.isDilatation) {
        switch (self.pageIndex) {
            case 1:
            {
                dic = @{@"userId":self.myUser_Id,@"mech_id":self.myMech_Id,@"flag":@(self.pageIndex+1),@"money":@(self.baseMoney),@"personSize":@"0",@"vipTime":month,@"appOrderdealMachines":@[]};
            }
                break;
            case 2:
            {
                dic = @{@"userId":self.myUser_Id,@"mech_id":self.myMech_Id,@"flag":@(self.pageIndex+1),@"money":@(self.baseMoneyTwo),@"personSize":peopleCount,@"vipTime":@"0",@"appOrderdealMachines":@[]};
            }
                break;
            case 3:
            {
                dic = @{@"userId":self.myUser_Id,@"mech_id":self.myMech_Id,@"flag":@(self.pageIndex+1),@"money":@(self.baseMoneyThree),@"personSize":@"0",@"vipTime":@"0",@"appOrderdealMachines":mechArr};
            }
                break;
                
            default:
                break;
        }
    } else {
        dic = @{@"userId":self.myUser_Id,@"mech_id":self.myMech_Id,@"flag":@"1",@"money":@(self.baseMoney),@"personSize":peopleCount,@"vipTime":month,@"appOrderdealMachines":mechArr};
    }
    return dic;
}
#pragma mark == buyMeDelegate
- (void)clickToPayAndReturnTheResualt:(id)resualt {
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    [HttpRequestEngine againLoginWithName:name pwd:pwd completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            self.MyUserInfoModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
            self.currentPeopleLB.text = [NSString stringWithFormat:@"%@／%@",self.MyUserInfoModel.mechSize,self.MyUserInfoModel.personSize];
            self.stopTimeLabel.text = [NSString stringWithFormat:@"%@",self.MyUserInfoModel.vipStopTime];
        }
    }];
}

#pragma mark == 扩容的三个按钮点击
- (void)tabBtnClick:(UIButton*)sender {
    self.pageIndex = sender.tag;
    UIButton *btnOne = [self.bgImage viewWithTag:1];
    UIButton *btnTwo = [self.bgImage viewWithTag:2];
    UIButton *btnThree = [self.bgImage viewWithTag:3];
    switch (sender.tag) {
        case 1:
        {
            [btnOne setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            [btnOne setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateNormal];
            [btnOne setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateHighlighted];
            
            [btnTwo setTitleColor:GRAY160 forState:UIControlStateNormal];
            [btnTwo setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
            [btnTwo setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
            
            [btnThree setTitleColor:GRAY160 forState:UIControlStateNormal];
            [btnThree setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
            [btnThree setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
            self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoney];
        }
            break;
        case 2:
        {
            [btnOne setTitleColor:GRAY160 forState:UIControlStateNormal];
            [btnOne setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
            [btnOne setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
            
            [btnTwo setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            [btnTwo setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateNormal];
            [btnTwo setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateHighlighted];
            
            [btnThree setTitleColor:GRAY160 forState:UIControlStateNormal];
            [btnThree setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
            [btnThree setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
            self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoneyTwo];
        }
            break;
        default:
        {
            [btnOne setTitleColor:GRAY160 forState:UIControlStateNormal];
            [btnOne setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
            [btnOne setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
            
            [btnTwo setTitleColor:GRAY160 forState:UIControlStateNormal];
            [btnTwo setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateNormal];
            [btnTwo setBackgroundImage:[UIImage imageNamed:@"TabControl"] forState:UIControlStateHighlighted];
            
            [btnThree setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
            [btnThree setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateNormal];
            [btnThree setBackgroundImage:[UIImage imageNamed:@"TabControlPressed"] forState:UIControlStateHighlighted];
            self.moneyLb.text = [Utils stringToMoneyWithValue:self.baseMoneyThree];
        }
            break;
    }
    
    [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth*sender.tag-kScreenWidth, 0) animated:YES];
    
}
- (void)makeAppointmentWithType:(NSString *)type {
    [HttpRequestEngine sendAppointMobileWithUserId:self.myUser_Id mech_id:self.myMech_Id name:self.MyUserInfoModel.realName mobile:self.myMobile type:type completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            if ([type isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"预约成功"];
            }
        } else {
            [MBProgressHUD showError:errorStr];
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
