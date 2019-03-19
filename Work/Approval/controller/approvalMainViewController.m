//
//  approvalMainViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/10.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalMainViewController.h"
#import "approvalViewController.h"
#import "ApprovalDetailViewController.h"

#import "JohnTopTitleView.h"
#import "DYVCSegmentOne.h"
#import "DYVCSegmentTwo.h"
#import "DYVCSegmentThree.h"
#import "DYVCSegmentFour.h"
#import "siftingView.h"

#import "approvalModel.h"
@interface approvalMainViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) JohnTopTitleView *titleView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)DYVCSegmentOne *vcOne;

@property(nonatomic,strong)DYVCSegmentTwo *vcTwo;

@property(nonatomic,strong)DYVCSegmentThree *vcThree;

@property(nonatomic, strong)DYVCSegmentFour *vcFour;

@property(nonatomic, strong)siftingView *siftingView;

@property(nonatomic) NSInteger index;

@property(nonatomic) UIView *naviBarView;
@end

@implementation approvalMainViewController

- (UIView *)naviBarView {
    if (!_naviBarView) {
        UIView *navBarView = [[UIView alloc] init];
        navBarView.backgroundColor = TABBAR_BASE_COLOR;
        navBarView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NaviHeight);
        [self.view addSubview:navBarView];
        self.naviBarView = navBarView;
    }
    return _naviBarView;
}

-(siftingView *)siftingView {
    if (!_siftingView) {
        _siftingView = [[siftingView alloc] initWithFrame:CGRectMake(0, -kScreenHeight+NaviHeight, kScreenWidth, kScreenHeight-NaviHeight)];
        _siftingView.bgView.hidden = YES;
        
    }
    return _siftingView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight+44, kScreenWidth, kScreenHeight-NaviHeight-44)];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator  = NO;
        _scrollView.showsVerticalScrollIndicator    = NO;
        _scrollView.contentSize     = CGSizeMake(kScreenWidth * 3, 0);
        _scrollView.pagingEnabled   = YES;
        _scrollView.bounces         = NO;
        
    }
    return _scrollView;
}
-(DYVCSegmentOne *)vcOne{
    if (!_vcOne) {
        _vcOne = [[DYVCSegmentOne alloc]init];
    }
    return _vcOne;
}
-(DYVCSegmentTwo *)vcTwo{
    if (!_vcTwo) {
        _vcTwo = [[DYVCSegmentTwo alloc]init];
        
    }
    return _vcTwo;
}
-(DYVCSegmentThree *)vcThree{
    if (!_vcThree) {
        _vcThree = [[DYVCSegmentThree alloc]init];
        
    }
    return _vcThree;
}
-(DYVCSegmentFour *)vcFour{
    if (!_vcFour) {
        _vcFour = [[DYVCSegmentFour alloc]init];
        
    }
    return _vcFour;
}

