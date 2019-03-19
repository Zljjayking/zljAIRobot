//
//  PayViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/27.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "PayViewController.h"
#import "employeePayTableViewCell.h"
#import "payGroupViewController.h"
#import "payGroupModel.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *payTableView;
@property (nonatomic) LoginPeopleModel *loginModel;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic) NSString *performance;//组名用于搜索

@property (nonatomic) NSMutableArray *dataArr;
@end

@implementation PayViewController
- (UITableView *)payTableView {
    if (!_payTableView) {
        _payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_payTableView registerClass:[employeePayTableViewCell class] forCellReuseIdentifier:@"cell"];
        _payTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self requestData];
        }];
        _payTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [self requestData];
        }];
        _payTableView.backgroundColor = VIEW_BASE_COLOR;
        _payTableView.tableFooterView = [UIView new];
    }
    return _payTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"薪资组";
    [self.view addSubview:self.payTableView];
    self.dataArr = [NSMutableArray array];
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无薪资组数据"];
    [self.payTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.page = 0;
    [self requestData];
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPayGroup)];
    self.navigationItem.rightBarButtonItem = one;
    // Do any additional setup after loading the view.
}
- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (![Utils isBlankString:self.performance]) {
        dic[@"performance"] = self.performance;
    }
    dic[@"inter"] = @"queryPerformance";
    dic[@"mech_id"] = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    dic[@"page"] = [NSString stringWithFormat:@"%ld",self.page];
    dic[@"rows"] = @"10";
    [HttpRequestEngine getPayGroupWithDic:dic completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            [self.payTableView.header endRefreshing];
            [self.payTableView.footer endRefreshing];
            
            if (self.page == 0) {
                [self.dataArr removeAllObjects];
            }
            NSArray *data = (NSArray *)obj;
            for (NSDictionary *dic in data) {
                payGroupModel *model = [payGroupModel requestWithDic:dic];
                [self.dataArr addObject:model];
            }
            if (data.count<10) {
                [self.payTableView.footer noticeNoMoreData];
            }
            if (self.dataArr.count == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
            [self.payTableView reloadData];
            
        } else {
            if (self.page == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
            [self.payTableView.header endRefreshing];
            [self.payTableView.footer endRefreshing];
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    employeePayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    payGroupModel *model = self.dataArr[indexPath.row];
    cell.nameLB.text = model.performance;;
    cell.perNumLB.text = [NSString stringWithFormat:@"%@人",model.perNum];
    cell.basePayLB.text = [NSString stringWithFormat:@"基础薪资:%@元",model.salary];
    cell.TiChengLB.text = [NSString stringWithFormat:@"提成方式:按%@提成",model.commission];
    
    if ([model.commission isEqualToString:@"件"]) {
        cell.signView.backgroundColor = kMyColor(44, 244, 243);
    } else if ([model.commission isEqualToString:@"量"]) {
        cell.signView.backgroundColor = kMyColor(253, 159, 42);
    } else if ([model.commission isEqualToString:@"服务费"]) {
        cell.signView.backgroundColor = kMyColor(241, 45, 114);
    } else {
        cell.signView.backgroundColor = kMyColor(201, 145, 114);
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*KAdaptiveRateWidth+60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    payGroupViewController *payGroup = [payGroupViewController new];
    payGroupModel *model = self.dataArr[indexPath.row];
    payGroup.Id = model.Id;
    payGroup.type = 1;
    payGroup.Block = ^(){
        [self.payTableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:payGroup animated:YES];
}
- (void)ClickAddPayGroup {
    payGroupViewController *payGroup = [payGroupViewController new];
    payGroup.type = 0;
    payGroup.Block = ^(){
        [self.payTableView.header beginRefreshing];
    };
    [self.navigationController pushViewController:payGroup animated:YES];
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
