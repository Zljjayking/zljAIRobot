//
//  MemberPayViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MemberPayViewController.h"
#import "MemberLabelCell.h"
#import "MemberButtonCell.h"
#import "MemberTextFieldCell.h"
#import "MemberImageCell.h"
#import "LoginPeopleModel.h"
#import <AlipaySDK/AlipaySDK.h>

#import "PaySuccessViewController.h"

@interface MemberPayViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    LoginPeopleModel * loginPeople;
}

@property (nonatomic,strong) UITableView * memberPayTableView;
@property (nonatomic,strong) UIButton * surePayBtn;

@property (nonatomic,assign) NSInteger customCellHeight;

@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) float payNumber;//支付一个月金额
@property (nonatomic,assign) NSInteger month;//月份
@property (nonatomic,assign) float allPay;//支付总金额

@property (nonatomic,copy) NSString * orderNo;
@property (nonatomic,copy) NSString * payInfo;

@property (nonatomic,strong) UIView * vv;

@end


@implementation MemberPayViewController

-(UITableView *)memberPayTableView{
    if (!_memberPayTableView) {
        _memberPayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStyleGrouped];
    }
    return _memberPayTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 1;

    
    [self getVipPrice];
    
    self.month = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yanzheng) name:@"CallBackResault" object:nil];
    
    self.vv = [[UIView alloc]initWithFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationItem.title = @"会员充值";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
//    self.navigationItem.leftBarButtonItem = left;
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self creatUI];
}

-(void)getVipPrice{
    
    [HttpRequestEngine GetVIPPriceWithCompetion:^(id obj, NSString *errorStr) {
        NSLog(@"obj == %@",obj);
        if (errorStr == nil) {
        
            NSDictionary *dic = [NSDictionary changeType:obj];
            NSLog(@"price == %@",dic);
            
    
            
        }else{
            
            NSLog(@"%@",errorStr);
            [MBProgressHUD showError:@"请求出错"];
        }
        
    }];

    
}

