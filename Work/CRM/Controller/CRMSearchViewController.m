//
//  CRMSearchViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMSearchViewController.h"
#import "ButtonsModel.h"

#import "CRMSearOneCell.h"
#import "SearchThreeCell.h"
#import "SearchFiveCell.h"
#import "CRMSearTwoCell.h"
#import "CRMSearThreeCell.h"

#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"
#import "CRMSearchChooseViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CRMSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SelectDateTimeDelegate>{
    LoginPeopleModel *myModel;
    DateTimeSelectView *_dateTimeSelectView;
    NSUserDefaults *CRMChooseItemsUserDefaults;
}
@property (nonatomic, strong) UIView *bgView;
@property(nonatomic,strong)UITableView * seniorSearchTableView;
@property(nonatomic,strong)UIButton * sureSearchBtn;

@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,strong)NSMutableArray * titleBtn;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic,strong)NSMutableArray * dataArray;
//接口字段

@property (nonatomic) NSString *state;//状态 1待处理，2邀约中，3已到访，5公司放弃，6客户放弃
@property (nonatomic) NSString *name;//姓名
@property (nonatomic) NSString *phone;//电话
@property (nonatomic) NSString *asset_car_date;//汽车购买日期
@property (nonatomic) NSString *idcardNo;//身份证号
@property (nonatomic) NSString *work_name;// 单位名称
@property (nonatomic) NSString *work_type;//单位类型 1行政事业单位、社会团体 2国企 3民营 4外资 5合资 6私营 7个体
@property (nonatomic) NSString *iscpf;//公积金,1有，2无
@property (nonatomic) NSString *isgrbx;//保险：1有，2无
@property (nonatomic) NSString *work_money_type;// 工资发放形式 1银行代发 2现金 3网银
@property (nonatomic) NSString *cpfMoneyMin;//公积金缴纳金额小
@property (nonatomic) NSString *cpfMoneyMax;//公积金缴纳金额大
@property (nonatomic) NSString *issb;//社保,1有，2无
@property (nonatomic) NSString *startTime;//开始时间
@property (nonatomic) NSString *endTime;//结束时间
@property (nonatomic) NSString *asset_house_type;// 房产类型 1揭购 2自建 3全款 4其他
@property (nonatomic) NSString *asset_house_monthMin;//按揭金额 小
@property (nonatomic) NSString *asset_house_monthMax;//按揭金额 大
@property (nonatomic) NSString *asset_car_priceMin;//汽车购买价格小
@property (nonatomic) NSString *asset_car_priceMax;//汽车购买价格大
@property (nonatomic) NSString *asset_car_monthMin;//汽车月供金额小
@property (nonatomic) NSString *asset_car_monthMax;//汽车月供金额大
@end

@implementation CRMSearchViewController
static NSString *startLTime;
static NSString *endRTime;
static NSString *buyCarTime;

