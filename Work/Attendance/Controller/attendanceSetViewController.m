//
//  attendanceSetViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/7.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceSetViewController.h"
#import "attendanceSetTableViewCell.h"
#import "signInViewController.h"
#import "attendanceMachineSetViewController.h"
#import "calendarViewController.h"
@interface attendanceSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *setTableView;
@end

@implementation attendanceSetViewController
- (UITableView *)setTableView {
    if (!_setTableView) {
        _setTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.tableFooterView = [UIView new];
        _setTableView.backgroundColor = GRAY245;
        [_setTableView registerClass:[attendanceSetTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _setTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤设置";
    [self.view addSubview:self.setTableView];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    vi.backgroundColor = GRAY245;
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    attendanceSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            cell.titleLB.text = @"考勤日期管理";
            cell.signLB.text = @"自定义工作日、休息日";
        }
            break;
        case 1:
        {
            cell.titleLB.text = @"签到管理";
            cell.signLB.text = @"设置签到时间、迟到规则等";
        }
            break;
        case 2:
        {
            cell.titleLB.text = @"考勤机设置";
            cell.signLB.text = @"考勤机与企业进行绑定设置";
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        calendarViewController *calendar = [calendarViewController new];
        [self.navigationController pushViewController:calendar animated:YES];
    } else if (indexPath.section == 1) {
        signInViewController *sign = [signInViewController new];
        [self.navigationController pushViewController:sign animated:YES];
    } else if (indexPath.section == 2) {
        attendanceMachineSetViewController *machine = [attendanceMachineSetViewController new];
        [self.navigationController pushViewController:machine animated:YES];
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
