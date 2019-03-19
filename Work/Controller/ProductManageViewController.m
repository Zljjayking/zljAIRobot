//
//  ProductManageViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ProductManageViewController.h"
#import "productModel.h"
#import "productTableViewCell.h"
#import "rightTableViewCell.h"
#import "rightModel.h"
#import "EditRightViewController.h"
#import "LoginPeopleModel.h"
#import "TaskTableViewCell.h"
#import "TaskListModel.h"
#import "EditTaskViewController.h"
#import "TaskTemplateViewController.h"
#import "productChooseTableViewCell.h"
#import "ProductDetailVC.h"
#import "AddProductViewController.h"
#import "ContactDetailsViewController.h"
#import "BianjiProductViewController.h"


@interface ProductManageViewController ()<UITableViewDelegate,UITableViewDataSource,JKAlertViewDelegate>{
    
    LoginPeopleModel *loginModel;
    NSInteger _pageIndex;
}

@property (nonatomic, strong) UITableView *productTableView;
@property (nonatomic, strong) UITableView *taskTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *rightList;
@property (nonatomic, strong) NSMutableArray *DagouProductID;
@property (nonatomic, strong) NSMutableArray *DagouProductName;
@property (nonatomic, strong) NSMutableArray *taskIDMutable;
@property (nonatomic, strong) NSMutableArray *taskNameMutable;
@property (nonatomic, strong) NSString *isRefreshRight;
@property (nonatomic, strong) NSString *isRetreshTask;
@property (nonatomic, strong) NSString *isRefreshProduct;
@property (nonatomic, strong) NSString *isRefreshXiaJia;

@property (nonatomic,strong) NSString *isRefreshBianJi;

@property (nonatomic, strong) NSString *proID;
@property (nonatomic, strong) NSString *cityID;

@property (nonatomic) NSString *rows;

@end

