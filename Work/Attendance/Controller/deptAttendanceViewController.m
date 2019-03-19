//
//  deptAttendanceViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/19.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "deptAttendanceViewController.h"
#import "JohnTopTitleView.h"
#import "dailyViewController.h"
#import "monthlyViewController.h"
#import "FDAlertView.h"
#import "dailyClickView.h"
#import "announcementView.h"
@interface deptAttendanceViewController ()<UIScrollViewDelegate,SelectDateTimeDelegate,UIGestureRecognizerDelegate>{
    DateTimeSelectView *_dateTimeSelectView;
    DateTimeSelectView *_MonthSelectView;
}
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic,strong) JohnTopTitleView *titleView;

@property(nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) dailyViewController *vcOne;
@property (nonatomic, strong) monthlyViewController *vcTwo;
@property (nonatomic, assign) BOOL isRequested;//用于判断第二个界面是否 requestData 过
@end

@implementation deptAttendanceViewController
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, NaviHeight, self.view.frame.size.width, kScreenHeight-NaviHeight)];
    }
    return _titleView;
}
-(dailyViewController *)vcOne{
    if (!_vcOne) {
        _vcOne = [[dailyViewController alloc]init];
    }
    return _vcOne;
}
-(monthlyViewController *)vcTwo{
    if (!_vcTwo) {
        _vcTwo = [[monthlyViewController alloc]init];
        
    }
    return _vcTwo;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"部门考勤统计";
    NSArray *titleArray = [NSArray arrayWithObjects:@"日报",@"月报", nil];
    self.titleView.title = titleArray;
    self.isRequested = 0;
    __weak typeof (self) weakSelf = self;
    self.titleView.selectBlock = ^(NSInteger index){
        weakSelf.index = index;
        if (index == 1) {
            if (!weakSelf.isRequested) {
                [weakSelf.vcTwo requestData];
                weakSelf.isRequested = 1;
            }
        }
    };
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    self.titleView.pageScrollView.bounces = NO;
    [self.view addSubview:self.titleView];
    
    UIGestureRecognizer *gestur = [[UIGestureRecognizer alloc]init];
    gestur.delegate=self;
    [self.titleView.pageScrollView addGestureRecognizer:gestur];
        
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.5;
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMdd"];
    _dateTimeSelectView.delegateGetDate = self;
    
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
    
    _MonthSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMM"];
    _MonthSelectView.delegateGetDate = self;
    
    [self.navigationController.view addSubview:_MonthSelectView];
    _MonthSelectView.hidden = YES;
    // Do any additional setup after loading the view.
}
- (NSArray <UIViewController *>*)setChildVC{
    
    FDAlertView *alert = [FDAlertView new];
    alert.backgroundView.backgroundColor = [UIColor clearColor];
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    NSString *user_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.userId];
    NSString *dept_id = [NSString stringWithFormat:@"%@",self.MyUserInfoModel.dept_id];
    __weak typeof (self) weakSelf = self;
    self.vcOne.dailyblock = ^(NSDictionary *modelDic,NSString *time) {
        NSString *name = modelDic[@"name"];
        NSString *type = modelDic[@"type"];
        dailyClickView *daily = [[dailyClickView alloc]initWithFrame:CGRectMake(0, 0, 290*KAdaptiveRateWidth, 500*KAdaptiveRateHeight) modelArr:@[@"1"] mech_id:mech_id user_id:user_id dept_id:dept_id type:type time:time title:name];
        alert.contentView = daily;
        [alert show];
    };
    self.vcOne.showDate = ^(){
        [weakSelf dateChooseBtnClick];
    };
    
    self.vcTwo.showDate = ^{
        [weakSelf MonthChooseBtnClick];
    };
    self.vcTwo.clickBangOne = ^(NSArray *modelArr) {
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:modelArr];
        announcementView *ann = [[announcementView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) modelArr:mutableArr title:@"zao"];
        weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        ann.isPopBlock = ^{
            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        };
        [weakSelf.navigationController.view addSubview:ann];
    };
    self.vcTwo.clickBangTwo = ^(NSArray *modelArr) {
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:modelArr];
        announcementView *ann = [[announcementView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) modelArr:mutableArr title:@"chi"];
        weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        ann.isPopBlock = ^{
            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        };
        [weakSelf.navigationController.view addSubview:ann];
    };
    
    
    NSArray *childVC = [NSArray arrayWithObjects:self.vcOne,self.vcTwo, nil];
    return childVC;
}
- (void)dateChooseBtnClick {
    _dateTimeSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = timeViewRect;
    }];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;

}
- (void)MonthChooseBtnClick {
    _MonthSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:animateTime animations:^{
        _MonthSelectView.frame = timeViewRect;
    }];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@",dictDate[@"date"]];
    if (self.index == 0) {
        [self.vcOne.dateChooseBtn setTitle:[NSString stringWithFormat:@" %@",dateStr] forState:UIControlStateNormal];
        [UIView animateWithDuration:animateTime animations:^{
            _dateTimeSelectView.frame = hideTimeViewRect;
        } completion:^(BOOL finished) {
            [self.vcOne reloadData];
            _dateTimeSelectView.hidden = YES;
            self.bgView.hidden = YES;
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        }];
    } else {
        [self.vcTwo.dateChooseBtn setTitle:[NSString stringWithFormat:@" %@",dateStr] forState:UIControlStateNormal];
        [UIView animateWithDuration:animateTime animations:^{
            _MonthSelectView.frame = hideTimeViewRect;
        } completion:^(BOOL finished) {
            [self.vcTwo reloadData];
            _MonthSelectView.hidden = YES;
            self.bgView.hidden = YES;
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        }];
    }
    
}

- (void)cancelDate {
    if (self.index == 0) {
        [UIView animateWithDuration:animateTime animations:^{
            _dateTimeSelectView.frame = hideTimeViewRect;
        } completion:^(BOOL finished) {
            _dateTimeSelectView.hidden = YES;
            self.bgView.hidden = YES;
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        }];
    } else {
        [UIView animateWithDuration:animateTime animations:^{
            _MonthSelectView.frame = hideTimeViewRect;
        } completion:^(BOOL finished) {
            _MonthSelectView.hidden = YES;
            self.bgView.hidden = YES;
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        }];
    }
    
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    
    CGPoint p = [touch locationInView:self.vcOne.chartView];
    if (p.x < 50*KAdaptiveRateWidth || p.x > (kScreenWidth-50*KAdaptiveRateWidth) || p.y < 110*KAdaptiveRateWidth || p.y > 400*KAdaptiveRateWidth) {
        self.vcOne.chartView.rotationEnabled = NO;
        self.titleView.pageScrollView.scrollEnabled = YES;
        
    } else {
        self.vcOne.chartView.rotationEnabled = YES;
        self.titleView.pageScrollView.scrollEnabled = NO;
        
    }
    return NO;
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
