//
//  siftingView.m
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "siftingView.h"

@implementation siftingView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        _datePickerView = [[DatePickerView alloc]initWithCustomeHeight:250];
        _siftingOnePicker = [[siftingOnePickerView alloc] initWithCustomeHeight:250];
        _siftingTwoPicker = [[siftingTwoPickerView alloc] initWithCustomeHeight:250];
        _datePickerOne = [[DatePickerOneView alloc]initWithCustomeHeight:250];
        _datePickerTwo = [[DatePickerOneView alloc]initWithCustomeHeight:250];
        self.isSifting = 1;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, NaviHeight)];
    topView.backgroundColor = [UIColor clearColor];
    [self addSubview:topView];
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [topView addGestureRecognizer:tapGR1];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 335)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UITextField *nameTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-36, 54)];
    nameTf.backgroundColor = [UIColor whiteColor];
    nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTf.tag = 1;
    nameTf.delegate = self;
    [backView addSubview:nameTf];
    nameTf.placeholder = @"搜索姓名或手机号";
    nameTf.delegate = self;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 54, kScreenWidth-15, 0.28)];
    line.backgroundColor = GRAY190;
    [backView addSubview:line];
    
    self.siftingTbaleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, kScreenWidth,220) style:UITableViewStylePlain];
    self.siftingTbaleView.bounces = NO;
    self.siftingTbaleView.delegate = self;
    self.siftingTbaleView.dataSource = self;
    [backView addSubview:self.siftingTbaleView];
    
    self.siftingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.siftingBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [self.siftingBtn setBackgroundImage:[UIImage imageWithColor:MYORANGE] forState:UIControlStateNormal];
    [self.siftingBtn setBackgroundImage:[UIImage imageWithColor:VIEW_BASE_COLOR] forState:UIControlStateHighlighted];
    [self addSubview:self.siftingBtn];
    self.siftingBtn.layer.masksToBounds = YES;
    [self.siftingBtn.layer setCornerRadius:5];
    [self.siftingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.siftingTbaleView.mas_bottom).offset(10);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [self.siftingBtn addTarget:self action:@selector(siftingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    [self.cleanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [backView addSubview:self.cleanBtn];
    [self.cleanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.siftingTbaleView.mas_bottom).offset(10);
        make.left.equalTo(self.siftingBtn.mas_right).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [self.cleanBtn addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 335, kScreenWidth, kScreenHeight-NaviHeight-335)];
    self.bgView.backgroundColor = customBackColor;
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tapGR];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = GRAY150;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UITextField *siftingTF1 = [cell viewWithTag:indexPath.row+2];
    [siftingTF1 removeFromSuperview];
    
    
    UITextField *siftingTF = [[UITextField alloc] init];
    [cell addSubview:siftingTF];
    siftingTF.tag = indexPath.row+2;
    siftingTF.delegate = self;
    siftingTF.textAlignment = NSTextAlignmentRight;
    siftingTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [siftingTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.mas_right).offset(-30);
        make.left.equalTo(cell.textLabel.mas_left).offset(30);
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
    }];
    
    __weak typeof (self) weakSelf = self;
    
    
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"审批单类型";
            siftingTF.placeholder = @"请选择审批单类型";
            
            siftingTF.text = self.OneStr;
            
            _siftingOnePicker.confirmOneBlock = ^(NSString *choseStr) {
                
                siftingTF.text = choseStr;
                [weakSelf endEditing:YES];
//                if ([weakSelf.OneStr isEqualToString:@"报销审批"]) {
//                    weakSelf.application_id = @"1";
//                } else if ([weakSelf.OneStr isEqualToString:@"请假审批"]) {
//                    weakSelf.application_id = @"2";
//                } else if ([weakSelf.OneStr isEqualToString:@"离职审批"]) {
//                    weakSelf.application_id = @"3";
//                } else if ([weakSelf.OneStr isEqualToString:@"转正审批"]) {
//                    weakSelf.application_id = @"4";
//                } else if ([weakSelf.OneStr isEqualToString:@"加班审批"]) {
//                    weakSelf.application_id = @"5";
//                } else if ([weakSelf.OneStr isEqualToString:@"出差审批"]) {
//                    weakSelf.application_id = @"6";
//                } else if ([weakSelf.OneStr isEqualToString:@"补打卡审批"]) {
//                    weakSelf.application_id = @"7";
//                } else if ([weakSelf.OneStr isEqualToString:@"采购审批"]) {
//                    weakSelf.application_id = @"8";
//                } else if ([weakSelf.OneStr isEqualToString:@"普通审批"]) {
//                    weakSelf.application_id = @"9";
//                }
            };
            
            _siftingOnePicker.cannelOneBlock = ^(){
                [weakSelf endEditing:YES];
            };
            siftingTF.inputView = _siftingOnePicker;
            
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"审批状态";
            siftingTF.placeholder = @"请选择审批状态";
            
            siftingTF.text = self.TwoStr;
            
            _siftingTwoPicker.confirmTwoBlock = ^(NSString *choseStr) {
                
                siftingTF.text = choseStr;
                [weakSelf endEditing:YES];
            };
            
            _siftingTwoPicker.cannelTwoBlock = ^(){
                [weakSelf endEditing:YES];
                
            };
            siftingTF.inputView = _siftingTwoPicker;
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"开始日期";
            siftingTF.placeholder = @"请选择开始日期";
            
            siftingTF.text = self.ThreeStr;
            
            _datePickerOne.confirmBlock = ^(NSString *choseDate, NSString *restDate) {
                
                siftingTF.text = choseDate;
                [weakSelf endEditing:YES];
            };
            
            _datePickerOne.cannelBlock = ^(){
                [weakSelf endEditing:YES];
                
            };
            siftingTF.inputView = _datePickerOne;
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"结束日期";
            siftingTF.placeholder = @"请选择结束日期";
            
            siftingTF.text = self.FourStr;
            
            _datePickerTwo.confirmBlock = ^(NSString *choseDate, NSString *restDate) {
                
                siftingTF.text = choseDate;
                [weakSelf endEditing:YES];
                
            };
            
            _datePickerTwo.cannelBlock = ^(){
                [weakSelf endEditing:YES];
                
            };
            siftingTF.inputView = _datePickerTwo;
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 1:
            self.nameStr = textField.text;
            break;
        case 2:
            self.OneStr = textField.text;
            if ([self.OneStr isEqualToString:@"报销审批"]) {
                self.application_id = @"1";
            } else if ([self.OneStr isEqualToString:@"请假审批"]) {
                self.application_id = @"2";
            } else if ([self.OneStr isEqualToString:@"离职审批"]) {
                self.application_id = @"3";
            } else if ([self.OneStr isEqualToString:@"转正审批"]) {
                self.application_id = @"4";
            } else if ([self.OneStr isEqualToString:@"加班审批"]) {
                self.application_id = @"5";
            } else if ([self.OneStr isEqualToString:@"出差审批"]) {
                self.application_id = @"6";
            } else if ([self.OneStr isEqualToString:@"补打卡审批"]) {
                self.application_id = @"7";
            } else if ([self.OneStr isEqualToString:@"采购审批"]) {
                self.application_id = @"8";
            } else if ([self.OneStr isEqualToString:@"普通审批"]) {
                self.application_id = @"9";
            }
            
            break;
        case 3:
            self.TwoStr = textField.text;
            if ([self.TwoStr isEqualToString:@"全部"]) {
                self.state_type = @"";
            } else if ([self.TwoStr isEqualToString:@"未提交"]) {
                self.state_type = @"1";
            } else if ([self.TwoStr isEqualToString:@"撤回"]) {
                self.state_type = @"2";
            } else if ([self.TwoStr isEqualToString:@"审批中"]) {
                self.state_type = @"3";
            } else if ([self.TwoStr isEqualToString:@"驳回"]) {
                self.state_type = @"4";
            } else if ([self.TwoStr isEqualToString:@"审批通过"]) {
                self.state_type = @"5";
            } else {
                self.state_type = @"";
            }
            break;
        case 4:
            self.ThreeStr = textField.text;
            break;
        case 5:
            self.FourStr = textField.text;
            break;
        default:
            break;
    }
}
- (void)siftingBtnClick {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (![Utils isBlankString:self.nameStr]) {
        dic[@"searchName"] = self.nameStr;
    }
    if (![Utils isBlankString:self.OneStr]) {
        dic[@"application_id"] = self.application_id;
    }
    if (![Utils isBlankString:self.state_type]) {
        dic[@"state_type"] = self.state_type;
    }
    if (![Utils isBlankString:self.ThreeStr]) {
        dic[@"start_time"] = self.ThreeStr;
    }
    if (![Utils isBlankString:self.FourStr]) {
        dic[@"end_time"] = self.FourStr;
    }
    
    if (self.siftBlock != nil) {
        self.siftBlock(dic);
    }
    self.isSifting = 1;
}
- (void)cleanBtnClick {
    UITextField *nameTf = [self viewWithTag:1];
    nameTf.text = @"";
    self.nameStr = @"";
    self.OneStr = @"";
    self.TwoStr = @"";
    self.ThreeStr = @"";
    self.FourStr = @"";
    [self.siftingTbaleView reloadData];
    if (self.isSifting == 1) {
        self.isSifting = 0;
    }
}
- (void)tapBgView {
    if (!self.isSifting) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        if (self.siftBlock != nil) {
            self.siftBlock(dic);
        }
        self.isSifting = 1;
    } else {
        if (self.hideBlock != nil) {
            self.hideBlock();
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
