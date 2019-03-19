//
//  MyWalletViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/12.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "MyWalletViewController.h"
#import "billModel.h"
#import "billTableViewCell.h"
#import "TopUpView.h"
#import "protocolViewController.h"
@interface MyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *balanceLb;
@property (nonatomic, strong) UITableView *detailsTableView;
@property (nonatomic, strong) LoginPeopleModel *loginModel;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) UIView *BGView;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray *billsArr;
@property (nonatomic, strong) NSMutableArray *allBillKeysArray;
@property (nonatomic, strong) NSMutableDictionary * billDic;
@property (nonatomic,strong)TopUpView *topUpView;//充值

@property (nonatomic, strong)UIWindow * window;
@end

@implementation MyWalletViewController
- (UITableView *)detailsTableView {
    if (!_detailsTableView) {
        _detailsTableView = [[UITableView alloc]init];
        _detailsTableView.delegate = self;
        _detailsTableView.dataSource = self;
        _detailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailsTableView.tableFooterView = [UIView new];
        [_detailsTableView registerClass:[billTableViewCell class] forCellReuseIdentifier:@"bill"];
        _detailsTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            _billDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [self requestForBills];
        }];
    }
    return _detailsTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的钱包";
    self.page = 0;
    self.billsArr = [NSMutableArray array];
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.uid = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
    
    _allBillKeysArray = [NSMutableArray arrayWithCapacity:0];
    _billDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self setupView];
    [self setupTableView];
    
    [self requestForBalance];
    [self requestForBills];
    
    // Do any additional setup after loading the view.
}
- (void)requestForBalance {
    [HttpRequestEngine getBalanceWithUid:self.uid Completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            self.moneyStr = (NSString *)obj;
            self.balanceLb.text = [self formateStrWith:(NSMutableString *)self.moneyStr];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}

#pragma mark -- 把余额数格式化
-(NSString *)formateStrWith:(NSMutableString *)money{
    
    
    NSString *tempStr = nil;
    BOOL     isLittle = NO; //是否包含小数点
    for (int i = 0; i < money.length; i++) {
        tempStr = [money substringWithRange:NSMakeRange(i, 1)];
        if ([tempStr isEqualToString:@"."]) { //包含小数点
            isLittle = YES;
        }
    }
    return isLittle?[NSString stringWithFormat:@"%@.%@",[self getStrHaveDotWith:[self InvertedWith:(NSMutableString *)[money componentsSeparatedByString:@"."][0]]],[(NSString *)([money componentsSeparatedByString:@"."][1]) substringToIndex:2]]:[self getStrHaveDotWith:[self InvertedWith:money]];
}

-(NSString  *)getStrHaveDotWith:(NSMutableString *)produceStr{
    
    for (unsigned long i = 0 ; i < produceStr.length / 3; i ++ ) {
        if (((i+1)*3+i) < produceStr.length) {
            [produceStr insertString:@"," atIndex:((i+1)*3+i)];
        }
    }
    NSString *returnStr = [self InvertedWith:produceStr];
    return  returnStr;
    
    
}
//倒序字符串
-(NSMutableString *)InvertedWith:(NSMutableString *)string{
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:string.length];
    for (int i = (int)string.length - 1; i >=0 ; i --) {
        unichar ch = [string characterAtIndex:i];
        [newString appendFormat:@"%c", ch];
    }
    return newString;
}

