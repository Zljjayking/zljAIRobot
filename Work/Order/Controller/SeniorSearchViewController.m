//
//  SeniorSearchViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SeniorSearchViewController.h"
#import "SearchOneCell.h"
#import "SearchTwoCell.h"
#import "SearchThreeCell.h"
#import "SearchFourCell.h"
#import "SearchFiveCell.h"
#import "ButtonsModel.h"

#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"
#import "MyOrderModel.h"
#import "LoginPeopleModel.h"
@interface SeniorSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SelectDateTimeDelegate>{
    LoginPeopleModel *loginModel;
    DateTimeSelectView *_dateTimeSelectView;
}
@property (nonatomic, strong) UIView *bgView;

@property(nonatomic,strong)UITableView * seniorSearchTableView;

@property(nonatomic,strong)UIButton * sureSearchBtn;


@property(nonatomic,strong) NSString* orderNoSearch;	//订单标号
@property(nonatomic,strong) NSString* mechNameSearch;	//产品名称
@property(nonatomic,strong) NSString* applynameSearch;	//申请人名称
@property(nonatomic,strong) NSString* applyNoSearch;		//申请人证件号
@property(nonatomic,strong) NSString* agentApplySearch;	//代理申请人名称
@property(nonatomic,strong) NSString* examineuserNameSearch;	//审核人名称
@property(nonatomic,strong) NSString* quotaMinSearch;		//最大申请额度
@property(nonatomic,strong) NSString* quotaMaxSearch;		//最小申请额度
@property(nonatomic,strong) NSString* speedSearch;		//申请进度
@property(nonatomic,strong) NSString* serviceMoneyMinSearch;	//最小总服务费
@property(nonatomic,strong) NSString* serviceMoneyMaxSearch;	//最大总服务费
@property(nonatomic,strong) NSString* serviceMoneyMechanismMinSearch;	//最小机构服务费
@property(nonatomic,strong) NSString* serviceMoneyMechanismMaxSearch;	//最大机构服务费
@property(nonatomic,strong) NSString* createTimeMinSearch;	//最小订单开始时间
@property(nonatomic,strong) NSString* createTimeMaxSearch;	//最大订单开始时间
@property(nonatomic,strong) NSString* finish_timeMinSearch;	//最小订单放款时间
@property(nonatomic,strong) NSString* finish_timeMaxSearch;	//最大订单放款时间


@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,strong)NSMutableArray * titleBtn;
@property (nonatomic, strong) NSMutableArray *searchListArr;

@property(nonatomic,strong)UIView * vv;


@end

@implementation SeniorSearchViewController
static NSString *startLTime;
static NSString *startRTime;
static NSString *endLTime;
static NSString *endRTime;

static NSInteger temp;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vv = [[UIView alloc]initWithFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
    self.searchListArr = [NSMutableArray array];
    self.navigationItem.title = @"高级搜索";
    self.view.backgroundColor = VIEW_BASE_COLOR;
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
//    self.navigationItem.leftBarButtonItem = left;
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(EmptyOnClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    [self loadData];
    [self creatUI];
    
    // 选择时间界面
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect];
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
    
//    _titleArray = @[@"订单编号",@"产品名称",@"申请人",@"申请人证件号",@"代理申请人",@"审核人",@"申请额度",@"申请进度",@"总服务费",@"机构服务费",@"订单开始时间",@"订单结束时间"];
    _titleArray = @[@"订单编号",@"产品名称",@"申请人",@"申请人证件号",@"代理申请人",@"审核人",@"申请额度",@"申请进度",@"订单开始时间",@"订单结束时间"];
    ButtonsModel * modelBtn = [[ButtonsModel alloc]init];
    modelBtn.name = @"申请进度";//1申请中2审批中3审批成功4已签约5已放款6已完成7审核未通过
    modelBtn.BtnArr = [NSMutableArray arrayWithObjects:@"申请中",@"审批中",@"审批成功",@"已签约",@"已放款",@"已完成",@"审批失败", nil];
    modelBtn.index = 0;
    
    _titleBtn = [NSMutableArray arrayWithObjects:modelBtn, nil];
    
}

