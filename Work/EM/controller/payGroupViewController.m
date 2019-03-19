//
//  payGroupViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/27.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "payGroupViewController.h"
#import "payGroupModel.h"
#import "ContactModel.h"
#import "payGroupOneTableViewCell.h"
#import "payGroupTwoTableViewCell.h"
#import "payGroupThreeTableViewCell.h"
#import "chooseViewController.h"
@interface payGroupViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JKAlertViewDelegate>
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UITableView *payGroupdetailTableView;
@property (nonatomic, strong) payGroupModel *model;
@property (nonatomic ) NSMutableArray *peopleMuArr;
@property (nonatomic) NSMutableArray *groupLimitArr;
@property (nonatomic, strong) NSString *commission;
@property (nonatomic) NSMutableArray *deleteArr;
@end

@implementation payGroupViewController
- (UITableView *)payGroupdetailTableView {
    if (!_payGroupdetailTableView) {
        _payGroupdetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-60) style:UITableViewStylePlain];
        if (IS_IPHONE_X) {
            _payGroupdetailTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-84);
        }
        _payGroupdetailTableView.backgroundColor = VIEW_BASE_COLOR;
        _payGroupdetailTableView.delegate = self;
        _payGroupdetailTableView.dataSource = self;
        _payGroupdetailTableView.tableFooterView = [UIView new];
        _payGroupdetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_payGroupdetailTableView registerClass:[payGroupOneTableViewCell class] forCellReuseIdentifier:@"one"];
        [_payGroupdetailTableView registerClass:[payGroupTwoTableViewCell class] forCellReuseIdentifier:@"two"];
        [_payGroupdetailTableView registerClass:[payGroupThreeTableViewCell class] forCellReuseIdentifier:@"three"];
    }
    return _payGroupdetailTableView;
}

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组详情";
    self.peopleMuArr = [NSMutableArray arrayWithCapacity:0];
    self.deleteArr = [NSMutableArray arrayWithCapacity:0];
    self.groupLimitArr = [NSMutableArray arrayWithCapacity:0];
    self.model = [payGroupModel new];
    
    [self.view addSubview:self.payGroupdetailTableView];
    
    if (self.type == 1) {
        [self requestData];
        [self setBottomView];
    } else {
        self.payGroupdetailTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
    }
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickCompletion)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}
- (void)requestData {
    [MBProgressHUD showMessage:@"正在加载..." toView:self.navigationController.view];
    [HttpRequestEngine getPayGroupDetailWithId:self.Id completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dic = (NSDictionary *)obj;
            self.model = [payGroupModel requestWithDic:dic];
            if ([self.model.commission isEqualToString:@"件"]) {
                self.commission = @"1";
            } else if ([self.model.commission isEqualToString:@"量"]){
                self.commission = @"2";
            } else if ([self.model.commission isEqualToString:@"服务费"]) {
                self.commission = @"3";
            }
            NSArray *peopleArr = (NSArray *)dic[@"personList"];
            if (peopleArr.count > 0) {
                for (NSDictionary *people in peopleArr) {
                    ContactModel *peopleModel = [ContactModel requestWithDic:people];
                    [self.peopleMuArr addObject:peopleModel];
                }
            }
            
            [self.payGroupdetailTableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [MBProgressHUD showError:errorStr];
            
        }
    }];
}
- (void)setBottomView {
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.layer.cornerRadius = 5;
    [self.deleteBtn setTitle:@"删   除" forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deletePayGroup) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    [self.deleteBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        if (IS_IPHONE_X) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-34);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
        make.height.mas_equalTo(40);
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 110*KAdaptiveRateWidth;
    } else if (indexPath.row == 1) {
        return 52*KAdaptiveRateWidth+110;
    } else {
        return (65*KAdaptiveRateWidth+12) * ((self.peopleMuArr.count)/4+1)+12+29*KAdaptiveRateWidth;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        payGroupOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
        if (cell == nil) {
            cell = [[payGroupOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
        }
        cell.nameTF.tag = 1000;
        cell.salaryTF.tag = 2000;
        
        cell.nameTF.text = self.model.performance;
        cell.salaryTF.text = self.model.salary;
        
        cell.nameTF.delegate = self;
        cell.salaryTF.delegate = self;
        
        return cell;
    } else if (indexPath.row == 1) {
        payGroupTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
        if (cell == nil) {
            cell = [[payGroupTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
        }
        cell.jianBtn.tag = 100;
        cell.liangBtn.tag = 200;
        cell.seviceBtn.tag = 300;
        cell.fangKuanBtn.tag = 400;
        [cell.jianBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.liangBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.seviceBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.fangKuanBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.model.commission isEqualToString:@"件"]) {
            cell.jianBtn.selected = YES;
            cell.liangBtn.selected = NO;
            cell.seviceBtn.selected = NO;
            cell.fangKuanBtn.selected = NO;
        } else if ([self.model.commission isEqualToString:@"量"]){
            cell.jianBtn.selected = NO;
            cell.liangBtn.selected = YES;
            cell.seviceBtn.selected = NO;
            cell.fangKuanBtn.selected = NO;
        } else if ([self.model.commission isEqualToString:@"服务费"]) {
            cell.jianBtn.selected = NO;
            cell.liangBtn.selected = NO;
            cell.seviceBtn.selected = YES;
            cell.fangKuanBtn.selected = NO;
        } else  if ([self.model.commission isEqualToString:@"放款总额"]){
            cell.jianBtn.selected = NO;
            cell.liangBtn.selected = NO;
            cell.seviceBtn.selected = NO;
            cell.fangKuanBtn.selected = YES;
        }

        return cell;
    } else {
        payGroupThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three" ];
        if (cell == nil) {
            cell = [[payGroupThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
        }
        
        for (UIButton *btn in cell.subviews) {
            [btn removeFromSuperview];
        }
        
        cell.bgView = [[UIView alloc] init];
        cell.bgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview: cell.bgView];
        cell.bgView.layer.cornerRadius = 5*KAdaptiveRateWidth;
        [cell.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
            make.top.equalTo(cell.mas_top).offset(7*KAdaptiveRateWidth);
            make.right.equalTo(cell.mas_right).offset(-10*KAdaptiveRateWidth);
            make.bottom.equalTo(cell.mas_bottom).offset(-7*KAdaptiveRateWidth);
        }];
        
        UIView *hehe = [[UIView alloc] init];
        hehe.backgroundColor = kMyColor(241, 45, 114);
        [cell addSubview:hehe];
        [hehe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(15*KAdaptiveRateWidth);
            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
            make.width.mas_equalTo(5*KAdaptiveRateWidth);
            make.height.mas_equalTo(14*KAdaptiveRateWidth);
        }];
        
        UILabel *heheLB = [[UILabel alloc]init];
        [cell addSubview:heheLB];
        heheLB.text = @"组成员";
        heheLB.textColor = GRAY138;
        heheLB.font = [UIFont systemFontOfSize:14];
        [heheLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(hehe.mas_centerY);
            make.left.equalTo(hehe.mas_right).offset(5*KAdaptiveRateWidth);
            make.height.mas_equalTo(14*KAdaptiveRateWidth);
        }];
        
        for (int i = 0; i < self.peopleMuArr.count+1; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(i/4 * (65*KAdaptiveRateWidth+12)+12+29*KAdaptiveRateWidth);
                make.left.equalTo(cell.mas_left).offset(i%4 * (65*KAdaptiveRateWidth + 12*KAdaptiveRateWidth)+12*KAdaptiveRateWidth);
                make.width.mas_equalTo(65*KAdaptiveRateWidth);
                make.height.mas_equalTo(65*KAdaptiveRateWidth);
            }];
            if (i==self.peopleMuArr.count) {
                UIImageView *imageV = [[UIImageView alloc]init];
                [btn addSubview:imageV];
                imageV.layer.masksToBounds = YES;
                [imageV.layer setCornerRadius:5];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn.mas_top).offset(10*KAdaptiveRateWidth);
                    make.centerX.equalTo(btn.mas_centerX);
                    make.height.mas_equalTo(40*KAdaptiveRateWidth);
                    make.width.mas_equalTo(40*KAdaptiveRateWidth);
                }];
                //                    btn.tag = 1;
                [btn addTarget:self action:@selector(ClickAddPeople:) forControlEvents:UIControlEventTouchUpInside];
                imageV.image = [UIImage imageNamed:@"增加群聊（大加）"];
            } else {
                
                ContactModel * model = self.peopleMuArr[i];
                UIImageView *imageV = [[UIImageView alloc]init];
                [btn addSubview:imageV];
                imageV.layer.masksToBounds = YES;
                [imageV.layer setCornerRadius:20*KAdaptiveRateWidth];
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn.mas_top).offset(10*KAdaptiveRateWidth);
                    make.centerX.equalTo(btn.mas_centerX);
                    make.height.mas_equalTo(40*KAdaptiveRateWidth);
                    make.width.mas_equalTo(40*KAdaptiveRateWidth);
                }];
                NSString * imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,model.iconUrl];
                NSURL * imageURL = [NSURL URLWithString:imagePath];
                [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    UILabel *label = [[UILabel alloc]init];
                    [btn addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:13];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(btn.mas_bottom);
                        make.left.equalTo(btn.mas_left).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(14*KAdaptiveRateWidth);
                    }];
                    label.text = model.realName;
                }];
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.tag = i+1000;
                [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
                [btn addSubview:deleteBtn];
                [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(btn.mas_centerX).offset(20*KAdaptiveRateWidth);
                    make.top.equalTo(btn.mas_top);
                    make.width.mas_equalTo(15*KAdaptiveRateWidth);
                    make.height.mas_equalTo(15*KAdaptiveRateWidth);
                }];
            }
        }
        
        return cell;
    }
    
}
- (void)chooseType:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            if (!sender.selected) {
                sender.selected = YES;
                self.model.commission = @"件";
                self.commission = @"1";
                UIButton *btnTwo = [self.payGroupdetailTableView viewWithTag:200];
                UIButton *btnThree = [self.payGroupdetailTableView viewWithTag:300];
                UIButton *btnFour = [self.payGroupdetailTableView viewWithTag:400];
                btnFour.selected = NO;
                btnTwo.selected = NO;
                btnThree.selected = NO;
            }
        }
            break;
        case 200:
        {
            if (!sender.selected) {
                sender.selected = YES;
                self.model.commission = @"量";
                self.commission = @"2";
                UIButton *btnOne = [self.payGroupdetailTableView viewWithTag:100];
                UIButton *btnThree = [self.payGroupdetailTableView viewWithTag:300];
                UIButton *btnFour = [self.payGroupdetailTableView viewWithTag:400];
                btnFour.selected = NO;
                btnOne.selected = NO;
                btnThree.selected = NO;
            }
        }
            break;
        case 300:
        {
            if (!sender.selected) {
                sender.selected = YES;
                self.model.commission = @"服务费";
                self.commission = @"3";
                UIButton *btnOne = [self.payGroupdetailTableView viewWithTag:100];
                UIButton *btnTwo = [self.payGroupdetailTableView viewWithTag:200];
                UIButton *btnFour = [self.payGroupdetailTableView viewWithTag:400];
                btnFour.selected = NO;
                btnOne.selected = NO;
                btnTwo.selected = NO;
            }
        }
            break;
        default:
            if (!sender.selected) {
                sender.selected = YES;
                self.model.commission = @"放款总额";
                self.commission = @"4";
                UIButton *btnOne = [self.payGroupdetailTableView viewWithTag:100];
                UIButton *btnTwo = [self.payGroupdetailTableView viewWithTag:200];
                UIButton *btnThree = [self.payGroupdetailTableView viewWithTag:300];
                btnThree.selected = NO;
                btnOne.selected = NO;
                btnTwo.selected = NO;
            }
            break;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.model.performance = textField.text;
    } else {
        self.model.salary = textField.text;
    }
}
- (void)ClickAddPeople:(UIButton *)btn {
    [self.groupLimitArr removeAllObjects];
    chooseViewController *choose = [chooseViewController new];
    choose.seType = 2;
    choose.limited = 9;
    
    [self.groupLimitArr addObjectsFromArray:self.peopleMuArr];
    choose.deleteArr = self.deleteArr;
    choose.limitArr = self.groupLimitArr;
    [choose returnAvilableMutableArray:^(NSMutableArray *returnMutableArray) {
        [self.peopleMuArr addObjectsFromArray:returnMutableArray];
        [_payGroupdetailTableView reloadData];
        [self.deleteArr removeAllObjects];
    }];
    [self.navigationController pushViewController:choose animated:YES];
}
- (void)deleteBtnClick:(UIButton *)Btn {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //获取可用人员数据
        ContactModel *model = self.peopleMuArr[Btn.tag%1000];
        [self.peopleMuArr removeObjectAtIndex:Btn.tag%1000];
        
        [self.deleteArr addObject:model];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_payGroupdetailTableView reloadData];
            
        });
    });
    
}

