//
//  OrderViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderBottomView.h"

#import "MyOrderViewController.h"
#import "ApproveOrderViewController.h"

#import "SeniorSearchViewController.h"
@interface OrderViewController ()<OrderBottomViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)OrderBottomView * orderBottomView;

@property(nonatomic,strong)UIScrollView * mainScrollView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    
}

-(void)creatUI{
    
    self.navigationItem.title = @"订单管理";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
//    self.navigationItem.leftBarButtonItem = left;
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"高级搜索" style:UIBarButtonItemStylePlain target:self action:@selector(SearchOnClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.orderBottomView = [[OrderBottomView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    if (IS_IPHONE_X) {
        self.orderBottomView.frame = CGRectMake(0, kScreenHeight-74, kScreenWidth, 50);
    }
    self.orderBottomView.titleArray = @[@"我的订单",@"审批订单"];
    self.orderBottomView.delegate = self;
    [self.view addSubview:self.orderBottomView];
    
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-50)];
    
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.scrollEnabled = NO;
    //设置内容视图的大小
    _mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, kScreenHeight-NaviHeight-50);
    if (IS_IPHONE_X) {
        _mainScrollView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-74);
        _mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, kScreenHeight-NaviHeight-74);
    }
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    _mainScrollView.delegate = self;
    
    [self.view addSubview:_mainScrollView];
    
    [self addChildVC];
    
}

-(void)addChildVC{
    
    MyOrderViewController * myOrderVC = [[MyOrderViewController alloc]init];
    myOrderVC.ispush = self.ispush;
    ApproveOrderViewController * approveOrderVC = [[ApproveOrderViewController alloc]init];
    
    myOrderVC.view.backgroundColor = [UIColor whiteColor];
    approveOrderVC.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:myOrderVC];
    [self addChildViewController:approveOrderVC];
    //更改frame
    myOrderVC.view.frame = CGRectMake(0, 0, kScreenWidth, _mainScrollView.frame.size.height);
    approveOrderVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, _mainScrollView.frame.size.height);
    
    [_mainScrollView addSubview:myOrderVC.view];
    [_mainScrollView addSubview:approveOrderVC.view];

    if (self.page == 1) {
        
        [self clickButton:self.page];

        
        UIButton *btn2 = [self.orderBottomView viewWithTag:101];
        [self.orderBottomView BtnONClick:btn2];

    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.mainScrollView) {
        //contentOffset 偏移量
        NSInteger  page = scrollView.contentOffset.x/kScreenWidth;
        [self.orderBottomView resetBtnStatus:page+100];
    }
}

-(void)clickButton:(NSInteger)page{
    
    [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth *page, 0) animated:NO];

}


-(void)GoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SearchOnClick{
    CGFloat width = [self.mainScrollView contentOffset].x;
    SeniorSearchViewController * seniorSearchVC = [[SeniorSearchViewController alloc]init];
    NSLog(@"width == %f",width);
    if (width == 0.0) {
        seniorSearchVC.seType = 0;
        [seniorSearchVC returnSearchList:^(NSDictionary *returnSearchDic) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:returnSearchDic forKey:@"searchMine"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchMine" object:self userInfo:dic];
//            if (returnSearchList.count != 0) {
//                
//            }
        }];
    } else {
        seniorSearchVC.seType = 1;
        [seniorSearchVC returnSearchList:^(NSDictionary *returnSearchDic) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:returnSearchDic forKey:@"searchShenPi"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchShenPi" object:self userInfo:dic];
//            if (returnSearchList.count != 0) {
//                
//            }
        }];
    }
    
    [self.navigationController pushViewController:seniorSearchVC animated:YES];
    
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
