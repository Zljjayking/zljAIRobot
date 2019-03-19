//
//  BianjiProductViewController.m
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BianjiProductViewController.h"
#import "ProductChooseTableViewController.h"
#import "AFNetworking.h"
#import "ProductManageViewController.h"

#import "IconProductCell.h"
#import "InputProductInfoCell.h"
#import "SelectProductCell.h"
#import "ApplyInfoCell.h"
#import "LendingInfoCell.h"

#import "LocationData.h"
#import "BankModel.h"
#import "citiesViewController.h"
@interface BianjiProductViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JKAlertViewDelegate,UITextFieldDelegate>

    {
        UIImagePickerController *_imagePickerC;
        UIButton    *_xiajiaBtn; //下架按钮

        // 选择内容arr
        NSArray   *productTypeArr ;
        NSArray   *coustomTypeArr ;
        NSArray   *payTypeArr ;
        NSArray   *zhudaArr ;
        
    }

@property(nonatomic,strong)UITableView * editProductTableView;
@property(nonatomic,strong)NSArray * nameArray;

@property(nonatomic,strong)NSMutableArray *bankArray;

@property(nonatomic,copy)NSString * typeCustomerString;
@property(nonatomic,copy)NSString * returnMoneyString;
@property(nonatomic,copy)NSString * kindPro;

@property(nonatomic,copy)NSString * imagePath;//产品图像地址

@property(nonatomic,strong)UIImage * getImage;

@property(nonatomic,strong)NSMutableDictionary * dataDic;

@property(nonatomic,strong)UIView * vv;

@property(nonatomic, weak) UITextField *TextField;

@property(nonatomic, strong) LoginPeopleModel *loginModel;
@end

@implementation BianjiProductViewController

static NSString *returnString;
- (void)viewWillAppear:(BOOL)animated {
    returnString = _product.mechProType;
    if (![returnString  isEqualToString:_product.mechProType]) {
        [_editProductTableView reloadData];
    }
    [self setData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginModel = [[LoginPeopleModel alloc] initWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
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
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOk)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSLog(@"product.proId == %@",_product.proId);
    [self initDatas];
    [self initUIs];
}

#pragma mark -- Datas

-(void)initDatas{
    
    [HttpRequestEngine getBankOrMechianCompletion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            NSArray *arr = (NSArray *)obj;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                BankModel *bankModel = [BankModel requestWithDic:dic];
                [self.bankArray addObject:bankModel];
            }];
            
            [self.editProductTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
        
    }];
    
    _nameArray = @[@[@"产品图像"],@[@"产品名称",@"所属银行/机构",@"产品类型",@"产品优势",@"产品利率"],@[@"客户类型",@"还款方式",@"放款时间",@"放款额度",@"产品分类",@"产品地址"],@[@"申请条件",@"申请材料",@"费用说明",@"备注信息"]];
    
    productTypeArr = @[@"银行信用贷",@"房产抵押",@"房产按揭",@"车辆抵押",@"车辆按揭",@"企业贷款",@"小额贷款",@"大额贷款",@"过桥垫资",@"信用卡"];
    coustomTypeArr = @[@"企业",@"工薪族",@"个人",@"其他"];
    payTypeArr     = @[@"等额本息",@"等额本金",@"先息后本",@"其他"];
