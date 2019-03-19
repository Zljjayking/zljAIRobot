//
//  ApproveOrderViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ApproveOrderViewController.h"
#import "ApproveOrderModel.h"
#import "MyOrderTableViewCell.h"
#import "MyOrderModel.h"
#import "ApproveDetailViewController.h"

@interface ApproveOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * approveOrderTableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,copy) NSString * isRefreshApproveOrder;

@property (nonatomic, assign) NSInteger page;
@end

@implementation ApproveOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.isRefreshApproveOrder isEqualToString:@"99"]) {
        
        [self loadData];
        [self.approveOrderTableView reloadData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(search:) name:@"searchShenPi" object:nil];
    self.page = 0;
    [self creatUI];
    [self loadData];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.isRefreshApproveOrder = @"000";
}

- (void)search:(NSNotification *)noti {
    
    NSLog(@"监听到高级搜索审批的通知");
    NSDictionary *dic = noti.userInfo;
    NSMutableDictionary *searchDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"searchShenPi"]];
    self.approveOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self loadDataWithSeachDic:searchDic];
        [self.approveOrderTableView.footer resetNoMoreData];
    }];
    self.approveOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self loadDataWithSeachDic:searchDic];
        
    }];
    [self.approveOrderTableView.header beginRefreshing];
//    [self.dataArray removeAllObjects];
//    [self.dataArray addObjectsFromArray:arr];
//    [self.approveOrderTableView reloadData];

}

-(void)loadData{
    
    
    LoginPeopleModel *myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    NSString* userID = [NSString stringWithFormat:@"%ld",myModel.userId];
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    [HttpRequestEngine getApproveOrderListWithUid:userID page:page completion:^(id obj, NSString *errorStr) {
        
//        [MBProgressHUD hideHUD];
        [self.approveOrderTableView.header endRefreshing];
        if (errorStr == nil) {
            if (self.page == 0) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArr = (NSArray *)obj;
            
            [self.dataArray addObjectsFromArray:dataArr];
            
            [self.approveOrderTableView reloadData];
            
            [self.approveOrderTableView.footer endRefreshing];
            
            if (dataArr.count < 10) {
                [self.approveOrderTableView.footer noticeNoMoreData];
            }
            if (self.dataArray.count == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
        }else{
            self.blankV.hidden = NO;
            [self.dataArray removeAllObjects];
            [self.approveOrderTableView reloadData];
//            [MBProgressHUD showError:errorStr];
            
        }
        
        
    }];
}
- (void)loadDataWithSeachDic:(NSMutableDictionary *)dic  {
//    LoginPeopleModel *myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
//    NSString* userID = [NSString stringWithFormat:@"%ld",myModel.userId];
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    [HttpRequestEngine searchOrderWithDic:dic page:page completion:^(id obj, NSString *errorStr) {
//        [MBProgressHUD hideHUD];
        [self.approveOrderTableView.header endRefreshing];
        if (errorStr == nil) {
            if (self.page == 0) {
                [self.dataArray removeAllObjects];
            }
            
            NSArray *dataArr = (NSArray *)obj;
            NSLog(@"array==%ld",dataArr.count);
            [self.dataArray addObjectsFromArray:dataArr];
            
            [self.approveOrderTableView reloadData];
            
            [self.approveOrderTableView.footer endRefreshing];
            
            if (dataArr.count == 0) {
                [self.approveOrderTableView.footer noticeNoMoreData];
            }
            if (self.dataArray.count == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
        }else{
            self.blankV.hidden = NO;
            [self.dataArray removeAllObjects];
            [self.approveOrderTableView reloadData];
//            [MBProgressHUD showError:errorStr];
        }
        
        
    }];

}
-(void)creatUI{
    
    _approveOrderTableView = [[UITableView alloc]init];
    _approveOrderTableView.delegate = self;
    _approveOrderTableView.dataSource = self;
    [self.view addSubview:_approveOrderTableView];
    _approveOrderTableView.rowHeight = 80.f;
    
    [_approveOrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.approveOrderTableView setTableFooterView:view];
    
    [_approveOrderTableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ApproveOrderCellID"];
    

    _approveOrderTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self.approveOrderTableView.footer resetNoMoreData];
        [self loadData];
    }];
    _approveOrderTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self loadData];
    }];
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无订单信息!"];
    [self.approveOrderTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ApproveOrderCellID"];
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
        } else {
            cell.signImage.hidden = YES;
        }
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ApproveDetailViewController * approveDetailVC = [[ApproveDetailViewController alloc]init];
    MyOrderModel * model = self.dataArray[indexPath.row];
    approveDetailVC.orderID = model.kid;
    approveDetailVC.ptpId = model.ptpId;
    approveDetailVC.myPushId = model.myPushId;
    approveDetailVC.ptpMechUserId = [NSString stringWithFormat:@"%@",model.ptpMechUserId];
    approveDetailVC.ptpMechId = [NSString stringWithFormat:@"%@",model.ptpMechId];
    approveDetailVC.ptpMechUserIcon = [NSString stringWithFormat:@"%@",model.ptpMechUserIcon];
    approveDetailVC.jrq_mechanism_id = [NSString stringWithFormat:@"%@",model.jrq_mechanism_id];
    approveDetailVC.publicity_mech_id = [NSString stringWithFormat:@"%@",model.publicity_mech_id];
    [approveDetailVC returnIsRefreshApproveOrder:^(NSString *returnIsRefrshApproveOrder) {
       
        self.isRefreshApproveOrder = returnIsRefrshApproveOrder;
    }];
    
    [self.navigationController pushViewController:approveDetailVC animated:YES];
    
}


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
