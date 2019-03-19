//
//  CRMViewController.m
//  Financeteam
//
//  Created by Zccf on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMViewController.h"
#import "CRMTableViewCell.h"
#import "CRMListModel.h"
#import "CRMDetailsViewController.h"
#import "WorkBtn.h"
#import "CRMSearchViewController.h"
@interface CRMViewController ()<UITableViewDelegate,UITableViewDataSource>{
    LoginPeopleModel *myModel;
    NSMutableDictionary *personObjectDics;
}
@property (nonatomic)UITableView *CRMTableView;
@property (nonatomic, strong) NSMutableArray *requstDataArr;
@property (nonatomic, strong) NSString *isRefreshCRM;
@property (nonatomic, strong) UIView *stateView;
@property (nonatomic) WorkBtn *workBtn;
@property (nonatomic) NSInteger stateNum;

@property (nonatomic,assign) NSInteger page;
@end

@implementation CRMViewController
- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight)];
        _stateView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        NSArray *imageArr = [NSArray arrayWithObjects:@"公司",@"客户",@"已到访",@"邀约中",@"待处理",@"处理中", nil];
        NSArray *titleArr = [NSArray arrayWithObjects:@"公司放弃",@"客户放弃",@"已到访",@"邀约中",@"待处理",@"处理中", nil];
        UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(10*KAdaptiveRateWidth, kScreenHeight-160*KAdaptiveRateHeight, kScreenWidth-20*KAdaptiveRateWidth, 160*KAdaptiveRateHeight)];
        [vie.layer setCornerRadius:10];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        vie.center = _stateView.center;
        [_stateView addGestureRecognizer:tap];
        [_stateView addSubview:vie];
        vie.backgroundColor = [UIColor whiteColor];
        //循环创建出按钮
        for (int i = 0; i<imageArr.count; i++) {
            _workBtn = [[WorkBtn alloc]init];
            _workBtn.enabled = YES;
            _workBtn.showsTouchWhenHighlighted = YES;
            
            [_workBtn setHighlighted:YES];
            [vie addSubview:_workBtn];
            _workBtn.tag = i+1+1000;
            [_workBtn addTarget:self action:@selector(clickState:) forControlEvents:UIControlEventTouchUpInside];
            if (i<=6) {
                _workBtn.Image.image = [UIImage imageNamed:imageArr[i]];
            }
            _workBtn.Label.text = titleArr[i];
            _workBtn.layer.masksToBounds = YES;
            [_workBtn.layer setCornerRadius:10];
            [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(vie.mas_top).offset((i/3)*80*KAdaptiveRateHeight);
                make.left.equalTo(vie.mas_left).offset((i%3)*(kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                make.width.mas_equalTo((kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                make.height.mas_equalTo(80*KAdaptiveRateHeight);
            }];
            //竖着的分割线
            if (i % 3 == 1 || i%3 == 2) {
                UIView *HSeparetor = [[UIView alloc]init];
                [_workBtn addSubview:HSeparetor];
                HSeparetor.backgroundColor = kMyColor(240, 239, 245);
                [HSeparetor mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(vie.mas_top).offset((i/3)*80*KAdaptiveRateHeight);
                    make.left.equalTo(vie.mas_left).offset((i%3)*(kScreenWidth-20*KAdaptiveRateWidth)/3.0-0.5);
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(80*KAdaptiveRateHeight);
                }];
            }
            //横着的分割线
            if (i/3 == 1 || i/3 == 2 ) {
                UIView *VSeparetor = [[UIView alloc]init];
                [_workBtn addSubview:VSeparetor];
                VSeparetor.backgroundColor = kMyColor(240, 239, 245);
                [VSeparetor mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(vie.mas_top).offset((i/3)*80*KAdaptiveRateHeight - 0.5 );
                    make.left.equalTo(vie.mas_left).offset((i%3)*(kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                    make.width.mas_equalTo((kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                    make.height.mas_equalTo(1);
                }];
            }
        }
    }
    return _stateView;
}
- (void)tap:(UITapGestureRecognizer *)gr {
    CGPoint p = [gr locationInView:gr.view];
    if (p.y<kScreenHeight/2.0 - 80*KAdaptiveRateHeight ||p.y>kScreenHeight/2.0 + 80*KAdaptiveRateHeight) {
        [self.stateView removeFromSuperview];
    }
}
- (void)clickState:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
        {
            self.stateNum = 1;
        }
            break;
        case 1002:
        {
            self.stateNum = 2;
        }
            break;
        case 1003:
        {
            self.stateNum = 3;
        }
            break;
        case 1004:
        {
            self.stateNum = 4;
        }
            break;
        case 1005:
        {
            self.stateNum = 5;
        }
            break;
        case 1006:
        {
            self.stateNum = 6;
        }
            break;
    }
    [self.stateView removeFromSuperview];
    [self.CRMTableView reloadData];
}
- (UITableView *)CRMTableView {
    if (!_CRMTableView) {
        _CRMTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
        _CRMTableView.delegate = self;
        _CRMTableView.dataSource = self;
        
        [_CRMTableView registerClass:[CRMTableViewCell class] forCellReuseIdentifier:@"cell"];
        
        _CRMTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self requestDataWithUid:[NSString stringWithFormat:@"%ld",myModel.userId]];
            [self.CRMTableView.footer resetNoMoreData];
        }];
        _CRMTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page += 1;
            [self requestDataWithUid:[NSString stringWithFormat:@"%ld",myModel.userId]];
            
        }];
        
    }
    return _CRMTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.isRefreshCRM isEqualToString:@"1"]) {
        [self.CRMTableView.header beginRefreshing];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0, 80, 80) imageName:@"noData" title:@"暂无CRM信息!"];
    [self.CRMTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
    [self initUIs];//加载view
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAdd)];
    UIBarButtonItem *two = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"搜索(1)"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick:)];
    self.navigationItem.rightBarButtonItems = @[one,two];
    
    // Do any additional setup after loading the view.
}
- (void)searchBtnClick:(UIButton *)btn {

   // [self.navigationController.view addSubview:self.stateView];
    CRMSearchViewController * crmSearchVC = [[CRMSearchViewController alloc]init];
    [crmSearchVC returnMutableDictionary:^(NSMutableDictionary *returnMutableDictionary) {
        
        if (returnMutableDictionary != nil) {
            
            self.CRMTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                self.page = 0;
                [self requestCRMListWith:returnMutableDictionary];
            }];
            self.CRMTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                self.page += 1;
                [self requestCRMListWith:returnMutableDictionary];
                
            }];
            [self.CRMTableView.header beginRefreshing];
            
        }
    }];
    [self.navigationController pushViewController:crmSearchVC animated:YES];
    
}
- (void)requestCRMListWith:(NSMutableDictionary *)dic {
    NSLog(@"dic == %@",dic);

    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    dic[@"page"] = page;
    dic[@"rows"] = @"10";
    [HttpRequestEngine getCRMListWithDic:dic completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            if ([(NSMutableArray *)obj count]>0) {
                if (self.page == 0) {
                    [self.requstDataArr removeAllObjects];
                    if ([(NSMutableArray *)obj count]<10) {
                        [self.CRMTableView.footer noticeNoMoreData];
                    }
                }
                NSArray *dataArr = (NSArray *)obj;
                [self.requstDataArr addObjectsFromArray:dataArr];
                
                if (self.requstDataArr.count == 0) {
                    self.blankV.hidden = NO;
                } else {
                    self.blankV.hidden = YES;
                }
                [self.CRMTableView.header endRefreshing];
                [self.CRMTableView.footer endRefreshing];
                
                [self.CRMTableView reloadData];
            }else{
                
                if (self.page == 0) {
                    [self.requstDataArr removeAllObjects];
                }
                
                [self.CRMTableView.header endRefreshing];
                [self.CRMTableView.footer endRefreshing];
                [self.CRMTableView.footer noticeNoMoreData];
                [self.CRMTableView reloadData];
                if (self.requstDataArr.count == 0) {
                    self.blankV.hidden = NO;
                } else {
                    self.blankV.hidden = YES;
                }
            }
            [MBProgressHUD hideHUDForView:self.navigationController.view];
        } else {
            self.blankV.hidden = NO;
            [MBProgressHUD hideHUDForView:self.navigationController.view];
            [MBProgressHUD showError:errorStr];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.isRefreshCRM = @"0";
}
//加载view
- (void)initUIs {
    self.navigationItem.title = @"客户";
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.view addSubview:self.CRMTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.CRMTableView setTableFooterView:view];
    self.requstDataArr = [NSMutableArray array];
    self.CRMTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [MBProgressHUD showMessage:@"正在加载..." toView:self.navigationController.view];
    [self requestDataWithUid:[NSString stringWithFormat:@"%ld",myModel.userId]];
    
}
//请求数据
- (void)requestDataWithUid:(NSString *)uid {
    
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    
    [HttpRequestEngine getCRMListWithUid:uid page:page completion:^(id obj, NSString *errorStr) {
        
        if (errorStr == nil) {
            if ([(NSMutableArray *)obj count]>0) {
                if (self.page == 0) {
                    [self.requstDataArr removeAllObjects];
                }
                NSArray *dataArr = (NSArray *)obj;
                [self.requstDataArr addObjectsFromArray:dataArr];
                
                if (self.requstDataArr.count == 0) {
                    self.blankV.hidden = NO;
                } else {
                    self.blankV.hidden = YES;
                }
                [self.CRMTableView.header endRefreshing];
                [self.CRMTableView.footer endRefreshing];
                if (dataArr.count < 10 ) {
                    [self.CRMTableView.footer noticeNoMoreData];
                }
                [self.CRMTableView reloadData];
            }else{
                
                if (self.page == 0) {
                    [self.requstDataArr removeAllObjects];
                }
                
                [self.CRMTableView.header endRefreshing];
                [self.CRMTableView.footer endRefreshing];
                [self.CRMTableView.footer noticeNoMoreData];
                [self.CRMTableView reloadData];
                if (self.requstDataArr.count == 0) {
                    self.blankV.hidden = NO;
                } else {
                    self.blankV.hidden = YES;
                }
            }
            [MBProgressHUD hideHUDForView:self.navigationController.view];
        } else {
            self.blankV.hidden = NO;
            [MBProgressHUD hideHUDForView:self.navigationController.view];
            [MBProgressHUD showError:errorStr];
        }
    }];
}

