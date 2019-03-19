//
//  WorkViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "WorkViewController.h"
#import "WorkBtn.h"
#import "ProductManageViewController.h"
#import "LoginPeopleModel.h"
#import "CRMViewController.h"
#import "OrderViewController.h"
#import "NoticeListViewController.h"
#import "UpgradeViewController.h"
#import "ExecutiveForceViewController.h"
#import "ApplyProductViewController.h"
#import "RetailSaleViewController.h"
#import "ExcelViewController.h"
#import <RongIMKit/RongIMKit.h>

#import "AYCheckManager.h"
#import "EMViewController.h"
#import "FinanceMgrViewController.h"
#import "approvalMainViewController.h"
#import "attendanceViewController.h"
#import "CRMListModel.h"
#import "MyOrderModel.h"
#import "workCRMView.h"
#import "workOrderView.h"

#import "OnApplyOrderViewController.h"
#import "LookOrderInfoViewController.h"
#import "CRMDetailsViewController.h"
#import "LocationManager.h"

#import "citiesViewController.h"
#import "cityModel.h"
#import "RCDCustomerServiceViewController.h"
#import "customConversationViewController.h"
#import "customCellModel.h"
#import "newCreateAndJoinViewController.h"
@interface WorkViewController ()<UIScrollViewDelegate,RCIMReceiveMessageDelegate>//<RCIMReceiveMessageDelegate>

{
    UIImageView *_bannerImageView;
    UILabel *_YearAndMonthLB;
    UILabel *_weekLB;
    UILabel *_dayLB;
    
    
    WorkBtn *_workBtn;
    LoginPeopleModel *loginModel;
    UIView *_lineView;
}

@property (nonatomic, strong) UIScrollView *baseScrollView;

@property (nonatomic, strong) NSMutableArray *CRMArr;

@property (nonatomic, strong) NSMutableArray *OrderArr;

@property (nonatomic, strong) UIView *workBtnView;

@property (nonatomic, strong) UIView *CRMView;
@property (nonatomic, strong) UILabel *emptyCRMLb;

@property (nonatomic, strong) UIView *orderView;
@property (nonatomic, strong) UILabel *emptyOrderLb;

@property (nonatomic, strong) UILabel *refresh;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSString *locationStr;
@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) UIButton *locationBtn;
@end

@implementation WorkViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}
-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
//    pwd = @"user1";
//    pwd = [NSString MD5ForLower32Bate:pwd];
//    NSLog(@"pwd == %@",pwd);
    UIView *vi = [UIView new];
    vi.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = vi;
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //打印全部字体
//    NSArray *familyNames = [UIFont familyNames];
//    for( NSString *familyName in familyNames )
//    {
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//        for( NSString *fontName in fontNames )
//        {
//            DLog(@"\tFont: %s \n", [fontName UTF8String] );
//        }
//    }
    
    self.view.backgroundColor = kMyColor(240, 239, 245);
//    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
//    _lineView.hidden = YES;
    
    self.CRMArr = [NSMutableArray arrayWithCapacity:0];
    self.OrderArr = [NSMutableArray arrayWithCapacity:0];
    
    
    
    _bannerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner"]];
    [self.view addSubview:_bannerImageView];
    [_bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(128*KAdaptiveRateWidth);
    }];
    _bannerImageView.userInteractionEnabled = YES;
    
    [self getLocation];

    //用来获取本地年月日星期
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    long int week = [comps weekday];
    long int year=[comps year];
    long int month = [comps month];
    long int day = [comps day];
    //年和月的label
    _YearAndMonthLB = [[UILabel alloc]init];
    [_bannerImageView addSubview:_YearAndMonthLB];
    _YearAndMonthLB.textAlignment = NSTextAlignmentCenter;
    _YearAndMonthLB.font = [UIFont systemFontOfSize:12*KAdaptiveRateWidth];
    _YearAndMonthLB.textColor = kMyColor(83, 158, 239);
    [_YearAndMonthLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(_bannerImageView.mas_bottom).offset(-14*KAdaptiveRateHeight);
        make.height.mas_equalTo(11*KAdaptiveRateWidth);
    }];
    //日的label
    _dayLB = [[UILabel alloc]init];
    [_bannerImageView addSubview:_dayLB];
    _dayLB.font = [UIFont systemFontOfSize:39*KAdaptiveRateWidth];
    _dayLB.textAlignment = NSTextAlignmentCenter;
    _dayLB.textColor = kMyColor(83, 158, 239);
    [_dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_YearAndMonthLB.mas_left).offset(-3*KAdaptiveRateWidth);
        make.bottom.equalTo(_bannerImageView.mas_bottom).offset(-10*KAdaptiveRateHeight);
        make.height.mas_equalTo(39*KAdaptiveRateWidth);
    }];
    //星期的label
    _weekLB = [[UILabel alloc]init];
    [_bannerImageView addSubview:_weekLB];
    _weekLB.font = [UIFont systemFontOfSize:14*KAdaptiveRateWidth];
    _weekLB.textAlignment = NSTextAlignmentCenter;
    _weekLB.textColor = kMyColor(83, 158, 239);
    [_weekLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10*KAdaptiveRateWidth);
        make.left.equalTo(_dayLB.mas_right).offset(3*KAdaptiveRateWidth);
        make.bottom.equalTo(_YearAndMonthLB.mas_top).offset(-5*KAdaptiveRateHeight);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
    _YearAndMonthLB.text=[NSString stringWithFormat:@"%ld年%ld月",year,month];
    _dayLB.text=[NSString stringWithFormat:@"%ld",day];
    _weekLB.text=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]];
    
    
    
    self.baseScrollView = [[UIScrollView alloc]init];
    self.baseScrollView.contentSize = CGSizeMake(0, 1400);
    self.baseScrollView.delegate = self;
    [self.view addSubview:self.baseScrollView];
    self.baseScrollView.backgroundColor = [UIColor whiteColor];
    [self.baseScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bannerImageView.mas_bottom).offset(0*KAdaptiveRateWidth);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    
    
    [self setupView];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentExcelVC:) name:@"iswork" object:nil];
    AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
    checkManger.countryAbbreviation = @"cn";
    [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"" confimTitle:@"前往更新" skipVersionTitle:@""];

}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    if (message.conversationType == ConversationType_SYSTEM) {
        customCellModel *messag = (customCellModel *)message.content;
        if (messag.flag == 15) {
            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
            NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
            [HttpRequestEngine againLoginWithName:name pwd:pwd completion:^(id obj, NSString *errorStr) {
                
            }];
        }
        if (messag.flag == 17) {
            
            newCreateAndJoinViewController *caj = [newCreateAndJoinViewController new];
            caj.seType = 1;
            caj.num = 1;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:caj];
            [self.tabBarController presentViewController:navi animated:NO completion:nil];
            [[RCIMClient sharedRCIMClient] clearConversations:@[@(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_CHATROOM),
                                                                @(ConversationType_GROUP),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_SYSTEM),
                                                                @(ConversationType_CUSTOMERSERVICE)]];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UITabBarItem *item = self.tabBarController.tabBar.items[0];
        //        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (count != 0)
        {
            if (count > 99) {
                item.badgeValue = @"99+";
            } else {
                item.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
            }
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = count;
        }
        else
        {
            item.badgeValue = nil;
        }
        
    });
}

