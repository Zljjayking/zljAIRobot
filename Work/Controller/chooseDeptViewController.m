//
//  chooseDeptViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/28.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "chooseDeptViewController.h"
#import "MechNameCell.h"
#import "DeptChooseCell.h"

#import "DeptModel.h"

#import "AllDeptCell.h"

#import "DeptDetailViewController.h"

#import "ExeResultViewController.h"
@interface chooseDeptViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoginPeopleModel * loginPeople;
}

@property (nonatomic,strong)UITableView * chooseDeptTableView;
@property (nonatomic,strong)NSMutableArray * deptArray;

@property (nonatomic,strong)NSMutableArray * selectArray;
@end

@implementation chooseDeptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.navigationItem.title = @"选择部门";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPeople)];
//    self.navigationItem.rightBarButtonItem = right;
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self creatUI];
    
    [self loadData];

    
}

-(void)loadData{
    
    loginPeople = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    NSString * mechanIdStr = [NSString stringWithFormat:@"%ld",loginPeople.jrqMechanismId];
    NSString * userId = [NSString stringWithFormat:@"%ld",loginPeople.userId];
    [HttpRequestEngine getAllDeptWithMechanId:mechanIdStr userId:userId completion:^(id obj, NSString *errorStr) {
        
        if (errorStr == nil) {
            
            [self.deptArray removeAllObjects];
            NSMutableArray *deptArr = [NSMutableArray array];
            [deptArr removeAllObjects];
            [deptArr addObjectsFromArray:obj];
            //仅选择自己负责的部门
            if ([self.seType isEqualToString:@"1"]) {
                
                for (int i =0; i<deptArr.count; i++) {
                    DeptModel *deptModel = deptArr[i];
                    if (self.deptId == deptModel.deptId) {
                        [self.deptArray addObject:deptModel];
                    }
                }
            } else {
                [self.deptArray addObjectsFromArray:obj];
            }
            
            [self.chooseDeptTableView reloadData];
            
        }else{
            [MBProgressHUD showError:@"未查到数据"];
            
            [self.deptArray removeAllObjects];
            
         //   [self.organizationTableView.header endRefreshing];
            
        }
        
    }];
    
}

-(void)creatUI{
    
    _chooseDeptTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
    _chooseDeptTableView.delegate = self;
    _chooseDeptTableView.dataSource = self;
    [self.view addSubview:_chooseDeptTableView];
    
    [_chooseDeptTableView registerNib:[UINib nibWithNibName:@"MechNameCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MechNameCellID"];
 
//    [_chooseDeptTableView registerClass:[DeptChooseCell class] forCellReuseIdentifier:@"DeptChooseCellID"];
 
//    [_chooseDeptTableView registerNib:[UINib nibWithNibName:@"MechNameCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MechNameCellID"];
    
    [_chooseDeptTableView registerNib:[UINib nibWithNibName:@"AllDeptCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AllDeptCellID"];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else{
        return self.deptArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        MechNameCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MechNameCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.mechImageView.image = [UIImage imageNamed:@"head_mechanism"];
        cell.mechNameLabel.text = [NSString stringWithFormat:@"%@",loginPeople.mechName];
        cell.mechTeamLabel.text = @"企业管理团队";
        
        cell.mechButton.hidden = YES;
        return cell;
        
    }else{
        
//        DeptChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeptChooseCellID" forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[DeptChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeptChooseCellID"];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        DeptModel * model = self.deptArray[indexPath.row];
//        
//    
//      //  cell.leftBtn.tag = model.tag;
//        cell.leftBtn.selected = model.isSelected;
//        
//        if (cell.leftBtn.selected) {
//            
//            [cell.leftBtn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
//
//        }else{
//            
//            [cell.leftBtn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
//
//        }
//        
//            
//        
//        [cell.leftBtn addTarget:self action:@selector(chooseOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        
//        
//        cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.deptName];
        AllDeptCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllDeptCellID"];
        
        DeptModel * model = self.deptArray[indexPath.row];
        
        cell.deptImageView.image = [UIImage imageNamed:@"head_dept"];
        cell.deptNameLabel.text = [NSString stringWithFormat:@"%@(%ld)人",model.deptName,model.deptcount];
        
        cell.searchBtn.hidden = NO;
        
        [cell.searchBtn setTitle:@"查 看" forState:UIControlStateNormal];
        [cell.searchBtn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
        cell.searchBtn.tag = model.deptId;
        [cell.searchBtn addTarget:self action:@selector(searchDeptClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        
        DeptDetailViewController * deptDetailVC = [[DeptDetailViewController alloc]init];
        deptDetailVC.startTime = self.startTime;
        deptDetailVC.endTime = self.endTime;
        DeptModel * model = self.deptArray[indexPath.row];
        
        deptDetailVC.deptModel = model;
        
        deptDetailVC.deptcount = model.deptcount;
        
        deptDetailVC.deptIdStr = [NSString stringWithFormat:@"%ld",model.deptId];
        
        deptDetailVC.deptName = [NSString stringWithFormat:@"%@",model.deptName];
        
        deptDetailVC.isSearch = 1;
        
        self.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:deptDetailVC animated:YES];
        
    }
}
#pragma makr === 这里查询部门执行力
- (void)searchDeptClick:(UIButton *)sender {
    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];
    paramaters[@"inter"] = @"implementPower";
    paramaters[@"deptId"] = [NSString stringWithFormat:@"%ld",sender.tag];
    paramaters[@"startTime"] = self.startTime;
    paramaters[@"endTime"] = self.endTime;
//    [HttpRequestEngine departmentEfficiency:paramaters completion:^(id obj, NSString *errorStr) {
//        
//    }];
    
    [MBProgressHUD showMessage:@"正在加载.."];
    
    [HttpRequestEngine searchExecutiveWithDic:paramaters completion:^(id obj, NSString *errorStr) {
        
        [MBProgressHUD hideHUD];
        //            NSLog(@"obj == %@",obj);
        if (errorStr == nil) {
            
            NSDictionary * dict = obj;
            
            
            ExeResultViewController * exeResultVC = [[ExeResultViewController alloc]init];
            
            exeResultVC.dataDic = dict;
            
            [self.navigationController pushViewController:exeResultVC animated:YES];
            
            
        }else{
            
            NSLog(@"%@",errorStr);
        }
    }];
}
-(void)chooseOnClick:(UIButton *)sender{
    
    
    if (self.selectArray.count != 0) {
        DeptModel *model = self.selectArray[0];
        model.isSelected = 0;
        [self.selectArray removeAllObjects];
    }
    DeptChooseCell *cell = (DeptChooseCell *)[sender superview];
    NSIndexPath *indexPath = [_chooseDeptTableView indexPathForCell:cell];
 
    DeptModel * model = self.deptArray[indexPath.row];
    model.isSelected = 1;
    [self.selectArray addObject:model];
    
    [_chooseDeptTableView reloadData];
    
}

-(void)ClickAddPeople{
    
    if (self.selectArray.count != 0) {
        
        if (self.returnNSMutableArrayBlock != nil) {
            self.returnNSMutableArrayBlock(self.selectArray);
        }
        
        [self.navigationController popViewControllerAnimated:YES];

        
    }else{
        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择部门" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertV show] ;
    }
    
}

-(NSMutableArray *)deptArray{
    if (_deptArray == nil) {
        _deptArray = [[NSMutableArray alloc]init];
        
    }
    return _deptArray;
}

-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [[NSMutableArray alloc]init];
    }
    
    return _selectArray;
}

-(void)returnMutableArray:(ReturnNSMutableArrayBlock)block{
    
    self.returnNSMutableArrayBlock = block;
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
