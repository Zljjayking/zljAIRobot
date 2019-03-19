//
//  MyOrderViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"

#import "MyOrderModel.h"

#import "LookOrderInfoViewController.h"
#import "OnApplyOrderViewController.h"

#import "SeniorSearchViewController.h"


@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SeniorSearchViewControllerDelegate>{
    LoginPeopleModel *loginModel;
}
@property (nonatomic,copy) NSString * isRefreshMyOrder;
@property (nonatomic, assign) NSInteger page;
@end

@implementation MyOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.isRefreshMyOrder isEqualToString:@"111"]) {
        [self.myOrderTableView.header beginRefreshing];
        
        [self loadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchMine:) name:@"searchMine" object:nil];
    self.page = 0;
    
    [self creatUI];
    
    [self loadData];
    
    
    
}
- (void)searchMine:(NSNotification *)noti {
    NSLog(@"监听到高级搜索我的订单的通知");
    NSDictionary *dic = noti.userInfo;
    
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"searchMine"]];
    self.myOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self loadDataWithSeachDic:searchDic];
        [self.myOrderTableView.footer resetNoMoreData];
    }];
    self.myOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self loadDataWithSeachDic:searchDic];
        
    }];
    [self.myOrderTableView.header beginRefreshing];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.isRefreshMyOrder = @"000";
}