- (void)getLocation {
    
    self.locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locationBtn.backgroundColor = customBackColor;
    [_bannerImageView addSubview:self.locationBtn];
    self.locationBtn.layer.masksToBounds = YES;
    self.locationBtn.layer.cornerRadius = 12.5;
    [self.locationBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(cityClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cityName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"]];
    BOOL isCityName = [Utils isBlankString:self.cityName];
    if (isCityName) {
        self.cityName = @"全国";
    }
    [self.locationBtn setTitle:self.cityName forState:UIControlStateNormal];
    self.locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bannerImageView.mas_left).offset(15);
        make.top.equalTo(_bannerImageView.mas_top).offset(35);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo([self.cityName widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:20]+25+20);
    }];
    [self.view layoutIfNeeded];
    
    self.cityId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"]];
    
    if ([Utils isBlankString:self.cityId]) {
        self.cityId = @"";
        [[NSUserDefaults standardUserDefaults] setObject:self.cityId forKey:@"cityId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"locationProId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"proId"];
    }
    
    LocationManager * locationManager = [LocationManager sharedLocationManager];
    [locationManager startUpdateLocation];
    locationManager.nameBlock = ^(NSString * str){
        if ([Utils isBlankString:str]) {
            self.locationStr = @"定位失败，请授权定位！";
            self.locationID = @"";
            [MBProgressHUD showError:@"定位失败，请授权定位！"];
        }else if ([str isEqualToString:@"全国"]) {
            self.locationStr = @"定位失败，请授权定位！";
            self.locationID = @"";
            [MBProgressHUD showError:@"定位失败，请授权定位！"];
        }else {
            self.locationStr = str;
            self.cityName = str;
            [self.locationBtn setTitle:self.cityName forState:UIControlStateNormal];
            CGRect rect = self.locationBtn.frame;
            rect.size.width = [self.cityName widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:15]+25+20;
            self.locationBtn.frame = rect;
            NSArray *cityArr = [LocationData getCityArray];
            for (cityModel *model in cityArr) {
                NSString *name = model.name;
                if ([name isEqualToString:self.cityName]) {
                    self.cityId = model.cityId;
                    self.locationID = self.cityId;
                    NSString *proID = model.reid;
                    [[NSUserDefaults standardUserDefaults] setObject:self.cityId forKey:@"cityId"];
                    [[NSUserDefaults standardUserDefaults] setObject:proID forKey:@"locationProId"];
                    [[NSUserDefaults standardUserDefaults] setObject:proID forKey:@"proId"];
                    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"cityName"];
                }
            }
        }
//        AYCheckManager *checkManger = [AYCheckManager sharedCheckManager];
//        checkManger.countryAbbreviation = @"cn";
//        [checkManger checkVersionWithAlertTitle:@"发现新版本" nextTimeTitle:@"" confimTitle:@"前往更新" skipVersionTitle:@""];
        
    };
    locationManager.latitudeBlock = ^(float latitude,float longitude){
        
        if (latitude==0&&longitude==0) {
            self.locationStr = @"定位失败，请授权定位！";
            self.locationID = @"";
            [MBProgressHUD showError:@"定位失败，请授权定位！"];
        } else {
            CLLocation * location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
            //2.反地理编码
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error || placemarks.count==0) {
                    self.locationStr = @"定位失败，请授权定位！";
                    self.locationID = @"";
                    [MBProgressHUD showError:@"定位失败，请授权定位！"];
                } else {
                    //显示最前面的地标信息
                    CLPlacemark *firstPlacemark=[placemarks firstObject];
                    NSString *cityName = [NSString stringWithFormat:@"%@",firstPlacemark.locality];
                    
                    self.locationStr = cityName;
                    self.cityName = cityName;
                    [self.locationBtn setTitle:self.cityName forState:UIControlStateNormal];
                    CGRect rect = self.locationBtn.frame;
                    rect.size.width = [self.cityName widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:15]+25+20;
                    self.locationBtn.frame = rect;
                    NSArray *cityArr = [LocationData getCityArray];
                    for (cityModel *model in cityArr) {
                        NSString *name = model.name;
                        if ([name isEqualToString:self.cityName]) {
                            self.cityId = model.cityId;
                            self.locationID = self.cityId;
                            NSString *proID = model.reid;
                            [[NSUserDefaults standardUserDefaults] setObject:self.cityId forKey:@"cityId"];
                            [[NSUserDefaults standardUserDefaults] setObject:proID forKey:@"locationProId"];
                            [[NSUserDefaults standardUserDefaults] setObject:proID forKey:@"proId"];
                            [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"cityName"];
                        }
                    }
                }
                
            }];
        }
    };
    
}
- (void)cityClick:(UIButton *)sender{
    
    citiesViewController *citiesVC = [[citiesViewController alloc]init];
    citiesVC.locationName = self.locationStr;
    citiesVC.locationID = self.locationID;
//    citiesVC.proId = [[NSUserDefaults standardUserDefaults] objectForKey:@"proId"];
    citiesVC.type = 2;
    
    [citiesVC returnSelectCityBlock:^(NSString *selectedCityName,NSString *selectedCityID,NSString *selectedProID) {
        
        self.cityName = selectedCityName;
        [self.locationBtn setTitle:self.cityName forState:UIControlStateNormal];
        CGRect rect = self.locationBtn.frame;
        rect.size.width = [self.cityName widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:15]+25+20;
        self.locationBtn.frame = rect;
        if ([selectedCityName isEqualToString:@"全国"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"cityId"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"proId"];
        } else {
            self.cityId = selectedCityID;
            NSString *proID = selectedProID;
            [[NSUserDefaults standardUserDefaults] setObject:self.cityId forKey:@"cityId"];
            [[NSUserDefaults standardUserDefaults] setObject:proID forKey:@"proId"];
        }
    }];
    citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:citiesVC animated:YES completion:nil];
    

}