//    zhudaArr       = @[@"普通产品",@"主打产品",@"明星产品"];
    zhudaArr       = @[@"普通产品",@"主打产品"];
    
    
}
#pragma mark -- UIs
-(void)initUIs{
    
    self.navigationItem.title = @"编辑产品";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    _editProductTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-60) style:UITableViewStyleGrouped];
    _editProductTableView.delegate = self;
    _editProductTableView.dataSource = self;
    
    _editProductTableView.showsVerticalScrollIndicator = NO;
    _editProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_editProductTableView];
    
    [_editProductTableView registerNib:[UINib nibWithNibName:@"IconProductCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"IconProductID"];
    
    [_editProductTableView registerNib:[UINib nibWithNibName:@"InputProductInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InputProductInfoCellID"];
    
    [_editProductTableView registerNib:[UINib nibWithNibName:@"SelectProductCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SelectProductCellID"];
    
    [_editProductTableView registerClass:[ApplyInfoCell class] forCellReuseIdentifier:@"ApplyInfoCellID"];
    
    [_editProductTableView registerNib:[UINib nibWithNibName:@"LendingInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LendingInfoCellID"];
    
    //下架按钮
    _xiajiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _xiajiaBtn.frame    = CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40);
    if (IS_IPHONE_X) {
        _editProductTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-80);
        _xiajiaBtn.frame = CGRectMake(10, kScreenHeight-70, kScreenWidth-20, 40);
    }
    _xiajiaBtn.tag   =  0;
    [_xiajiaBtn setTitle:@"下架产品" forState:UIControlStateNormal];
    _xiajiaBtn.titleLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
    _xiajiaBtn.layer.masksToBounds = YES;
    _xiajiaBtn.layer.cornerRadius = [UIAdaption getAdaptiveHeightWith5SHeight:5];
    [_xiajiaBtn setBackgroundImage:[UIImage imageWithColor:customBlueColor] forState:UIControlStateNormal];
    [_xiajiaBtn setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
    [_xiajiaBtn addTarget:self action:@selector(clickXiajia:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_xiajiaBtn];

}
#pragma mark -- UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [UIAdaption getAdaptiveHeightWith5SHeight:10];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [UIAdaption getAdaptiveHeightWith5SHeight:0.1];
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
    }
    
    else if (indexPath.section == 3 && indexPath.row == 0){
        
        NSString *str = [NSString stringWithFormat:@"%@",_product.appliCondition];

        CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth-120];
        if (height > 70) {
            return height+20;
        } else {
            return 70;
        }
    }else if (indexPath.section == 3 && indexPath.row == 1){

        
        NSString *str = [NSString stringWithFormat:@"%@",_product.appliMaterials];
        
        CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth-120];
        if (height > 70) {
            return height+20;
        } else {
            return 70;
        }
    }else if (indexPath.section == 3 && indexPath.row == 2){

        
        NSString *str = [NSString stringWithFormat:@"%@",_product.costDescription];

        CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth-120];
        if (height > 70) {
            return height+20;
        } else {
            return 70;
        }
    }else{
        
        NSString *str = [NSString stringWithFormat:@"%@",_product.mechProtext];

        CGFloat height = [str heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth-120];
        if (height > 70) {
            return height+20;
        } else {
            return 70;
        }
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 5;
            
        case 2:
            return 6;
            
        case 3:
            return 4;
            
        default:
            return 4;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditProductCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditProductCell"];
    }
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {//产品图像
        
        IconProductCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IconProductID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.iconProLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.addIconButton.tag=19;
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,_product.mechProIcon];
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        
        [cell.addIconButton sd_setBackgroundImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
        
        [cell.addIconButton addTarget:self action:@selector(AddIconOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 0){ //产品名称
        
        InputProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputProductInfoCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.inputproductLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.inputProductTextField.placeholder = @"输入产品名称";
        cell.inputProductTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.inputProductTextField.borderStyle = UITextBorderStyleNone;
        cell.inputProductTextField.tintColor = TABBAR_BASE_COLOR;
        cell.inputProductTextField.returnKeyType = UIReturnKeyDone;
        cell.inputProductTextField.text = _product.mechProName;
        cell.inputProductTextField.delegate = self;
        cell.inputProductTextField.tag = 100;
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 3){  //产品优势
        
        InputProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputProductInfoCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.inputproductLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.inputProductTextField.placeholder = @"输入产品优势";
        cell.inputProductTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.inputProductTextField.borderStyle = UITextBorderStyleNone;
        cell.inputProductTextField.tintColor = TABBAR_BASE_COLOR;
        cell.inputProductTextField.returnKeyType = UIReturnKeyDone;
        if ([_product.mechProGoodness isEqual:@"null"]) {
            cell.inputProductTextField.text = @"";
        }else{
        cell.inputProductTextField.text = _product.mechProGoodness;
        }
        cell.inputProductTextField.delegate = self;
        cell.inputProductTextField.tag = 101;
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 4){  //产品利率
        
        InputProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputProductInfoCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.inputproductLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.inputProductTextField.placeholder = @"输入产品利率: %";
        cell.inputProductTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.inputProductTextField.borderStyle = UITextBorderStyleNone;
        cell.inputProductTextField.tintColor = TABBAR_BASE_COLOR;
        cell.inputProductTextField.returnKeyType = UIReturnKeyDone;
        if ([_product.tabInterestRate isEqual:@"null"]) {
            cell.inputProductTextField.text = @"";
        }else{
            cell.inputProductTextField.text = _product.tabInterestRate;
        }
        cell.inputProductTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.inputProductTextField.delegate = self;
        cell.inputProductTextField.tag = 102;
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 2){ //产品类型
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag  = indexPath.section*10 + indexPath.row;
        
        NSString *str = [NSString stringWithFormat:@"%@",_product.mechProType];
        [cell.selectProButton setTitle:str forState:UIControlStateNormal];
        if (str.length != 0) {
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section == 1 && indexPath.row == 1){ //所属银行获机构
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag  = indexPath.section*10 + indexPath.row;
        
        NSString *str = [NSString stringWithFormat:@"%@",_product.bankId];
        NSString *bankName;
        for (BankModel *model in self.bankArray) {
            if ([model.bankId isEqualToString:str]) {
                bankName = model.bankName;
            }
        }
        [cell.selectProButton setTitle:bankName forState:UIControlStateNormal];
        if (str.length != 0) {
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section ==2 && indexPath.row == 0){ //客户类型
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        NSString *str = [NSString stringWithFormat:@"%@",_product.tabCustomerType];
        if ([str isEqualToString:@"1"]) {
            [cell.selectProButton setTitle:@"企业" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"2"]) {
            [cell.selectProButton setTitle:@"工薪族" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"3"]) {
            [cell.selectProButton setTitle:@"个人" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"4"]){
            [cell.selectProButton setTitle:@"其他" forState:UIControlStateNormal];
        }
        if (str.length != 0) {
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 2 && indexPath.row == 1){  //还款方式
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *str = [NSString stringWithFormat:@"%@",_product.tabReimburSement];
        if ([str isEqualToString:@"1"]) {
            [cell.selectProButton setTitle:@"等额本息" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"2"]) {
            [cell.selectProButton setTitle:@"等额本金" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"3"]) {
            [cell.selectProButton setTitle:@"先息后本" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"4"]){
            [cell.selectProButton setTitle:@"其他" forState:UIControlStateNormal];
        }
        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (str.length != 0) {
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 2 && indexPath.row == 2){  //放款时间
        LendingInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LendingInfoCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.LendingLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.minTextField.placeholder = @"最短时间";
        cell.minTextField.text = [NSString stringWithFormat:@"%@",_product.minDay];
        cell.minTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.minTextField.borderStyle = UITextBorderStyleNone;
        cell.minTextField.tintColor = TABBAR_BASE_COLOR;
        cell.minTextField.tag = 103;
        cell.minTextField.delegate = self;
        cell.minTextField.returnKeyType = UIReturnKeyDone;
        cell.minTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        cell.maxTextField.placeholder = @"最长时间";
        cell.maxTextField.text = [NSString stringWithFormat:@"%@",_product.maxDay];
        cell.maxTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.maxTextField.borderStyle = UITextBorderStyleNone;
        cell.maxTextField.tintColor = TABBAR_BASE_COLOR;
        cell.maxTextField.delegate = self;
        cell.maxTextField.returnKeyType = UIReturnKeyDone;
        cell.maxTextField.tag = 104;
        cell.maxTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.timeAndMoneyLabel.text = @"天";
        
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 3){  //放款额度
        
        LendingInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LendingInfoCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.LendingLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        cell.minTextField.placeholder = @"最小金额";
        cell.minTextField.text = [NSString stringWithFormat:@"%@",_product.minCash];
        cell.minTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.minTextField.borderStyle = UITextBorderStyleNone;
        cell.minTextField.tintColor = TABBAR_BASE_COLOR;
        cell.minTextField.delegate = self;
        cell.minTextField.returnKeyType = UIReturnKeyDone;
        cell.minTextField.tag = 105;
        cell.minTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.maxTextField.placeholder = @"最大金额";
        cell.maxTextField.text = [NSString stringWithFormat:@"%@",_product.maxCash];
        cell.maxTextField.clearButtonMode = UITextFieldViewModeAlways;
        cell.maxTextField.borderStyle = UITextBorderStyleNone;
        cell.maxTextField.tintColor = TABBAR_BASE_COLOR;
        cell.maxTextField.tag = 106;
        cell.maxTextField.delegate = self;
        cell.maxTextField.returnKeyType = UIReturnKeyDone;
        cell.timeAndMoneyLabel.text = @"万元";
        cell.maxTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        return cell;
        
    }
    else if (indexPath.section == 2 && indexPath.row == 4){  //产品分类
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *str = [NSString stringWithFormat:@"%@",_product.type];
        if ([str isEqualToString:@"1"]) {
            [cell.selectProButton setTitle:@"普通产品" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"2"]) {
            [cell.selectProButton setTitle:@"主打产品" forState:UIControlStateNormal];
        } else if ([str isEqualToString:@"3"]) {
            [cell.selectProButton setTitle:@"明星产品" forState:UIControlStateNormal];
        }

        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        if (str.length != 0) {
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [cell.selectProButton addTarget:self action:@selector(AddclickChoose:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section == 2 && indexPath.row == 5){  //产品地址
        
        SelectProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectProductCellID"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.selectProLabel.text = _nameArray[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell.selectProButton setTitle:[LocationData getLocationString:[_product.proId integerValue] cityId:[_product.cityId integerValue]  areaId:[_product.areaId integerValue]] forState:UIControlStateNormal];
        
        if (cell.selectProButton.titleLabel.text.length != 0) {
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

        cell.selectProButton.tag = indexPath.section*10 + indexPath.row;
        [cell.selectProButton addTarget:self action:@selector(AddressClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 3 && indexPath.row == 0){ //申请条件
        
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        if ([_product.appliCondition isEqual:@"null"]) {
            cell.applyInfoTextView.text = @"";
        }else{
            cell.applyInfoTextView.text = self.dataDic[@"appliCondition"];
      
        }
        
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 1000;
        
        cell.placeholderLabel.tag = 1001;
        cell.placeholderLabel.text = self.dataDic[@"input1"];
  
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
            cell.deleteBtn.hidden = YES;
        }
        
        UIView *separator = [[UIView alloc]init];
        separator.backgroundColor = GRAY200;
        [cell addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(18);
            make.right.equalTo(cell.mas_right).offset(0);
            make.bottom.equalTo(cell.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.2);
        }];
        
        cell.deleteBtn.tag = 777;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }else if (indexPath.section == 3 && indexPath.row == 1){ //申请材料
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        
        if ([_product.appliMaterials isEqual:@"null"]) {
            cell.applyInfoTextView.text = @"";
        }else{
            cell.applyInfoTextView.text = self.dataDic[@"appliMaterials"];
        }
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 2000;
        
        cell.placeholderLabel.tag = 2001;
        cell.placeholderLabel.text = self.dataDic[@"input2"];
        
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
            cell.deleteBtn.hidden = YES;
        }
        
        cell.deleteBtn.tag = 778;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *separator = [[UIView alloc]init];
        separator.backgroundColor = GRAY200;
        [cell addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(18);
            make.right.equalTo(cell.mas_right).offset(0);
            make.bottom.equalTo(cell.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.2);
        }];
        return cell;
    }else if (indexPath.section == 3 && indexPath.row == 2){  //费用说明
        
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        if ([_product.costDescription isEqual:@"null"]) {
            cell.applyInfoTextView.text =@"";
        }else{
        cell.applyInfoTextView.text = self.dataDic[@"costDescription"];
        }
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 3000;
        
        cell.placeholderLabel.tag = 3001;
        cell.placeholderLabel.text = self.dataDic[@"input3"];
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
            cell.deleteBtn.hidden = YES;
        }
        
        cell.deleteBtn.tag = 779;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *separator = [[UIView alloc]init];
        separator.backgroundColor = GRAY200;
        [cell addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(18);
            make.right.equalTo(cell.mas_right).offset(0);
            make.bottom.equalTo(cell.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.2);
        }];
        return cell;
        
    }else if (indexPath.section == 3 && indexPath.row == 3){  //备注信息
        
        ApplyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyInfoCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ApplyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ApplyInfoCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.applyInfoLabel.text = _nameArray[indexPath.section][indexPath.row];
        if ([_product.mechProtext isEqual:@"null"]) {
            cell.applyInfoTextView.text = @"";
        }else{
            cell.applyInfoTextView.text = self.dataDic[@"mechProtext"];

        }
        cell.applyInfoTextView.delegate = self;
        cell.applyInfoTextView.tag = 4000;
        
        cell.placeholderLabel.tag = 4001;
        cell.placeholderLabel.text = self.dataDic[@"input4"];
        
        if (cell.applyInfoTextView.text.length != 0) {
            cell.placeholderLabel.hidden = YES;
        }else{
            cell.placeholderLabel.hidden = NO;
            cell.deleteBtn.hidden = YES;
        }
        
        cell.deleteBtn.tag = 780;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView *separator = [[UIView alloc]init];
        separator.backgroundColor = GRAY200;
        [cell addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(18);
            make.right.equalTo(cell.mas_right).offset(0);
            make.bottom.equalTo(cell.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.2);
        }];
        return cell;
      
    }
    
    return cell;
}


#pragma mark -- 产品下架
-(void)clickXiajia:(UIButton *)sender{
    
    // 准备初始化配置参数
    NSString *title = @"下架产品";
    NSString *message = @"确认下架该产品吗";
    NSString *okButtonTitle = @"下架";
    NSString *cancelButtonTitle = @"取消";
    
    NSString *eid = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建下架操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        NSDictionary *parameters = @{@"inter":@"updown2",@"eid":eid,@"pid":[NSString stringWithFormat:@"%@",self.product.ID],@"type":@2};
        [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *data = [NSDictionary changeType:responseObject];
            NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
            if (![code isEqualToString:@"200"]) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
            } else {
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
               
                
                ProductManageViewController * pmVC = [ProductManageViewController new];
                pmVC.seType = 1;
                
//                if (self.isRefreshXiaJia != nil) {
//                    NSString * xiajia = @"11";
//                    self.isRefreshXiaJia(xiajia);
//                }
                NSDictionary *dic = [NSDictionary dictionaryWithObject:@"11" forKey:@"isRefreshXiaJia"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isRefreshXiaJia" object:self userInfo:dic];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[ProductManageViewController class]]) {
                        
                        [self.navigationController popToViewController:temp animated:YES];
                    }  
                }
            }
            NSLog(@"JSON: %@", data);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
        }];
        

        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // 添加操作
    [alertDialog addAction:okAction];
    [alertDialog addAction:cancelAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];

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
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
//    actionSheet.delegate       = self;
//    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

#pragma mark --  UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePickerC = [[UIImagePickerController alloc]init];
    _imagePickerC.allowsEditing = YES;
    _imagePickerC.delegate = self;
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    _imagePickerC.navigationBar.titleTextAttributes = textAttributes;
    [_imagePickerC.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
    [_imagePickerC.navigationBar setTranslucent:NO];
     if(buttonIndex == 0){ //相册
        _imagePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerC animated:YES completion:nil];
    }
}
#pragma mark -- UIImagePickerView
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    self.getImage=  [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    [self dismissViewControllerAnimated:picker completion:^{
        UIButton* imagebtn = [self.editProductTableView viewWithTag:19];
//        [imagebtn setBackgroundImage:self.getImage forState:UIControlStateNormal];
        imagebtn.tag = 1;
        [HttpRequestEngine uploadImageData:[self getDataWitdImgae:self.getImage] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
            if (errorStr)
            {
                [MBProgressHUD showError:errorStr toView:self.view];
            }else{
                
                NSDictionary *dic = [NSDictionary changeType:obj];
                
                self.imagePath = dic[@"errorMsg"];
                NSLog(@"self.imagePath == %@",self.imagePath);
                _product.mechProIcon = self.imagePath;
                [_editProductTableView reloadData];
                [MBProgressHUD showSuccess:@"添加成功"];
                
                [imagebtn setBackgroundImage:self.getImage forState:UIControlStateNormal];
                
            }
        }];

    }];
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
    if (sender.tag <= 24) {
        [self.navigationController pushViewController:productChoose animated:YES];
    }
    
    [productChoose returnText:^(NSString *returnStr) {
        
        returnString  = returnStr;
        if (sender.tag == 11) {
            for (BankModel *model in self.bankArray) {
                if ([returnString isEqualToString:model.bankName]) {
                    _product.bankId = model.bankId;
                }
            }
        }else if (sender.tag == 12) {
            _product.mechProType = returnStr;
        }else if(sender.tag == 20){
            
        }else if (sender.tag == 21){
            
        }else if(sender.tag == 24){
            UIButton * kindPro = [self.editProductTableView viewWithTag:24];
            if ([kindPro.titleLabel.text isEqualToString:@"普通产品"]) {
                _product.type = @"1";
            }else if ([kindPro.titleLabel.text isEqualToString:@"主打产品"]){
                _product.type = @"2";
            }else if ([kindPro.titleLabel.text isEqualToString:@"明星产品"]){
                _product.type = @"3";
            }
        }
        [sender setTitle:returnString forState:UIControlStateNormal];
        
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
    }];
}

