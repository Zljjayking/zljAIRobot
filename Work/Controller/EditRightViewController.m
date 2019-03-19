//
//  EditRightViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditRightViewController.h"
#import "NameTableViewCell.h"
#import "FunctionTableViewCell.h"
#import "FunctionNameOneTableViewCell.h"
#import "FunctionNameTwoTableViewCell.h"
#import "AvilableTableViewCell.h"
#import "RemoveTableViewCell.h"
#import "FunModel.h"
#import "powerUserModel.h"
#import "avilableBtn.h"
#import "LoginPeopleModel.h"
#import "ChoosePeopleViewController.h"
#import "ContactModel.h"
#import "chooseViewController.h"
#import "ContactDetailsViewController.h"
@interface EditRightViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JKAlertViewDelegate>
{
    LoginPeopleModel *loginModel;
}
//@property (nonatomic, strong) AppDelegate *MyDelegate;
//@property (nonatomic) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UITableView *rightEditTableView;
@property (nonatomic, strong) NSDictionary *rightDetails;
@property (nonatomic,strong) NSMutableArray *powerUserArr;//可用人员
@property (nonatomic, strong) NSMutableArray *funListArr;//权限列表数据
@property (nonatomic, strong) NSMutableArray *productsArr;//产品数据
@property (nonatomic, strong) NSMutableArray *taskArr;//任务数据
@property (nonatomic, strong) NSMutableArray *DianXiaoArr;//电销数据
@property (nonatomic, strong) NSMutableArray *rightArr;//权限数据
@property (nonatomic, strong) NSMutableArray *CRMArr;//CRM数据
@property (nonatomic, strong) NSMutableArray *orderArr;//订单数据
@property (nonatomic, strong) NSMutableArray *GongGaoArr;//公告数据
@property (nonatomic, strong) NSMutableArray *UpgradeArr;//提升等级
@property (nonatomic, strong) NSMutableArray *DepartmentMgrArr;//部门管理
@property (nonatomic, strong) NSMutableArray *ExecutiveArr;//执行力
@property (nonatomic, strong) NSMutableArray *FriendCopMgrArr;//好友机构管理
@property (nonatomic, strong) NSMutableArray *AttendanceMgrArr;//考勤管理
@property (nonatomic, strong) NSMutableArray *EMArr;//员工管理
@property (nonatomic, strong) NSMutableArray *FMArr;//财务管理


@property (nonatomic, strong) NSMutableArray *DaGouCount;//多有打勾的数据
@property (nonatomic, strong) NSMutableArray *totalModel;//所有显示在界面上的数据
@property (nonatomic, strong) NSMutableArray *avilableNameArr;//可用人员名字
@property (nonatomic, strong) NSMutableArray *avilableIconArr;//可用人员头像
@property (nonatomic, strong) NSMutableArray *oldAvilableArr;//存储旧的可用人员
@property (nonatomic, strong) NSMutableArray *avilablePersonNameArr;
@property (nonatomic, strong) NSMutableArray *avilablePersonImageArr;
@property (nonatomic, strong) NSMutableArray *deletePersonArr;//此页面删除的人员
@property (nonatomic, strong) NSMutableArray *addPersonArr;//已经添加的人员
@property (nonatomic, strong) NSMutableArray *allPeopleArr;
@property (nonatomic, strong) NSMutableArray *allSuper;

@end

@implementation EditRightViewController
static long int productCount;//产品数据的数量
static long int taskCount;//任务数据的数量
static long int DianXiaoCount;//电销数据的数量
static long int rightCount;//权限数据的数量
static long int CRMCount;//CRM数据的数量
static long int orderCount;//订单数据的数量
static long int gonggaoCount;//公告数据的数量
static long int upGradeCount;//提升等级数量
static long int DepartmentMgrCount;//部门管理数量
static long int ExecutiveCount;//执行力数量
static long int FriendCopMgrCount;//好友机构管理数量
static long int AttendanceMgrCount;//考勤管理数量
static long int EMCount;//员工管理数量
static long int FMCount;//财务管理数量