- (void)presentExcelVC:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    UIView *aa = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    aa.backgroundColor = [UIColor blackColor];
    aa.center = self.view.center;
    [self.view addSubview:aa];
    NSLog(@"dic == %@",dic);
    if (dic) {
        NSString *path = [dic objectForKey:@"path"];
        NSURL *url = [NSURL URLWithString:path];
        NSMutableString *string = [[NSMutableString alloc] initWithString:path];
        if ([path hasPrefix:@"file://"]) {
            [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch  range:NSMakeRange(0, path.length)];
        }
        NSString *fileNameStr = [url lastPathComponent];
        NSString *Doc = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Inbox"] stringByAppendingPathComponent:fileNameStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [data writeToFile:Doc atomically:YES];
        ExcelViewController *excelVC = [[ExcelViewController alloc]init];
        //  self.window.rootViewController = self.excelVC;
        
        [self.navigationController presentViewController:excelVC animated:YES completion:nil];
        
        [excelVC openExcel:string];
        
        [excelVC saveExcel:Doc];
    }
}


- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}
//设置工作界面视图
- (void)setupView {
#pragma mark == 之前美工设计的风格
//    self.CRMView = [[UIView alloc] init];
//    [self.baseScrollView addSubview:self.CRMView];
//    self.CRMView.backgroundColor = GRAY240;
//    [self.CRMView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseScrollView.mas_top).offset(0*KAdaptiveRateWidth);
//        make.left.equalTo(self.baseScrollView.mas_left);
//        make.width.mas_equalTo(kScreenWidth);
//        make.height.mas_equalTo(30*KAdaptiveRateWidth);
//    }];
//    
//    self.CRMView.layer.borderColor = VIEW_BASE_COLOR.CGColor;
//    self.CRMView.layer.borderWidth = 0.3;
//    self.CRMView.layer.shadowOpacity = 0.5f;// 阴影透明度
//    self.CRMView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
//    self.CRMView.layer.shadowRadius = 2;// 阴影扩散的范围控制
//    self.CRMView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
//    
//    UIView *CRMBgView = [[UIView alloc]init];
//    [self.CRMView addSubview:CRMBgView];
//    CRMBgView.backgroundColor = [UIColor whiteColor];
//    CRMBgView.layer.cornerRadius = 15*KAdaptiveRateWidth;
//    [CRMBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.CRMView.mas_left).offset(-30);
//        make.top.equalTo(self.CRMView.mas_top);
//        make.bottom.equalTo(self.CRMView.mas_bottom);
//        make.width.mas_equalTo(100);
//    }];
//    
//    UIButton *CRMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.CRMView addSubview:CRMBtn];
//    CRMBtn.tag = 4;
//    [CRMBtn addTarget:self action:@selector(clickWork:) forControlEvents:UIControlEventTouchUpInside];
//    [CRMBtn setTitle:@"CRM" forState:UIControlStateNormal];
//    CRMBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [CRMBtn setTitleColor:UIColorFromRGB(0xff4e7ac4, 1) forState:UIControlStateNormal];
//    [CRMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.CRMView.mas_left).offset(14);
//        make.centerY.equalTo(self.CRMView.mas_centerY);
//        make.height.mas_equalTo(20);
//    }];
//    
//    UIButton *CRMSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.CRMView addSubview:CRMSearchBtn];
//    [CRMSearchBtn setBackgroundImage:[UIImage imageNamed:@"workSearch"] forState:UIControlStateNormal];
//    [CRMSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.CRMView.mas_right).offset(-10*KAdaptiveRateWidth);
//        make.centerY.equalTo(self.CRMView.mas_centerY);
//        make.width.mas_equalTo(20*KAdaptiveRateWidth);
//        make.height.mas_equalTo(20*KAdaptiveRateWidth);
//    }];
//    
//    self.emptyCRMLb = [[UILabel alloc]init];
//    [self.baseScrollView addSubview:self.emptyCRMLb];
//    self.emptyCRMLb.textColor = GRAY150;
//    self.emptyCRMLb.text = @"您还没有CRM";
//    self.emptyCRMLb.font = [UIFont systemFontOfSize:14];
//    self.emptyCRMLb.textAlignment = NSTextAlignmentCenter;
//    [self.emptyCRMLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.baseScrollView).offset(0);
//        make.top.equalTo(self.CRMView.mas_bottom).offset(5*KAdaptiveRateWidth);
//        make.width.mas_equalTo(kScreenWidth);
//        make.height.mas_equalTo(30*KAdaptiveRateWidth);
//    }];
//    
//    
//    
//    self.orderView = [[UIView alloc] init];
//    [self.baseScrollView addSubview:self.orderView];
//    self.orderView.backgroundColor = GRAY240;
//    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.baseScrollView.mas_top).offset(70*KAdaptiveRateWidth);
//        make.left.equalTo(self.baseScrollView.mas_left);
//        make.width.mas_equalTo(kScreenWidth);
//        make.height.mas_equalTo(30*KAdaptiveRateWidth);
//    }];
//    
//    self.orderView.layer.borderColor = VIEW_BASE_COLOR.CGColor;
//    self.orderView.layer.borderWidth = 0.3;
//    self.orderView.layer.shadowOpacity = 0.5f;// 阴影透明度
//    self.orderView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
//    self.orderView.layer.shadowRadius = 2;// 阴影扩散的范围控制
//    self.orderView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
//    
//    UIView *OrderBgView = [[UIView alloc]init];
//    [self.orderView addSubview:OrderBgView];
//    OrderBgView.backgroundColor = [UIColor whiteColor];
//    OrderBgView.layer.cornerRadius = 15*KAdaptiveRateWidth;
//    [OrderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.orderView.mas_left).offset(-30);
//        make.top.equalTo(self.orderView.mas_top);
//        make.bottom.equalTo(self.orderView.mas_bottom);
//        make.width.mas_equalTo(130);
//    }];
//    
//    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.orderView addSubview:orderBtn];
//    orderBtn.tag = 5;
//    [orderBtn addTarget:self action:@selector(clickWork:) forControlEvents:UIControlEventTouchUpInside];
//    [orderBtn setTitle:@"我的订单" forState:UIControlStateNormal];
//    orderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [orderBtn setTitleColor:UIColorFromRGB(0xff4e7ac4, 1) forState:UIControlStateNormal];
//    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.orderView.mas_left).offset(14);
//        make.centerY.equalTo(self.orderView.mas_centerY);
//        make.height.mas_equalTo(20);
//    }];
//    
//    UIButton *orderSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.orderView addSubview:orderSearchBtn];
//    [orderSearchBtn setBackgroundImage:[UIImage imageNamed:@"workSearch"] forState:UIControlStateNormal];
//    [orderSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.orderView.mas_right).offset(-10*KAdaptiveRateWidth);
//        make.centerY.equalTo(self.orderView.mas_centerY);
//        make.width.mas_equalTo(20*KAdaptiveRateWidth);
//        make.height.mas_equalTo(20*KAdaptiveRateWidth);
//    }];
//    
//    self.emptyOrderLb = [[UILabel alloc]init];
//    [self.baseScrollView addSubview:self.emptyOrderLb];
//    self.emptyOrderLb.textColor = GRAY150;
//    self.emptyOrderLb.text = @"您还没有订单";
//    self.emptyOrderLb.font = [UIFont systemFontOfSize:14];
//    self.emptyOrderLb.textAlignment = NSTextAlignmentCenter;
//    [self.emptyOrderLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.baseScrollView).offset(0);
//        make.top.equalTo(self.orderView.mas_bottom).offset(5*KAdaptiveRateWidth);
//        make.width.mas_equalTo(kScreenWidth);
//        make.height.mas_equalTo(30*KAdaptiveRateWidth);
//    }];
    
    
    

//    NSArray *imageArr = [NSArray arrayWithObjects:@"work_product",@"work_task",@"工具",@"work_permission",@"work_crm",@"work_order",@"notice_icon",@"level_up",@"执行力", nil];
//    NSArray *titleArr = [NSArray arrayWithObjects:@"产品",@"任务",@"工具",@"权限",@"CRM",@"订单",@"公告",@"等级提升",@"执行力", nil];
    
    
//    NSArray *imageArr = [NSArray arrayWithObjects:@"work_product",@"work_task",@"工具",@"work_permission",@"work_crm",@"work_order",@"notice_icon",@"level_up",@"执行力",@"执行力",@"执行力",@"执行力",@"执行力", nil];
//    NSArray *titleArr = [NSArray arrayWithObjects:@"产品",@"任务",@"工具",@"权限",@"CRM",@"订单",@"公告",@"等级提升",@"执行力",@"员工管理",@"财务管理",@"审批管理",@"考勤管理", nil];

    NSArray *imageArr = [NSArray arrayWithObjects:@"work_product",@"work_task",@"工具",@"work_right",@"work_CRM",@"work_order",@"公告",@"执行力",@"员工管理",@"财务管理",@"审批管理",@"考勤管理", nil];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"产品",@"任务",@"工具",@"权限",@"CRM",@"订单",@"公告",@"执行力",@"员工管理",@"财务管理",@"审批",@"考勤", nil];
    
    NSInteger lineCount = titleArr.count%3==0 ? titleArr.count/3:(titleArr.count/3)+1;
    
    self.workBtnView = [[UIView alloc] init];
    [self.baseScrollView addSubview:self.workBtnView];
    self.workBtnView.backgroundColor = VIEW_BASE_COLOR;
    [self.workBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(0*KAdaptiveRateWidth);
        make.left.equalTo(self.baseScrollView.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo((kScreenWidth/3.0+5*KAdaptiveRateWidth) * lineCount+1);
    }];
    
    //循环创建出按钮
    for (int i = 0; i<imageArr.count; i++) {
        _workBtn = [[WorkBtn alloc]init];
        _workBtn.enabled = YES;
        
        [self.workBtnView addSubview:_workBtn];
        _workBtn.tag = i;
        [_workBtn addTarget:self action:@selector(clickWork:) forControlEvents:UIControlEventTouchUpInside];
        if (i<=11) {
            _workBtn.Image.image = [UIImage imageNamed:imageArr[i]];
        } else {
            _workBtn.enabled = NO;
        }
        _workBtn.Label.text = titleArr[i];
        [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.workBtnView.mas_top).offset((i/3)*(kScreenWidth/3.0+5*KAdaptiveRateWidth));
            make.left.equalTo(self.workBtnView.mas_left).offset((i%3)*kScreenWidth/3.0);
            make.width.mas_equalTo(kScreenWidth/3.0);
            make.height.mas_equalTo(kScreenWidth/3.0+5*KAdaptiveRateWidth);
        }];
        //竖着的分割线
        if (i % 3 == 1 || i%3 == 2 || i%3 == 3) {
            UIView *HSeparetor = [[UIView alloc]init];
            [_workBtn addSubview:HSeparetor];
            HSeparetor.backgroundColor = kMyColor(240, 239, 245);
            [HSeparetor mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.workBtnView.mas_top).offset((i/3)*(kScreenWidth/3.0+5*KAdaptiveRateWidth));
                make.left.equalTo(self.workBtnView.mas_left).offset((i%3)*kScreenWidth/3.0-0.5);
                make.width.mas_equalTo(1);
                make.height.mas_equalTo(kScreenWidth/3.0+5*KAdaptiveRateWidth);
            }];
        }
        //横着的分割线
        if (i/3 == 0 || i/3 == 1 || i/3 == 2 || i/3 == 3 || i/3 == 4 ) {
            UIView *VSeparetor = [[UIView alloc]init];
            [_workBtn addSubview:VSeparetor];
            VSeparetor.backgroundColor = kMyColor(240, 239, 245);
            [VSeparetor mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.workBtnView.mas_top).offset((i/3)*(kScreenWidth/3.0+5*KAdaptiveRateWidth) - 0.5 );
                make.left.equalTo(self.workBtnView.mas_left).offset((i%3)*kScreenWidth/3.0);
                make.width.mas_equalTo(kScreenWidth/3.0);
                make.height.mas_equalTo(1);
            }];
        }
    }
    
    UILabel *signLB = [[UILabel alloc]init];
    [self.baseScrollView addSubview:signLB];
    signLB.textColor = GRAY90;
    signLB.text = @"-  瀚语 让办公更容易  -";
    signLB.textAlignment = NSTextAlignmentCenter;
    signLB.font = [UIFont systemFontOfSize:14];
    [signLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workBtnView.mas_bottom).offset(25);
        make.height.mas_equalTo(25);
        make.centerX.equalTo(self.workBtnView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [self.view layoutIfNeeded];
    CGRect rect1 = self.workBtnView.frame;
    self.baseScrollView.contentSize = CGSizeMake(0, rect1.origin.y+rect1.size.height+75);
    
//    self.baseScrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        for (UIView *view in [self.baseScrollView subviews] ) {
//            if ([view isKindOfClass:[workCRMView class]] || [view isKindOfClass:[workOrderView class]]) {
//                [view removeFromSuperview];
//            }
//        }
//        [self setCRMData];
//    }];
//    
//    [self setCRMData];
    
    
}