//产品地址

-(void)AddressClick:(UIButton *)sender{
    if (sender.tag == 25){
        
        citiesViewController *citiesVC = [[citiesViewController alloc]init];
        citiesVC.type = 5;
        citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
            _product.proId = selectedProID;
            _product.cityId = selectedCityID;
            _product.areaId = selectedAreaID;
            
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
            
            SelectProductCell *cell = (SelectProductCell*)[_editProductTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:2]];
            [cell.selectProButton setTitle:str forState:UIControlStateNormal];
            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        };
        citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:citiesVC animated:YES completion:nil];
        
//        __weak LocationView * weakView = self.locaView;
//        weakView.locaBlock = ^(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str){
//            
//            _product.proId = [NSString stringWithFormat:@"%ld",num1];
//            _product.cityId = [NSString stringWithFormat:@"%ld",num2];
//            _product.areaId = [NSString stringWithFormat:@"%ld",num3];
//            
//            
//            SelectProductCell *cell = (SelectProductCell*)[_editProductTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:2]];
//            [cell.selectProButton setTitle:str forState:UIControlStateNormal];
//            [cell.selectProButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        };
    }else {
        _product.proId = 0;
        _product.cityId = 0;
        _product.areaId = 0;
    }
}

#pragma mark --编辑产品的点击事件
-(void)ClickOk{
    
    JKAlertView * editAlertView = [[JKAlertView alloc]initWithTitle:@"编辑产品" message:@"确定修改该产品吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [editAlertView show] ;
    
   }

-(void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
   //     UITextField * namePro = [self.editProductTableView viewWithTag:100];
//        UIButton * typePro = [self.editProductTableView viewWithTag:11];
//        for (BankModel *model in self.bankArray) {
//            if ([typePro.titleLabel.text isEqualToString:model.bankName]) {
//                _product.bankId = model.bankId;
//            }
//        }
        NSString *bankId = [NSString stringWithFormat:@"%@",_product.bankId];
        
        UIButton * typeCustomer = [self.editProductTableView viewWithTag:20];
        if ([typeCustomer.titleLabel.text isEqualToString:@"企业"]) {
            self.typeCustomerString = [typeCustomer.titleLabel.text stringByReplacingOccurrencesOfString:@"企业" withString:@"1"];
        }else if ([typeCustomer.titleLabel.text isEqualToString:@"工薪族"]){
            self.typeCustomerString = [typeCustomer.titleLabel.text stringByReplacingOccurrencesOfString:@"工薪族" withString:@"2"];
        }else if ([typeCustomer.titleLabel.text isEqualToString:@"个人"]){
            self.typeCustomerString = [typeCustomer.titleLabel.text stringByReplacingOccurrencesOfString:@"个人" withString:@"3"];
        }else if ([typeCustomer.titleLabel.text isEqualToString:@"其他"]){
            self.typeCustomerString = [typeCustomer.titleLabel.text stringByReplacingOccurrencesOfString:@"其他" withString:@"4"];
        }
        
        UIButton * returnMoney = [self.editProductTableView viewWithTag:21];
        if ([returnMoney.titleLabel.text isEqualToString:@"等额本息"]) {
            self.returnMoneyString = [returnMoney.titleLabel.text stringByReplacingOccurrencesOfString:@"等额本息" withString:@"1"];
        }else if ([returnMoney.titleLabel.text isEqualToString:@"等额本金"]){
            self.returnMoneyString = [returnMoney.titleLabel.text stringByReplacingOccurrencesOfString:@"等额本金" withString:@"2"];
        }else if ([returnMoney.titleLabel.text isEqualToString:@"先息后本"]){
            self.returnMoneyString = [returnMoney.titleLabel.text stringByReplacingOccurrencesOfString:@"先息后本" withString:@"3"];
        }else if ([returnMoney.titleLabel.text isEqualToString:@"其他"]){
            self.returnMoneyString = [returnMoney.titleLabel.text stringByReplacingOccurrencesOfString:@"其他" withString:@"4"];
        }
        
        self.kindPro = [NSString stringWithFormat:@"%@",_product.type];
//        UIButton * kindPro = [self.editProductTableView viewWithTag:24];
//        if ([kindPro.titleLabel.text isEqualToString:@"普通产品"]) {
//            self.kindPro = [kindPro.titleLabel.text stringByReplacingOccurrencesOfString:@"普通产品" withString:@"1"];
//        }else if ([kindPro.titleLabel.text isEqualToString:@"主打产品"]){
//            self.kindPro = [kindPro.titleLabel.text stringByReplacingOccurrencesOfString:@"主打产品" withString:@"2"];
//        }else if ([kindPro.titleLabel.text isEqualToString:@"明星产品"]){
//            self.kindPro = [kindPro.titleLabel.text stringByReplacingOccurrencesOfString:@"明星产品" withString:@"3"];
//        }
        
        
        if (_product.mechProName.length == 0) {
            JKAlertView * alertName = [[JKAlertView alloc]initWithTitle:@"请输入产品名称" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertName show] ;
        }else if ([_product.mechProType isEqualToString:@"点击选择"]){
            JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品类型" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertType show] ;
        }else if ([Utils isBlankString:bankId]){
            JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品所属银行/机构" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertType show] ;
        }else if (_product.mechProIcon.length == 0){
            JKAlertView * alertRate = [[JKAlertView alloc]initWithTitle:@"请添加产品图像" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertRate show] ;
        }else if ([self.kindPro isEqualToString:@"点击选择"]){
            JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品分类" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertType show] ;
            
        }else if (_product.proId == 0 && _product.cityId == 0 && _product.areaId == 0  ){
            JKAlertView * alertType = [[JKAlertView alloc]initWithTitle:@"请选择产品地址" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            
            [alertType show] ;
            
        }

        else{
            
            NSDictionary *parameters = [self dicWithInterType:@"updateproduct2" MechProId:[_product.ID integerValue]];
            NSLog(@"parameters == %@",parameters);
            NSArray *dataArr = [NSArray arrayWithObject:_product];
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *data = [NSDictionary changeType:responseObject];
                NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                if (![code isEqualToString:@"200"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                } else {
                    [MBProgressHUD showSuccess:@"编辑成功"];
                    
                    if (self.isRefreshBianji != nil) {
                        
                        self.isRefreshBianji(dataArr);
                    }
                    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"9" forKey:@"refreshPro"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshPro" object:self userInfo:dic];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                NSLog(@"JSON: %@", data);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
        }

    }
}



-(NSMutableDictionary *)dicWithInterType:(NSString *)interType MechProId:(NSInteger)mechProId{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    dic[@"inter"] = interType;
    dic[@"pid"] = [NSString stringWithFormat:@"%ld",mechProId];
    dic[@"eid"] = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    dic[@"bankId"] = _product.bankId;
    _product.ID = [NSString stringWithFormat:@"%ld",mechProId];
    UITextField * namePro = [self.editProductTableView viewWithTag:100];
    dic[@"mechProName"] = _product.mechProName;
    _product.mechProName = namePro.text;
    UIButton * typePro = [self.editProductTableView viewWithTag:12];
    dic[@"mechProType"] = typePro.titleLabel.text;
    _product.mechProType = typePro.titleLabel.text;
    UITextField * advantagePro = [self.editProductTableView viewWithTag:101];
    
    if (_product.mechProGoodness.length != 0) {
        dic[@"mechProGoodness"] = _product.mechProGoodness;
        _product.mechProGoodness = advantagePro.text;
    }
    
    UITextField * ratePro = [self.editProductTableView viewWithTag:102];
    if (_product.tabInterestRate.length != 0) {
        dic[@"tabInterestRate"] = _product.tabInterestRate;
        _product.tabInterestRate = ratePro.text;
    }
    
    _product.tabCustomerType = self.typeCustomerString;
    dic[@"tabCustomerType"] = _product.tabCustomerType;
    
    _product.tabReimburSement = self.returnMoneyString;
    dic[@"tabReimburSement"] = _product.tabReimburSement;
    
    UITextField * minTime = [self.editProductTableView viewWithTag:103];
    if (minTime.text.length != 0) {
        _product.minDay = minTime.text;
        dic[@"minDay"] = _product.minDay;
        
    }
    UITextField * maxTime = [self.editProductTableView viewWithTag:104];
    if (maxTime.text.length != 0) {
        _product.maxDay = maxTime.text;
        dic[@"maxDay"] = _product.maxDay;
        
    }
    UITextField * minMoney = [self.editProductTableView viewWithTag:105];
    if (minMoney.text.length != 0) {
        _product.minCash = minMoney.text;
        dic[@"minCash"] = _product.minCash;
        
    }
    UITextField * maxMoney = [self.editProductTableView viewWithTag:106];
    if (maxMoney.text.length != 0) {
        _product.maxCash = maxMoney.text;
        dic[@"maxCash"] = _product.maxCash;
        
    }
    
    
    _product.type = self.kindPro;
    dic[@"type"] = _product.type;
    dic[@"proId"] = [NSString stringWithFormat:@"%@",_product.proId];
    dic[@"cityId"] = [NSString stringWithFormat:@"%@",_product.cityId];
    dic[@"areaId"] = [NSString stringWithFormat:@"%@",_product.areaId];
    
    
    dic[@"appliCondition"] = self.dataDic[@"appliCondition"];
    dic[@"appliMaterials"] = self.dataDic[@"appliMaterials"];
    dic[@"costDescription"] = self.dataDic[@"costDescription"];
    dic[@"mechProtext"] = self.dataDic[@"mechProtext"];
    
//    UITextView * applyRequire = [self.editProductTableView viewWithTag:1000];
//    if (applyRequire.text.length != 0) {
//        dic[@"appliCondition"] = self.dataDic[@"appliCondition"];
//        _product.appliCondition = applyRequire.text;
//    }
//    
//    UITextView * applyMaterials = [self.editProductTableView viewWithTag:2000];
//    if (applyMaterials.text.length != 0) {
//        dic[@"appliMaterials"] = self.dataDic[@"appliMaterials"];
//        _product.appliMaterials = applyMaterials.text;
//    }
//    
//    UITextView * applyMoney = [self.editProductTableView viewWithTag:3000];
//    if (applyMoney.text.length != 0) {
//        dic[@"costDescription"] = self.dataDic[@"costDescription"];
//        _product.costDescription = applyMoney.text;
//    }
//    
//    UITextView * applyInfo = [self.editProductTableView viewWithTag:4000];
//    if (applyInfo.text.length != 0) {
//        dic[@"mechProtext"] = self.dataDic[@"mechProtext"];
//        _product.mechProtext = applyInfo.text;
//    }
    
    dic[@"path"] = _product.mechProIcon;
//    if (self.imagePath.length != 0) {
//        _product.mechProIcon = self.imagePath;
//    }
    
    return dic;
}

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
#pragma mark -- textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textField.text == %@",textField.text);
    switch (textField.tag) {
        case 100:
        {
            _product.mechProName = textField.text;
            
        }
            break;
        case 101:
        {
            
            _product.mechProGoodness = textField.text;
            
        }
            break;
        case 102:
        {
            
            _product.tabInterestRate = textField.text;
            
        }
            break;
        case 103:
        {
            
            if ([textField.text floatValue]>[_product.maxDay floatValue]) {
                _product.minDay = [NSString stringWithFormat:@"%g",[_product.maxDay floatValue]-1];
            } else {
                _product.minDay = textField.text;
            }
            
        }
            break;
        case 104:
        {
            if ([textField.text floatValue]<[_product.minDay floatValue]) {
                _product.maxDay = [NSString stringWithFormat:@"%g",[_product.minDay floatValue]+1];
            } else {
                _product.maxDay = textField.text;
            }
            
        }
            break;
        case 105:
        {
            
            if ([textField.text floatValue]>[_product.maxCash floatValue]) {
                _product.minCash = [NSString stringWithFormat:@"%g",[_product.maxCash floatValue]-1];
            } else {
                _product.minCash = textField.text;
            }
        }
            break;
        case 106:
        {
            
            
            if ([textField.text floatValue]<[_product.minCash floatValue]) {
                _product.maxCash = [NSString stringWithFormat:@"%g",[_product.minCash floatValue]+1];
            } else {
                _product.maxCash = textField.text;
            }
        }
            break;
        default:
            break;
    }
    [self.editProductTableView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.TextField = textField;
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
    switch (textView.tag) {
        case 1000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliCondition"];
            _product.appliCondition = textView.text;
            
        }
            break;
        case 2000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliMaterials"];
            _product.appliMaterials = textView.text;
            
        }
            break;
        case 3000:
        {
            [self.dataDic setValue:textView.text forKey:@"costDescription"];
            _product.costDescription = textView.text;
            
        }
            break;
        case 4000:
        {
            [self.dataDic setValue:textView.text forKey:@"mechProtext"];
            _product.mechProtext = textView.text;
            
        }
            break;
            
        default:
            break;
    }
    [self.editProductTableView beginUpdates];
    [self.editProductTableView endUpdates];
    
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
      //  [self.editProductTableView reloadData];
    }else if (textView.tag == 2000){
        UILabel * lab = [textView viewWithTag:2001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
       // [self.editProductTableView reloadData];
    }else if (textView.tag == 3000){
        UILabel * lab = [textView viewWithTag:3001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
      //  [self.editProductTableView reloadData];
    }else if (textView.tag == 4000){
        UILabel * lab = [textView viewWithTag:4001];
        if (textView.text.length != 0) {
            lab.hidden = YES;
        }else{
            lab.hidden = NO;
        }
       //  [self.editProductTableView reloadData];
    }
    switch (textView.tag) {
        case 1000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliCondition"];
            _product.appliCondition = textView.text;
            
        }
            break;
        case 2000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliMaterials"];
            _product.appliMaterials = textView.text;
            
        }
            break;
        case 3000:
        {
            [self.dataDic setValue:textView.text forKey:@"costDescription"];
            _product.costDescription = textView.text;
            
        }
            break;
        case 4000:
        {
            [self.dataDic setValue:textView.text forKey:@"mechProtext"];
            _product.mechProtext = textView.text;
            
        }
            break;
            
        default:
            break;
    }
    [self.editProductTableView reloadData];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        //        [textView resignFirstResponder];
        return YES; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    switch (textView.tag) {
        case 1000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliCondition"];
            _product.appliCondition = textView.text;
            
        }
            break;
        case 2000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliMaterials"];
            _product.appliMaterials = textView.text;
            
        }
            break;
        case 3000:
        {
            [self.dataDic setValue:textView.text forKey:@"costDescription"];
            _product.costDescription = textView.text;
            
        }
            break;
        case 4000:
        {
            [self.dataDic setValue:textView.text forKey:@"mechProtext"];
            _product.mechProtext = textView.text;
            
        }
            break;
            
        default:
            break;
    }