- (void)deletePayGroup{
    JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"确定删除该薪资组?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}
- (void)ClickCompletion {
    NSDictionary *dic = [self dicWithData];
    if (dic) {
        if (self.type == 1) {
            [HttpRequestEngine mendPayGroupDetialWithDic:dic completion:^(id obj, NSString *errorStr) {
                if ([Utils isBlankString:errorStr]) {
                    [MBProgressHUD showSuccess:@"修改成功"];
                    self.Block();
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        } else {
            [HttpRequestEngine addPayGroupWithDic:dic completion:^(id obj, NSString *errorStr) {
                if ([Utils isBlankString:errorStr]) {
                    [MBProgressHUD showSuccess:@"新增成功"];
                    self.Block();
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        }
        
    }
}
- (NSDictionary *)dicWithData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.type == 1) {
        dic[@"inter"] = @"updatePerformance";
        dic[@"id"] = self.Id;
    } else {
        dic[@"inter"] = @"insertPerformance";
    }
    if (![Utils isBlankString:self.model.performance]) {
        dic[@"performance"] = self.model.performance;
    } else {
        [MBProgressHUD showError:@"请输入薪资组名称"];
        return nil;
    }
    if (![Utils isBlankString:self.model.salary]) {
        dic[@"salary"] = self.model.salary;
    } else {
        [MBProgressHUD showError:@"请输入基础薪资"];
        return nil;
    }
    
    if (![Utils isBlankString:self.commission]) {
        dic[@"commission"] = self.commission;
    } else {
        [MBProgressHUD showError:@"请选择提成方式"];
        return nil;
    }
    LoginPeopleModel *loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    dic[@"mech_id"] = [NSString stringWithFormat:@"%ld",loginModel.jrqMechanismId];
    if (self.peopleMuArr.count) {
        NSString *idString;
        for ( int i=0 ; i < self.peopleMuArr.count; i++) {
            ContactModel *peopleModel = self.peopleMuArr[i];
            if (i == 0 ) {
                idString = [NSString stringWithFormat:@"%ld",peopleModel.userId];
            } else if (i!=0) {
                idString = [NSString stringWithFormat:@"%@,%ld",idString,peopleModel.userId];
            }
        }
        
        dic[@"userId"] = idString;
    }
    
    
    return dic;
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [HttpRequestEngine deletePayGroupWithId:self.Id completion:^(id obj, NSString *errorStr) {
            if ([Utils isBlankString:errorStr]) {
                [MBProgressHUD showSuccess:@"删除成功"];
                self.Block();
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
