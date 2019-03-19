//
//  approvalFlowViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/15.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "approvalFlowViewController.h"

#import "addApprovalPeopleTableViewCell.h"
#import "approvalPeopleTableViewCell.h"
#import "approvalFlowTableViewCell.h"

#import "ContactModel.h"
#import "chooseViewController.h"
@interface approvalFlowViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *approvalFlowTableView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *peopleArr;
@property (nonatomic, strong) NSMutableArray *flowMutableArr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *IdStr;
@property (nonatomic, strong) LoginPeopleModel *loginModel;
@end

@implementation approvalFlowViewController
- (UITableView *)approvalFlowTableView {
    if (!_approvalFlowTableView) {
        _approvalFlowTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, NaviHeight+10, kScreenWidth-20, kScreenHeight-NaviHeight-20) style:UITableViewStylePlain];
        _approvalFlowTableView.delegate = self;
        _approvalFlowTableView.dataSource = self;
        _approvalFlowTableView.tableFooterView = [UIView new];
        _approvalFlowTableView.layer.cornerRadius = 10;
        _approvalFlowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_approvalFlowTableView registerClass:[addApprovalPeopleTableViewCell class] forCellReuseIdentifier:@"add"];
        [_approvalFlowTableView registerClass:[approvalFlowTableViewCell class] forCellReuseIdentifier:@"flow"];
        [_approvalFlowTableView registerClass:[approvalPeopleTableViewCell class] forCellReuseIdentifier:@"people"];
    }
    return _approvalFlowTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABBAR_BASE_COLOR;
    [self.view addSubview:self.approvalFlowTableView];
    self.count = 0;
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    if (self.type == 1) {
        self.flowMutableArr = [NSMutableArray arrayWithCapacity:0];
        
        [self requestFlowArr];
        
        self.title = @"审批流程";
        self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-50, self.view.center.y/2.0-40, 80, 80) imageName:@"noData" title:@"暂无审批流请添加"];
        [self.approvalFlowTableView addSubview:self.blankV];
        self.blankV.hidden = YES;
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(addFlow)];
        self.navigationItem.rightBarButtonItem = right;
    } else {
        self.peopleArr = [NSMutableArray arrayWithCapacity:0];
        self.count = self.peopleArr.count + 1;
        self.title = @"选择审批人员";
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(clickComplete)];
        self.navigationItem.rightBarButtonItem = right;
    }
    
    
    // Do any additional setup after loading the view.
}
- (void)requestFlowArr {
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    NSString *user_id = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
    NSString *page = @"0";
    NSString *rows = @"1000";
    NSDictionary *dic = @{@"inter":@"queryflow",@"application_id":self.application_id,@"mech_id":mech_id,@"user_id":user_id,@"page":page,@"rows":rows};
    
    [HttpRequestEngine getApprovalFlowWithDic:dic completion:^(id obj, NSString *errorStr) {
        
        if ([Utils isBlankString:errorStr]) {
            [self.flowMutableArr removeAllObjects];
            [self.flowMutableArr addObjectsFromArray:(NSArray *)obj];
            self.count = self.flowMutableArr.count;
            if (self.count>0) {
                self.blankV.hidden = YES;
            } else {
                self.blankV.hidden = NO;
            }
            [self.approvalFlowTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        NSDictionary *dic = self.flowMutableArr[indexPath.row];
        NSString *nameStr = dic[@"user_name"];
        CGFloat rowHeight = [nameStr heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-100];
        
        return rowHeight > 60 ? rowHeight:60;
    }
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (self.type == 1) {
        
        approvalFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flow"];
        if (cell == nil) {
            cell = [[approvalFlowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"flow"];
        }
        NSDictionary *dic = self.flowMutableArr[indexPath.row];
        cell.nameLB.text = [NSString stringWithFormat:@"%@",dic[@"user_name"]];
        cell.numberLB.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        NSString *flowId = [NSString stringWithFormat:@"%@",dic[@"flowId"]];
        if ([self.flow_id isEqualToString:flowId]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;

    } else {
        if (indexPath.row == self.count-1) {
            addApprovalPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add"];
            if (cell == nil) {
                cell = [[addApprovalPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"add"];
            }
            return cell;
        } else {
            approvalPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people"];
            if (cell == nil) {
                cell = [[approvalPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
            }
            ContactModel *model = self.peopleArr[indexPath.row];
            cell.orderLB.text = [NSString stringWithFormat:@"第%ld经办人",indexPath.row+1];
//            cell.numberLB.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            cell.nameLB.text = model.realName;
            [cell.headerImage sd_setImageWithURL:[model.iconUrl convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
            return cell;
        }
    }
    return cell;
    
    
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewRowAction *DeleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (self.type == 1) {
            NSDictionary *dic = self.flowMutableArr[indexPath.row];
            NSDictionary *removeDic = @{@"inter":@"updateflow",@"flowId":dic[@"flowId"]};
            [self.flowMutableArr removeObject:dic];
            self.count = self.flowMutableArr.count;
            
            [HttpRequestEngine deleteApprovalFlowWithDic:removeDic completion:^(id obj, NSString *errorStr) {
                if ([Utils isBlankString:errorStr]) {
                    [self.approvalFlowTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    [self requestFlowArr];
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        } else {
            ContactModel *model = self.peopleArr[indexPath.row];
            [self.peopleArr removeObject:model];
            self.count = self.peopleArr.count + 1;
//            [self.approvalFlowTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.approvalFlowTableView reloadData];
        }
        
        
    }];
    DeleteAction.backgroundColor = [UIColor redColor];
    return @[DeleteAction];
}

- (void)addFlow {
    approvalFlowViewController *approvalFlow = [approvalFlowViewController new];
    approvalFlow.type = 2;
    approvalFlow.application_id = self.application_id;
    approvalFlow.returnPeopleArrBlock = ^(NSArray *peopleArr){
        [self requestFlowArr];
    };
    [self.navigationController pushViewController:approvalFlow animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 2) {
        if (indexPath.row == self.count-1) {
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                [self.peopleArr addObjectsFromArray:returnAvilableMutableArray];
                self.count = self.peopleArr.count + 1;
                [self.approvalFlowTableView reloadData];
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }
    } else {
        NSDictionary *dic = self.flowMutableArr[indexPath.row];
        NSString *nameStr = dic[@"user_name"];
        NSString *IdStr = [NSString stringWithFormat:@"%@",dic[@"flowId"]];
        self.returnFlowNameBlock(nameStr);
        self.returnFlowIdBlock(IdStr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)clickComplete {
    
    
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    NSString *user_id = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
    if (self.peopleArr.count) {
        NSMutableArray *flowUserArr = [NSMutableArray arrayWithCapacity:0];
        for (ContactModel *model in self.peopleArr) {
            NSDictionary *dic = @{@"user_name":model.realName,@"user_id":@(model.userId)};
            [flowUserArr addObject:dic];
        }
        NSDictionary *dic = @{@"user_id":user_id,@"application_id":self.application_id,@"mech_id":mech_id,@"flowUser":flowUserArr};
        [HttpRequestEngine addApprovalFlowWithDic:dic completion:^(id obj, NSString *errorStr) {
            if ([Utils isBlankString:errorStr]) {
                self.returnPeopleArrBlock(self.peopleArr);
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:errorStr];
            }
        }];
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