-(void)loadData{
   //  [MBProgressHUD showMessage:@"正在加载.."];
    
    LoginPeopleModel *myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    NSString* userID = [NSString stringWithFormat:@"%ld",(long)myModel.userId];
    NSLog(@"==%@",userID);
    NSString *page = [NSString stringWithFormat:@"%ld",(long)self.page];

    [HttpRequestEngine getMyOrderListWithUid:userID page:page completion:^(id obj, NSString *errorStr) {
        [self.myOrderTableView.header endRefreshing];
        [MBProgressHUD hideHUD];
        if (errorStr == nil) {
            if (self.page == 0) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArr = (NSArray *)obj;
            NSLog(@"array==%ld",(unsigned long)dataArr.count);
            [self.dataArray addObjectsFromArray:dataArr];
            
            [self.myOrderTableView reloadData];
            
            [self.myOrderTableView.footer endRefreshing];
            
            if (dataArr.count < 10) {
                [self.myOrderTableView.footer noticeNoMoreData];
            }
            if (self.dataArray.count == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
        }else{
            self.blankV.hidden = NO;
            [self.dataArray removeAllObjects];
            [self.myOrderTableView reloadData];
            [MBProgressHUD showError:errorStr];
        }
        
    }];
    
    
}

- (void)loadDataWithSeachDic:(NSMutableDictionary *)dic  {
    //    LoginPeopleModel *myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    //    NSString* userID = [NSString stringWithFormat:@"%ld",myModel.userId];
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    [HttpRequestEngine searchOrderWithDic:dic page:page completion:^(id obj, NSString *errorStr) {
        
        [self.myOrderTableView.header endRefreshing];
        [MBProgressHUD hideHUD];
        if (errorStr == nil) {
            if (self.page == 0) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArr = (NSArray *)obj;
            NSLog(@"array==%ld",dataArr.count);
            [self.dataArray addObjectsFromArray:dataArr];
            
            
            
            [self.myOrderTableView.footer endRefreshing];
            
            if (dataArr.count < 10) {
                [self.myOrderTableView.footer noticeNoMoreData];
            }
            [self.myOrderTableView reloadData];
            if (self.dataArray.count == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
        }else{
            self.blankV.hidden = NO;
            [self.dataArray removeAllObjects];
            [self.myOrderTableView reloadData];
            [MBProgressHUD showError:errorStr];
        }
        
        
        
    }];
    
}

-(void)creatUI{
    SeniorSearchViewController * seniorSearchVC = [[SeniorSearchViewController alloc]init];
    seniorSearchVC.delegate = self;
    
        
    _myOrderTableView = [[UITableView alloc]init];
    _myOrderTableView.delegate = self;
    _myOrderTableView.dataSource = self;
    _myOrderTableView.tableFooterView = [UIView new];
    [self.view addSubview:_myOrderTableView];
    _myOrderTableView.rowHeight = 80.f;
    
    [_myOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.myOrderTableView setTableFooterView:view];
    
    [_myOrderTableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyOrderCellID"];
    
    _myOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        
        DLog(@"self.dataArray.count == %ld",self.dataArray.count);
        [self.myOrderTableView.footer resetNoMoreData];
        [self loadData];
    }];
    _myOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self loadData];
    }];
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无订单信息!"];
    [self.myOrderTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCellID"];
    
    MyOrderModel * model = self.dataArray[indexPath.row];

    NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,model.icon];
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    [cell.iconImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"work_order"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    cell.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.nameLabel.text = model.name;
    cell.numberIdLabel.text = model.number_id;
    cell.bianhaoLabel.text = @"编号:";
    
    cell.realNameLabel.text = model.real_name;
    [cell.realNameLabel setTextColor:TABBAR_BASE_COLOR];
    
    NSInteger one = 1;
    NSInteger two = 2;
    NSInteger three = 3;
    NSInteger four = 4;
    NSInteger five = 5;
    NSInteger six = 6;
    NSInteger seven = 7;
    
    if (model.speed == [NSNumber numberWithInteger:one]) {
        cell.speedLabel.text = @"申请中";
        cell.speedLabel.backgroundColor = UIColorFromRGB(0xa4c989, 1);
    }else if (model.speed == [NSNumber numberWithInteger:two]){
        cell.speedLabel.text = @"审批中";
        cell.speedLabel.backgroundColor = UIColorFromRGB(0x889fda, 1);
    }else if (model.speed == [NSNumber numberWithInteger:three]){
        cell.speedLabel.text = @"审批成功";
        cell.speedLabel.backgroundColor = customBlueColor;
    }else if (model.speed == [NSNumber numberWithInteger:four]){
        cell.speedLabel.text = @"已签约";
        cell.speedLabel.backgroundColor = customGreenColor;
    }else if (model.speed == [NSNumber numberWithInteger:five]){
        cell.speedLabel.text = @"已放款";
        cell.speedLabel.backgroundColor = UIColorFromRGB(0xeb6877, 1);
    }else if (model.speed == [NSNumber numberWithInteger:six]){
        cell.speedLabel.text = @"已成功";
        cell.speedLabel.backgroundColor = UIColorFromRGB(0xeb6877, 1);
    }else if (model.speed == [NSNumber numberWithInteger:seven]){
        cell.speedLabel.text = @"未通过";
        cell.speedLabel.backgroundColor = [UIColor lightGrayColor];
    }

    if (![Utils isBlankString:model.myPushId]) {
        cell.signImage.hidden = NO;
        cell.signImage.image = [UIImage imageNamed:@"推送"];
    } else if (![Utils isBlankString:model.ptpId]) {
        cell.signImage.hidden = NO;
        cell.signImage.image = [UIImage imageNamed:@"接收"];
    } else {
        
        if ([model.publicity_mech_id isEqualToString:@"0"]) {
            cell.signImage.hidden = NO;
            cell.signImage.image = [UIImage imageNamed:@"officialOrder"];
        }else {
            cell.signImage.hidden = YES;
        }
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyOrderModel * model = self.dataArray[indexPath.row];
    if (model.speed == [NSNumber numberWithInteger:1]){
        OnApplyOrderViewController * onApplyOrderVC = [[OnApplyOrderViewController alloc]init];
        onApplyOrderVC.orderID = model.kid;
        loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
        onApplyOrderVC.ptpId = model.ptpId;
        onApplyOrderVC.myPushId = model.myPushId;
        onApplyOrderVC.orderModel = model;
        onApplyOrderVC.jrq_mechanism_id = [NSString stringWithFormat:@"%@",model.jrq_mechanism_id];
        onApplyOrderVC.publicity_mech_id = [NSString stringWithFormat:@"%@",model.publicity_mech_id];
        onApplyOrderVC.ptpMechUserId = [NSString stringWithFormat:@"%@",model.ptpMechUserId];
        onApplyOrderVC.ptpMechId = [NSString stringWithFormat:@"%@",model.ptpMechId];
        onApplyOrderVC.ptpMechUserIcon = [NSString stringWithFormat:@"%@",model.ptpMechUserIcon];
        onApplyOrderVC.mechanism_other_id = [NSString stringWithFormat:@"%@",model.mechanism_other_id];
        onApplyOrderVC.refreshBlock = ^{
            [self.myOrderTableView.header beginRefreshing];
        };
        NSArray *powerList = (NSArray *)loginModel.powerList;
        
        NSMutableArray *funIdArray = [NSMutableArray array];
        for (int i=0; i<powerList.count; i++) {
            NSDictionary *powerDic = powerList[i];
            NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
            [funIdArray addObject:funId];
        }
        if ([funIdArray containsObject:@"21"]) {
            onApplyOrderVC.isAssignedApprover = 1;
        } else {
            onApplyOrderVC.isAssignedApprover = 0;
        }
        [onApplyOrderVC returnIsRefreshMyOrder:^(NSString *returnIsRefrshMyOrder) {
           
            self.isRefreshMyOrder = returnIsRefrshMyOrder;
        }];
        [self.navigationController pushViewController:onApplyOrderVC animated:YES];
        
    }else{
        LookOrderInfoViewController * lookOrderInfoVC = [[LookOrderInfoViewController alloc]init];
        
        lookOrderInfoVC.orderID = model.kid;
        
        lookOrderInfoVC.jrq_mechanism_id = [NSString stringWithFormat:@"%@",model.jrq_mechanism_id];
        lookOrderInfoVC.publicity_mech_id = [NSString stringWithFormat:@"%@",model.publicity_mech_id];
        lookOrderInfoVC.ptpMechUserId = [NSString stringWithFormat:@"%@",model.ptpMechUserId];
        lookOrderInfoVC.ptpMechId = [NSString stringWithFormat:@"%@",model.ptpMechId];
        lookOrderInfoVC.ptpMechUserIcon = [NSString stringWithFormat:@"%@",model.ptpMechUserIcon];
        lookOrderInfoVC.mechanism_other_id = [NSString stringWithFormat:@"%@",model.mechanism_other_id];
        lookOrderInfoVC.ptpId = model.ptpId;
        lookOrderInfoVC.myPushId = model.myPushId;
        lookOrderInfoVC.orderModel = model;
        lookOrderInfoVC.refreshBlcok = ^{
            [self.myOrderTableView.header beginRefreshing];
        };
        [self.navigationController pushViewController:lookOrderInfoVC animated:YES];
    }
}

//-(void)searchBarSearchButtonClicked:(NSString *)textString{
//    
//    NSString * stringUTF8 = [textString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    
//    LoginPeopleModel *myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
//    [HttpRequestEngine searchMyOrderListWithUid:[NSString stringWithFormat:@"%ld",myModel.userId] OrderSearch:stringUTF8 completion:^(id obj, NSString *errorStr) {
//        
//        if (errorStr == nil) {
//            [self.dataArray removeAllObjects];
//            
//            [self.dataArray addObjectsFromArray:obj];
//            
//            
//            [self.myOrderTableView reloadData];
//        }else{
//            
//            [self.dataArray removeAllObjects];
//            
//            [MBProgressHUD showError:@"未查询到数据"];
//            
//        }
//
//        
//    }];
//    
//}


-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }return _dataArray;
    
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
