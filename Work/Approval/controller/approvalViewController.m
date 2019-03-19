//
//  approvalViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/5.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalViewController.h"
#import "CustomSlideView.h"
#import "WorkBtn.h"

#import "ApprovalDetailViewController.h"

#define adsViewWidth 240.0*(kScreenWidth/320.0)
#define RatioValue  (kScreenHeight-118)/450.0
@interface approvalViewController ()<SlideCardViewDelegate,UIGestureRecognizerDelegate>
{
    CustomSlideView *_slide;
    WorkBtn *_workBtn;
}

@property (nonatomic, strong) NSString *viewTypeStr;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bgViewTwo;
@property (nonatomic, assign) int i;
@end

@implementation approvalViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"新增审批";
    self.view.backgroundColor = TABBAR_BASE_COLOR;
    self.i = 0;
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight)];
    [self.view addSubview:self.bgView];
    self.viewTypeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"viewType"]];
    if ([self.viewTypeStr isEqualToString:@"1"]) {
        
        [self setupPlaidView];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"viewType"];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cardPage"] style:UIBarButtonItemStylePlain target:self action:@selector(changeType)];
        self.navigationItem.rightBarButtonItem = right;
    } else {
        [self setupPageView];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"viewType"];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Plaid"] style:UIBarButtonItemStylePlain target:self action:@selector(changeType)];
        self.navigationItem.rightBarButtonItem = right;
        
    }
    
    // Do any additional setup after loading the view.
}
-(void)changeType {
    self.viewTypeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"viewType"]];
    if ([self.viewTypeStr isEqualToString:@"0"]) {
        
        
        for (UIView *view in [self.bgView subviews]) {
            [view removeFromSuperview];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"viewType"];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cardPage"] style:UIBarButtonItemStylePlain target:self action:@selector(changeType)];
        self.navigationItem.rightBarButtonItem = right;
        
        [self setupPlaidView];
    } else {
        
        for (WorkBtn *view in [self.bgView subviews]) {
            [view removeFromSuperview];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"viewType"];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Plaid"] style:UIBarButtonItemStylePlain target:self action:@selector(changeType)];
        self.navigationItem.rightBarButtonItem = right;
        self.i = 0;
        
        [self setupPageView];
    }
}
-(void)setupPlaidView {
    NSArray *imageArr = @[@"ic_apply_for_reimbursement",@"ic_apply_leave",@"ic_apply_dimission",@"ic_apply_become_a_regular_worker",@"ic_apply_overtime",@"ic_apply_evection",@"ic_apply_supplement",@"ic_apply_purchase",@"ic_apply_common",@"ic_apply_waiqing"];
    NSArray *nameArr = @[@"报销审批",@"请假审批",@"离职审批",@"转正审批",@"加班审批",@"出差审批",@"补打卡审批",@"采购审批",@"普通审批",@"外勤审批"];
    
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.viewTypeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"viewType"]];
    
    UILabel *label = [[UILabel alloc] init];
    label.alpha = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    [self.bgView addSubview:label];
    
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor clearColor];
    btn.alpha = 0;
    [self.bgView addSubview:btn];
    btn.tag = self.i;
    
    if (self.i<10) {
        label.text = nameArr[self.i];
        [btn setBackgroundImage:[UIImage imageNamed:imageArr[self.i]] forState:UIControlStateNormal];
    } else {
        
    }
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset((self.i/3)*(65+((kScreenWidth - 65*3)/4.0)+15*KAdaptiveRateWidth)+(kScreenWidth - 65*3)/4.0 +15*KAdaptiveRateWidth);
        make.left.equalTo(self.view.mas_left).offset((self.i%3)*(65+((kScreenWidth - 65*3)/4.0))+((kScreenWidth - 65*3)/4.0));
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(70);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.centerX.equalTo(btn.mas_centerX);
        make.height.mas_equalTo(16);
    }];
    
    [UIView animateWithDuration:0.08 animations:^{
        btn.alpha = 1;
        label.alpha = 1;
    } completion:^(BOOL finished) {
        
        if ([self.viewTypeStr isEqualToString:@"1"]) {
            if (self.i < 9) {
                self.i = self.i + 1;
                
                [self setupPlaidView];
                
                self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
            } else {
                self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
            }
        }
    }];
}
-(void)setupPageView {

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    self.viewTypeStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"viewType"]];
    
    NSArray *array = @[
                       @{@"imageName":@"ic_apply_waiqing_card"},
                       @{@"imageName":@"ic_apply_common_card"},
                       @{@"imageName":@"ic_apply_purchase_card"},
                       @{@"imageName":@"ic_apply_supplement_card"},
                       @{@"imageName":@"ic_apply_evection_card"},
                       @{@"imageName":@"ic_apply_overtime_card"},
                       @{@"imageName":@"ic_apply_become_a_regular_worker_card"},
                       @{@"imageName":@"ic_apply_dimission_card"},
                       @{@"imageName":@"ic_apply_leave_card"},
                       @{@"imageName":@"ic_apply_for_reimbursement_card"}
                       ];
    
    CGRect rect = {{lrintf((kScreenWidth-adsViewWidth)/2.0),188*KAdaptiveRateWidth-NaviHeight},{240*KAdaptiveRateWidth , kScreenHeight-66-NaviHeight }};
    
    _slide = [[CustomSlideView alloc]initWithFrame:rect AndzMarginValue:9/(RatioValue) AndxMarginValue:11/(RatioValue) AndalphaValue:1 AndangleValue:2];
    _slide.delegate = self;
    _slide.center = CGPointMake(kScreenWidth/2.0, (kScreenHeight-NaviHeight)/2.0+70*KAdaptiveRateWidth);
    [_slide addCardDataWithArray:array];
    _slide.backgroundColor = [UIColor clearColor];
    
    [self.bgView addSubview:_slide];
}
#pragma mark- 代理
-(void)slideCardViewDidEndScrollIndex:(NSInteger)index
{
    NSLog(@"__end__%ld",index);
}

