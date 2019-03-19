//
//  attendanceViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/1.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceViewController.h"
#import "attendanceCollectionViewCell.h"
#import "attendanceTableViewCell.h"
#import "attendanceModel.h"
#import "attendanceSetViewController.h"
#import "attendanceStatisticsViewController.h"
#import "deptAttendanceViewController.h"
@interface attendanceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,SelectDateTimeDelegate>

{
    DateTimeSelectView *_dateTimeSelectView;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *detailsTableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *timeStr;//请求用到的时间字符串

@property (nonatomic, strong) NSMutableArray *dataArrOne;
@property (nonatomic, strong) NSMutableArray *dataArrTwo;
@property (nonatomic, strong) NSMutableArray *dataArrThree;
@property (nonatomic, strong) NSMutableArray *dataArrFour;
@property (nonatomic, strong) NSMutableArray *dataArrFive;
@property (nonatomic, strong) NSMutableArray *dataArrSix;
@property (nonatomic, strong) NSMutableArray *dataArrSeven;

@property (nonatomic, strong) NSString *type;//1.休 2.工作
@end

@implementation attendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"考勤管理";
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AttendanceStatistics"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAdd)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"attendanceSet"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick:)];
    NSArray *powerList = (NSArray *)self.MyUserInfoModel.powerList;
    NSMutableArray *funIdArray = [NSMutableArray array];
    for (int i=0; i<powerList.count; i++) {
        NSDictionary *powerDic = powerList[i];
        NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
        [funIdArray addObject:funId];
    }
    if ([funIdArray containsObject:@"36"]) {
        if (self.MyUserInfoModel.level == 2 ) {
            self.navigationItem.rightBarButtonItems = @[one,two];
        } else {
            self.navigationItem.rightBarButtonItems = @[two];
        }
    } else {
        if (self.MyUserInfoModel.level == 2 ) {
            self.navigationItem.rightBarButtonItems = @[one];
        }
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArrOne = [NSMutableArray arrayWithCapacity:0];
    self.dataArrTwo = [NSMutableArray arrayWithCapacity:0];
    self.dataArrThree = [NSMutableArray arrayWithCapacity:0];
    self.dataArrFour = [NSMutableArray arrayWithCapacity:0];
    self.dataArrFive = [NSMutableArray arrayWithCapacity:0];
    self.dataArrSix = [NSMutableArray arrayWithCapacity:0];
    self.dataArrSeven = [NSMutableArray arrayWithCapacity:0];
    [self setupView];
    
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
    // Do any additional setup after loading the view.
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
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(width, 190*KAdaptiveRateWidth);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, 190*KAdaptiveRateWidth) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.tag = 100;
    collectionView.bounces = YES;
    [collectionView registerClass:[attendanceCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.view addSubview:collectionView];
    [collectionView setContentOffset:CGPointMake(6 * (width), 0) animated:NO];
    self.collectionView = collectionView;
    self.index = 6;
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(30, 190*KAdaptiveRateWidth, 2, kScreenHeight-190*KAdaptiveRateWidth)];
    [self.view addSubview:lineV1];
    lineV1.backgroundColor = GRAY180;
    
