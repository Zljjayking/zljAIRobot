//
//  AddProductViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "AddProductViewController.h"
#import "LoginPeopleModel.h"
#import "IconProductCell.h"
#import "InputProductInfoCell.h"
#import "SelectProductCell.h"
#import "ApplyInfoCell.h"
#import "LendingInfoCell.h"
#import "ProductChooseTableViewController.h"

#import "LocationData.h"
#import "BankModel.h"
#import "citiesViewController.h"
@interface AddProductViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,JKAlertViewDelegate,UITextFieldDelegate>
{
    UIImagePickerController *_imagePickerC;
    // 选择内容arr
    NSArray   *productTypeArr ;
    NSArray   *coustomTypeArr ;
    NSArray   *payTypeArr ;
    NSArray   *zhudaArr ;

}

@property(nonatomic,strong)UITableView *addProTableView;
@property(nonatomic,strong)NSArray *nameArray;

@property(nonatomic,strong)NSMutableArray *bankArray;

@property(nonatomic,copy)NSString * imgaePath;
@property(nonatomic,copy)NSString *mechProType;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,copy)NSString * typeCustomerString;
@property(nonatomic,copy)NSString * returnMoneyString;
@property(nonatomic,copy)NSString * kindPro;
@property (nonatomic,copy)NSString *addressString;

@property(nonatomic,copy)NSString * typeCustomerString1;
@property(nonatomic,copy)NSString * returnMoneyString1;
@property(nonatomic,copy)NSString * kindPro1;
@property (nonatomic,copy)NSString *addressString1;

@property(nonatomic,assign)NSInteger proID;
@property(nonatomic,assign)NSInteger cityID;
@property(nonatomic,assign)NSInteger areaID;

@property(nonatomic,copy)NSString * mechProGoodness;
@property(nonatomic,copy)NSString * tabInterestRate;
@property(nonatomic,copy)NSString * minDay;
@property(nonatomic,copy)NSString * maxDay;
@property(nonatomic,copy)NSString * minCash;
@property(nonatomic,copy)NSString * maxCash;
@property(nonatomic,copy)NSString * appliCondition;
@property(nonatomic,copy)NSString * appliMaterials;
@property(nonatomic,copy)NSString * costDescription;
@property(nonatomic,copy)NSString * mechProtext;

@property(nonatomic,strong)NSMutableDictionary * dataDic;

@property(nonatomic,strong)UIView * vv;

@property (nonatomic, weak) UITextField *TextField;
@property (nonatomic, strong) LoginPeopleModel *loginModel;
@property (nonatomic) NSString *bankId;


//@property (nonatomic,copy)NSString *mechProName;
@end

@implementation AddProductViewController
static NSString *returnString;
- (void)viewWillAppear:(BOOL)animated {
    returnString = @"点击选择";
    if (![returnString  isEqualToString:@"点击选择"]) {
        [_addProTableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginModel = [[LoginPeopleModel alloc] initWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    [self setDic];
    self.view.backgroundColor = [UIColor whiteColor];
    self.bankArray = [NSMutableArray array];
    self.vv = [[UIView alloc]initWithFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    self.navigationItem.title = @"新增产品";
    self.view.backgroundColor = VIEW_BASE_COLOR;

    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOk)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    [self creatData];
    
    [self initUI];
}
-(void)creatData{
    [HttpRequestEngine getBankOrMechianCompletion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            NSArray *arr = (NSArray *)obj;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                BankModel *bankModel = [BankModel requestWithDic:dic];
                [self.bankArray addObject:bankModel];
            }];
            
//            [self.addProTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
        
    }];
    _nameArray = @[@[@"产品图像"],@[@"产品名称",@"所属银行/机构",@"产品类型",@"产品优势",@"产品利率"],@[@"客户类型",@"还款方式",@"放款时间",@"放款额度",@"产品分类",@"产品地址"],@[@"申请条件",@"申请材料",@"费用说明",@"备注信息"]];
    
    productTypeArr = @[@"银行信用贷",@"房产抵押",@"房产按揭",@"车辆抵押",@"车辆按揭",@"企业贷款",@"小额贷款",@"大额贷款",@"过桥垫资",@"信用卡"];
    coustomTypeArr = @[@"企业",@"工薪族",@"个人",@"其他"];
    payTypeArr     = @[@"等额本息",@"等额本金",@"先息后本",@"其他"];
    zhudaArr       = @[@"普通产品",@"主打产品",@"明星产品"];
    
    
    
}

