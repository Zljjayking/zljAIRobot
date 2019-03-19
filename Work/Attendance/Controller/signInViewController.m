//
//  signInViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/7.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "signInViewController.h"
#import "paySetTitleTableViewCell.h"
#import "signInSetTableViewCell.h"
#import "signInChangeTableViewCell.h"
#import "tolerantTableViewCell.h"
#import "signInModel.h"
#import "signTimePickerView.h"
#import "approvalTypePicker.h"
@interface signInViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SelectDateTimeDelegate>

{
    DateTimeSelectView *_dateTimeSelectView;
}
@property (nonatomic, strong) UITableView *signTableView;
@property (nonatomic, assign) NSInteger type;//1.1天1次 2.1天2次
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView1;
@property (nonatomic, strong) UIView *bottomView1;
@property (nonatomic, strong) UIView *topView2;
@property (nonatomic, strong) UIView *bottomView2;
@property (nonatomic, strong) signInModel *signInModel;
@property (nonatomic, strong) signTimePickerView *timePickerOne;
@property (nonatomic, strong) signTimePickerView *timePickerTwo;
@property (nonatomic, strong) signTimePickerView *timePickerThree;
@property (nonatomic, strong) signTimePickerView *timePickerFour;
@property (nonatomic, strong) approvalTypePicker *signInTimesPickerView;
@property (nonatomic, strong) approvalTypePicker *tolerantPickerView1;
@property (nonatomic, strong) approvalTypePicker *tolerantPickerView2;
@property (nonatomic, strong) approvalTypePicker *tolerantPickerView3;
@end

@implementation signInViewController
- (UITableView *)signTableView {
    if (!_signTableView) {
        _signTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        _signTableView.delegate = self;
        _signTableView.dataSource = self;
        _signTableView.tableFooterView = [UIView new];
        _signTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _signTableView.backgroundColor = GRAY245;
        [_signTableView registerClass:[paySetTitleTableViewCell class] forCellReuseIdentifier:@"title"];
        [_signTableView registerClass:[signInSetTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_signTableView registerClass:[signInChangeTableViewCell class] forCellReuseIdentifier:@"change"];
        [_signTableView registerClass:[tolerantTableViewCell class] forCellReuseIdentifier:@"tolerant"];
    }
    return _signTableView;
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

- (UIView *)topView1 {
    if (!_topView1) {
        _topView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _topView1.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 6, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [_topView1 addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 13, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_topView1 addSubview:backTwoV];
    }
    return _topView1;
}
- (UIView *)bottomView1 {
    if (!_bottomView1) {
        _bottomView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _bottomView1.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [_bottomView1 addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_bottomView1 addSubview:backTwoV];
    }
    return _bottomView1;
}

- (UIView *)topView2 {
    if (!_topView2) {
        _topView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _topView2.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 6, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [_topView2 addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 13, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_topView2 addSubview:backTwoV];
    }
    return _topView2;
}
- (UIView *)bottomView2 {
    if (!_bottomView2) {
        _bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _bottomView2.backgroundColor = VIEW_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 14)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 7;
        [_bottomView2 addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(7*KAdaptiveRateWidth, 0, kScreenWidth-14*KAdaptiveRateWidth, 7)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_bottomView2 addSubview:backTwoV];
    }
    return _bottomView2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到管理";
    self.type = 2;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickCompletion)];
    self.navigationItem.rightBarButtonItem = one;
    self.signInModel = [signInModel new];
    [self requestSignInConfiguration];
    [self.view addSubview:self.signTableView];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    self.timePickerOne = [[signTimePickerView alloc]initWithCustomeHeight:250];