static NSInteger temp;

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"data==%@",self.dataArray);
    
    
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    self.navigationItem.title = @"高级查询";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"查询选择"] style:UIBarButtonItemStylePlain target:self action:@selector(SelectSearClick)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.dataDic = [NSMutableDictionary dictionary];
    CRMChooseItemsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr = [CRMChooseItemsUserDefaults objectForKey:@"CRMChooseItems"];
    if (arr.count) {
        [self.dataArray addObjectsFromArray:arr];
    }
    [self loadData];
    [self creatUI];
    // 选择时间界面
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMdd"];
    _dateTimeSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
}
- (void)tapBgView {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}
-(void)loadData{
    
    _titleArray = @[@"姓名",@"手机",@"身份证号码",@"状态",@"单位名称",@"单位性质",@"房产类型",@"公积金",@"社保",@"保险",@"发薪形式",@"购车金额",@"车贷月供",@"购车日期",@"起始时间"];
    
    ButtonsModel * modelBtn1 = [[ButtonsModel alloc]init];
    modelBtn1.name = @"状态";//1待处理，2邀约中，3已到访，5公司放弃，6客户放弃
    modelBtn1.BtnArr = [NSMutableArray arrayWithObjects:@"待处理",@"邀约中",@"已到访",@"办理中",@"公司放弃",@"客户放弃", nil];
    modelBtn1.index = 0;
    
    ButtonsModel * modelBtn2 = [[ButtonsModel alloc]init];
    modelBtn2.name = @"单位性质";
    modelBtn2.BtnArr = [NSMutableArray arrayWithObjects:@"民营",@"私营",@"外资",@"个体",@"国企",@"合资",@"行政事业单位、社会团体", nil];
    modelBtn2.index = 0;
    
    ButtonsModel * modelBtn3 = [[ButtonsModel alloc]init];
    modelBtn3.name = @"房产类型";
    modelBtn3.BtnArr = [NSMutableArray arrayWithObjects:@"揭购房",@"自建房",@"全款房",@"其他", nil];
    modelBtn3.index = 0;
    
    ButtonsModel * modelBtn4 = [[ButtonsModel alloc]init];
    modelBtn4.name = @"公积金";
    modelBtn4.BtnArr = [NSMutableArray arrayWithObjects:@"有",@"无", nil];
    modelBtn4.index = 0;
    
    ButtonsModel * modelBtn5 = [[ButtonsModel alloc]init];
    modelBtn5.name = @"社保";
    modelBtn5.BtnArr = [NSMutableArray arrayWithObjects:@"有",@"无", nil];
    modelBtn5.index = 0;
    
    ButtonsModel * modelBtn6 = [[ButtonsModel alloc]init];
    modelBtn6.name = @"保险";
    modelBtn6.BtnArr = [NSMutableArray arrayWithObjects:@"有",@"无", nil];
    modelBtn6.index = 0;
    
    ButtonsModel * modelBtn7 = [[ButtonsModel alloc]init];
    modelBtn7.name = @"发薪形式";
    modelBtn7.BtnArr = [NSMutableArray arrayWithObjects:@"银行代发",@"现金",@"网银", nil];
    modelBtn7.index = 0;

    
    _titleBtn = [NSMutableArray arrayWithObjects:modelBtn1,modelBtn2,modelBtn3,modelBtn4,modelBtn5,modelBtn6,modelBtn7, nil];
    
}