#pragma mark -- 点击事件
- (void)ClickAdd {
    if (self.isAddCRM) {
        CRMDetailsViewController *details = [CRMDetailsViewController new];
        details.seType = 2;
        [details returnIsRefreshCRM:^(NSString *returnIsRefrshCRM) {
            self.isRefreshCRM = returnIsRefrshCRM;
        }];
        details.customerId = [NSString stringWithFormat:@"%ld",myModel.userId];
        [self.navigationController pushViewController:details animated:YES];
    } else {
        [MBProgressHUD showError:@"暂无此权限"];
    }
    
}

#pragma mark -- tableview 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.stateNum) {
        case 1:
        {
            NSMutableArray *arr = [personObjectDics objectForKey:@"5"];
            
            if (arr.count == 0) {
//                [MBProgressHUD showError:@"没有该状态的客户"];
            }
            return arr.count;
        }
            break;
        case 2:
        {
            NSMutableArray *arr = [personObjectDics objectForKey:@"6"];
            
            if (arr.count == 0) {
//                [MBProgressHUD showError:@"没有该状态的客户"];
            }
            return arr.count;
        }
            break;
        case 3:
        {
            NSMutableArray *arr = [personObjectDics objectForKey:@"3"];
            
            if (arr.count == 0) {
//                [MBProgressHUD showError:@"没有该状态的客户"];
            }
            return arr.count;
        }
            break;
        case 4:
        {
            NSMutableArray *arr = [personObjectDics objectForKey:@"2"];
            
            if (arr.count == 0) {
//                [MBProgressHUD showError:@"没有该状态的客户"];
            }
            return arr.count;
        }
            break;
        case 5:
        {
            NSMutableArray *arr = [personObjectDics objectForKey:@"1"];
            
            if (arr.count == 0) {
//                [MBProgressHUD showError:@"没有该状态的客户"];
            }
            return arr.count;
        }
            break;
        case 6:
        {
            NSMutableArray *arr = [personObjectDics objectForKey:@"4"];
            if (arr.count == 0) {
//                [MBProgressHUD showError:@"没有该状态的客户"];
            }
            return arr.count;
        }
            break;
        default:
        {
//            for (UILabel *hehe in [self.view subviews]){
//                [hehe removeFromSuperview];
//            }
            return self.requstDataArr.count;
        }
            break;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
    view.backgroundColor = VIEW_BASE_COLOR;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[CRMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (self.stateNum == 1) {
        NSMutableArray *arr = [personObjectDics objectForKey:@"5"];
        CRMListModel *model = arr[indexPath.section];
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"green"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"red"];
        }
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
             cell.nameLB.text = [model.user_name substringToIndex:3];
        }