//    self.timePickerTwo = [[signTimePickerView alloc]initWithCustomeHeight:250];
//    self.timePickerThree = [[signTimePickerView alloc]initWithCustomeHeight:250];
//    self.timePickerFour = [[signTimePickerView alloc]initWithCustomeHeight:250];
    NSArray *signInTimesArr = @[@"2",@"4"];
    NSArray *tolerantArr1 = @[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35",@"40"];
    NSArray *tolerantArr2 = @[@"40",@"45",@"50",@"55",@"60",@"65",@"70",@"75",@"80",@"85",@"90",@"95",@"100",@"105",@"110",@"115",@"120"];
    
    self.signInTimesPickerView = [[approvalTypePicker alloc] initWithCustomeHeight:250 titleArray:signInTimesArr];
    self.tolerantPickerView1 = [[approvalTypePicker alloc] initWithCustomeHeight:250 titleArray:tolerantArr1];
    self.tolerantPickerView2 = [[approvalTypePicker alloc] initWithCustomeHeight:250 titleArray:tolerantArr2];
    self.tolerantPickerView3 = [[approvalTypePicker alloc] initWithCustomeHeight:250 titleArray:tolerantArr2];
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"HH:mm"];
    _dateTimeSelectView.delegateGetDate = self;
    
    [self.signTableView reloadData];
}
- (void)requestSignInConfiguration {
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    [HttpRequestEngine getConfigurationWithMech_id:mech_id Completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            self.signInModel = [signInModel requestWithDic:obj];
            if ([self.signInModel.card_times isEqualToString:@"2"]) {
                self.type = 2;
            } else {
                self.type = 2;//此处为2，没毛病。就是那么任性
            }
            [self.signTableView reloadData];
        } else {
            if ([errorStr isEqualToString:@"无数据"]) {
                self.signInModel.start_time = @"09:00";
                self.signInModel.end_time = @"12:00";
                self.signInModel.start_time_pm = @"13:30";
                self.signInModel.end_time_pm = @"18:00";
                self.signInModel.Id = @"0";
                self.signInModel.late_minute = @"10";
                self.signInModel.early_minute = @"60";
                self.signInModel.absence_minute = @"40";
                self.signInModel.tolerant_time = @"09:10";
                self.signInModel.late_time = @"09:50";
                self.signInModel.leave_early = @"11:10";
                self.signInModel.late_time_pm = @"14:20";
                self.signInModel.leave_early_pm = @"17:10";
                self.signInModel.card_times = @"2";
                NSDictionary *dic = [self getDic];
                if (dic) {
                    [HttpRequestEngine signInConfigurationWithDic:dic completion:^(id obj, NSString *errorStr) {
                        if ([Utils isBlankString:errorStr]) {
                            [self requestSignInConfiguration];
                        } else {
                            [MBProgressHUD showError:errorStr];
                        }
                    }];
                }
            } else {
                [MBProgressHUD showError:errorStr];
            }
        }
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
//        if (self.type == 1) {
//            return 3;
//        } else {
//            return 5;
//        }
        return 5;
    } else if (section == 1) {
        return 2;
    } else {
        return 4;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 15*KAdaptiveRateWidth;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 55;
    }
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.topView;
    }else if (section == 1) {
        return self.topView1;
    }else {
        return self.topView2;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.bottomView;
    }else if (section == 1) {
        return self.bottomView1;
    }else {
        return self.bottomView2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    __weak typeof (self) weakSelf = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
            }
            cell.hehe.backgroundColor = kMyColor(49, 163, 35);
            cell.heheLB.text = @"上下班时间";
            return cell;
        } else {
            if (self.type == 1) {
                if (indexPath.row == 3) {
                    signInChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"change"];
                    if (cell == nil) {
                        cell = [[signInChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"change"];
                    }
                    [cell.changeBtn setTitle:@"切换一天两次上下班" forState:UIControlStateNormal];
                    [cell.changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                } else {
                    signInSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    if (cell == nil) {
                        cell = [[signInSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    }
                    cell.star.hidden = YES;
                    cell.chooseTF.tag = indexPath.row;
                    cell.chooseTF.delegate = self;
                    if (indexPath.row == 1) {
                        cell.titleLabel.text = @"上班时间";
                        
                        if ([Utils isBlankString:self.signInModel.start_time]) {
                            cell.chooseTF.text = @"9:00";
                            self.signInModel.start_time = @"9:00";
                        } else {
                            cell.chooseTF.text = self.signInModel.start_time;
                        }
                        
                        cell.chooseTF.inputView = self.timePickerOne;
                        
                    } else {
                        cell.titleLabel.text = @"下班时间";
                        
                        if ([Utils isBlankString:self.signInModel.end_time_pm]) {
                            cell.chooseTF.text = @"18:00";
                            self.signInModel.end_time_pm = @"18:00";
                        } else {
                            cell.chooseTF.text = self.signInModel.end_time_pm;
                        }
                        
                        cell.chooseTF.inputView = self.timePickerOne;
                    }
                    cell.chooseTF.placeholder = @"点击选择";
                    return cell;
                }
            } else {
                if (indexPath.row == 5) {
                    signInChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"change"];
                    if (cell == nil) {
                        cell = [[signInChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"change"];
                    }
                    [cell.changeBtn setTitle:@"切换一天一次上下班" forState:UIControlStateNormal];
                    [cell.changeBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                } else {
                    signInSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                    if (cell == nil) {
                        cell = [[signInSetTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                    }
                    cell.star.hidden = YES;
                    cell.chooseTF.tag = indexPath.row;
                    cell.chooseTF.delegate = self;
                    if (indexPath.row == 1) {
                        cell.titleLabel.text = @"上午上班时间";
                        
                        if ([Utils isBlankString:self.signInModel.start_time]) {
                            cell.chooseTF.text = @"9:00";
                            self.signInModel.start_time = @"9:00";
                        } else {
                            cell.chooseTF.text = self.signInModel.start_time;
                        }
                        
                        cell.chooseTF.inputView = self.timePickerOne;
                        
                    } else if (indexPath.row == 2) {
                        cell.titleLabel.text = @"上午下班时间";
                        
                        if ([Utils isBlankString:self.signInModel.end_time]) {
                            cell.chooseTF.text = @"12:00";
                            self.signInModel.end_time = @"12:00";
                        } else {
                            cell.chooseTF.text = self.signInModel.end_time;
                        }
                        
                        cell.chooseTF.inputView = self.timePickerOne;
                        
                    } else if (indexPath.row == 3) {
                        cell.titleLabel.text = @"下午上班时间";
                        
                        if ([Utils isBlankString:self.signInModel.start_time_pm]) {
                            cell.chooseTF.text = @"13:30";
                            self.signInModel.start_time_pm = @"13:30";
                        } else {
                            cell.chooseTF.text = self.signInModel.start_time_pm;
                        }
                        
                        
                        cell.chooseTF.inputView = self.timePickerOne;
                        
                    } else {
                        cell.titleLabel.text = @"下午下班时间";
                        cell.chooseTF.text = self.signInModel.end_time_pm;
                        
                        if ([Utils isBlankString:self.signInModel.end_time_pm]) {
                            cell.chooseTF.text = @"18:00";
                            self.signInModel.end_time_pm = @"18:00";
                        } else {
                            cell.chooseTF.text = self.signInModel.end_time_pm;
                        }
                        
                        
                        cell.chooseTF.inputView = self.timePickerOne;
                    }
                    cell.chooseTF.placeholder = @"点击选择";
                    return cell;
                }
            }
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
            }
            cell.hehe.backgroundColor = kMyColor(136, 205, 233);
            cell.heheLB.text = @"打卡次数";
            
            return cell;
        } else {
            
            tolerantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tolerant"];
            if (cell == nil) {
                cell = [[tolerantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tolerant"];
            }
            cell.chooseTF.tag = indexPath.row+20;
            cell.chooseTF.delegate = self;
            cell.chooseTF.placeholder = @"点击选择";
            cell.titleLabel.text = @"每日打卡次数";
            
            if ([self.signInModel.card_times isEqualToString:@"2"]) {
                cell.chooseTF.text = @"2";
            } else if ([self.signInModel.card_times isEqualToString:@"4"]) {
                cell.chooseTF.text = @"4";
            }
            
            self.signInTimesPickerView.confirmOneBlock = ^(NSString *chooseOneState) {
                if ([chooseOneState isEqualToString:@"2"]) {
                    weakSelf.signInModel.card_times = @"2";
                } else {
                    weakSelf.signInModel.card_times = @"4";
                }
                cell.chooseTF.text = chooseOneState;
                
                [weakSelf.signTableView endEditing:YES];
                
            };
            self.signInTimesPickerView.cannelOneBlock = ^{
                [weakSelf.signTableView endEditing:YES];
            };
            
            cell.chooseTF.inputView = self.signInTimesPickerView;
            
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            paySetTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
            if (cell == nil) {
                cell = [[paySetTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
            }
            cell.hehe.backgroundColor = kMyColor(241, 45, 114);
            cell.heheLB.text = @"其他设置";
            return cell;
        } else {
            
            tolerantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tolerant"];
            if (cell == nil) {
                cell = [[tolerantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tolerant"];
            }
            cell.chooseTF.tag = indexPath.row+20;
            cell.chooseTF.delegate = self;
            cell.chooseTF.placeholder = @"点击选择";
            cell.chooseTF.font = [UIFont systemFontOfSize:15];
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"迟到";
                NSString *string = [NSString stringWithFormat:@"上午上班后 %@ 分钟打卡为迟到",self.signInModel.late_minute];
                NSInteger titleLength = [self.signInModel.late_minute length];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:17.0]
                 
                                      range:NSMakeRange(6, titleLength)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:kMyColor(83, 158, 239)
                 
                                      range:NSMakeRange(6, titleLength)];
                
                cell.chooseTF.attributedText = AttributedStr;
                
                self.tolerantPickerView1.confirmOneBlock = ^(NSString *chooseOneState) {
                    NSString *string = [NSString stringWithFormat:@"上午上班后 %@ 分钟打卡为迟到",chooseOneState];
                    
                    NSDate *late_time = [Utils stringToDate:weakSelf.signInModel.start_time withDateFormat:@"HH:mm"];
                    
                    NSDate *late_timeDay = [NSDate dateWithTimeInterval:[chooseOneState integerValue]*60 sinceDate:late_time];//迟到多少分钟
                    
                    weakSelf.signInModel.tolerant_time = [Utils dateToString:late_timeDay withDateFormat:@"HH:mm"];
                    
                    
                    NSInteger titleLength = [chooseOneState length];
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                    
                    [AttributedStr addAttribute:NSFontAttributeName
                     
                                          value:[UIFont systemFontOfSize:17.0]
                     
                                          range:NSMakeRange(6, titleLength)];
                    
                    [AttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                          value:kMyColor(83, 158, 239)
                     
                                          range:NSMakeRange(6, titleLength)];
                    
                    cell.chooseTF.attributedText = AttributedStr;
                    
                    weakSelf.signInModel.late_minute = chooseOneState;
                    
                    [weakSelf.signTableView endEditing:YES];
                    
                };
                self.tolerantPickerView1.cannelOneBlock = ^{
                    [weakSelf.signTableView endEditing:YES];
                };
                cell.chooseTF.inputView = self.tolerantPickerView1;
                
            } else if (indexPath.row == 2) {
                cell.titleLabel.text = @"缺勤";
                
                
                NSString *string = [NSString stringWithFormat:@"上班后 %@ 分钟打卡为缺勤",self.signInModel.absence_minute];
                NSInteger titleLength = [self.signInModel.absence_minute length];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:17.0]
                 
                                      range:NSMakeRange(4, titleLength)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:kMyColor(83, 158, 239)
                 
                                      range:NSMakeRange(4, titleLength)];
                
                cell.chooseTF.attributedText = AttributedStr;
                
                self.tolerantPickerView2.confirmOneBlock = ^(NSString *chooseOneState) {
                    
                    NSDate *late_time = [Utils stringToDate:weakSelf.signInModel.start_time withDateFormat:@"HH:mm"];
                    NSDate *late_timeDay = [NSDate dateWithTimeInterval:[chooseOneState integerValue]*60 sinceDate:late_time];//
                    weakSelf.signInModel.late_time = [Utils dateToString:late_timeDay withDateFormat:@"HH:mm"];
                    
                    NSDate *late_time_pm = [Utils stringToDate:weakSelf.signInModel.start_time_pm withDateFormat:@"HH:mm"];
                    NSDate *late_time_pmDay = [NSDate dateWithTimeInterval:[chooseOneState integerValue]*60 sinceDate:late_time_pm];//
                    weakSelf.signInModel.late_time_pm = [Utils dateToString:late_time_pmDay withDateFormat:@"HH:mm"];
                    
                    NSString *string = [NSString stringWithFormat:@"上班后 %@ 分钟打卡为缺勤",chooseOneState];
                    NSInteger titleLength = [chooseOneState length];
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                    
                    [AttributedStr addAttribute:NSFontAttributeName
                     
                                          value:[UIFont systemFontOfSize:17.0]
                     
                                          range:NSMakeRange(4, titleLength)];
                    
                    [AttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                          value:kMyColor(83, 158, 239)
                     
                                          range:NSMakeRange(4, titleLength)];
                    
                    cell.chooseTF.attributedText = AttributedStr;
                    
                    weakSelf.signInModel.absence_minute = chooseOneState;
                    
                    [weakSelf.signTableView endEditing:YES];
                    
                };
                self.tolerantPickerView2.cannelOneBlock = ^{
                    [weakSelf.signTableView endEditing:YES];
                };
                cell.chooseTF.inputView = self.tolerantPickerView2;
            } else if (indexPath.row == 3) {
                cell.titleLabel.text = @"早退";
                
                
                NSString *string = [NSString stringWithFormat:@"下班前 %@ 分钟打卡为早退",self.signInModel.early_minute];
                NSInteger titleLength = [self.signInModel.early_minute length];
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:17.0]
                 
                                      range:NSMakeRange(4, titleLength)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:kMyColor(83, 158, 239)
                 
                                      range:NSMakeRange(4, titleLength)];
                
                cell.chooseTF.attributedText = AttributedStr;
                
                self.tolerantPickerView3.confirmOneBlock = ^(NSString *chooseOneState) {
                    
                    
                    NSDate *late_time = [Utils stringToDate:weakSelf.signInModel.end_time withDateFormat:@"HH:mm"];
                    NSDate *late_timeDay = [NSDate dateWithTimeInterval:-[chooseOneState integerValue]*60 sinceDate:late_time];//
                    weakSelf.signInModel.leave_early = [Utils dateToString:late_timeDay withDateFormat:@"HH:mm"];
                    
                    NSDate *late_time_pm = [Utils stringToDate:weakSelf.signInModel.end_time_pm withDateFormat:@"HH:mm"];
                    NSDate *late_time_pmDay = [NSDate dateWithTimeInterval:-[chooseOneState integerValue]*60 sinceDate:late_time_pm];//
                    weakSelf.signInModel.leave_early_pm = [Utils dateToString:late_time_pmDay withDateFormat:@"HH:mm"];
                    
                    NSString *string = [NSString stringWithFormat:@"下班前 %@ 分钟打卡为早退",chooseOneState];
                    NSInteger titleLength = [chooseOneState length];
                    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
                    
                    [AttributedStr addAttribute:NSFontAttributeName
                     
                                          value:[UIFont systemFontOfSize:17.0]
                     
                                          range:NSMakeRange(4, titleLength)];
                    
                    [AttributedStr addAttribute:NSForegroundColorAttributeName
                     
                                          value:kMyColor(83, 158, 239)
                     
                                          range:NSMakeRange(4, titleLength)];
                    
                    cell.chooseTF.attributedText = AttributedStr;
                    
                    weakSelf.signInModel.early_minute = chooseOneState;
                    
                    [weakSelf.signTableView endEditing:YES];
                    
                };
                self.tolerantPickerView3.cannelOneBlock = ^{
                    [weakSelf.signTableView endEditing:YES];
                };
                cell.chooseTF.inputView = self.tolerantPickerView3;
            }
            return cell;
        }
    }
    return cell;
}

- (void)changeBtnClick:(UIButton *)sender {
    self.signInModel.start_time = @"";
    self.signInModel.end_time = @"";
    if (self.type == 1) {
        self.type = 2;
        self.signInModel.card_times = @"2";
        self.signInModel.start_time = @"";
        self.signInModel.end_time = @"";
    } else {
        self.type = 1;
        self.signInModel.card_times = @"1";
        self.signInModel.start_time_pm = @"";
        self.signInModel.end_time_pm = @"";
    }
    [self.signTableView reloadData];
}

- (void)ClickCompletion {
    
    NSDictionary *dic = [self getDic];
    
    if (dic) {
        [HttpRequestEngine signInConfigurationWithDic:dic completion:^(id obj, NSString *errorStr) {
            if ([Utils isBlankString:errorStr]) {
                [MBProgressHUD showSuccess:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [MBProgressHUD showError:errorStr];
            }
        }];
    }
}
- (NSDictionary *)getDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"inter"] = @"insertConfig";
    dic[@"mech_id"] = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    if ([Utils isBlankString:self.signInModel.Id]) {
        dic[@"id"] = @"0";
    } else {
        dic[@"id"] = self.signInModel.Id;
    }
    
    dic[@"card_times"] = self.signInModel.card_times;
    if ([Utils isBlankString:self.signInModel.start_time]) {
        [MBProgressHUD showToastText:@"请选择上午上班时间"];
        return nil;
    } else {
        dic[@"start_time"] = self.signInModel.start_time;
    }
    
    if ([Utils isBlankString:self.signInModel.end_time]) {
        [MBProgressHUD showToastText:@"请选择上午下班时间"];
        return nil;
    } else {
        dic[@"end_time"] = self.signInModel.end_time;
    }
    if ([Utils isBlankString:self.signInModel.start_time_pm]) {
        [MBProgressHUD showToastText:@"请选择下午上班时间"];
        return nil;
    } else {
        dic[@"start_time_pm"] = self.signInModel.start_time_pm;
    }
    
    if ([Utils isBlankString:self.signInModel.end_time_pm]) {
        [MBProgressHUD showToastText:@"请选择下午下班时间"];
        return nil;
    } else {
        dic[@"end_time_pm"] = self.signInModel.end_time_pm;
    }
    
    if (![Utils isBlankString:self.signInModel.tolerant_time]) {
        dic[@"tolerant_time"] = self.signInModel.tolerant_time;
    }
    
    dic[@"late_time"] = self.signInModel.late_time;
    dic[@"leave_early"] = self.signInModel.leave_early;
    dic[@"late_time_pm"] = self.signInModel.late_time_pm;
    dic[@"leave_early_pm"] = self.signInModel.leave_early_pm;
    dic[@"late_minute"] = self.signInModel.late_minute;
    dic[@"early_minute"] = self.signInModel.early_minute;
    dic[@"absence_minute"] = self.signInModel.absence_minute;
    
    return dic;
}

#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
//    NSString *time = [NSString stringWithFormat:@"%@",dictDate[@"time"]];

    [self.view endEditing:YES];
    
//    [UIView animateWithDuration:animateTime animations:^{
//        _dateTimeSelectView.frame = hideTimeViewRect;
//    } completion:^(BOOL finished) {
//        _dateTimeSelectView.hidden = YES;
//        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
//    }];
}
- (void)cancelDate {
    
    [self.view endEditing:YES];
    
//    [UIView animateWithDuration:animateTime animations:^{
//        _dateTimeSelectView.frame = hideTimeViewRect;
//    } completion:^(BOOL finished) {
//        _dateTimeSelectView.hidden = YES;
//        self.bgView.hidden = YES;
//        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
//    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    __weak typeof (self) weakSelf = self;
    self.timePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
        
        switch (textField.tag) {
            case 1:
            {
                if (self.type == 1) {
                    weakSelf.signInModel.start_time = choseDate;
                    
                    
                    if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                        //                                NSDate *date = [Utils stringToDate:weakSelf.signInModel.start_time withDateFormat:@"HH:mm"];
                        //                                NSDate *lastDay = [NSDate dateWithTimeInterval:-60 sinceDate:date];//前一分钟
                        [MBProgressHUD showToastText:@"上班时间大于下班时间"];
                        weakSelf.signInModel.start_time = @"";
                    } else {
                        weakSelf.signInModel.start_time = choseDate;
                    }
                } else {
                    weakSelf.signInModel.start_time = choseDate;
                    
                    if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time]) {
                        [MBProgressHUD showToastText:@"上午上班时间大于上午下班时间"];
                        weakSelf.signInModel.start_time = @"";
                    } else {
                        
                        if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.start_time_pm]) {
                            [MBProgressHUD showToastText:@"上午上班时间大于下午上班时间"];
                            weakSelf.signInModel.start_time = @"";
                        } else {
                            if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                                [MBProgressHUD showToastText:@"上午上班时间大于下午下班时间"];
                                weakSelf.signInModel.start_time = @"";
                            } else {
                                weakSelf.signInModel.start_time = choseDate;
                            }
                        }
                        
                    }
                }
                
            }
                break;
            case 2:
            {
                if (self.type == 1) {
                    
                    weakSelf.signInModel.end_time_pm = choseDate;
                    
                    if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                        [MBProgressHUD showToastText:@"下班时间小于上班时间"];
                        weakSelf.signInModel.end_time_pm = @"";
                    } else {
                        weakSelf.signInModel.end_time_pm = choseDate;
                    }

                } else {
                    weakSelf.signInModel.end_time = choseDate;
                    
                    if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time]) {
                        [MBProgressHUD showToastText:@"上午下班时间小于上午上班时间"];
                        weakSelf.signInModel.end_time = @"";
                    } else {
                        
                        if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.end_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.start_time_pm]) {
                            [MBProgressHUD showToastText:@"上午下班时间大于下午上班时间"];
                            weakSelf.signInModel.end_time = @"";
                        } else {
                            if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.end_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                                [MBProgressHUD showToastText:@"上午下班时间大于下午下班时间"];
                                weakSelf.signInModel.end_time = @"";
                            } else {
                                weakSelf.signInModel.end_time = choseDate;
                            }
                        }
                    }
                }
                
            }
                break;
            case 3:
            {
                weakSelf.signInModel.start_time_pm = choseDate;
                
                if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.start_time_pm]) {
                    [MBProgressHUD showToastText:@"下午上班时间小于上午上班时间"];
                    weakSelf.signInModel.start_time_pm = @"";
                } else {
                    
                    if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.end_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.start_time_pm]) {
                        [MBProgressHUD showToastText:@"下午上班时间小于上午下班时间"];
                        weakSelf.signInModel.start_time_pm = @"";
                    } else {
                        if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time_pm DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                            [MBProgressHUD showToastText:@"下午上班时间大于下午下班时间"];
                            weakSelf.signInModel.start_time_pm = @"";
                        } else {
                            weakSelf.signInModel.start_time_pm = choseDate;
                        }
                    }
                    
                }
                
                [weakSelf.signTableView endEditing:YES];            }
                break;
            case 4:
            {
                weakSelf.signInModel.end_time_pm = choseDate;
                
                if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                    [MBProgressHUD showToastText:@"下午下班时间小于上午上班时间"];
                    weakSelf.signInModel.end_time_pm = @"";
                } else {
                    
                    if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.end_time DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                        [MBProgressHUD showToastText:@"下午下班时间大于上午下班时间"];
                        weakSelf.signInModel.end_time_pm = @"";
                    } else {
                        if (![Utils compareTwoTimeWithMinTime:weakSelf.signInModel.start_time_pm DateFormat:@"HH:mm" MaxTime:weakSelf.signInModel.end_time_pm]) {
                            [MBProgressHUD showToastText:@"下午下班时间大于下午上班时间"];
                            weakSelf.signInModel.end_time_pm = @"";
                        } else {
                            weakSelf.signInModel.end_time_pm = choseDate;
                        }
                    }
                }
                
            }
                break;
                
                
            default:
                break;
        }
        
        
        [weakSelf.signTableView endEditing:YES];
        [weakSelf.signTableView reloadData];
    };
    
    self.timePickerOne.cannelBlock = ^(){
        [weakSelf.signTableView endEditing:YES];
    };
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