-(void)creatUI{
    
    _seniorSearchTableView = [[UITableView alloc]init];
    _seniorSearchTableView.delegate = self;
    _seniorSearchTableView.dataSource = self;
//    _seniorSearchTableView.bounces = NO;
    
    _seniorSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_seniorSearchTableView];
    [_seniorSearchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 84, 0));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 60, 0));
        }
        
    }];
    
    [_seniorSearchTableView registerNib:[UINib nibWithNibName:@"SearchOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchOneCellID"];
    [_seniorSearchTableView registerNib:[UINib nibWithNibName:@"SearchTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchTwoCellID"];
    [_seniorSearchTableView registerClass:[SearchThreeCell class] forCellReuseIdentifier:@"SearchThreeCellID"];
    [_seniorSearchTableView registerNib:[UINib nibWithNibName:@"SearchFourCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchFourCellID"];
    [_seniorSearchTableView registerNib:[UINib nibWithNibName:@"SearchFiveCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SearchFiveCellID"];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.seniorSearchTableView setTableFooterView:view];
    
    _sureSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40)];
    if (IS_IPHONE_X) {
        _sureSearchBtn.frame = CGRectMake(10, kScreenHeight-74, kScreenWidth-20, 40);
    }
    [_sureSearchBtn setBackgroundColor:TABBAR_BASE_COLOR];
    [_sureSearchBtn setTitle:@"确认查询" forState:UIControlStateNormal];
    [_sureSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sureSearchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _sureSearchBtn.layer.cornerRadius = 5.0;
    _sureSearchBtn.layer.masksToBounds = YES;
    [self.view addSubview:_sureSearchBtn];
    [_sureSearchBtn addTarget:self action:@selector(sureSearchOnClick) forControlEvents:UIControlEventTouchUpInside];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 7) {
        return 95;
    }else{
        return 35;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.row == 0) {
        
        SearchOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.SearchOneLavel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
    
        cell.searchOneTextField.tintColor = TABBAR_BASE_COLOR;
        cell.searchOneTextField.tag = 90;
        cell.searchOneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.searchOneTextField.delegate = self;
        cell.searchOneTextField.returnKeyType = UIReturnKeyDone;
        return cell;
        
    }else if (indexPath.row == 1){
        SearchOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.SearchOneLavel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        cell.searchOneTextField.tintColor = TABBAR_BASE_COLOR;
        cell.searchOneTextField.tag = 91;
        cell.searchOneTextField.delegate = self;
        cell.searchOneTextField.returnKeyType = UIReturnKeyDone;
        return cell;

    }else if (indexPath.row == 2){
        SearchOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.SearchOneLavel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        cell.searchOneTextField.tintColor = TABBAR_BASE_COLOR;
        cell.searchOneTextField.tag = 92;
        cell.searchOneTextField.delegate = self;
        cell.searchOneTextField.returnKeyType = UIReturnKeyDone;
        return cell;
        
    }else if (indexPath.row == 3){
        
        SearchOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.SearchOneLavel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        cell.searchOneTextField.tintColor = TABBAR_BASE_COLOR;
        cell.searchOneTextField.tag = 93;
        cell.searchOneTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.searchOneTextField.delegate = self;
        cell.searchOneTextField.returnKeyType = UIReturnKeyDone;
        return cell;
        
    }else if (indexPath.row == 4){
        SearchOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.SearchOneLavel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        cell.searchOneTextField.tintColor = TABBAR_BASE_COLOR;
        cell.searchOneTextField.tag = 94;
        cell.searchOneTextField.delegate = self;
        cell.searchOneTextField.returnKeyType = UIReturnKeyDone;
        return cell;
        
    }else if (indexPath.row == 5){
        SearchOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.SearchOneLavel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        cell.searchOneTextField.tintColor = TABBAR_BASE_COLOR;
        cell.searchOneTextField.tag = 95;
        cell.searchOneTextField.delegate = self;
        cell.searchOneTextField.returnKeyType = UIReturnKeyDone;
        return cell;
        
    }else if (indexPath.row == 6){
        
        SearchTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTwoCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.searchSecondLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        cell.searchSecondLTF.tintColor = TABBAR_BASE_COLOR;
        cell.searchSecondRTF.tintColor = TABBAR_BASE_COLOR;
        cell.searchSecondLTF.tag = 96;
        cell.searchSecondRTF.tag = 97;
        cell.searchSecondLTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.searchSecondRTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.searchSecondLTF.delegate = self;
        cell.searchSecondLTF.returnKeyType = UIReturnKeyDone;
        cell.searchSecondRTF.delegate = self;
        cell.searchSecondRTF.returnKeyType = UIReturnKeyDone;
        return cell;

    }else if (indexPath.row == 7){
        
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
        titleLB.font = [UIFont systemFontOfSize:12];
        titleLB.textAlignment = NSTextAlignmentRight;
        [cell addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(14*KAdaptiveRateWidth);
            make.top.equalTo(cell.mas_top).offset(6);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(20);
        }];
        titleLB.text = [NSString stringWithFormat:@"%@:",nodeData.name];

        if ([nodeData.name isEqualToString:@"申请进度"]) {
            
            for (int i = 0; i < nodeData.BtnArr.count; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = i+1+100;
                if (nodeData.index == i+1+100) {
                    btn.selected = YES;
                }
                [btn setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
                [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+3*KAdaptiveRateWidth);
                    make.top.equalTo(cell.mas_top).offset((21)*(i/2)+9);
                
                    make.height.mas_equalTo(16);
                    
                }];
        }

        }
        return cell;
    }