//    [self.editProductTableView reloadData];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 1000) {
        UIButton * btn = [self.editProductTableView viewWithTag:777];
        btn.hidden = NO;
    }else if (textView.tag == 2000){
        UIButton * btn = [self.editProductTableView viewWithTag:778];
        btn.hidden = NO;
    }else if (textView.tag == 3000){
        UIButton * btn = [self.editProductTableView viewWithTag:779];
        btn.hidden = NO;
    }else if (textView.tag == 4000){
        UIButton * btn = [self.editProductTableView viewWithTag:780];
        btn.hidden = NO;
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case 1000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliCondition"];
            _product.appliCondition = textView.text;
            
        }
            break;
        case 2000:
        {
            [self.dataDic setValue:textView.text forKey:@"appliMaterials"];
            _product.appliMaterials = textView.text;
            
        }
            break;
        case 3000:
        {
            [self.dataDic setValue:textView.text forKey:@"costDescription"];
            _product.costDescription = textView.text;
            
        }
            break;
        case 4000:
        {
            [self.dataDic setValue:textView.text forKey:@"mechProtext"];
            _product.mechProtext = textView.text;
            
        }
            break;
            
        default:
            break;
    }
    [self.editProductTableView reloadData];
    return YES;
}

-(void)deleteBtnOnClick:(UIButton *)sender{
    
    if (sender.tag == 777) {
        UITextView * textView = [self.editProductTableView viewWithTag:1000];
        [textView becomeFirstResponder];
        textView.text = @"";
        
    }else if (sender.tag == 778){
        UITextView * textView = [self.editProductTableView viewWithTag:2000];
        [textView becomeFirstResponder];
        textView.text = @"";
        
    }else if (sender.tag == 779){
        UITextView * textView = [self.editProductTableView viewWithTag:3000];
        [textView becomeFirstResponder];
        textView.text = @"";
    }else if (sender.tag == 780){
        UITextView * textView = [self.editProductTableView viewWithTag:4000];
        [textView becomeFirstResponder];
        textView.text = @"";
    }
    
   // [self.editProductTableView reloadData];
}