@implementation ProductManageViewController
static int panduan;
//懒加载productTableView
- (UITableView *)productTableView {
    if (!_productTableView) {
        _productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        if (self.ishideNaviView) {
            _productTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight);
        }
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _productTableView.backgroundColor = VIEW_BASE_COLOR;
        
        [_productTableView registerClass:[productTableViewCell class] forCellReuseIdentifier:@"cell"];
        _productTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requsetProduct];
        }];
        
        _productTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self refreshProductFooter];
        }];
    }
    return _productTableView;
}
- (UITableView *)taskTableView {
    if (!_taskTableView) {
        _taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        _taskTableView.delegate = self;
        _taskTableView.dataSource = self;
        _taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _taskTableView.backgroundColor = GRAY229;
        
        [_taskTableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"cell"];
        _taskTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestTask];
        }];
    }
    return _taskTableView;
}
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = VIEW_BASE_COLOR;
        
        [_rightTableView registerClass:[rightTableViewCell class] forCellReuseIdentifier:@"cell"];
        _rightTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestRightData];
        }];
    }
    return _rightTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    panduan = 1;
    [super viewWillAppear:animated];
    
    if (_seType == 1)
        
    {
        if ([self.isRefreshProduct isEqualToString:@"1"]) {
            [self.productTableView.header beginRefreshing];
//            [self setupProductView];
        }
        
        if ([self.isRefreshXiaJia isEqualToString:@"11"]) {
            [self.productTableView.header beginRefreshing];
//            [self setupProductView];
        }
        
        if ([self.isRefreshBianJi isEqualToString:@"9"]) {
            [self.productTableView.header beginRefreshing];
//            [self setupProductView];
        }
    }
    else if (_seType == 2)
    {
        if ([self.isRetreshTask isEqualToString:@"1"]) {
            [self.taskTableView.header beginRefreshing];
//            [self setupTaskView];
        }
        
    }
    else if (_seType == 3)
    {
        NSLog(@"self.isRefreshRight == %@",self.isRefreshRight);
        if ([self.isRefreshRight isEqualToString:@"1"]) {
            [self.rightTableView.header beginRefreshing];
//            [MBProgressHUD showMessage:@"正在加载数据..."];
//            [self setupRightView];
        }
        
    }
    else if (_seType == 4)
    {
//        [self setupChooseView];
    }
    else if ( _seType == 5) {
//        [self setupSearch];
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isRefreshXiaJia:) name:@"isRefreshXiaJia" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPro:) name:@"refreshPro" object:nil];
    [MBProgressHUD showMessage:@"加载中..."];
    self.DagouProductID = [NSMutableArray array];
    self.DagouProductName = [NSMutableArray array];
    [self.DagouProductName removeAllObjects];
    [self.DagouProductID removeAllObjects];
    self.taskIDMutable = [NSMutableArray array];
    self.taskNameMutable = [NSMutableArray array];
    if (self.taskMechProIDArr.count || self.taskMechProNameArr.count) {
        [self.taskNameMutable addObjectsFromArray:self.taskMechProNameArr];
        [self.taskIDMutable addObject:self.taskMechProIDArr];
    }
    self.proID = [[NSUserDefaults standardUserDefaults]objectForKey:@"proId"];
    self.cityID = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityId"];
    
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.view.backgroundColor = VIEW_BASE_COLOR;

    
    
    if (_seType == 1)
    {
        
        if (self.isAddPro) {
            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
            UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPro)];
            self.navigationItem.rightBarButtonItem = right;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        }
        [self setupProductView];
    }
    else if (_seType == 2)
    {
        if (self.isAddTask) {
            [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
            UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPro)];
            self.navigationItem.rightBarButtonItem = right;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        }
        [self setupTaskView];
    }
    else if (_seType == 3)
    {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPro)];
        self.navigationItem.rightBarButtonItem = right;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        
        [self setupRightView];
    }
    else if (_seType == 4)
    {
        
        [self setupChooseView];
    }
    else if ( _seType == 5) {
        [self setupSearch];
    }
}
- (void)isRefreshXiaJia:(NSNotification*)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"isRefreshXiaJia"] isEqualToString:@"11"]) {
        [self.productTableView.header beginRefreshing];
    }
}
- (void)refreshPro:(NSNotification*)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"refreshPro"] isEqualToString:@"9"]) {
        [self.productTableView.header beginRefreshing];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    self.isRefreshRight = @"0";
    self.isRetreshTask = @"0";
    self.isRefreshProduct = @"0";
    self.isRefreshXiaJia = @"0";
    self.isRefreshBianJi = @"0";
}
#pragma mark -- 创建各个页面
- (void)setupProductView {
    self.productTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无产品信息"];
    
    [self.productTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    self.navigationItem.title = @"产品管理";
    [self.view addSubview:self.productTableView];
    self.rows = @"10";
    [self requsetProduct];

}

- (void)requsetProduct {
    
    _pageIndex = 0;
    [self.productTableView.footer resetNoMoreData];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{@"inter":@"selectproduct2",@"rows":self.rows,@"page":@(_pageIndex),@"mid":[NSString stringWithFormat:@"%ld",loginModel.jrqMechanismId],@"area_pro_id":self.proID,@"area_city_id":self.cityID,@"area_area_id":@""};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        [self.productTableView.header endRefreshing];
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
        NSString *errorMsg = dic[@"errorMsg"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *data = dic[@"data"];
            NSArray *rows = data[@"rows"];
            if (rows.count < 10) {
                [self.productTableView.footer noticeNoMoreData];
            }
            self.searchList = [NSMutableArray array];
            if (rows.count == 0) {
                
                [self.searchList removeAllObjects];
                [self.productTableView reloadData];
                
                
            } else {
                
                for (int i = 0; i < rows.count; i++) {
                    productModel *model = [productModel new];
                    NSDictionary *searchDic = [NSDictionary changeType:rows[i]];
                    model.mechProName = searchDic[@"mechProName"];
                    model.mechProType = searchDic[@"mechProType"];
                    model.mechProIcon = searchDic[@"mechProIcon"];
                    model.mechanName = searchDic[@"mechanName"];
                    //8月22新加字段
                    model.publicity_mech_id = [NSString stringWithFormat:@"%@",searchDic[@"publicity_mech_id"]];
                    model.jrq_mechanism_id = [NSString stringWithFormat:@"%@",searchDic[@"jrq_mechanism_id"]];
                    model.mechUserIcon = [NSString stringWithFormat:@"%@",searchDic[@"mechUserIcon"]];
                    model.mechUserid = [NSString stringWithFormat:@"%@",searchDic[@"mechUserid"]];
                    
                    
                    model.bankId = searchDic[@"bankId"];
                    model.minDay = [NSString stringWithFormat:@"%@",searchDic[@"minDay"]];
                    model.maxDay = [NSString stringWithFormat:@"%@",searchDic[@"maxDay"]];
                    model.minCash = [NSString stringWithFormat:@"%@",searchDic[@"minCash"]];
                    model.maxCash = [NSString stringWithFormat:@"%@",searchDic[@"maxCash"]];
                    model.tabInterestRate = [NSString stringWithFormat:@"%@",searchDic[@"tabInterestRate"]];
                    model.type = [NSString stringWithFormat:@"%@",searchDic[@"type"]];
                    model.mechProGoodness = searchDic[@"mechProGoodness"];
                    model.costDescription = searchDic[@"costDescription"];
                    model.tabCustomerType = [NSString stringWithFormat:@"%@",searchDic[@"tabCustomerType"]];
                    model.tabReimburSement = [NSString stringWithFormat:@"%@",searchDic[@"tabReimburSement"]];
                    model.appliMaterials = searchDic[@"appliMaterials"];
                    model.appliCondition = searchDic[@"appliCondition"];
                    model.mechProtext = searchDic[@"mechProtext"];
                    model.proId = [NSString stringWithFormat:@"%@",searchDic[@"proId"]];
                    model.cityId = [NSString stringWithFormat:@"%@",searchDic[@"cityId"]];
                    model.areaId = [NSString stringWithFormat:@"%@",searchDic[@"areaId"]];
                    model.ID = [NSString stringWithFormat:@"%@",searchDic[@"id"]];
                    
                    NSString *method = [NSString stringWithFormat:@"%@",searchDic[@"tabReimburSement"]];
                    
                    if ([method isEqualToString:@"1"]) {
                        model.method = @"还款方式：等额本息";
                    } else if ([method isEqualToString:@"2"]) {
                        model.method = @"还款方式：等额本金";
                    } else if ([method isEqualToString:@"3"]) {
                        model.method = @"还款方式：先息后本";
                    } else {
                        model.method = @"还款方式：其他";
                    }
                    
                    model.myPushId = [NSString stringWithFormat:@"%@",searchDic[@"myPushId"]];
                    model.ptpId = [NSString stringWithFormat:@"%@",searchDic[@"ptpId"]];
                    model.mechId = [NSString stringWithFormat:@"%@",searchDic[@"mechId"]];
                    
                    model.ptpMechId = [NSString stringWithFormat:@"%@",searchDic[@"ptpMechId"]];
                    model.ptpMechUserId = [NSString stringWithFormat:@"%@",searchDic[@"ptpMechUserId"]];
                    model.ptpMechUserIcon = [NSString stringWithFormat:@"%@",searchDic[@"ptpMechUserIcon"]];
                    
                    if ([self.myMobile isEqualToString:@"15255353386"]) {
                        if (![model.publicity_mech_id isEqualToString:@"0"]) {
                            if (self.seType == 4 && self.limit == 1) {
                                for (int i=0; i<self.limitArr.count; i++) {
                                    productModel *exitPro = self.limitArr[i];
                                    if ([model.ID isEqualToString:exitPro.ID]) {
                                        [self.searchList addObject:model];
                                    }
                                }
                                
                            }else if (self.seType == 5 && self.limit == 1) {
                                for (int i=0; i<self.limitArr.count; i++) {
                                    productModel *exitPro = self.limitArr[i];
                                    if ([model.ID isEqualToString:exitPro.ID]) {
                                        [self.searchList addObject:model];
                                    }
                                }
                                
                            } else {
                                if (self.seType == 1) {
                                    if (self.taskMechProIDArr.count > 0) {
                                        for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                            
                                            if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                                [self.searchList addObject:model];
                                            }
                                        }
                                        
                                    } else {
                                        if (self.taskMechProIDArr) {
                                            for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                                
                                                if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                                    model.isChoice = 1;
                                                    if (![self.DagouProductID containsObject:model.ID]) {
                                                        [self.DagouProductID addObject:model.ID];
                                                    }
                                                    if (![self.DagouProductName containsObject:model.mechProName]) {
                                                        [self.DagouProductName addObject:model.mechProName];
                                                    }
                                                }
                                            }
                                            
                                        } else {
                                            model.isChoice = 0;
                                        }
                                        [self.searchList addObject:model];
                                    }
                                } else {
                                    if (self.taskMechProIDArr) {
                                        for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                            
                                            if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                                model.isChoice = 1;
                                                if (![self.DagouProductID containsObject:model.ID]) {
                                                    [self.DagouProductID addObject:model.ID];
                                                }
                                                if (![self.DagouProductName containsObject:model.mechProName]) {
                                                    [self.DagouProductName addObject:model.mechProName];
                                                }
                                            }
                                        }
                                        
                                    } else {
                                        model.isChoice = 0;
                                    }
                                    [self.searchList addObject:model];
                                }
                            }
                        }
                    } else {
                        if (self.seType == 4 && self.limit == 1) {
                            for (int i=0; i<self.limitArr.count; i++) {
                                productModel *exitPro = self.limitArr[i];
                                if ([model.ID isEqualToString:exitPro.ID]) {
                                    [self.searchList addObject:model];
                                }
                            }
                            
                        }else if (self.seType == 5 && self.limit == 1) {
                            for (int i=0; i<self.limitArr.count; i++) {
                                productModel *exitPro = self.limitArr[i];
                                if ([model.ID isEqualToString:exitPro.ID]) {
                                    [self.searchList addObject:model];
                                }
                            }
                            
                        } else {
                            if (self.seType == 1) {
                                if (self.taskMechProIDArr.count > 0) {
                                    for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                        
                                        if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                            [self.searchList addObject:model];
                                        }
                                    }
                                    
                                } else {
                                    if (self.taskMechProIDArr) {
                                        for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                            
                                            if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                                model.isChoice = 1;
                                                if (![self.DagouProductID containsObject:model.ID]) {
                                                    [self.DagouProductID addObject:model.ID];
                                                }
                                                if (![self.DagouProductName containsObject:model.mechProName]) {
                                                    [self.DagouProductName addObject:model.mechProName];
                                                }
                                            }
                                        }
                                        
                                    } else {
                                        model.isChoice = 0;
                                    }
                                    [self.searchList addObject:model];
                                }
                            } else {
                                if (self.taskMechProIDArr) {
                                    for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                        
                                        if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                            model.isChoice = 1;
                                            if (![self.DagouProductID containsObject:model.ID]) {
                                                [self.DagouProductID addObject:model.ID];
                                            }
                                            if (![self.DagouProductName containsObject:model.mechProName]) {
                                                [self.DagouProductName addObject:model.mechProName];
                                            }
                                        }
                                    }
                                    
                                } else {
                                    model.isChoice = 0;
                                }
                                [self.searchList addObject:model];
                            }
                        }
                    }
                    
                    
                    
                }
                if (self.seType == 1 && self.searchList.count==0) {
//                    JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"未查到产品" message:nil
//                                                                   delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//                    [alert show];
                }

                if (self.searchList.count == self.DagouProductID.count ) {
                    self.selectStatus = 1;
                }
                if (panduan == 1) {
                    if (self.seType == 4 && self.limit == 1) {
                        NSLog(@"self.searchList.count == %ld",self.searchList.count);
                        if (self.searchList.count == 0) {
                            JKAlertView *alert = [[JKAlertView alloc]initWithTitle:nil message:@"申请的产品不存在或已下架" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                    if (self.seType == 5 && self.limit == 1) {
                        NSLog(@"self.searchList.count == %ld",self.searchList.count);
                        if (self.searchList.count == 0) {
                            JKAlertView *alert = [[JKAlertView alloc]initWithTitle:nil message:@"没有适合您申请的产品!" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                }
                panduan = panduan+1;
                [self.productTableView reloadData];
                
                
            }
            
            if (self.searchList.count == 0) {
                self.blankV.hidden = NO;
            } else {
                self.blankV.hidden = YES;
            }
        } else {
            self.blankV.hidden = NO;
            [MBProgressHUD showError:errorMsg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUD];
        [self.productTableView.header endRefreshing];
        [MBProgressHUD showError:@"网络出错"];
        self.blankV.hidden = NO;
    }];

}

- (void)refreshProductFooter {
    _pageIndex ++;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parameters = @{@"inter":@"selectproduct2",@"rows":self.rows,@"page":@(_pageIndex),@"mid":[NSString stringWithFormat:@"%ld",loginModel.jrqMechanismId],@"area_pro_id":self.proID,@"area_city_id":self.cityID,@"area_area_id":@""};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  NSLog(@"数据：%@",responseObject);
        [MBProgressHUD hideHUD];
        [self.productTableView.footer endRefreshing];
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
        NSString *errorMsg = dic[@"errorMsg"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *data = dic[@"data"];
            NSArray *rows = data[@"rows"];
            if (rows.count < 10) {
                [self.productTableView.footer noticeNoMoreData];
                [self.productTableView reloadData];
            }
            if (rows.count == 0) {
                
            } else {
                for (int i = 0; i < rows.count; i++) {
                    productModel *model = [productModel new];
                    NSDictionary *searchDic = [NSDictionary changeType:rows[i]];
                    model.mechProName = searchDic[@"mechProName"];
                    model.mechProType = searchDic[@"mechProType"];
                    model.mechProIcon = searchDic[@"mechProIcon"];
                    model.mechanName = searchDic[@"mechanName"];
                    
                    //8月22新加字段
                    model.publicity_mech_id = [NSString stringWithFormat:@"%@",searchDic[@"publicity_mech_id"]];
                    model.jrq_mechanism_id = [NSString stringWithFormat:@"%@",searchDic[@"jrq_mechanism_id"]];
                    model.mechUserIcon = [NSString stringWithFormat:@"%@",searchDic[@"mechUserIcon"]];
                    model.mechUserid = [NSString stringWithFormat:@"%@",searchDic[@"mechUserid"]];
                    
                    model.bankId = searchDic[@"bankId"];
                    
                    model.minDay = searchDic[@"minDay"];
                    model.maxDay = searchDic[@"maxDay"];
                    model.minCash = searchDic[@"minCash"];
                    model.maxCash = searchDic[@"maxCash"];
                    model.tabInterestRate = searchDic[@"tabInterestRate"];
                    model.type = searchDic[@"type"];
                    model.mechProGoodness = searchDic[@"mechProGoodness"];
                    model.costDescription = searchDic[@"costDescription"];
                    model.tabCustomerType = searchDic[@"tabCustomerType"];
                    model.tabReimburSement = searchDic[@"tabReimburSement"];
                    model.appliMaterials = searchDic[@"appliMaterials"];
                    model.appliCondition = searchDic[@"appliCondition"];
                    model.mechProtext = searchDic[@"mechProtext"];
                    model.proId = searchDic[@"proId"];
                    model.cityId = searchDic[@"cityId"];
                    model.areaId = searchDic[@"areaId"];
                    model.ID = [NSString stringWithFormat:@"%@",searchDic[@"id"]];
                    NSString *method = [NSString stringWithFormat:@"%@",searchDic[@"reimbursement"]];
                    if ([method isEqualToString:@"1"]) {
                        model.method = @"还款方式：等额本息";
                    } else if ([method isEqualToString:@"2"]) {
                        model.method = @"还款方式：等额本金";
                    } else if ([method isEqualToString:@"3"]) {
                        model.method = @"还款方式：先息后本";
                    } else {
                        model.method = @"还款方式：其他";
                    }
                    
                    
                    model.myPushId = [NSString stringWithFormat:@"%@",searchDic[@"myPushId"]];
                    model.ptpId = [NSString stringWithFormat:@"%@",searchDic[@"ptpId"]];
                    model.mechId = [NSString stringWithFormat:@"%@",searchDic[@"mechId"]];
                    
                    model.ptpMechId = [NSString stringWithFormat:@"%@",searchDic[@"ptpMechId"]];
                    model.ptpMechUserId = [NSString stringWithFormat:@"%@",searchDic[@"ptpMechUserId"]];
                    model.ptpMechUserIcon = [NSString stringWithFormat:@"%@",searchDic[@"ptpMechUserIcon"]];
                    
                    if ([self.myMobile isEqualToString:@"15255353386"]) {
                        if (![model.publicity_mech_id isEqualToString:@"0"]) {
                            if (self.seType == 4 && self.limit == 1) {
                                for (int i=0; i<self.limitArr.count; i++) {
                                    productModel *exitPro = self.limitArr[i];
                                    if ([model.ID isEqualToString:exitPro.ID]) {
                                        [self.searchList addObject:model];
                                    }
                                }
                                
                            } else {
                                if (self.taskMechProIDArr) {
                                    for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                        
                                        if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                            model.isChoice = 1;
                                            [self.DagouProductID addObject:model.ID];
                                            [self.DagouProductName addObject:model.mechProName];
                                        }
                                    }
                                } else {
                                    if (self.selectStatus == 1) {
                                        model.isChoice = 1;
                                        [self.DagouProductID addObject:model.ID];
                                        [self.DagouProductName addObject:model.mechProName];
                                    } else {
                                        model.isChoice = 0;
                                    }
                                }
                                
                                [self.searchList addObject:model];
                            }

                        }
                    } else {
                        if (self.seType == 4 && self.limit == 1) {
                            for (int i=0; i<self.limitArr.count; i++) {
                                productModel *exitPro = self.limitArr[i];
                                if ([model.ID isEqualToString:exitPro.ID]) {
                                    [self.searchList addObject:model];
                                }
                            }
                            
                        } else {
                            if (self.taskMechProIDArr) {
                                for (int j=0; j<self.taskMechProIDArr.count; j++) {
                                    
                                    if ([model.ID isEqualToString:self.taskMechProIDArr[j]]) {
                                        model.isChoice = 1;
                                        [self.DagouProductID addObject:model.ID];
                                        [self.DagouProductName addObject:model.mechProName];
                                    }
                                }
                            } else {
                                if (self.selectStatus == 1) {
                                    model.isChoice = 1;
                                    [self.DagouProductID addObject:model.ID];
                                    [self.DagouProductName addObject:model.mechProName];
                                } else {
                                    model.isChoice = 0;
                                }
                            }
                            
                            [self.searchList addObject:model];
                        }

                    }
                    
                    
                }
                
                if (panduan == 1) {
                    if (self.seType == 4 && self.limit == 1) {
                        NSLog(@"self.searchList.count == %ld",self.searchList.count);
                        if (self.searchList.count == 0) {
                            JKAlertView *alert = [[JKAlertView alloc]initWithTitle:nil message:@"申请的产品不存在或已下架" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                }
                panduan = panduan+1;
                [self.productTableView reloadData];
            }
        } else {
            [MBProgressHUD showError:errorMsg];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUD];
        [self.productTableView.footer endRefreshing];
        [MBProgressHUD showError:@"网络出错"];
    }];
}
- (void)setupTaskView {
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无任务信息"];
    [self.taskTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    self.navigationItem.title = @"任务";
    [self.view addSubview:self.taskTableView];
    [self requestTask];
    
}
- (void)requestTask {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"loginModel.userId == %@",[NSString stringWithFormat:@"%ld",loginModel.userId]);
    NSDictionary *parameters = @{@"inter":@"querytask",@"userId":[NSString stringWithFormat:@"%ld",loginModel.userId]};
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *data = responseObject;
        
        if (data.count == 0) {
            self.blankV.hidden = NO;
        } else {
            self.blankV.hidden = YES;
        }
        [MBProgressHUD hideHUD];
        [self.taskTableView.header endRefreshing];
        self.searchList = [NSMutableArray array];
        if (data.count==0) {
            [self.searchList removeAllObjects];
            [self.taskTableView reloadData];
        } else {
            for (int i = 0; i < data.count; i++) {
                TaskListModel *model = [TaskListModel new];
                NSDictionary *searchDic = [NSDictionary changeType:data[i]];
                model.ID = searchDic[@"id"];
                model.content = searchDic[@"content"];
                model.cpId = searchDic[@"cpId"];
                model.icon = searchDic[@"icon"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
                [formatter setTimeZone:timeZone];
                NSDate *datenow = [NSDate date];
                //设置一个字符串的时间
                NSMutableString *datestring = [NSMutableString stringWithFormat:@"%@",searchDic[@"createTime"]];
                NSDateFormatter * dm = [[NSDateFormatter alloc]init];
                //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
                [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                NSDate * newdate = [dm dateFromString:datestring];
                long dd = (long)[datenow timeIntervalSince1970] - [newdate timeIntervalSince1970];
                NSString *timeString=@"";
                
                
                
                if (dd/3600<1)
                {

                    timeString = [NSString stringWithFormat:@"%ld", dd/60];
                    timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
                    if (dd/60<1) {
                        timeString=[NSString stringWithFormat:@"刚刚"];
                    }
                }
                if (dd/3600>=1&&dd/86400<1)
                {
                    timeString = [NSString stringWithFormat:@"%ld", dd/3600];
                    timeString=[NSString stringWithFormat:@"%@小时前", timeString];
                }
                if (dd/86400>=1)
                {
                    timeString = [NSString stringWithFormat:@"%ld", dd/86400];
                    timeString=[NSString stringWithFormat:@"%@天前", timeString];
                }
                model.createTime = timeString;
                model.cpName = searchDic[@"cpName"];
                model.name = searchDic[@"name"];
                model.personId = searchDic[@"personId"];
                model.type = [NSString stringWithFormat:@"%@",searchDic[@"type"]];
                model.personName = searchDic[@"personName"];
                [self.searchList addObject:model];
            }
            
            [self.taskTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [self.taskTableView.header endRefreshing];
        [MBProgressHUD showError:@"网络出错"];
        self.blankV.hidden = NO;
//        NSLog(@"Error: %@", error);
    }];
    
}
- (void)setupRightView {
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无权限信息"];
    [self.rightTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    self.navigationItem.title = @"权限管理";
    [self.view addSubview:self.rightTableView];
    [self requestRightData];
}
-(void)requestRightData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"inter":@"queryPower",@"userId":[NSString stringWithFormat:@"%ld",loginModel.userId]};
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        [self.rightTableView.header endRefreshing];
        NSArray *data = responseObject;
        NSLog(@"权限管理的data == %@",data);
        self.rightList = [NSMutableArray array];
        if (data.count==0) {
//            [MBProgressHUD showError:@"未搜索到结果"];
            [self.rightList removeAllObjects];
            [self.rightTableView reloadData];
        } else {
            for (int i = 0; i < data.count; i++) {
                rightModel *model = [rightModel new];
                NSDictionary *searchDic = [NSDictionary changeType:data[i]];
                model.ID = searchDic[@"id"];
                model.qxname = searchDic[@"qxname"];
                [self.rightList addObject:model];
            }
            
            [self.rightTableView reloadData];
        }
        if (self.rightList.count == 0) {
            self.blankV.hidden = NO;
        } else {
            self.blankV.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [self.rightTableView.header endRefreshing];
        [MBProgressHUD showError:@"网络出错"];
        self.blankV.hidden = NO;
    }];
}
- (void)setupChooseView {
    self.navigationItem.title = @"选择产品";
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPro)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTableView.backgroundColor = VIEW_BASE_COLOR;
    [self.view addSubview:self.productTableView];
    [self.productTableView registerClass:[productChooseTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.rows = @"100";
    [self requsetProduct];
    
}
- (void)setupSearch {
    self.navigationItem.title = @"查询结果";
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    self.productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.productTableView.backgroundColor = VIEW_BASE_COLOR;
    [self.view addSubview:self.productTableView];
    [self.productTableView registerClass:[productChooseTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.rows = @"100";
    [self requsetProduct];
}
- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)ClickAddPro {
    if (_seType == 1)
    {
        if (self.isAddPro) {
            
            //将地址写入沙盒
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path=[paths objectAtIndex:0];
            NSLog(@"%@",path);
            NSString *Json_path=[path stringByAppendingPathComponent:@"File.json"];
            
            [HttpRequestEngine areaListRequestCompletion:^(id obj,NSString * errorStr){
                if (!errorStr)
                {
                
                    NSLog(@"%@",[obj writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");
                    
                }
            }];

            AddProductViewController *addProductVC = [[AddProductViewController alloc]init];
            
            if (self.ishideNaviView) {
                
            }
            
            [addProductVC returnIsRefreshProduct:^(NSString *returnIsRefrshProduct) {
                self.isRefreshProduct = returnIsRefrshProduct;
            }];
            [self.navigationController pushViewController:addProductVC animated:YES];
            
            
        }else{
            [MBProgressHUD showError:@"暂无此权限"];
        }
        
    }
    else if (_seType == 2)
    {
        if (self.isAddTask) {
            TaskTemplateViewController *TaskTemplate = [TaskTemplateViewController new];
            [TaskTemplate returnIsRefreshTask:^(NSString *returnIsRefrshTask) {
                self.isRetreshTask = returnIsRefrshTask;
            }];
            [self.navigationController pushViewController:TaskTemplate animated:YES];
        } else{
            [MBProgressHUD showError:@"暂无此权限"];
        }
        
    }
    else if (_seType == 3)
    {
        
        EditRightViewController *editRight = [EditRightViewController new];
        editRight.rightName = @"";
        [editRight returnIsRefreshRight:^(NSString *returnIsRefrshRight) {
            self.isRefreshRight = returnIsRefrshRight;
        }];
        editRight.seType = 1;
        [self.navigationController pushViewController:editRight animated:YES];
    }
    else if (_seType == 4 || _seType == 5) {
        if (self.returnIDNSMutableArrayBlock != nil) {
            if (self.DagouProductID.count!=0) {
                self.returnIDNSMutableArrayBlock(self.DagouProductID);
            } else {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:@"点击选取"];
                self.returnIDNSMutableArrayBlock(arr);
            }
            
        }
        if (self.returnNameNSMutableArrayBlock != nil) {
            if (self.DagouProductID.count!=0) {
                self.returnNameNSMutableArrayBlock(self.DagouProductName);
            } else {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:@"点击选取"];
                self.returnNameNSMutableArrayBlock(arr);
            }
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//实现returnMutableArray 方法
- (void)returnIDMutableArray:(ReturnIDNSMutableArrayBlock)block {
    self.returnIDNSMutableArrayBlock = block;
}
- (void)returnNameMutableArray:(ReturnNameNSMutableArrayBlock)block {
    self.returnNameNSMutableArrayBlock = block;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.productTableView) {
        
        return self.searchList.count;
        
    } else if (tableView == self.taskTableView) {
        
        return self.searchList.count;
        
    } else if (tableView == self.rightTableView) {
        
        return self.rightList.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.productTableView) {
        return 1;
    } else if (tableView == self.taskTableView) {
        return 1;
    } else if (tableView == self.rightTableView) {
        return 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.productTableView) {
        return 105;// 57.5+45*KAdaptiveRateWidth
    } else if (tableView == self.taskTableView) {
        return 60*KAdaptiveRateWidth;
    } else if (tableView == self.rightTableView) {
        return 55*KAdaptiveRateWidth;
    }
    return 55*KAdaptiveRateWidth;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.productTableView) {
        if (self.seType == 4&& self.limit != 1) {
            if (section == 0) {
                return 40;
            }
        }
        return 0.01;
    } else if (tableView == self.taskTableView) {
        return 0.01;
    } else if (tableView == self.rightTableView) {
        if (section == 0) {
            return 0.01;
        } else {
            return 12;
        }
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.seType == 4 && self.limit != 1) {
        if (section == 0) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            view.backgroundColor = VIEW_BASE_COLOR;
            view.tag = section;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-40, 20)];
            titleLb.text = @"全选";
            [view addSubview:titleLb];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 7.5, 25, 25);
            [view addSubview:btn];
            btn.selected = self.selectStatus;
            [btn addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
            return view;
        }
    }
    if (tableView == self.taskTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.0)];
        view.backgroundColor = VIEW_BASE_COLOR;
        return view;
    } else if (tableView == self.rightTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        view.backgroundColor = VIEW_BASE_COLOR;
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.productTableView) {
        if (section == self.searchList.count-1) {
            return 0.01;
        } else {
            return 12;
        }
        
    } else if (tableView == self.taskTableView) {
        return 0.01;
    } else if (tableView == self.rightTableView) {
        return 0.01;
    }

    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.0)];
    view.backgroundColor = VIEW_BASE_COLOR;
    
    if (tableView == self.productTableView) {
        if (section == self.searchList.count-1) {
            return view;
        } else {
            view.frame = CGRectMake(0, 0, kScreenWidth, 12);
            return view;
        }
        
    } else if (tableView == self.taskTableView) {
        return view;
    } else if (tableView == self.rightTableView) {
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.productTableView) {
        if (_seType == 4 || _seType == 5) {
            
            productChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[productChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            productModel *model = self.searchList[indexPath.section];
            cell.DaGouBtn.tag = indexPath.section;
            if (self.limit == 1) {
                cell.DaGouBtn.hidden = YES;
                [cell.DaGouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.mas_left).offset(5*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(90*KAdaptiveRateHeight);
                    make.width.mas_equalTo(1*KAdaptiveRateWidth);
                }];
            } else {
                cell.DaGouImage.tag = 1000*(indexPath.section+1);
                if (model.isChoice) {
                    cell.DaGouBtn.selected = YES;
                    [cell.DaGouImage setImage:[UIImage imageNamed:@"checkbox_pressed"]];
                } else {
                    cell.DaGouBtn.selected = NO;
                    [cell.DaGouImage setImage:[UIImage imageNamed:@"checkbox_normal"]];
                }
            }
            
            if ([model.publicity_mech_id isEqualToString:@"0"]) {
                cell.officalProImage.hidden = NO;
                cell.officalProImage.image = [UIImage imageNamed:@"officialPro"];
            } else {
                cell.officalProImage.hidden = YES;
            }
            
            if (![Utils isBlankString:model.myPushId]) {
                cell.signImageView.hidden = NO;
                cell.signImageView.image = [UIImage imageNamed:@"推送"];
            } else if (![Utils isBlankString:model.ptpId]) {
                cell.signImageView.hidden = NO;
                cell.signImageView.image = [UIImage imageNamed:@"接收"];
            } else {
                cell.signImageView.hidden = YES;
            }
            [cell.DaGouBtn addTarget:self action:@selector(ChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *str = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,model.mechProIcon];
            
            NSURL *url = [NSURL URLWithString:str];
            [cell.mechProIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"work_product"]];
            cell.mechProTypeLB.text = model.mechProType;
            cell.mechProNameLB.text = model.mechProName;
            
            if ([model.tabInterestRate isEqual:@"null"]) {
                cell.tabInterestRateLB.text = @"月利率：%";
            }else{
                cell.tabInterestRateLB.text = [NSString stringWithFormat:@"月利率：%@%%",model.tabInterestRate];
            }
            
            cell.dayLB.text = [NSString stringWithFormat:@"%@-%@天放款",model.minDay,model.maxDay];
            cell.cashLB.text = [NSString stringWithFormat:@"%@-%@万元",model.minCash,model.maxCash];
            cell.methodLB.text = model.method;
            return cell;
            
        } else {
            productTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[productTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            productModel *model = self.searchList[indexPath.section];
            NSString *str = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,model.mechProIcon];
            NSURL *url = [NSURL URLWithString:str];
            [cell.mechProIcon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"work_product"]];
            cell.mechProTypeLB.text = model.mechProType;
            cell.mechProNameLB.text = model.mechProName;
            
            if ([model.publicity_mech_id isEqualToString:@"0"]) {
                cell.officalProImage.hidden = NO;
                cell.officalProImage.image = [UIImage imageNamed:@"officialPro"];
            } else {
                cell.officalProImage.hidden = YES;
            }
            
            if (![Utils isBlankString:model.myPushId]) {
                cell.signImageView.hidden = NO;
                cell.signImageView.image = [UIImage imageNamed:@"推送"];
            } else if (![Utils isBlankString:model.ptpId]) {
                cell.signImageView.hidden = NO;
                cell.signImageView.image = [UIImage imageNamed:@"接收"];
            } else {
                cell.signImageView.hidden = YES;
            }
            
            if ([model.tabInterestRate isEqual:@"null"]) {
                cell.tabInterestRateLB.text = @"月利率：%";
            }else{
                cell.tabInterestRateLB.text = [NSString stringWithFormat:@"月利率：%@%%",model.tabInterestRate];
            }
            
            cell.dayLB.text = [NSString stringWithFormat:@"%@-%@天放款",model.minDay,model.maxDay];
            cell.cashLB.text = [NSString stringWithFormat:@"%@-%@万元",model.minCash,model.maxCash];
            cell.methodLB.text = model.method;
            return cell;

        }
        
    } else if (tableView == self.taskTableView) {
        TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[TaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        TaskListModel *Model = self.searchList[indexPath.section];
        NSURL *icon = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,Model.icon]];
        [cell.headImage sd_setBackgroundImageWithURL:icon forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        [cell.headImage addTarget:self action:@selector(ClickHeadImage:) forControlEvents:UIControlEventTouchUpInside];
        cell.NameLb.text = Model.name;
        cell.SignLb.text = Model.content;
        cell.TimeLb.text = Model.createTime;
        return cell;
    } else if (tableView == self.rightTableView) {
        rightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[rightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        rightModel *Model = self.rightList[indexPath.section];
        cell.rightNameLB.text = Model.qxname;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.productTableView) {
        productModel *model = self.searchList[indexPath.section];
        ProductDetailVC *productDetail = [ProductDetailVC new];
        if (self.seType == 4 || self.limit == 1) {
            productDetail.setype = 1;
        }
        productDetail.refreshBlock = ^{
            [self.productTableView.header beginRefreshing];
        };
        productDetail.product = model;
        productDetail.isPushPro = self.isPushPro;
//        NSLog(@"model.proId == %@",model.proId);
        BianjiProductViewController * bjVC = [[BianjiProductViewController alloc]init];
        [bjVC returnIsRefreshBianJi:^(NSArray *returnIsRefrshBianJi) {
//            self.isRefreshBianJi = returnIsRefrshBianJi;
        }];
    
        [self.navigationController pushViewController:productDetail animated:YES];
    }else if (tableView == self.rightTableView) {
        rightModel *Model = self.rightList[indexPath.section];
        EditRightViewController *editRight = [EditRightViewController new];
        editRight.rightName = Model.qxname;
        [editRight returnIsRefreshRight:^(NSString *returnIsRefrshRight) {
            self.isRefreshRight = returnIsRefrshRight;
        }];
        editRight.seType = 2;
        editRight.powerId = Model.ID;
        [self.navigationController pushViewController:editRight animated:YES];
    } else if (tableView == self.taskTableView) {
        EditTaskViewController *editTask = [EditTaskViewController new];
        [editTask returnIsRefreshTask:^(NSString *returnIsRefrshTask) {
            self.isRetreshTask = returnIsRefrshTask;
        }];
        editTask.model = self.searchList[indexPath.section];
        editTask.isDelTask = self.isDelTask;
        editTask.seType = 1;
        [self.navigationController pushViewController:editTask animated:YES];
    }
}
//全选
- (void)chooseAll:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.selectStatus = 1;
        [self.DagouProductID removeAllObjects];
        [self.DagouProductName removeAllObjects];
        for (int i = 0; i<self.searchList.count; i++) {
            productModel *model = self.searchList[i];
            model.isChoice = 1;
            
            if (![self.DagouProductID containsObject:model.ID]) {
                [self.DagouProductID addObject:model.ID];
            }
            if (![self.DagouProductName containsObject:model.mechProName]) {
                [self.DagouProductName addObject:model.mechProName];
            }
        }
        
    } else {
        self.selectStatus = 0;
        [self.DagouProductID removeAllObjects];
        [self.DagouProductName removeAllObjects];
        for (int i = 0; i<self.searchList.count; i++) {
            productModel *model = self.searchList[i];
            model.isChoice = 0;
        }
    }
    [self.productTableView reloadData];
}
- (void)ChooseBtnClick:(UIButton *)Btn {
    Btn.selected = !Btn.selected;
    if (Btn.selected) {
        productModel *model = self.searchList[Btn.tag];
        model.isChoice = 1;
        if (![self.DagouProductID containsObject:model.ID]) {
            [self.DagouProductID addObject:model.ID];
        }
        if (![self.DagouProductName containsObject:model.mechProName]) {
            [self.DagouProductName addObject:model.mechProName];
        }
        if (self.DagouProductID.count == self.searchList.count) {
            self.selectStatus = 1;
        }
    } else {
        productModel *model = self.searchList[Btn.tag];
        model.isChoice = 0;
        [self.DagouProductID removeObject:model.ID];
        [self.DagouProductName removeObject:model.mechProName];
        self.selectStatus = 0;
    }
    [self.productTableView reloadData];
}
- (void)ClickHeadImage:(UIButton *)btn {
    TaskTableViewCell *cell = (TaskTableViewCell *)[btn superview];
    NSIndexPath *index = [self.taskTableView indexPathForCell:cell];
    NSLog(@"index.section == %ld",index.section);
    TaskListModel *Model = self.searchList[index.section];
    ContactDetailsViewController * cdVC = [[ContactDetailsViewController alloc]init];
    cdVC.uid = [NSString stringWithFormat:@"%@", Model.cpId];
    NSLog(@"cdVC.uid == %@",cdVC.uid);
    cdVC.setype = 3;
    [self.navigationController pushViewController:cdVC animated:YES];
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
