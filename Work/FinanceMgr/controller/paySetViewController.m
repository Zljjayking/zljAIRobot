//
//  paySetViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySetViewController.h"
#import "paySetOneTableViewCell.h"
#import "paySetTitleTableViewCell.h"
#import "paySetTwoTableViewCell.h"
#import "paySetThreeTableViewCell.h"
#import "paySetFourTableViewCell.h"
#import "paySetFiveTableViewCell.h"
#import "paySetSixTableViewCell.h"
@interface paySetViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *paySetTableView;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) NSInteger sevicePay;
@property (nonatomic, assign) NSInteger allPay;
@property (nonatomic, strong) NSMutableDictionary *serviceDic;
@property (nonatomic, strong) NSMutableDictionary *allPayDic;

@property (nonatomic, assign) BOOL isEnableService;
@property (nonatomic, assign) BOOL isEnableAllpay;
@property (nonatomic, strong) LoginPeopleModel *loginModel;

@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *jianStr;
@property (nonatomic, strong) NSString *liangStr;
@property (nonatomic, strong) NSString *jiaBanStr;
@property (nonatomic, strong) NSString *quanQinStr;

@property (nonatomic, strong) NSString *chiDaoStr;
@property (nonatomic, strong) NSString *queQinStr;
@property (nonatomic, strong) NSString *kuangGongStr;
@property (nonatomic, strong) NSString *qingJiaStr;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger serviceID;
@property (nonatomic, assign) NSInteger allPayID;

@end

