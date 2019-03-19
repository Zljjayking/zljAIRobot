//
//  EMInfoDetailViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "EMInfoDetailViewController.h"
#import "employeeInfoModel.h"
#import "employeeContactModel.h"
#import "employeeOneTableViewCell.h"
#import "employeeTwoTableViewCell.h"
#import "employeeThreeTableViewCell.h"
#import "employeeFourTableViewCell.h"
#import "employeeFiveTableViewCell.h"
#import "employeeSixTableViewCell.h"
#import "employeeSevenTableViewCell.h"

#import "DatePickerView.h"
#import "MarriageStatePickerView.h"
#import "EducationPickerView.h"
@interface EMInfoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) employeeContactModel *contactModelOne;
@property (nonatomic, strong) employeeContactModel *contactModelTwo;
@property (nonatomic, strong) employeeInfoModel *infoModel;
@property (nonatomic) NSMutableArray *contactArr;
@property (nonatomic) NSArray *sectionTitleArr;
@property (nonatomic) NSArray *titleArr;

@property (strong,nonatomic) DatePickerView *datePickerView;//时间选择器
@property (strong,nonatomic) EducationPickerView *educationPicker;//发薪形式选择器
@property (nonatomic,strong) MarriageStatePickerView *marriageStatePicker;//婚姻状态选择器

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, strong) UIButton *womenBtn;

@property (nonatomic, strong) UIButton *manBtn;
@end

@implementation EMInfoDetailViewController
static NSString *one = @"one";
static NSString *two = @"two";
static NSString *three = @"three";

-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [[NSMutableDictionary alloc]init];
    }
    return _dataDic;
}


- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.tableFooterView = [UIView new];
        [_detailTableView registerClass:[employeeOneTableViewCell class] forCellReuseIdentifier:@"one"];
        [_detailTableView registerClass:[employeeTwoTableViewCell class] forCellReuseIdentifier:@"two"];
        [_detailTableView registerClass:[employeeThreeTableViewCell class] forCellReuseIdentifier:@"three"];
        [_detailTableView registerClass:[employeeFourTableViewCell class] forCellReuseIdentifier:@"four"];
        [_detailTableView registerClass:[employeeFiveTableViewCell class] forCellReuseIdentifier:@"five"];
        [_detailTableView registerClass:[employeeSixTableViewCell class] forCellReuseIdentifier:@"six"];
        [_detailTableView registerClass:[employeeSevenTableViewCell class] forCellReuseIdentifier:@"seven"];
        [self.view addSubview:_detailTableView];
    }
    return _detailTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工详情";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    _datePickerView = [[DatePickerView alloc]initWithCustomeHeight:250];
    self.contactModelOne = [employeeContactModel new];
    self.contactModelTwo = [employeeContactModel new];
    self.contactArr = [NSMutableArray array];
    self.sectionTitleArr = @[@"基本信息",@"前公司信息",@"联系人信息"];
    self.titleArr = @[@[@"姓名",@"性别",@"出生日期",@"手机号码",@"身份证号码",@"现住宅地址",@"学历",@"婚姻状况",@"家庭住址"],@[@"单位名称",@"职务",@"电话",@"单位地址"],@[@"姓名",@"关系",@"手机号码",@"姓名",@"关系",@"手机号码"]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickComplete)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self requestData];
    // Do any additional setup after loading the view.
}
- (void)requestData {
    [HttpRequestEngine getEmployeeInfoWithUserId:self.userId completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dic = (NSDictionary *)obj;
            self.infoModel = [employeeInfoModel requestWithDic:dic];
            NSArray *contactArr = (NSArray *)dic[@"conList"];
            for (NSDictionary *dic in contactArr) {
                employeeContactModel *contactModel = [employeeContactModel requestWithDic:dic];
                [self.contactArr addObject:contactModel];
            }
            if (self.contactArr.count) {
                self.contactModelOne = self.contactArr[0];
            }
            if (self.contactArr.count == 2) {
                self.contactModelTwo = self.contactArr[1];
            }
            [self.detailTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 9;
            break;
        case 1:
            return 4;
            break;
        default:
            return 6;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    vi.backgroundColor = VIEW_BASE_COLOR;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, kScreenWidth, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [vi addSubview:titleView];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 18, 18)];
    image.image = [UIImage imageNamed:self.sectionTitleArr[section]];
    [titleView addSubview:image];
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, kScreenWidth-50, 30)];
    titleLb.text = self.sectionTitleArr[section];
    titleLb.font = [UIFont systemFontOfSize:18 weight:0.2];
    titleLb.textColor = GRAY70;
    [titleView addSubview:titleLb];
    return vi;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 5 || indexPath.row == 8) {
            return 70;
        } else {
            return 55;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            return 70;
        } else {
            return 55;
        }
    } else {
        return 55;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 4 ) {
            employeeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[employeeOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.textField.delegate = self;
            cell.textField.tag = 10*indexPath.section + indexPath.row+1;
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            
            cell.textField.enabled = YES;
            cell.textField.text = self.infoModel.jrq_id_card;
            cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            employeeSixTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
            if (cell == nil) {
                cell = [[employeeSixTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
            }
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            
            cell.womenBtn.tag = 200;
            cell.manBtn.tag = 100;
            [cell.womenBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
            [cell.manBtn addTarget:self action:@selector(chooseSex:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([self.infoModel.sex isEqualToString:@"1"]) {
                cell.manBtn.selected = YES;
                cell.womenBtn.selected = NO;
            }
            if ([self.infoModel.sex isEqualToString:@"2"]) {
                cell.womenBtn.selected = YES;
                cell.manBtn.selected = NO;
            }
            
            return cell;
        } else if (indexPath.section == 0 && indexPath.row == 2) {
            employeeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
            if (cell == nil) {
                cell = [[employeeThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
            }
            cell.starImage.hidden = NO;
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            cell.textField.placeholder = @"请选择";
            cell.textField.delegate = self;
            cell.textField.text = self.infoModel.birthday;
            __weak typeof (self) weakSelf = self;
            _datePickerView.confirmBlock = ^(NSString *choseDate, NSString *restDate) {
                [weakSelf.view endEditing:YES];
                cell.textField.text = choseDate;
                weakSelf.infoModel.birthday = choseDate;
                
            };
            
            _datePickerView.cannelBlock = ^(){
                [weakSelf.view endEditing:YES];
                
            };
            cell.textField.inputView = _datePickerView;
            return cell;
        } else if (indexPath.section == 0 && indexPath.row == 6) {
            employeeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
            if (cell == nil) {
                cell = [[employeeThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
            }
            cell.textField.placeholder = @"请选择";
//            cell.starImage.hidden = YES;
            cell.textField.delegate = self;
            
            if ([self.infoModel.education isEqualToString:@"1"]) {
                cell.textField.text = @"初中及以下";
            }else if ([self.infoModel.education isEqualToString:@"2"]){
                cell.textField.text = @"高中";
            }else if ([self.infoModel.education isEqualToString:@"3"]){
                cell.textField.text = @"中技";
            }else if ([self.infoModel.education isEqualToString:@"4"]){
                cell.textField.text = @"中专";
            }else if ([self.infoModel.education isEqualToString:@"5"]){
                cell.textField.text = @"大专";
            }else if ([self.infoModel.education isEqualToString:@"6"]){
                cell.textField.text = @"本科";
            }else if ([self.infoModel.education isEqualToString:@"7"]){
                cell.textField.text = @"硕士";
            }else if ([self.infoModel.education isEqualToString:@"8"]){
                cell.textField.text = @"MBA";
            }else if ([self.infoModel.education isEqualToString:@"9"]){
                cell.textField.text = @"博士";
            }else{
                cell.textField.text = @"";
            }
            
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            
            _educationPicker = [[EducationPickerView alloc] initWithCustomeHeight:250];
            
            __weak typeof (self) weakSelf = self;
            _educationPicker.confirmBlock = ^(NSString *chooseWorkType) {
                
                cell.textField.text =chooseWorkType;
                
                if ([chooseWorkType isEqualToString:@"初中及以下"]) {
                    weakSelf.infoModel.education = @"1";
                }else if ([chooseWorkType isEqualToString:@"高中"]){
                    weakSelf.infoModel.education = @"2";
                }else if ([chooseWorkType isEqualToString:@"中技"]){
                    weakSelf.infoModel.education = @"3";
                }else if ([chooseWorkType isEqualToString:@"中专"]){
                    weakSelf.infoModel.education = @"4";
                }else if ([chooseWorkType isEqualToString:@"大专"]){
                    weakSelf.infoModel.education = @"5";
                }else if ([chooseWorkType isEqualToString:@"本科"]){
                    weakSelf.infoModel.education = @"6";
                }else if ([chooseWorkType isEqualToString:@"硕士"]){
                    weakSelf.infoModel.education = @"7";
                }else if ([chooseWorkType isEqualToString:@"MBA"]){
                    weakSelf.infoModel.education = @"8";
                }else if ([chooseWorkType isEqualToString:@"博士"]){
                    weakSelf.infoModel.education = @"9";
                }else{
                    weakSelf.infoModel.education = @"";
                }
                
                //[weakSelf.detailTableView reloadData];
            };
            
            _educationPicker.cannelBlock = ^(){
                
                
                [weakSelf.view endEditing:YES];
                
            };
            
                        //设置textfield的键盘 替换为我们的自定义view
            cell.textField.inputView = _educationPicker;
            return cell;
        } else if (indexPath.section == 0 && indexPath.row == 7) {
            employeeThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
            if (cell == nil) {
                cell = [[employeeThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
            }
//            cell.starImage.hidden = YES;
            cell.textField.placeholder = @"请选择";
            cell.textField.delegate = self;
            cell.textField.text = self.infoModel.marital_status;
            
            if ([self.infoModel.marital_status isEqualToString:@"1"]) {
                cell.textField.text = @"已婚";
            }else if ([self.infoModel.marital_status isEqualToString:@"2"]){
                cell.textField.text = @"未婚";
            }else {
                cell.textField.text = @"";
            }
            
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            
            _marriageStatePicker = [[MarriageStatePickerView alloc] initWithCustomeHeight:250];
            
            __weak typeof (self) weakSelf = self;
            _marriageStatePicker.confirmBlock = ^(NSString *chooseMarriageState) {
                
                cell.textField.text = chooseMarriageState ;
                
                if ([chooseMarriageState isEqualToString:@"已婚"]) {
                    weakSelf.infoModel.marital_status = @"1";
                }else if ([chooseMarriageState isEqualToString:@"未婚"]){
                    weakSelf.infoModel.marital_status = @"2";
                }
                
            };
            
            _marriageStatePicker.cannelBlock = ^(){
                
                
                [weakSelf.view endEditing:YES];
                
            };
            
            cell.textField.inputView = _marriageStatePicker;
            return cell;
        } else if (indexPath.section == 0 && indexPath.row == 5) {
            employeeTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:two];
            if (cell == nil) {
                cell = [[employeeTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:two];
            }
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            cell.textField.userInteractionEnabled = YES;
            cell.textField.tag = 1000;
            cell.textField.delegate = self;
            cell.placeholderLabel.text = @"请填写";
            cell.textField.delegate = self;
            
            cell.textField.text = self.infoModel.address;
            [self contentSizeToFit:cell.textField text:self.infoModel.address];
            
            cell.placeholderLabel.tag = 1001;
            if (cell.textField.text.length != 0) {
                cell.placeholderLabel.hidden = YES;
                
            }else{
                cell.placeholderLabel.hidden = NO;
            }
            
            
            return cell;
        } else if (indexPath.section == 0 && indexPath.row == 8) {
            employeeFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
            if (cell == nil) {
                cell = [[employeeFiveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
            }
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            cell.textField.userInteractionEnabled = YES;
            cell.textField.tag = 2000;
            cell.textField.delegate = self;
            
            cell.textField.text = self.infoModel.home_address;
            [self contentSizeToFit:cell.textField text:self.infoModel.home_address];
            
            cell.placeholderLabel.text = @"请填写";
            cell.placeholderLabel.tag = 2001;
            if (cell.textField.text.length != 0) {
                cell.placeholderLabel.hidden = YES;
                
            }else{
                cell.placeholderLabel.hidden = NO;
            }
            
            return cell;
        } else {
            employeeSevenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
            if (cell == nil) {
                cell = [[employeeSevenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
            }
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            if (indexPath.row == 0) {
                cell.titleLB.text = self.infoModel.real_name;
            } else {
                cell.titleLB.text = self.infoModel.mobile;
            }
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            employeeFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
            if (cell == nil) {
                cell = [[employeeFiveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
            }
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            cell.textField.userInteractionEnabled = YES;
            cell.textField.tag = 3000;
            cell.textField.delegate = self;
            
            cell.textField.text = self.infoModel.company_address;
            [self contentSizeToFit:cell.textField text:self.infoModel.company_address];
            cell.placeholderLabel.text = @"请填写";
            cell.placeholderLabel.tag = 3001;
            if (cell.textField.text.length != 0) {
                cell.placeholderLabel.hidden = YES;
                
            }else{
                cell.placeholderLabel.hidden = NO;
            }
            
            return cell;
        } else if(indexPath.row == 0) {
            employeeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[employeeOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            
            cell.textField.tag = 10*indexPath.section + indexPath.row+1;
            cell.textField.delegate = self;
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            cell.textField.text = self.infoModel.company_name;
            cell.starImage.hidden = YES;
            cell.textField.enabled = YES;
            
            return cell;
        } else {
            employeeFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
            if (cell == nil) {
                cell = [[employeeFourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
            }
            cell.textField.tag = 10*indexPath.section + indexPath.row+1;
            cell.textField.enabled = YES;
            cell.textField.delegate = self;
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            if (indexPath.row == 1) {
                cell.textField.text = self.infoModel.post_name;
            } else if (indexPath.row == 2) {
                cell.textField.text = self.infoModel.telephone;
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
            }
            return cell;
        }
    } else  if (indexPath.section == 2) {
        if (indexPath.section == 2 && indexPath.row < 3) {
            employeeOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            
            if (!cell) {
                cell = [[employeeOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.textField.tag = 10*indexPath.section + indexPath.row+1;
            cell.textField.delegate = self;
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            
            
            if (indexPath.row == 2) {
                cell.textField.userInteractionEnabled = YES;
                cell.textField.text = self.contactModelOne.telephone;
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
            } else if (indexPath.row == 1) {
                cell.textField.userInteractionEnabled = YES;
                cell.textField.text = self.contactModelOne.relation;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            } else if (indexPath.row == 0) {
                cell.textField.userInteractionEnabled = YES;
                cell.textField.text = self.contactModelOne.name;
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            }
            return cell;
        } else {
            employeeFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
            if (!cell) {
                cell = [[employeeFourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
            }
            cell.textField.tag = 10*indexPath.section + indexPath.row+1;
            
            
            cell.textField.delegate = self;
            cell.nameLB.text = self.titleArr[indexPath.section][indexPath.row];
            if (indexPath.row == 5) {
                cell.textField.text = self.contactModelTwo.telephone;
                cell.textField.keyboardType = UIKeyboardTypePhonePad;
            } else if (indexPath.row == 4) {
                cell.textField.text = self.contactModelTwo.relation;
            } else if (indexPath.row == 3) {
                cell.textField.text = self.contactModelTwo.name;
            }
            return cell;
        }
    }
    return cell;
}
-(void)deleteBtnOnClick:(UIButton *)sender{
    
    if (sender.tag == 777) {
        UITextView * textView = [self.detailTableView viewWithTag:1000];
        textView.text = @"";
        
    }else if (sender.tag == 778){
        UITextView * textView = [self.detailTableView viewWithTag:2000];
        textView.text = @"";
        
    }else if (sender.tag == 779){
        UITextView * textView = [self.detailTableView viewWithTag:3000];
        textView.text = @"";
    }else if (sender.tag == 780){
        UITextView * textView = [self.detailTableView viewWithTag:4000];
        textView.text = @"";
    }
    
    [self.detailTableView reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 4:
        {
            self.infoModel.mobile = textField.text;
        }
            break;
        case 5:
        {
            self.infoModel.jrq_id_card = textField.text;
        }
            break;
        case 11:
        {
            self.infoModel.company_name = textField.text;
        }
            break;
        case 12:
        {
            self.infoModel.post_name = textField.text;
        }
            break;
        case 13:
        {
            self.infoModel.telephone = textField.text;
        }
            break;
        case 21:
        {
            self.contactModelOne.name = textField.text;
        }
            break;
        case 22:
        {
            self.contactModelOne.relation = textField.text;
        }
            break;
        case 23:
        {
            self.contactModelOne.telephone = textField.text;
        }
            break;
        case 24:
        {
            if (![Utils isBlankString:textField.text]) {
                self.contactModelTwo.name = textField.text;
            }
        }
            break;
        case 25:
        {
            if (![Utils isBlankString:textField.text]) {
                self.contactModelTwo.relation = textField.text;
            }
        }
            break;
        case 26:
        {
            if (![Utils isBlankString:textField.text]) {
                self.contactModelTwo.telephone = textField.text;
            }
        }
            break;
        
    }
    
    textField.enabled = YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    [self contentSizeToFit:textView text:textView.text];
    if (textView.tag == 1000) {
        UILabel * label = [self.detailTableView viewWithTag:1001];
        if (textView.text.length > 0) {
            label.hidden = YES;
        } else {
            label.hidden = NO;
        }
        
    }else if (textView.tag == 2000){
        UILabel * label = [self.detailTableView viewWithTag:2001];
        if (textView.text.length > 0) {
            label.hidden = YES;
        } else {
            label.hidden = NO;
        }
        
    }else if (textView.tag == 3000){
        UILabel * label = [self.detailTableView viewWithTag:3001];
        if (textView.text.length > 0) {
            label.hidden = YES;
        } else {
            label.hidden = NO;
        }
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    switch (textView.tag) {
        case 1000:
        {
            self.infoModel.address = textView.text;
        }
            break;
        case 2000:
        {
            self.infoModel.home_address = textView.text;
        }
            break;
        case 3000:
        {
            self.infoModel.company_address = textView.text;
        }
            break;

        default:
            break;
    }
}
- (void)contentSizeToFit:(UITextView *)textView text:(NSString *)text
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if([text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = textView.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= textView.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (textView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = textView.frame.size;
            offset = UIEdgeInsetsZero;
            
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            //while (contentSize.height > textView.frame.size.height)
            //{
                //[textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                //contentSize = textView.contentSize;
            //}
            newSize = contentSize;
        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [textView setContentSize:newSize];
        [textView setContentInset:offset];
        
    }
}
- (void)chooseSex:(UIButton *)sender {

    if (sender.tag == 100) {
        
        if (sender.selected) {
            //self.womenBtn.selected = NO;
        } else {
            sender.selected = YES;
            self.infoModel.sex = @"1";
            UIButton *btn = [self.detailTableView viewWithTag:200];
            if (btn.selected) {
                btn.selected = NO;
            }
        }
    } else {
        if (sender.selected) {
            //self.manBtn.selected = NO;
        } else {
            self.infoModel.sex = @"2";
            sender.selected = YES;
            UIButton *btn = [self.detailTableView viewWithTag:100];
            if (btn.selected) {
                btn.selected = NO;
            }
        }
    }
    
}

- (void)ClickComplete {
    [self.view endEditing:YES];
    NSDictionary *dic = [self dicWithData];
    
    if (dic) {
        
        [HttpRequestEngine mendEmployeeInfoWithDic:dic completion:^(id obj, NSString *errorStr) {
            if (![Utils isBlankString:errorStr]) {
                [MBProgressHUD showError:errorStr];
            } else {
                self.block();
                [MBProgressHUD showSuccess:@"修改成功"];
            }
        }];
    }
}
- (NSDictionary *)dicWithData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = self.infoModel.userId;
    /**
     
     "address": "null",
     "birthday": null,
     "company_address": "null",
     "company_name": "null",
     "contacts": [
     {
     "name": "null",
     "relation": "null",
     "telephone": "null"
     }
     ],
     "education": null,
     "home_address": "null",
     "jrq_id_card": "null",
     "marital_status": null,
     "mobile": "19999999999",
     "post_name": "null",
     "real_name": "a苹果端有问题可向此号反馈",
     "sex": 1,
     "telephone": "null",
     "userId": 1
     */
    if (![Utils isBlankString:self.infoModel.sex]) {
        dic[@"sex"] = self.infoModel.sex;
    } else {
        [MBProgressHUD showError:@"请选择性别"];
        return nil;
    }
    
    if (![Utils isBlankString:self.infoModel.birthday]) {
        dic[@"birthday"] = self.infoModel.birthday;
    } else {
        [MBProgressHUD showError:@"请选择出生日期"];
        return nil;
    }
    
    if (![Utils isBlankString:self.infoModel.jrq_id_card]) {
        if ([self.infoModel.jrq_id_card checkIDCardNumInput]) {
            dic[@"jrq_id_card"] = self.infoModel.jrq_id_card;
        } else {
            [MBProgressHUD showError:@"身份证号码错误"];
            return nil;
        }
    } else {
        [MBProgressHUD showError:@"请填写身份证号码"];
        return nil;
    }
    
    if (![Utils isBlankString:self.infoModel.address]) {
        dic[@"address"] = self.infoModel.address;
    } else {
        [MBProgressHUD showError:@"请填写现住宅地址"];
        return nil;
    }
    
    if (![Utils isBlankString:self.infoModel.education]) {
        dic[@"education"] = self.infoModel.education;
    } else {
        [MBProgressHUD showError:@"请选择学历"];
        return nil;
    }
    
    if (![Utils isBlankString:self.infoModel.marital_status]) {
        dic[@"marital_status"] = self.infoModel.marital_status;
    } else {
        [MBProgressHUD showError:@"请选择婚姻状况"];
        return nil;
    }
    
    if (![Utils isBlankString:self.infoModel.home_address]) {
        dic[@"home_address"] = self.infoModel.home_address;
    }
    
    NSMutableDictionary *compList = [NSMutableDictionary dictionary];
    if (![Utils isBlankString:self.infoModel.company_name]) {
        compList[@"company_name"] = self.infoModel.company_name;
    }
    
    if (![Utils isBlankString:self.infoModel.post_name]) {
        compList[@"post_name"] = self.infoModel.post_name;
    }
    
    if (![Utils isBlankString:self.infoModel.telephone]) {
        compList[@"telephone"] = self.infoModel.telephone;
    }
    
    if (![Utils isBlankString:self.infoModel.company_address]) {
        compList[@"company_address"] = self.infoModel.company_address;
    }
    NSArray *compListArr = [NSArray arrayWithObject:compList];
    
    dic[@"compList"] = compListArr;
    
    NSMutableDictionary *contactOneDic = [NSMutableDictionary dictionary];
    
    if (![Utils isBlankString:self.contactModelOne.name]) {
        contactOneDic[@"name"] = self.contactModelOne.name;
    } else {
        [MBProgressHUD showError:@"请填写联系人姓名"];
        return nil;
    }
    
    if (![Utils isBlankString:self.contactModelOne.relation]) {
        contactOneDic[@"relation"] = self.contactModelOne.relation;
    } else {
        [MBProgressHUD showError:@"请填写联系人关系"];
        return nil;
    }
    
    if (![Utils isBlankString:self.contactModelOne.telephone]) {
        if ([self.contactModelOne.telephone checkPhoneNumInput]) {
            contactOneDic[@"telephone"] = self.contactModelOne.telephone;
        } else {
            [MBProgressHUD showError:@"联系人手机号码错误"];
            return nil;
        }
    } else {
        [MBProgressHUD showError:@"请填写联系人手机号码"];
        return nil;
    }
    
    NSMutableDictionary *contactTwoDic = [NSMutableDictionary dictionary];
    
    if (![Utils isBlankString:self.contactModelTwo.name]) {
        contactTwoDic[@"name"] = self.contactModelTwo.name;
    }
    
    if (![Utils isBlankString:self.contactModelTwo.relation]) {
        contactTwoDic[@"relation"] = self.contactModelTwo.relation;
    }
    
    if (![Utils isBlankString:self.contactModelTwo.telephone]) {
        if ([self.contactModelTwo.telephone checkPhoneNumInput]) {
            contactTwoDic[@"telephone"] = self.contactModelTwo.telephone;
        } else {
            [MBProgressHUD showError:@"联系人手机号码错误"];
            return nil;
        }
    }
    
    NSArray *contactListArr = [NSArray arrayWithObjects:contactOneDic,contactTwoDic, nil];
    
    
    dic[@"conList"] = contactListArr;
    
    return dic;
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