-(void)creatUI{
    
    _seniorSearchTableView = [[UITableView alloc]init];
    _seniorSearchTableView.delegate = self;
    _seniorSearchTableView.dataSource = self;
   // _seniorSearchTableView.bounces = NO;
    
    _seniorSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_seniorSearchTableView];
    [_seniorSearchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 80, 0));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 60, 0));
        }
    }];
    
    [_seniorSearchTableView registerClass:[CRMSearOneCell class] forCellReuseIdentifier:@"CRMSearOneCellID"];
    [_seniorSearchTableView registerClass:[CRMSearTwoCell class] forCellReuseIdentifier:@"CRMSearTwoCellID"];
    [_seniorSearchTableView registerClass:[CRMSearThreeCell class] forCellReuseIdentifier:@"CRMSearThreeCellID"];
    [_seniorSearchTableView registerClass:[SearchThreeCell class] forCellReuseIdentifier:@"SearchThreeCellID"];
    [_seniorSearchTableView registerNib:[UINib nibWithNibName:@"SearchFiveCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchFiveCellID"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.seniorSearchTableView setTableFooterView:view];
    
    _sureSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40)];
    if (IS_IPHONE_X) {
        _sureSearchBtn.frame = CGRectMake(10, kScreenHeight-70, kScreenWidth-20, 40);
    }
    [_sureSearchBtn setBackgroundColor:TABBAR_BASE_COLOR];
    [_sureSearchBtn setTitle:@"确认查询" forState:UIControlStateNormal];
    [_sureSearchBtn addTarget:self action:@selector(searchCRM) forControlEvents:UIControlEventTouchUpInside];
    [_sureSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureSearchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _sureSearchBtn.layer.cornerRadius = 5.0;
    _sureSearchBtn.layer.masksToBounds = YES;
    [self.view addSubview:_sureSearchBtn];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.titleArray.count+2;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 20);
    headerView.backgroundColor = VIEW_BASE_COLOR;
   
    UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-20, 24)];
    textLabel.backgroundColor = VIEW_BASE_COLOR;
    textLabel.text = @"温馨提示: 点击右上角可选择查询选项";
    textLabel.font = [UIFont systemFontOfSize:11];
    textLabel.textColor = [UIColor grayColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:textLabel];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        if ([self.dataArray containsObject:@(0)]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 1){
        if ([self.dataArray containsObject:@(1)]) {
            return 34;
        }else{
            return 0;
        }

    }else if (indexPath.row == 2){
        if ([self.dataArray containsObject:@(2)]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 3) {
        if ([self.dataArray containsObject:@(3)]) {
            return 75;
        }else{
            return 0;
        }
    }else if (indexPath.row == 4){
        if ([self.dataArray containsObject:@(4)]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 5){
        if ([self.dataArray containsObject:@(5)]) {
            return 75;
        }else{
            return 0;
        }
    }else if (indexPath.row == 6){
        if ([self.dataArray containsObject:@(6)]) {
            return 55;
        }else{
            return 0;
        }
    }else if (indexPath.row == 7){
        if ([self.dataArray containsObject:@(6)] && [self.asset_house_type isEqualToString:@"1"]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 8){
        if ([self.dataArray containsObject:@(7)]) {
            return 40;
        }else{
            return 0;
        }
    }else if (indexPath.row == 9){
        if ([self.dataArray containsObject:@(7)] && [self.iscpf isEqualToString:@"1"]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 10){
        if ([self.dataArray containsObject:@(8)]) {
            return 40;
        }else{
            return 0;
        }
    }else if (indexPath.row == 11){
        if ([self.dataArray containsObject:@(9)]) {
            return 40;
        }else{
            return 0;
        }
    }else if (indexPath.row == 12){
        if ([self.dataArray containsObject:@(10)]) {
            return 40;
        }else{
            return 0;
        }
    }else if (indexPath.row == 13){
        if ([self.dataArray containsObject:@(11)]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 14){
        if ([self.dataArray containsObject:@(12)]) {
            return 34;
        }else{
            return 0;
        }
    }else if (indexPath.row == 15){
        if ([self.dataArray containsObject:@(13)]) {
            return 34;
        }else{
            return 0;
        }
    }else{
        if ([self.dataArray containsObject:@(14)]) {
            return 34;
        }else{
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
  
    if (indexPath.row == 0) {
        if ([self.dataArray containsObject:@(0)]) {
            CRMSearOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearOneCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearOneCellID"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
            cell.rightTF.text = self.name;
            cell.rightTF.delegate = self;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            cell.rightTF.tag = 1;
            return cell;
        }
    }else if (indexPath.row == 1){
        if ([self.dataArray containsObject:@(1)]) {
            
            CRMSearOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearOneCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearOneCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
            
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.rightTF.delegate = self;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            cell.rightTF.text = self.phone;
            cell.rightTF.tag = 11;
            return cell;
        }
    }else if (indexPath.row == 2){
        if ([self.dataArray containsObject:@(2)]) {
            
            CRMSearOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearOneCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearOneCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
            
            
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.rightTF.delegate = self;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            cell.rightTF.tag = 21;
            cell.rightTF.text = self.idcardNo;
            return cell;
        }
    }else if (indexPath.row == 3) {
        if ([self.dataArray containsObject:@(3)]) {
            
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[0];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5);
                //  make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.top.equalTo(cell.mas_top).offset(4);
                make.bottom.equalTo(cell.mas_bottom).offset(-4);
                
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            if ([nodeData.name isEqualToString:@"状态"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+100;
                    if (nodeData.index == btn.tag) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset(21*(i/2)+9);
                        
                        //     make.bottom.equalTo(cell.mas_bottom).offset(-(75-(21*(i/2)+9)-16));
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    }else if (indexPath.row == 4){
        if ([self.dataArray containsObject:@(4)]) {

            
            
            CRMSearOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearOneCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearOneCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
            
            cell.rightTF.delegate = self;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            cell.rightTF.tag = 41;
            cell.rightTF.text = self.work_name;
            return cell;

        }
    }else if (indexPath.row == 5){
        if ([self.dataArray containsObject:@(5)]) {
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[1];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.height.mas_equalTo(20);
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            if ([nodeData.name isEqualToString:@"单位性质"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+200;
                    if (nodeData.index == btn.tag) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%3)+5*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/3)+9);
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    }else if (indexPath.row == 6){
        if ([self.dataArray containsObject:@(6)]) {
            
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[2];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.height.mas_equalTo(20);
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            if ([nodeData.name isEqualToString:@"房产类型"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+300;
                    if (nodeData.index == btn.tag) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((80*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/2)+9);
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    } else if (indexPath.row == 7) {
        if ([self.dataArray containsObject:@(6)] && [self.asset_house_type isEqualToString:@"1"]) {
            CRMSearTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearTwoCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearTwoCellID"];
            }
            cell.leftLabel.text = @"按揭金额";
            cell.midLabel.text = @"元至";
            cell.rightLabel.text = @"元";
            cell.leftTF.delegate = self;
            cell.leftTF.tag = 71;
            cell.leftTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.leftTF.text = self.asset_house_monthMin;
            cell.leftTF.returnKeyType = UIReturnKeyDone;
            
            
            if (self.asset_house_monthMin.length != 0) {
                NSInteger asset_house_monthMin = [self.asset_house_monthMin integerValue];
                NSInteger asset_house_monthMax = [self.asset_house_monthMax integerValue];
                if (asset_house_monthMax < asset_house_monthMin) {
                    self.asset_house_monthMax = [NSString stringWithFormat:@"%ld",asset_house_monthMin+1];
                }
            }
            
            cell.rightTF.delegate = self;
            cell.rightTF.tag = 72;
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.rightTF.text = self.asset_house_monthMax;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            return cell;
        }
    }else if (indexPath.row == 8) {
        if ([self.dataArray containsObject:@(7)]) {
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[3];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.height.mas_equalTo(20);
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            
            if ([nodeData.name isEqualToString:@"公积金"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+400;
                    if (nodeData.index == i+400) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/2)+12);
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    }else if (indexPath.row == 9) {
        if ([self.dataArray containsObject:@(7)]&&[self.iscpf isEqualToString:@"1"]) {
            
            CRMSearTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearTwoCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearTwoCellID"];
            }
            cell.leftLabel.text = @"公积金金额";
            cell.midLabel.text = @"元至";
            cell.rightLabel.text = @"元";
            cell.leftTF.delegate = self;
            cell.leftTF.tag = 91;
            cell.leftTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.leftTF.text = self.cpfMoneyMin;
            cell.leftTF.returnKeyType = UIReturnKeyDone;
            
            
            if (self.cpfMoneyMin.length != 0) {
                NSInteger cpfMoneyMin = [self.cpfMoneyMin integerValue];
                NSInteger cpfMoneyMax = [self.cpfMoneyMax integerValue];
                if (cpfMoneyMax < cpfMoneyMin) {
                    self.cpfMoneyMax = [NSString stringWithFormat:@"%ld",cpfMoneyMin+1];
                }
            }
            
            cell.rightTF.delegate = self;
            cell.rightTF.tag = 92;
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.rightTF.text = self.cpfMoneyMax;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            return cell;
        }
    }else if (indexPath.row == 10){
        if ([self.dataArray containsObject:@(8)]) {
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[4];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.height.mas_equalTo(20);
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            
            if ([nodeData.name isEqualToString:@"社保"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+500;
                    if (nodeData.index == i+500) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/2)+12);
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    }else if (indexPath.row == 11){
        if ([self.dataArray containsObject:@(9)]) {
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[5];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.height.mas_equalTo(20);
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            
            if ([nodeData.name isEqualToString:@"保险"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+600;
                    if (nodeData.index == i+600) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/2)+12);
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    }else if (indexPath.row == 12){
        if ([self.dataArray containsObject:@(10)]) {
            
            SearchThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchThreeCellID"];
            if (cell == nil) {
                cell = [[SearchThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _titleBtn[6];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton * btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:14];
            titleLB.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.mas_equalTo(85);
                make.height.mas_equalTo(20);
            }];
            titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];
            
            if ([nodeData.name isEqualToString:@"发薪形式"]) {
                
                for (int i = 0; i < nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+700;
                    if (nodeData.index == btn.tag) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:13];
                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%3)+12*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/3)+13);
                        
                        make.height.mas_equalTo(16);
                        
                    }];
                }
                
            }
            return cell;
        }
    }else if (indexPath.row == 13){
        if ([self.dataArray containsObject:@(11)]) {
            
            
            CRMSearTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearTwoCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearTwoCellID"];
            }
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row-2]];
            
            cell.midLabel.text = @"万元至";
            cell.rightLabel.text = @"万元";
            cell.leftTF.delegate = self;
            cell.leftTF.tag = 131;
            cell.leftTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.leftTF.text = self.asset_car_priceMin;
            cell.leftTF.returnKeyType = UIReturnKeyDone;
            
            if (self.asset_car_priceMin.length != 0) {
                NSInteger asset_car_priceMin = [self.asset_car_priceMin integerValue];
                NSInteger asset_car_priceMax = [self.asset_car_priceMax integerValue];
                if (asset_car_priceMax < asset_car_priceMin) {
                    self.asset_car_priceMax = [NSString stringWithFormat:@"%ld",asset_car_priceMin+1];
                }
            }
            
            cell.rightTF.delegate = self;
            cell.rightTF.tag = 132;
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.rightTF.text = self.asset_car_priceMax;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            return cell;
        }
    }else if (indexPath.row == 14){
        if ([self.dataArray containsObject:@(12)]) {
            
            CRMSearTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearTwoCellID" forIndexPath:indexPath];
            if (!cell) {
                cell = [[CRMSearTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearTwoCellID"];
            }
            
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row-2]];
            
            cell.midLabel.text = @"元至";
            cell.rightLabel.text = @"元";
            cell.leftTF.delegate = self;
            cell.leftTF.tag = 141;
            cell.leftTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.leftTF.text = self.asset_car_monthMin;
            cell.leftTF.returnKeyType = UIReturnKeyDone;
            
            if (self.asset_car_monthMin.length != 0) {
                NSInteger asset_car_monthMin = [self.asset_car_monthMin integerValue];
                NSInteger asset_car_monthMax = [self.asset_car_monthMax integerValue];
                if (asset_car_monthMax < asset_car_monthMin) {
                    self.asset_car_monthMax = [NSString stringWithFormat:@"%ld",asset_car_monthMin+1];
                }
            }
            
            cell.rightTF.delegate = self;
            cell.rightTF.tag = 142;
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.rightTF.text = self.asset_car_monthMax;
            cell.rightTF.returnKeyType = UIReturnKeyDone;
            return cell;
        }
        
    }else if (indexPath.row == 15){
        if ([self.dataArray containsObject:@(13)]) {
            
            CRMSearThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CRMSearThreeCellID"];
            if (!cell) {
                cell = [[CRMSearThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CRMSearThreeCellID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row-2]];
            
            
            cell.rightBtn.tag = 330;
            [cell.rightBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.rightBtn setTitle:buyCarTime forState:UIControlStateNormal];
            
            return cell;
        }

    }else if (indexPath.row == 16){

        if ([self.dataArray containsObject:@(14)]) {

            SearchFiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFiveCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.searchFiveLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row-2]];
            cell.searchFiveLabel.font = [UIFont systemFontOfSize:14];
            
            [cell.searchFiveLBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.searchFiveLBtn setTitle:startLTime forState:UIControlStateNormal];
            cell.searchFiveLBtn.tag = 310;
            
            [cell.searchFiveRBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.searchFiveRBtn setTitle:endRTime forState:UIControlStateNormal];
            cell.searchFiveRBtn.tag = 320;
            
            return cell;
        }
    }
    return cell;
}

-(void)SelectBtnOnClick:(UIButton *)sender{
    
    if (sender.tag == 100 || sender.tag == 101 ||sender.tag == 102 || sender.tag == 103 || sender.tag == 104 || sender.tag == 105) {
        
        ButtonsModel * model = _titleBtn[0];
        model.index = sender.tag;
        self.state = [NSString stringWithFormat:@"%ld",(model.index%100)+1];
        [_seniorSearchTableView reloadData];
    }else if (sender.tag == 200 || sender.tag == 201 ||sender.tag == 202 || sender.tag == 203 || sender.tag == 204 || sender.tag == 205 || sender.tag == 206 ){
        //1行政事业单位、社会团体 2国企 3民营 4外资 5合资 6私营 7个体
        ButtonsModel * model = _titleBtn[1];
        model.index = sender.tag;
        if (model.index == 200) {
            self.work_type = @"3";
        } else if (model.index == 201) {
            self.work_type = @"6";
        } else if (model.index == 202) {
            self.work_type = @"4";
        } else if (model.index == 203) {
            self.work_type = @"7";
        } else if (model.index == 204) {
            self.work_type = @"2";
        } else if (model.index == 205) {
            self.work_type = @"5";
        } else if (model.index == 206) {
            self.work_type = @"1";
        }
        
        [_seniorSearchTableView reloadData];
    }else if (sender.tag == 300 || sender.tag == 301 ||sender.tag == 302 || sender.tag == 303 ){
        
        ButtonsModel * model = _titleBtn[2];
        
        model.index = sender.tag;
        
        self.asset_house_type = [NSString stringWithFormat:@"%ld",(model.index%300)+1];
        [_seniorSearchTableView reloadData];
    }else if (sender.tag == 400 || sender.tag == 401 ){
        
        ButtonsModel * model = _titleBtn[3];
        model.index = sender.tag;
        self.iscpf = [NSString stringWithFormat:@"%ld",(model.index%400)+1];
        [_seniorSearchTableView reloadData];
    }else if (sender.tag == 500 || sender.tag == 501 ){
        
        ButtonsModel * model = _titleBtn[4];
        model.index = sender.tag;
        self.issb = [NSString stringWithFormat:@"%ld",(model.index%500)+1];
        [_seniorSearchTableView reloadData];
    }else if (sender.tag == 600 || sender.tag == 601){
        
        ButtonsModel * model = _titleBtn[5];
        model.index = sender.tag;
        self.isgrbx = [NSString stringWithFormat:@"%ld",(model.index%600)+1];
        [_seniorSearchTableView reloadData];

    }else if (sender.tag == 700 || sender.tag == 701 || sender.tag == 702){
        
        ButtonsModel * model = _titleBtn[6];
        model.index = sender.tag;
        self.work_money_type = [NSString stringWithFormat:@"%ld",(model.index%700)+1];
        [_seniorSearchTableView reloadData];
    }
    
}

-(void)timeOnClicked:(UIButton *)sender{
    if (sender.tag == 310) {
        temp = 1;
    }else if (sender.tag == 320){
        temp = 2;
    }else if (sender.tag == 330){
        temp = 3;
    }
    
//    FDAlertView *alert = [[FDAlertView alloc] init];
//    
//    RBCustomDatePickerView * contentView=[[RBCustomDatePickerView alloc]init];
//    contentView.delegate=self;
//    contentView.frame = CGRectMake(0, 0, 320, 300);
//    alert.contentView = contentView;
//    [alert show];
    _dateTimeSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = timeViewRect;
    }];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *time = [NSString stringWithFormat:@"%@%@:00",dictDate[@"date"],dictDate[@"time"]];
    NSString * timeString = [time substringToIndex:(time.length-9)];
    if (temp == 1) {
        
        startLTime = timeString;
        
        self.startTime = [NSString stringWithFormat:@"%@ 00:00:00",timeString];
        
        [_seniorSearchTableView reloadData];
        //  self.createTimeMinSearch = startLTime;
    }
    
    if (temp == 2) {
        
        endRTime = timeString;
        self.endTime = [NSString stringWithFormat:@"%@ 23:59:59",timeString];
        [_seniorSearchTableView reloadData];
        // self.createTimeMaxSearch = startRTime;
    }
    
    if (temp == 3) {
        buyCarTime = timeString;
        self.asset_car_date = timeString;
        
        [_seniorSearchTableView reloadData];
    }
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }];
}
- (void)cancelDate {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }];
}

