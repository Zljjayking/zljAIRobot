//
//  DYVCSegmentOne.m
//  DYScrollSegmentDemo
//
//  Created by Daniel Yao on 17/4/10.
//  Copyright © 2017年 Daniel Yao. All rights reserved.
//

#import "DYVCSegmentOne.h"
#import "HttpRequestEngine.h"
#import "LoginPeopleModel.h"
#import "approvalTableViewCell.h"
@interface DYVCSegmentOne ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) LoginPeopleModel *loginModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableDictionary *requestDic;
@end

@implementation DYVCSegmentOne
- (void)siftingDataWithDic:(NSMutableDictionary *)dic {
    
    [self.requestDic removeAllObjects];
    self.requestDic[@"inter"] = @"queryMyApproval";
    self.requestDic[@"rows"] = @"10";
    self.requestDic[@"user_id"] = @(self.loginModel.userId);
    
    [self.requestDic addEntriesFromDictionary:dic];
    
    [self.tableView.header beginRefreshing];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight-40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[approvalTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self.tableView.footer resetNoMoreData];
            [self requestDataWithDic:self.requestDic];
            
        }];
        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [self requestDataWithDic:self.requestDic];
        }];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BASE_COLOR;
    [self.view addSubview:self.tableView];
    self.loginModel = [[LoginPeopleModel alloc] initWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.page = 0;
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-40, 80, 80) imageName:@"noData" title:@"暂无我提交的数据"];
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    self.requestDic= [NSMutableDictionary dictionaryWithCapacity:0];
    self.requestDic[@"inter"] = @"queryMyApproval";
    self.requestDic[@"rows"] = @"10";
    self.requestDic[@"user_id"] = @(self.loginModel.userId);
//    [MBProgressHUD showMessage:@"正在加载..."];
    [self requestDataWithDic:self.requestDic];
    // Do any additional setup after loading the view.
}

- (void)requestDataWithDic:(NSMutableDictionary *)dic {
    dic[@"page"] = @(self.page);
    
    [HttpRequestEngine getMyPutApprovalWithDic:dic completion:^(id obj, NSString *errorStr) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([Utils isBlankString:errorStr]) {
            NSArray *data = (NSArray *)obj;
            
            if (data.count == 0) {
                if (self.page == 0) {
                    self.blankV.hidden = NO;
                    [self.dataArr removeAllObjects];
                }
                
            } else {
                self.blankV.hidden = YES;
                if (self.page == 0) {
                    [self.dataArr removeAllObjects];
                }
                for (NSDictionary *dic in data) {
                    approvalModel *model = [approvalModel requestWithDic:dic];
                    [self.dataArr addObject:model];
                }
                
            }
            if (data.count<10) {
                [self.tableView.footer noticeNoMoreData];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    approvalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[approvalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    approvalModel *model = self.dataArr[indexPath.row];
    [cell.headImage sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
    cell.nameLb.text = model.nick_name;
    cell.typeLb.text = model.application_name;
    cell.stateLb.text = model.state_type;
    if ([model.state_type isEqualToString:@"未提交"] || [model.state_type isEqualToString:@"撤回"]) {
        cell.stateLb.textColor = UIColorFromRGB(0xfa4a4a4,1);
    } else if ([model.state_type isEqualToString:@"驳回"]){
        cell.stateLb.textColor = UIColorFromRGB(0xfFF0000,1);
    } else if ([model.state_type isEqualToString:@"审批通过"]) {
        cell.stateLb.textColor = UIColorFromRGB(0xf2aa515,1);
    } else {
        cell.stateLb.textColor = UIColorFromRGB(0xf4E9CF0,1);
    }
    cell.timeLb.text = model.create_time;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    approvalModel *model = self.dataArr[indexPath.row];
    self.pushBlock(model);
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
