//
//  approvalHistoryViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalHistoryViewController.h"
#import "approvalHistoryTableViewCell.h"
#import "approvalHistoryModel.h"
@interface approvalHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *historyTabelView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation approvalHistoryViewController
- (UITableView *)historyTabelView {
    if (!_historyTabelView) {
        _historyTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        [_historyTabelView registerClass:[approvalHistoryTableViewCell class] forCellReuseIdentifier:@"cell"];
        _historyTabelView.delegate = self;
        _historyTabelView.dataSource = self;
        _historyTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _historyTabelView.tableFooterView = [UIView new];
        _historyTabelView.backgroundColor = [UIColor clearColor];
    }
    return _historyTabelView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"审批记录";
    self.view.backgroundColor = TABBAR_BASE_COLOR;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(25, NaviHeight, 2, kScreenHeight)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    [self.view addSubview:self.historyTabelView];
//    self.dataArr = [NSMutableArray arrayWithCapacity:0];
//    [self requestHistory];
    // Do any additional setup after loading the view.
}
- (void)requestHistory {
    [HttpRequestEngine getApprovalHistoryWithID:self.ID mech_id:self.mech_ID completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *arr = (NSArray *)obj;
            for (NSDictionary *dic in arr) {
                approvalHistoryModel *model = [approvalHistoryModel requestWithDic:dic];
                
                [self.dataArr addObject:model];
            }
            [self.historyTabelView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    approvalHistoryModel *mdoel = self.dataArr[indexPath.row];
    NSString *reason = [NSString stringWithFormat:@"%@",mdoel.reason];
    
    CGFloat height = 151+ [reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-87.5];
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    approvalHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[approvalHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    approvalHistoryModel *model = self.historyArr[indexPath.row];
    if ([model.state_type isEqualToString:@"4"]) {
        cell.stateImage.image = [UIImage imageNamed:@"approvalRejectYuan"];
        cell.signImage.image = [UIImage imageNamed:@"approvalReject"];
    } else {//if ([model.state_type isEqualToString:@"5"])
        cell.stateImage.image = [UIImage imageNamed:@"approvedYuan"];
        cell.signImage.image = [UIImage imageNamed:@"approved"];
    }
    
    cell.timeLB.text = model.create_time;
    [cell.headerImage sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
    cell.nameLB.text = model.approvalName;
    cell.signLB.text = model.reason;
    
    
    return cell;
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