//-(void)getTimeToValue:(NSString *)theTimeStr{
//    
//    NSString * timeString = [theTimeStr substringToIndex:(theTimeStr.length-9)];
//    
//    if (temp == 1) {
//        
//        startLTime = timeString;
//        self.startTime = timeString;
//        [_seniorSearchTableView reloadData];
//      //  self.createTimeMinSearch = startLTime;
//    }
//    
//    if (temp == 2) {
//        
//        endRTime = timeString;
//        self.endTime = timeString;
//        [_seniorSearchTableView reloadData];
//       // self.createTimeMaxSearch = startRTime;
//    }
//    
//}
#pragma mark -- textfield 代理方法
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        self.name = textField.text;
    } else if (textField.tag == 11) {
        self.phone = textField.text;
    } else if (textField.tag == 21) {
        self.idcardNo = textField.text;
    } else if (textField.tag == 41) {
        self.work_name = textField.text;
    } else if (textField.tag == 71) {
        self.asset_house_monthMin = textField.text;
    } else if (textField.tag == 72) {
        self.asset_house_monthMax = textField.text;
        
    } else if (textField.tag == 91) {
        self.cpfMoneyMin = textField.text;
    } else if (textField.tag == 92) {
        self.cpfMoneyMax = textField.text;
        
    } else if (textField.tag == 131) {
        self.asset_car_priceMin = textField.text;
    } else if (textField.tag == 132) {
        self.asset_car_priceMax = textField.text;
    } else if (textField.tag == 141) {
        self.asset_car_monthMin = textField.text;
    } else if (textField.tag == 142) {
        self.asset_car_monthMax = textField.text;
        
    }
    [self.seniorSearchTableView reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 查询crm列表
/*
    private String name;//姓名
	private String phone;//电话
	private String idcardNo;//身份证号
	private String iscpf;//公积金,1有，2无
	private String cpfMoneyMin;//公积金缴纳金额小
	private String cpfMoneyMax;//公积金缴纳金额大
	private String issb;//社保,1有，2无
	private String isgrbx;//保险：1有，2无
	private String asset_house_type;// 房产类型 1揭购 2自建 3全款 4其他
	private String asset_house_monthMin;//按揭区间小
	private String asset_house_monthMax;//按揭区间大
	private String asset_car_priceMin;//汽车购买价格小
	private String asset_car_priceMax;//汽车购买价格大
	private String asset_car_monthMin;//汽车月供金额小
	private String asset_car_monthMax;//汽车月供金额大
	private String asset_car_date;//汽车购买日期
	private String work_name;// 单位名称
	private String work_type;//单位类型 1行政事业单位、社会团体 2国企 3民营 4外资 5合资 6私营 7个体
	private String work_money_type;// 工资发放形式 1银行代发 2现金 3网银
	private String state;//状态 ， 1待处理，2邀约中，3已到访，5公司放弃，6客户放弃
	private String startTime;//开始时间
	private String endTime;//结束时间
 **/

- (void)searchCRM {
    
    if (self.returnNSMutableDictionaryBlock != nil) {
        
        self.dataDic[@"inter"] = @"queryCRM";
        self.dataDic[@"uid"] = [NSString stringWithFormat:@"%ld",myModel.userId];
        if (self.phone.length != 0) {
            self.dataDic[@"phone"] = self.phone;
        }
        if (self.idcardNo.length != 0) {
            self.dataDic[@"idcardNo"] = self.idcardNo;
        }
        if (self.iscpf.length != 0) {
            self.dataDic[@"iscpf"] = self.iscpf;
        }
        if (self.name.length != 0) {
            self.dataDic[@"name"] = self.name;
        }
        if (self.state.length != 0) {
            self.dataDic[@"state"] = self.state;
        }
        if (self.work_name.length != 0) {
            self.dataDic[@"work_name"] = self.work_name;
        }
        if (self.work_type.length != 0) {
            self.dataDic[@"work_type"] = self.work_type;
        }
        //房产类型
        if (self.asset_house_type.length != 0) {
            self.dataDic[@"asset_house_type"] = self.asset_house_type;
        }
        //按揭金额
        if (self.asset_house_monthMin.length != 0) {
            self.dataDic[@"asset_house_monthMin"] = self.asset_house_monthMin;
        }
        if (self.asset_house_monthMax.length != 0) {
            self.dataDic[@"asset_house_monthMax"] = self.asset_house_monthMax;
        }
        //公积金金额
        if (self.cpfMoneyMin.length !=0) {
            self.dataDic[@"cpfMoneyMin"] = self.cpfMoneyMin;
        }
        if (self.cpfMoneyMax.length != 0) {
            self.dataDic[@"cpfMoneyMax"] = self.cpfMoneyMax;
        }
        //汽车购买价格
        if (self.asset_car_priceMin.length !=0) {
            self.dataDic[@"asset_car_priceMin"] = self.asset_car_priceMin;
        }
        if (self.asset_car_priceMax.length != 0) {
            self.dataDic[@"asset_car_priceMax"] = self.asset_car_priceMax;
        }
        //汽车月供
        if (self.asset_car_monthMin.length !=0) {
            self.dataDic[@"asset_car_monthMin"] = self.asset_car_monthMin;
        }
        if (self.asset_car_monthMax.length != 0) {
            self.dataDic[@"asset_car_monthMax"] = self.asset_car_monthMax;
        }
        if (self.asset_car_date.length != 0) {
            self.dataDic[@"asset_car_date"] = self.asset_car_date;
        }
        
        if (self.isgrbx.length != 0) {
            self.dataDic[@"isgrbx"] = self.isgrbx;
        }
        if (self.issb.length != 0) {
            self.dataDic[@"issb"] = self.issb;
        }
        if (self.startTime.length != 0) {
            self.dataDic[@"startTime"] = self.startTime;
        }
        if (self.endTime.length != 0) {
            self.dataDic[@"endTime"] = self.endTime;
        }
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *dt1 = [[NSDate alloc] init];
        NSDate *dt2 = [[NSDate alloc] init];
        dt1 = [df dateFromString:self.startTime];
        dt2 = [df dateFromString:self.endTime];
        NSComparisonResult result1 = [dt1 compare:dt2];
        int cpfMoney = [self.cpfMoneyMax intValue] - [self.cpfMoneyMin intValue];
        if (self.startTime.length != 0 || self.endTime.length != 0 ) {
            if (result1 == NSOrderedDescending ) {
                [MBProgressHUD showError:@"时间区间有误"];
            }else {
                if (self.cpfMoneyMax.length != 0 || self.cpfMoneyMin.length != 0) {
                    if (cpfMoney <= 0) {
                        [MBProgressHUD showError:@"公积金区间有误"];
                    }else {
                        self.returnNSMutableDictionaryBlock(self.dataDic);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    self.returnNSMutableDictionaryBlock(self.dataDic);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            
        }else if (self.cpfMoneyMax.length != 0 || self.cpfMoneyMin.length != 0) {
            if (cpfMoney <= 0) {
                [MBProgressHUD showError:@"公积金区间有误"];
            }else {
                self.returnNSMutableDictionaryBlock(self.dataDic);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            self.returnNSMutableDictionaryBlock(self.dataDic);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
}

-(void)SelectSearClick{
    
    CRMSearchChooseViewController * searchChooseVC = [[CRMSearchChooseViewController alloc]init];
    if (self.dataArray.count != 0) {
        searchChooseVC.alreadyChooseItems = self.dataArray;
    }
    [searchChooseVC returnMutableArray:^(NSMutableArray *returnMutableArray) {
        self.dataArray = returnMutableArray;
        
        if (self.dataArray.count != 0) {
            [CRMChooseItemsUserDefaults removeObjectForKey:@"CRMChooseItems"];
            [CRMChooseItemsUserDefaults setObject:self.dataArray forKey:@"CRMChooseItems"];
            [self.seniorSearchTableView reloadData];
        } else {
            [self.dataArray removeAllObjects];
            [CRMChooseItemsUserDefaults removeObjectForKey:@"CRMChooseItems"];
            [self.seniorSearchTableView reloadData];
        }
    }];
    
    [self.navigationController pushViewController:searchChooseVC animated:YES];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    startLTime = @"";
    endRTime = @"";
    buyCarTime = @"";
    temp = 0;
}
- (void)returnMutableDictionary:(ReturnNSMutableDictionaryBlock)block {
    self.returnNSMutableDictionaryBlock = block;
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