//        if ([self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] || [self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = NO;
//        } else {
//            cell.signLB.hidden = YES;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = model.real_name;
        cell.statusLB.text = [NSString stringWithFormat:@"公司放弃"];
        cell.statusLB.textColor = kMyColor(54, 120, 163);
        cell.createTimeLB.text = model.createTime;
    } else if (self.stateNum ==2) {
        NSMutableArray *arr = [personObjectDics objectForKey:@"6"];
        CRMListModel *model = arr[indexPath.section];
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"男头像(2)"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"女"];
        }
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
            cell.nameLB.text = [model.user_name substringToIndex:3];
        }
//        if (![self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] && ![self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = YES;
//        } else {
//            cell.signLB.hidden = NO;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = model.real_name;
        cell.statusLB.text = [NSString stringWithFormat:@"客户放弃"];
        cell.statusLB.textColor = kMyColor(149, 91, 165);
        cell.createTimeLB.text = model.createTime;
    } else if (self.stateNum == 3) {
        NSMutableArray *arr = [personObjectDics objectForKey:@"3"];
        CRMListModel *model = arr[indexPath.section];
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"男头像(2)"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"女"];
        }
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
            cell.nameLB.text = [model.user_name substringToIndex:3];
        }
//        if (![self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] && ![self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = YES;
//        } else {
//            cell.signLB.hidden = NO;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = model.real_name;
        cell.statusLB.text = [NSString stringWithFormat:@"已到访"];
        cell.statusLB.textColor = kMyColor(14, 175, 230);
        cell.createTimeLB.text = model.createTime;
    } else if (self.stateNum == 4) {
        NSMutableArray *arr = [personObjectDics objectForKey:@"2"];
        CRMListModel *model = arr[indexPath.section];
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"男头像(2)"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"女"];
        }
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
            cell.nameLB.text = [model.user_name substringToIndex:3];
        }