- (void)requestForBills {
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    [HttpRequestEngine getExpenseCalendarWithPage:page uid:self.uid completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            NSArray *arr = [NSArray arrayWithArray:obj];
            NSMutableArray *mutableArr = [NSMutableArray array];
            if (arr.count) {
                for (NSDictionary *dic in arr) {
                    billModel *bill = [billModel requestWithDic:dic];
                    [self.billsArr addObject:bill];
                    [mutableArr addObject:bill];
                }
                [self.detailsTableView.footer endRefreshing];
                if (arr.count < 10) {
                    [self.detailsTableView.footer noticeNoMoreData];
                }
                self.blankV.hidden = YES;
                [self prepareBillListDatasourceWithArray:self.billsArr andToDictionary:_billDic];
                
            } else {
                if (self.page == 0) {
                    self.blankV.hidden = NO;
                }
            }
            
        } else {
            [MBProgressHUD showError:errorStr];
        }
        
    }];
}
- (void)setupView {
    self.BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 162*KAdaptiveRateWidth)];
    if (IS_IPHONE_X) {
        self.BGView.frame = CGRectMake(0, 88, kScreenWidth, 162*KAdaptiveRateWidth);
    }
    self.BGView.backgroundColor = TABBAR_BASE_COLOR;
    [self.view addSubview:self.BGView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 162*KAdaptiveRateWidth-20)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5;
    [self.BGView addSubview:bgView];
    
    UILabel *currentLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 17)];
    currentLb.font = [UIFont systemFontOfSize:16];
    currentLb.text = @"当前余额";
    currentLb.textColor = GRAY120;
    [bgView addSubview:currentLb];
    
    UIButton *explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [explainBtn setImage:[UIImage imageNamed:@"问好"] forState:UIControlStateNormal];
    [explainBtn setTitle:@"余额说明" forState:UIControlStateNormal];
    [explainBtn setTitleColor:GRAY138 forState:UIControlStateNormal];
    explainBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:explainBtn];
    [explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).offset(10);
        make.right.equalTo(bgView.mas_right).offset(-10);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *yuanLb = [[UILabel alloc]init];
    yuanLb.font = KFONT(15*KAdaptiveRateWidth, 0.1);
    yuanLb.text = @"元";
    yuanLb.textColor = kMyColor(29, 46, 55);
    [bgView addSubview:yuanLb];
    
    self.balanceLb = [[UILabel alloc] init];
    self.balanceLb.font = KFONT(40*KAdaptiveRateWidth, 0.1);
    self.balanceLb.text = @"0.00";
    self.balanceLb.textColor = kMyColor(29, 46, 55);
    [bgView addSubview:self.balanceLb];
    [self.balanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(10);
        //make.right.equalTo(yuanLb.mas_left);
        make.centerY.equalTo(bgView.mas_centerY).offset(-10);
        make.height.mas_equalTo(50*KAdaptiveRateWidth);
    }];
    
    
    [yuanLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLb.mas_right).offset(10);
        //make.right.equalTo(bgView.mas_right);
        make.bottom.equalTo(self.balanceLb.mas_bottom).offset(-10*KAdaptiveRateWidth);
        make.height.mas_equalTo(15*KAdaptiveRateWidth);
    }];
    
    UIButton *putinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [putinBtn setBackgroundImage:[UIImage imageNamed:@"putinBtn"] forState:UIControlStateNormal];
    [putinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [putinBtn setTitle:@"充    值" forState:UIControlStateNormal];
    putinBtn.titleLabel.font = KFONT(17, 0.2);
    [bgView addSubview:putinBtn];
    [putinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(35*KAdaptiveRateWidth);
        make.bottom.equalTo(bgView.mas_bottom).offset(-5);
        make.right.equalTo(bgView.mas_right).offset(-35*KAdaptiveRateWidth);
        make.height.mas_equalTo(40);
    }];
    [putinBtn addTarget:self action:@selector(putinBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:signBtn];
    [signBtn addTarget:self action:@selector(signBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateNormal];
    [signBtn setTitleColor:GRAY150 forState:UIControlStateHighlighted];
    signBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(putinBtn.mas_top).offset(-4*KAdaptiveRateWidth);
        make.centerX.equalTo(bgView.mas_centerX);
        make.height.mas_equalTo(15);
    }];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"支付即代表同意《支付协议》"];
    [attStr addAttributes:@{NSForegroundColorAttributeName:customBlue,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(7, 6)];//添加属性
    [attStr addAttributes:@{NSForegroundColorAttributeName:GRAY180,
                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 7)];//添加属性
    [signBtn setAttributedTitle:attStr forState:UIControlStateNormal];
}
#pragma mark == 购买协议的点击方法
- (void)signBtnClick {
    protocolViewController *protocol = [protocolViewController new];
    protocol.type = 2;
    [self.navigationController pushViewController:protocol animated:YES];
}
- (void)setupTableView {
    UILabel *detailLb = [[UILabel alloc] init];
    detailLb.font = KFONT(14, 0.1);
    detailLb.text = @"交易明细";
    detailLb.textColor = kMyColor(29, 46, 55);
    [self.BGView addSubview:detailLb];
    [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BGView.mas_left).offset(20);
        make.top.equalTo(self.BGView.mas_bottom).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [self.view addSubview:self.detailsTableView];
    [self.detailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLb.mas_bottom).offset(10);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.detailsTableView.center.y/2.0+20, 90, 90) imageName:@"noData" title:@"暂无交易信息"];
    [self.detailsTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
}

