//
//  attendanceMachineSetViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/9.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceMachineSetViewController.h"
#import "paySetTitleTableViewCell.h"
#import "signInChangeTableViewCell.h"
#import "tolerantTableViewCell.h"
#import "attendanceMachineSetModel.h"
#import "attendanceMachineSetTableViewCell.h"
@interface attendanceMachineSetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *machineSetTableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) attendanceMachineSetModel *model;
@property (nonatomic, assign) NSInteger type;//1.不可输入 2.可输入
@property (nonatomic, strong) NSMutableArray *mechineArr;
@end

@implementation attendanceMachineSetViewController
- (UITableView *)machineSetTableView {
    if (!_machineSetTableView) {
        _machineSetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        _machineSetTableView.delegate = self;
        _machineSetTableView.dataSource = self;
        _machineSetTableView.tableFooterView = [UIView new];
        _machineSetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _machineSetTableView.backgroundColor = GRAY245;
        [_machineSetTableView registerClass:[paySetTitleTableViewCell class] forCellReuseIdentifier:@"title"];
        [_machineSetTableView registerClass:[signInChangeTableViewCell class] forCellReuseIdentifier:@"change"];
        [_machineSetTableView registerClass:[attendanceMachineSetTableViewCell class] forCellReuseIdentifier:@"tolerant"];
    }
    return _machineSetTableView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _topView.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 6, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [_topView addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 13, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:backTwoV];
    }
    return _topView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _bottomView.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [_bottomView addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:backTwoV];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤机设置";
    
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickCompletion)];
    self.navigationItem.rightBarButtonItem = one;
    self.mechineArr = [NSMutableArray arrayWithCapacity:0];
    self.model = [attendanceMachineSetModel new];
    [self.view addSubview:self.machineSetTableView];
    self.type = 1;
    [self requestattendanceMachineSet];
    
    
    // Do any additional setup after loading the view.
}
- (void)requestattendanceMachineSet {
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    [HttpRequestEngine getAttendanceMachineSetWithMech_ic:mech_id completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *dataArr = obj;
            if (dataArr.count) {
                for (NSDictionary *dic in dataArr) {
                    attendanceMachineSetModel *model = [attendanceMachineSetModel requestWithDic:dic];
                    [self.mechineArr addObject:model];
                }
            } else {
                self.type = 2;
                attendanceMachineSetModel *model = [attendanceMachineSetModel new];
                [self.mechineArr addObject:model];
            }
            [self.machineSetTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2+self.mechineArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 15*KAdaptiveRateWidth;
    }
    if (indexPath.section == 0 && indexPath.row <= self.mechineArr.count) {
        return 85;
    }
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.topView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.bottomView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 0) {
        paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
        if (cell == nil) {
            cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
        }
        cell.hehe.backgroundColor = kMyColor(136, 205, 233);
        cell.heheLB.text = @"设备绑定";
        return cell;
    } else{
        if (indexPath.row <= self.mechineArr.count) {
            
            attendanceMachineSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tolerant"];
            if (cell == nil) {
                cell = [[attendanceMachineSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tolerant"];
            }
            attendanceMachineSetModel *model = self.mechineArr[indexPath.row-1];
            cell.titleLabel.text = @"设备序列号";
            cell.chooseTF.placeholder = @"输入设备序列号";
            cell.markTF.tag = indexPath.row*10;
            cell.markTF.textAlignment = NSTextAlignmentLeft;
            cell.chooseTF.tag = indexPath.row*10+1;
            cell.chooseTF.delegate = self;
            cell.markTF.delegate = self;
            cell.markTF.text = model.name;
            cell.chooseTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.chooseTF.text = model.sn;
            cell.chooseTF.textAlignment = NSTextAlignmentRight;
            if (self.type == 2 && ![Utils isBlankString:self.model.sn]) {
                cell.chooseTF.enabled = NO;
            } else {
                cell.chooseTF.enabled = YES;
            }
            
//            [cell.chooseTF addTarget:self action:@selector(textFieldDidEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            
            [cell updateConstraints];
            return cell;
            
        } else {
            signInChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"change"];
            if (cell == nil) {
                cell = [[signInChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"change"];
            }
            [cell.changeBtn setTitle:@"添加更多设备" forState:UIControlStateNormal];
            if (self.type == 2 && ![Utils isBlankString:self.model.sn]) {
                [cell.changeBtn setTitle:@"添加更多设备" forState:UIControlStateNormal];
            }
            
            [cell.changeBtn addTarget:self action:@selector(addMoreMechine) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
    }
    
    return cell;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.type == 1) {
        self.model.sn = textField.text;
    }
    NSInteger index = (textField.tag/10)-1;
    attendanceMachineSetModel *model = self.mechineArr[index];
    if (textField.tag%10) {
        //设备号
        model.sn = textField.text;
    } else {
        //备注
        model.name = textField.text;
    }
    
}

- (void)ClickCompletion {
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    NSMutableArray *mechineArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<self.mechineArr.count; i++) {
        attendanceMachineSetModel *model = self.mechineArr[i];
        if ([Utils isBlankString:model.ID]) {
            model.ID = @"0";
        }
        if ([Utils isBlankString:model.sn]) {
            [MBProgressHUD showToastText:[NSString stringWithFormat:@"请填写第%d条的设备序列号",i+1]];
            
            return;
        }
        if ([Utils isBlankString:model.name]) {
            [MBProgressHUD showToastText:[NSString stringWithFormat:@"请填写第%d条的设备备注",i+1]];
            
            return;
        }
        NSDictionary *dic = @{@"id":model.ID,@"sn":model.sn,@"name":model.name,@"mech_id":mech_id};
        [mechineArray addObject:dic];
    }
    NSDictionary *paramaters = @{@"appCardSnConfigs":mechineArray,@"mech_id":mech_id};
    
    [HttpRequestEngine attendanceMachineSetWithDic:paramaters completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            [MBProgressHUD showSuccess:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1) {
//        if (self.type == 1) {
//            attendanceMachineSetTableViewCell *cell1 = (attendanceMachineSetTableViewCell *)cell;
//            [cell1.chooseTF becomeFirstResponder];
//        }
//    }
//    if ([cell isKindOfClass:[attendanceMachineSetTableViewCell class]]) {
//        attendanceMachineSetTableViewCell *cell1 = (attendanceMachineSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//        if (self.type == 1) {
//            [cell1.chooseTF becomeFirstResponder];
//        }
//    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row > 0 && indexPath.row <= self.mechineArr.count ) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    attendanceMachineSetModel *model = self.mechineArr[indexPath.row-1];
    
    [self.mechineArr removeObject:model];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)addMoreMechine {
    attendanceMachineSetModel *model = [attendanceMachineSetModel new];
    [self.mechineArr addObject:model];
    [self.machineSetTableView reloadData];
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