- (void)setCRMData{
    
    NSString *uid = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.userId];
    [HttpRequestEngine getCRMListWithUid:uid page:@"0" completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            [self.CRMArr removeAllObjects];
            NSArray *dataArr = (NSArray *)obj;
            if (dataArr.count > 3) {
                [self.CRMArr addObject:dataArr[0]];
                [self.CRMArr addObject:dataArr[1]];
                [self.CRMArr addObject:dataArr[2]];
            } else {
                [self.CRMArr addObjectsFromArray:dataArr];
            }
            
            if (self.CRMArr.count > 0) {
                self.emptyCRMLb.hidden = YES;
                
                for (int i=0; i<self.CRMArr.count; i++) {
                    CRMListModel *model = self.CRMArr[i];
                    workCRMView *crm = [[workCRMView alloc]initWithFrame:CGRectMake(0, 40*KAdaptiveRateWidth*(i)+35*KAdaptiveRateWidth, kScreenWidth, 40*KAdaptiveRateWidth)];
                    [self.baseScrollView addSubview:crm];
                    crm.nameLB.text = model.user_name;
                    crm.mobileLB.text = model.user_mobile;
                    switch ([model.state integerValue]) {
                        case 1:
                            crm.stateLB.text = [NSString stringWithFormat:@"待处理"];
                            crm.lineOneView.backgroundColor = kMyColor(249, 105, 8);
                            break;
                        case 2:
                            crm.stateLB.text = [NSString stringWithFormat:@"邀约中"];
                            crm.lineOneView.backgroundColor = kMyColor(59, 95, 46);
                            break;
                        case 3:
                            crm.stateLB.text = [NSString stringWithFormat:@"已到访"];
                            crm.lineOneView.backgroundColor = kMyColor(14, 175, 230);
                            break;
                        case 4:
                            crm.stateLB.text = [NSString stringWithFormat:@"办理中"];
                            crm.lineOneView.backgroundColor = kMyColor(249, 105, 150);
                            break;
                        case 5:
                            crm.stateLB.text = [NSString stringWithFormat:@"公司放弃"];
                            crm.lineOneView.backgroundColor = kMyColor(54, 120, 163);
                            break;
                        case 6:
                            crm.stateLB.text = [NSString stringWithFormat:@"客户放弃"];
                            crm.lineOneView.backgroundColor = kMyColor(149, 91, 165);
                            break;
                    }
                    crm.btn.tag = 20+i;
                    
                    
                    
                    [crm.btn addTarget:self action:@selector(clickCRM:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.orderView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.baseScrollView.mas_top).offset(40*KAdaptiveRateWidth*self.CRMArr.count+40*KAdaptiveRateWidth);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self.view layoutIfNeeded];
                }];
                
            } else {
                self.emptyCRMLb.hidden = NO;
            }
            
            [self.view layoutIfNeeded];
            
            [self setOrderData];
        } else {
            self.emptyCRMLb.hidden = NO;
            self.emptyCRMLb.text = errorStr;
            
            [self.view layoutIfNeeded];
            
            [self setOrderData];
        }
    }];
    [self.view layoutIfNeeded];
    
}
- (void)setOrderData {
    NSString *uid = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.userId];
    [HttpRequestEngine getMyOrderListWithUid:uid page:@"0" completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            
            [self.OrderArr removeAllObjects];
            NSArray *dataArr = (NSArray *)obj;
            if (dataArr.count > 2) {
                [self.OrderArr addObject:dataArr[0]];
                [self.OrderArr addObject:dataArr[1]];
            } else {
                [self.OrderArr addObjectsFromArray:dataArr];
            }
            if (self.OrderArr.count) {
                self.emptyOrderLb.hidden = YES;
                CGRect rect = self.orderView.frame;
                for (int i=0; i<self.OrderArr.count; i++) {
                    MyOrderModel *model = self.OrderArr[i];
                    workOrderView *order = [[workOrderView alloc]initWithFrame:CGRectMake(0, 50*KAdaptiveRateWidth*(i)+rect.origin.y+rect.size.height+5*KAdaptiveRateWidth, kScreenWidth, 50*KAdaptiveRateWidth)];
                    [self.baseScrollView addSubview:order];
                    [order.imageV sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"default_order_head"]];
                    order.orderNameLB.text = model.name;
                    order.orderIdLB.text = model.number_id;
                    if (model.speed == [NSNumber numberWithInteger:1]) {
                        order.stateLB.text = @"申请中";
                        order.lineOneView.backgroundColor = [UIColor greenColor];
                    }else if (model.speed == [NSNumber numberWithInteger:2]){
                        order.stateLB.text = @"审批中";
                        order.lineOneView.backgroundColor = kMyColor(254, 196, 46);
                    }else if (model.speed == [NSNumber numberWithInteger:3]){
                        order.stateLB.text = @"审批成功";
                        order.lineOneView.backgroundColor = [UIColor yellowColor];
                    }else if (model.speed == [NSNumber numberWithInteger:4]){
                        order.stateLB.text = @"已签约";
                        order.lineOneView.backgroundColor = [UIColor blueColor];
                    }else if (model.speed == [NSNumber numberWithInteger:5]){
                        order.stateLB.text = @"已放款";
                        order.lineOneView.backgroundColor = [UIColor redColor];
                    }else if (model.speed == [NSNumber numberWithInteger:6]){
                        order.stateLB.text = @"已成功";
                        order.lineOneView.backgroundColor = [UIColor redColor];
                    }else if (model.speed == [NSNumber numberWithInteger:7]){
                        order.stateLB.text = @"未通过";
                        order.lineOneView.backgroundColor = [UIColor lightGrayColor];
                    }
                    order.btn.tag = 30+i;
                    [order.btn addTarget:self action:@selector(clickOrder:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                [self.workBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.orderView.mas_bottom).offset(50*KAdaptiveRateWidth*self.OrderArr.count+10*KAdaptiveRateWidth);
                }];
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self.view layoutIfNeeded];
                }];
                CGRect rect1 = self.workBtnView.frame;
                self.baseScrollView.contentSize = CGSizeMake(0, rect1.origin.y+rect1.size.height+75);
            }else {
                self.emptyOrderLb.hidden = NO;
            }
            [self.view layoutIfNeeded];
            CGRect rect1 = self.workBtnView.frame;
            self.baseScrollView.contentSize = CGSizeMake(0, rect1.origin.y+rect1.size.height+75);
            
            [self.baseScrollView.header endRefreshing];
        } else {
            self.emptyOrderLb.hidden = NO;
            self.emptyOrderLb.text = errorStr;
            [self.view layoutIfNeeded];
            
            CGRect rect = self.workBtnView.frame;
            self.baseScrollView.contentSize = CGSizeMake(0, rect.origin.y+rect.size.height+75);
            
            [self.baseScrollView.header endRefreshing];
        }
    }];
    
}