#pragma mark-排序billList
- (void)prepareBillListDatasourceWithArray:(NSArray *)array andToDictionary:(NSMutableDictionary *)dic
{
    for (billModel *model in array) {
        
        
        NSString *yearAndMonth = [model.createTime substringWithRange:NSMakeRange(0, 7)];
        if (![dic objectForKey:yearAndMonth]) {
            NSMutableArray *arr = [NSMutableArray array];
            [dic setObject:arr forKey:yearAndMonth];
            
        }
        if ([[dic objectForKey:yearAndMonth] containsObject:model]) {
            return;
        }
        [[dic objectForKey:yearAndMonth] addObject:model];
    }
    [self.allBillKeysArray removeAllObjects];
    [self.allBillKeysArray addObjectsFromArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.allBillKeysArray =  (NSMutableArray *)[[self.allBillKeysArray reverseObjectEnumerator] allObjects];
    [self.detailsTableView reloadData];
    if (self.allBillKeysArray.count == 0) {
        self.blankV.hidden = NO;
    } else {
        self.blankV.hidden = YES;
    }
    
}

//充值
- (void)putinBtnClick {
    //充值
    _topUpView = [[TopUpView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 300)];
    
    _topUpView.bgView.hidden = YES;
    
    [self.navigationController.view addSubview:_topUpView.bgView];
    [self.navigationController.view addSubview:_topUpView];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    
    self.topUpView.bgView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    self.topUpView.isPopBlock = ^(){
        weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    };
    _topUpView.isSuccessBlock = ^(){
        [weakSelf requestForBalance];
        [weakSelf requestForBills];
    };
    [UIView animateWithDuration:0.2 animations:^{
        
        self.topUpView.frame = CGRectMake(0, kScreenHeight-300, kScreenWidth, 300);
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allBillKeysArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.billDic objectForKey:self.allBillKeysArray[section]];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    billTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[billTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bill"];
    }
    NSArray *arr = [self.billDic objectForKey:self.allBillKeysArray[indexPath.section]];
    
    billModel *model = arr[indexPath.row];
    
    NSString *newAmount = [NSString stringWithFormat:@"%.2f",[model.money floatValue]];
    
    if ([model.moneyStatus isEqualToString:@"0"]) {
        cell.typeLB.text = @"充值";
        cell.moneyLB.text = [NSString stringWithFormat:@"+%@",newAmount];
        cell.moneyLB.textColor = kMyColor(19, 131, 27);
        
    }else if ([model.moneyStatus isEqualToString:@"1"]){
        cell.typeLB.text = @"消费";
        cell.moneyLB.textColor = kMyColor(211, 91, 41);
        cell.moneyLB.text = [NSString stringWithFormat:@"-%@",newAmount];
    }
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    NSString *strToday = [formatter1 stringFromDate:now];
    NSString *titleStr = [model.createTime substringToIndex:4];
    if ([titleStr isEqualToString:[strToday substringToIndex:4]]) {
        cell.timeLB.text = [model.createTime substringFromIndex:5];
    } else {
        cell.timeLB.text = model.createTime;
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月"];
    NSString *dateString = [formatter stringFromDate:dateNow];
    
    NSString *titleStr = [self.allBillKeysArray[section] stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    titleStr = [NSString stringWithFormat:@"%@月",titleStr];
    if ([dateString isEqualToString:titleStr]) {
        
        titleStr = [titleStr substringToIndex:5];
        titleStr = [NSString stringWithFormat:@"本月"];
    }
    /**
     if ([[dateString substringToIndex:4] isEqualToString:[titleStr substringToIndex:4]]){
     if ([dateString isEqualToString:titleStr]) {
     titleStr = @"本月";
     } else {
     titleStr = [titleStr substringFromIndex:<#(NSUInteger)#>];
     }
     }
     */
    
    return titleStr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewRowAction *DeleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSMutableArray *arr = [self.billDic objectForKey:self.allBillKeysArray[indexPath.section]];
        
        billModel *model = arr[indexPath.row];
        
        [arr removeObject:model];
        
        
        [HttpRequestEngine removeRecordWithOrderRechargeId:model.Id uid:self.uid completion:^(id obj, NSString *errorStr) {
            if (![Utils isBlankString:errorStr]) {
                [MBProgressHUD showError:errorStr];
            }
        }];
        
        [self.detailsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
    DeleteAction.backgroundColor = [UIColor redColor];
    return @[DeleteAction];
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