@implementation paySetViewController
- (UITableView *)paySetTableView {
    if (!_paySetTableView) {
        _paySetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        _paySetTableView.delegate = self;
        _paySetTableView.dataSource = self;
        _paySetTableView.tableFooterView = [UIView new];
        [_paySetTableView registerClass:[paySetTitleTableViewCell class] forCellReuseIdentifier:@"title"];
        [_paySetTableView registerClass:[paySetOneTableViewCell class] forCellReuseIdentifier:@"one"];
        _paySetTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_paySetTableView registerClass:[paySetTwoTableViewCell class] forCellReuseIdentifier:@"two"];
        [_paySetTableView registerClass:[paySetThreeTableViewCell class] forCellReuseIdentifier:@"three"];
        [_paySetTableView registerClass:[paySetFourTableViewCell class] forCellReuseIdentifier:@"four"];
        [_paySetTableView registerClass:[paySetFiveTableViewCell class] forCellReuseIdentifier:@"five"];
        [_paySetTableView registerClass:[paySetSixTableViewCell class] forCellReuseIdentifier:@"six"];
    }
    return _paySetTableView;
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
    self.title = @"薪资设置";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.mech_id = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    self.isEnableService = 0;
    self.isEnableAllpay = 0;
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickCompletion)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.serviceDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.allPayDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.sevicePay = 1;
    self.allPay = 1;
    
    self.serviceID = 1;
    self.allPayID = 1;
    
    self.rows = 7+self.sevicePay+self.allPay;
    [self.view addSubview:self.paySetTableView];
    //请求查询薪资设置
    [self getPaySet];
    
    // Do any additional setup after loading the view.
}
- (void)getPaySet {
    
    [HttpRequestEngine getPaySetWithMech_id:self.mech_id completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *arr = obj;
            
            for ( int i = 1 ; i <= arr.count ; i++) {
                NSDictionary *dic = arr[i-1];
                NSString *commission = [NSString stringWithFormat:@"%@",dic[@"commission"]];
                switch ([commission integerValue]) {
                    case 1:
                        self.jianStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        break;
                    case 2:
                        self.liangStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        break;
                    case 3:
                    {
                        NSString *min = [NSString stringWithFormat:@"%@",dic[@"minValue"]];
                        NSString *max = [NSString stringWithFormat:@"%@",dic[@"maxValue"]];
                        NSString *value = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithCapacity:0];
                        mudic[@"1"] = min;
                        mudic[@"2"] = max;
                        mudic[@"3"] = value;
                        self.isEnableService = 1;
                        
                        NSString *keyStr = [NSString stringWithFormat:@"%ld",self.serviceID];
                        [self.serviceDic setObject:mudic forKey:keyStr];
                        self.serviceID = self.serviceID+1;
                        
                    }
                        break;
                    case 4:
                    {
                        NSString *min = [NSString stringWithFormat:@"%@",dic[@"minValue"]];
                        NSString *max = [NSString stringWithFormat:@"%@",dic[@"maxValue"]];
                        NSString *value = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithCapacity:0];
                        mudic[@"1"] = min;
                        mudic[@"2"] = max;
                        mudic[@"3"] = value;
                        self.isEnableAllpay = 1;
                        NSString *keyStr = [NSString stringWithFormat:@"%ld",self.allPayID];
                        [self.allPayDic setObject:mudic forKey:keyStr];
                        self.allPayID = self.allPayID+1;
                    }
                        break;
                    case 5:
                    {
                        NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        if ([name isEqualToString:@"加班补贴"]) {
                            self.jiaBanStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        }
                    }
                        break;
                    case 6:
                    {
                        NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        if ([name isEqualToString:@"全勤奖"]){
                            self.quanQinStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        }
                    }
                        break;
                    case 7:
                    {
                        NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        if ([name isEqualToString:@"迟到早退"]){
                            self.chiDaoStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        }
                    }
                        break;
                    case 8:
                    {
                        NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        if ([name isEqualToString:@"缺勤"]){
                            self.queQinStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        }
                    }
                        break;
                    case 9:
                    {
                        NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        if ([name isEqualToString:@"旷工"]){
                            self.kuangGongStr = [NSString stringWithFormat:@"%@",dic[@"value"]];
                        }
                    }
                        break;
                    
                }
            }
            self.sevicePay = [self.serviceDic allKeys].count>0?[self.serviceDic allKeys].count:1;
            self.allPay = [self.allPayDic allKeys].count>0?[self.allPayDic allKeys].count:1;
            self.rows = 7+self.sevicePay+self.allPay;
            [self.paySetTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.rows;
    } else if (section == 1){
        return 3;
    } else {
        return 4;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        vi.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 6, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [vi addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 13, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [vi addSubview:backTwoV];
        return vi;
    } else if (section == 1) {
        UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        vi.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 6, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [vi addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 13, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [vi addSubview:backTwoV];
        return vi;
    }
    return self.topView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        view.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [view addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [view addSubview:backTwoV];

        return view;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        view.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [view addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [view addSubview:backTwoV];
        
        return view;
    }
    return self.bottomView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 15*KAdaptiveRateWidth;
        } else {
            if (indexPath.row == 1) {
                NSString *str = @"根据员工月放款订单数量，按照 件*元/件=提成金额 进行计算提成金额";
//                CGSize size = [str boundingRectWithSize:CGSizeMake(kScreenWidth-130*KAdaptiveRateWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+size1.height;
            } else if (indexPath.row == 2) {
                NSString *str = @"根据员工意向客户数量(不包含状态为‘公司放弃’的客户)，按照 个*元/个=提成金额 进行计算提成金额";
                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+size1.height;
            } else if (indexPath.row == 3) {
                NSString *str = @"根据员工服务费总额，匹配符合下列设置的服务费的区间范围，按照 服务费*设定百分比=提成金额 进行计算提成金额";
                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-40*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+size1.height;
            } else if (indexPath.row == 4+self.sevicePay+1) {
                NSString *str = @"根据员工月放款总额，匹配符合下列设置的服务费的区间范围，按照 放款总额*设定百分比=提成金额 进行计算提成金额";
                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-40*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+size1.height;
            } else if (indexPath.row == 6+self.sevicePay+self.allPay) {
                return 70;
            } else if (indexPath.row == 4+self.sevicePay) {
                return 70;
            }
            return 50;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 15*KAdaptiveRateWidth;
        } else {
            if (indexPath.row == 1) {
                NSString *str = @"根据员工在公司规定工作时间外的劳动补贴,按照 加班时间(小时) * 元/小时 = 实际补贴金额 (实际加班时间按照员工提出加班审批通过后的时间为准)";
                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-120*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+size1.height;
            } else if (indexPath.row == 2) {
                NSString *str = @"当月在公司规定的上班时间内未出现任何迟到、早退、请假、旷工者，公司给予全勤奖";
                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-120*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+size1.height;
            }
        }
    } else{
        if (indexPath.row == 0) {
            return 15*KAdaptiveRateWidth;
        } else {
            if (indexPath.row == 1) {
                NSString *str = @"根据员工在公司规定工作时间内迟到早退的次数,按照 次数 * 元/次 = 扣除金额进行计算";
                CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:kScreenWidth-120*KAdaptiveRateWidth];
//                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-120*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+height;
            } else if (indexPath.row == 2) {
                NSString *str = @"在公司规定的工作时间内出现缺勤情况，按照 基本薪资／当月工作天数*缺勤天数 = 缺勤应扣款 进行计算";
                CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:kScreenWidth-40*KAdaptiveRateWidth];
//                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+height;
            } else if (indexPath.row == 3){
                NSString *str = @"根据员工在公司规定工作时间内旷工(正常工作日内无请假或请假不通过的缺勤行为)的次数，按照 次数*基本薪资／当月工作日天数*设置倍数 = 扣除金额 进行计算";
                CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:kScreenWidth-120*KAdaptiveRateWidth];
//                CGSize size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130*KAdaptiveRateWidth, MAXFLOAT)];
                return 55+height;
            }
        }
    }
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
            }
            cell.hehe.backgroundColor = kMyColor(44, 244, 243);
            cell.heheLB.text = @"基础提成";
            return cell;
        } else if (indexPath.row == 1) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"件";
            cell.unitLB.text = @"元/件";
            cell.salaryLB.text = @"根据员工月放款订单数量，按照 件*元/件=提成金额 进行计算提成金额";
            cell.salaryTF.delegate = self;
            cell.salaryTF.text = self.jianStr;
            cell.salaryTF.tag = 100;
            return cell;
        } else if (indexPath.row == 2) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"量";
            cell.unitLB.text = @"元/个";
            cell.salaryLB.text = @"根据员工意向客户数量(不包含状态为‘公司放弃’的客户)，按照 个*元/个=提成金额 进行计算提成金额";
            cell.salaryTF.delegate = self;
            cell.salaryTF.text = self.liangStr;
            cell.salaryTF.tag = 200;
            return cell;
        } else if (indexPath.row == 3) {
            paySetTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
            if (cell == nil) {
                cell = [[paySetTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
            }
            cell.nameLB.text = @"服务费";
            cell.salaryLB.text = @"根据员工服务费总额，匹配符合下列设置的服务费的区间范围，按照 服务费*设定百分比=提成金额 进行计算提成金额";
            return cell;
        } else if (indexPath.row < 4+self.sevicePay && indexPath.row > 3) {
            paySetThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
            if (cell == nil) {
                cell = [[paySetThreeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
            }
            NSString *numberStr = [NSString stringWithFormat:@"%ld",indexPath.row-3];
            cell.ll.text = numberStr;
            [cell.deleteBtn addTarget:self action:@selector(clickDeleteService:) forControlEvents:UIControlEventTouchUpInside];
            NSMutableDictionary *dic = [self.serviceDic objectForKey:numberStr];
            if (dic) {
                dic = [NSDictionary changeType:dic];
                NSString *minValue = [NSString stringWithFormat:@"%@",dic[@"1"]];
                if (![Utils isBlankString:minValue]) {
                    cell.minTF.text = minValue;
                } else {
                    cell.minTF.text = @"";
                }
                NSString *maxValue = [NSString stringWithFormat:@"%@",dic[@"2"]];
                if (![Utils isBlankString:maxValue]) {
                    cell.maxTF.text = maxValue;
                } else {
                    cell.maxTF.text = @"";
                }
                NSString *three = [NSString stringWithFormat:@"%@",dic[@"3"]];
                if (![Utils isBlankString:three]) {
                    cell.percentTF.text = three;
                }else{
                    cell.percentTF.text = @"";
                }
            } else {
                cell.minTF.text = @"";
                cell.maxTF.text = @"";
                cell.percentTF.text = @"";
            }
            cell.minTF.delegate = self;
            cell.minTF.tag = (indexPath.row-3)*1000+1;
            cell.maxTF.delegate = self;
            cell.maxTF.tag = (indexPath.row-3)*1000+2;
            cell.percentTF.delegate = self;
            cell.percentTF.tag = (indexPath.row-3)*1000+3;
            if (indexPath.row == 4+self.sevicePay-1) {
                if (indexPath.row == 4) {
                    cell.deleteBtn.hidden = YES;
                }else {
                    cell.deleteBtn.hidden = NO;
                }
                cell.minTF.enabled = YES;
                cell.maxTF.enabled = YES;
                cell.minTF.textColor = GRAY50;
                cell.maxTF.textColor = GRAY50;
            } else {
                cell.deleteBtn.hidden = YES;
                
                cell.minTF.enabled = NO;
                cell.maxTF.enabled = NO;
                cell.minTF.textColor = GRAY100;
                cell.maxTF.textColor = GRAY100;
            }
            return cell;
        } else if (indexPath.row == 4+self.sevicePay) {
            paySetFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
            if (cell == nil) {
                cell = [[paySetFiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
            }
            cell.btn.enabled = _isEnableService;
            cell.btn.tag = 999;
            [cell.btn addTarget:self action:@selector(clickAddService:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else if (indexPath.row == 4+self.sevicePay+1) {
            paySetTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
            if (cell == nil) {
                cell = [[paySetTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
            }
            cell.nameLB.text = @"放款总额";
            cell.salaryLB.text = @"根据员工月放款总额，匹配符合下列设置的服务费的区间范围，按照 放款总额*设定百分比=提成金额 进行计算提成金额";
            return cell;
        } else if (indexPath.row < 6+self.sevicePay+self.allPay && indexPath.row > 4+self.sevicePay+1){
            paySetFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Four"];
            if (cell == nil) {
                cell = [[paySetFourTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Four"];
            }
            NSString *numberStr = [NSString stringWithFormat:@"%ld",indexPath.row-4-self.sevicePay-1];
            cell.ll.text = numberStr;
            [cell.deleteBtn addTarget:self action:@selector(clickDeleteAllPay:) forControlEvents:UIControlEventTouchUpInside];
            
            NSMutableDictionary *dic = [self.allPayDic objectForKey:numberStr];
            if (dic) {
                dic = [NSDictionary changeType:dic];
                NSString *minValue = [NSString stringWithFormat:@"%@",dic[@"1"]];
                if (![Utils isBlankString:minValue]) {
                    cell.minTF.text = minValue;
                } else {
                    cell.minTF.text = @"";
                }
                NSString *maxValue = [NSString stringWithFormat:@"%@",dic[@"2"]];
                if (![Utils isBlankString:maxValue]) {
                    cell.maxTF.text = maxValue;
                } else {
                    cell.maxTF.text = @"";
                }
                NSString *three = [NSString stringWithFormat:@"%@",dic[@"3"]];
                if (![Utils isBlankString:three]) {
                    cell.percentTF.text = three;
                }else{
                    cell.percentTF.text = @"";
                }
            } else {
                cell.minTF.text = @"";
                cell.maxTF.text = @"";
                cell.percentTF.text = @"";
            }
            
            cell.minTF.delegate = self;
            cell.minTF.tag = (indexPath.row-4-self.sevicePay-1)*10000+1;
            cell.maxTF.delegate = self;
            cell.maxTF.tag = (indexPath.row-4-self.sevicePay-1)*10000+2;
            cell.percentTF.delegate = self;
            cell.percentTF.tag = (indexPath.row-4-self.sevicePay-1)*10000+3;
            if (indexPath.row == 6+self.sevicePay+self.allPay-1) {
                if (indexPath.row == 4+self.sevicePay+2) {
                    cell.deleteBtn.hidden = YES;
                }else {
                    cell.deleteBtn.hidden = NO;
                }
                cell.minTF.enabled = YES;
                cell.maxTF.enabled = YES;
                cell.minTF.textColor = GRAY50;
                cell.maxTF.textColor = GRAY50;
            } else {
                cell.deleteBtn.hidden = YES;
                
                cell.minTF.enabled = NO;
                cell.maxTF.enabled = NO;
                cell.minTF.textColor = GRAY100;
                cell.maxTF.textColor = GRAY100;
            }
            return cell;
        } else if (indexPath.row == 6+self.sevicePay+self.allPay) {
            paySetSixTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
            if (cell == nil) {
                cell = [[paySetSixTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
            }
            cell.btn.enabled = _isEnableAllpay;
            cell.btn.tag = 9999;
            [cell.btn addTarget:self action:@selector(clickAddAllPay:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
            }
            cell.hehe.backgroundColor = kMyColor(253, 159, 42);
            cell.heheLB.text = @"其他";
            return cell;
        }else if (indexPath.row == 1) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"加班补贴";
            cell.unitLB.text = @"元/小时";
            cell.salaryLB.text = @"根据员工在公司规定工作时间外的劳动补贴,按照 加班时间(小时) * 元/小时 = 实际补贴金额 (实际加班时间按照员工提出加班审批通过后的时间为准)";
            cell.salaryTF.delegate = self;
            cell.salaryTF.text = self.jiaBanStr;
            cell.salaryTF.tag = 300;
            return cell;
        } else if (indexPath.row == 2) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"全勤奖";
            cell.unitLB.text = @"元/月";
            cell.salaryLB.text = @"当月在公司规定的上班时间内未出现任何迟到、早退、请假、旷工者，公司给予全勤奖";
            cell.salaryTF.delegate = self;
            cell.salaryTF.text = self.quanQinStr;
            cell.salaryTF.tag = 400;
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
            }
            cell.hehe.backgroundColor = customRedColor;
            cell.heheLB.text = @"扣除部分";
            return cell;
        }else if (indexPath.row == 1) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"迟到早退";
            cell.unitLB.text = @"元/次";
            cell.salaryLB.text = @"根据员工在公司规定工作时间内迟到早退的次数,按照 次数 * 元/次 = 扣除金额进行计算";
            cell.salaryTF.delegate = self;
            cell.salaryTF.text = self.chiDaoStr;
            cell.salaryTF.tag = 500;
            return cell;
        } else if (indexPath.row == 2) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"缺勤";
            cell.unitLB.text = @"";
            cell.salaryLB.text = @"在公司规定的工作时间内出现缺勤情况，按照 基本薪资／当月工作天数*缺勤天数 = 缺勤应扣款 进行计算";
            [cell.salaryLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(40*KAdaptiveRateWidth);
                make.top.equalTo(cell.nameLB.mas_bottom).offset(10);
                make.right.equalTo(cell.mas_right).offset(-40*KAdaptiveRateWidth);
            }];
            [cell layoutIfNeeded];
            cell.salaryTF.delegate = self;
            cell.salaryTF.text = self.queQinStr;
            cell.salaryTF.enabled = NO;
            cell.salaryTF.hidden = YES;
            cell.salaryTF.tag = 600;
            return cell;
        } else if (indexPath.row == 3) {
            paySetOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[paySetOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.nameLB.text = @"旷工";
            cell.unitLB.text = @"日薪倍数";
            cell.salaryLB.text = @"根据员工在公司规定工作时间内旷工(正常工作日内无请假或请假不通过的缺勤行为)的次数，按照 次数*基本薪资／当月工作日天数*设置倍数 = 扣除金额 进行计算";
            cell.salaryTF.delegate = self;
            cell.salaryTF.placeholder = @"输入倍数";
            cell.salaryTF.text = self.kuangGongStr;
            cell.salaryTF.tag = 700;
            return cell;
        }
    }
    
    return cell;
}

- (void)clickDeleteService:(UIButton *)sender {
    
    NSString *keyStr = [NSString stringWithFormat:@"%ld",self.sevicePay];
    [self.serviceDic removeObjectForKey:keyStr];
    
    self.sevicePay = self.sevicePay-1;
    self.rows = 7+self.sevicePay+self.allPay;
    self.isEnableService = 1;
    
    [self.paySetTableView reloadData];

}
- (void)clickAddService:(UIButton *)sender {
    self.sevicePay = self.sevicePay+1;
    self.rows = 7+self.sevicePay+self.allPay;
    self.isEnableService = 0;
    [self.paySetTableView reloadData];
}
- (void)clickDeleteAllPay:(UIButton *)sender {
    
    NSString *keyStr = [NSString stringWithFormat:@"%ld",self.allPay];
    [self.allPayDic removeObjectForKey:keyStr];
    
    self.allPay = self.allPay-1;
    self.rows = 7+self.sevicePay+self.allPay;
    self.isEnableAllpay = 1;
    [self.paySetTableView reloadData];
}
- (void)clickAddAllPay:(UIButton *)sender {
    
    self.allPay = self.allPay+1;
    self.rows = 7+self.sevicePay+self.allPay;
    self.isEnableAllpay = 0;
    [self.paySetTableView reloadData];
    
}
//点击完成
- (void)ClickCompletion {
    [self.dataArr removeAllObjects];
    [self.paySetTableView endEditing:YES];
    NSDictionary *dic = [self.serviceDic objectForKey:@"1"];
    if (dic) {
        NSString *minValue = [NSString stringWithFormat:@"%@",dic[@"1"]];
        NSString *maxValue = [NSString stringWithFormat:@"%@",dic[@"2"]];
        if ([Utils isBlankString:minValue] || [Utils isBlankString:maxValue]) {
            [MBProgressHUD showError:@"请填写服务费提成方式"];
        } else {
            NSString *lastKey = [NSString stringWithFormat:@"%ld",[self.serviceDic allKeys].count];
            NSDictionary *lastDic = [self.serviceDic objectForKey:lastKey];
            NSString *minValue = [NSString stringWithFormat:@"%@",lastDic[@"1"]];
            NSString *maxValue = [NSString stringWithFormat:@"%@",lastDic[@"2"]];
            if (![Utils isBlankString:minValue] && ![Utils isBlankString:maxValue]) {
                NSDictionary *dic1 = [self.allPayDic objectForKey:@"1"];
                if (dic1) {
                    NSString *minValue = [NSString stringWithFormat:@"%@",dic1[@"1"]];
                    NSString *maxValue = [NSString stringWithFormat:@"%@",dic1[@"2"]];
                    if ([Utils isBlankString:minValue] || [Utils isBlankString:maxValue]) {
                        [MBProgressHUD showError:@"请填写放款总额提成方式"];
                    } else {
                        NSString *lastKey = [NSString stringWithFormat:@"%ld",[self.allPayDic allKeys].count];
                        NSDictionary *lastDic = [self.allPayDic objectForKey:lastKey];
                        NSString *minValue = [NSString stringWithFormat:@"%@",lastDic[@"1"]];
                        NSString *maxValue = [NSString stringWithFormat:@"%@",lastDic[@"2"]];
                        if (![Utils isBlankString:minValue] && ![Utils isBlankString:maxValue]) {
                            for (int i = 1; i <= [self.serviceDic allKeys].count ; i++ ) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                NSDictionary *dic2 = [self.serviceDic objectForKey:[NSString stringWithFormat:@"%d",i]];
                                muDic[@"commission"] = @"3";
                                muDic[@"minValue"] = [NSString stringWithFormat:@"%@",dic2[@"1"]];
                                muDic[@"maxValue"] = [NSString stringWithFormat:@"%@",dic2[@"2"]];
                                if (![Utils isBlankString:[NSString stringWithFormat:@"%@",dic2[@"3"]]]) {
                                    muDic[@"value"] = [NSString stringWithFormat:@"%@",dic2[@"3"]];
                                } else {
                                    muDic[@"value"] = @"0";
                                }
                                
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"2";
                                [self.dataArr addObject:muDic];
                            }
                            for (int i = 1; i <= [self.allPayDic allKeys].count ; i++ ) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                NSDictionary *dic3 = [self.allPayDic objectForKey:[NSString stringWithFormat:@"%d",i]];
                                muDic[@"commission"] = @"4";
                                muDic[@"minValue"] = [NSString stringWithFormat:@"%@",dic3[@"1"]];
                                muDic[@"maxValue"] = [NSString stringWithFormat:@"%@",dic3[@"2"]];
                                if (![Utils isBlankString:[NSString stringWithFormat:@"%@",dic3[@"3"]]]) {
                                    muDic[@"value"] = [NSString stringWithFormat:@"%@",dic3[@"3"]];
                                } else {
                                    muDic[@"value"] = @"0";
                                }
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"2";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.jianStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"1";
                                muDic[@"value"] = self.jianStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"1";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.liangStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"2";
                                muDic[@"value"] = self.liangStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"2";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.jiaBanStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"5";
                                muDic[@"name"] = @"加班补贴";
                                muDic[@"value"] = self.jiaBanStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"5";
                                muDic[@"name"] = @"加班补贴";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.quanQinStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"6";
                                muDic[@"name"] = @"全勤奖";
                                muDic[@"value"] = self.quanQinStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"6";
                                muDic[@"name"] = @"全勤奖";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.chiDaoStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"7";
                                muDic[@"name"] = @"迟到早退";
                                muDic[@"value"] = self.chiDaoStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"7";
                                muDic[@"name"] = @"迟到早退";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.queQinStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"8";
                                muDic[@"name"] = @"缺勤";
                                muDic[@"value"] = self.queQinStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"8";
                                muDic[@"name"] = @"缺勤";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            }
                            if (![Utils isBlankString:self.kuangGongStr]) {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"9";
                                muDic[@"name"] = @"旷工";
                                muDic[@"value"] = self.kuangGongStr;
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"1";
                                [self.dataArr addObject:muDic];
                            } else {
                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
                                muDic[@"commission"] = @"9";
                                muDic[@"name"] = @"旷工";
                                muDic[@"value"] = @"0";
                                muDic[@"mech_id"] = self.mech_id;
                                muDic[@"unit"] = @"3";
                                [self.dataArr addObject:muDic];
                            }
//                            if (![Utils isBlankString:self.qingJiaStr]) {
//                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
//                                muDic[@"commission"] = @"10";
//                                muDic[@"name"] = @"请假";
//                                muDic[@"value"] = self.qingJiaStr;
//                                muDic[@"mech_id"] = self.mech_id;
//                                muDic[@"unit"] = @"1";
//                                [self.dataArr addObject:muDic];
//                            } else {
//                                NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithCapacity:0];
//                                muDic[@"commission"] = @"10";
//                                muDic[@"name"] = @"请假";
//                                muDic[@"value"] = @"0";
//                                muDic[@"mech_id"] = self.mech_id;
//                                muDic[@"unit"] = @"1";
//                                [self.dataArr addObject:muDic];
//                            }
                            
                            [self addPaySetWithArr:self.dataArr];
                            
                        } else {
                            [MBProgressHUD showError:@"请完整放款总额提成方式"];
                        }
                    }
                } else {
                    [MBProgressHUD showError:@"请填写放款总额提成方式"];
                }
            } else {
                [MBProgressHUD showError:@"请完整服务费提成方式"];
            }
        }
    } else {
        [MBProgressHUD showError:@"请填写服务费提成方式"];
    }
    
}
- (void)addPaySetWithArr:(NSMutableArray *)arr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"appWelfares"] = arr;
    dic = [NSDictionary changeType:dic];
    [HttpRequestEngine addPaySetWithDic:dic completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            [MBProgressHUD showSuccess:@"设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
//- (void)mendPaySetWithArr:(NSMutableArray *)arr {
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    dic[@"appWelfares"] = arr;
//    [HttpRequestEngine mendPaySetWithDic:dic completion:^(id obj, NSString *errorStr) {
//        if (![Utils isBlankString:errorStr]) {
//            
//        } else {
//            [MBProgressHUD showError:errorStr];
//        }
//    }];
//}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    BOOL a = textField.tag/10000;
    if (!a) {
        if (textField.tag/1000) {
            NSString *tagStr = [NSString stringWithFormat:@"%ld",textField.tag/1000];
            NSMutableDictionary *dic = [self.serviceDic objectForKey:tagStr];
            NSString *tagString = [NSString stringWithFormat:@"%ld",textField.tag%1000];
            if (!dic) {
                dic = [NSMutableDictionary dictionaryWithCapacity:0];
                
                
                if (![Utils isBlankString:textField.text]) {
                    if (![tagStr isEqualToString:@"1"]) {
                        NSString *topTag = [NSString stringWithFormat:@"%g",[tagStr floatValue]-1];
                        NSMutableDictionary *dicTwo = [self.serviceDic objectForKey:topTag];
                        NSString *topMaxValue = [dicTwo objectForKey:@"2"];
                        if (![tagString isEqualToString:@"3"]) {
                            if ([topMaxValue floatValue] >= [textField.text floatValue]) {
                                textField.text = @"";
                                UIButton *btn = [self.paySetTableView viewWithTag:999];
                                btn.enabled = NO;
                                self.isEnableService = 0;
                                [MBProgressHUD showError:@"不能小于等于上一区间最大值"];
                                return ;
                            } else {
                                [dic setObject:textField.text forKey:tagString];
                            }
                        }
                    }
                    if ([tagString isEqualToString:@"3"]) {
                        if ([textField.text floatValue] > 100.0) {
                            textField.text = @"100";
                        }
                        [dic setObject:textField.text forKey:tagString];
                    }
                    if ([tagString isEqualToString:@"2"]) {
                        NSString *minValue = [dic objectForKey:@"1"];
                        
                        if (![Utils isBlankString:minValue]) {
                            if ([minValue floatValue]<[textField.text floatValue]) {
                                [dic setObject:textField.text forKey:@"2"];
                            } else {
                                textField.text = @"";
                                UIButton *btn = [self.paySetTableView viewWithTag:999];
                                btn.enabled = NO;
                                self.isEnableService = 0;
                                [MBProgressHUD showError:@"不能小于最小值"];
                                return;
                            }
                        } else {
                            [dic setObject:textField.text forKey:@"2"];
                        }
                    }
                    if ([tagString isEqualToString:@"1"]) {
                        NSString *maxValue = [dic objectForKey:@"2"];
                        if (![Utils isBlankString:maxValue]) {
                            if ([maxValue floatValue]>[textField.text floatValue]) {
                                [dic setObject:textField.text forKey:@"1"];
                            } else {
                                textField.text = @"";
                                UIButton *btn = [self.paySetTableView viewWithTag:999];
                                btn.enabled = NO;
                                self.isEnableService = 0;
                                [MBProgressHUD showError:@"不能大于最大值"];
                                return;
                            }
                        } else {
                            [dic setObject:textField.text forKey:@"1"];
                        }
                    }
                }
                [self.serviceDic setObject:dic forKey:tagStr];
            } else{
                
                if (![Utils isBlankString:textField.text]) {
                    if (![tagStr isEqualToString:@"1"]) {
                        NSString *topTag = [NSString stringWithFormat:@"%g",[tagStr floatValue]-1];
                        NSMutableDictionary *dicTwo = [self.serviceDic objectForKey:topTag];
                        NSString *topMaxValue = [dicTwo objectForKey:@"2"];
                        if (![tagString isEqualToString:@"3"]) {
                            if ([topMaxValue floatValue] >= [textField.text floatValue]) {
                                textField.text = @"";
                                [dic removeObjectForKey:tagString];
                                UIButton *btn = [self.paySetTableView viewWithTag:999];
                                btn.enabled = NO;
                                self.isEnableService = 0;
                                [MBProgressHUD showError:@"不能小于等于上一区间最大值"];
                                return ;
                            } else {
                                [dic setObject:textField.text forKey:tagString];
                            }
                        }
                    }
                    if ([tagString isEqualToString:@"3"]) {
                        
                        if ([textField.text floatValue] > 100.0) {
                            textField.text = @"100";
                        }
                        [dic setObject:textField.text forKey:tagString];
                    }
                    if ([tagString isEqualToString:@"2"]) {
                        NSString *minValue = [dic objectForKey:@"1"];
                        
                        if (![Utils isBlankString:minValue]) {
                            if ([minValue floatValue]<[textField.text floatValue]) {
                                [dic setObject:textField.text forKey:@"2"];
                            } else {
                                textField.text = @"";
                                [dic removeObjectForKey:tagString];
                                UIButton *btn = [self.paySetTableView viewWithTag:999];
                                btn.enabled = NO;
                                self.isEnableService = 0;
                                [MBProgressHUD showError:@"不能小于最小值"];
                                return;
                            }
                        } else {
                            [dic setObject:textField.text forKey:@"2"];
                        }
                    }
                    if ([tagString isEqualToString:@"1"]) {
                        NSString *maxValue = [dic objectForKey:@"2"];
                        if (![Utils isBlankString:maxValue]) {
                            if ([maxValue floatValue]>[textField.text floatValue]) {
                                [dic setObject:textField.text forKey:@"1"];
                            } else {
                                textField.text = @"";
                                [dic removeObjectForKey:tagString];
                                UIButton *btn = [self.paySetTableView viewWithTag:999];
                                btn.enabled = NO;
                                self.isEnableService = 0;
                                [MBProgressHUD showError:@"不能大于最大值"];
                                return;
                            }
                        } else {
                            [dic setObject:textField.text forKey:@"1"];
                        }
                    }
                } else {
                    UIButton *btn = [self.paySetTableView viewWithTag:999];
                    btn.enabled = NO;
                    self.isEnableService = 0;
                    [dic removeObjectForKey:tagString];
                }
                
            }
            NSString *minValue = [NSString stringWithFormat:@"%@",dic[@"1"]];
            NSString *maxValue = [NSString stringWithFormat:@"%@",dic[@"2"]];
            if (![Utils isBlankString:minValue] && ![Utils isBlankString:maxValue]) {
                UIButton *btn = [self.paySetTableView viewWithTag:999];
                btn.enabled = YES;
                self.isEnableService = 1;
            }
        } else {
            //这里是件和量的textField执行的方法
            if (![Utils isBlankString:textField.text]) {
                switch (textField.tag) {
                    case 100:
                        self.jianStr = textField.text;
                        break;
                    case 200:
                        self.liangStr = textField.text;
                        break;
                    case 300:
                        self.jiaBanStr = textField.text;
                        break;
                    case 400:
                        self.quanQinStr = textField.text;
                        break;
                    case 500:
                        self.chiDaoStr = textField.text;
                        break;
                    case 600:
                        self.queQinStr = textField.text;
                        break;
                    case 700:
                        self.kuangGongStr = textField.text;
                        break;
                    case 800:
                        self.qingJiaStr = textField.text;
                        break;
                }
            }
        }
        
    } else {
        
        NSString *tagStr = [NSString stringWithFormat:@"%ld",textField.tag/10000];
        NSMutableDictionary *dic = [self.allPayDic objectForKey:tagStr];
        NSString *tagString = [NSString stringWithFormat:@"%ld",textField.tag%10000];
        if (!dic) {
            dic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            if (![Utils isBlankString:textField.text]) {
                if (![tagStr isEqualToString:@"1"]) {
                    NSString *topTag = [NSString stringWithFormat:@"%g",[tagStr floatValue]-1];
                    NSMutableDictionary *dicTwo = [self.allPayDic objectForKey:topTag];
                    NSString *topMaxValue = [dicTwo objectForKey:@"2"];
                    if (![tagString isEqualToString:@"3"]) {
                        if ([topMaxValue floatValue] >= [textField.text floatValue]) {
                            textField.text = @"";
                            UIButton *btn = [self.paySetTableView viewWithTag:9999];
                            btn.enabled = NO;
                            self.isEnableAllpay = 0;
                            [MBProgressHUD showError:@"不能小于等于上一区间最大值"];
                            return;
                        } else {
                            [dic setObject:textField.text forKey:tagString];
                        }
                    }
                }
                if ([tagString isEqualToString:@"3"]) {
                    if ([textField.text floatValue] > 100.0) {
                        textField.text = @"100";
                    }
                    [dic setObject:textField.text forKey:tagString];
                }
                if ([tagString isEqualToString:@"2"]) {
                    NSString *minValue = [dic objectForKey:@"1"];
                    if (![Utils isBlankString:minValue]) {
                        if ([minValue floatValue]<[textField.text floatValue]) {
                            [dic setObject:textField.text forKey:@"2"];
                        } else {
                            textField.text = @"";
                            UIButton *btn = [self.paySetTableView viewWithTag:9999];
                            btn.enabled = NO;
                            self.isEnableAllpay = 0;
                            [MBProgressHUD showError:@"不能小于最小值"];
                            return;
                        }
                    } else {
                        [dic setObject:textField.text forKey:@"2"];
                    }
                }
                if ([tagString isEqualToString:@"1"]) {
                    NSString *maxValue = [dic objectForKey:@"2"];
                    if (![Utils isBlankString:maxValue]) {
                        if ([maxValue floatValue]>[textField.text floatValue]) {
                            [dic setObject:textField.text forKey:@"1"];
                        } else {
                            textField.text = @"";
                            UIButton *btn = [self.paySetTableView viewWithTag:9999];
                            btn.enabled = NO;
                            self.isEnableAllpay = 0;
                            [MBProgressHUD showError:@"不能大于最大值"];
                            return;
                        }
                    } else {
                        [dic setObject:textField.text forKey:@"1"];
                    }
                }
            }
            [self.allPayDic setObject:dic forKey:tagStr];
        } else{
            if (![Utils isBlankString:textField.text]) {
                if (![tagStr isEqualToString:@"1"]) {
                    NSString *topTag = [NSString stringWithFormat:@"%g",[tagStr floatValue]-1];
                    NSMutableDictionary *dicTwo = [self.allPayDic objectForKey:topTag];
                    NSString *topMaxValue = [dicTwo objectForKey:@"2"];
                    if (![tagString isEqualToString:@"3"]) {
                        if ([topMaxValue floatValue] >= [textField.text floatValue]) {
                            textField.text = @"";
                            UIButton *btn = [self.paySetTableView viewWithTag:9999];
                            btn.enabled = NO;
                            self.isEnableAllpay = 0;
                            [MBProgressHUD showError:@"不能小于等于上一区间最大值"];
                            return ;
                        } else {
                            [dic setObject:textField.text forKey:tagString];
                        }
                    }
                }
                if ([tagString isEqualToString:@"3"]) {
                    
                    if ([textField.text floatValue] > 100.0) {
                        textField.text = @"100";
                    }
                    [dic setObject:textField.text forKey:tagString];
                }
                if ([tagString isEqualToString:@"2"]) {
                    NSString *minValue = [dic objectForKey:@"1"];
                    if (![Utils isBlankString:minValue]) {
                        if ([minValue floatValue]<[textField.text floatValue]) {
                            [dic setObject:textField.text forKey:@"2"];
                        } else {
                            textField.text = @"";
                            [dic removeObjectForKey:tagString];
                            UIButton *btn = [self.paySetTableView viewWithTag:9999];
                            btn.enabled = NO;
                            self.isEnableAllpay = 0;
                            [MBProgressHUD showError:@"不能小于最小值"];
                            return;
                        }
                    } else {
                        [dic setObject:textField.text forKey:@"2"];
                    }
                }
                if ([tagString isEqualToString:@"1"]) {
                    NSString *maxValue = [dic objectForKey:@"2"];
                    if (![Utils isBlankString:maxValue]) {
                        if ([maxValue floatValue]>[textField.text floatValue]) {
                            [dic setObject:textField.text forKey:@"1"];
                        } else {
                            textField.text = @"";
                            [dic removeObjectForKey:tagString];
                            UIButton *btn = [self.paySetTableView viewWithTag:9999];
                            btn.enabled = NO;
                            self.isEnableAllpay = 0;
                            [MBProgressHUD showError:@"不能大于最大值"];
                            return;
                        }
                    } else {
                        [dic setObject:textField.text forKey:@"1"];
                    }
                }
            } else {
                UIButton *btn = [self.paySetTableView viewWithTag:9999];
                btn.enabled = NO;
                self.isEnableAllpay = 0;
                [dic removeObjectForKey:tagString];
            }
            
        }
        
        NSString *minValue = [NSString stringWithFormat:@"%@",dic[@"1"]];
        NSString *maxValue = [NSString stringWithFormat:@"%@",dic[@"2"]];
        if (![Utils isBlankString:minValue] && ![Utils isBlankString:maxValue]) {
            UIButton *btn = [self.paySetTableView viewWithTag:9999];
            btn.enabled = YES;
            self.isEnableAllpay = 1;
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return [self validateNumber:string text:textField.text floatCount:2];;
}

- (BOOL)validateNumber:(NSString*)number text:(NSString *)textFieldText floatCount:(NSInteger)floatCount {
    
    BOOL res = YES;
    
    
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    int i = 0;
    
    if (number.length==0) {
        
        //允许删除
        
        return  YES;
        
    }
    
    while (i < number.length) {
        
        //确保是数字
        
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        
        if (range.length == 0) {
            
            res = NO;
            
            break;
            
        }
        
        i++;
        
    }
    
    
    if (textFieldText.length==0) {
        
        //第一个不能是0和.
        
        if ([number isEqualToString:@"0"]||[number isEqualToString:@"."]) {
            
            return NO;
            
        }
        
    }
    
    NSArray *array = [textFieldText componentsSeparatedByString:@"."];
    
    NSInteger count = [array count] ;
    
    //小数点只能有一个
    
    if (count>1&&[number isEqualToString:@"."]) {
        
        return NO;
        
    }
    
    //控制小数点后面的字数
    
    if ([textFieldText rangeOfString:@"."].location!=NSNotFound) {
        
        if (textFieldText.length-[textFieldText rangeOfString:@"."].location>floatCount) {
            
            return NO;
            
        }
        
    }
    
    if (textFieldText.length >= 11) {
        return NO;
    }
    
    return res;
    
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