- (void)clickCRM:(UIButton *)sender {
    NSInteger index = sender.tag%20;
    CRMListModel * model = self.CRMArr[index];
    CRMDetailsViewController *details = [CRMDetailsViewController new];
    [details returnIsRefreshCRM:^(NSString *returnIsRefrshCRM) {
//        self.isRefreshCRM = returnIsRefrshCRM;
    }];
    details.iconURL = model.icon;
    details.customerId = model.ID;
    
    NSArray *powerList = (NSArray *)self.MyUserInfoModel.powerList;
    NSMutableArray *funIdArray = [NSMutableArray array];
    for (int i=0; i<powerList.count; i++) {
        NSDictionary *powerDic = powerList[i];
        NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
        [funIdArray addObject:funId];
    }
    
    if ([funIdArray containsObject:@"5"]) {
        if ([funIdArray containsObject:@"17"]) {
            
            details.isUpdateCRM = 1;
        } else {
            details.isUpdateCRM = 0;
        }
        if ([funIdArray containsObject:@"18"]) {
            details.isDelCRM = 1;
        } else {
            details.isDelCRM = 0;
        }
        if ([funIdArray containsObject:@"19"]) {
            details.isChangeState = 1;
        } else {
            details.isChangeState = 0;
        }
        if ([funIdArray containsObject:@"20"]) {
            details.isCreateOrderCRM = 1;
        } else {
            details.isCreateOrderCRM = 0;
        }
        
        details.seType = 1;
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
        
    } else {
        [MBProgressHUD showToastText:@"暂无此权限"];
        return;
    }
    
 }