-(void)creatUI{
    
    self.memberPayTableView.delegate = self;
    self.memberPayTableView.dataSource = self;
    self.memberPayTableView.bounces = NO;
    self.memberPayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.memberPayTableView];
    
    [self.memberPayTableView registerClass:[MemberLabelCell class] forCellReuseIdentifier:@"MemberLabelCellID"];
    [self.memberPayTableView registerClass:[MemberButtonCell class] forCellReuseIdentifier:@"MemberButtonCellID"];
    [self.memberPayTableView registerClass:[MemberTextFieldCell class] forCellReuseIdentifier:@"MemberTextFieldCellID"];
    [self.memberPayTableView registerClass:[MemberImageCell class] forCellReuseIdentifier:@"MemberImageCellID"];
    
    self.surePayBtn = [[UIButton alloc]init];
    self.surePayBtn.frame = CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40);
    [self.surePayBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.surePayBtn setTintColor:[UIColor whiteColor]];
    self.surePayBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.surePayBtn setBackgroundColor:[UIColor redColor]];
    self.surePayBtn.layer.cornerRadius = 5.0;
    self.surePayBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.surePayBtn];
    [self.surePayBtn addTarget:self action:@selector(surePayOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 13;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        MemberLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberLabelCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberLabelCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberLabelCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberLabel.text = @"选择时长";

        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        MemberLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberLabelCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberLabelCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberLabelCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.memberLabel.text = @"支付方式";
        
        return cell;

    }else if (indexPath.section == 0 && indexPath.row == 1){
        MemberButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberButtonCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberButtonCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLabel.text = @"1个月";
        
        cell.leftButton.tag = 1;
        if (self.index == 1) {
            cell.leftButton.selected = YES;
        }else{
            cell.leftButton.selected = NO;
        }
        
        [cell.leftButton addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 2){
        MemberButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberButtonCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberButtonCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLabel.text = @"3个月";
        cell.leftButton.tag = 2;
        
        if (self.index == 2) {
            cell.leftButton.selected = YES;
        }else{
            cell.leftButton.selected = NO;
        }
        
        [cell.leftButton addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 3){
        MemberButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberButtonCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberButtonCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLabel.text = @"6个月";
        cell.leftButton.tag = 3;
        if (self.index == 3) {
            cell.leftButton.selected = YES;
        }else{
            cell.leftButton.selected = NO;
        }
        
        [cell.leftButton addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 4){
        MemberButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberButtonCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberButtonCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightLabel.text = @"12个月";
        cell.leftButton.tag = 4;
        if (self.index == 4) {
            cell.leftButton.selected = YES;
        }else{
            cell.leftButton.selected = NO;
        }
        
        [cell.leftButton addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 5){
        MemberButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberButtonCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberButtonCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.rightLabel.text = @"自定义";
        cell.leftButton.tag = 5;
        if (self.index == 5) {
            cell.leftButton.selected = YES;
        }else{
            cell.leftButton.selected = NO;
        }
        
        [cell.leftButton addTarget:self action:@selector(selectOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 6){
        
        MemberTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTextFieldCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberTextFieldCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.customTextField.tag = 6;
        cell.customTextField.delegate = self;

        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        MemberImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberImageCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberImageCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftBtn.selected = YES;
        cell.centerImage.image = [UIImage imageNamed:@"支付宝"];
        cell.rightLabel.text = @"支付宝";
        
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 7){
        
        MemberLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberLabelCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MemberLabelCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberLabelCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.allPay = self.payNumber * self.month;
        NSString * str =[NSString stringWithFormat:@"支付金额:￥%.2f",self.allPay];
        NSMutableAttributedString * message = [[NSMutableAttributedString alloc]initWithString:str];
        //设置：在0-3个单位长度内的内容显示成红色
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, message.length-5)];
        cell.memberLabel.attributedText = message;
        cell.memberLabel.font = [UIFont systemFontOfSize:10];
        
        return cell;

        
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 7) {
        return 20;
    }else if (indexPath.section == 0 && indexPath.row == 6){
        return self.customCellHeight;
    }
    else{
        return 40;
    }
}

-(void)selectOnClick:(UIButton *)sender{
    if (sender.tag == 1) {
        self.index = sender.tag;
        self.month = 1;
        
        self.customCellHeight = 0;
    }else if (sender.tag ==2){
        self.index = sender.tag;
        self.month = 3;
        
        self.customCellHeight = 0;
    }else if (sender.tag == 3){
        self.index = sender.tag;
        self.month = 6;
        
        self.customCellHeight = 0;
    }else if (sender.tag == 4){
        self.index = sender.tag;
        self.month = 12;
        
        self.customCellHeight = 0;
    }else if (sender.tag == 5){
        self.index = sender.tag;
        self.customCellHeight = 40;
        
        self.month = 0;
}
    
    [self.memberPayTableView reloadData];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 6) {
        self.month = [textField.text integerValue];
        
        [self.memberPayTableView reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark --立即支付按钮点击事件
-(void)surePayOnClick:(UIButton *)sender{
    
   /*
    
   loginPeople =  [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    NSString * userId = [NSString stringWithFormat:@"%ld",loginPeople.userId];
    NSString * vipTime = [NSString stringWithFormat:@"%ld",self.month];
    
    NSString * money = [NSString stringWithFormat:@"%.2f",self.allPay];
    
    NSLog(@"m==%@",money);
    
    
    
    [HttpRequestEngine creatTradingOrderWithUserId:userId vipTime:vipTime money:money completion:^(id obj, NSString *errorStr) {
       
        if (errorStr == nil) {
            
             NSDictionary *data = [NSDictionary changeType:obj];
             NSLog(@"数据==%@",data);

            self.orderNo = [NSString stringWithFormat:@"%@",[data objectForKey:@"orderNo"]];
            
            NSString * dataStr = [NSString stringWithFormat:@"%@",data[@"payInfo"]];
            NSLog(@"dataStr==%@",dataStr);
            
            self.payInfo = data[@"payInfo"];
//            self.payInfo = [dataStr stringByReplacingOccurrencesOfString:@"1000" withString:@"0"];
            NSLog(@"payInfo==%@",self.payInfo);
            

            NSString *appScheme = @"alipay.com";
            
            [[AlipaySDK defaultService] payOrder:self.payInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSString *resultStatus = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
                
                NSLog(@"resultStatus == %@",resultStatus);
                
                if([resultStatus  isEqualToString: @"9000"]){
                    [self yanzheng];
                    NSLog(@"充值成功");
                    
                    PaySuccessViewController * psVC = [[PaySuccessViewController alloc]init];
                    
                    [self.navigationController pushViewController:psVC animated:YES];
                }
            }];
            
        }else{
            [MBProgressHUD showError:@"请求出错"];
        }
    }];

    */
    
    PaySuccessViewController * psVC = [[PaySuccessViewController alloc]init];
    
    [self.navigationController pushViewController:psVC animated:YES];
   
}

-(void)yanzheng{
    
    [HttpRequestEngine queryOrderStateWithOrderNo:self.orderNo completion:^(id obj, NSString *errorStr) {
        
        if (errorStr == nil) {
           
            NSDictionary * dic = [NSDictionary changeType:obj];
            NSLog(@"dic==%@",dic);
            
            
            
        }else{
            [MBProgressHUD showError:errorStr toView:self.view];
        }
        
    }];
}


#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    [self.memberPayTableView endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
}

-(void)GoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