-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

-(void)setData{
    
    [self.dataDic setValue:_product.appliCondition forKey:@"appliCondition"];
    [self.dataDic setValue:_product.appliMaterials forKey:@"appliMaterials"];
    [self.dataDic setValue:_product.costDescription forKey:@"costDescription"];
    [self.dataDic setValue:_product.mechProtext forKey:@"mechProtext"];
    
    [self.dataDic setValue:@"输入申请条件" forKey:@"input1"];
    [self.dataDic setValue:@"输入申请材料" forKey:@"input2"];
    [self.dataDic setValue:@"输入费用说明" forKey:@"input3"];
    [self.dataDic setValue:@"输入备注信息" forKey:@"input4"];
    
    NSLog(@"dataDic == %@",self.dataDic);

}

#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    NSLog(@"self.TextField");
//    [self.editProductTableView endEditing:YES];
    [self.TextField endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.TextField endEditing:YES];
    [self.vv removeFromSuperview];
}

#pragma mark -- 图片转Data
-(NSData  *)getDataWitdImgae:(UIImage *)originalImage{
    
    NSData *baseData = UIImageJPEGRepresentation(originalImage, 0.5);
    return baseData;
    
}

-(void)returnIsRefreshXiaJia:(ReturnIsRefreshXiaJiaBlock)block{
    self.isRefreshXiaJia = block;
}

-(void)returnIsRefreshBianJi:(ReturnIsRefreshBianJiBlock)block{
    self.isRefreshBianji = block;
}



@end