- (void)clickOrder:(UIButton *)sender {
    NSInteger index = sender.tag%30;
    MyOrderModel *model = self.OrderArr[index];
    NSArray *powerList = (NSArray *)self.MyUserInfoModel.powerList;
    
    NSMutableArray *funIdArray = [NSMutableArray array];
    for (int i=0; i<powerList.count; i++) {
        NSDictionary *powerDic = powerList[i];
        NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
        [funIdArray addObject:funId];
    }

    if ([funIdArray containsObject:@"6"]) {
        
        if (model.speed == [NSNumber numberWithInteger:1]){
            OnApplyOrderViewController * onApplyOrderVC = [[OnApplyOrderViewController alloc]init];
            onApplyOrderVC.orderID = model.kid;
            loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
            onApplyOrderVC.ptpId = model.ptpId;
            onApplyOrderVC.myPushId = model.myPushId;
            onApplyOrderVC.orderModel = model;
            onApplyOrderVC.refreshBlock = ^{
                //            [self.myOrderTableView.header beginRefreshing];
            };
            if ([funIdArray containsObject:@"21"]) {
                onApplyOrderVC.isAssignedApprover = 1;
            } else {
                onApplyOrderVC.isAssignedApprover = 0;
            }
            [onApplyOrderVC returnIsRefreshMyOrder:^(NSString *returnIsRefrshMyOrder) {
                
                //            self.isRefreshMyOrder = returnIsRefrshMyOrder;
            }];
            onApplyOrderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:onApplyOrderVC animated:YES];
            
        }else{
            LookOrderInfoViewController * lookOrderInfoVC = [[LookOrderInfoViewController alloc]init];
            
            lookOrderInfoVC.orderID = model.kid;
            
            lookOrderInfoVC.ptpId = model.ptpId;
            lookOrderInfoVC.myPushId = model.myPushId;
            lookOrderInfoVC.orderModel = model;
            lookOrderInfoVC.refreshBlcok = ^{
                //            [self.myOrderTableView.header beginRefreshing];
            };
            lookOrderInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lookOrderInfoVC animated:YES];
        }
        
    } else {
        [MBProgressHUD showToastText:@"暂无此权限"];
        return;
    }
    
}