static long int SuperBtnTag = 1;//父权限cell的打勾按钮的tag
static long int ProductBtnTag = 1;//子权限cell的打勾按钮的tag
static long int TaskBtnTag = 1;//子权限cell的打勾按钮的tag
static long int DianXiaoBtnTag = 1;//子权限cell的打勾按钮的tag
static long int RightBtnTag = 1;//子权限cell的打勾按钮的tag
static long int CRMBtnTag = 1;//子权限cell的打勾按钮的tag
static long int OrderBtnTag = 1;//子权限cell的打勾按钮的tag
static long int GongGaoBtnTag = 1;//子权限cell的打勾按钮的tag
static long int UpGradeBtnTag = 1;//子权限cell的打勾按钮的tag
static long int DepartmentBtnTag = 1;//子权限cell的打勾按钮的tag
static long int ExecutiveBtnTag = 1;//子权限cell的打勾按钮的tag
static long int FriendCopMgrTag = 1;//子权限cell的打勾按钮的tag
static long int AttendanceMgrTag = 1;
static long int EMTag = 1;
static long int FMTag = 1;
static NSString *FunIdStr = @"";//用于拼funId
static NSString *peopleStr = @"";//用于拼可用人员Id
- (UITableView *)rightEditTableView {
    if (!_rightEditTableView) {
        _rightEditTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight)];
        _rightEditTableView.backgroundColor = VIEW_BASE_COLOR;
    }
    return _rightEditTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    SuperBtnTag = 1;
    ProductBtnTag = 1;
    TaskBtnTag = 1;
    DianXiaoBtnTag = 1;
    RightBtnTag = 1;
    CRMBtnTag = 1;
    OrderBtnTag = 1;
    GongGaoBtnTag = 1;
    UpGradeBtnTag = 1;
    DepartmentBtnTag = 1;
    ExecutiveBtnTag = 1;
    FriendCopMgrCount = 1;
    AttendanceMgrCount = 1;
    EMCount = 1;
    FMCount = 1;
    FunIdStr = @"";
    peopleStr = @"";
    
    if (self.powerUserArr.count != 0) {
        [self.avilableIconArr removeAllObjects];
        [self.avilableNameArr removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            for (int i=0; i<self.powerUserArr.count; i++) {
                ContactModel *model = self.powerUserArr[i];
                
                if ([model.iconUrl isEqualToString:@""]) {
                    model.iconUrl = @"";
                    [self.avilableIconArr addObject:model.iconUrl];
                } else if (model.iconUrl == nil) {
                    model.iconUrl = @"";
                    [self.avilableIconArr addObject:model.iconUrl];
                } else {
                    [self.avilableIconArr addObject:model.iconUrl];
                }
                [self.avilableNameArr addObject:model.realName];
                if (i == 0) {
                    peopleStr = [NSString stringWithFormat:@"%ld",model.userId];
                } else {
                    peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,model.userId];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
            });
        });
    } else {
        [self.avilableIconArr removeAllObjects];
        [self.avilableNameArr removeAllObjects];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    NSLog(@"self.powerID==%@",self.powerId);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //各个枚举初始化为0
    self.selectStatus = 0;
    self.isProductAdd = 0;
    self.isTaskAdd = 0;
    self.isDianXiaoAdd = 0;
    self.isRightAdd = 0;
    self.isCRMAdd = 0;
    self.isOrderAdd = 0;
    self.isGongGaoAdd = 0;
    self.isUpGradeAdd = 0;
    self.isDepartmentAdd = 0;
    self.isExecutiveAdd = 0;
    self.isFriendMgrAdd = 0;
    self.isAttendanceAdd = 0;
    self.isEMAdd = 0;
    self.isFMAdd = 0;
    self.DaGouCount = [NSMutableArray array];
    self.avilableIconArr = [NSMutableArray array];
    self.avilableNameArr = [NSMutableArray array];
    self.oldAvilableArr = [NSMutableArray array];
    self.deletePersonArr = [NSMutableArray array];
    self.addPersonArr = [NSMutableArray array];
    self.navigationItem.title = @"编辑权限";
    self.view.backgroundColor = VIEW_BASE_COLOR;

    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOk)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView {
    
    self.rightEditTableView.delegate = self;
    self.rightEditTableView.dataSource = self;
    self.rightEditTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rightEditTableView registerClass:[NameTableViewCell class] forCellReuseIdentifier:@"name"];
    [self.rightEditTableView registerClass:[FunctionTableViewCell class] forCellReuseIdentifier:@"Function"];
    [self.rightEditTableView registerClass:[FunctionNameOneTableViewCell class] forCellReuseIdentifier:@"FunctionNameOne"];
    [self.rightEditTableView registerClass:[FunctionNameTwoTableViewCell class] forCellReuseIdentifier:@"FunctionNameTwo"];
    [self.rightEditTableView registerClass:[AvilableTableViewCell class] forCellReuseIdentifier:@"Avilable"];
    if (self.seType == 1) {
        [self requestAddRight];
    } else {
        [self.rightEditTableView registerClass:[RemoveTableViewCell class] forCellReuseIdentifier:@"Remove"];
        [self requestRightDetails];
    }
    [self.view addSubview:self.rightEditTableView];
    
}
- (void)requestAddRight {
    self.selectType = 0;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    NSLog(@"%ld",loginModel.userId);
    NSDictionary *parameters = @{@"inter":@"getfun",@"userId":[NSString stringWithFormat:@"%ld",loginModel.userId]};
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        self.rightDetails = [NSDictionary changeType:data];
        NSLog(@"powerInfo == %@",self.rightDetails);
        NSArray *powerUser = [NSArray array];
        powerUser = self.rightDetails[@"powerUser"];
        NSArray *funList = [NSArray array];
        funList = self.rightDetails[@"funList"];
        self.powerUserArr = [NSMutableArray array];
        self.funListArr = [NSMutableArray array];
        self.productsArr = [NSMutableArray array];
        self.taskArr = [NSMutableArray array];
        self.DianXiaoArr = [NSMutableArray array];
        self.rightArr = [NSMutableArray array];
        self.CRMArr = [NSMutableArray array];
        self.orderArr = [NSMutableArray array];
        self.GongGaoArr = [NSMutableArray array];
        self.UpgradeArr = [NSMutableArray array];
        self.DepartmentMgrArr = [NSMutableArray array];
        self.ExecutiveArr = [NSMutableArray array];
        self.FriendCopMgrArr = [NSMutableArray array];
        self.AttendanceMgrArr = [NSMutableArray array];
        self.EMArr = [NSMutableArray array];
        self.FMArr = [NSMutableArray array];
        
        self.totalModel = [NSMutableArray array];
        self.allPeopleArr = [NSMutableArray array];
        self.allSuper = [NSMutableArray array];
        //获取可用人员数据
        for (int i = 0; i < powerUser.count; i++) {
            NSDictionary *dic = powerUser[i];
            NSLog(@"dic == %@",dic);
            ContactModel *powerUser = [ContactModel requestWithDic:dic];
            
            //                powerUser.iconUrl = dic[@"icon"];
            //                powerUser.userId = [dic[@"id"] integerValue];
            //                powerUser.realName = dic[@"real_name"];
            if (i == 0) {
                peopleStr = [NSString stringWithFormat:@"%ld",powerUser.userId];
            } else {
                peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,powerUser.userId];
            }
            [self.powerUserArr addObject:powerUser];
            NSString *name = powerUser.realName;
            //                if ([name isEqualToString:@""]) {
            //                    name = @"测试";
            //                }
            [self.avilableNameArr addObject:name];
            NSString *icon = powerUser.iconUrl;
            
            [self.avilableIconArr addObject:icon];
            
        }
        //获取父权限和子权限的数据
        for (int i = 0; i<funList.count; i++)
        {
            //循环读取数据
            NSDictionary *dic = funList[i];
            FunModel *Model = [FunModel new];
            Model.flag = @"0";
            Model.funId = [NSString stringWithFormat:@"%@",dic[@"funId"]];
            Model.funName = [NSString stringWithFormat:@"%@",dic[@"funName"]];
            Model.superiorId = [NSString stringWithFormat:@"%@",dic[@"superiorId"]];
            if ([Model.superiorId isEqualToString:@"0"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.isAdd = NO;
//                Model.tag = SuperBtnTag;
//                SuperBtnTag = SuperBtnTag+1;
                NSString *funId = [NSString stringWithFormat:@"%@",Model.funId];
                [self.allSuper addObject:funId];
                [self.funListArr addObject:Model];
                [self.totalModel addObject:Model];
//                if (i == 0) {
//                    [self.allSuper addObject:funId];
//                    [self.funListArr addObject:Model];
//                    [self.totalModel addObject:Model];
//                } else {
//                    for (int j=0; j<self.funListArr.count; j++) {
//                        FunModel *model = self.funListArr[j];
//                        if ([Model.funId integerValue] < [model.funId integerValue]) {
//                            [self.allSuper insertObject:funId atIndex:j];
//                            [self.funListArr insertObject:Model atIndex:j];
//                            [self.totalModel insertObject:Model atIndex:j];
//                        } else {
//                            [self.allSuper addObject:funId];
//                            [self.funListArr addObject:Model];
//                            [self.totalModel addObject:Model];
//                        }
//                    }
//                }
                
            }
            if ([Model.superiorId isEqualToString:@"1"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = ProductBtnTag;
                ProductBtnTag = ProductBtnTag+1;
                [self.productsArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"2"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = TaskBtnTag;
                TaskBtnTag = TaskBtnTag+1;
                [self.taskArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"3"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = DianXiaoBtnTag;
                DianXiaoBtnTag = DianXiaoBtnTag+1;
                [self.DianXiaoArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"4"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = RightBtnTag;
                RightBtnTag = RightBtnTag+1;
                [self.rightArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"5"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = CRMBtnTag;
                CRMBtnTag = CRMBtnTag+1;
                [self.CRMArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"6"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = OrderBtnTag;
                OrderBtnTag = OrderBtnTag+1;
                [self.orderArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"12"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = GongGaoBtnTag;
                GongGaoBtnTag = GongGaoBtnTag+1;
                [self.GongGaoArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"22"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = UpGradeBtnTag;
                UpGradeBtnTag = UpGradeBtnTag +1;
                [self.UpgradeArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"25"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = DepartmentBtnTag;
                DepartmentBtnTag = DepartmentBtnTag +1;
                [self.DepartmentMgrArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"28"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = ExecutiveBtnTag;
                ExecutiveBtnTag = ExecutiveBtnTag +1;
                [self.ExecutiveArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"32"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = FriendCopMgrTag;
                FriendCopMgrTag = FriendCopMgrTag +1;
                [self.FriendCopMgrArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"35"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = AttendanceMgrTag;
                AttendanceMgrTag = AttendanceMgrTag +1;
                [self.AttendanceMgrArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"37"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = EMTag;
                EMTag = EMTag +1;
                [self.EMArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"38"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = FMTag;
                FMTag = FMTag +1;
                [self.FMArr addObject:Model];
            }
            
        }
        NSString *k;
        FunModel *model = [FunModel new];
        FunModel *model1 = [FunModel new];
        for (int i=0; i<self.allSuper.count; i++) {
            for (int j=0; j<self.allSuper.count-1-i; j++) {
                if ([self.allSuper[j] integerValue] > [self.allSuper[j+1] integerValue]) {
                    k = self.allSuper[j];
                    model = self.funListArr[j];
                    model1 = self.totalModel[j];
                    
                    self.allSuper[j] = self.allSuper[j+1];
                    self.allSuper[j+1] = k;
                    
                    self.funListArr[j] = self.funListArr[j+1];
                    self.funListArr[j+1] = model;
                    
                    self.totalModel[j] = self.totalModel[j+1];
                    self.totalModel[j+1] = model1;
                }
            }
        }
        for (int i=0; i<self.funListArr.count; i++) {
            FunModel *Model = self.funListArr[i];
            Model.tag = SuperBtnTag;
            FunModel *Model1 = self.totalModel[i];
            Model1.tag = SuperBtnTag;
            SuperBtnTag = SuperBtnTag+1;
        }
        NSLog(@"self.allSuper == %@",self.allSuper);
        /*
         for(i=0;i<9;i++)
         
         for(j=0;j<10-i;j++)
         
         if(a[j]>a[j+1])
         
         {
         
         k=a[j];
         
         a[j]=a[j+1];
         
         a[j+1]=k;
         
         }
         */
        
        /*self.funListArr = [NSMutableArray array];
        self.productsArr = [NSMutableArray array];
        self.taskArr = [NSMutableArray array];
        self.DianXiaoArr = [NSMutableArray array];
        self.rightArr = [NSMutableArray array];
        self.CRMArr = [NSMutableArray array];
        self.orderArr = [NSMutableArray array];
        self.GongGaoArr = [NSMutableArray array];
        self.UpgradeArr = [NSMutableArray array];
        self.DepartmentMgrArr = [NSMutableArray array];*/
        if ([self.allSuper containsObject:@"1"]) {
            [self.allPeopleArr addObject:self.productsArr];
        }
        if ([self.allSuper containsObject:@"2"]) {
            [self.allPeopleArr addObject:self.taskArr];
        }
        if ([self.allSuper containsObject:@"3"]) {
            [self.allPeopleArr addObject:self.DianXiaoArr];
        }
        if ([self.allSuper containsObject:@"4"]) {
            [self.allPeopleArr addObject:self.rightArr];
        }
        if ([self.allSuper containsObject:@"5"]) {
            [self.allPeopleArr addObject:self.CRMArr];
        }
        if ([self.allSuper containsObject:@"6"]) {
            [self.allPeopleArr addObject:self.orderArr];
        }
        if ([self.allSuper containsObject:@"12"]) {
            [self.allPeopleArr addObject:self.GongGaoArr];
        }
        if ([self.allSuper containsObject:@"22"]) {
            [self.allPeopleArr addObject:self.UpgradeArr];
        }
        if ([self.allSuper containsObject:@"25"]) {
            [self.allPeopleArr addObject:self.DepartmentMgrArr];
        }
        if ([self.allSuper containsObject:@"28"]) {
            [self.allPeopleArr addObject:self.ExecutiveArr];
        }
        if ([self.allSuper containsObject:@"32"]) {
            [self.allPeopleArr addObject:self.FriendCopMgrArr];
        }
        if ([self.allSuper containsObject:@"35"]) {
            [self.allPeopleArr addObject:self.AttendanceMgrArr];
        }
        if ([self.allSuper containsObject:@"37"]) {
            [self.allPeopleArr addObject:self.EMArr];
        }
        if ([self.allSuper containsObject:@"38"]) {
            [self.allPeopleArr addObject:self.FMArr];
        }
        [self.rightEditTableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
//        [MBProgressHUD hideHUD];
    }];

}
- (void)requestRightDetails {
    self.selectType = 0;
//    [MBProgressHUD showMessage:@"正在加载..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"inter":@"powerInfo",@"powerId":self.powerId};
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        self.rightDetails = [NSDictionary changeType:data];
        NSLog(@"powerInfo == %@",self.rightDetails);
        NSArray *powerUser = [NSArray array];
        powerUser = self.rightDetails[@"powerUser"];
        NSArray *funList = [NSArray array];
        funList = self.rightDetails[@"funList"];
        self.powerUserArr = [NSMutableArray array];
        self.funListArr = [NSMutableArray array];
        self.productsArr = [NSMutableArray array];
        self.taskArr = [NSMutableArray array];
        self.DianXiaoArr = [NSMutableArray array];
        self.rightArr = [NSMutableArray array];
        self.CRMArr = [NSMutableArray array];
        self.orderArr = [NSMutableArray array];
        self.GongGaoArr = [NSMutableArray array];
        self.UpgradeArr = [NSMutableArray array];
        self.DepartmentMgrArr = [NSMutableArray array];
        self.ExecutiveArr = [NSMutableArray array];
        self.FriendCopMgrArr = [NSMutableArray array];
        self.AttendanceMgrArr = [NSMutableArray array];
        self.EMArr = [NSMutableArray array];
        self.FMArr = [NSMutableArray array];
        
        self.totalModel = [NSMutableArray array];
        self.allPeopleArr = [NSMutableArray array];
        self.allSuper = [NSMutableArray array];
        //获取可用人员数据
        for (int i = 0; i < powerUser.count; i++) {
            NSDictionary *dic = powerUser[i];
            NSLog(@"dic == %@",dic);
            ContactModel *powerUser = [ContactModel requestWithDic:dic];
            if (i == 0) {
                peopleStr = [NSString stringWithFormat:@"%ld",powerUser.userId];
            } else {
                peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,powerUser.userId];
            }
            [self.powerUserArr addObject:powerUser];
            NSString *name = powerUser.realName;
            [self.avilableNameArr addObject:name];
            NSString *icon = powerUser.iconUrl;
            
            [self.avilableIconArr addObject:icon];
            
        }
        //获取父权限和子权限的数据
        for (int i = 0; i<funList.count; i++)
        {
            //循环读取数据
            NSDictionary *dic = funList[i];
            FunModel *Model = [FunModel new];
            Model.flag = [NSString stringWithFormat:@"%@",dic[@"flag"]];
            Model.funId = [NSString stringWithFormat:@"%@",dic[@"funId"]];
            Model.funName = [NSString stringWithFormat:@"%@",dic[@"funName"]];
            Model.superiorId = [NSString stringWithFormat:@"%@",dic[@"superiorId"]];
            if ([Model.superiorId isEqualToString:@"0"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.isAdd = NO;
//                Model.tag = SuperBtnTag;
//                SuperBtnTag = SuperBtnTag+1;
                NSString *funId = [NSString stringWithFormat:@"%@",Model.funId];
                [self.allSuper addObject:funId];
                [self.funListArr addObject:Model];
                [self.totalModel addObject:Model];
                
            }
            if ([Model.superiorId isEqualToString:@"1"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = ProductBtnTag;
                ProductBtnTag = ProductBtnTag+1;
                [self.productsArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"2"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = TaskBtnTag;
                TaskBtnTag = TaskBtnTag+1;
                [self.taskArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"3"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = DianXiaoBtnTag;
                DianXiaoBtnTag = DianXiaoBtnTag+1;
                [self.DianXiaoArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"4"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = RightBtnTag;
                RightBtnTag = RightBtnTag+1;
                [self.rightArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"5"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = CRMBtnTag;
                CRMBtnTag = CRMBtnTag+1;
                [self.CRMArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"6"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = OrderBtnTag;
                OrderBtnTag = OrderBtnTag+1;
                [self.orderArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"12"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = GongGaoBtnTag;
                GongGaoBtnTag = GongGaoBtnTag+1;
                [self.GongGaoArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"22"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = UpGradeBtnTag;
                UpGradeBtnTag = UpGradeBtnTag+1;
                [self.UpgradeArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"25"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = DepartmentBtnTag;
                DepartmentBtnTag = DepartmentBtnTag+1;
                [self.DepartmentMgrArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"28"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = ExecutiveBtnTag;
                ExecutiveBtnTag = ExecutiveBtnTag+1;
                [self.ExecutiveArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"32"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = FriendCopMgrTag;
                FriendCopMgrTag = FriendCopMgrTag+1;
                [self.FriendCopMgrArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"35"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = AttendanceMgrTag;
                AttendanceMgrTag = AttendanceMgrTag+1;
                [self.AttendanceMgrArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"37"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = EMTag;
                EMTag = EMTag+1;
                [self.EMArr addObject:Model];
            }
            if ([Model.superiorId isEqualToString:@"38"]) {
                if ([Model.flag isEqualToString:@"1"]) {
                    [self.DaGouCount addObject:Model];
                }
                Model.tag = FMTag;
                FMTag = FMTag+1;
                [self.FMArr addObject:Model];
            }
        }
        
        NSString *k;
        FunModel *model = [FunModel new];
        FunModel *model1 = [FunModel new];
        for (int i=0; i<self.allSuper.count; i++) {
            for (int j=0; j<self.allSuper.count-1-i; j++) {
                if ([self.allSuper[j] integerValue] > [self.allSuper[j+1] integerValue]) {
                    k = self.allSuper[j];
                    model = self.funListArr[j];
                    model1 = self.totalModel[j];
                    
                    self.allSuper[j] = self.allSuper[j+1];
                    self.allSuper[j+1] = k;
                    
                    self.funListArr[j] = self.funListArr[j+1];
                    self.funListArr[j+1] = model;
                    
                    self.totalModel[j] = self.totalModel[j+1];
                    self.totalModel[j+1] = model1;
                }
            }
        }
        for (int i=0; i<self.funListArr.count; i++) {
            FunModel *Model = self.funListArr[i];
            Model.tag = SuperBtnTag;
            FunModel *Model1 = self.totalModel[i];
            Model1.tag = SuperBtnTag;
            SuperBtnTag = SuperBtnTag+1;
        }

        
        if ([self.allSuper containsObject:@"1"]) {
            [self.allPeopleArr addObject:self.productsArr];
        }
        if ([self.allSuper containsObject:@"2"]) {
            [self.allPeopleArr addObject:self.taskArr];
        }
        if ([self.allSuper containsObject:@"3"]) {
            [self.allPeopleArr addObject:self.DianXiaoArr];
        }
        if ([self.allSuper containsObject:@"4"]) {
            [self.allPeopleArr addObject:self.rightArr];
        }
        if ([self.allSuper containsObject:@"5"]) {
            [self.allPeopleArr addObject:self.CRMArr];
        }
        if ([self.allSuper containsObject:@"6"]) {
            [self.allPeopleArr addObject:self.orderArr];
        }
        if ([self.allSuper containsObject:@"12"]) {
            [self.allPeopleArr addObject:self.GongGaoArr];
        }
        if ([self.allSuper containsObject:@"22"]) {
            [self.allPeopleArr addObject:self.UpgradeArr];
        }
        if ([self.allSuper containsObject:@"25"]) {
            [self.allPeopleArr addObject:self.DepartmentMgrArr];
        }
        if ([self.allSuper containsObject:@"28"]) {
            [self.allPeopleArr addObject:self.ExecutiveArr];
        }
        if ([self.allSuper containsObject:@"32"]) {
            [self.allPeopleArr addObject:self.FriendCopMgrArr];
        }
        if ([self.allSuper containsObject:@"35"]) {
            [self.allPeopleArr addObject:self.AttendanceMgrArr];
        }
        if ([self.allSuper containsObject:@"37"]) {
            [self.allPeopleArr addObject:self.EMArr];
        }
        if ([self.allSuper containsObject:@"38"]) {
            [self.allPeopleArr addObject:self.FMArr];
        }
        [self.rightEditTableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
//        [MBProgressHUD hideHUD];
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        if (self.totalModel.count != 0) {
            return self.totalModel.count+1;
        }else {
            return 1;
        }
        
    }else if (section == 2) {
        if (self.seType == 1) {
            return 1;
        } else {
            return 2;
        }
        
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    view.backgroundColor = VIEW_BASE_COLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 30)];
    [view addSubview:label];
    label.textColor = [UIColor lightGrayColor];
    if (section == 0) {
        label.text = @"权限名称";
    } else if (section == 1) {
        label.text = @"权限功能";
    } else {
        label.text = @"可用人员";
    }
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2){
        if (indexPath.row == 1) {
            return 60;
        } else {
            /**
             return ((kScreenWidth-12)/6.0+15) * ((self.avilableNameArr.count+1)/6+1)+15;
             */
            
            return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count+1)/5+1)+10;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
        if (!cell) {
            cell = [[NameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
        }
        cell.nameTF.delegate = self;
        cell.nameTF.placeholder = @"输入权限组名称";
        cell.nameTF.text = self.rightName;
        [cell.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            FunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Function" forIndexPath:indexPath];
            if (!cell) {
                cell = [[FunctionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Function"];
            }
            //是否全选
            if (self.selectStatus == SelectStatusNone) {
                cell.DaGou.image = [UIImage imageNamed:@"checkbox_normal"];
            } else if (self.selectStatus == SelectStatusAll) {
                cell.DaGou.image = [UIImage imageNamed:@"checkbox_pressed"];
            }
            return cell;
        } else {
            if (self.totalModel.count != 0) {
                
                FunModel *model = self.totalModel[indexPath.row - 1];
                if ([model.superiorId isEqualToString:@"0"]) {
                    
                    FunctionNameOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FunctionNameOne" forIndexPath:indexPath];
                    
                    if (!cell) {
                        cell = [[FunctionNameOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FunctionNameOne"];
                    }
                    cell.index = model.tag - 1;
                    cell.nameLB.text = model.funName;
                    cell.DaGou.tag = model.tag;
                    cell.isAdd = model.isAdd;
                    if (cell.isAdd) {
                        cell.arrow.image = [UIImage imageNamed:@"箭头（上）"];
                    } else {
                        cell.arrow.image = [UIImage imageNamed:@"箭头（下）"];
                    }
                    
                    cell.DaGou.selected = [model.flag integerValue];
                    [cell.DaGou addTarget:self action:@selector(ClickGou:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
                    [cell.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
                    
                    return cell;
                } else  {
                    FunctionNameTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FunctionNameTwo" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[FunctionNameTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FunctionNameTwo"];
                    }
                    cell.nameLB.text = model.funName;
                    cell.DaGou.tag = model.tag + 100*[model.superiorId integerValue];
                    cell.DaGou.selected = [model.flag integerValue];
                    [cell.DaGou addTarget:self action:@selector(ClickGou:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
                    [cell.DaGou setBackgroundImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
                    return cell;
                    
                }
                
            }
        }
        
    } else if (indexPath.section == 2) {
        if (self.seType == 1) {
            if (indexPath.row == 0) {
                AvilableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Avilable" forIndexPath:indexPath];
                if (!cell ) {
                    cell = [[AvilableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Avilable"];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                self.avilablePersonNameArr = [NSMutableArray array];
                [self.avilablePersonNameArr addObject:@" "];
                [self.avilablePersonNameArr insertObjects:self.avilableNameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonNameArr.count-1, self.avilableNameArr.count)]];
                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObject:@"增加群聊（大加）"];
                [self.avilablePersonImageArr insertObjects:self.avilableIconArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonImageArr.count-1, self.avilableIconArr.count)]];
                
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
                for (int i = 0; i < self.avilablePersonImageArr.count; i++) {
                    
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+2000;
                    
                    [cell addSubview:btn];
                    
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (55*KAdaptiveRateWidth+10)+10);
                        make.left.equalTo(cell.mas_left).offset(i%5 * (55*KAdaptiveRateWidth + 7.5*KAdaptiveRateWidth)+7.5*KAdaptiveRateWidth);
                        make.width.mas_equalTo(55*KAdaptiveRateWidth);
                        make.height.mas_equalTo(55*KAdaptiveRateWidth);
                    }];
                    
                    UIImageView *imageV = [[UIImageView alloc]init];
                    [btn addSubview:imageV];
                    
                    imageV.layer.masksToBounds = YES;
                    
                    imageV.layer.cornerRadius = 21*KAdaptiveRateWidth;
                    if (i == self.avilablePersonImageArr.count - 1) {
                        imageV.layer.cornerRadius = 1;
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(btn.mas_centerY);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    } else {
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    }
                    
                    if (i != self.avilablePersonImageArr.count - 1) {
                        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                        NSURL *imageURL = [NSURL URLWithString:imagePath];
                        [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            UILabel *label = [[UILabel alloc]init];
                            [btn addSubview:label];
                            label.textAlignment = NSTextAlignmentCenter;
                            label.font = [UIFont systemFontOfSize:12];
                            /**
                             [label mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.top.equalTo(imageV.mas_bottom).offset(5);
                             make.left.equalTo(btn.mas_left).offset(0);
                             make.right.equalTo(btn.mas_right).offset(0);
                             make.height.mas_equalTo(10);
                             }];
                             */
                            
                            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(btn.mas_bottom);
                                make.left.equalTo(btn.mas_left).offset(0);
                                make.right.equalTo(btn.mas_right).offset(0);
                                make.height.mas_equalTo(12);
                            }];
                            label.text = self.avilablePersonNameArr[i];
                        }];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+1000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(btn.mas_centerX).offset(20*KAdaptiveRateWidth);
                            make.top.equalTo(btn.mas_top);
                            make.width.mas_equalTo(15*KAdaptiveRateWidth);
                            make.height.mas_equalTo(15*KAdaptiveRateWidth);
                        }];
                    } else {
                        imageV.layer.cornerRadius = 5;
                        imageV.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
                    }
                    
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            }
        } else {
            if (indexPath.row == 0) {
                AvilableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Avilable" forIndexPath:indexPath];
                if (!cell ) {
                    cell = [[AvilableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Avilable"];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                self.avilablePersonNameArr = [NSMutableArray array];
                [self.avilablePersonNameArr addObject:@" "];
                [self.avilablePersonNameArr insertObjects:self.avilableNameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonNameArr.count-1, self.avilableNameArr.count)]];
                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObject:@"增加群聊（大加）"];
                [self.avilablePersonImageArr insertObjects:self.avilableIconArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonImageArr.count-1, self.avilableIconArr.count)]];
                
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
                for (int i = 0; i < self.avilablePersonImageArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+2000;
                    
                    [cell addSubview:btn];
                    
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    /**
                     [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(cell.mas_top).offset(i/6 * 68+6);
                     make.left.equalTo(cell.mas_left).offset(i%6 * (kScreenWidth-12)/6.0 + 12);
                     make.width.mas_equalTo((kScreenWidth-12)/6.0-12);
                     make.height.mas_equalTo((kScreenWidth-12)/6.0);
                     }];
                     */
                    
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (55*KAdaptiveRateWidth+10)+10);
                        make.left.equalTo(cell.mas_left).offset(i%5 * (55*KAdaptiveRateWidth + 7.5*KAdaptiveRateWidth)+7.5*KAdaptiveRateWidth);
                        make.width.mas_equalTo(55*KAdaptiveRateWidth);
                        make.height.mas_equalTo(55*KAdaptiveRateWidth);
                    }];
                    
                    UIImageView *imageV = [[UIImageView alloc]init];
                    imageV.layer.masksToBounds = YES;
                    [imageV.layer setCornerRadius:5];
                    [btn addSubview:imageV];
                    /**
                     [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(btn.mas_top).offset(0);
                     make.left.equalTo(btn.mas_left).offset(((kScreenWidth-12)/6.0-52)/2.0);
                     make.right.equalTo(btn.mas_right).offset(-((kScreenWidth-12)/6.0-52)/2.0);
                     make.height.mas_equalTo(40);
                     }];
                     */
                    imageV.layer.masksToBounds = YES;
                    imageV.layer.cornerRadius = 21*KAdaptiveRateWidth;
                    if (i == self.avilablePersonImageArr.count - 1) {
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(btn.mas_centerY);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    } else {
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    }
                    if (i != self.avilablePersonImageArr.count - 1) {
                        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                        NSURL *imageURL = [NSURL URLWithString:imagePath];
                        [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            UILabel *label = [[UILabel alloc]init];
                            [btn addSubview:label];
                            label.textAlignment = NSTextAlignmentCenter;
                            label.font = [UIFont systemFontOfSize:12];
                            /**
                             [label mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.top.equalTo(imageV.mas_bottom).offset(5);
                             make.left.equalTo(btn.mas_left).offset(0);
                             make.right.equalTo(btn.mas_right).offset(0);
                             make.height.mas_equalTo(10);
                             }];
                             */
                            
                            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.bottom.equalTo(btn.mas_bottom);
                                make.left.equalTo(btn.mas_left).offset(0);
                                make.right.equalTo(btn.mas_right).offset(0);
                                make.height.mas_equalTo(12);
                            }];
                            label.text = self.avilablePersonNameArr[i];
                        }];
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+1000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        /**
                         [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.top.equalTo(btn.mas_top).offset(0);
                         make.right.equalTo(btn.mas_right).offset(0);
                         make.height.mas_equalTo(20);
                         make.width.mas_equalTo(20);
                         }];
                         */
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(btn.mas_centerX).offset(20*KAdaptiveRateWidth);
                            make.top.equalTo(btn.mas_top);
                            make.width.mas_equalTo(15*KAdaptiveRateWidth);
                            make.height.mas_equalTo(15*KAdaptiveRateWidth);
                        }];
                    } else {
                        imageV.layer.cornerRadius = 5;
                        imageV.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
                    }
                    if (i == self.avilablePersonImageArr.count - 1) {
                        
                    }
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            }else if (indexPath.row == 1) {
                RemoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Remove" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[RemoveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Remove"];
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.removeBtn setTitle:@"删除权限" forState:UIControlStateNormal];
                [cell.removeBtn addTarget:self action:@selector(removeRight:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
        }
    }
    return nil;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    self.rightName = textField.text;

}
- (void)BtnClick:(UIButton *)Btn {
    NSLog(@"self.addPersonArr.count == %ld",self.addPersonArr.count);
    NSLog(@"deletePersonArr == %ld",self.deletePersonArr.count);
    if (Btn.tag%2000 == self.avilableIconArr.count) {
        if (self.deletePersonArr.count > self.addPersonArr.count) {
            for (int i=0; i<self.deletePersonArr.count; i++) {
                ContactModel *mode1 = self.deletePersonArr[i];
                for (int j=0; j<self.addPersonArr.count; j++) {
                    ContactModel *model2 = self.addPersonArr[j];
                    if (model2.userId == mode1.userId) {
                        [self.deletePersonArr removeObject:mode1];
                        [self.addPersonArr removeObject:model2];
                        i=i-1;
                        j=j-1;
                    }
                }
            }
        } else if (self.deletePersonArr.count < self.addPersonArr.count) {
            for (int i=0; i<self.addPersonArr.count; i++) {
                ContactModel *mode1 = self.addPersonArr[i];
                for (int j=0; j<self.deletePersonArr.count; j++) {
                    ContactModel *model2 = self.deletePersonArr[j];
                    if (model2.userId == mode1.userId) {
                        [self.deletePersonArr removeObject:model2];
                        [self.addPersonArr removeObject:mode1];
                        i=i-1;
                        j=j-1;
                    }
                }
            }
        } else {
            for (int i=0; i<self.addPersonArr.count; i++) {
                ContactModel *mode1 = self.addPersonArr[i];
                for (int j=0; j<self.deletePersonArr.count; j++) {
                    ContactModel *model2 = self.deletePersonArr[j];
                    if (model2.userId == mode1.userId) {
                        [self.deletePersonArr removeObject:model2];
                        [self.addPersonArr removeObject:mode1];
                        i=i-1;
                        j=j-1;
                    }
                }
            }
        }
        NSLog(@"self.addPersonArr.count == %ld",self.addPersonArr.count);
        NSLog(@"deletePersonArr == %ld",self.deletePersonArr.count);
        chooseViewController *choosePeople = [chooseViewController new];
        choosePeople.seType = 2;
        choosePeople.limited = 1;
        choosePeople.deleteArr = self.deletePersonArr;
        choosePeople.addArr = self.addPersonArr;
        [choosePeople returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
            self.deletePersonArr = [NSMutableArray array];
            [self.powerUserArr addObjectsFromArray:returnAvilableMutableArray];
            for (int i=0; i<returnAvilableMutableArray.count; i++) {
                ContactModel *model = returnAvilableMutableArray[i];
                if (![self.addPersonArr containsObject:model]) {
                    NSLog(@"执行增加");
                    [self.addPersonArr addObject:model];
                }
            }
            
        }];
        [self.navigationController pushViewController:choosePeople animated:YES];
    } else {
        NSInteger index = Btn.tag%2000;
        ContactModel *model = self.powerUserArr[index];
        ContactDetailsViewController * cdVC = [[ContactDetailsViewController alloc]init];
        cdVC.uid = [NSString stringWithFormat:@"%ld", model.userId];
        cdVC.setype = 3;
        [self.navigationController pushViewController:cdVC animated:YES];
    }
    
}
- (void)deleteBtnClick:(UIButton *)Btn {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //获取可用人员数据
        NSLog(@"sup.tag == %ld",Btn.tag);
        ContactModel *powerUser = self.powerUserArr[Btn.tag%1000];
        [self.deletePersonArr addObject:powerUser];
        NSLog(@"powerUser.realName == %@",powerUser.realName);
        [self.powerUserArr removeObjectAtIndex:Btn.tag%1000];
        [self.avilableNameArr removeAllObjects];
        [self.avilableIconArr removeAllObjects];
        
        if (self.powerUserArr.count != 0) {
            for (int i = 0; i < self.powerUserArr.count; i++) {
                ContactModel *powerUser = self.powerUserArr[i];
                NSString *name = powerUser.realName;
                if (i == 0) {
                    peopleStr = [NSString stringWithFormat:@"%ld",powerUser.userId];
                } else {
                    peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,powerUser.userId];
                }
                
                [self.avilableNameArr addObject:name];
                NSString *icon = powerUser.iconUrl;
                
                [self.avilableIconArr addObject:icon];
            }
        } else {
            peopleStr = @"";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        });
        
    });

}
- (void)removeRight:(UIButton *)Btn {
    
    if (iOS8Later) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除权限" message:@"确定删除权限吗?删除后不可更改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *fangQi = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            NSDictionary *parameters = @{@"inter": @"deletepower",@"powerId":self.powerId};
            [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *data = [NSDictionary changeType:responseObject];
                NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                } else {
                    if (self.isRefreshRight != nil) {
                        NSString *str = @"1";
                        self.isRefreshRight(str);
                    }
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                NSLog(@"JSON: %@", data);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];

        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:fangQi];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"删除权限" message:@"确定删除权限吗?删除后不可更改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2;
        [alert show];
    }
}

- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1) {
        if (alertView.tag == 2) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            NSDictionary *parameters = [NSDictionary dictionaryWithObjects:@[@"deletepower",self.powerId] forKeys:@[@"inter",@"powerId"]];
            
//  @{@"inter": @"deletepower",@"powerId":self.powerId};//@[@"deletepower",self.powerId],@[@"inter",@"powerId"]
            [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *data = [NSDictionary changeType:responseObject];
                NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                } else {
                    if (self.isRefreshRight != nil) {
                        NSString *str = @"1";
                        self.isRefreshRight(str);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                }
                NSLog(@"JSON: %@", data);

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
        } else if (alertView.tag == 1) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            NSDictionary *parameters = @{@"inter": @"updatepower",@"powerId":self.powerId,@"powerName":self.rightNameTF.text,@"funs":[NSString stringWithFormat:@"%@",FunIdStr],@"people":[NSString stringWithFormat:@"%@",peopleStr]};
            [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *data = [NSDictionary changeType:responseObject];
                NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                } else {
                    if (self.isRefreshRight != nil) {
                        NSString *str = @"1";
                        self.isRefreshRight(str);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                }
                NSLog(@"JSON: %@", data);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
            

        }
        
    }
    
}

- (void)ClickGou:(UIButton *)Btn {
    NSLog(@"btn.tag == %ld",Btn.tag);
    
    Btn.selected = !Btn.selected;

    
    if (Btn.selected == NO) {

        
        self.selectStatus = 0;
        if (Btn.tag <= self.funListArr.count) {
            FunctionNameOneTableViewCell *cell = (FunctionNameOneTableViewCell *)Btn.superview;
            NSIndexPath *indexpath = [self.rightEditTableView indexPathForCell:cell];
            FunModel *Model = self.totalModel[indexpath.row-1];
            Model.flag = @"0";
            
            NSInteger index = cell.index;
            NSMutableArray *arr = [NSMutableArray array];
            arr = self.allPeopleArr[index];
            [self.DaGouCount removeObject:self.funListArr[index]];
            [self.DaGouCount removeObjectsInArray:arr];
            for (FunModel *Model in arr) {
                Model.flag = @"0";
            }
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

            
        } else {
            
            
            FunctionNameTwoTableViewCell *cell = (FunctionNameTwoTableViewCell *)Btn.superview;
            NSIndexPath *indexpath = [self.rightEditTableView indexPathForCell:cell];
            FunModel *Model = self.totalModel[indexpath.row-1];
            Model.flag = @"0";
            [self.DaGouCount removeObject:Model];

            NSLog(@"self.DaGouCount.count == %ld",self.DaGouCount.count);
        }
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//        [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

    } else {
        
        
//        NSLog(@"self.funListArr.count == %ld",self.funListArr.count);

        if (Btn.tag <= self.funListArr.count) {
            FunctionNameOneTableViewCell *cell = (FunctionNameOneTableViewCell *)Btn.superview;
            NSIndexPath *indexpath = [self.rightEditTableView indexPathForCell:cell];
            FunModel *Model = self.totalModel[indexpath.row-1];
            Model.flag = @"1";
            
            NSInteger index = cell.index;
            NSMutableArray *arr = [NSMutableArray array];
            arr = self.allPeopleArr[index];
            NSLog(@"arr.count == %ld",arr.count);
            [self.DaGouCount addObjectsFromArray:arr];
            [self.DaGouCount addObject:self.funListArr[index]];
            for (FunModel *Model in arr) {
                Model.flag = @"1";
            }
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

            
        } else {
            
            FunctionNameTwoTableViewCell *cell = (FunctionNameTwoTableViewCell *)Btn.superview;
            NSInteger index = cell.DaGou.tag;
//            NSMutableArray *arr = self.allPeopleArr[index/10];
//            long int DownTag = Btn.tag%10;
            NSIndexPath *indexpath = [self.rightEditTableView indexPathForCell:cell];
            FunModel *Model = self.totalModel[indexpath.row-1];
            Model.flag = @"1";
            [self.DaGouCount addObject:Model];
            for (int i=0; i<self.funListArr.count; i++) {
                FunModel *UPModel = self.funListArr[i];
                if (index/100 == [UPModel.funId integerValue]) {
                    if ([UPModel.flag isEqualToString:@"0"]) {
                        UPModel.flag = @"1";
                        [self.DaGouCount addObject:self.funListArr[i]];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }

//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
        if (self.DaGouCount.count == self.funListArr.count+self.productsArr.count+self.taskArr.count+self.DianXiaoArr.count+self.rightArr.count+self.CRMArr.count+self.orderArr.count+self.GongGaoArr.count+self.UpgradeArr.count+self.DepartmentMgrArr.count+self.ExecutiveArr.count+self.FriendCopMgrArr.count+self.AttendanceMgrArr.count+self.EMArr.count+self.FMArr.count) {
            self.selectStatus = 1;
            
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

        }
    }
    
    [self.rightEditTableView reloadData];
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//    
//    [self.rightEditTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

    NSLog(@"self.DaGouCount.count == %ld",self.DaGouCount.count);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            if (self.selectStatus == 0) {
                self.selectStatus = 1;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [self.DaGouCount removeAllObjects];
                    NSMutableArray *allArr = [NSMutableArray array];
                    [allArr addObjectsFromArray:self.funListArr];
                    [allArr addObjectsFromArray:self.productsArr];
                    [allArr addObjectsFromArray:self.taskArr];
                    [allArr addObjectsFromArray:self.DianXiaoArr];
                    [allArr addObjectsFromArray:self.rightArr];
                    [allArr addObjectsFromArray:self.CRMArr];
                    [allArr addObjectsFromArray:self.orderArr];
                    [allArr addObjectsFromArray:self.GongGaoArr];
                    [allArr addObjectsFromArray:self.UpgradeArr];
                    [allArr addObjectsFromArray:self.DepartmentMgrArr];
                    [allArr addObjectsFromArray:self.ExecutiveArr];
                    [allArr addObjectsFromArray:self.FriendCopMgrArr];
                    [allArr addObjectsFromArray:self.AttendanceMgrArr];
                    [allArr addObjectsFromArray:self.EMArr];
                    [allArr addObjectsFromArray:self.FMArr];
                    for (FunModel *Model in allArr) {
                        Model.flag = @"1";
                        [self.DaGouCount addObject:Model];
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"self.selectStatus = 1   self.DaGouCount.count == %ld",self.DaGouCount.count);
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    });
                });
                
            } else if (self.selectStatus == 1) {
                self.selectStatus = 0;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    NSMutableArray *allArr = [NSMutableArray array];
                    [allArr addObjectsFromArray:self.funListArr];
                    [allArr addObjectsFromArray:self.productsArr];
                    [allArr addObjectsFromArray:self.taskArr];
                    [allArr addObjectsFromArray:self.DianXiaoArr];
                    [allArr addObjectsFromArray:self.rightArr];
                    [allArr addObjectsFromArray:self.CRMArr];
                    [allArr addObjectsFromArray:self.orderArr];
                    [allArr addObjectsFromArray:self.GongGaoArr];
                    [allArr addObjectsFromArray:self.UpgradeArr];
                    [allArr addObjectsFromArray:self.DepartmentMgrArr];
                    [allArr addObjectsFromArray:self.ExecutiveArr];
                    [allArr addObjectsFromArray:self.FriendCopMgrArr];
                    [allArr addObjectsFromArray:self.AttendanceMgrArr];
                    [allArr addObjectsFromArray:self.EMArr];
                    [allArr addObjectsFromArray:self.FMArr];
                    for (FunModel *Model in allArr) {
                        Model.flag = @"0";
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.DaGouCount removeAllObjects];
                        NSLog(@"self.selectStatus = 0   self.DaGouCount.count == %ld",self.DaGouCount.count);
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    });
                });
                
            }
            
            
        } else {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([cell isMemberOfClass:[FunctionNameOneTableViewCell class]]) {
                FunctionNameOneTableViewCell *cell = (FunctionNameOneTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                NSString *cellTitle = [cell.nameLB.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                cellTitle = [cellTitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                cellTitle = [cellTitle stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSInteger index = cell.index;
                if ([cellTitle isEqualToString:@"任务管理"]) {
                    if (self.isTaskAdd) {
                        self.isTaskAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        taskCount = 0;
                        [self.totalModel removeObjectsInArray:self.taskArr];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        [tableView reloadData];
                        
                    } else {
                        self.isTaskAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        taskCount = self.taskArr.count;
                        
                        [self.totalModel insertObjects:self.taskArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.taskArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                } else if ([cellTitle isEqualToString:@"产品管理"]) {
                    
                    if (self.isProductAdd) {
                        self.isProductAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        productCount = 0;
                        [self.totalModel removeObjectsInArray:self.productsArr];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                    } else {
                        self.isProductAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        productCount = self.productsArr.count;
                        
                        [self.totalModel insertObjects:self.productsArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.productsArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                    }
                    
                } else if ([cellTitle isEqualToString:@"电销管理"]) {
                    
                    if (self.isDianXiaoAdd) {
                        self.isDianXiaoAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        DianXiaoCount = 0;
                        [self.totalModel removeObjectsInArray:self.DianXiaoArr];
                        [tableView reloadData];
                        
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isDianXiaoAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        DianXiaoCount = self.DianXiaoArr.count;
                        
                        [self.totalModel insertObjects:self.DianXiaoArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.DianXiaoArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                } else if ([cellTitle isEqualToString:@"权限管理"]) {
                    
                    if (self.isRightAdd) {
                        self.isRightAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        rightCount = 0;
                        [self.totalModel removeObjectsInArray:self.rightArr];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isRightAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        rightCount = self.rightArr.count;
                        
                        [self.totalModel insertObjects:self.rightArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.rightArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                } else if ([cellTitle isEqualToString:@"客户管理"]) {
                    
                    if (self.isCRMAdd) {
                        self.isCRMAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        CRMCount = 0;
                        [self.totalModel removeObjectsInArray:self.CRMArr];
                        
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isCRMAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        CRMCount = self.CRMArr.count;
                        
                        [self.totalModel insertObjects:self.CRMArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.CRMArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                } else if ([cellTitle isEqualToString:@"订单管理"]) {
                    
                    if (self.isOrderAdd) {
                        self.isOrderAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        orderCount = 0;
                        [self.totalModel removeObjectsInArray:self.orderArr];
                        [tableView reloadData];
                        
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isOrderAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        orderCount = self.orderArr.count;
                        
                        [self.totalModel insertObjects:self.orderArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.orderArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                }else if ([cellTitle isEqualToString:@"公告管理"]) {
                    
                    if (self.isGongGaoAdd) {
                        self.isGongGaoAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        gonggaoCount = 0;
                        [self.totalModel removeObjectsInArray:self.GongGaoArr];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isGongGaoAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        gonggaoCount = self.GongGaoArr.count;
                        
                        [self.totalModel insertObjects:self.GongGaoArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.GongGaoArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                }else if ([cellTitle isEqualToString:@"等级提升"]) {
                    
                    if (self.isUpGradeAdd) {
                        self.isUpGradeAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        upGradeCount = 0;
                        [self.totalModel removeObjectsInArray:self.UpgradeArr];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isUpGradeAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        upGradeCount = self.UpgradeArr.count;
                        
                        [self.totalModel insertObjects:self.UpgradeArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.UpgradeArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                }else if ([cellTitle isEqualToString:@"部门管理"]) {
                    
                    if (self.isDepartmentAdd) {
                        self.isDepartmentAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        DepartmentMgrCount = 0;
                        [self.totalModel removeObjectsInArray:self.DepartmentMgrArr];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isDepartmentAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        DepartmentMgrCount = self.DepartmentMgrArr.count;
                        
                        [self.totalModel insertObjects:self.DepartmentMgrArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.DepartmentMgrArr.count)]];
                        [tableView reloadData];
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                }else if ([cellTitle isEqualToString:@"执行力"]) {
                    
                    if (self.isExecutiveAdd) {
                        self.isExecutiveAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        ExecutiveCount = 0;
                        [self.totalModel removeObjectsInArray:self.ExecutiveArr];
                        [tableView reloadData];
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        //                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isExecutiveAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        ExecutiveCount = self.ExecutiveArr.count;
                        
                        [self.totalModel insertObjects:self.ExecutiveArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.ExecutiveArr.count)]];
                        [tableView reloadData];
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        //                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                }else if ([cellTitle isEqualToString:@"友好机构管理"]) {
                    
                    if (self.isFriendMgrAdd) {
                        self.isFriendMgrAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        FriendCopMgrCount = 0;
                        [self.totalModel removeObjectsInArray:self.FriendCopMgrArr];
                        [tableView reloadData];
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        //                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                        
                    } else {
                        self.isFriendMgrAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        FriendCopMgrCount = self.FriendCopMgrArr.count;
                        
                        [self.totalModel insertObjects:self.FriendCopMgrArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.FriendCopMgrArr.count)]];
                        [tableView reloadData];
                        //                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        //                        [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                        
                    }
                    
                }else if ([cellTitle isEqualToString:@"考勤管理"]) {
                    
                    if (self.isAttendanceAdd) {
                        self.isAttendanceAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        AttendanceMgrCount = 0;
                        [self.totalModel removeObjectsInArray:self.AttendanceMgrArr];
                        [tableView reloadData];
                        
                        
                    } else {
                        self.isAttendanceAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        AttendanceMgrCount = self.AttendanceMgrArr.count;
                        
                        [self.totalModel insertObjects:self.AttendanceMgrArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.AttendanceMgrArr.count)]];
                        [tableView reloadData];
                        
                    }
                }else if ([cellTitle isEqualToString:@"员工管理"]) {
                    
                    if (self.isEMAdd) {
                        self.isEMAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        EMCount = 0;
                        [self.totalModel removeObjectsInArray:self.EMArr];
                        [tableView reloadData];
                        
                        
                    } else {
                        self.isEMAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        EMCount = self.EMArr.count;
                        
                        [self.totalModel insertObjects:self.EMArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.EMArr.count)]];
                        [tableView reloadData];
                        
                    }
                }else if ([cellTitle isEqualToString:@"财务管理"]){
                    
                    if (self.isFMAdd) {
                        self.isFMAdd = 0;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = NO;
                        FMCount = 0;
                        [self.totalModel removeObjectsInArray:self.FMArr];
                        [tableView reloadData];
                        
                    } else {
                        self.isFMAdd = 1;
                        FunModel *Model = self.funListArr[index];
                        Model.isAdd = YES;
                        FMCount = self.FMArr.count;
                        
                        [self.totalModel insertObjects:self.FMArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, self.FMArr.count)]];
                        [tableView reloadData];
                        
                    }
                } else {
                    
                }
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)ClickOk {
    
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    for (int i=0; i<self.DaGouCount.count; i++) {
        FunModel *model = self.DaGouCount[i];
        if (i == 0 ) {
            FunIdStr = model.funId;
        } else if (i!=0) {
            FunIdStr = [NSString stringWithFormat:@"%@,%@",FunIdStr,model.funId];
        }
        
    }
    
    for (int i=0; i<self.powerUserArr.count ; i++) {
        ContactModel *model = self.powerUserArr[i];
        if (i == 0 ) {
            peopleStr = [NSString stringWithFormat:@"%ld",model.userId];
        } else if (i!=0) {
            peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,model.userId];
        }
    }
    
    NSString *funid = FunIdStr;
    NSString *peoplestr = peopleStr;
    
    if (self.rightName.length == 0) {
        [MBProgressHUD showError:@"权限名称不能为空"];
    }else if (peoplestr.length == 0){
        [MBProgressHUD showError:@"未选择可用人员"];
    }else if (funid.length == 0){
        [MBProgressHUD showError:@"未选择权限功能"];
    }else {
        
    if (iOS8Later) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑权限" message:@"确定修改?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *fangQi = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            if (self.seType == 1) {
                NSDictionary *parameters = @{@"inter": @"addpower",@"userId":[NSString stringWithFormat:@"%ld",loginModel.userId],@"powerName":[NSString stringWithFormat:@"%@",self.rightName],@"funs":[NSString stringWithFormat:@"%@",funid],@"people":[NSString stringWithFormat:@"%@",peoplestr]};
                [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *data = [NSDictionary changeType:responseObject];
                    NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                    if ([code isEqualToString:@"1"]) {
                        if (self.isRefreshRight != nil) {
                            NSString *str = @"1";
                            self.isRefreshRight(str);
                        }
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                    } else {
                        if (self.isRefreshRight != nil) {
                            NSString *str = @"1";
                            self.isRefreshRight(str);
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                    }
                    NSLog(@"JSON: %@", data);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                }];
                
            } else {
                NSDictionary *parameters = @{@"inter": @"updatepower",@"powerId":[NSString stringWithFormat:@"%@",self.powerId],@"powerName":[NSString stringWithFormat:@"%@",self.rightName],@"funs":[NSString stringWithFormat:@"%@",funid],@"people":[NSString stringWithFormat:@"%@",peoplestr]};
                [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *data = [NSDictionary changeType:responseObject];
                    NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                    if ([code isEqualToString:@"1"]) {
                        if (self.isRefreshRight != nil) {
                            NSString *str = @"1";
                            self.isRefreshRight(str);
                        }
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                    } else {
                        if (self.isRefreshRight != nil) {
                            NSString *str = @"1";
                            self.isRefreshRight(str);
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                        
                    }
                    NSLog(@"JSON: %@", data);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                }];
            }
//            NSDictionary *parameters = @{@"inter": @"updatepower",@"powerId":[NSString stringWithFormat:@"%@",self.powerId],@"powerName":[NSString stringWithFormat:@"%@",self.rightName],@"funs":[NSString stringWithFormat:@"%@",funid],@"people":[NSString stringWithFormat:@"%@",peoplestr]};
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:fangQi];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"编辑权限" message:@"确定修改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }
    }

}

//实现 方法
- (void)returnIsRefreshRight:(ReturnIsRefreshRightBlock)block {
    self.isRefreshRight = block;
}

//- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        
//    }else if (buttonIndex == 1) {
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSDictionary *parameters = @{@"inter": @"deletepower",@"powerId":self.powerId};
//        [manager POST:REQUEST_HOST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary *data = [NSDictionary changeType:responseObject];
//            NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
//            if ([code isEqualToString:@"1"]) {
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
//            } else {
//                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
//            }
//            NSLog(@"JSON: %@", data);
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
//        
//    }
//    
//}

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
