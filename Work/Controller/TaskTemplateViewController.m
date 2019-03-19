//
//  TaskTemplateViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "TaskTemplateViewController.h"
#import "LoginPeopleModel.h"
#import "CreatTaskViewController.h"
@interface TaskTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>{
    LoginPeopleModel *loginModel;
}

@property (nonatomic, strong) UITableView *taskTableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSString *isTask;
@end

@implementation TaskTemplateViewController
- (UITableView *)taskTableView {
    if (!_taskTableView) {
        _taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight)];
    }
    return _taskTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskTableView.delegate = self;
    self.taskTableView.dataSource = self;
    [self.view addSubview:self.taskTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.taskTableView setTableFooterView:view];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    self.navigationItem.title = @"任务模版";
    self.view.backgroundColor = VIEW_BASE_COLOR;
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
//    self.navigationItem.leftBarButtonItem = left;
    self.titleArr = [NSArray arrayWithObjects:@"普通任务",@"CRM任务",@"销售任务", nil];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}
#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        return 3;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*KAdaptiveRateHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CreatTaskViewController *CreatTask = [CreatTaskViewController new];
        CreatTask.seType = 1;
        [CreatTask returnIsRefreshTask:^(NSString *returnIsRefrshTask) {
            self.isTask = returnIsRefrshTask;
        }];
        [self.navigationController pushViewController:CreatTask animated:YES];
    } else if (indexPath.row == 1) {
        CreatTaskViewController *CreatTask = [CreatTaskViewController new];
        CreatTask.seType = 2;
        [CreatTask returnIsRefreshTask:^(NSString *returnIsRefrshTask) {
            self.isTask = returnIsRefrshTask;
        }];
        [self.navigationController pushViewController:CreatTask animated:YES];
    } else if (indexPath.row == 2) {
        CreatTaskViewController *CreatTask = [CreatTaskViewController new];
        CreatTask.seType = 3;
        [CreatTask returnIsRefreshTask:^(NSString *returnIsRefrshTask) {
            self.isTask = returnIsRefrshTask;
        }];
        [self.navigationController pushViewController:CreatTask animated:YES];
    }
}
#pragma mark -- 点击事件
- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    if (self.isRefreshTask != nil) {
        self.isRefreshTask(self.isTask);
    }
}
//实现returnMutableArray 方法
- (void)returnIsRefreshTask:(ReturnIsRefreshTaskBlock)block {
    self.isRefreshTask = block;
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