//根据按钮的tag值跳转到不同的页面
- (void)clickWork:(UIButton *)sender {
    
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];

    NSArray *powerList = (NSArray *)loginModel.powerList;
    BOOL isOutDate = 0;
    if ([Utils isBlankString:self.MyUserInfoModel.vipStopTime]) {
        isOutDate = 1;
    } else {
        isOutDate = ![Utils compareTwoDateWithMinDate:self.MyUserInfoModel.currentTime MaxDate:self.MyUserInfoModel.vipStopTime];
    }
    
//    BOOL isNotBuy = ![self.MyUserInfoModel.orderExists intValue];
    
//    BOOL isMoreFive = [self.MyUserInfoModel.mechSize integerValue] > 0 ? 1:0;
    

    NSMutableArray *funIdArray = [NSMutableArray array];
    for (int i=0; i<powerList.count; i++) {
        NSDictionary *powerDic = powerList[i];
        NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
        [funIdArray addObject:funId];
    }
    if (sender.tag == 0) {
        if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
            if ( isOutDate) {
                [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
                return ;
            } else {
                if ([funIdArray containsObject:@"1"]) {
                    ProductManageViewController *productManage = [ProductManageViewController new];
                    productManage.seType = 1;
                    if ([funIdArray containsObject:@"10"]) {
                        productManage.isAddPro = 1;
                    } else {
                        productManage.isAddPro = 0;
                    }
                    if ([funIdArray containsObject:@"11"]) {
                        productManage.isUpdatePro = 1;
                    } else {
                        productManage.isUpdatePro = 0;
                    }
                    if ([funIdArray containsObject:@"30"]) {
                        productManage.isPushPro = 1;
                    } else {
                        productManage.isPushPro = 0;
                    }
                    self.navigationController.navigationBar.hidden = NO;
                    productManage.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:productManage animated:YES];
                } else {
                    [MBProgressHUD showError:@"暂无此权限"];
                }
                
            }
        } else {
            [MBProgressHUD showError:@"该功能正在开发中..."];
        }
    }
    if (sender.tag == 1) {
        if ( isOutDate) {
            [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
            return ;
        } else {
            if ([funIdArray containsObject:@"2"]) {
                
                ProductManageViewController *productManage = [ProductManageViewController new];
                if ([funIdArray containsObject:@"7"]) {
                    productManage.isAddTask = 1;
                } else {
                    productManage.isAddTask = 0;
                }
                if ([funIdArray containsObject:@"8"]) {
                    productManage.isUpdateTask = 1;
                } else {
                    productManage.isUpdateTask = 0;
                }
                if ([funIdArray containsObject:@"9"]) {
                    productManage.isDelTask = 1;
                } else {
                    productManage.isDelTask = 0;
                }
                
                productManage.seType = 2;
                self.navigationController.navigationBar.hidden = NO;
                productManage.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productManage animated:YES];
            } else {
                [MBProgressHUD showError:@"暂无此权限"];
            }
        }
        
    }
    if (sender.tag == 2) {
        
//        if ([funIdArray containsObject:@"3"]) {
//            if ([loginModel.isVip isEqualToString:@"1"]) {
//                RetailSaleViewController *RetailSale = [RetailSaleViewController new];
//                RetailSale.hidesBottomBarWhenPushed = YES;
//                
//                [self.navigationController pushViewController:RetailSale animated:YES];
//            } else {
//                [MBProgressHUD showError:@"您不是VIP"];
//            }
//        } else {
//            [MBProgressHUD showError:@"暂无此权限"];
//        }
//        [MBProgressHUD showHud];
        [MBProgressHUD showToastText:@"功能敬请期待！"];
//        self.navigationController.navigationBar.hidden = NO;

    }
    if (sender.tag == 3) {
        if ( isOutDate) {
            [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
            return ;
        } else {
            if ([funIdArray containsObject:@"4"]) {
                ProductManageViewController *productManage = [ProductManageViewController new];
                productManage.seType = 3;
                self.navigationController.navigationBar.hidden = NO;
                productManage.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:productManage animated:YES];
            } else {
                [MBProgressHUD showError:@"暂无此权限"];
            }
        }
        
    }
    if (sender.tag == 4) {
        CRMViewController *CRM = [CRMViewController new];
        CRM.isAddCRM = 1;
        CRM.isUpdateCRM = 1;
        CRM.isDeleteCRM = 1;
        CRM.isChangeStateCRM = 1;
        CRM.isCreateOrderCRM = 1;
        self.navigationController.navigationBar.hidden = NO;
        CRM.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:CRM animated:YES];