//    else if (indexPath.row == 8){
//        
//        SearchFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFourCellID"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        cell.searchFourLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
//        cell.searchFourLTF.tintColor = TABBAR_BASE_COLOR;
//        cell.searchFourRTF.tintColor = TABBAR_BASE_COLOR;
//        cell.searchFourLTF.tag = 110;
//        cell.searchFourRTF.tag = 111;
//        cell.searchFourLTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        cell.searchFourRTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        cell.searchFourLTF.delegate = self;
//        cell.searchFourLTF.returnKeyType = UIReturnKeyDone;
//        cell.searchFourRTF.delegate = self;
//        cell.searchFourRTF.returnKeyType = UIReturnKeyDone;
//        return cell;
//    }else if (indexPath.row == 9){
//        
//        SearchFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFourCellID"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        cell.searchFourLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
//        
//        cell.searchFourLTF.tintColor = TABBAR_BASE_COLOR;
//        cell.searchFourRTF.tintColor = TABBAR_BASE_COLOR;
//        cell.searchFourLTF.tag = 112;
//        cell.searchFourRTF.tag = 113;
//        cell.searchFourLTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        cell.searchFourRTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//        cell.searchFourLTF.delegate = self;
//        cell.searchFourLTF.returnKeyType = UIReturnKeyDone;
//        cell.searchFourRTF.delegate = self;
//        cell.searchFourRTF.returnKeyType = UIReturnKeyDone;
//        return cell;
//    }
    else if (indexPath.row == 8){
        
        SearchFiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFiveCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.searchFiveLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        [cell.searchFiveLBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.searchFiveLBtn setTitle:startLTime forState:UIControlStateNormal];
        cell.searchFiveLBtn.tag = 300;
        
        [cell.searchFiveRBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.searchFiveRBtn setTitle:startRTime forState:UIControlStateNormal];
        cell.searchFiveRBtn.tag = 310;
        
        return cell;
        
    }else if (indexPath.row == 9){
        SearchFiveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchFiveCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.searchFiveLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[indexPath.row]];
        
        [cell.searchFiveLBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.searchFiveLBtn setTitle:endLTime forState:UIControlStateNormal];
        cell.searchFiveLBtn.tag = 320;
        
        [cell.searchFiveRBtn addTarget:self action:@selector(timeOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.searchFiveRBtn setTitle:endRTime forState:UIControlStateNormal];
        cell.searchFiveRBtn.tag = 330;
        
        return cell;
    }

    return cell;
}