-(void)initUI{
    
    _addProTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
    
    _addProTableView.delegate = self;
    _addProTableView.dataSource = self;
    _addProTableView.showsVerticalScrollIndicator = NO;
    _addProTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_addProTableView];
    
    [_addProTableView registerNib:[UINib nibWithNibName:@"IconProductCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"IconProductID"];
    
    [_addProTableView registerNib:[UINib nibWithNibName:@"InputProductInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputProductInfoID"];
    
    [_addProTableView registerNib:[UINib nibWithNibName:@"SelectProductCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SelectProductID"];
    
    [_addProTableView registerClass:[ApplyInfoCell class] forCellReuseIdentifier:@"ApplyInfoCellID"];
    
    [_addProTableView registerNib:[UINib nibWithNibName:@"LendingInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LendingInfoID"];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [UIAdaption getAdaptiveHeightWith5SHeight:0.5];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [UIAdaption getAdaptiveHeightWith5SHeight:0.01];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }else if (indexPath.section == 1){
        return 55;
    }else if (indexPath.section == 2){
       return  55;
    }else if (indexPath.section == 3 && indexPath.row == 0){
        
        UITextView * tv = [tableView viewWithTag:1000];
        
        tv.font = [UIFont systemFontOfSize:15];
        
        CGFloat titleTextHeight = tv.contentSize.height;
        if (titleTextHeight > 55) {
            return titleTextHeight+20;
        } else {
            return 55;
        }
    }else if (indexPath.section == 3 && indexPath.row == 1){
        UITextView * tv = [tableView viewWithTag:2000];
        
        tv.font = [UIFont systemFontOfSize:15];
        
        CGFloat titleTextHeight = tv.contentSize.height;
        if (titleTextHeight > 55) {
            return titleTextHeight+20;
        } else {
            return 55;
        }
    }else if (indexPath.section == 3 && indexPath.row == 2){
        UITextView * tv = [tableView viewWithTag:3000];
        
        tv.font = [UIFont systemFontOfSize:15];
        
        CGFloat titleTextHeight = tv.contentSize.height;
        if (titleTextHeight > 55) {
            return titleTextHeight+20;
        } else {
            return 55;
        }
    }else if (indexPath.section == 3 && indexPath.row == 3){
        UITextView * tv = [tableView viewWithTag:4000];
        
        tv.font = [UIFont systemFontOfSize:15];
        
        CGFloat titleTextHeight = tv.contentSize.height;
        if (titleTextHeight > 55) {
            return titleTextHeight+20;
        } else {
            return 55;
        }

    }else{
        return 50;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else if (section == 2){
        return 6;
    }else{
        return 4;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddProCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddProCell"];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {//产品图像
        
        IconProductCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IconProductID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        cell.iconProLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.addIconButton.tag=19;
        
        [cell.addIconButton addTarget:self action:@selector(AddIconOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else if (indexPath.section == 1 && indexPath.row == 0){ //产品名称
        
        InputProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputProductInfoID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.inputproductLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.inputProductTextField.placeholder = @"输入产品名称";
        cell.inputProductTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.inputProductTextField.tintColor = TABBAR_BASE_COLOR;
        cell.inputProductTextField.borderStyle = UITextBorderStyleNone;
        cell.inputProductTextField.returnKeyType = UIReturnKeyDone;
        cell.inputProductTextField.tag = 100;
        cell.inputProductTextField.delegate = self;
        
        cell.inputProductTextField.text = self.dataDic[@"mechProName"];
        
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 3){  //产品优势
        
        InputProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputProductInfoID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.inputproductLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.inputProductTextField.placeholder = @"输入产品优势";
        cell.inputProductTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.inputProductTextField.tintColor = TABBAR_BASE_COLOR;
        cell.inputProductTextField.borderStyle = UITextBorderStyleNone;
        cell.inputProductTextField.returnKeyType = UIReturnKeyDone;
        cell.inputProductTextField.tag = 101;
        cell.inputProductTextField.delegate = self;
        cell.inputProductTextField.text = self.dataDic[@"mechProGoodness"];
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 4){  //产品利率
        
        InputProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputProductInfoID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.inputproductLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.inputProductTextField.placeholder = @"输入产品利率: %";
        cell.inputProductTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.inputProductTextField.tintColor = TABBAR_BASE_COLOR;
        cell.inputProductTextField.borderStyle = UITextBorderStyleNone;
        cell.inputProductTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.inputProductTextField.returnKeyType = UIReturnKeyDone;
        cell.inputProductTextField.tag = 102;
        cell.inputProductTextField.text = self.dataDic[@"tabInterestRate"];
        cell.inputProductTextField.delegate = self;
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){ //所属银行获机构
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductID"];
        if (cell == nil) {
            cell = [[SelectProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectProductID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (![Utils isBlankString:self.bankName]) {
            [cell.selectProButton setTitle:self.bankName forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }else {
            [cell.selectProButton setTitle:@"点击选择" forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateSelected];
        }
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 2){ //产品类型
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductID"];
        if (cell == nil) {
            cell = [[SelectProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectProductID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (![Utils isBlankString:self.mechProType]) {
            [cell.selectProButton setTitle:self.mechProType forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }else {
            [cell.selectProButton setTitle:@"点击选择" forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateSelected];
        }
        
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section ==2 && indexPath.row == 0){ //客户类型
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductID"];
        if (cell == nil) {
            cell = [[SelectProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectProductID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (![Utils isBlankString:self.typeCustomerString1]) {
            [cell.selectProButton setTitle:self.typeCustomerString1 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }else {
            [cell.selectProButton setTitle:@"点击选择" forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateSelected];
        }
        
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 2 && indexPath.row == 1){  //还款方式
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductID"];
        if (cell == nil) {
            cell = [[SelectProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectProductID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (![Utils isBlankString:self.returnMoneyString1]) {
            [cell.selectProButton setTitle:self.returnMoneyString1 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }else {
            [cell.selectProButton setTitle:@"点击选择" forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateSelected];
        }
        
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }else if (indexPath.section == 2 && indexPath.row == 2){  //放款时间
        LendingInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LendingInfoID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.LendingLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.minTextField.placeholder = @"最短时间";
        cell.minTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.minTextField.borderStyle = UITextBorderStyleNone;
        cell.minTextField.tintColor = TABBAR_BASE_COLOR;
        cell.minTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.minTextField.returnKeyType = UIReturnKeyDone;
        cell.minTextField.text = self.dataDic[@"minDay"];
        cell.minTextField.delegate = self;
        cell.minTextField.tag = 103;
        
        cell.maxTextField.placeholder = @"最长时间";
        cell.maxTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.maxTextField.borderStyle = UITextBorderStyleNone;
        cell.maxTextField.tintColor = TABBAR_BASE_COLOR;
        cell.maxTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
        cell.maxTextField.tag = 104;
        cell.maxTextField.text = self.dataDic[@"maxDay"];
        cell.maxTextField.delegate = self;
        
        cell.timeAndMoneyLabel.text = @"天";
        
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 3){  //放款额度
        
        LendingInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LendingInfoID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.LendingLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.minTextField.placeholder = @"最小金额";
        cell.minTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.minTextField.borderStyle = UITextBorderStyleNone;
        cell.minTextField.tintColor = TABBAR_BASE_COLOR;
        cell.minTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.minTextField.text = self.dataDic[@"minCash"];
        cell.minTextField.delegate = self;
        cell.minTextField.tag = 105;
        
        cell.maxTextField.placeholder = @"最大金额";
        cell.maxTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cell.maxTextField.borderStyle = UITextBorderStyleNone;
        cell.maxTextField.tintColor = TABBAR_BASE_COLOR;
        cell.maxTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.maxTextField.text = self.dataDic[@"maxCash"];
        cell.maxTextField.delegate =self;
        cell.maxTextField.tag = 106;
        
        cell.timeAndMoneyLabel.text = @"万元";
        return cell;
        
    }
    else if (indexPath.section == 2 && indexPath.row == 4){  //产品分类
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductID"];
        if (cell == nil) {
            cell = [[SelectProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectProductID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (![Utils isBlankString:self.kindPro1]) {
            [cell.selectProButton setTitle:self.kindPro1 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }else {
            [cell.selectProButton setTitle:@"点击选择" forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateSelected];
        }
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section == 2 && indexPath.row == 5){  //产品地址
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductID"];
        if (cell == nil) {
            cell = [[SelectProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SelectProductID"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (![Utils isBlankString:self.addressString1]) {
            [cell.selectProButton setTitle:self.addressString1 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        }else {
            [cell.selectProButton setTitle:@"点击选择" forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:GRAY190 forState:UIControlStateSelected];
        }
        
        [cell.selectProButton addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 3 && indexPath.row == 0){ //申请条件
        
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 1000;
        cell.applyInfoTextView.text = self.dataDic[@"appliCondition"];
        
        cell.placeholderLabel.tag = 1001;
        cell.placeholderLabel.text = self.dataDic[@"input1"];
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
            
        }else{
            cell.placeholderLabel.hidden = NO;
        }
        
        cell.deleteBtn.tag = 777;
        cell.deleteBtn.hidden = YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
        
    }else if (indexPath.section == 3 && indexPath.row == 1){ //申请材料
        
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 2000;
        cell.applyInfoTextView.text = self.dataDic[@"appliMaterials"];
        
        cell.placeholderLabel.tag = 2001;
        cell.placeholderLabel.text = self.dataDic[@"input2"];
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
        }
        
        cell.deleteBtn.tag = 778;
        cell.deleteBtn.hidden = YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        return cell;
        
    }else if (indexPath.section == 3 && indexPath.row == 2){  //费用说明
        
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 3000;
        cell.applyInfoTextView.text = self.dataDic[@"costDescription"];
        
        cell.placeholderLabel.tag = 3001;
        cell.placeholderLabel.text = self.dataDic[@"input3"];
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
        }
        
        cell.deleteBtn.tag = 779;
        cell.deleteBtn.hidden = YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.section == 3 && indexPath.row == 3){  //备注信息
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        
     
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 4000;
        cell.applyInfoTextView.text = self.dataDic[@"mechProtext"];
        
        cell.placeholderLabel.tag = 4001;
        cell.placeholderLabel.text = self.dataDic[@"input4"];
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
        }
        
        cell.deleteBtn.tag = 780;
        cell.deleteBtn.hidden = YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    return nil;
}

-(void)AddressClick:(UIButton *)sender{

     if (sender.tag == 25){
         
         citiesViewController *citiesVC = [[citiesViewController alloc]init];
         citiesVC.type = 5;
         citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
             self.proID = [selectedProID integerValue];
             self.cityID = [selectedCityID integerValue];
             self.areaID = [selectedAreaID integerValue];
             
             NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
             
             SelectProductCell *cell = (SelectProductCell*)[_addProTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:2]];
             self.addressString1 = str;
             [cell.selectProButton setTitle:str forState:UIControlStateNormal];
             [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         };
         citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
         [self presentViewController:citiesVC animated:YES completion:nil];
         
//         citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//         [self presentViewController:citiesVC animated:YES completion:nil];
//         
//         __weak LocationView * weakView = self.locaView;
//         weakView.locaBlock = ^(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str){
//             
//            self.proID = num1;
//            self.cityID = num2;
//            self.areaID = num3;
//             
//            SelectProductCell *cell = (SelectProductCell*)[_addProTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:2]];
//             self.addressString1 = str;
//             [cell.selectProButton setTitle:str forState:UIControlStateNormal];
//             [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//         };
       
     }else{
         self.proID = 0;
         self.cityID = 0;
         self.areaID = 0;
     }

}
#pragma mark -- 选择产品
-(void)AddclickChoose:(UIButton *)sender{
    
    ProductChooseTableViewController *productChoose = [[ProductChooseTableViewController alloc]init];
    
    if (sender.tag == 12) {
        productChoose.dataArr                           = productTypeArr;
        productChoose.title                             = @"选择产品类型";
    }else if (sender.tag == 11) {
        productChoose.dataArr                           = self.bankArray;
        productChoose.title                             = @"选择所属银行/机构";
        productChoose.type = 1;
    }else if(sender.tag == 20){
        productChoose.dataArr                           = coustomTypeArr;
        productChoose.title                             = @"选择客户类型";
    }else if (sender.tag == 21){
        productChoose.dataArr                           = payTypeArr;
        productChoose.title                             = @"选择还款方式";
    }else if(sender.tag == 24){
        productChoose.dataArr                           = zhudaArr;
        productChoose.title                             = @"选择产品分类";
    }
//    [productChoose makeTableviewFrame];
    if (sender.tag != 25) {
        [self.navigationController pushViewController:productChoose animated:YES];
    }
    
    [productChoose returnText:^(NSString *returnStr) {
        
        returnString  = returnStr;
        if (sender.tag == 11) {
            for (BankModel *model in self.bankArray) {
                if ([returnString isEqualToString:model.bankName]) {
                    self.bankId = model.bankId;
                    self.bankName = model.bankName;
                }
            }
        }else if (sender.tag == 12) {
            self.mechProType = returnStr;
        }else if(sender.tag == 20){
            self.typeCustomerString1 = returnStr;
        }else if (sender.tag == 21){
            self.returnMoneyString1 = returnStr;
        }else if(sender.tag == 24){
            self.kindPro1 = returnStr;
        }
        [sender setTitle:returnString forState:UIControlStateNormal];
        
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }];
}


//添加产品图像
-(void)AddIconOnClick{
    JKAlertManager * manager = [[JKAlertManager alloc]initWithPreferredStyle:UIAlertControllerStyleActionSheet title:nil message:nil ];
    [manager configueCancelTitle:@"取消" destructiveIndex:-1 otherTitles:@[@"从相册选择"]];
    [manager configuePopoverControllerForActionSheetStyleWithSourceView:self.tabBarController.view sourceRect:self.tabBarController.view.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
        _imagePickerC = [[UIImagePickerController alloc]init];
        UIFont *font = [UIFont systemFontOfSize:17];
        NSDictionary *textAttributes = @{
                                         NSFontAttributeName : font,
                                         NSForegroundColorAttributeName : [UIColor whiteColor]
                                         };
        _imagePickerC.navigationBar.titleTextAttributes = textAttributes;
        [_imagePickerC.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
        [_imagePickerC.navigationBar setTranslucent:NO];
        _imagePickerC.allowsEditing = YES;
        _imagePickerC.delegate = self;
        if (actionIndex == 0) {
            _imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerC animated:YES completion:nil];
        }
    }];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:nil, nil];
//    actionSheet.delegate       = self;
//    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

#pragma mark --  UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePickerC = [[UIImagePickerController alloc]init];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    _imagePickerC.navigationBar.titleTextAttributes = textAttributes;
    [_imagePickerC.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
    [_imagePickerC.navigationBar setTranslucent:NO];
    _imagePickerC.allowsEditing = YES;
    _imagePickerC.delegate = self;
    if (buttonIndex == 0) {
        _imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerC animated:YES completion:nil];
    }
}
#pragma mark -- UIImagePickerView
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *getImage=  [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:picker completion:^{
        UIButton* imagebtn = [self.addProTableView viewWithTag:19];
        
        imagebtn.tag = 1;
        
        [HttpRequestEngine uploadImageData:[self getDataWitdImgae:getImage] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
            if (errorStr)
            {
                [MBProgressHUD showError:errorStr toView:self.view];
            }else{

                NSDictionary *dic = [NSDictionary changeType:obj];
                self.imgaePath = dic[@"errorMsg"];
//                NSLog(@"%@",self.imgaePath);

                [MBProgressHUD showSuccess:@"添加成功"];
                
                [imagebtn setBackgroundImage:getImage forState:UIControlStateNormal];
                [self.addProTableView reloadData];
            }
        }];
    }];
}


#pragma mark -- 上传产品
-(void)ClickOk{
    
    NSString * namePro = self.dataDic[@"mechProName"];
    //UIButton * typePro = [self.addProTableView viewWithTag:11];
    
    NSString * bankName = self.mechProType;
    
    for (BankModel *model in self.bankArray) {
        if ([model.bankName isEqualToString:bankName]) {
            self.bankId = model.bankId;
        }
    }
    
    //UIButton * typeCustomer = [self.addProTableView viewWithTag:20];
    if ([self.typeCustomerString1 isEqualToString:@"企业"]) {
        self.typeCustomerString = [self.typeCustomerString1 stringByReplacingOccurrencesOfString:@"企业" withString:@"1"];
    }else if ([self.typeCustomerString1 isEqualToString:@"工薪族"]){
        self.typeCustomerString = [self.typeCustomerString1 stringByReplacingOccurrencesOfString:@"工薪族" withString:@"2"];
        
    }else if ([self.typeCustomerString1 isEqualToString:@"个人"]){
        self.typeCustomerString = [self.typeCustomerString1 stringByReplacingOccurrencesOfString:@"个人" withString:@"3"];
        
    }else if ([self.typeCustomerString1 isEqualToString:@"其他"]){
        self.typeCustomerString = [self.typeCustomerString1 stringByReplacingOccurrencesOfString:@"其他" withString:@"4"];
    }
    
    //UIButton * returnMoney = [self.addProTableView viewWithTag:21];
    if ([self.returnMoneyString1 isEqualToString:@"等额本息"]) {
        self.returnMoneyString = [self.returnMoneyString1 stringByReplacingOccurrencesOfString:@"等额本息" withString:@"1"];
    }else if ([self.returnMoneyString1 isEqualToString:@"等额本金"]){
        self.returnMoneyString = [self.returnMoneyString1 stringByReplacingOccurrencesOfString:@"等额本金" withString:@"2"];
    }else if ([self.returnMoneyString1 isEqualToString:@"先息后本"]){
        self.returnMoneyString = [self.returnMoneyString1 stringByReplacingOccurrencesOfString:@"先息后本" withString:@"3"];
    }else if ([self.returnMoneyString1 isEqualToString:@"其他"]){
        self.returnMoneyString = [self.returnMoneyString1 stringByReplacingOccurrencesOfString:@"其他" withString:@"4"];
    }
    
    //UIButton * kindPro = [self.addProTableView viewWithTag:24];
    if ([self.kindPro1 isEqualToString:@"普通产品"]) {
        self.kindPro = [self.kindPro1 stringByReplacingOccurrencesOfString:@"普通产品" withString:@"1"];
    }else if ([self.kindPro1 isEqualToString:@"主打产品"]){
        self.kindPro = [self.kindPro1 stringByReplacingOccurrencesOfString:@"主打产品" withString:@"2"];
    }else if ([self.kindPro1 isEqualToString:@"明星产品"]){
        self.kindPro = [self.kindPro1 stringByReplacingOccurrencesOfString:@"明星产品" withString:@"3"];
    }

    if (self.imgaePath.length == 0) {
        JKAlertView * alertRate = [[JKAlertView alloc]initWithTitle:@"请添加产品图像" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertRate show] ;
    }else if (namePro.length == 0) {
        JKAlertView * alertName = [[JKAlertView alloc]initWithTitle:@"请输入产品名称" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertName show] ;
    }else if ([self.mechProType isEqualToString:@"点击选择"]){
        JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品类型" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertType show] ;
    }else if ([Utils isBlankString:self.bankId]){
        JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品所属银行/机构" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertType show] ;
    }else if ([self.kindPro1 isEqualToString:@"点击选择"]){
        JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品分类" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertType show] ;
        
    }else if (self.proID == 0 && self.cityID == 0 && self.areaID == 0  ){
        JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品地址" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertType show] ;
        
    }else{
        
        JKAlertView * addAlertView = [[JKAlertView alloc]initWithTitle:@"新增产品" message:@"确定新增该产品吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [addAlertView show] ;
    }
}

-(void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
       // UITextField * namePro = [self.addProTableView viewWithTag:100];
   //     UIButton * typePro = [self.addProTableView viewWithTag:11];
        /**
         UIButton * typeCustomer = [self.addProTableView viewWithTag:20];
         if ([typeCustomer.titleLabel.text isEqualToString:@"企业"]) {
         self.typeCustomerString = [typeCustomer.titleLabel. text stringByReplacingOccurrencesOfString:@"企业" withString:@"1"];
         }else if ([typeCustomer.titleLabel.text isEqualToString:@"工薪族"]){
         self.typeCustomerString = [typeCustomer.titleLabel. text stringByReplacingOccurrencesOfString:@"工薪族" withString:@"2"];
         
         }else if ([typeCustomer.titleLabel.text isEqualToString:@"个人"]){
         self.typeCustomerString = [typeCustomer.titleLabel. text stringByReplacingOccurrencesOfString:@"个人" withString:@"3"];
         
         }else if ([typeCustomer.titleLabel.text isEqualToString:@"其他"]){
         self.typeCustomerString = [typeCustomer.titleLabel. text stringByReplacingOccurrencesOfString:@"其他" withString:@"4"];
         
         }
         
         UIButton * returnMoney = [self.addProTableView viewWithTag:21];
         if ([returnMoney.titleLabel.text isEqualToString:@"等额本息"]) {
         self.returnMoneyString = [returnMoney.titleLabel. text stringByReplacingOccurrencesOfString:@"等额本息" withString:@"1"];
         }else if ([returnMoney.titleLabel.text isEqualToString:@"等额本金"]){
         self.returnMoneyString = [returnMoney.titleLabel. text stringByReplacingOccurrencesOfString:@"等额本金" withString:@"2"];
         }else if ([returnMoney.titleLabel.text isEqualToString:@"先息后本"]){
         self.returnMoneyString = [returnMoney.titleLabel. text stringByReplacingOccurrencesOfString:@"先息后本" withString:@"3"];
         }else if ([returnMoney.titleLabel.text isEqualToString:@"其他"]){
         self.returnMoneyString = [returnMoney.titleLabel. text stringByReplacingOccurrencesOfString:@"其他" withString:@"4"];
         }
         
         UIButton * kindPro = [self.addProTableView viewWithTag:24];
         if ([kindPro.titleLabel.text isEqualToString:@"普通产品"]) {
         self.kindPro = [kindPro.titleLabel.text stringByReplacingOccurrencesOfString:@"普通产品" withString:@"1"];
         }else if ([kindPro.titleLabel.text isEqualToString:@"主打产品"]){
         self.kindPro = [kindPro.titleLabel.text stringByReplacingOccurrencesOfString:@"主打产品" withString:@"2"];
         }else if ([kindPro.titleLabel.text isEqualToString:@"明星产品"]){
         self.kindPro = [kindPro.titleLabel.text stringByReplacingOccurrencesOfString:@"明星产品" withString:@"3"];
         }
         
         */
        
        //  UIButton * address = [self.addProTableView viewWithTag:25];
        
        LoginPeopleModel *myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        NSMutableDictionary *parameters = [self dicWithInterType:@"addproduct2" MechProId:myModel.userId];
        
        //            NSLog(@"%@",parameters);
        [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *data = [NSDictionary changeType:responseObject];
            NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
            if (![code isEqualToString:@"200"]) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
            } else {
                if (self.isRefreshProduct != nil) {
                    NSString *str = @"1";
                    self.isRefreshProduct(str);
                }
                
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            //                NSLog(@"JSON: %@", data);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
        }];
    }
    
}

-(NSMutableDictionary *)dicWithInterType:(NSString *)interType MechProId:(NSInteger)mechProId{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    dic[@"inter"] = interType;
    dic[@"uid"] = [NSString stringWithFormat:@"%ld",mechProId];
    dic[@"eid"] = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
  //  UITextField * namePro = [self.addProTableView viewWithTag:100];
    dic[@"bankId"] = self.bankId;
    dic[@"mechProName"] = [self changeString:self.dataDic[@"mechProName"]];
    
    //UIButton * typePro = [self.addProTableView viewWithTag:12];
    dic[@"mechProType"] = [self changeString:self.mechProType];
    
    UITextField * advantagePro = [self.addProTableView viewWithTag:101];
    if (advantagePro.text.length != 0) {
        dic[@"mechProGoodness"] = [self changeString:self.dataDic[@"mechProGoodness"]];
    }
    
    UITextField * ratePro = [self.addProTableView viewWithTag:102];
    if (ratePro.text.length != 0) {
        dic[@"tabInterestRate"] = [self changeString:self.dataDic[@"tabInterestRate"]];
    }
    
    dic[@"tabCustomerType"] = self.typeCustomerString;
    dic[@"tabReimburSement"] = self.returnMoneyString;
    dic[@"bankId"] = self.bankId;
    
    UITextField * minTime = [self.addProTableView viewWithTag:103];
    if (minTime.text.length != 0) {
        dic[@"minDay"] = self.dataDic[@"minDay"];
    }
    UITextField * maxTime = [self.addProTableView viewWithTag:104];
    if (maxTime.text.length != 0) {
        dic[@"maxDay"] = self.dataDic[@"maxDay"];
    }
    UITextField * minMoney = [self.addProTableView viewWithTag:105];
    if (minMoney.text.length != 0) {
        dic[@"minCash"] = self.dataDic[@"minCash"];
    }
    UITextField * maxMoney = [self.addProTableView viewWithTag:106];
    if (maxMoney.text.length != 0) {
        dic[@"maxCash"] = self.dataDic[@"maxCash"];
    }
    
    dic[@"type"] = self.kindPro;
    
    dic[@"proId"] = [NSString stringWithFormat:@"%ld",self.proID];
    dic[@"cityId"] = [NSString stringWithFormat:@"%ld",self.cityID];
    dic[@"areaId"] = [NSString stringWithFormat:@"%ld",self.areaID];
    if (self.cityID == 0) {
        dic[@"cityId"] = @"";
    }
    if (self.areaID == 0) {
        dic[@"areaID"] = @"";
    }
    UITextView * applyRequire = [self.addProTableView viewWithTag:1000];
    if (applyRequire.text.length != 0) {
        dic[@"appliCondition"] = [self changeString:self.dataDic[@"appliCondition"]];
    }
    
    UITextView * applyMaterials = [self.addProTableView viewWithTag:2000];
    
    if (applyMaterials.text.length != 0) {
        dic[@"appliMaterials"] = [self changeString:self.dataDic[@"appliMaterials"]];
    }
    UITextView * applyMoney = [self.addProTableView viewWithTag:3000];
    
    if (applyMoney.text.length != 0) {
        dic[@"costDescription"] = [self changeString:self.dataDic[@"costDescription"]];
    }
    UITextView * applyInfo = [self.addProTableView viewWithTag:4000];

    if (applyInfo.text.length != 0) {
        dic[@"mechProtext"] = [self changeString:self.dataDic[@"mechProtext"]];
    }
    
    dic[@"path"] = self.imgaePath;
    
    return dic;
}

- (NSString *)changeString:(NSString*)string {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [string dataUsingEncoding:enc];
//    NSString *retStr = [[NSString alloc] initWithData:data encoding:enc];
//    NSString *str = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@",string];
}
//-(void)GoBack{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(LocationView*)locaView
{
    if (_locaView == nil)
    {
        _locaView = [[LocationView alloc] init];
        _locaView.frame = self.navigationController.view.bounds;
        [self.navigationController.view addSubview:_locaView];
        return _locaView;
    }
    [_locaView reloadData];
    return _locaView;
}

#pragma mark -- 图片转Data
-(NSData  *)getDataWitdImgae:(UIImage *)originalImage{
    
    NSData *baseData = UIImageJPEGRepresentation(originalImage, 0.5);
    return baseData;
    
}

#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    [self.addProTableView endEditing:YES];
    [self.TextField endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.TextField endEditing:YES];
    [self.vv removeFromSuperview];
}

#pragma mark --TextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 1000) {
        UILabel * lab = [textView viewWithTag:1001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
    }else if (textView.tag == 2000){
        UILabel * lab = [textView viewWithTag:2001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
        
    }else if (textView.tag == 3000){
        UILabel * lab = [textView viewWithTag:3001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
    }else if (textView.tag == 4000){
        UILabel * lab = [textView viewWithTag:4001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
    }
    
    [self.addProTableView beginUpdates];
    [self.addProTableView endUpdates];
    
}



-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.tag == 1000) {
        UILabel * lab = [textView viewWithTag:1001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
        
        NSString *headerData = textView.text;
        headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self.addProTableView reloadData];
    }else if (textView.tag == 2000){
        UILabel * lab = [textView viewWithTag:2001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
        [self.addProTableView reloadData];
    }else if (textView.tag == 3000){
        UILabel * lab = [textView viewWithTag:3001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
         [self.addProTableView reloadData];
    }else if (textView.tag == 4000){
        UILabel * lab = [textView viewWithTag:4001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
         [self.addProTableView reloadData];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        //        [textView resignFirstResponder];
        return YES; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 1000) {
        UIButton * btn = [self.addProTableView viewWithTag:777];
        btn.hidden = NO;
    }else if (textView.tag == 2000){
        UIButton * btn = [self.addProTableView viewWithTag:778];
        btn.hidden = NO;
    }else if (textView.tag == 3000){
        UIButton * btn = [self.addProTableView viewWithTag:779];
        btn.hidden = NO;
    }else if (textView.tag == 4000){
        UIButton * btn = [self.addProTableView viewWithTag:780];
        btn.hidden = NO;
    }
    
}

-(void)deleteBtnOnClick:(UIButton *)sender{
    
    if (sender.tag == 777) {
        UITextView * textView = [self.addProTableView viewWithTag:1000];
        textView.text = @"";
        
    }else if (sender.tag == 778){
        UITextView * textView = [self.addProTableView viewWithTag:2000];
        textView.text = @"";
        
    }else if (sender.tag == 779){
        UITextView * textView = [self.addProTableView viewWithTag:3000];
        textView.text = @"";
    }else if (sender.tag == 780){
        UITextView * textView = [self.addProTableView viewWithTag:4000];
        textView.text = @"";
    }
   
    [self.addProTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 100) {
        
        [self.dataDic setValue:textField.text forKey:@"mechProName"];
        
    }else if (textField.tag == 101){
        
        [self.dataDic setValue:textField.text forKey:@"mechProGoodness"];
        
    }else if (textField.tag == 102){
        
        [self.dataDic setValue:textField.text forKey:@"tabInterestRate"];
        
    }else if (textField.tag == 103){
        NSLog(@"textField.text == %@",textField.text);
        [self.dataDic setValue:textField.text forKey:@"minDay"];
        self.minDay = [NSString stringWithFormat:@"%@",self.dataDic[@"minDay"]];
        if (![Utils isBlankString:self.maxDay]) {
            if ([self.minDay floatValue]>[self.maxDay floatValue]) {
                self.minDay = [NSString stringWithFormat:@"%g",[self.maxDay floatValue]-1];
                [self.dataDic setValue:self.minDay forKey:@"minDay"];
            }
        }
        
    }else if (textField.tag == 104){
        NSLog(@"textField.text == %@",textField.text);
        [self.dataDic setValue:textField.text forKey:@"maxDay"];
        self.maxDay = [NSString stringWithFormat:@"%@",self.dataDic[@"maxDay"]];
        if (![Utils isBlankString:self.minDay]) {
            if ([self.minDay floatValue]>[self.maxDay floatValue]) {
                self.maxDay = [NSString stringWithFormat:@"%g",[self.minDay floatValue]+1];
                [self.dataDic setValue:self.maxDay forKey:@"maxDay"];
            }
        }
        
    }else if (textField.tag == 105){
        NSLog(@"textField.text == %@",textField.text);
        [self.dataDic setValue:textField.text forKey:@"minCash"];
        self.minCash = [NSString stringWithFormat:@"%@",self.dataDic[@"minCash"]];
        if (![Utils isBlankString:self.maxCash]) {
            if ([self.minCash floatValue]>[self.maxCash floatValue]) {
                self.minCash = [NSString stringWithFormat:@"%g",[self.maxCash floatValue]-1];
                [self.dataDic setValue:self.minCash forKey:@"minCash"];
            }
        }
        
    }else if (textField.tag == 106){
        NSLog(@"textField.text == %@",textField.text);
        [self.dataDic setValue:textField.text forKey:@"maxCash"];
        self.maxCash = [NSString stringWithFormat:@"%@",self.dataDic[@"maxCash"]];
        if (![Utils isBlankString:self.minCash]) {
            if ([self.minCash floatValue]>[self.maxCash floatValue]) {
                self.maxCash = [NSString stringWithFormat:@"%g",[self.minCash floatValue]+1];
                [self.dataDic setValue:self.maxCash forKey:@"maxCash"];
            }
        }
    }
    
    [self.addProTableView reloadData];
    NSLog(@"self.minday = %@,self.maxday = %@,self.mincrash = %@,self.maxcrash = %@",self.dataDic[@"minDay"],self.dataDic[@"maxDay"],self.dataDic[@"minCash"],self.dataDic[@"maxCash"]);
}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    
//    
//
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.TextField = textField;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case 1000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliCondition"];
            
        }
            break;
        case 2000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliMaterials"];
            
        }
            break;
        case 3000:
        {
            [self.dataDic setValue:textView.text forKey:@"costDescription"];
            
        }
            break;
        case 4000:
        {
            [self.dataDic setValue:textView.text forKey:@"mechProtext"];
            
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}



-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [[NSMutableDictionary alloc]init];
    }
    return _dataDic;
}



-(void)returnIsRefreshProduct:(ReturnIsRefreshProductBlock)block{
    
    self.isRefreshProduct = block;
}


-(void)setDic{
    
    [self.dataDic setValue:@"输入申请条件" forKey:@"input1"];
    [self.dataDic setValue:@"输入申请材料" forKey:@"input2"];
    [self.dataDic setValue:@"输入费用说明" forKey:@"input3"];
    [self.dataDic setValue:@"输入备注信息" forKey:@"input4"];


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