- (void)createUI{
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"我提交的",@"待我审批",@"通知我的",@"我审批的", nil];
    self.titleView.title = titleArray;
    __weak typeof (self) weakSelf = self;
    self.titleView.selectBlock = ^(NSInteger index){
        weakSelf.index = index;
    };
    [self.titleView setupViewControllerWithFatherVC:self childVC:[self setChildVC]];
    [self.view addSubview:self.titleView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    
//    [self.navigationController.view addSubview:self.siftingView];
    [self.view addSubview:self.siftingView];
    
    [self.view addSubview:self.naviBarView];
    
    __weak typeof (self) weakSelf = self;
    _siftingView.hideBlock = ^(){
        weakSelf.siftingView.bgView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
//            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
            weakSelf.siftingView.frame = CGRectMake(0, -kScreenHeight+NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
        }];
    };
    _siftingView.siftBlock = ^(NSMutableDictionary *dic) {
        [UIView animateWithDuration:0.2 animations:^{
//            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
            weakSelf.siftingView.frame = CGRectMake(0, -kScreenHeight+NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
        }];
        if (weakSelf.index == 0) {
            [weakSelf.vcOne siftingDataWithDic:dic];
        } else if (weakSelf.index == 1){
            [weakSelf.vcTwo siftingDataWithDic:dic];
        } else if (weakSelf.index == 2) {
            [weakSelf.vcThree siftingDataWithDic:dic];
        } else if (weakSelf.index == 3) {
            [weakSelf.vcFour siftingDataWithDic:dic];
        }
        
    };
}
- (NSArray <UIViewController *>*)setChildVC{
    
    __weak typeof (self) weakSelf = self;
    self.vcOne.pushBlock = ^(approvalModel *model) {
        ApprovalDetailViewController *approvalVC = [ApprovalDetailViewController new];
        approvalVC.ID = model.Id;
        approvalVC.mech_id = model.mech_id;
        approvalVC.seq_id = model.seq_id;
        approvalVC.type = 2;
        approvalVC.refreshBlock = ^(){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [weakSelf.vcOne siftingDataWithDic:dic];
            [weakSelf.vcTwo siftingDataWithDic:dic];
            [weakSelf.vcThree siftingDataWithDic:dic];
            [weakSelf.vcFour siftingDataWithDic:dic];
        };
        [weakSelf.navigationController pushViewController:approvalVC animated:YES];
    };
    
    self.vcTwo.pushBlock = ^(approvalModel *model) {
        ApprovalDetailViewController *approvalVC = [ApprovalDetailViewController new];
        approvalVC.type = 2;
        approvalVC.mech_id = model.mech_id;
        approvalVC.seq_id = model.seq_id;
        approvalVC.ID = model.Id;
        approvalVC.indexID = 2;
        approvalVC.refreshBlock = ^(){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [weakSelf.vcOne siftingDataWithDic:dic];
            [weakSelf.vcTwo siftingDataWithDic:dic];
            [weakSelf.vcThree siftingDataWithDic:dic];
            [weakSelf.vcFour siftingDataWithDic:dic];
        };
        [weakSelf.navigationController pushViewController:approvalVC animated:YES];
    };
    
    self.vcThree.pushBlock = ^(approvalModel *model) {
        ApprovalDetailViewController *approvalVC = [ApprovalDetailViewController new];
        approvalVC.type = 2;
        approvalVC.mech_id = model.mech_id;
        approvalVC.seq_id = model.seq_id;
        approvalVC.ID = model.Id;
        approvalVC.refreshBlock = ^(){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [weakSelf.vcOne siftingDataWithDic:dic];
            [weakSelf.vcTwo siftingDataWithDic:dic];
            [weakSelf.vcThree siftingDataWithDic:dic];
            [weakSelf.vcFour siftingDataWithDic:dic];
        };
        [weakSelf.navigationController pushViewController:approvalVC animated:YES];
    };
    
    self.vcFour.pushBlock = ^(approvalModel *model) {
        ApprovalDetailViewController *approvalVC = [ApprovalDetailViewController new];
        approvalVC.ID = model.Id;
        approvalVC.mech_id = model.mech_id;
        approvalVC.seq_id = model.seq_id;
        approvalVC.type = 2;
        approvalVC.refreshBlock = ^(){
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [weakSelf.vcOne siftingDataWithDic:dic];
            [weakSelf.vcTwo siftingDataWithDic:dic];
            [weakSelf.vcThree siftingDataWithDic:dic];
            [weakSelf.vcFour siftingDataWithDic:dic];
        };
        [weakSelf.navigationController pushViewController:approvalVC animated:YES];
    };
    
    NSArray *childVC = [NSArray arrayWithObjects:self.vcOne,self.vcTwo,self.vcThree,self.vcFour, nil];
    return childVC;
}

#pragma mark - getter
- (JohnTopTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[JohnTopTitleView alloc]initWithFrame:CGRectMake(0, NaviHeight, self.view.frame.size.width, kScreenHeight-NaviHeight)];
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批管理";
    UIBarButtonItem *rightOne = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sifting"] style:UIBarButtonItemStylePlain target:self action:@selector(siftingClick)];
    UIBarButtonItem *rightTwo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItems = @[rightTwo,rightOne];
    self.index = 0;
    [self createUI];
//    [self configNavigationBar];
//    [self initWithScrollView];
    // Do any additional setup after loading the view.
}


#pragma mark - UIScrollDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


- (void)siftingClick {
    
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.siftingView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
    } completion:^(BOOL finished) {
        weakSelf.siftingView.bgView.hidden = NO;
//        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    }];


}
- (void)addClick {
    
    approvalViewController *approvalVC = [approvalViewController new];
    approvalVC.refreshBlock = ^(){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [self.vcOne siftingDataWithDic:dic];
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