//        if ( isOutDate) {
//            [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
//            return ;
//        } else {
//            if ([funIdArray containsObject:@"5"]) {
//
//                CRMViewController *CRM = [CRMViewController new];
//
//                if ([funIdArray containsObject:@"16"]) {
//                    CRM.isAddCRM = 1;
//                } else {
//                    CRM.isAddCRM = 0;
//                }
//                if ([funIdArray containsObject:@"17"]) {
//                    CRM.isUpdateCRM = 1;
//                } else {
//                    CRM.isUpdateCRM = 0;
//                }
//                if ([funIdArray containsObject:@"18"]) {
//                    CRM.isDeleteCRM = 1;
//                } else {
//                    CRM.isDeleteCRM = 0;
//                }
//                if ([funIdArray containsObject:@"19"]) {
//                    CRM.isChangeStateCRM = 1;
//                } else {
//                    CRM.isChangeStateCRM = 0;
//                }
//                if ([funIdArray containsObject:@"20"]) {
//                    CRM.isCreateOrderCRM = 1;
//                } else {
//                    CRM.isCreateOrderCRM = 0;
//                }
//                self.navigationController.navigationBar.hidden = NO;
//                CRM.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:CRM animated:YES];
//            } else {
//                [MBProgressHUD showError:@"暂无此权限"];
//            }
//        }
    }

    if (sender .tag == 5) {
        if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
            if ( isOutDate) {
                [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
                return ;
            } else {
                if ([funIdArray containsObject:@"6"]) {
                    
                    OrderViewController * orderVC = [OrderViewController new];
                    
                    if ([funIdArray containsObject:@"21"]) {
                        orderVC.isAssignedApprover = 1;
                    }else{
                        orderVC.isAssignedApprover = 0;
                    }
                    if ([funIdArray containsObject:@"31"]) {
                        orderVC.ispush = 1;
                    } else {
                        orderVC.ispush = 0;
                    }
                    self.navigationController.navigationBar.hidden = NO;
                    orderVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:orderVC animated:YES];
                    
                }else{
                    [MBProgressHUD showError:@"暂无此权限"];
                }
            }
        } else {
            [MBProgressHUD showError:@"该功能正在开发中..."];
        }
        
    }
    if (sender.tag == 6) {
        if ( isOutDate) {
            [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
            return ;
        } else {
            if ([funIdArray containsObject:@"12"]) {
                NoticeListViewController *noticeList = [NoticeListViewController new];
                
                if ([funIdArray containsObject:@"13"]) {
                    noticeList.isAddnotice = 1;
                } else {
                    noticeList.isAddnotice = 0;
                }
                if ([funIdArray containsObject:@"15"]) {
                    noticeList.isDeleteNotice = 1;
                } else {
                    noticeList.isDeleteNotice = 0;
                }
                if ([funIdArray containsObject:@"14"]) {
                    noticeList.isUpdateNotice = 1;
                } else {
                    noticeList.isUpdateNotice = 0;
                }
                self.navigationController.navigationBar.hidden = NO;
                noticeList.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:noticeList animated:YES];
            } else {
                [MBProgressHUD showError:@"暂无此权限"];
            }
        }
        
    }
//    if (sender.tag == 7) {
//        if ([funIdArray containsObject:@"22"]) {
//            UpgradeViewController *UpgradeList = [UpgradeViewController new];
//            
//            if ([funIdArray containsObject:@"23"]) {
//                UpgradeList.isEditUpgrade = 1;
//            } else {
//                UpgradeList.isEditUpgrade = 0;
//            }
//            if ([funIdArray containsObject:@"24"]) {
//                UpgradeList.isDeleteUpgrade = 1;
//            } else {
//                UpgradeList.isDeleteUpgrade = 0;
//            }
//            UpgradeList.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:UpgradeList animated:YES];
//        } else {
//            [MBProgressHUD showError:@"暂无此权限"];
//        }
//    }
    if (sender.tag == 7) {
        if ( isOutDate) {
            [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
            return ;
        } else {
            if ([funIdArray containsObject:@"28"]) {
                
                ExecutiveForceViewController *ExecutiveForce = [ExecutiveForceViewController new];
                self.navigationController.navigationBar.hidden = NO;
                ExecutiveForce.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ExecutiveForce animated:YES];
                
            }else{
                [MBProgressHUD showError:@"暂无此权限"];
                
            }
        }
        
    }
    if (sender.tag == 8) {
        if ( isOutDate) {
            [MBProgressHUD showError:@"您未开通付费服务，无法使用该功能"];
            return ;
        } else {
            if ([funIdArray containsObject:@"37"]) {
                EMViewController *EMVC = [EMViewController new];
                self.navigationController.navigationBar.hidden = NO;
                EMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:EMVC animated:YES];
            } else {
                [MBProgressHUD showError:@"暂无此权限"];
            }
        }
        
    }
    if (sender.tag == 9) {
        if ([funIdArray containsObject:@"38"]) {
            FinanceMgrViewController *FMVC = [FinanceMgrViewController new];
            self.navigationController.navigationBar.hidden = NO;
            FMVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:FMVC animated:YES];
        } else {
            [MBProgressHUD showError:@"暂无此权限"];
        }
    }
    if (sender.tag == 10) {
        
        approvalMainViewController *AMVC = [approvalMainViewController new];
        self.navigationController.navigationBar.hidden = NO;
        AMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:AMVC animated:YES];
        
    }
    if (sender.tag == 11) {
        attendanceViewController *attendanceVC = [attendanceViewController new];
        self.navigationController.navigationBar.hidden = NO;
        attendanceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:attendanceVC animated:YES];
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