//        if (![self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] && ![self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = YES;
//        } else {
//            cell.signLB.hidden = NO;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = model.real_name;
        cell.statusLB.text = [NSString stringWithFormat:@"邀约中"];
        cell.statusLB.textColor = kMyColor(59, 95, 46);
        cell.createTimeLB.text = model.createTime;
    } else if (self.stateNum == 5) {
        NSMutableArray *arr = [personObjectDics objectForKey:@"1"];
        CRMListModel *model = arr[indexPath.section];
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"男头像(2)"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"女"];
        }
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
            cell.nameLB.text = [model.user_name substringToIndex:4];
        }
//        if (![self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] && ![self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = YES;
//        } else {
//            cell.signLB.hidden = NO;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = model.real_name;
        cell.statusLB.text = [NSString stringWithFormat:@"待处理"];
        cell.statusLB.textColor = kMyColor(249, 105, 8);
        cell.createTimeLB.text = model.createTime;
    } else if (self.stateNum == 6) {
        NSMutableArray *arr = [personObjectDics objectForKey:@"4"];
        CRMListModel *model = arr[indexPath.section];
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"男头像(2)"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"女"];
        }
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
            cell.nameLB.text = [model.user_name substringToIndex:3];
        }
//        if (![self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] && ![self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = YES;
//        } else {
//            cell.signLB.hidden = NO;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = model.real_name;
        cell.statusLB.text = [NSString stringWithFormat:@"办理中"];
        cell.statusLB.textColor = kMyColor(249, 105, 150);
        cell.createTimeLB.text = model.createTime;
    } else {
        CRMListModel *model = self.requstDataArr[indexPath.section];
        if ([self.myUser_Id isEqualToString:model.adviserId]) {
            if ([model.systemAllocation isEqualToString:@"1"]) {
                cell.systemAllocationLB.hidden = NO;
                cell.systemAllocationLB.text = @"-- 系统分配";
            } else {
                cell.systemAllocationLB.hidden = YES;
            }
        } else {
            cell.systemAllocationLB.hidden = YES;
        }
        if (model.user_sex == 1) {
            cell.headerImage.image = [UIImage imageNamed:@"green"];
        } else if (model.user_sex == 2) {
            cell.headerImage.image = [UIImage imageNamed:@"red"];
        }
        cell.nameLB.text = model.user_name;
        if (model.user_name.length > 4) {
            cell.nameLB.text = [model.user_name substringToIndex:3];
        }
//        if (![self.myUser_Id isEqualToString:[NSString stringWithFormat:@"%ld",model.createPsId]] && ![self.myUser_Id isEqualToString:model.adviserId]) {
//            cell.signLB.hidden = YES;
//        } else {
//            cell.signLB.hidden = NO;
//        }
        switch ([model.userSign integerValue]) {
            case 1:
                cell.signLB.text = @"★";
                break;
            case 2:
                cell.signLB.text = @"★★";
                break;
            case 3:
                cell.signLB.text = @"★★★";
                break;
            case 4:
                cell.signLB.text = @"★★★★";
                break;
            case 5:
                cell.signLB.text = @"★★★★★";
                break;
            case 6:
                cell.signLB.text = @"放弃";
                break;
            default:
                cell.signLB.text = @"";
                break;
        }
        cell.mobilLB.text = model.user_mobile;
        cell.realNameLB.text = [NSString stringWithFormat:@"创建人: %@",model.real_name];
        
        switch ([model.state integerValue]) {
            case 1:
                cell.statusLB.text = [NSString stringWithFormat:@"待处理"];
                cell.statusLB.textColor = kMyColor(249, 105, 8);
                break;
            case 2:
                cell.statusLB.text = [NSString stringWithFormat:@"邀约中"];
                cell.statusLB.textColor = kMyColor(59, 95, 46);
                break;
            case 3:
                cell.statusLB.text = [NSString stringWithFormat:@"已到访"];
                cell.statusLB.textColor = kMyColor(14, 175, 230);
                break;
            case 4:
                cell.statusLB.text = [NSString stringWithFormat:@"办理中"];
                cell.statusLB.textColor = kMyColor(249, 105, 150);
                break;
            case 5:
                cell.statusLB.text = [NSString stringWithFormat:@"公司放弃"];
                cell.statusLB.textColor = kMyColor(54, 120, 163);
                break;
            case 6:
                cell.statusLB.text = [NSString stringWithFormat:@"客户放弃"];
                cell.statusLB.textColor = kMyColor(149, 91, 165);
                break;
        }
        cell.createTimeLB.text = model.createTime;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CRMListModel *model = self.requstDataArr[indexPath.section];
    CRMDetailsViewController *details = [CRMDetailsViewController new];
    [details returnIsRefreshCRM:^(NSString *returnIsRefrshCRM) {
        self.isRefreshCRM = returnIsRefrshCRM;
    }];
    details.returnStateBlock = ^(NSString *CRMState) {
        model.state = CRMState;
        [tableView reloadData];
    };
    details.returnStarBlock = ^(NSString *CRMStar) {
        model.userSign = CRMStar;
        [tableView reloadData];
    };
    details.CRMListModelBlock = ^(CRMListModel *CRMListModel) {
        model.user_name = CRMListModel.user_name;
        model.user_mobile = CRMListModel.user_mobile;
        [tableView reloadData];
    };
    details.createPsId = [NSString stringWithFormat:@"%ld",model.createPsId];
    details.adviserId = [NSString stringWithFormat:@"%@",model.adviserId];
    details.iconURL = model.icon;
    details.customerId = model.ID;
    details.userSign = model.userSign;
    details.isUpdateCRM = self.isUpdateCRM;
    details.isDelCRM = self.isDeleteCRM;
    details.isChangeState = self.isChangeStateCRM;
    details.isCreateOrderCRM = self.isCreateOrderCRM;
    details.seType = 1;
    [self.navigationController pushViewController:details animated:YES];
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