-(void)slideCardViewDidSlectIndex:(NSInteger)index
{
    ApprovalDetailViewController *approvalVC = [ApprovalDetailViewController new];
    approvalVC.type = 1;
    approvalVC.refreshBlock = ^(){
        self.refreshBlock();
    };
    approvalVC.application_id = [NSString stringWithFormat:@"%ld",index+1];
    [self.navigationController pushViewController:approvalVC animated:YES];
    NSLog(@"__select__%ld",index);
}

-(void)slideCardViewDidScrollAllPage:(NSInteger)page AndIndex:(NSInteger)index
{
    NSLog(@"__page__%ld__index__%ld",page,index);
    
    //判断是否为第一页
    //    if(page == index){
    //        if (self.comeBackFirstMessageButton.frame.origin.y<APPScreenBoundsHeight) {
    //            [UIView animateWithDuration:0.8 animations:^{
    //                self.comeBackFirstMessageButton.center = CGPointMake(self.comeBackFirstMessageButton.center.x, self.comeBackFirstMessageButton.center.y+self.comeBackFirstMessageButton.frame.size.height);
    //            }];
    //        }
    //    }else{
    //        if (self.comeBackFirstMessageButton.frame.origin.y>=APPScreenBoundsHeight) {
    //            [UIView animateWithDuration:0.8 animations:^{
    //                self.comeBackFirstMessageButton.center = CGPointMake(self.comeBackFirstMessageButton.center.x, self.comeBackFirstMessageButton.center.y-self.comeBackFirstMessageButton.frame.size.height);
    //            }];
    //        }
    //    }
    
    //提醒已是最后一条消息,由透明慢慢显现
    //    if (_curPage == _totalPage && slideImageView.scrollView.contentOffset.y<0) {
    //        self.lastMessageLabel.alpha = -(slideImageView.scrollView.contentOffset.y/50.0);
    //    }
}
- (void)btnClick:(UIButton *)sender {
    ApprovalDetailViewController *approvalVC = [ApprovalDetailViewController new];
    approvalVC.type = 1;
    approvalVC.application_id = [NSString stringWithFormat:@"%ld",sender.tag+1];
    approvalVC.refreshBlock = ^(){
        self.refreshBlock();
    };
    [self.navigationController pushViewController:approvalVC animated:YES];
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