    if (self.detailsTableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190*KAdaptiveRateWidth, width, height-190*KAdaptiveRateWidth)];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tag = 200;
        [tableView registerClass:[attendanceTableViewCell class] forCellReuseIdentifier:@"cell"];
        self.detailsTableView = tableView;
        [self.view addSubview:self.detailsTableView];
    }
    
    NSDate *date = [NSDate date];
    
    self.timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
    
    [self requestDataWithTime:self.timeStr];
    
    self.detailsTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSDate *date = [NSDate date];
        NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
        [self requestDataWithTime:timeStr];
    }];
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-40, 80, 80) imageName:@"noData" title:@"暂无考勤数据"];
    [self.detailsTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
    UIView *jiji = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-150, kScreenWidth, 150)];
    [self.view addSubview:jiji];
    jiji.backgroundColor = [UIColor whiteColor];
    jiji.userInteractionEnabled = NO;
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    UIColor *colorOne = [UIColor clearColor];
    UIColor *colorTwo = [UIColor colorWithWhite:1 alpha:0.4];
    UIColor *colorThree = [UIColor whiteColor];
    headerLayer.colors = @[(id)colorOne.CGColor,(id)colorTwo.CGColor,(id)colorThree.CGColor];
    headerLayer.locations = @[@0,@0.5,@1];
    headerLayer.frame = CGRectMake(0, 0, kScreenWidth, 150);
    jiji.layer.mask = headerLayer;
}
- (void)requestDataWithTime:(NSString *)time {
    
    NSString *Mech_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    NSString *userID = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.userId];
    [HttpRequestEngine getAttendenceWithMech_id:Mech_id userId:userID time:time completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *dataArr = obj[@"cardSign"];
            self.type = [NSString stringWithFormat:@"%@",obj[@"type"]];
            NSArray *arr = dataArr;
            if (arr.count) {
                [self.dataArrSeven removeAllObjects];
                for (NSDictionary *dic in arr) {
                    attendanceModel *model = [attendanceModel requestWithDic:dic];
                    switch (self.index) {
                        case 6:
                            [self.dataArrSeven addObject:model];
                            break;
                        case 5:
                            [self.dataArrSix addObject:model];
                            break;
                        case 4:
                            [self.dataArrFive addObject:model];
                            break;
                        case 3:
                            [self.dataArrFour addObject:model];
                            break;
                        case 2:
                            [self.dataArrThree addObject:model];
                            break;
                        case 1:
                            [self.dataArrTwo addObject:model];
                            break;
                        case 0:
                            [self.dataArrOne addObject:model];
                            break;
                        default:
                            break;
                    }
                }
                self.detailsTableView.backgroundColor = [UIColor clearColor];
                self.blankV.hidden = YES;
            } else {
                [self.dataArrSeven removeAllObjects];
                self.detailsTableView.backgroundColor = VIEW_BASE_COLOR;
                self.blankV.hidden = NO;
            }
            [self.collectionView reloadData];
            [self.detailsTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
    [self.detailsTableView.header endRefreshing];
}
#pragma mark == collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    attendanceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    
    [cell requestDataWithTime:self.timeStr type:self.type];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _dateTimeSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = timeViewRect;
    }];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;

}
#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *timeStr = [NSString stringWithFormat:@"%@",dictDate[@"date"]];
    self.timeStr = timeStr;
    [self requestDataWithTime:self.timeStr];
    
    self.detailsTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestDataWithTime:self.timeStr];
    }];

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

#pragma mark == tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.index) {
        case 6:
            return self.dataArrSeven.count;
            break;
        case 5:
            return self.dataArrSix.count;
            break;
        case 4:
            return self.dataArrFive.count;
            break;
        case 3:
            return self.dataArrFour.count;
            break;
        case 2:
            return self.dataArrThree.count;
            break;
        case 1:
            return self.dataArrTwo.count;
            break;
        case 0:
            return self.dataArrOne.count;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    attendanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[attendanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    attendanceModel *model;
    switch (self.index) {
        case 6:
            model = self.dataArrSeven[indexPath.row];
            break;
        case 5:
            model = self.dataArrSix[indexPath.row];
            break;
        case 4:
            model = self.dataArrFive[indexPath.row];
            break;
        case 3:
            model = self.dataArrFour[indexPath.row];
            break;
        case 2:
            model = self.dataArrThree[indexPath.row];
            break;
        case 1:
            model = self.dataArrTwo[indexPath.row];
            break;
        case 0:
            model = self.dataArrOne[indexPath.row];
            break;
    }
    cell.timeLB.text = model.card_time;
    cell.IDLB.text = [NSString stringWithFormat:@"ID:%@",model.Id];
    return cell;
}
#pragma mark == 滚动代理
//滚动动画停止时执行,代码改变时出发,也就是setContentOffset改变时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    switch (scrollView.tag) {
        case 100:
        {
            CGPoint p = scrollView.contentOffset;
            
            if (p.x == kScreenWidth*6) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*7 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 6;
                if (!self.dataArrSeven.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
            if (p.x == kScreenWidth*5) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*6 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 5;
                if (!self.dataArrSix.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
            if (p.x == kScreenWidth*4) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*5 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 4;
                if (!self.dataArrFive.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
            if (p.x == kScreenWidth*3) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*4 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 3;
                if (!self.dataArrFour.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
            if (p.x == kScreenWidth*2) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*3 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 2;
                if (!self.dataArrThree.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
            if (p.x == kScreenWidth*1) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*2 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 1;
                if (!self.dataArrTwo.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
            if (p.x == kScreenWidth*0) {
                NSDate *nextDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];//当前时间前七天
                NSDate *date = [NSDate dateWithTimeInterval:24*3600*1 sinceDate:nextDay];
                NSString *timeStr = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
                self.index = 0;
                if (!self.dataArrOne.count) {
                    [self requestDataWithTime:timeStr];
                }
            }
        }
            break;
        default:
        {
            
        }
            break;
    }
    
}

#pragma mark == 右边两个item点击事件
- (void)ClickAdd {
    deptAttendanceViewController *dept = [deptAttendanceViewController new];
    [self.navigationController pushViewController:dept animated:YES];
}
- (void)searchBtnClick:(UIBarButtonItem *)sender {
    attendanceSetViewController *set = [attendanceSetViewController new];
    [self.navigationController pushViewController:set animated:YES];
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