-(void)SelectBtnOnClick:(UIButton *)sender{
    //private String speedSearch;		//申请进度
    ButtonsModel * model = _titleBtn[0];
    model.index = sender.tag;
    [_seniorSearchTableView reloadData];
//    if (model.index %100 == 1 || model.index %100 == 2) {
//        self.speedSearch = [NSString stringWithFormat:@"%ld",model.index%100];
//    }
    self.speedSearch = [NSString stringWithFormat:@"%ld",model.index%100];

}

-(void)timeOnClicked:(UIButton *)sender{
    
    if (sender.tag == 300) {
        temp = 1;
    }else if (sender.tag == 310){
        temp = 2;
    }else if (sender.tag == 320){
        temp = 3;
    }else if (sender.tag == 330){
        temp = 4;
    }
    
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
        [_seniorSearchTableView reloadData];
        self.createTimeMinSearch = startLTime;
    }
    
    if (temp == 2) {
        
        startRTime = timeString;
        [_seniorSearchTableView reloadData];
        self.createTimeMaxSearch = startRTime;
    }
    
    if (temp == 3) {
        
        endLTime = timeString;
        [_seniorSearchTableView reloadData];
        self.finish_timeMinSearch = endLTime;
    }
    
    if (temp == 4) {
        
        endRTime = timeString;
        [_seniorSearchTableView reloadData];
        self.finish_timeMaxSearch = endRTime;
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
-(void)getTimeToValue:(NSString *)theTimeStr{
    
    NSString * timeString = [theTimeStr substringToIndex:(theTimeStr.length-9)];
    /*
     private String createTimeMinSearch;	//最小订单开始时间
     private String createTimeMaxSearch;	//最大订单开始时间
     private String finish_timeMinSearch;	//最小订单放款时间
     private String finish_timeMaxSearch;	//最大订单放款时间
     */
    if (temp == 1) {
        
        startLTime = timeString;
        [_seniorSearchTableView reloadData];
        self.createTimeMinSearch = startLTime;
    }

    if (temp == 2) {
        
        startRTime = timeString;
        [_seniorSearchTableView reloadData];
        self.createTimeMaxSearch = startRTime;
    }
    
    if (temp == 3) {
        
        endLTime = timeString;
        [_seniorSearchTableView reloadData];
        self.finish_timeMinSearch = endLTime;
    }
    
    if (temp == 4) {
        
        endRTime = timeString;
        [_seniorSearchTableView reloadData];
        self.finish_timeMaxSearch = endRTime;
    }
}

//清空
-(void)EmptyOnClick{
    
    UITextField * orderNoSearch = [self.seniorSearchTableView viewWithTag:90];
    UITextField * mechNameSearch = [self.seniorSearchTableView viewWithTag:91];
    UITextField * applynameSearch = [self.seniorSearchTableView viewWithTag:92];
    UITextField * applyNoSearch = [self.seniorSearchTableView viewWithTag:93];
    UITextField * agentApplySearch = [self.seniorSearchTableView viewWithTag:94];
    UITextField * examineuserNameSearch = [self.seniorSearchTableView viewWithTag:95];
    UITextField * quotaMinSearch = [self.seniorSearchTableView viewWithTag:96];
    UITextField * quotaMaxSearch = [self.seniorSearchTableView viewWithTag:97];
    
    UITextField * serviceMoneyMinSearch = [self.seniorSearchTableView viewWithTag:110];
    UITextField * serviceMoneyMaxSearch = [self.seniorSearchTableView viewWithTag:111];
    UITextField * serviceMoneyMechanismMinSearch = [self.seniorSearchTableView viewWithTag:112];
    UITextField * serviceMoneyMechanismMaxSearch = [self.seniorSearchTableView viewWithTag:113];
    
    UIButton * oneButton = [self.seniorSearchTableView viewWithTag:100];
    oneButton.selected = NO;
    UIButton * twoButton = [self.seniorSearchTableView viewWithTag:101];
    twoButton.selected = NO;
    UIButton * threeButton = [self.seniorSearchTableView viewWithTag:102];
    threeButton.selected = NO;
    UIButton * fourButton = [self.seniorSearchTableView viewWithTag:103];
    fourButton.selected = NO;
    UIButton * fiveButton = [self.seniorSearchTableView viewWithTag:104];
    fiveButton.selected = NO;
    UIButton * sixButton = [self.seniorSearchTableView viewWithTag:105];
    sixButton.selected = NO;
    UIButton * sevenButton = [self.seniorSearchTableView viewWithTag:106];
    sevenButton.selected = NO;
    
    UIButton * createTimeMinSearch = [self.seniorSearchTableView viewWithTag:300];
    UIButton * createTimeMaxSearch = [self.seniorSearchTableView viewWithTag:310];
    UIButton * finish_timeMinSearch = [self.seniorSearchTableView viewWithTag:320];
    UIButton * finish_timeMaxSearch = [self.seniorSearchTableView viewWithTag:330];
    
    
    [orderNoSearch setText:@" "];
    [mechNameSearch setText:@" "];
    [applynameSearch setText:@" "];
    [applyNoSearch setText:@" "];
    [agentApplySearch setText:@" "];
    [examineuserNameSearch setText:@" "];
    [quotaMinSearch setText:@" "];
    [quotaMaxSearch setText:@" "];
    [serviceMoneyMinSearch setText:@" "];
    [serviceMoneyMaxSearch setText:@" "];
    [serviceMoneyMechanismMinSearch setText:@" "];
    [serviceMoneyMechanismMaxSearch setText:@" "];
    
    [createTimeMinSearch setTitle:@" " forState:UIControlStateNormal];
    [createTimeMaxSearch setTitle:@" " forState:UIControlStateNormal];
    [finish_timeMinSearch setTitle:@" " forState:UIControlStateNormal];
    [finish_timeMaxSearch setTitle:@" " forState:UIControlStateNormal];
    startLTime = @" ";
    startRTime = @" ";
    endLTime = @" ";
    endRTime = @" ";
    
}

-(void)sureSearchOnClick{
    
//    UITextField * mechNameSearch = [self.seniorSearchTableView viewWithTag:91];
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)] ) {
//        [_delegate searchBarSearchButtonClicked:[NSString stringWithFormat:@"%@",mechNameSearch.text]];
//    }else{
//        NSLog(@"没有设置代理或者没有代理没有实现协议方法");
//    }
    /*
     self.orderNoSearch;	//订单标号
     self.mechNameSearch;	//产品名称
     self.applynameSearch;	//申请人名称
     self.applyNoSearch;		//申请人证件号
     self.agentApplySearch;	//代理申请人名称
     self.examineuserNameSearch;	//审核人名称
     self.quotaMinSearch;		//最大申请额度
     self.quotaMaxSearch;		//最小申请额度
     self.speedSearch;		//申请进度
     self.serviceMoneyMinSearch;	//最小总服务费
     self.serviceMoneyMaxSearch;	//最大总服务费
     self.serviceMoneyMechanismMinSearch;	//最小机构服务费
     self.serviceMoneyMechanismMaxSearch;	//最大机构服务费
     self.createTimeMinSearch;	//最小订单开始时间
     self.createTimeMaxSearch;	//最大订单开始时间
     self.finish_timeMinSearch;	//最小订单放款时间
     self.finish_timeMaxSearch;	//最大订单放款时间
     */
    [self.searchListArr removeAllObjects];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.seType == 0) {
        dic[@"inter"] = @"queryOrder2";
    }else {
        dic[@"inter"] = @"querySPOrder2";
    }
    dic[@"uid"] = [NSString stringWithFormat:@"%ld",loginModel.userId];
    if (self.orderNoSearch.length != 0) {
        dic[@"orderNoSearch"] = self.orderNoSearch;
    }
    if (self.mechNameSearch.length != 0) {
        dic[@"mechNameSearch"] = self.mechNameSearch;
    }
    if (self.applynameSearch.length != 0) {
        dic[@"applynameSearch"] = self.applynameSearch;
    }
    if (self.applyNoSearch.length != 0) {
        dic[@"applyNoSearch"] = self.applyNoSearch;
    }
    if (self.agentApplySearch.length != 0) {
        dic[@"agentApplySearch"] = self.agentApplySearch;
    }
    if (self.examineuserNameSearch.length != 0) {
        dic[@"examineuserNameSearch"] = self.examineuserNameSearch;
    }
    if (self.quotaMinSearch.length != 0) {
        dic[@"quotaMinSearch"] = self.quotaMinSearch;
    }
    if (self.quotaMaxSearch.length != 0) {
        dic[@"quotaMaxSearch"] = self.quotaMaxSearch;
    }
    if (self.speedSearch.length != 0) {
        dic[@"speedSearch"] = self.speedSearch;
    }
    if (self.serviceMoneyMinSearch.length != 0) {
        dic[@"serviceMoneyMinSearch"] = self.serviceMoneyMinSearch;
    }
    if (self.serviceMoneyMaxSearch.length != 0) {
        dic[@"serviceMoneyMaxSearch"] = self.serviceMoneyMaxSearch;
    }
    if (self.serviceMoneyMechanismMinSearch.length != 0) {
        dic[@"serviceMoneyMechanismMinSearch"] = self.serviceMoneyMechanismMinSearch;
    }
    if (self.serviceMoneyMechanismMaxSearch.length != 0) {
        dic[@"serviceMoneyMechanismMaxSearch"] = self.serviceMoneyMechanismMaxSearch;
    }
    if (self.createTimeMinSearch.length != 0) {
        dic[@"createTimeMinSearch"] = self.createTimeMinSearch;
    }
    if (self.createTimeMaxSearch.length != 0) {
        dic[@"createTimeMaxSearch"] = self.createTimeMaxSearch;
    }
    if (self.finish_timeMinSearch.length != 0) {
        dic[@"finish_timeMinSearch"] = self.finish_timeMinSearch;
    }
    if (self.finish_timeMaxSearch.length != 0) {
        dic[@"finish_timeMaxSearch"] = self.finish_timeMaxSearch;
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    NSDate *dt3 = [[NSDate alloc] init];
    NSDate *dt4 = [[NSDate alloc] init];
    dt1 = [df dateFromString:self.createTimeMinSearch];
    dt2 = [df dateFromString:self.createTimeMaxSearch];
    dt3 = [df dateFromString:self.finish_timeMinSearch];
    dt4 = [df dateFromString:self.finish_timeMaxSearch];
    NSComparisonResult result1 = [dt1 compare:dt2];
    NSComparisonResult result2 = [dt3 compare:dt4];
    int quota = [self.quotaMaxSearch intValue] - [self.quotaMinSearch intValue];
    int serviceMoney =[self.serviceMoneyMaxSearch intValue] - [self.serviceMoneyMinSearch intValue];
    int serviceMoneyMechanism = [self.serviceMoneyMechanismMaxSearch intValue] - [self.serviceMoneyMechanismMinSearch intValue];
    
//    if (self.createTimeMinSearch.length != 0 || self.createTimeMaxSearch.length != 0 ) {
//        if (result1 == NSOrderedDescending ) {
//            [MBProgressHUD showError:@"订单开始时间区间有误"];
//        }else {
//            [self SearchOrderWithDic:dic];
//        }
//    }else if (self.finish_timeMinSearch.length != 0 || self.finish_timeMaxSearch.length != 0) {
//        if (result2 == NSOrderedDescending) {
//            [MBProgressHUD showError:@"订单结束时间区间有误"];
//        }else {
//            [self SearchOrderWithDic:dic];
//        }
//    }else if (self.quotaMaxSearch.length != 0 || self.quotaMinSearch.length != 0) {
//        if (quota < 0) {
//            [MBProgressHUD showError:@"额度区间有误"];
//        }else {
//            [self SearchOrderWithDic:dic];
//        }
//    }else if (self.serviceMoneyMaxSearch.length != 0 || self.serviceMoneyMinSearch.length != 0) {
//        if (serviceMoney < 0) {
//            [MBProgressHUD showError:@"总服务费区间有误"];
//        }else {
//            [self SearchOrderWithDic:dic];
//        }
//    }else if (self.serviceMoneyMechanismMaxSearch.length != 0 || self.serviceMoneyMechanismMinSearch.length != 0) {
//        if (serviceMoneyMechanism < 0) {
//            [MBProgressHUD showError:@"机构服务费区间有误"];
//        }else {
//            [self SearchOrderWithDic:dic];
//        }
//    } else {
//        [self SearchOrderWithDic:dic];
//    }
    
    if (result1 == NSOrderedDescending || result2 == NSOrderedDescending) {
        [MBProgressHUD showError:@"时间区间有误"];
        
    } else if ( quota < 0 || serviceMoney < 0 || serviceMoneyMechanism < 0) {
        [MBProgressHUD showError:@"额度或费用区间有误"];
    }else {
        NSLog(@"dic == %@",dic);
        [self SearchOrderWithDic:dic];
    }
    
}
- (void)SearchOrderWithDic:(NSDictionary *)dic {
//    [HttpRequestEngine searchOrderWithDic:dic completion:^(id obj, NSString *errorStr) {
//        self.searchListArr = [[NSMutableArray alloc]init];
//        if (errorStr == nil) {
//            NSArray *listArray = obj;
//            NSLog(@"obj == %@",obj);
//            for (NSDictionary* subDic in listArray) {
//                NSDictionary *hehe = [NSDictionary changeType:subDic];
//                MyOrderModel * model = [[MyOrderModel alloc]initWithDictionary:hehe error:nil];
//                
//                [self.searchListArr addObject:model];
//            }
//            if (self.returnSearchListBlock != nil) {
//                self.returnSearchListBlock(dic);
//            }
//        } else {
//            
//        }
//        
//    }];
    
    if (self.returnSearchListBlock != nil) {
        self.returnSearchListBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnSearchList:(ReturnSearchListBlock)block {
    self.returnSearchListBlock = block;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    /*
     private String orderNoSearch;	//订单标号
     private String mechNameSearch;	//产品名称
     private String applynameSearch;	//申请人名称
     private String applyNoSearch;		//申请人证件号
     private String agentApplySearch;	//代理申请人名称
     private String examineuserNameSearch;	//审核人名称
     private String quotaMinSearch;		//最大申请额度
     private String quotaMaxSearch;		//最小申请额度
     private String serviceMoneyMinSearch;	//最小总服务费
     private String serviceMoneyMaxSearch;	//最大总服务费
     private String serviceMoneyMechanismMinSearch;	//最小机构服务费
     private String serviceMoneyMechanismMaxSearch;	//最大机构服务费
     */
    switch (textField.tag) {
        case 90:
        {
            self.orderNoSearch = textField.text;
        }
            break;
        case 91:
        {
            self.mechNameSearch = textField.text;
        }
            break;
        case 92:
        {
            self.applynameSearch = textField.text;
        }
            break;
        case 93:
        {
            self.applyNoSearch = textField.text;
        }
            break;
        case 94:
        {
            self.agentApplySearch = textField.text;
        }
            break;
        case 95:
        {
            self.examineuserNameSearch = textField.text;
        }
            break;
        case 96:
        {
            self.quotaMinSearch = textField.text;
        }
            break;
        case 97:
        {
            self.quotaMaxSearch = textField.text;
        }
            break;
        case 110:
        {
            self.serviceMoneyMinSearch = textField.text;
        }
            break;
        case 111:
        {
            self.serviceMoneyMaxSearch = textField.text;
        }
            break;
        case 112:
        {
            self.serviceMoneyMechanismMinSearch = textField.text;
        }
            break;
        case 113:
        {
            self.serviceMoneyMechanismMaxSearch = textField.text;
        }
            break;
        default:
            break;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//-(void)GoBack{
//    
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    startLTime = @"";
//    startRTime = @"";
//    endLTime = @"";
//    endRTime = @"";
//}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    startLTime = @"";
    startRTime = @"";
    endLTime = @"";
    endRTime = @"";
}
#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    [self.seniorSearchTableView endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
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
