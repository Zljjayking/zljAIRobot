//
//  CRMDetailsViewController.m
//  Financeteam
//
//  Created by Zccf on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMDetailsViewController.h"
#import "CRMDetailsTableViewCell.h"
#import "CRMDetailsTwoTableViewCell.h"
#import "CRMDetailsThreeTableViewCell.h"
#import "ProductManageViewController.h"
#import "ChoosePeopleViewController.h"
#import "CRMSecondTableViewCell.h"
#import "CRMSubTableViewCell.h"
#import "TreeViewNode.h"
#import "superCellModel.h"
#import "subCellModel.h"
#import "RBCustomDatePickerView.h"

#import "FDAlertView.h"
#import "CRMDetailsModel.h"
#import "WorkBtn.h"
#import "productModel.h"
#import "ContactModel.h"
#import "reamrkModel.h"
#import "chooseViewController.h"
#import "cusrecordListModel.h"
#import "LatestTableViewCell.h"
#import "ContactDetailsViewController.h"
#import "alermViewController.h"
#import "alermModel.h"
#import "CRMPhotosViewController.h"
#import "IQKeyboardManager.h"
#import "YBPopupMenu.h"
#import "CRMSignView.h"
#import "CRMVoiceViewController.h"
@interface CRMDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SelectDateTimeDelegate,JKAlertViewDelegate,UITextViewDelegate,YBPopupMenuDelegate>{
    LoginPeopleModel *myModel;
    DateTimeSelectView *_dateTimeSelectView;
    UIButton *_btn1;
}

@property (nonatomic, strong) UIView *vv;


@property (nonatomic)UITableView *CRMDetailsTableView;
@property (nonatomic) NSMutableArray *productArr;
@property (nonatomic) NSMutableArray *crmInfoArr;
@property (nonatomic) NSMutableArray *cusrecordListArr;//最新动态
@property (nonatomic) NSMutableArray *remarkListArr;//备注列表
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
#pragma mark == 17年3月9号 新增section1
@property(strong,nonatomic) NSMutableArray* sectionOneDataArray; //保存section1全部数据的数组


@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组
#pragma mark == 17年3月9号 新增section1保存数据数组
@property(strong,nonatomic) NSArray *sectionOneDisplayArray;   //保存要显示在界面上的数据的数组

@property(nonatomic, strong) CRMDetailsModel *CRMModel;
@property (nonatomic,strong) UIView *stateView;
@property (nonatomic) WorkBtn *workBtn;
@property (nonatomic) UIView *bottomView;
@property (nonatomic) UIView *bottomViewOne;
@property (nonatomic) UIButton *stateBtn;

@property (nonatomic, strong) NSArray *returnIDArray;//从产品列表返回的产品ID数组
@property (nonatomic, strong) NSArray *returnNameArray;//从产品列表返回的产品Name数组
@property (nonatomic, strong) NSArray *returnPeople;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic) NSIndexPath *remarkIndexPath;//记录备注的indexPath
@property (nonatomic,assign) CGFloat remarkHeight;//记录备注的高度
@property (nonatomic,assign) CGFloat projectHeight;//记录融资方案的高度
//接口字段
@property (nonatomic) NSString *person_colleague_company;
@property (nonatomic) NSString *person_family_company;
@property (nonatomic) NSString *user_house_type;
@property (nonatomic) NSString *nowaddress;
@property (nonatomic) NSString *jrq_table_personal_info_id;
@property (nonatomic) NSString *asset_car_month;
@property (nonatomic) NSString *person_company_address;
@property (nonatomic) NSString *jrq_table_asset_info_id;
@property (nonatomic) NSString *cpfMoney;
@property (nonatomic) NSString *work_part;
@property (nonatomic) NSString *hkaddress;
@property (nonatomic) NSString *work_money;
@property (nonatomic) NSString *asset_house_price;
@property (nonatomic) NSString *work_money_type;
@property (nonatomic) NSString *person_other_ship;
@property (nonatomic) NSString *work_industry;
@property (nonatomic) NSString *special_company_number;
@property (nonatomic) NSString *issb;
@property (nonatomic) NSString *asset_house_pro_id;
@property (nonatomic) NSString *work_job;
@property (nonatomic) NSString *person_colleague_moblie;
@property (nonatomic) NSString *special_company_area;
@property (nonatomic) NSString *special_company_type;
@property (nonatomic) NSString *user_name;
@property (nonatomic) NSString *asset_house_year;
@property (nonatomic) NSString *special_company_date;
@property (nonatomic) NSString *asset_house_type;
@property (nonatomic) NSString *real_name;
@property (nonatomic) NSString *asset_house_area_id;
@property (nonatomic) NSString *asset_house_month;
@property (nonatomic) NSString *Id;
@property (nonatomic) NSString *jrq_table_special_info_id;
@property (nonatomic) NSString *work_name;
@property (nonatomic) NSString *person_family_ship;
@property (nonatomic) NSString *work_date;
@property (nonatomic) NSString *person_together;
@property (nonatomic) NSString *person_family_moblie;
@property (nonatomic) NSString *user_marry;
@property (nonatomic) NSString *person_mobile;
@property (nonatomic) NSString *user_id_number;
@property (nonatomic) NSString *asset_house_area;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *work_money_date;
@property (nonatomic) NSString *asset_house;
@property (nonatomic) NSString *isgrbx;
@property (nonatomic) NSString *person_other_name;
@property (nonatomic) NSString *purpose;
@property (nonatomic) NSString *work_tel;
@property (nonatomic) NSString *asset_car;
@property (nonatomic) NSString *user_education;
@property (nonatomic) NSString *jrq_table_work_info_id;
@property (nonatomic) NSString *person_id_card;
@property (nonatomic) NSString *special_company_type_other;
@property (nonatomic) NSString *user_id_type;
@property (nonatomic) NSString *person_dear;
@property (nonatomic) NSString *user_mobile;
@property (nonatomic) NSString *money;
@property (nonatomic) NSString *isbs;
@property (nonatomic) NSString *asset_house_city_id;
@property (nonatomic) NSString *work_address_pro_id;
@property (nonatomic) NSString *person_colleague_name;
@property (nonatomic) NSString *person_company_tel;
@property (nonatomic) NSString *user_tel;
@property (nonatomic) NSString *asset_car_date;
@property (nonatomic) NSString *person_other_company;
@property (nonatomic) NSString *asset_house_money;
@property (nonatomic) NSString *work_type;
@property (nonatomic) NSString *person_together_name;
@property (nonatomic) NSString *person_know;
@property (nonatomic) NSString *work_address_city_id;
//@property (nonatomic) NSString *adviserId;
@property (nonatomic) NSString *special_net_profit;
@property (nonatomic) NSString *user_child;
@property (nonatomic) NSString *asset_car_price;
@property (nonatomic) NSString *adviserPlan;
@property (nonatomic) NSString *user_house_money;
@property (nonatomic) NSString *work_address_area_id;
@property (nonatomic) NSString *asset_house_type_other;
@property (nonatomic) NSString *work_address;
@property (nonatomic) NSString *source;

@property (nonatomic) NSString *person_company_name;
@property (nonatomic) NSString *person_other_moblie;
@property (nonatomic) NSString *asset_house_property;
@property (nonatomic) NSString *iscpf;
@property (nonatomic) NSString *user_sex;
@property (nonatomic) NSString *person_address;
@property (nonatomic) NSString *person_colleague_work;
@property (nonatomic) NSString *person_family_name;
@property (nonatomic) NSString *asset_house_date;
@property (nonatomic) NSString *mechProId;
@property (nonatomic) NSString *remark;



#pragma mark == 新加公积金范围
@property (nonatomic) NSString *cpfRange;
#pragma mark == 新加房产总价范围
@property (nonatomic) NSString *asset_house_totalPrice;
#pragma mark == 新加房产总价
@property (nonatomic) NSString *asset_house_totalval;//asset_house_totalPrice为4时填写
#pragma mark == 新加房产月供范围
@property (nonatomic) NSString *asset_house_monRange;//asset_house_dateRange
#pragma mark == 新加购房日期范围
@property (nonatomic) NSString *asset_house_dateRange;

#pragma mark == 新加车辆总价范围
@property (nonatomic) NSString *asset_car_totalRange;
#pragma mark == 新加购车形式
@property (nonatomic) NSString *asset_car_type;//asset_house_totalPrice为4时填写
#pragma mark == 新加车辆月供范围
@property (nonatomic) NSString *asset_car_monRange;//asset_house_dateRange
#pragma mark == 新加购房日期范围
@property (nonatomic) NSString *asset_car_dateRange;
#pragma mark == 新加职业类型
@property (nonatomic) NSString *occ_type;
#pragma mark == 新增个人保险缴纳年限范围
@property (nonatomic) NSString *grbx_term_range;
#pragma mark == 新增个人保险缴纳金额
@property (nonatomic) NSString *grbx_sum;

@property (nonatomic) UILabel *signLabel;//备注提示用到的label
@property (nonatomic) UILabel *projectLabel;//融资方案提示用到的label

//提醒相关
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString *alerm;
@property (nonatomic, strong) alermModel *model;
@property (nonatomic, strong) NSMutableArray *alermArr;
@end

@implementation CRMDetailsViewController
static BOOL isAddMonthlyRepayments;
static BOOL isAddMonthlyRent;


static BOOL isAddAccumulationFund;
static BOOL isAddTogether;
static BOOL isEdit;

#pragma mark == 新加是否添加公积金范围
static BOOL isAddCpf;
#pragma mark == 新加是否添加职业性质
static BOOL isAddOccType;
#pragma mark == 新加是否添加私营业主是否缴税
static BOOL isAddPrivate;
#pragma mark == 新加是否添加个人保险年限
static BOOL isAddGRBXRange;
#pragma mark == 新加是否添加个人保险金额
static BOOL isAddGRBXMoney;
#pragma mark == 新加是否添加购房价格
static BOOL isAddHouseTotal;
#pragma mark == 新加是否添加购房月供
static BOOL isAddHouseMonth;
#pragma mark == 新加是否添加购车价格
static BOOL isAddCarTotal;
#pragma mark == 新加是否添加购车月供
static BOOL isAddCarMonth;

static BOOL isAddHouseInstallment;

static BOOL isAddCarInstallment;


static NSInteger personalInfoCount;
static NSInteger AssetInfoCount;
static NSInteger houseInfoCount;
static NSInteger carInfoCount;
static NSInteger workInfoCount;
//static NSInteger loansInfoCount;
static NSInteger matesInfoCount;
static NSInteger relativesInfoCount;
static NSInteger workmatesInfoCount;
static NSInteger otherContactsInfoCount;
static NSInteger contactsInfoCount;
static NSString *state;
static NSString *userName;
static NSString *userMobile;
static NSString *productName;
static NSString *houseTime;
static NSString *carTime;
static NSString *buildTime;
static NSString *workTime;
static NSString *ClickRowName;
static NSString *houseMoney;
static NSString *cpfMoney;
static NSString *headPeopleName = @"点击选取";
static NSString *headPeopleID;
static BOOL latest = 0;
- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _stateView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        NSArray *imageArr = [NSArray arrayWithObjects:@"公司",@"客户",@"已到访",@"邀约中",@"待处理",@"删除", nil];
        NSArray *titleArr = [NSArray arrayWithObjects:@"公司放弃",@"客户放弃",@"已到访",@"邀约中",@"待处理",@"删除", nil];
        UIView *vie = [[UIView alloc] initWithFrame:CGRectMake(10*KAdaptiveRateWidth, kScreenHeight-NaviHeight-160*KAdaptiveRateHeight, kScreenWidth-20*KAdaptiveRateWidth, 160*KAdaptiveRateHeight)];
        [vie.layer setCornerRadius:10];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        vie.center = _stateView.center;
        [_stateView addGestureRecognizer:tap];
        [_stateView addSubview:vie];
        vie.backgroundColor = [UIColor whiteColor];
        //循环创建出按钮
        for (int i = 0; i<imageArr.count; i++) {
            _workBtn = [[WorkBtn alloc]init];
            _workBtn.enabled = YES;
            [vie addSubview:_workBtn];
            _workBtn.tag = i+1+1000;
            [_workBtn addTarget:self action:@selector(clickState:) forControlEvents:UIControlEventTouchUpInside];
            if (i<=6) {
                _workBtn.Image.image = [UIImage imageNamed:imageArr[i]];
            }
            _workBtn.Label.text = titleArr[i];
            _workBtn.layer.masksToBounds = YES;
            [_workBtn.layer setCornerRadius:10];
            [_workBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(vie.mas_top).offset((i/3)*80*KAdaptiveRateHeight);
                make.left.equalTo(vie.mas_left).offset((i%3)*(kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                make.width.mas_equalTo((kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                make.height.mas_equalTo(80*KAdaptiveRateHeight);
            }];
            //竖着的分割线
            if (i % 3 == 1 || i%3 == 2) {
                UIView *HSeparetor = [[UIView alloc]init];
                [_workBtn addSubview:HSeparetor];
                HSeparetor.backgroundColor = kMyColor(240, 239, 245);
                [HSeparetor mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(vie.mas_top).offset((i/3)*80*KAdaptiveRateHeight);
                    make.left.equalTo(vie.mas_left).offset((i%3)*(kScreenWidth-20*KAdaptiveRateWidth)/3.0-0.5);
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(80*KAdaptiveRateHeight);
                }];
            }
            //横着的分割线
            if (i/3 == 1 || i/3 == 2 ) {
                UIView *VSeparetor = [[UIView alloc]init];
                [_workBtn addSubview:VSeparetor];
                VSeparetor.backgroundColor = kMyColor(240, 239, 245);
                [VSeparetor mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(vie.mas_top).offset((i/3)*80*KAdaptiveRateHeight - 0.5 );
                    make.left.equalTo(vie.mas_left).offset((i%3)*(kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                    make.width.mas_equalTo((kScreenWidth-20*KAdaptiveRateWidth)/3.0);
                    make.height.mas_equalTo(1);
                }];
            }
        }
    }
    return _stateView;
}
- (UIView *)bottomViewOne {
    if (!_bottomViewOne) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:230/255.0 green:229/255.0 blue:235/255.0 alpha:1.0];
        if (self.ishideNaviView) {
            view.frame = CGRectMake(0, kScreenHeight-NaviHeight-44, kScreenWidth, 44);
            if (IS_IPHONE_X) {
                view.frame = CGRectMake(0, kScreenHeight-NaviHeight-83, kScreenWidth, 83);
            }
        } else {
            view.frame = CGRectMake(0, kScreenHeight-44, kScreenWidth, 44);
            if (IS_IPHONE_X) {
                view.frame = CGRectMake(0, kScreenHeight-83, kScreenWidth, 83);
            }
        }
        _bottomViewOne = view;
        
        UIButton *picturesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        picturesBtn.frame = CGRectMake(0,0, kScreenWidth, 44);
        [view addSubview:picturesBtn];
        [picturesBtn addTarget:self action:@selector(picturesBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [picturesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [picturesBtn setTitle:@"编辑图片材料" forState:UIControlStateNormal];
        picturesBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _bottomViewOne;
}
- (void)clickState:(UIButton *)sender {
    if (sender.tag == 1006) {
        if (self.isDelCRM) {
            JKAlertView *removeAlert = [[JKAlertView alloc] initWithTitle:@"删除" message:@"确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            removeAlert.tag = 1006;
            [removeAlert show];
        } else {
            [MBProgressHUD showError:@"暂无此权限"];
        }
        
    } else {
        if(self.isChangeState) {
            JKAlertView *removeAlert = [[JKAlertView alloc] initWithTitle:@"更改状态" message:@"确定更改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            removeAlert.tag = sender.tag;
            NSLog(@"sender.tag == %ld",(long)sender.tag);
            [removeAlert show];
        } else {
            [MBProgressHUD showError:@"暂无此权限"];
        }
        
    }
    
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1006) {
        if (buttonIndex == 1) {
            [HttpRequestEngine removeCRMWithCustomerId:self.customerId completion:^(id obj, NSString *errorStr) {
                NSDictionary *data = obj;
                NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
                NSLog(@"%@",data);
                if ([code isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
                } else {
                    if (self.alermArr.count > 0) {
                        for (int i=0; i<self.alermArr.count; i++) {
                            alermModel *model = self.alermArr[i];
                            NSString *key = [NSString stringWithFormat:@"%@%@",self.customerId,model.time];
                            [LocalPushCenter cancleLocalPushWithKey:key];
                        }
                    }
                    if ([self.db open]) {
                        BOOL delete = [_db executeUpdate:@"delete from CRMAlerm where CRMID=?",self.customerId];
                        if (delete) {
                            NSLog(@"删除数据成功");
                        }else{
                            NSLog(@"删除数据失败");
                        }
                    }
                    [self.db close];
                    
                    if (self.isRefreshCRM != nil) {
                        NSString *str = @"1";
                        self.isRefreshCRM(str);
                    }
                    [self.stateView removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showSuccess:@"删除成功"];
                }
                if (data == nil) {
                    [MBProgressHUD showError:@"网络连接出错"];
                }
            }];
            
        }
    } else if (alertView.tag == 1007) {
        if (buttonIndex == 1) {
#pragma mark === 生成订单 需要添加userID
            [HttpRequestEngine CRMBuildUpToOrderWithCustomerID:self.customerId userId:[NSString stringWithFormat:@"%ld",myModel.userId] completion:^(id obj, NSString *errorStr) {
                NSDictionary *data = obj;
                NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
                NSLog(@"%@",data);
                if ([code isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
                } else {
                    if (self.isRefreshCRM != nil) {
                        NSString *str = @"1";
                        self.isRefreshCRM(str);
                    }
                    [self.stateView removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showSuccess:@"生成订单成功"];
                }
                if (data == nil) {
                    [MBProgressHUD showError:@"网络连接出错"];
                }
            }];
        }
    } else {
        NSInteger stateNum = alertView.tag%1000;
        NSLog(@"stateNum == %ld",stateNum);
        if (buttonIndex == 1) {
            if (stateNum == 1) {
                [self.stateBtn setTitle:@"公司放弃" forState:UIControlStateNormal];
                state = @"5";
            }
            if (stateNum == 2) {
                [self.stateBtn setTitle:@"客户放弃" forState:UIControlStateNormal];
                state = @"6";
            }
            if (stateNum == 3) {
                [self.stateBtn setTitle:@"已到访" forState:UIControlStateNormal];
                state = @"3";
                
            }
            if (stateNum == 4) {
                [self.stateBtn setTitle:@"邀约中" forState:UIControlStateNormal];
                state = @"2";
            }
            if (stateNum == 5) {
                [self.stateBtn setTitle:@"待处理" forState:UIControlStateNormal];
                state = @"1";
            }
            NSLog(@"self.uid == %@",self.uid);
            [HttpRequestEngine UpdataCRMStateWithCid:self.customerId uid:[NSString stringWithFormat:@"%ld",myModel.userId] state:[NSString stringWithFormat:@"%@",state] cpid:[NSString stringWithFormat:@"%@",self.uid] completion:^(id obj, NSString *errorStr) {
                NSDictionary *data = obj;
                NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
                NSLog(@"data==%@",data);
                if ([code isEqualToString:@"1"]) {
                    [self.stateView removeFromSuperview];
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
                } else if([code isEqualToString:@"0"]) {
                    if (self.returnStateBlock != nil) {
                        self.returnStateBlock(state);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.stateView removeFromSuperview];
                    [MBProgressHUD showSuccess:@"操作成功"];
                }
            }];
            
            
        }
    }
    
}
- (void)tap:(UITapGestureRecognizer *)gr {
    
    CGPoint p = [gr locationInView:gr.view];
    if (p.y<kScreenHeight/2.0 - 80*KAdaptiveRateHeight ||p.y>kScreenHeight/2.0 + 80*KAdaptiveRateHeight) {
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        [self.stateView removeFromSuperview];
    }
}
- (UITableView *)CRMDetailsTableView {
    if (!_CRMDetailsTableView) {
        _CRMDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-44) style:UITableViewStyleGrouped];
        if (IS_IPHONE_X) {
            _CRMDetailsTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-83);
        }
        if (self.ishideNaviView) {
            _CRMDetailsTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight-44);
            if (IS_IPHONE_X) {
                _CRMDetailsTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight-83);
            }
        }
        
    }
    return _CRMDetailsTableView;
}
- (void)viewDidAppear:(BOOL)animated {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    ClickRowName = @"";
    //    if (self.returnNameArray.count == 0) {
    //        productName = @"点击选取";
    //    }
    //    for (int i=0; i<self.returnNameArray.count ; i++) {
    //        //        powerUserModel *model = self.powerUserArr[i];
    //        if (i == 0 ) {
    //            productName = self.returnNameArray[0];
    //        } else if (i!=0) {
    //            productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
    //        }
    //        [self.CRMDetailsTableView reloadData];
    //    }
    [self aboutDateBase];
    
    
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
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
    
    
    self.CRMModel = [CRMDetailsModel new];
    latest = 0;
    myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    isAddMonthlyRepayments = 0;
    isAddMonthlyRent = 0;
    
    isAddCpf = 0;
    
    isAddHouseMonth = 0;
    isAddHouseTotal = 0;
    isAddCarMonth = 0;
    isAddCarTotal = 0;
    
    isAddOccType = 0;
    isAddPrivate = 0;
    isAddGRBXMoney = 0;
    isAddGRBXRange = 0;
    
    isAddHouseInstallment = 0;
    isAddCarInstallment = 0;
    
    isAddAccumulationFund = 0;
    isAddTogether = 0;
    isEdit = 0;
    personalInfoCount = 0;
    AssetInfoCount = 0;
    houseInfoCount = 0;
    carInfoCount = 0;
    workInfoCount = 0;
    //    loansInfoCount = 0;
    matesInfoCount = 0;
    relativesInfoCount = 0;
    workmatesInfoCount = 0;
    otherContactsInfoCount = 0;
    contactsInfoCount = 0;
    self.isPersonalInfo = 0;
    if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
        self.isPersonalInfo = 1;
        personalInfoCount = 9;
    }
    
    self.isAssetInfo = 0;
    headPeopleID = @"";
    _dataArray = [NSMutableArray array];
    
    _sectionOneDataArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.seType == 1) {
        [self initUIs];//创建视图
        
    } else {
        [self setupView];
        isEdit = 1;
        if (self.seType == 3) {
            UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickDismiss)];
            self.navigationItem.leftBarButtonItem = left;
        }
    }
    
    // 选择时间界面
    
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.5;
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMdd"];
    _dateTimeSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
    // Do any additional setup after loading the view.
}

#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    [self.CRMDetailsTableView endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
}



//数据库中的提醒数量
- (void)aboutDateBase {
    self.alermArr = [NSMutableArray array];
    self.db = [FMDatabase databaseWithPath:dataBasePath];
    if ([self.db open]) {
        FMResultSet *resultSet = [self.db executeQuery:@"select * from CRMAlerm where CRMID=?",self.customerId];
        while ([resultSet next]) {
            self.alerm = [resultSet objectForColumnName:@"alerm"];
            NSLog(@"name == %@",self.alerm);
        }
        if (self.alerm.length > 0) {
            NSData *JSONArrData = [self.alerm dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *theObject = [[NSMutableArray alloc] init];
            NSError *error = nil;
            theObject = [NSJSONSerialization JSONObjectWithData:JSONArrData options:NSJSONReadingMutableContainers error:&error];
            for (int i = 0; i<theObject.count; i++) {
                NSDictionary *alerm = theObject[i];
                alermModel *model = [alermModel requestWithDic:alerm];
                [self.alermArr addObject:model];
            }
        }
    }
    [self.db close];
    NSLog(@"self.alermArr.count == %ld",self.alermArr.count);
}

- (void)PeopleBtnClick:(UIButton *)btn {
    ContactDetailsViewController *ContactDetails = [ContactDetailsViewController new];
    ContactDetails.setype = 3;
    ContactDetails.uid = self.uid;
    
    [self.navigationController pushViewController:ContactDetails animated:YES];
}
//创建视图
- (void)initUIs {
    userName = @"";
    userMobile = @"";
    self.navigationItem.title = @"客户详情";
    self.crmInfoArr = [NSMutableArray array];
    self.productArr = [NSMutableArray array];
    self.cusrecordListArr = [NSMutableArray array];
    self.remarkListArr = [NSMutableArray arrayWithCapacity:0];
    [self requsetCRMDetails:self.customerId];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"编辑"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickEdit)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 999;
    [btn setImage:[UIImage imageNamed:@"CRMMore"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 40);
    [btn addTarget:self action:@selector(ClickNotification) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"闹钟"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickNotificationn)];
    
    self.navigationItem.rightBarButtonItems = @[right2,right];
    if ([self.myUser_Id isEqualToString:self.createPsId] || [self.myUser_Id isEqualToString:self.adviserId]) {
        self.navigationItem.rightBarButtonItems = @[right1,right];
    }
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.CRMDetailsTableView];
    
    self.CRMDetailsTableView.delegate = self;
    self.CRMDetailsTableView.dataSource = self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.CRMDetailsTableView setTableFooterView:view];
    self.CRMDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.CRMDetailsTableView registerClass:[CRMDetailsTableViewCell class] forCellReuseIdentifier:@"firstLevel"];
    [self.CRMDetailsTableView registerClass:[CRMSecondTableViewCell class] forCellReuseIdentifier:@"two"];
    [self.CRMDetailsTableView registerClass:[CRMSubTableViewCell class] forCellReuseIdentifier:@"sub"];
    [self.CRMDetailsTableView registerClass:[LatestTableViewCell class] forCellReuseIdentifier:@"latest"];
    
    if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
        _CRMDetailsTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-44);
    }
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.layer.masksToBounds = YES;
    [self.view addSubview:_btn1];
    
    _btn1.frame = CGRectMake(kScreenWidth-70,79,50, 50);
    if (IS_IPHONE_X) {
        _btn1.frame = CGRectMake(kScreenWidth-70,NaviHeight+15,50, 50);
    }
    [_btn1.layer setCornerRadius:25];
    
}
- (void)setupView {
    self.CRMDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-44) style:UITableViewStyleGrouped];
    if (IS_IPHONE_X) {
        _CRMDetailsTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-83);
    }
    if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
        _CRMDetailsTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
    }
    self.navigationItem.title = @"信息采集";
    self.crmInfoArr = [NSMutableArray array];
    self.productArr = [NSMutableArray array];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOK)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.view addSubview:self.CRMDetailsTableView];
    self.CRMDetailsTableView.delegate = self;
    self.CRMDetailsTableView.dataSource = self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.CRMDetailsTableView setTableFooterView:view];
    self.CRMDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //CRMDetailsTableViewCell
    [self.CRMDetailsTableView registerClass:[CRMDetailsTableViewCell class] forCellReuseIdentifier:@"firstLevel"];
    [self.CRMDetailsTableView registerClass:[CRMSecondTableViewCell class] forCellReuseIdentifier:@"two"];
    [self.CRMDetailsTableView registerClass:[CRMSubTableViewCell class] forCellReuseIdentifier:@"sub"];
    
#pragma mark == 修改的section1的数据
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        [self sectionOneData];
        [self.view addSubview:self.bottomViewOne];
    }
    
    [self addPersonalInfoData];
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        [self addAssetInfoData];
    }
    [self addWorkInfoData];
    //    [self addLoansInfoData];
    [self addContactsInfoData];
    [self reloadDataForDisplayArray];
    userName = @"";
    userMobile = @"";
}
//底面按钮
- (void)addBottomView {
    int count = 1;
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        count = 2;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = VIEW_BASE_COLOR;
    if (self.ishideNaviView) {
        view.frame = CGRectMake(0, kScreenHeight-NaviHeight-44, kScreenWidth, 44);
        if (IS_IPHONE_X) {
            view.frame = CGRectMake(0, kScreenHeight-NaviHeight-83, kScreenWidth, 83);
        }
    } else {
        view.frame = CGRectMake(0, kScreenHeight-44, kScreenWidth, 44);
        if (IS_IPHONE_X) {
            view.frame = CGRectMake(0, kScreenHeight-83, kScreenWidth, 83);
        }
    }
    
    self.bottomView = view;
    UIButton *stateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.frame = CGRectMake(0, 0, kScreenWidth/(count+1)*1.0, 44);
    [self.bottomView addSubview:stateBtn];
    [stateBtn addTarget:self action:@selector(stateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [stateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [stateBtn setImage:[UIImage imageNamed:@"分类"] forState:UIControlStateNormal];
    NSString *state;
    /*状态 ， 1待处理，2邀约中，3已到访，5公司放弃，6客户放弃*/
    switch ([self.CRMModel.state integerValue]) {
        case 1:
            state = [NSString stringWithFormat:@"待处理"];
            [stateBtn setTitle:state forState:UIControlStateNormal];
            break;
        case 2:
            state = [NSString stringWithFormat:@"邀约中"];
            [stateBtn setTitle:state forState:UIControlStateNormal];
            break;
        case 3:
            state = [NSString stringWithFormat:@"已到访"];
            [stateBtn setTitle:state forState:UIControlStateNormal];
            break;
        case 4:
            state = [NSString stringWithFormat:@"办理中"];
            [stateBtn setTitle:state forState:UIControlStateNormal];
            break;
        case 5:
            state = [NSString stringWithFormat:@"公司放弃"];
            [stateBtn setTitle:state forState:UIControlStateNormal];
            break;
        case 6:
            state = [NSString stringWithFormat:@"客户放弃"];
            [stateBtn setTitle:state forState:UIControlStateNormal];
            break;
    }
    stateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.stateBtn = stateBtn;
    
    UIButton *picturesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    picturesBtn.frame = CGRectMake(kScreenWidth/(count+1)*1.0,0, kScreenWidth/(count+1)*1.0, 44);
    [view addSubview:picturesBtn];
    [picturesBtn addTarget:self action:@selector(picturesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [picturesBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [picturesBtn setTitle:@"图片材料" forState:UIControlStateNormal];
    picturesBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *buildOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buildOrderBtn.frame = CGRectMake(kScreenWidth/(count+1)*1.0*count,0, kScreenWidth/(count+1)*1.0, 44);
    [view addSubview:buildOrderBtn];
    [buildOrderBtn addTarget:self action:@selector(buildOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buildOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [buildOrderBtn setTitle:@"生成订单" forState:UIControlStateNormal];
    buildOrderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
        picturesBtn.hidden = YES;
        buildOrderBtn.hidden = YES;
        stateBtn.frame = CGRectMake(0, 0, kScreenWidth, 44);
    }
    
    
    for (int i=0; i<count; i++) {
        UIView *seperator = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/(count+1)*1.0*(i+1),7, 0.5, 30)];
        seperator.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:seperator];
        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
            seperator.hidden = YES;
        }
    }
    [self.view addSubview:view];
    
    
}
- (NSMutableDictionary *)dicWithData:(NSString *)interType {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    
    for (TreeViewNode *node in _sectionOneDataArray) {
        subCellModel *model = node.nodeData;
        if ([model.name isEqualToString:@"职业性质"]) {
            self.occ_type = [NSString stringWithFormat:@"%ld",model.index];
            if (![self.occ_type isEqualToString:@"0"]) {
                dic[@"occ_type"] = self.occ_type;
            }
        }
        if ([model.name isEqualToString:@"单位性质"]) {
            self.work_type = [NSString stringWithFormat:@"%ld",model.index];
            if (![self.work_type isEqualToString:@"0"]) {
                dic[@"work_type"] = self.work_type;
            }
        }
        if ([model.name isEqualToString:@"公  积  金"]) {
            self.iscpf = [NSString stringWithFormat:@"%ld",model.index];
            if (![self.iscpf isEqualToString:@"0"]) {
                dic[@"iscpf"] = self.iscpf;
            }
        }
        if ([model.name isEqualToString:@"公积金范围"]) {
            self.cpfRange = [NSString stringWithFormat:@"%ld",model.index];
            if (![self.cpfRange isEqualToString:@"0"]) {
                dic[@"cpfRange"] = self.cpfRange;
            }
        }
        if ([model.name isEqualToString:@"公积金金额"]) {
            self.cpfMoney = model.TFText;
            if (![self.cpfMoney isEqualToString:@"0"]) {
                dic[@"cpfMoney"] = self.cpfMoney;
            }
        }
        if ([model.name isEqualToString:@"社保有无"]) {
            self.issb = [NSString stringWithFormat:@"%ld",model.index];
            
            if (![self.issb isEqualToString:@"0"]) {
                dic[@"issb"] = self.issb;
            }
        }
        if ([model.name isEqualToString:@"个人保险"]) {
            self.isgrbx = [NSString stringWithFormat:@"%ld",model.index];
            
            if (![self.isgrbx isEqualToString:@"0"]) {
                dic[@"isgrbx"] = self.isgrbx;
            }
        }
        if ([model.name isEqualToString:@"投保年限"]) {
            self.grbx_term_range = [NSString stringWithFormat:@"%ld",model.index];
            
            if (![self.grbx_term_range isEqualToString:@"0"]) {
                dic[@"grbx_term_range"] = self.grbx_term_range;
            }
        }
        if ([model.name isEqualToString:@"保险金额/元"]) {
            self.grbx_sum = [NSString stringWithFormat:@"%@",model.TFText];
            
            if (![Utils isBlankString:self.grbx_sum]) {
                dic[@"grbx_sum"] = self.grbx_sum;
            }
        }
        if ([model.name isEqualToString:@"私营业主是否报税"]) {
            self.isbs = [NSString stringWithFormat:@"%ld",model.index];
            
            if (![self.isbs isEqualToString:@"0"]) {
                dic[@"isbs"] = self.isbs;
            }
        }
    }
    
    for (TreeViewNode *node in _dataArray) {
        subCellModel *model = node.nodeData;
        if ([model.name isEqualToString:@"客户来源"]) {
            self.source = [NSString stringWithFormat:@"%ld",model.index];
            if (![self.source isEqualToString:@"0"]) {
                dic[@"source"] = self.source;
            }
        }
        if ([model.name isEqualToString:@"融资顾问"]) {
            dic[@"adviserId"] = self.adviserId;
            //            if (![self.adviserId isEqualToString:self.CRMModel.adviserId]) {
            //
            //            }
        }
        
        if ([model.name isEqualToString:@"融资金额"]) {
            self.money = [NSString stringWithFormat:@"%@",model.TFText];
            if (![self.money isEqual:@"(null)"]) {
                dic[@"money"] = self.money;
            }
            
        }
        
        if ([model.name isEqualToString:@"申请产品"]) {
            if (self.returnIDArray.count != 0) {
                for (int i=0; i<self.returnIDArray.count; i++) {
                    if (i == 0) {
                        self.mechProId = self.returnIDArray[i];
                    } else {
                        self.mechProId = [NSString stringWithFormat:@"%@,%@",self.mechProId,self.returnIDArray[i]];
                    }
                }
            } else {
                if (self.productArr.count > 0) {
                    for (int i=0; i<self.productArr.count; i++) {
                        productModel *proModel = self.productArr[i];
                        if (i == 0) {
                            self.mechProId = proModel.ID;
                        } else {
                            self.mechProId = [NSString stringWithFormat:@"%@,%@",self.mechProId,proModel.ID];
                        }
                    }
                }
            }
            dic[@"mechProId"] = self.mechProId;
        }
        if ([model.name isEqualToString:@"贷款用途"]) {
            self.purpose = [NSString stringWithFormat:@"%ld",model.index];
            if (![self.purpose isEqualToString:@"0"]) {
                dic[@"purpose"] = self.purpose;
            }
            
        }
        [tmp addObject:node];
        for(TreeViewNode *node2 in node.sonNodes){
            [tmp addObject:node2];
            subCellModel *model2 = node2.nodeData;
            if ([model2.name isEqualToString:@"性        别"]) {
                self.user_sex = [NSString stringWithFormat:@"%ld",model2.index];
                if (![self.user_sex isEqualToString:@"0"]) {
                    dic[@"user_sex"] = self.user_sex;
                }
            }
            if ([model2.name isEqualToString:@"证件类型"]) {
                self.user_id_type = [NSString stringWithFormat:@"%ld",model2.index];
                if (![self.user_id_type isEqualToString:@"0"]) {
                    dic[@"user_id_type"] = self.user_id_type;
                }
            }
            if ([model2.name isEqualToString:@"证件号码"]) {
                self.user_id_number = model2.TFText;
                dic[@"user_id_number"] = self.user_id_number;
            }
            if ([model2.name isEqualToString:@"婚姻状况"]) {
                self.user_marry = [NSString stringWithFormat:@"%ld",model2.index];
                if (![self.user_marry isEqualToString:@"0"]) {
                    dic[@"user_marry"] = self.user_marry;
                }
            }
            if ([model2.name isEqualToString:@"有无子女"]) {
                self.user_child = [NSString stringWithFormat:@"%ld",model2.index];
                if (![self.user_child isEqualToString:@"0"]) {
                    dic[@"user_child"] = self.user_child;
                }
            }
            if ([model2.name isEqualToString:@"最高学历"]) {
                self.user_education = [NSString stringWithFormat:@"%ld",model2.index];
                if (![self.user_education isEqualToString:@"0"]) {
                    dic[@"user_education"] = self.user_education;
                }
            }
            if ([model2.name isEqualToString:@"户口所在地"]) {
                self.hkaddress = model2.TFText;
                dic[@"hkaddress"] = self.hkaddress;
            }
            if ([model2.name isEqualToString:@"现住宅地址"]) {
                self.nowaddress = model2.TFText;
                dic[@"nowaddress"] = self.nowaddress;
            }
            //            if ([model2.name isEqualToString:@"现住宅类型"]) {
            //                self.user_house_type = [NSString stringWithFormat:@"%ld",model2.index];
            //                if (![self.user_house_type isEqualToString:@"0"]) {
            //                    dic[@"user_house_type"] = self.user_house_type;
            //                }
            //            }
            //            if ([model2.name isEqualToString:@"每月租金"] ||[model2.name isEqualToString:@"每月还款"] ) {
            //                self.user_house_money = model2.TFText;
            //                dic[@"user_house_money"] = self.user_house_money;
            //            }
            if ([model2.name isEqualToString:@"住宅电话"]) {
                self.user_tel = model2.TFText;
                dic[@"user_tel"] = self.user_tel;
            }
            
            
            
            
            if ([model2.identification isEqualToString:@"本人单位名称"]) {
                self.work_name = model2.TFText;
                dic[@"work_name"] = self.work_name;
            }
            if ([model2.identification isEqualToString:@"本人单位地址"]) {
                self.work_address = model2.TFText;
                dic[@"work_address"] = self.work_address;
            }
            
            if ([model2.name isEqualToString:@"所属行业"]) {
                self.work_industry = model2.TFText;
                dic[@"work_industry"] = self.work_industry;
            }
            if ([model2.identification isEqualToString:@"本人单位电话"]) {
                self.work_tel = model2.TFText;
                dic[@"work_tel"] = self.work_tel;
            }
            if ([model2.name isEqualToString:@"所属部门"]) {
                self.work_part = model2.TFText;
                dic[@"work_part"] = self.work_part;
            }
            if ([model2.name isEqualToString:@"担任职位"]) {
                self.work_job = model2.TFText;
                dic[@"work_job"] = self.work_job;
            }
            if ([model2.name isEqualToString:@"入职时间"]) {
                self.work_date = workTime;
                dic[@"work_date"] = self.work_date;
            }
            if ([model2.name isEqualToString:@"月总收入/元"]) {
                self.work_money = model2.TFText;
                dic[@"work_money"] = self.work_money;
            }
            
            if ([model2.name isEqualToString:@"发薪形式"]) {
                self.work_money_type = [NSString stringWithFormat:@"%ld",model2.index];
                if (![self.work_money_type isEqualToString:@"0"]) {
                    dic[@"work_money_type"] = self.work_money_type;
                }
            }
            if ([model2.name isEqualToString:@"企业类型"]) {
                self.special_company_type = [NSString stringWithFormat:@"%ld",model2.index];
                
                if (![self.special_company_type isEqualToString:@"0"]) {
                    dic[@"special_company_type"] = self.special_company_type;
                }
            }
            if ([model2.name isEqualToString:@"成立时间"]) {
                
                dic[@"special_company_date"] = self.special_company_date;
            }
            if ([model2.name isEqualToString:@"员工人数"]) {
                self.special_company_number = model2.TFText;
                dic[@"special_company_number"] = self.special_company_number;
            }
            if ([model2.name isEqualToString:@"月净利润"]) {
                self.special_net_profit = model2.TFText;
                dic[@"special_net_profit"] = self.special_net_profit;
            }
            if ([model2.name isEqualToString:@"营业面积"]) {
                self.special_company_area = model2.TFText;
                dic[@"special_company_area"] = self.special_company_area;
            }
            if ([model2.name isEqualToString:@"配偶/直系"]) {
                self.person_dear = model2.TFText;
                dic[@"person_dear"] = self.person_dear;
            }
            if ([model2.name isEqualToString:@"直系亲属"]) {
                self.person_family_name = model2.TFText;
                dic[@"person_family_name"] = self.person_family_name;
            }
            if ([model2.name isEqualToString:@"单位同事"]) {
                self.person_colleague_name = model2.TFText;
                dic[@"person_colleague_name"] = self.person_colleague_name;
            }
            if ([model2.name isEqualToString:@"其他联系人"]) {
                self.person_other_name = model2.TFText;
                dic[@"person_other_name"] = self.person_other_name;
            }
            if ([model2.name isEqualToString:@"以上哪些联系人可以知晓贷款"]) {
                self.person_know = model2.TFText;
                dic[@"person_know"] = self.person_know;
            }
            if ([model2.name isEqualToString:@"共同借款人"]) {
                self.person_together = [NSString stringWithFormat:@"%ld",model2.index];
                
                if (![self.person_together isEqualToString:@"0"]) {
                    dic[@"person_together"] = self.person_together;
                }
            }
            if ([model2.identification isEqualToString:@"共同借款人姓名"]) {
                self.person_together_name = model2.TFText;
                dic[@"person_together_name"] = self.person_together_name;
            }
            if ([model2.name isEqualToString:@"备注"]) {
                self.remark = [NSString stringWithFormat:@"%@",model2.TFText];
                if (![Utils isBlankString:self.remark]) {
                    dic[@"remark"] = self.remark;
                }
            }
            if ([model2.name isEqualToString:@"方案"]) {
                self.adviserPlan = [NSString stringWithFormat:@"%@",model2.TFText];
                if (![self.adviserPlan isEqual:@"(null)"]) {
                    
                    dic[@"adviserPlan"] = self.adviserPlan;
                }
                
            }
            for(TreeViewNode *node3 in node2.sonNodes){
                [tmp addObject:node3];
                subCellModel *model3 = node3.nodeData;
#pragma mark == 修改的资产信息
                if ([model3.name isEqualToString:@"房产类型"]) {
                    self.asset_house_type = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_house_type isEqualToString:@"0"]) {
                        dic[@"asset_house_type"] = self.asset_house_type;
                    }
                }
                if ([model3.identification isEqualToString:@"购房价格"]) {
                    self.asset_house_totalPrice = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_house_totalPrice isEqualToString:@"0"]) {
                        dic[@"asset_house_totalPrice"] = self.asset_house_totalPrice;
                    }
                }
                if ([model3.identification isEqualToString:@"购房总价格"]) {
                    self.asset_house_totalval = model3.TFText;
                    dic[@"asset_house_totalval"] = self.asset_house_totalval;
                }
                
                if ([model3.identification isEqualToString:@"购房月供"]) {
                    self.asset_house_monRange = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_house_monRange isEqualToString:@"0"]) {
                        dic[@"asset_house_monRange"] = self.asset_house_monRange;
                    }
                }
                if ([model3.identification isEqualToString:@"房产月供"]) {
                    self.asset_house_month = model3.TFText;
                    dic[@"asset_house_month"] = self.asset_house_month;
                }
                
                if ([model3.identification isEqualToString:@"购房日期"]) {
                    self.asset_house_dateRange = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_house_dateRange isEqualToString:@"0"]) {
                        dic[@"asset_house_dateRange"] = self.asset_house_dateRange;
                    }
                }
                
                if ([model3.name isEqualToString:@"建筑面积"]) {
                    self.asset_house_area = model3.TFText;
                    dic[@"asset_house_area"] = self.asset_house_area;
                }
                
                
                if ([model3.name isEqualToString:@"车辆类型"]) {
                    self.asset_car_type = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_car_type isEqualToString:@"0"]) {
                        dic[@"asset_car_type"] = self.asset_car_type;
                    }
                }
                if ([model3.identification isEqualToString:@"购车价格"]) {
                    self.asset_car_totalRange = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_car_totalRange isEqualToString:@"0"]) {
                        dic[@"asset_car_totalRange"] = self.asset_car_totalRange;
                    }
                }
                if ([model3.identification isEqualToString:@"购车总价格"]) {
                    self.asset_car_price = model3.TFText;
                    dic[@"asset_car_price"] = self.asset_car_price;
                }
                
                if ([model3.identification isEqualToString:@"购车月供"]) {
                    self.asset_car_monRange = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_car_monRange isEqualToString:@"0"]) {
                        dic[@"asset_car_monRange"] = self.asset_car_monRange;
                    }
                }
                if ([model3.identification isEqualToString:@"车辆月供"]) {
                    self.asset_car_month = model3.TFText;
                    dic[@"asset_car_month"] = self.asset_car_month;
                }
                //asset_car_dateRange
                if ([model3.identification isEqualToString:@"购房日期"]) {
                    self.asset_car_dateRange = [NSString stringWithFormat:@"%ld",model3.index];
                    if (![self.asset_car_dateRange isEqualToString:@"0"]) {
                        dic[@"asset_house_type"] = self.asset_car_dateRange;
                    }
                }
                
                
                
                
                if ([model3.name isEqualToString:@"身份证号码"]) {
                    self.person_id_card = model3.TFText;
                    dic[@"person_id_card"] = self.person_id_card;
                }
                if ([model3.identification isEqualToString:@"配偶手机号码"]) {
                    self.person_mobile = model3.TFText;
                    dic[@"person_mobile"] = self.person_mobile;
                }
                if ([model3.identification isEqualToString:@"配偶单位名称"]) {
                    self.person_company_name = model3.TFText;
                    dic[@"person_company_name"] = self.person_company_name;
                }
                if ([model3.identification isEqualToString:@"配偶单位地址"]) {
                    self.person_company_address = model3.TFText;
                    dic[@"person_company_address"] = self.person_company_address;
                }
                if ([model3.identification isEqualToString:@"配偶单位电话"]) {
                    self.person_company_tel = model3.TFText;
                    dic[@"person_company_tel"] = self.person_company_tel;
                }
                if ([model3.identification isEqualToString:@"配偶居住地址"]) {
                    self.person_address = model3.TFText;
                    dic[@"person_address"] = self.person_address;
                }
                if ([model3.identification isEqualToString:@"直系关系"]) {
                    self.person_family_ship = model3.TFText;
                    dic[@"person_family_ship"] = self.person_family_ship;
                }
                if ([model3.identification isEqualToString:@"直系手机号码"]) {
                    self.person_family_moblie = model3.TFText;
                    dic[@"person_family_moblie"] = self.person_family_moblie;
                }
                if ([model3.identification isEqualToString:@"直系单位名称"]) {
                    self.person_family_company = model3.TFText;
                    dic[@"person_family_company"] = self.person_family_company;
                }
                if ([model3.identification isEqualToString:@"同事职位"]) {
                    self.person_colleague_work = model3.TFText;
                    dic[@"person_colleague_work"] = self.person_colleague_work;
                }
                if ([model3.identification isEqualToString:@"同事手机号码"]) {
                    self.person_colleague_moblie = model3.TFText;
                    dic[@"person_colleague_moblie"] = self.person_colleague_moblie;
                }
                if ([model3.identification isEqualToString:@"同事单位名称"]) {
                    self.person_colleague_company = model3.TFText;
                    dic[@"person_colleague_company"] = self.person_colleague_company;
                }
                if ([model3.identification isEqualToString:@"其他联系人关系"]) {
                    self.person_other_ship = model3.TFText;
                    dic[@"person_other_ship"] = self.person_other_ship;
                }
                if ([model3.identification isEqualToString:@"其他联系人手机号码"]) {
                    self.person_other_moblie = model3.TFText;
                    dic[@"person_other_moblie"] = self.person_other_moblie;
                }
                if ([model3.identification isEqualToString:@"其他联系人单位名称"]) {
                    self.person_other_company = model3.TFText;
                    dic[@"person_other_company"] = self.person_other_company;
                }
                
            }
        }
    }
    dic[@"inter"] = [NSString stringWithFormat:@"%@",interType];
    if ([interType isEqualToString:@"updateCustomer"]) {
        dic[@"uid"] = [NSString stringWithFormat:@"%ld",myModel.userId];
        dic[@"customerId"] = self.customerId;
    } else {
        dic[@"state"] = @"1";
        dic[@"createPsId"] = self.customerId;
    }
    
    dic[@"user_name"] = userName;
    dic[@"user_mobile"] = userMobile;
    
    
    dic[@"photo_id_front"] = [self.CRMModel.photoIdFront stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_id_back"] = [self.CRMModel.photoIdBack stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_registered"] = [self.CRMModel.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_registered2"] = [self.CRMModel.photoRegist2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_registered3"] = [self.CRMModel.photoRegist3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_house"] = [self.CRMModel.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_house2"] = [self.CRMModel.photoHouse2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_house3"] = [self.CRMModel.photoHouse3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_marry"] = [self.CRMModel.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_marry2"] = [self.CRMModel.photoMarry2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_marry3"] = [self.CRMModel.photoMarry3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_work"] = [self.CRMModel.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_work2"] = [self.CRMModel.photoWork2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_work3"] = [self.CRMModel.photoWork3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_wages"] = [self.CRMModel.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_wages2"] = [self.CRMModel.photoWages2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_wages3"] = [self.CRMModel.photoWages3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_other"] = [self.CRMModel.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_other2"] = [self.CRMModel.photoOther2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_other3"] = [self.CRMModel.photoOther3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    dic[@"photo_credit"] = [self.CRMModel.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit2"] = [self.CRMModel.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit3"] = [self.CRMModel.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit4"] = [self.CRMModel.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit5"] = [self.CRMModel.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit6"] = [self.CRMModel.photoCredit6 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit7"] = [self.CRMModel.photoCredit7 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit8"] = [self.CRMModel.photoCredit8 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit9"] = [self.CRMModel.photoCredit9 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    dic[@"photo_credit10"] = [self.CRMModel.photoCredit10 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    DLog(@"dic === %@",dic);
    return dic;
}
- (void) requsetCRMDetails:(NSString *)customerId {
    [self.crmInfoArr removeAllObjects];
    [self.productArr removeAllObjects];
    
    [HttpRequestEngine getCRMDetailsWithCustomerId:customerId completion:^(id obj, NSString *errorStr) {
        if (errorStr) {
            [MBProgressHUD showError:@"未查询到该客户"];
        }else {
            if ([(NSMutableArray *)obj count]>0) {
                self.crmInfoArr = obj[0];
                self.productArr = obj[1];
                self.cusrecordListArr = obj[2];
                self.remarkListArr = obj[3];
                self.CRMModel = self.crmInfoArr[0];
                self.createPsId = [NSString stringWithFormat:@"%@",self.CRMModel.createPsId];
                self.adviserId = [NSString stringWithFormat:@"%@",self.CRMModel.adviserId];
                self.navigationItem.rightBarButtonItems = nil;
                UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"编辑"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickEdit)];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 999;
                [btn setImage:[UIImage imageNamed:@"CRMMore"] forState:UIControlStateNormal];
                btn.frame = CGRectMake(0, 0, 30, 40);
                [btn addTarget:self action:@selector(ClickNotification) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
                
                UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"闹钟"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickNotificationn)];
                
                self.navigationItem.rightBarButtonItems = @[right2,right];
                if ([self.myUser_Id isEqualToString:self.createPsId] || [self.myUser_Id isEqualToString:self.adviserId]) {
                    self.navigationItem.rightBarButtonItems = @[right1,right];
                }
                
#pragma mark == 修改的section1的数据
                if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                    [self sectionOneData];
                }
                
                [self addPersonalInfoData];
                if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                    [self addAssetInfoData];
                }
                
                [self addWorkInfoData];
                //                [self addLoansInfoData];
                [self addContactsInfoData];
                
                userName = self.CRMModel.user_name;
                userMobile = self.CRMModel.user_mobile;
                [self reloadDataForDisplayArray];
                [self.CRMDetailsTableView reloadData];
                
                [self addBottomView];
                self.iconURL = [NSString stringWithFormat:@"%@",self.CRMModel.icon];
                self.uid = [NSString stringWithFormat:@"%@",self.CRMModel.createPsId];
                NSString *str = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.iconURL];
                NSURL *iconUrl = [NSURL URLWithString:str];
                [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btn1 sd_setBackgroundImageWithURL:iconUrl forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                
            }else{
                [self.crmInfoArr removeAllObjects];
                [self.productArr removeAllObjects];
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"未查询到数据"];
            }
            
            [self.CRMDetailsTableView reloadData];
        }
        
    }];
}
#pragma mark == sectionOne数据
- (void)sectionOneData {
    TreeViewNode *node0 = [[TreeViewNode alloc]init];
    node0.nodeLevel = 1;//根层cell
    node0.type = 2;//type 1的cell
    node0.sonNodes = nil;
    node0.isExpanded = FALSE;//关闭状态
    subCellModel *model0 = [[subCellModel alloc]init];
    model0.name = @"职业性质";
    model0.BtnArr = [NSMutableArray arrayWithObjects:@"受    薪   ",@"自雇人士", nil];
    model0.type = 1;
    if (self.CRMModel.occ_type != nil) {
        model0.index = [self.CRMModel.occ_type integerValue];
    } else {
        model0.index = 0;
    }
    node0.nodeData = model0;
    
    TreeViewNode *node1 = [[TreeViewNode alloc]init];
    node1.nodeLevel = 1;//根层cell
    node1.type = 2;//type 1的cell
    node1.sonNodes = nil;
    node1.isExpanded = FALSE;//关闭状态
    subCellModel *model1 = [[subCellModel alloc]init];
    model1.name = @"单位性质";
    model1.BtnArr = [NSMutableArray arrayWithObjects:@" 行政事业单位、社会团体",@" 国 企  ",@" 民 企  ",@" 外 资  ",@" 合 资  ",@" 私 营  ",@"个 体  ", nil];
    model1.type = 1;
    if (self.CRMModel.work_type != nil) {
        model1.index = [self.CRMModel.work_type integerValue];
    } else {
        model1.index = 0;
    }
    node1.nodeData = model1;
    
    
    TreeViewNode *node2 = [[TreeViewNode alloc]init];
    node2.nodeLevel = 1;//根层cell
    node2.type = 2;//type 1的cell
    node2.sonNodes = nil;
    node2.isExpanded = FALSE;//关闭状态
    subCellModel *model2 = [[subCellModel alloc]init];
    model2.name = @"公  积  金";
    model2.BtnArr = [NSMutableArray arrayWithObjects:@" 有(元)  ",@" 无   ", nil];
    model2.type = 1;
    if (self.CRMModel.iscpf) {
        model2.index = [self.CRMModel.iscpf integerValue];
    } else {
        model2.index = 0;
    }
    node2.nodeData = model2;
    
    TreeViewNode *node3 = [[TreeViewNode alloc]init];
    node3.nodeLevel = 0;//根层cell
    node3.type = 3;//type 3的cell
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;//关闭状态
    subCellModel *model3 = [[subCellModel alloc]init];
    model3.name = @"公积金范围";
    model3.index = 0;
    model3.BtnArr = [NSMutableArray arrayWithObjects:@"500以内",@"500-1500",@"1500以上",@"其他", nil];;
    model3.type = 1;
    if (self.CRMModel.cpfRange != nil) {
        model3.index = [self.CRMModel.cpfRange integerValue];
    } else {
        model3.index = 0;
    }
    node3.nodeData = model3;
    
    TreeViewNode *node4 = [[TreeViewNode alloc]init];
    node4.nodeLevel = 0;//根层cell
    node4.type = 2;//type 1的cell
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;//关闭状态
    subCellModel *model4 = [[subCellModel alloc]init];
    model4.name = @"公积金金额";
    model4.index = 0;
    model4.KeyType = 1;
    model4.BtnArr = nil;
    model4.type = 2;
    if (![self.CRMModel.cpfMoney isEqual:@"(null)"]) {
        cpfMoney = self.CRMModel.cpfMoney;
        model4.TFText = cpfMoney;
    }
    node4.nodeData = model4;
    
    TreeViewNode *node5 = [[TreeViewNode alloc]init];
    node5.nodeLevel = 1;//根层cell
    node5.type = 2;//type 1的cell
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;//关闭状态
    subCellModel *model5 = [[subCellModel alloc]init];
    model5.name = @"社保有无";
    model5.BtnArr = [NSMutableArray arrayWithObjects:@" 有   ",@" 无   ", nil];
    model5.type = 1;
    if (self.CRMModel.issb) {
        model5.index = [self.CRMModel.issb integerValue];
    } else {
        model5.index = 0;
    }
    node5.nodeData = model5;
    
    TreeViewNode *node6 = [[TreeViewNode alloc]init];
    node6.nodeLevel = 1;//根层cell
    node6.type = 2;//type 1的cell
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;//关闭状态
    subCellModel *model6 = [[subCellModel alloc]init];
    model6.name = @"个人保险";
    model6.BtnArr = [NSMutableArray arrayWithObjects:@" 有   ",@" 无   ", nil];
    model6.type = 1;
    model6.index = 0;
    if (self.CRMModel.isgrbx) {
        model6.index = [self.CRMModel.isgrbx integerValue];
    } else {
        model6.index = 0;
    }
    node6.nodeData = model6;
    
    TreeViewNode *node7 = [[TreeViewNode alloc]init];
    node7.nodeLevel = 1;//根层cell
    node7.type = 2;//type 1的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    subCellModel *model7 = [[subCellModel alloc]init];
    model7.name = @"私营业主是否报税";
    model7.BtnArr = [NSMutableArray arrayWithObjects:@" 有   ",@" 无    ", nil];
    model7.type = 1;
    if (self.CRMModel.isbs) {
        model7.index = [self.CRMModel.isbs integerValue];
    } else {
        model7.index = 0;
    }
    node7.nodeData = model7;
    
    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    node8.nodeLevel = 1;//根层cell
    node8.type = 3;//type 1的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    subCellModel *model8 = [[subCellModel alloc]init];
    model8.name = @"投保年限";
    model8.index = 0;
    model8.BtnArr = [NSMutableArray arrayWithObjects:@"1年内",@"1-2年",@"2年以上", nil];
    model8.type = 1;
    if (self.CRMModel.grbx_term_range != nil) {
        model8.index = [self.CRMModel.grbx_term_range integerValue];
    } else {
        model8.index = 0;
    }
    node8.nodeData = model8;
    
    TreeViewNode *node9 = [[TreeViewNode alloc]init];
    node9.nodeLevel = 0;//根层cell
    node9.type = 2;//type 1的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    subCellModel *model9 = [[subCellModel alloc]init];
    model9.name = @"保险金额/元";
    model9.index = 0;
    model9.KeyType = 1;
    model9.BtnArr = nil;
    model9.type = 2;
    if (![self.CRMModel.grbx_sum isEqual:@"(null)"]) {
        cpfMoney = self.CRMModel.grbx_sum;
        model9.TFText = cpfMoney;
    }
    node9.nodeData = model9;
    
    DLog(@"self.CRMModel.iscpf == %@",self.CRMModel.iscpf);
    DLog(@"cpfMoney == %@",self.CRMModel.cpfMoney);
    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node5,node6]];
    //判断职业性质是否为1
    if ([self.CRMModel.occ_type isEqualToString:@"1"]) {
        isAddOccType = 1;
        //判断单位性质是否为私营
        if ([self.CRMModel.work_type isEqualToString:@"6"]) {
            isAddPrivate = 1;
            _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node5,node6]];
            //判断公积金有无
            if ([self.CRMModel.iscpf isEqualToString:@"1"]) {
                isAddAccumulationFund = 1;
                //判断公积金范围是否为其他
                if ([self.CRMModel.cpfRange isEqualToString:@"4"]) {
                    isAddCpf = 1;
                    //判断个人保险有无
                    if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                        isAddGRBXRange = 1;
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node3,node4,node5,node6,node8,node9]];
                    }else {
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node3,node4,node5,node6]];
                    }
                    
                } else if ([self.CRMModel.cpfRange integerValue]>0 && [self.CRMModel.cpfRange integerValue]<4) {
                    //判断个人保险有无
                    if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                        isAddGRBXRange = 1;
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node3,node5,node6,node8,node9]];
                    }else {
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node3,node5,node6]];
                    }
                } else {
                    //判断个人保险有无
                    if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                        isAddGRBXRange = 1;
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node3,node5,node6,node8,node9]];
                    }else {
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node3,node5,node6]];
                    }
                }
            }else{
                //判断个人保险有无
                if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                    isAddGRBXRange = 1;
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node5,node6,node8,node9]];
                }else {
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node7,node2,node5,node6]];
                }
                
            }
        } else {
            //判断公积金有无
            if ([self.CRMModel.iscpf isEqualToString:@"1"]) {
                isAddAccumulationFund = 1;
                //判断公积金范围是否为其他
                if ([self.CRMModel.cpfRange isEqualToString:@"4"]) {
                    isAddCpf = 1;
                    //判断个人保险有无
                    if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                        isAddGRBXRange = 1;
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node3,node4,node5,node6,node8,node9]];
                    }else {
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node3,node4,node5,node6]];
                    }
                    
                } else if ([self.CRMModel.cpfRange integerValue]>0 && [self.CRMModel.cpfRange integerValue]<4) {
                    //判断个人保险有无
                    if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                        isAddGRBXRange = 1;
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node3,node5,node6,node8,node9]];
                    }else {
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node3,node5,node6]];
                    }
                } else {
                    //判断个人保险有无
                    if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                        isAddGRBXRange = 1;
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node3,node5,node6,node8,node9]];
                    }else {
                        _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node3,node5,node6]];
                    }
                }
            }else{
                //判断个人保险有无
                if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                    isAddGRBXRange = 1;
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node5,node6,node8,node9]];
                }else {
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node1,node2,node5,node6]];
                }
                
            }
        }
    } else {
        //判断公积金有无
        if ([self.CRMModel.iscpf isEqualToString:@"1"]) {
            isAddAccumulationFund = 1;
            //判断公积金范围是否为其他
            if ([self.CRMModel.cpfRange isEqualToString:@"4"]) {
                isAddCpf = 1;
                //判断个人保险有无
                if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                    isAddGRBXRange = 1;
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node3,node4,node5,node6,node8,node9]];
                }else {
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node3,node4,node5,node6]];
                }
                
            } else if ([self.CRMModel.cpfRange integerValue]>0 && [self.CRMModel.cpfRange integerValue]<4) {
                //判断个人保险有无
                if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                    isAddGRBXRange = 1;
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node3,node5,node6,node8,node9]];
                }else {
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node3,node5,node6]];
                }
            } else {
                //判断个人保险有无
                if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                    isAddGRBXRange = 1;
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node3,node5,node6,node8,node9]];
                }else {
                    _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node3,node5,node6]];
                }
            }
        }else{
            //判断个人保险有无
            if ([self.CRMModel.isgrbx isEqualToString:@"1"]) {
                isAddGRBXRange = 1;
                _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node5,node6,node8,node9]];
            }else {
                _sectionOneDataArray = [NSMutableArray arrayWithArray:@[node0,node2,node5,node6]];
            }
            
        }
    }
    
    
}

#pragma mark -- 个人信息展开的数据
/*
 subCellModel 中的 type :
 1:多个单选按钮
 2:有一个textfield
 3:有一个textfield和单位标签
 4:有一个按钮用于时间等的选择
 */
- (void)addPersonalInfoData {
    TreeViewNode *node1 = [[TreeViewNode alloc]init];
    node1.nodeLevel = 0;//根层cell
    node1.type = 0;//type 1的cell
    node1.sonNodes = nil;
    node1.isExpanded = FALSE;//关闭状态
    if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
        node1.isExpanded = true;//关闭状态
    }
    
    superCellModel *model1 = [[superCellModel alloc]init];
    model1.name = @"个人信息";
    node1.nodeData = model1;
    
    TreeViewNode *node6 = [[TreeViewNode alloc]init];
    node6.nodeLevel = 1;//根层cell
    node6.type = 2;//type 1的cell
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;//关闭状态
    subCellModel *model6 = [[subCellModel alloc]init];
    model6.name = @"性        别";
    model6.BtnArr = [NSMutableArray arrayWithObjects:@" 男   ",@" 女   ", nil];
    model6.type = 1;
    if (self.CRMModel.user_sex) {
        model6.index = [self.CRMModel.user_sex integerValue];
    } else {
        model6.index = 0;
    }
    
    node6.nodeData = model6;
    
    TreeViewNode *node7 = [[TreeViewNode alloc]init];
    node7.nodeLevel = 1;//根层cell
    node7.type = 2;//type 1的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    subCellModel *model7 = [[subCellModel alloc]init];
    model7.name = @"证件类型";
    model7.BtnArr = [NSMutableArray arrayWithObjects:@" 身份证",@" 护     照 ",@" 军官证", nil];
    model7.type = 1;
    if (self.CRMModel.user_id_type) {
        model7.index = [self.CRMModel.user_id_type integerValue];
    } else {
        model7.index = 0;
    }
    
    node7.nodeData = model7;
    
    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    node8.nodeLevel = 1;//根层cell
    node8.type = 2;//type 1的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    subCellModel *model8 = [[subCellModel alloc]init];
    model8.name = @"证件号码";
    model8.KeyType = 1;
    model8.index = 0;
    model8.BtnArr = nil;
    model8.type = 2;
    if (![self.CRMModel.user_id_number isEqual:@"(null)"]) {
        model8.TFText = self.CRMModel.user_id_number;
    }
    
    node8.nodeData = model8;
    
    TreeViewNode *node9 = [[TreeViewNode alloc]init];
    node9.nodeLevel = 1;//根层cell
    node9.type = 2;//type 1的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    subCellModel *model9 = [[subCellModel alloc]init];
    model9.name = @"婚姻状况";
    model9.BtnArr = [NSMutableArray arrayWithObjects:@" 已 婚  ",@" 未 婚  ",@" 离 异  ",@" 丧 偶  ", nil];
    model9.type = 1;
    if (self.CRMModel.user_marry) {
        model9.index = [self.CRMModel.user_marry integerValue];
    } else {
        model9.index = 0;
    }
    node9.nodeData = model9;
    
    TreeViewNode *node10 = [[TreeViewNode alloc]init];
    node10.nodeLevel = 1;//根层cell
    node10.type = 2;//type 1的cell
    node10.sonNodes = nil;
    node10.isExpanded = FALSE;//关闭状态
    subCellModel *model10 = [[subCellModel alloc]init];
    model10.name = @"有无子女";
    model10.BtnArr = [NSMutableArray arrayWithObjects:@" 有    ",@" 无   ", nil];
    model10.type = 1;
    if (self.CRMModel.user_child) {
        model10.index = [self.CRMModel.user_child integerValue];
    } else {
        model10.index = 0;
    }
    node10.nodeData = model10;
    
    TreeViewNode *node11 = [[TreeViewNode alloc]init];
    node11.nodeLevel = 1;//根层cell
    node11.type = 2;//type 1的cell
    node11.sonNodes = nil;
    node11.isExpanded = FALSE;//关闭状态
    subCellModel *model11 = [[subCellModel alloc]init];
    model11.name = @"最高学历";
    model11.BtnArr = [NSMutableArray arrayWithObjects:@" 本科及以上",@" 大      专",@" 高      中",@" 高中以下", nil];
    model11.type = 1;
    if (self.CRMModel.user_education) {
        model11.index = [self.CRMModel.user_education integerValue];
    } else {
        model11.index = 0;
    }
    node11.nodeData = model11;
    
    TreeViewNode *node12 = [[TreeViewNode alloc]init];
    node12.nodeLevel = 1;//根层cell
    node12.type = 2;//type 1的cell
    node12.sonNodes = nil;
    node12.isExpanded = FALSE;//关闭状态
    subCellModel *model12 = [[subCellModel alloc]init];
    model12.name = @"户口所在地";
    model12.index = 0;
    
    if (![self.CRMModel.hkaddress isEqual:@"(null)"]) {
        model12.TFText = self.CRMModel.hkaddress;
    }
    model12.BtnArr = nil;
    model12.type = 2;
    node12.nodeData = model12;
    
    TreeViewNode *node13 = [[TreeViewNode alloc]init];
    node13.nodeLevel = 1;//根层cell
    node13.type = 2;//type 1的cell
    node13.sonNodes = nil;
    node13.isExpanded = FALSE;//关闭状态
    subCellModel *model13 = [[subCellModel alloc]init];
    model13.name = @"现住宅地址";
    model13.index = 0;
    if (![self.CRMModel.nowaddress isEqual:@"(null)"]) {
        model13.TFText = self.CRMModel.nowaddress;
    }
    model13.BtnArr = nil;
    model13.type = 2;
    node13.nodeData = model13;
    
    TreeViewNode *node14 = [[TreeViewNode alloc]init];
    node14.nodeLevel = 1;//根层cell
    node14.type = 2;//type 1的cell
    node14.sonNodes = nil;
    node14.isExpanded = FALSE;//关闭状态
    subCellModel *model14 = [[subCellModel alloc]init];
    model14.name = @"现住宅类型";
    model14.BtnArr = [NSMutableArray arrayWithObjects:@"租用",@"商业按揭购房",@"公积金按揭",@"全款商品房",@"自建房",@"家族房",@"单位宿舍",@"其他",nil];
    model14.type = 1;
    if (self.CRMModel.user_house_type) {
        model14.index = [self.CRMModel.user_house_type integerValue];
    } else {
        model14.index = 0;
    }
    node14.nodeData = model14;
    
    
    
    TreeViewNode *node17 = [[TreeViewNode alloc]init];
    node17.nodeLevel = 1;//根层cell
    node17.type = 2;//type 1的cell
    node17.sonNodes = nil;
    node17.isExpanded = FALSE;//关闭状态
    subCellModel *model17 = [[subCellModel alloc]init];
    model17.name = @"住宅电话";
    model17.index = 0;
    model17.KeyType = 1;
    if (![self.CRMModel.user_tel isEqual:@"(null)"]) {
        model17.TFText = self.CRMModel.user_tel;
    }
    model17.BtnArr = nil;
    model17.type = 2;
    node17.nodeData = model17;
    
    
    
    
#pragma mark == 修改
    node1.sonNodes = [NSMutableArray arrayWithObjects:node6,node7,node8,node9,node10,node11,node12,node13,node17, nil];//修改
    
    
    [_dataArray addObject:node1];
    
}
- (void)addAssetInfoData {
    TreeViewNode *node2 = [[TreeViewNode alloc]init];
    node2.nodeLevel = 0;//根层cell
    node2.type = 0;//type 1的cell
    node2.sonNodes = nil;
    node2.isExpanded = FALSE;//关闭状态
    superCellModel *model2 = [[superCellModel alloc]init];
    model2.name = @"资产信息";
    node2.nodeData = model2;
    
    TreeViewNode *node16 = [[TreeViewNode alloc]init];
    node16.nodeLevel = 1;//根层cell
    node16.type = 1;//type 1的cell
    node16.sonNodes = nil;
    node16.isExpanded = FALSE;//关闭状态
    subCellModel *model16 = [[subCellModel alloc]init];
    model16.name = @"房产信息";
    model16.KeyType = 3;
    //    if (![self.CRMModel.person_dear isEqual:@"(null)"]) {
    //        model6.TFText = self.CRMModel.person_dear;
    //    }
    node16.nodeData = model16;
    
    TreeViewNode *node17 = [[TreeViewNode alloc]init];
    node17.nodeLevel = 1;//根层cell
    node17.type = 1;//type 1的cell
    node17.sonNodes = nil;
    node17.isExpanded = FALSE;//关闭状态
    subCellModel *model17 = [[subCellModel alloc]init];
    model17.name = @"车辆信息";
    model17.KeyType = 3;
    //    if (![self.CRMModel.person_dear isEqual:@"(null)"]) {
    //        model6.TFText = self.CRMModel.person_dear;
    //    }
    node17.nodeData = model17;
    
    TreeViewNode *node3 = [[TreeViewNode alloc]init];
    node3.nodeLevel = 1;//根层cell
    node3.type = 2;//type 1的cell
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;//关闭状态
    subCellModel *model3 = [[subCellModel alloc]init];
    model3.name = @"房产类型";
    model3.BtnArr = [NSMutableArray arrayWithObjects:@" 按 揭  ",@" 自 建  ",@" 全 款  ", nil];
    model3.type = 1;
    if (self.CRMModel.asset_house_type) {
        model3.index = [self.CRMModel.asset_house_type integerValue];
    } else {
        model3.index = 0;
    }
    node3.nodeData = model3;
    
    
    /**
     *****************************   房产信息   *******************************************
     */
    
    TreeViewNode *node4 = [[TreeViewNode alloc]init];
    node4.nodeLevel = 2;//根层cell
    node4.type = 3;//type 5的cell
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;//关闭状态
    subCellModel *model4 = [[subCellModel alloc]init];
    model4.name = @"购买价格／万元";
    model4.identification = @"购房价格";
    model4.BtnArr = [NSMutableArray arrayWithObjects:@"<100",@"100-200",@">200",@"其他", nil];
    model4.type = 4;
    model4.KeyType = 1;
    if (self.CRMModel.asset_house_totalPrice) {
        model4.index = [self.CRMModel.asset_house_totalPrice integerValue];
    } else {
        model4.index = 0;
    }
    node4.nodeData = model4;
    
    
    TreeViewNode *node5 = [[TreeViewNode alloc]init];
    node5.nodeLevel = 2;//根层cell
    node5.type = 2;//type 2的cell
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;//关闭状态
    subCellModel *model5 = [[subCellModel alloc]init];
    model5.name = @"购买价格／万元";
    model5.identification = @"购房总价格";
    model5.BtnArr = nil;
    model5.KeyType = 1;
    model5.type = 2;
    model5.index = 0;
    if (![self.CRMModel.asset_house_totalval isEqual:@"(null)"]) {
        model5.TFText = self.CRMModel.asset_house_totalval;;
    }
    node5.nodeData = model5;
    
    
    TreeViewNode *node6 = [[TreeViewNode alloc]init];
    node6.nodeLevel = 2;//根层cell
    node6.type = 3;//type 1的cell
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;//关闭状态
    subCellModel *model6 = [[subCellModel alloc]init];
    model6.name = @"月 供／元";
    model6.identification = @"购房月供";
    model6.BtnArr = [NSMutableArray arrayWithObjects:@"<3000",@"3000-6000",@">6000",@"其他", nil];
    model6.type = 4;
    model6.KeyType = 1;
    if (self.CRMModel.asset_house_monRange) {
        model6.index = [self.CRMModel.asset_house_monRange integerValue];
    } else {
        model6.index = 0;
    }
    node6.nodeData = model6;
    
    
    TreeViewNode *node7 = [[TreeViewNode alloc]init];
    node7.nodeLevel = 2;//根层cell
    node7.type = 2;//type 1的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    subCellModel *model7 = [[subCellModel alloc]init];
    model7.name = @"月 供／元";
    model7.identification = @"房产月供";
    model7.KeyType = 1;
    model7.BtnArr = nil;
    model7.type = 2;
    model7.index = 0;
    if (![self.CRMModel.asset_house_month isEqual:@"(null)"]) {
        model7.TFText = self.CRMModel.asset_house_month;
    }
    node7.nodeData = model7;
    
    
    
    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    node8.nodeLevel = 2;//根层cell
    node8.type = 3;//type 1的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    subCellModel *model8 = [[subCellModel alloc]init];
    model8.name = @"购买日期";
    model8.identification = @"购房日期";
    model8.BtnArr = [NSMutableArray arrayWithObjects:@"<6个月",@"6-12个月",@">12个月", nil];
    model8.type = 4;
    model8.index = 0;//asset_house_dateRange
    if (self.CRMModel.asset_house_dateRange) {
        model8.index = [self.CRMModel.asset_house_dateRange integerValue];
    } else {
        model8.index = 0;
    }
    node8.nodeData = model8;
    
    TreeViewNode *node9 = [[TreeViewNode alloc]init];
    node9.nodeLevel = 2;//根层cell
    node9.type = 2;//type 1的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    subCellModel *model9 = [[subCellModel alloc]init];
    model9.name = @"建筑面积";
    model9.BtnArr = nil;
    model9.UnitType = @"m²";
    model9.KeyType = 1;
    model9.type = 3;
    model9.index = 0;
    if (![self.CRMModel.asset_house_area isEqual:@"(null)"]) {
        model9.TFText = self.CRMModel.asset_house_area;
    }
    node9.nodeData = model9;
    
    //    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    //    node8.nodeLevel = 2;//根层cell
    //    node8.type = 2;//type 1的cell
    //    node8.sonNodes = nil;
    //    node8.isExpanded = FALSE;//关闭状态
    //    subCellModel *model8 = [[subCellModel alloc]init];
    //    model8.name = @"产权比例";
    //    model8.KeyType = 1;
    //    model8.BtnArr = nil;
    //    model8.UnitType = @"%";
    //    if (![self.CRMModel.asset_house_property isEqual:@"(null)"]) {
    //        model8.TFText = self.CRMModel.asset_house_property;
    //    }
    //    model8.type = 3;
    //    model8.index = 0;
    //    node8.nodeData = model8;
    //
    /**
     *****************************   车辆信息   *******************************************
     */
    
    
    TreeViewNode *node10 = [[TreeViewNode alloc]init];
    node10.nodeLevel = 2;//根层cell
    node10.type = 2;//type 1的cell
    node10.sonNodes = nil;
    node10.isExpanded = FALSE;//关闭状态
    subCellModel *model10 = [[subCellModel alloc]init];
    model10.name = @"车辆类型";
    model10.BtnArr = [NSMutableArray arrayWithObjects:@" 按 揭  ",@" 全 款  ", nil];
    model10.type = 1;
    if (self.CRMModel.asset_car_type) {
        model10.index = [self.CRMModel.asset_car_type integerValue];
    } else {
        model10.index = 0;
    }
    node10.nodeData = model10;
    
    
    TreeViewNode *node11 = [[TreeViewNode alloc]init];
    node11.nodeLevel = 2;//根层cell
    node11.type = 3;//type 5的cell
    node11.sonNodes = nil;
    node11.isExpanded = FALSE;//关闭状态
    subCellModel *model11 = [[subCellModel alloc]init];
    model11.name = @"购买价格／万元";
    model11.identification = @"购车价格";
    model11.BtnArr = [NSMutableArray arrayWithObjects:@"<20",@"20-60",@">60",@"其他", nil];
    model11.type = 4;
    model11.KeyType = 2;
    if (self.CRMModel.asset_car_totalRange) {
        model11.index = [self.CRMModel.asset_car_totalRange integerValue];
    } else {
        model11.index = 0;
    }
    node11.nodeData = model11;
    
    
    TreeViewNode *node12 = [[TreeViewNode alloc]init];
    node12.nodeLevel = 2;//根层cell
    node12.type = 2;//type 2的cell
    node12.sonNodes = nil;
    node12.isExpanded = FALSE;//关闭状态
    subCellModel *model12 = [[subCellModel alloc]init];
    model12.name = @"购买价格／万元";
    model12.identification = @"购车总价格";
    model12.BtnArr = nil;
    model12.KeyType = 1;
    model12.type = 2;
    model12.index = 0;
    if (![self.CRMModel.asset_car_price isEqual:@"(null)"]) {
        model12.TFText = self.CRMModel.asset_car_price;;
    }
    node12.nodeData = model12;
    
    
    TreeViewNode *node13 = [[TreeViewNode alloc]init];
    node13.nodeLevel = 2;//根层cell
    node13.type = 3;//type 1的cell
    node13.sonNodes = nil;
    node13.isExpanded = FALSE;//关闭状态
    subCellModel *model13 = [[subCellModel alloc]init];
    model13.name = @"月 供／元";
    model13.identification = @"购车月供";
    model13.BtnArr = [NSMutableArray arrayWithObjects:@"<1500",@"1500-3000",@">3000",@"其他", nil];
    model13.type = 4;
    model13.KeyType = 1;
    if (self.CRMModel.asset_car_monRange) {
        model13.index = [self.CRMModel.asset_car_monRange integerValue];
    } else {
        model13.index = 0;
    }
    node13.nodeData = model13;
    
    
    
    TreeViewNode *node14 = [[TreeViewNode alloc]init];
    node14.nodeLevel = 2;//根层cell
    node14.type = 2;//type 1的cell
    node14.sonNodes = nil;
    node14.isExpanded = FALSE;//关闭状态
    subCellModel *model14 = [[subCellModel alloc]init];
    model14.name = @"月 供／元";
    model14.identification = @"车辆月供";
    model14.KeyType = 1;
    model14.BtnArr = nil;
    model14.type = 2;
    model14.index = 0;
    if (![self.CRMModel.asset_car_month isEqual:@"(null)"]) {
        model14.TFText = self.CRMModel.asset_car_month;
    }
    node14.nodeData = model14;
    
    
    
    TreeViewNode *node15 = [[TreeViewNode alloc]init];
    node15.nodeLevel = 2;//根层cell
    node15.type = 3;//type 1的cell
    node15.sonNodes = nil;
    node15.isExpanded = FALSE;//关闭状态
    subCellModel *model15 = [[subCellModel alloc]init];
    model15.name = @"购买日期";
    model15.identification = @"购房日期";
    model15.BtnArr = [NSMutableArray arrayWithObjects:@"<1年",@"1-3年",@">3年", nil];
    model15.type = 4;
    model15.index = 0;//asset_house_dateRange
    if (self.CRMModel.asset_house_dateRange) {
        model15.index = [self.CRMModel.asset_house_dateRange integerValue];
    } else {
        model15.index = 0;
    }
    node15.nodeData = model15;
    
    DLog(@"self.CRMModel.asset_house_type == %@",self.CRMModel.asset_house_type);
    DLog(@"self.CRMModel.asset_car_type == %@",self.CRMModel.asset_car_type);
    
    if ([self.CRMModel.asset_house_type isEqualToString:@"1"]) {
        isAddHouseInstallment = 1;
        if ([self.CRMModel.asset_house_totalPrice isEqualToString:@"4"]) {
            isAddHouseTotal = 1;
            node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node5,node6,node8,node9, nil];
            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
                isAddHouseMonth = 1;
                node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node5,node6,node7,node8,node9, nil];
            }
        } else {
            node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node6,node8,node9, nil];
            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
                isAddHouseMonth = 1;
                node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node6,node7,node8,node9, nil];
            }
        }
    } else {
        if ([self.CRMModel.asset_house_totalPrice isEqualToString:@"4"]) {
            isAddHouseTotal = 1;
            node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node5,node8,node9, nil];
            //            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
            //                isAddHouseMonth = 1;
            //                node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node5,node8,node9, nil];
            //            }
        } else {
            node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node8,node9, nil];
            //            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
            //                node16.sonNodes = [NSMutableArray arrayWithObjects:node3,node4,node5,node8,node9, nil];
            //            }
        }
    }
    
    if ([self.CRMModel.asset_car_type isEqualToString:@"1"]) {
        isAddCarInstallment = 1;
        if ([self.CRMModel.asset_car_totalRange isEqualToString:@"4"]) {
            isAddCarTotal = 1;
            node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node12,node13,node15, nil];
            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
                isAddCarMonth = 1;
                node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node12,node13,node14,node15, nil];
            }
        } else {
            node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node13,node15, nil];
            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
                isAddCarMonth = 1;
                node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node13,node14,node15, nil];
            }
        }
    } else {
        if ([self.CRMModel.asset_car_totalRange isEqualToString:@"4"]) {
            isAddCarTotal = 1;
            node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node12,node15, nil];
            //            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
            //                isAddCarMonth = 1;
            //                node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node12,node15, nil];
            //            }
        } else {
            node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node15, nil];
            //            if ([self.CRMModel.asset_house_monRange isEqualToString:@"4"]) {
            //                node17.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node15, nil];
            //            }
        }
    }
    
    node2.sonNodes = [NSMutableArray arrayWithObjects:node16,node17,nil];
    
    [_dataArray addObject:node2];
    
}
- (void)addWorkInfoData {
    TreeViewNode *node3 = [[TreeViewNode alloc]init];
    node3.nodeLevel = 0;//根层cell
    node3.type = 0;//type 1的cell
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;//关闭状态
    superCellModel *model3 = [[superCellModel alloc]init];
    model3.name = @"工作信息";
    node3.nodeData = model3;
    
    TreeViewNode *node4 = [[TreeViewNode alloc]init];
    node4.nodeLevel = 1;//根层cell
    node4.type = 2;//type 1的cell
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;//关闭状态
    subCellModel *model4 = [[subCellModel alloc]init];
    model4.name = @"单位名称";
    model4.identification = @"本人单位名称";
    model4.BtnArr = nil;
    model4.type = 2;
    model4.KeyType = 3;
    model4.index = 0;
    if (![self.CRMModel.work_name isEqual:@"(null)"]) {
        model4.TFText = self.CRMModel.work_name;
    }
    node4.nodeData = model4;
    
    TreeViewNode *node5 = [[TreeViewNode alloc]init];
    node5.nodeLevel = 1;//根层cell
    node5.type = 2;//type 1的cell
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;//关闭状态
    subCellModel *model5 = [[subCellModel alloc]init];
    model5.name = @"单位地址";
    model5.identification = @"本人单位地址";
    model5.BtnArr = nil;
    model5.type = 2;
    model5.KeyType = 3;
    model5.index = 0;
    if (![self.CRMModel.work_address isEqual:@"(null)"]) {
        model5.TFText = self.CRMModel.work_address;
    }
    node5.nodeData = model5;
    
    //    TreeViewNode *node6 = [[TreeViewNode alloc]init];
    //    node6.nodeLevel = 1;//根层cell
    //    node6.type = 2;//type 1的cell
    //    node6.sonNodes = nil;
    //    node6.isExpanded = FALSE;//关闭状态
    //    subCellModel *model6 = [[subCellModel alloc]init];
    //    model6.name = @"单位性质";
    //    model6.BtnArr = [NSMutableArray arrayWithObjects:@"行政事业单位、社会团体",@"国企",@"民企",@"外资",@"合资",@"私营",@"个体", nil];
    //    model6.type = 1;
    //    if (self.CRMModel.work_type != nil) {
    //        model6.index = [self.CRMModel.work_type integerValue];
    //    } else {
    //        model6.index = 0;
    //    }
    //    node6.nodeData = model6;
    
    TreeViewNode *node7 = [[TreeViewNode alloc]init];
    node7.nodeLevel = 1;//根层cell
    node7.type = 2;//type 1的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    subCellModel *model7 = [[subCellModel alloc]init];
    model7.name = @"所属行业";
    model7.BtnArr = nil;
    model7.type = 2;
    model7.index = 0;
    model7.KeyType = 3;
    if (![self.CRMModel.work_industry isEqual:@"(null)"]) {
        model7.TFText = self.CRMModel.work_industry;
    }
    node7.nodeData = model7;
    
    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    node8.nodeLevel = 1;//根层cell
    node8.type = 2;//type 1的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    subCellModel *model8 = [[subCellModel alloc]init];
    model8.name = @"单位电话";
    model8.identification = @"本人单位电话";
    model8.BtnArr = nil;
    model8.type = 2;
    model8.KeyType = 1;
    model8.index = 0;
    if (![self.CRMModel.work_tel isEqual:@"(null)"]) {
        model8.TFText = self.CRMModel.work_tel;
    }
    node8.nodeData = model8;
    
    TreeViewNode *node9 = [[TreeViewNode alloc]init];
    node9.nodeLevel = 1;//根层cell
    node9.type = 2;//type 1的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    subCellModel *model9 = [[subCellModel alloc]init];
    model9.name = @"所属部门";
    model9.BtnArr = nil;
    model9.type = 2;
    model9.KeyType = 3;
    if (![self.CRMModel.work_part isEqual:@"(null)"]) {
        model9.TFText = self.CRMModel.work_part;
    }
    model9.index = 0;
    node9.nodeData = model9;
    
    TreeViewNode *node10 = [[TreeViewNode alloc]init];
    node10.nodeLevel = 1;//根层cell
    node10.type = 2;//type 1的cell
    node10.sonNodes = nil;
    node10.isExpanded = FALSE;//关闭状态
    subCellModel *model10 = [[subCellModel alloc]init];
    model10.name = @"担任职位";
    model10.BtnArr = nil;
    model10.type = 2;
    model10.KeyType = 3;
    if (![self.CRMModel.work_job isEqual:@"(null)"]) {
        model10.TFText = self.CRMModel.work_job;
    }
    model10.index = 0;
    node10.nodeData = model10;
    
    TreeViewNode *node11 = [[TreeViewNode alloc]init];
    node11.nodeLevel = 1;//根层cell
    node11.type = 2;//type 1的cell
    node11.sonNodes = nil;
    node11.isExpanded = FALSE;//关闭状态
    subCellModel *model11 = [[subCellModel alloc]init];
    model11.name = @"入职时间";
    model11.BtnArr = nil;
    model11.type = 4;
    
    model11.index = 0;
    if (![self.CRMModel.work_date isEqual:@"(null)"]) {
        workTime = self.CRMModel.work_date;
        model11.TFText = workTime;
    }
    node11.nodeData = model11;
    
    TreeViewNode *node12 = [[TreeViewNode alloc]init];
    node12.nodeLevel = 1;//根层cell
    node12.type = 2;//type 1的cell
    node12.sonNodes = nil;
    node12.isExpanded = FALSE;//关闭状态
    subCellModel *model12 = [[subCellModel alloc]init];
    model12.name = @"月总收入/元";
    model12.BtnArr = nil;
    model12.KeyType = 1;
    model12.type = 3;
    model12.index = 0;
    if (![self.CRMModel.work_money isEqual:@"(null)"]) {
        model12.TFText = self.CRMModel.work_money;
    }
    node12.nodeData = model12;
    
    
    TreeViewNode *node14 = [[TreeViewNode alloc]init];
    node14.nodeLevel = 1;//根层cell
    node14.type = 2;//type 1的cell
    node14.sonNodes = nil;
    node14.isExpanded = FALSE;//关闭状态
    subCellModel *model14 = [[subCellModel alloc]init];
    model14.name = @"发薪形式";
    model14.BtnArr = [NSMutableArray arrayWithObjects:@" 银行代发",@" 网 银",@" 现 金", nil];
    model14.type = 1;
    if (![self.CRMModel.work_money_type isEqual:@"(null)"]) {
        model14.index = [self.CRMModel.work_money_type integerValue];
    } else {
        model14.index = 0;
    }
    
    node14.nodeData = model14;
    
    node3.sonNodes = [NSMutableArray arrayWithObjects:node4,node5,node7,node8,node9,node10,node11,node12,node14, nil];
    [_dataArray addObject:node3];
}
- (void)addLoansInfoData {
    TreeViewNode *node4 = [[TreeViewNode alloc]init];
    node4.nodeLevel = 0;//根层cell
    node4.type = 0;//type 1的cell
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;//关闭状态
    superCellModel *model4 = [[superCellModel alloc]init];
    model4.name = @"商业信息";
    node4.nodeData = model4;
    
    TreeViewNode *node5 = [[TreeViewNode alloc]init];
    node5.nodeLevel = 1;//根层cell
    node5.type = 2;//type 1的cell
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;//关闭状态
    subCellModel *model5 = [[subCellModel alloc]init];
    model5.name = @"企业类型";
    model5.BtnArr = [NSMutableArray arrayWithObjects:@"个体工商户",@"个人独资/合伙企业",@"有限责任公司",@"其他", nil];
    model5.type = 1;
    
    if (self.CRMModel.special_company_type) {
        model5.index = [self.CRMModel.special_company_type integerValue];
    } else {
        model5.index = 0;
    }
    node5.nodeData = model5;
    
    TreeViewNode *node6 = [[TreeViewNode alloc]init];
    node6.nodeLevel = 1;//根层cell
    node6.type = 2;//type 1的cell
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;//关闭状态
    subCellModel *model6 = [[subCellModel alloc]init];
    model6.name = @"成立时间";
    model6.BtnArr = nil;
    model6.type = 4;
    model6.index = 0;
    if (![self.CRMModel.special_company_date isEqual:@"(null)"]) {
        model6.TFText = self.CRMModel.special_company_date;
        self.special_company_date = self.CRMModel.special_company_date;
    }
    node6.nodeData = model6;
    
    TreeViewNode *node7 = [[TreeViewNode alloc]init];
    node7.nodeLevel = 1;//根层cell
    node7.type = 2;//type 1的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    subCellModel *model7 = [[subCellModel alloc]init];
    model7.name = @"员工人数";
    model7.UnitType = @"人";
    model7.BtnArr = nil;
    model7.KeyType = 1;
    model7.type = 3;
    if (![self.CRMModel.special_company_number isEqual:@"(null)"]) {
        model7.TFText = self.CRMModel.special_company_number;
    }
    model7.index = 0;
    node7.nodeData = model7;
    
    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    node8.nodeLevel = 1;//根层cell
    node8.type = 2;//type 1的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    subCellModel *model8 = [[subCellModel alloc]init];
    model8.name = @"月净利润";
    model8.UnitType = @"元";
    model8.BtnArr = nil;
    model8.type = 3;
    model8.KeyType = 1;
    model8.index = 0;
    if (![self.CRMModel.special_net_profit isEqual:@"(null)"]) {
        model8.TFText = self.CRMModel.special_net_profit;
    }
    node8.nodeData = model8;
    
    TreeViewNode *node9 = [[TreeViewNode alloc]init];
    node9.nodeLevel = 1;//根层cell
    node9.type = 2;//type 1的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    subCellModel *model9 = [[subCellModel alloc]init];
    model9.name = @"营业面积";
    model9.UnitType = @"m²";
    model9.KeyType = 1;
    model9.BtnArr = nil;
    model9.type = 3;
    if (![self.CRMModel.special_company_area isEqual:@"(null)"]) {
        model9.TFText = self.CRMModel.special_company_area;
    }
    model9.index = 0;
    node9.nodeData = model9;
    
    node4.sonNodes = [NSMutableArray arrayWithObjects:node5,node6,node7,node8,node9, nil];
    [_dataArray addObject:node4];
}
- (void)addContactsInfoData {
    TreeViewNode *node5 = [[TreeViewNode alloc]init];
    node5.nodeLevel = 0;//根层cell
    node5.type = 0;//type 1的cell
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;//关闭状态
    superCellModel *model5 = [[superCellModel alloc]init];
    model5.name = @"联系人信息";
    node5.nodeData = model5;
    
    TreeViewNode *node6 = [[TreeViewNode alloc]init];
    node6.nodeLevel = 1;//根层cell
    node6.type = 1;//type 1的cell
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;//关闭状态
    subCellModel *model6 = [[subCellModel alloc]init];
    model6.name = @"配偶/直系";
    model6.KeyType = 3;
    if (![self.CRMModel.person_dear isEqual:@"(null)"]) {
        model6.TFText = self.CRMModel.person_dear;
    }
    node6.nodeData = model6;
    
    TreeViewNode *node7 = [[TreeViewNode alloc]init];
    node7.nodeLevel = 1;//根层cell
    node7.type = 1;//type 1的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    subCellModel *model7 = [[subCellModel alloc]init];
    model7.name = @"直系亲属";
    if (![self.CRMModel.person_family_name isEqual:@"(null)"]) {
        model7.TFText = self.CRMModel.person_family_name;
    }
    node7.nodeData = model7;
    
    TreeViewNode *node8 = [[TreeViewNode alloc]init];
    node8.nodeLevel = 1;//根层cell
    node8.type = 1;//type 1的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    subCellModel *model8 = [[subCellModel alloc]init];
    model8.name = @"单位同事";
    if (![self.CRMModel.person_colleague_name isEqual:@"(null)"]) {
        model8.TFText = self.CRMModel.person_colleague_name;
    }
    node8.nodeData = model8;
    
    TreeViewNode *node9 = [[TreeViewNode alloc]init];
    node9.nodeLevel = 1;//根层cell
    node9.type = 1;//type 1的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    subCellModel *model9 = [[subCellModel alloc]init];
    model9.name = @"其他联系人";
    if (![self.CRMModel.person_other_name isEqual:@"(null)"]) {
        model9.TFText = self.CRMModel.person_other_name;
    }
    node9.nodeData = model9;
    
    TreeViewNode *node10 = [[TreeViewNode alloc]init];
    node10.nodeLevel = 2;//根层cell
    node10.type = 2;//type 1的cell
    node10.sonNodes = nil;
    node10.isExpanded = FALSE;//关闭状态
    subCellModel *model10 = [[subCellModel alloc]init];
    model10.name = @"身份证号码";
    model10.KeyType = 1;
    model10.BtnArr = nil;
    model10.type = 2;
    model10.index = 0;
    if (![self.CRMModel.person_id_card isEqual:@"(null)"]) {
        model10.TFText = self.CRMModel.person_id_card;
    }
    node10.nodeData = model10;
    
    TreeViewNode *node11 = [[TreeViewNode alloc]init];
    node11.nodeLevel = 2;//根层cell
    node11.type = 2;//type 1的cell
    node11.sonNodes = nil;
    node11.isExpanded = FALSE;//关闭状态
    subCellModel *model11 = [[subCellModel alloc]init];
    model11.name = @"手机号码";
    model11.identification = @"配偶手机号码";
    model11.BtnArr = nil;
    model11.KeyType = 1;
    model11.type = 2;
    model11.index = 0;
    if (![self.CRMModel.person_mobile isEqual:@"(null)"]) {
        model11.TFText = self.CRMModel.person_mobile;
    }
    node11.nodeData = model11;
    
    TreeViewNode *node12 = [[TreeViewNode alloc]init];
    node12.nodeLevel = 2;//根层cell
    node12.type = 2;//type 1的cell
    node12.sonNodes = nil;
    node12.isExpanded = FALSE;//关闭状态
    subCellModel *model12 = [[subCellModel alloc]init];
    model12.name = @"单位名称";
    model12.identification = @"配偶单位名称";
    model12.BtnArr = nil;
    model12.type = 2;
    model12.index = 0;
    if (![self.CRMModel.person_company_name isEqual:@"(null)"]) {
        model12.TFText = self.CRMModel.person_company_name;
    }
    node12.nodeData = model12;
    
    TreeViewNode *node13 = [[TreeViewNode alloc]init];
    node13.nodeLevel = 2;//根层cell
    node13.type = 2;//type 1的cell
    node13.sonNodes = nil;
    node13.isExpanded = FALSE;//关闭状态
    subCellModel *model13 = [[subCellModel alloc]init];
    model13.name = @"单位地址";
    model13.identification = @"配偶单位地址";
    model13.BtnArr = nil;
    model13.type = 2;
    model13.index = 0;
    if (![self.CRMModel.person_company_address isEqual:@"(null)"]) {
        model13.TFText = self.CRMModel.person_company_address;
    }
    node13.nodeData = model13;
    
    TreeViewNode *node14 = [[TreeViewNode alloc]init];
    node14.nodeLevel = 2;//根层cell
    node14.type = 2;//type 1的cell
    node14.sonNodes = nil;
    node14.isExpanded = FALSE;//关闭状态
    subCellModel *model14 = [[subCellModel alloc]init];
    model14.name = @"单位电话";
    model14.identification = @"配偶单位电话";
    model14.BtnArr = nil;
    model14.type = 2;
    model14.KeyType = 1;
    model14.index = 0;
    if (![self.CRMModel.person_company_tel isEqual:@"(null)"]) {
        model14.TFText = self.CRMModel.person_company_tel;
    }
    node14.nodeData = model14;
    
    TreeViewNode *node15 = [[TreeViewNode alloc]init];
    node15.nodeLevel = 2;//根层cell
    node15.type = 2;//type 1的cell
    node15.sonNodes = nil;
    node15.isExpanded = FALSE;//关闭状态
    subCellModel *model15 = [[subCellModel alloc]init];
    model15.name = @"居住地址";
    model15.identification = @"配偶居住地址";
    model15.BtnArr = nil;
    model15.type = 2;
    model15.index = 0;
    if (![self.CRMModel.person_address isEqual:@"(null)"]) {
        model15.TFText = self.CRMModel.person_address;
    }
    node15.nodeData = model15;
    
    node6.sonNodes = [NSMutableArray arrayWithObjects:node10,node11,node12,node13,node14,node15, nil];
    
    TreeViewNode *node16 = [[TreeViewNode alloc]init];
    node16.nodeLevel = 2;//根层cell
    node16.type = 2;//type 1的cell
    node16.sonNodes = nil;
    node16.isExpanded = FALSE;//关闭状态
    subCellModel *model16 = [[subCellModel alloc]init];
    model16.name = @"关        系";
    model16.identification = @"直系关系";
    model16.BtnArr = nil;
    model16.type = 2;
    model16.index = 0;
    if (![self.CRMModel.person_family_ship isEqual:@"(null)"]) {
        model16.TFText = self.CRMModel.person_family_ship;
    }
    node16.nodeData = model16;
    
    TreeViewNode *node17 = [[TreeViewNode alloc]init];
    node17.nodeLevel = 2;//根层cell
    node17.type = 2;//type 1的cell
    node17.sonNodes = nil;
    node17.isExpanded = FALSE;//关闭状态
    subCellModel *model17 = [[subCellModel alloc]init];
    model17.name = @"手机号码";
    model17.identification = @"直系手机号码";
    model17.BtnArr = nil;
    model17.type = 2;
    model17.KeyType = 1;
    model17.index = 0;
    if (![self.CRMModel.person_family_moblie isEqual:@"(null)"]) {
        model17.TFText = self.CRMModel.person_family_moblie;
    }
    node17.nodeData = model17;
    
    TreeViewNode *node18 = [[TreeViewNode alloc]init];
    node18.nodeLevel = 2;//根层cell
    node18.type = 2;//type 1的cell
    node18.sonNodes = nil;
    node18.isExpanded = FALSE;//关闭状态
    subCellModel *model18 = [[subCellModel alloc]init];
    model18.name = @"单位名称";
    model18.identification = @"直系单位名称";
    model18.BtnArr = nil;
    model18.type = 2;
    model18.index = 0;
    if (![self.CRMModel.person_family_company isEqual:@"(null)"]) {
        model18.TFText = self.CRMModel.person_family_company;
    }
    node18.nodeData = model18;
    
    node7.sonNodes = [NSMutableArray arrayWithObjects:node16,node17,node18, nil];
    
    TreeViewNode *node19 = [[TreeViewNode alloc]init];
    node19.nodeLevel = 2;//根层cell
    node19.type = 2;//type 1的cell
    node19.sonNodes = nil;
    node19.isExpanded = FALSE;//关闭状态
    subCellModel *model19 = [[subCellModel alloc]init];
    model19.name = @"职        位";
    model19.identification = @"同事职位";
    model19.BtnArr = nil;
    model19.type = 2;
    model19.index = 0;
    if (![self.CRMModel.person_colleague_work isEqual:@"(null)"]) {
        model19.TFText = self.CRMModel.person_colleague_work;
    }
    node19.nodeData = model19;
    
    TreeViewNode *node20 = [[TreeViewNode alloc]init];
    node20.nodeLevel = 2;//根层cell
    node20.type = 2;//type 1的cell
    node20.sonNodes = nil;
    node20.isExpanded = FALSE;//关闭状态
    subCellModel *model20 = [[subCellModel alloc]init];
    model20.name = @"手机号码";
    model20.identification = @"同事手机号码";
    model20.BtnArr = nil;
    model20.KeyType = 1;
    model20.type = 2;
    model20.index = 0;
    if (![self.CRMModel.person_colleague_moblie isEqual:@"(null)"]) {
        model20.TFText = self.CRMModel.person_colleague_moblie;
    }
    node20.nodeData = model20;
    
    TreeViewNode *node21 = [[TreeViewNode alloc]init];
    node21.nodeLevel = 2;//根层cell
    node21.type = 2;//type 1的cell
    node21.sonNodes = nil;
    node21.isExpanded = FALSE;//关闭状态
    subCellModel *model21 = [[subCellModel alloc]init];
    model21.name = @"单位名称";
    model21.identification = @"同事单位名称";
    model21.BtnArr = nil;
    model21.type = 2;
    model21.index = 0;
    if (![self.CRMModel.person_colleague_company isEqual:@"(null)"]) {
        model21.TFText = self.CRMModel.person_colleague_company;
    }
    node21.nodeData = model21;
    
    node8.sonNodes = [NSMutableArray arrayWithObjects:node19,node20,node21, nil];
    
    TreeViewNode *node22 = [[TreeViewNode alloc]init];
    node22.nodeLevel = 2;//根层cell
    node22.type = 2;//type 1的cell
    node22.sonNodes = nil;
    node22.isExpanded = FALSE;//关闭状态
    subCellModel *model22 = [[subCellModel alloc]init];
    model22.name = @"关        系";
    model22.identification = @"其他联系人关系";
    model22.BtnArr = nil;
    model22.type = 2;
    model22.index = 0;
    if (![self.CRMModel.person_other_ship isEqual:@"(null)"]) {
        model22.TFText = self.CRMModel.person_other_ship;
    }
    node22.nodeData = model22;
    
    TreeViewNode *node23 = [[TreeViewNode alloc]init];
    node23.nodeLevel = 2;//根层cell
    node23.type = 2;//type 1的cell
    node23.sonNodes = nil;
    node23.isExpanded = FALSE;//关闭状态
    subCellModel *model23 = [[subCellModel alloc]init];
    model23.name = @"手机号码";
    model23.identification = @"其他联系人手机号码";
    model23.BtnArr = nil;
    model23.KeyType = 1;
    model23.type = 2;
    model23.index = 0;
    if (![self.CRMModel.person_other_moblie isEqual:@"(null)"]) {
        model23.TFText = self.CRMModel.person_other_moblie;
    }
    node23.nodeData = model23;
    
    TreeViewNode *node24 = [[TreeViewNode alloc]init];
    node24.nodeLevel = 2;//根层cell
    node24.type = 2;//type 1的cell
    node24.sonNodes = nil;
    node24.isExpanded = FALSE;//关闭状态
    subCellModel *model24 = [[subCellModel alloc]init];
    model24.name = @"单位名称";
    model24.identification = @"其他联系人单位名称";
    model24.BtnArr = nil;
    model24.type = 2;
    model24.index = 0;
    if (![self.CRMModel.person_other_company isEqual:@"(null)"]) {
        model24.TFText = self.CRMModel.person_other_company;
    }
    node24.nodeData = model24;
    
    node9.sonNodes = [NSMutableArray arrayWithObjects:node22,node23,node24, nil];
    
    
    TreeViewNode *node25 = [[TreeViewNode alloc]init];
    node25.nodeLevel = 1;//根层cell
    node25.type = 2;//type 1的cell
    node25.sonNodes = nil;
    node25.isExpanded = FALSE;//关闭状态
    subCellModel *model25 = [[subCellModel alloc]init];
    model25.name = @"以上哪些联系人可以知晓贷款";
    model25.BtnArr = nil;
    model25.type = 2;
    model25.index = 0;
    if (![self.CRMModel.person_know isEqual:@"(null)"]) {
        model25.TFText = self.CRMModel.person_know;
    }
    node25.nodeData = model25;
    
    TreeViewNode *node26 = [[TreeViewNode alloc]init];
    node26.nodeLevel = 1;//根层cell
    node26.type = 2;//type 1的cell
    node26.sonNodes = nil;
    node26.isExpanded = FALSE;//关闭状态
    subCellModel *model26 = [[subCellModel alloc]init];
    model26.name = @"共同借款人";
    model26.BtnArr = [NSMutableArray arrayWithObjects:@"有   ",@"无   ", nil];
    model26.type = 1;
    
    if (self.CRMModel.person_together) {
        
        model26.index = [self.CRMModel.person_together integerValue];
    } else {
        
        model26.index = 0;
    }
    node26.nodeData = model26;
    
    TreeViewNode *node1 = [[TreeViewNode alloc]init];
    node1.nodeLevel = 1;//根层cell
    node1.type = 2;//type 1的cell
    node1.sonNodes = nil;
    node1.isExpanded = FALSE;//关闭状态
    subCellModel *model1 = [[subCellModel alloc]init];
    model1.name = @"姓名";
    model1.identification = @"共同借款人姓名";
    model1.BtnArr = nil;
    model1.type = 2;
    model1.index = 0;
    if (![self.CRMModel.person_together_name isEqual:@"(null)"]) {
        model1.TFText = self.CRMModel.person_together_name;
    }
    node1.nodeData = model1;
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if ([self.CRMModel.person_together isEqualToString:@"1"]) {
            node5.sonNodes = [NSMutableArray arrayWithObjects:node6,node7,node8,node9,node25,node26,node1, nil];
            isAddTogether = 1;
            
        } else {
            isAddTogether = 0;
            node5.sonNodes = [NSMutableArray arrayWithObjects:node6,node7,node8,node9,node25,node26, nil];
        }
    } else {
        isAddTogether = 0;
        node5.sonNodes = [NSMutableArray arrayWithObjects:node6,node7,node8,node9, nil];
    }
    
    
    [_dataArray addObject:node5];
    
    
    TreeViewNode *node27 = [[TreeViewNode alloc]init];
    node27.nodeLevel = 1;//根层cell
    node27.type = 2;//type 1的cell
    node27.sonNodes = nil;
    node27.isExpanded = FALSE;//关闭状态
    subCellModel *model27 = [[subCellModel alloc]init];
    model27.name = @"客户来源";
    model27.BtnArr = [NSMutableArray arrayWithObjects:@" 报  纸",@" 促销活动",@" 网  络",@" 朋友介绍",@" 老客户介绍",@" 老客户续贷",@" 其  他", nil];
    model27.type = 1;
    if (self.CRMModel.source) {
        model27.index = [self.CRMModel.source integerValue];
    } else {
        model27.index = 0;
    }
    
    node27.nodeData = model27;
    
    TreeViewNode *node28 = [[TreeViewNode alloc]init];
    node28.nodeLevel = 1;//根层cell
    node28.type = 2;//type 1的cell
    node28.sonNodes = nil;
    node28.isExpanded = FALSE;//关闭状态
    subCellModel *model28 = [[subCellModel alloc]init];
    model28.name = @"融资顾问";
    model28.BtnArr = nil;
    if (![self.CRMModel.real_name isEqual:@"(null)"]) {
        headPeopleName = self.CRMModel.real_name;
        self.adviserId = self.CRMModel.adviserId;
    }
    model28.type = 4;
    model28.index = 0;
    node28.nodeData = model28;
    
    //    TreeViewNode *node29 = [[TreeViewNode alloc]init];
    //    node29.nodeLevel = 1;//根层cell
    //    node29.type = 2;//type 1的cell
    //    node29.sonNodes = nil;
    //    node29.isExpanded = FALSE;
    //    subCellModel *model29 = [[subCellModel alloc]init];
    //    model29.name = @"融资方案";
    //    model29.BtnArr = nil;
    //    model29.type = 2;
    //    model29.index = 0;
    //    if (![self.CRMModel.adviserPlan isEqual:@"(null)"]) {
    //        model29.TFText = self.CRMModel.adviserPlan;
    //    }
    //    node29.nodeData = model29;
    
    TreeViewNode *node29 = [[TreeViewNode alloc]init];
    node29.nodeLevel = 0;//根层cell
    node29.type = 0;//type 1的cell
    node29.sonNodes = nil;
    if ([Utils isBlankString:self.CRMModel.adviserPlan]) {
        node29.isExpanded = FALSE;//关闭状态
    } else {
        node29.isExpanded = 1;//关闭状态
        self.isProject = 1;
    }
    superCellModel *model29 = [[superCellModel alloc]init];
    model29.name = @"融资方案";
    node29.nodeData = model29;
    
    
    TreeViewNode *node35 = [[TreeViewNode alloc]init];
    node35.nodeLevel = 1;//根层cell
    node35.type = 2;//type 1的cell
    node35.sonNodes = nil;
    node35.isExpanded = FALSE;//关闭状态
    subCellModel *model35 = [[subCellModel alloc]init];
    model35.name = @"方案";
    model35.BtnArr = nil;
    //    model34.UnitType = @"万元";
    model35.type = 2;
    model35.index = 0;
    if (![self.CRMModel.adviserPlan isEqual:@"(null)"]) {
        model35.TFText = self.CRMModel.adviserPlan;
        CGSize titleSize = [self.CRMModel.adviserPlan boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        if (titleSize.height <= 200.0) {
            self.projectHeight = 200.0;
        } else {
            self.projectHeight = titleSize.height;
        }
        
    }
    node35.nodeData = model35;
    node29.sonNodes = [NSMutableArray arrayWithObjects:node35, nil];
    
    TreeViewNode *node30 = [[TreeViewNode alloc]init];
    node30.nodeLevel = 1;//根层cell
    node30.type = 2;//type 1的cell
    node30.sonNodes = nil;
    node30.isExpanded = FALSE;//关闭状态
    subCellModel *model30 = [[subCellModel alloc]init];
    model30.name = @"融资金额";
    model30.BtnArr = nil;
    model30.UnitType = @"万元";
    model30.type = 3;
    model30.KeyType = 1;
    model30.index = 0;
    if (![self.CRMModel.money isEqual:@"(null)"]) {
        model30.TFText = self.CRMModel.money;
    }
    node30.nodeData = model30;
    
    TreeViewNode *node31 = [[TreeViewNode alloc]init];
    node31.nodeLevel = 1;//根层cell
    node31.type = 2;//type 1的cell
    node31.sonNodes = nil;
    node31.isExpanded = FALSE;//关闭状态
    subCellModel *model31 = [[subCellModel alloc]init];
    model31.name = @"申请产品";
    model31.BtnArr = nil;
    model31.type = 4;
    model31.index = 0;
    
    node31.nodeData = model31;
    
    TreeViewNode *node32 = [[TreeViewNode alloc]init];
    node32.nodeLevel = 1;//根层cell
    node32.type = 2;//type 1的cell
    node32.sonNodes = nil;
    node32.isExpanded = FALSE;//关闭状态
    subCellModel *model32 = [[subCellModel alloc]init];
    model32.name = @"贷款用途";
    model32.BtnArr = [NSMutableArray arrayWithObjects:@" 经  营",@" 消  费", nil];
    model32.type = 1;
    
    if (self.CRMModel.purpose) {
        model32.index = [self.CRMModel.purpose integerValue];
    } else {
        model32.index = 0;
    }
    node32.nodeData = model32;
    
    
    
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        [_dataArray addObject:node27];
        [_dataArray addObject:node28];
        [_dataArray addObject:node29];
        [_dataArray addObject:node30];
        [_dataArray addObject:node31];
        [_dataArray addObject:node32];
    }
    
    
    
    
    TreeViewNode *node33 = [[TreeViewNode alloc]init];
    node33.nodeLevel = 0;//根层cell
    node33.type = 0;//type 1的cell
    node33.sonNodes = nil;
    if (!self.remarkListArr.count) {
        node33.isExpanded = FALSE;//关闭状态
    } else {
        node33.isExpanded = 1;//关闭状态
        self.isRemark = 1;
    }
    superCellModel *model33 = [[superCellModel alloc]init];
    model33.name = @"备       注";
    node33.nodeData = model33;
    
    TreeViewNode *node34 = [[TreeViewNode alloc]init];
    node34.nodeLevel = 1;//根层cell
    node34.type = 2;//type 1的cell
    node34.sonNodes = nil;
    node34.isExpanded = FALSE;//关闭状态
    subCellModel *model34 = [[subCellModel alloc]init];
    model34.name = @"备注";
    model34.BtnArr = nil;
    //    model34.UnitType = @"万元";
    model34.type = 2;
    //    model33.KeyType = 1;
    model34.index = 0;
    if (![self.CRMModel.remark isEqual:@"(null)"]) {
        model34.TFText = @"";
        CGSize titleSize = [self.CRMModel.remark boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        if (titleSize.height <= 200.0) {
            self.remarkHeight = 200.0;
        } else {
            self.remarkHeight = titleSize.height;
        }
        self.remarkHeight = 200.0;
    }
    node34.nodeData = model34;
    node33.sonNodes = [NSMutableArray arrayWithObjects:node34, nil];
    
    for (reamrkModel *remarkModel in self.remarkListArr) {
        TreeViewNode *node = [[TreeViewNode alloc]init];
        node.nodeLevel = 1;//根层cell
        node.type = 2;//type 1的cell
        node.sonNodes = nil;
        node.isExpanded = FALSE;//关闭状态
        subCellModel *model = [[subCellModel alloc]init];
        model.name = @"备注历史";
        model.BtnArr = nil;
        //    model34.UnitType = @"万元";
        model.type = 2;
        //    model33.KeyType = 1;
        model.index = 0;
        if (![Utils isBlankString:remarkModel.remark]) {
            model.TFText = remarkModel.remark;
            CGSize titleSize = [remarkModel.remark boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            
            if (titleSize.height <= 55.0) {
                model.rowHeight = 55.0;
            } else {
                model.rowHeight = titleSize.height;
            }
            
        }
        node.nodeData = model;
        [node33.sonNodes addObject:node];
    }
    
    [_dataArray addObject:node33];
}
/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */

-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSMutableArray *tmpSectionOne = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(TreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(TreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    for (TreeViewNode *node in _sectionOneDataArray) {
        [tmpSectionOne addObject:node];
        if(node.isExpanded){
            for(TreeViewNode *node2 in node.sonNodes){
                [tmpSectionOne addObject:node2];
                if(node2.isExpanded){
                    for(TreeViewNode *node3 in node2.sonNodes){
                        [tmpSectionOne addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    _sectionOneDisplayArray = [NSArray arrayWithArray:tmpSectionOne];
    DLog(@"_sectionOneDisplayArray.count == %ld",_sectionOneDisplayArray.count);
    [self.CRMDetailsTableView reloadData];
}
#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (self.seType == 1) {
            
            if (latest == 1) {
                return 4;
            } else {
                return 3;
            }
        } else {
            return 3;
        }
    } else {
        if (self.seType == 1) {
            if (latest == 1) {
                return 3;
            } else {
                return 2;
            }
        } else {
            return 2;
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (section == 0) {
            return 2;
        } else if(section == 1) {
            return _sectionOneDisplayArray.count;
        }else if (section == 2) {
            return _displayArray.count;
        } else if (section == 3) {
            return self.cusrecordListArr.count;
        }
    } else {
        if (section == 0) {
            return 2;
        }else if (section == 1) {
            return _displayArray.count;
        }else if (section == 2) {
            return self.cusrecordListArr.count;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (section == 0) {
            return 12;
        }else if (section == 1) {
            return 12;
        }else if (section == 2) {
            if (self.seType == 1) {
                return 44;
            } else {
                return 0.1;
            }
        } else{
            return 0.1;
        }
    } else {
        if (section == 0) {
            return 12;
        }else if (section == 1) {
            if (self.seType == 1) {
                return 44;
            } else {
                return 0.1;
            }
        } else{
            return 0.1;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (self.seType == 1) {
            if (section == 2) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                view.backgroundColor = [UIColor whiteColor];
                UILabel *titleLB = [[UILabel alloc] init];
                titleLB.textColor = [UIColor grayColor];
                titleLB.font = [UIFont systemFontOfSize:17];
                [view addSubview:titleLB];
                titleLB.text = @"最新动态";
                [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).offset(10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.height.mas_equalTo(17);
                }];
                UIImageView *arrowView = [[UIImageView alloc] init];
                if (latest == 0) {
                    arrowView.image = [UIImage imageNamed:@"箭头（下）"];
                } else {
                    arrowView.image = [UIImage imageNamed:@"箭头（上）"];
                }
                [view addSubview:arrowView];
                [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right).offset(-20*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.height.mas_equalTo(8);
                    make.width.mas_equalTo(13);
                }];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = [UIColor clearColor];
                [view addSubview:btn];
                [btn addTarget:self action:@selector(latestBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(0, 0, kScreenWidth, 44);
                
                return view;
            } else  if (section == 0 || section == 1) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
                view.backgroundColor = VIEW_BASE_COLOR;
                return view;
            }
        } else {
            if (section == 0 || section == 1) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
                view.backgroundColor = VIEW_BASE_COLOR;
                return view;
            }
        }
    } else {
        if (self.seType == 1) {
            if (section == 1) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
                view.backgroundColor = [UIColor whiteColor];
                UILabel *titleLB = [[UILabel alloc] init];
                titleLB.textColor = [UIColor grayColor];
                titleLB.font = [UIFont systemFontOfSize:17];
                [view addSubview:titleLB];
                titleLB.text = @"最新动态";
                [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left).offset(10*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.height.mas_equalTo(17);
                }];
                UIImageView *arrowView = [[UIImageView alloc] init];
                if (latest == 0) {
                    arrowView.image = [UIImage imageNamed:@"箭头（下）"];
                } else {
                    arrowView.image = [UIImage imageNamed:@"箭头（上）"];
                }
                [view addSubview:arrowView];
                [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(view.mas_right).offset(-20*KAdaptiveRateWidth);
                    make.centerY.mas_equalTo(view.mas_centerY);
                    make.height.mas_equalTo(8);
                    make.width.mas_equalTo(13);
                }];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.backgroundColor = [UIColor clearColor];
                [view addSubview:btn];
                [btn addTarget:self action:@selector(latestBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(0, 0, kScreenWidth, 44);
                
                return view;
            } else  if (section == 0 ) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
                view.backgroundColor = VIEW_BASE_COLOR;
                return view;
            }
        } else {
            if (section == 0 || section == 1) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
                view.backgroundColor = VIEW_BASE_COLOR;
                return view;
            }
        }
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (void)latestBtn:(UIButton*)btn {
    if (latest == 0) {
        latest = 1;
        [self.CRMDetailsTableView reloadData];
        if (self.cusrecordListArr.count >0 ) {
            if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                [self.CRMDetailsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//UITableViewScrollPositionBottom
            } else {
                [self.CRMDetailsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//UITableViewScrollPositionBottom
            }
        }
    } else {
        latest = 0;
        [self.CRMDetailsTableView reloadData];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (indexPath.section == 1) {
            if (isAddOccType == 1) {
                if (indexPath.row == 1) {
                    return 110;
                }
            }
        }
        
        if (self.isPersonalInfo == 1) {
            if (indexPath.section == 2 && indexPath.row == 4) {
                return  80;
            }
            if (indexPath.section == 2 && indexPath.row == 6) {
                return  80;
            }
            
        }
        if (self.isAssetInfo == 1) {
            if (self.isHouseInfo == 1) {
                
                if (indexPath.section == 2 && indexPath.row == 3+personalInfoCount+1){
                    return 80;
                }
                if (isAddHouseTotal == 1) {
                    if (isAddHouseInstallment == 1) {
                        if (indexPath.section == 2 && indexPath.row == 3+personalInfoCount+3) {
                            return 80;
                        }
                    }
                    
                } else {
                    if (isAddHouseInstallment == 1) {
                        if (indexPath.section == 2 && indexPath.row == 3+personalInfoCount+2) {
                            return 80;
                        }
                    }
                }
                
            }
            if (self.isCarInfo == 1) {
                
                if (indexPath.section == 2 && indexPath.row == 4+personalInfoCount+houseInfoCount+1){
                    return 80;
                }
                
                if (isAddCarTotal == 1) {
                    if (isAddCarInstallment == 1) {
                        if (indexPath.section == 2 && indexPath.row == 4+personalInfoCount+houseInfoCount+3 ) {
                            return 80;
                        }
                    }
                } else {
                    if (isAddCarInstallment == 1) {
                        if (indexPath.section == 2 && indexPath.row == 4+personalInfoCount+houseInfoCount+2 ) {
                            return 80;
                        }
                    }
                }
                
                
            }
        }
#pragma mark == 在这里加上    +houseInfoCount+carInfoCount
        if (self.isWorkInfo == 1) {
            //        if (indexPath.section == 1 && indexPath.row == 3+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+2) {
            //            return 80;
            //        }
        }
        //    if (isLoansInfo == 1) {
        //        if (indexPath.section == 2 && indexPath.row == 4+personalInfoCount+AssetInfoCount+workInfoCount+houseInfoCount+carInfoCount) {
        //            return 60;
        //        }
        //    }
        if (indexPath.section == 2 && indexPath.row == 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount) {
            return 140;
        }
        
        if (self.isProject == 1) {
            if (indexPath.section == 2 && indexPath.row == 7+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount) {
                return self.projectHeight;
            }
        }
        
        if (self.isRemark == 1) {
            if (indexPath.section == 2 && indexPath.row == 11+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject) {
                return self.remarkHeight;
            }
            if (indexPath.section == 2 && (indexPath.row > 11+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject && indexPath.row <= 11+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject+self.remarkListArr.count)) {
                NSInteger i = 11+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject+self.remarkListArr.count - indexPath.row;
                reamrkModel *remark = self.remarkListArr[i];
                NSString *remarkText = [NSString stringWithFormat:@"%@ : %@",remark.real_name,remark.remark];
                CGFloat height = [remarkText heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:kScreenWidth-40];
                if (height < 55) {
                    height = 55;
                }
                return height+30;
            }
        }
    } else {
        
#pragma mark == 这里非金融行业 计算行高
        if (self.isPersonalInfo == 1) {
            if (indexPath.section == 1 && indexPath.row == 4) {
                return  80;
            }
            if (indexPath.section == 1 && indexPath.row == 6) {
                return  80;
            }
            
        }
        
#pragma mark == 在这里加上    +houseInfoCount+carInfoCount
        if (self.isWorkInfo == 1) {
            //        if (indexPath.section == 1 && indexPath.row == 3+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+2) {
            //            return 80;
            //        }
        }
        //    if (isLoansInfo == 1) {
        //        if (indexPath.section == 2 && indexPath.row == 4+personalInfoCount+AssetInfoCount+workInfoCount+houseInfoCount+carInfoCount) {
        //            return 60;
        //        }
        //    }
        //        if (indexPath.section == 1 && indexPath.row == 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount) {
        //            return 140;
        //        }
        
        //        if (self.isProject == 1) {
        //            if (indexPath.section == 1 && indexPath.row == 7+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount) {
        //                return self.projectHeight;
        //            }
        //        }
        
        if (self.isRemark == 1) {
            if (indexPath.section == 1 && indexPath.row == 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject) {
                return self.remarkHeight;
            }
            if (indexPath.section == 1 && (indexPath.row > 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject && indexPath.row <= 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject+self.remarkListArr.count)) {
                NSInteger i = 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject+self.remarkListArr.count - indexPath.row;
                reamrkModel *remark = self.remarkListArr[i];
                NSString *remarkText = [NSString stringWithFormat:@"%@ : %@",remark.real_name,remark.remark];
                CGFloat height = [remarkText heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:kScreenWidth-40];
                if (height < 55) {
                    height = 55;
                }
                return height+30;
            }
        }
    }
    
    
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CRMDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstLevel"];
            if (!cell) {
                cell = [[CRMDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstLevel"];
            }
            UIView *separator = [[UIView alloc]init];
            separator.backgroundColor = GRAY229;
            [cell addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(10);
                make.right.equalTo(cell.mas_right).offset(0);
                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                make.height.mas_equalTo(0.5);
            }];
            cell.arrowView.hidden = YES;
            cell.titleLB.text = @"姓        名";
            if (isEdit) {
                cell.contentTF.userInteractionEnabled = YES;
            } else {
                cell.contentTF.userInteractionEnabled = NO;
            }
            cell.contentTF.hidden = NO;
            //cell.contentTF.textColor = GRAY90;
            
            cell.contentTF.text = userName;
            cell.contentTF.placeholder = @"客户姓名";
            cell.contentTF.delegate = self;
            [cell.contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            //cell.contentTF.font = [UIFont systemFontOfSize:19 weight:0.2];
            cell.contentTF.keyboardType = UIKeyboardTypeDefault;
            cell.contentTF.returnKeyType = UIReturnKeyDone;
            cell.contentTF.tag = (indexPath.section+1)*10+(indexPath.row+1);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        } else if (indexPath.row == 1) {
            CRMDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstLevel"];
            if (!cell) {
                cell = [[CRMDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstLevel"];
            }
            UIView *separator = [[UIView alloc]init];
            separator.backgroundColor = GRAY229;
            [cell addSubview:separator];
            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(10);
                make.right.equalTo(cell.mas_right).offset(0);
                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                make.height.mas_equalTo(0.5);
            }];
            cell.arrowView.hidden = YES;
            cell.contentTF.hidden = NO;
            if (isEdit) {
                cell.contentTF.userInteractionEnabled = YES;
            } else {
                cell.contentTF.userInteractionEnabled = NO;
            }
            
            cell.titleLB.text = @"移动电话";
            cell.contentTF.placeholder = @"手机号码";
            cell.contentTF.text = userMobile;
            //cell.contentTF.font = [UIFont systemFontOfSize:19 weight:0.2];
            cell.contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cell.contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.contentTF.returnKeyType = UIReturnKeyDone;
            cell.contentTF.tag = (indexPath.section+1)*10+(indexPath.row+1);
            cell.contentTF.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
            
            return cell;
        }
        
    } else {
#pragma mark ===  判断是否为金融行业
        if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
            if (indexPath.section == 1) {
#pragma mark == 修改的section1的cell样式
                TreeViewNode *node = [_sectionOneDisplayArray objectAtIndex:indexPath.row];
                CRMSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub"];
                if(cell == nil){
                    cell = [[CRMSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub"];
                }
                
                subCellModel *nodeData = node.nodeData;
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.node = node;
                if(node.type == 2){//类型为2的cell
                    
                    if (nodeData.BtnArr.count != 0) {
                        for (UIButton *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    } else {
                        for (UITextField *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                    UILabel *titleLB = [[UILabel alloc] init];
                    titleLB.textColor = [UIColor grayColor];
                    titleLB.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:titleLB];
                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(17);
                    }];
                    titleLB.text = nodeData.name;
                    
                    UIView *separator = [[UIView alloc]init];
                    separator.backgroundColor = GRAY229;
                    [cell addSubview:separator];
                    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(10);
                        make.right.equalTo(cell.mas_right).offset(0);
                        make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                        make.height.mas_equalTo(0.5);
                    }];
                    
                    if ([nodeData.name isEqualToString:@"单位性质"] || [nodeData.name isEqualToString:@"私营业主是否报税"] ||[nodeData.name isEqualToString:@"保险金额"]) {
                        separator.backgroundColor = [UIColor whiteColor];
                        cell.backgroundColor = kMyColor(242, 240, 255);
                    }
                    
                    for (int i=0; i<nodeData.BtnArr.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.tag = i+1;
                        if (nodeData.index == i+1) {
                            btn.selected = YES;
                        }
                        if (isEdit) {
                            btn.userInteractionEnabled = YES;
                        } else {
                            btn.userInteractionEnabled = NO;
                        }
                        [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                        [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                        [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                        btn.titleLabel.font = secondFont;
                        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                        if ([nodeData.name isEqualToString:@"单位性质"]) {
                            if (i == 0) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%1)+10*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset(9);
                                    make.height.mas_equalTo(30);
                                    
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+17*KAdaptiveRateWidth)*((i-1)%3)+10*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((31)*(((i-1)/3)+1)+9);
                                    make.height.mas_equalTo(30);
                                    
                                }];
                            }
                        } else {
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth+17*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                        
                    }
                    
                    
                    
                    
                    if (nodeData.BtnArr.count == 0 && nodeData.type == 2) {
                        separator.backgroundColor = [UIColor whiteColor];
                        if ([nodeData.name isEqualToString:@"公积金金额"]) {
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            cell.backgroundColor = VIEW_BASE_COLOR;
                            
                            
                            UITextField *contentTF = [[UITextField alloc] init];
                            contentTF.text = nodeData.TFText;
                            
                            contentTF.tag = 10003;
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                        }
                        if ([nodeData.name isEqualToString:@"保险金额/元"]) {
                            cell.backgroundColor = kMyColor(242, 240, 255);
                            UIView *separator = [[UIView alloc]init];
                            separator.backgroundColor = [UIColor whiteColor];
                            [cell addSubview:separator];
                            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.right.equalTo(cell.mas_right).offset(0);
                                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                                make.height.mas_equalTo(0.5);
                            }];
                            cell.backgroundColor = kMyColor(242, 240, 255);
                            
                            UITextField *contentTF = [[UITextField alloc] init];
                            contentTF.text = nodeData.TFText;
                            
                            contentTF.tag = 10003;
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                        }
                    }
                    
                    
                    return cell;
                }
                if (node.type == 3) {
                    
                    if ([nodeData.name isEqualToString:@"投保年限"]) {
                        cell.backgroundColor = kMyColor(242, 240, 255);
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (UILabel *lab in [cell subviews]) {
                            [lab removeFromSuperview];
                        }
                        for (UIButton *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        for (int i = 0; i < nodeData.BtnArr.count; i++) {
                            
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            
                            btn.layer.masksToBounds = YES;
                            btn.layer.cornerRadius = 5;
                            btn.layer.borderWidth = 0.5;
                            btn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
                            
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                            
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                            [btn setBackgroundImage:[UIImage imageWithColor:TABBAR_BASE_COLOR] forState:UIControlStateSelected];
                            
                            btn.titleLabel.font = [UIFont systemFontOfSize:15];
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth+(kScreenWidth-4*70*KAdaptiveRateWidth)/4.0)*i+(kScreenWidth-4*70*KAdaptiveRateWidth)/4.0);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(70*KAdaptiveRateWidth);
                                
                            }];
                        }
                    } else {
                        cell.backgroundColor = kMyColor(242, 240, 255);
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (UILabel *lab in [cell subviews]) {
                            [lab removeFromSuperview];
                        }
                        for (int i = 0; i < nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            
                            btn.layer.masksToBounds = YES;
                            btn.layer.cornerRadius = 5;
                            btn.layer.borderWidth = 0.5;
                            btn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
                            
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                            
                            [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                            [btn setBackgroundImage:[UIImage imageWithColor:TABBAR_BASE_COLOR] forState:UIControlStateSelected];
                            
                            btn.titleLabel.font = [UIFont systemFontOfSize:15];
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset((70*KAdaptiveRateWidth+(kScreenWidth-4*70*KAdaptiveRateWidth)/5.0)*i+(kScreenWidth-4*70*KAdaptiveRateWidth)/5.0);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(70*KAdaptiveRateWidth);
                            }];
                        }
                    }
                    
                    
                    return cell;
                }
            } else if (indexPath.section == 2) {
                TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
                if(node.type == 0){//类型为0的cell
                    CRMDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstLevel"];
                    if(cell == nil){
                        cell = [[CRMDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstLevel"];
                    }
                    if (node.isExpanded) {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                        } completion:NULL];
                    } else {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                        } completion:NULL];
                    }
                    UIView *separator = [[UIView alloc]init];
                    separator.backgroundColor = GRAY229;
                    [cell addSubview:separator];
                    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(10);
                        make.right.equalTo(cell.mas_right).offset(0);
                        make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                        make.height.mas_equalTo(0.5);
                    }];
                    cell.node = node;
                    cell.backgroundColor = [UIColor whiteColor];
                    [self loadDataForTreeViewCell:cell with:node indexPath:indexPath.row];
                    cell.arrowView.hidden = NO;
                    cell.contentTF.hidden = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    [cell setNeedsDisplay];
                    return cell;
                }
                if(node.type == 1){//类型为1的cell
                    CRMSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
                    if(cell == nil){
                        cell = [[CRMSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
                    }
                    
                    if (node.isExpanded) {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                        } completion:NULL];
                    } else {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                        } completion:NULL];
                    }
                    cell.node = node;
                    
                    //            cell.contentTF.textColor = [UIColor lightGrayColor];
                    [self loadDataForTreeViewCell:cell with:node indexPath:indexPath.row];
                    cell.arrowView.hidden = NO;
                    cell.contentTF.hidden = NO;
                    cell.contentTF.delegate = self;
                    subCellModel *nodeData = node.nodeData;
                    if ([nodeData.name isEqualToString:@"房产信息"] || [nodeData.name isEqualToString:@"车辆信息"]) {
                        cell.contentTF.hidden = YES;
                    }
                    cell.contentTF.returnKeyType = UIReturnKeyDone;
                    if (isEdit) {
                        cell.contentTF.userInteractionEnabled = YES;
                    } else {
                        cell.contentTF.userInteractionEnabled = NO;
                    }
                    //            cell.contentTF.placeholder = @"输入姓名";
                    //            superCellModel *nodeData = node.nodeData;
                    //            cell.contentTF.text = nodeData.TFText;
                    [cell setNeedsDisplay];
                    return cell;
                }
                else if (node.type == 2){//类型为2的cell
                    CRMSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub"];
                    if(cell == nil){
                        cell = [[CRMSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub"];
                    }
                    
                    subCellModel *nodeData = node.nodeData;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (nodeData.BtnArr.count != 0) {
                        for (UIButton *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    } else {
                        for (UITextField *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                    UILabel *titleLB = [[UILabel alloc] init];
                    titleLB.textColor = [UIColor grayColor];
                    titleLB.font = [UIFont systemFontOfSize:16];
                    [cell addSubview:titleLB];
                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(20*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(17);
                    }];
                    titleLB.text = nodeData.name;
                    if ([nodeData.name isEqualToString:@"婚姻状况"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+13*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                make.height.mas_equalTo(30);
                            }];
                        }
                    } else if ([nodeData.name isEqualToString:@"最高学历"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+18*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }else if ([nodeData.name isEqualToString:@"企业类型"]) {
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            if (i<3) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                    make.height.mas_equalTo(30);
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((110*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                    make.height.mas_equalTo(30);
                                }];
                            }
                            
                        }
                    } else if ([nodeData.name isEqualToString:@"现住宅类型"]) {
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((35)*(i/2)+9);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    } else if ([nodeData.name isEqualToString:@"房产类型"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }
                    
                    else if ([nodeData.name isEqualToString:@"客户来源"] ) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = GRAY229;
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        [titleLB removeFromSuperview];
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                make.height.mas_equalTo(30);
                                
                            }];
                            
                        }
                        cell.backgroundColor = [UIColor whiteColor];
                    }else if ([nodeData.name isEqualToString:@"贷款用途"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = GRAY229;
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        [titleLB removeFromSuperview];
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+15*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                        cell.backgroundColor = [UIColor whiteColor];
                    }
                    else if ([nodeData.name isEqualToString:@"共同借款人"]) {
                        [titleLB removeFromSuperview];
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.tag = 1000;
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        cell.backgroundColor = kMyColor(242, 240, 255);
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }
                    else if ([nodeData.name isEqualToString:@"发薪形式"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            if (i<2) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((80*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                    make.centerY.mas_equalTo(cell.mas_centerY);
                                    make.height.mas_equalTo(30);
                                    
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth+7*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                    make.centerY.mas_equalTo(cell.mas_centerY);
                                    make.height.mas_equalTo(30);
                                    
                                }];
                            }
                            
                        }
                    }
                    else {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((65*KAdaptiveRateWidth+13*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }
                    
                    if (nodeData.BtnArr.count == 0 && nodeData.type == 2) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        //                if ([nodeData.name isEqualToString:@"融资方案"]) {
                        //                    separator.backgroundColor = GRAY229;
                        //                    [titleLB removeFromSuperview];
                        //                    UILabel *titleLB = [[UILabel alloc] init];
                        //                    titleLB.textColor = [UIColor grayColor];
                        //                    titleLB.font = [UIFont systemFontOfSize:17];
                        //                    [cell addSubview:titleLB];
                        //                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        //                        make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                        //                        make.centerY.mas_equalTo(cell.mas_centerY);
                        //                        make.height.mas_equalTo(17);
                        //                    }];
                        //                    titleLB.text = nodeData.name;
                        //                    UITextField *contentTF = [[UITextField alloc] init];
                        //                    NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                        //                    contentTF.placeholder = placeholder;
                        //                    if (isEdit) {
                        //                        contentTF.userInteractionEnabled = YES;
                        //                    } else {
                        //                        contentTF.userInteractionEnabled = NO;
                        //                    }
                        //                    contentTF.text = nodeData.TFText;
                        //                    contentTF.delegate = self;
                        //                    contentTF.returnKeyType = UIReturnKeyDone;
                        //                    contentTF.font = secondFont;
                        //                    contentTF.textColor = GRAY90;
                        //                    [cell addSubview:contentTF];
                        //                    [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        //                        make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                        //                        make.centerY.mas_equalTo(cell.mas_centerY);
                        //                        make.height.mas_equalTo(30);
                        //                        make.width.mas_equalTo(200);
                        //                    }];
                        //                    if (nodeData.KeyType == 1) {
                        //                        contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        //                    }
                        //                    cell.backgroundColor = [UIColor whiteColor];
                        //                } else
                        if ([nodeData.name isEqualToString:@"职        位"]) {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入职位"];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.font = [UIFont systemFontOfSize:14];
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                        } else if ([nodeData.name isEqualToString:@"关        系"]) {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入关系"];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.text = nodeData.TFText;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                        }else if ([nodeData.name isEqualToString:@"以上哪些联系人可以知晓贷款"]) {
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            cell.backgroundColor = kMyColor(242, 240, 255);
                            titleLB.text = nodeData.name;
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入姓名"];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                        }else if ([nodeData.name isEqualToString:@"备注"]) {
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            //                    titleLB.text = nodeData.name;
                            cell.backgroundColor = GRAY229;//kMyColor(242, 240, 255)
                            UITextView *contentTF = [[UITextView alloc] init];
                            contentTF.tag = 9999;
                            //                    NSString *placeholder = [NSString stringWithFormat:@"输入备注"];
                            //                    contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.backgroundColor = [UIColor whiteColor];
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.layer.borderColor = kMyColor(242, 240, 255).CGColor;
                            contentTF.layer.borderWidth = 0.5f;
                            contentTF.font = [UIFont systemFontOfSize:14];
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            if (isEdit) {
                                contentTF.editable = YES;
                            } else {
                                contentTF.editable = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(5);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                if (self.remarkHeight > 200) {
                                    make.height.mas_equalTo(self.remarkHeight-10);
                                } else {
                                    make.height.mas_equalTo(190);
                                }
                                make.width.mas_equalTo(kScreenWidth-10);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                            self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 15)];
                            self.signLabel.text = @"输入备注（1500字以内）";
                            self.signLabel.textColor = GRAY138;
                            self.signLabel.font = [UIFont systemFontOfSize:14];
                            if (nodeData.TFText.length > 0) {
                                [self.signLabel removeFromSuperview];
                            } else {
                                [contentTF addSubview:self.signLabel];
                            }
                            if (nodeData.type == 2 ) {
                                
                            }
                        }else if ([nodeData.name isEqualToString:@"备注历史"]){
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            //                    titleLB.text = nodeData.name;
                            cell.backgroundColor = GRAY229;//kMyColor(242, 240, 255)
                            
                            NSInteger i = 11+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject+self.remarkListArr.count - indexPath.row;
                            reamrkModel *remark = self.remarkListArr[i];
                            
                            UILabel *remarkLB = [[UILabel alloc]init];
                            [cell addSubview:remarkLB];
                            remarkLB.text = [NSString stringWithFormat:@"%@ : %@",remark.real_name,remark.remark];
                            remarkLB.textColor = [UIColor redColor];
                            remarkLB.numberOfLines = 0;
                            remarkLB.font = [UIFont systemFontOfSize:13];
                            [remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.top.equalTo(cell.mas_top).offset(10);
                                make.bottom.equalTo(cell.mas_bottom).offset(-15);
                                make.width.mas_equalTo(kScreenWidth-20);
                            }];
                            
                            UILabel *timeLb = [[UILabel alloc] init];
                            [cell addSubview:timeLb];
                            timeLb.text = remark.create_time;
                            timeLb.font = [UIFont systemFontOfSize:10];
                            [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(cell.mas_right).offset(-10);
                                make.top.equalTo(remarkLB.mas_bottom).offset(2);
                                make.height.mas_equalTo(8);
                            }];
                            
                        }else if ([nodeData.name isEqualToString:@"方案"]){
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            cell.backgroundColor = GRAY229;//kMyColor(242, 240, 255)
                            UITextView *contentTF = [[UITextView alloc] init];
                            contentTF.tag = 99999;
                            
                            contentTF.delegate = self;
                            contentTF.backgroundColor = [UIColor whiteColor];
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.layer.borderColor = kMyColor(242, 240, 255).CGColor;
                            contentTF.layer.borderWidth = 0.5f;
                            contentTF.font = [UIFont systemFontOfSize:14];
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            if (isEdit) {
                                contentTF.editable = YES;
                            } else {
                                contentTF.editable = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(5);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                if (self.projectHeight > 200) {
                                    make.height.mas_equalTo(self.projectHeight-10);
                                } else {
                                    make.height.mas_equalTo(190);
                                }
                                make.width.mas_equalTo(kScreenWidth-10);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                            self.projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 15)];
                            self.projectLabel.text = @"输入融资方案（1500字以内）";
                            self.projectLabel.textColor = GRAY138;
                            self.projectLabel.font = [UIFont systemFontOfSize:14];
                            if (nodeData.TFText.length > 0) {
                                [self.projectLabel removeFromSuperview];
                            } else {
                                [contentTF addSubview:self.projectLabel];
                            }
                        } else {
                            UITextField *contentTF = [[UITextField alloc] init];
                            contentTF.text = nodeData.TFText;
                            
                            if ([nodeData.name isEqualToString:@"每月租金"]) {
                                contentTF.tag = 10001;
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                                
                            } else if ([nodeData.name isEqualToString:@"每月还款"]) {
                                
                                contentTF.tag = 10002;
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                            } else if ([nodeData.name isEqualToString:@"公积金金额"]) {
                                
                                contentTF.tag = 10003;
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                                
                            } else if ([nodeData.name isEqualToString:@"证件号码"] || [nodeData.name isEqualToString:@"身份证号码"]) {
                                contentTF.tag = 10004;
                                [contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                                }
                            } else {
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                            }
                            
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            
                        }
                        
                    }
                    if (nodeData.type == 3) {
                        if ([nodeData.name isEqualToString:@"月       供"]) {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入月供"];
                            contentTF.placeholder = placeholder;
                            contentTF.text = nodeData.TFText;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            UILabel *unitLb = [[UILabel alloc] init];
                            unitLb.font = [UIFont systemFontOfSize:17];
                            unitLb.textColor = [UIColor grayColor];
                            unitLb.text = nodeData.UnitType;
                            [cell addSubview:unitLb];
                            [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(contentTF.mas_right).offset(3);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                        }else if ([nodeData.name isEqualToString:@"融资金额"]) {
                            
                            UIView *separator = [[UIView alloc]init];
                            separator.backgroundColor = GRAY229;
                            [cell addSubview:separator];
                            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.right.equalTo(cell.mas_right).offset(0);
                                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                                make.height.mas_equalTo(0.5);
                            }];
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            titleLB.text = nodeData.name;
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.font = secondFont;
                            contentTF.textAlignment = NSTextAlignmentCenter;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.text = nodeData.TFText;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            UILabel *unitLb = [[UILabel alloc] init];
                            unitLb.font = [UIFont systemFontOfSize:17];
                            unitLb.textColor = [UIColor grayColor];
                            unitLb.text = nodeData.UnitType;
                            [cell addSubview:unitLb];
                            [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(contentTF.mas_right).offset(3);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                            cell.backgroundColor = [UIColor whiteColor];
                        } else {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            
                            contentTF.text = nodeData.TFText;
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            UILabel *unitLb = [[UILabel alloc] init];
                            unitLb.font = [UIFont systemFontOfSize:14];
                            unitLb.textColor = [UIColor grayColor];
                            unitLb.text = nodeData.UnitType;
                            [cell addSubview:unitLb];
                            [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(contentTF.mas_right).offset(3);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                        }
                    }
                    if (nodeData.type == 4) {
                        if ([nodeData.name isEqualToString:@"融资顾问"]||[nodeData.name isEqualToString:@"申请产品"]) {
                            UIView *separator = [[UIView alloc]init];
                            separator.backgroundColor = GRAY229;
                            [cell addSubview:separator];
                            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.right.equalTo(cell.mas_right).offset(0);
                                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                                make.height.mas_equalTo(0.5);
                            }];
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            titleLB.text = nodeData.name;
                            UILabel *chooseLB = [[UILabel alloc]init];
                            chooseLB.font = [UIFont systemFontOfSize:16];
                            if ([nodeData.name isEqualToString:@"申请产品"]) {
                                if (self.returnNameArray.count != 0) {
                                    chooseLB.text = productName;
                                } else {
                                    if (self.productArr.count!=0) {
                                        for (int i=0; i<self.productArr.count; i++) {
                                            productModel *model = self.productArr[i];
                                            
                                            if (i ==0) {
                                                chooseLB.text = model.mechProName;
                                            } else {
                                                NSString *str = chooseLB.text;
                                                chooseLB.text = [NSString stringWithFormat:@"%@、%@",str,model.mechProName];
                                            }
                                        }
                                    } else {
                                        chooseLB.text = @"点击选取";
                                    }
                                }
                            } else {
                                
                                if (self.returnPeople.count != 0) {
                                    ContactModel *model = self.returnPeople[0];
                                    headPeopleName = model.realName;
                                    chooseLB.text = headPeopleName;
                                } else {
                                    chooseLB.text = headPeopleName;
                                }
                            }
                            
                            
                            chooseLB.textAlignment = NSTextAlignmentRight;
                            chooseLB.textColor = GRAY90;
                            [cell addSubview:chooseLB];
                            [chooseLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.right.equalTo(cell.mas_right).offset(-30*KAdaptiveRateWidth);
                                make.height.mas_equalTo(30);
                            }];
                            cell.backgroundColor = [UIColor whiteColor];
                            UIImageView *imageV = [[UIImageView alloc]init];
                            imageV.image = [UIImage imageNamed:@"箭头（右）"];
                            [cell addSubview:imageV];
                            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(cell.mas_right).offset(-20*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(13);
                                make.width.mas_offset(7);
                            }];
                            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                        }
                        else {
                            UILabel *chooseLB = [[UILabel alloc]init];
                            chooseLB.font = [UIFont systemFontOfSize:14];
                            if ([nodeData.identification isEqualToString:@"购房日期"]) {
                                if (houseTime != nil) {
                                    chooseLB.text = houseTime;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            if ([nodeData.identification isEqualToString:@"购车日期"]) {
                                if (carTime != nil) {
                                    chooseLB.text = carTime;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            if ([nodeData.name isEqualToString:@"成立时间"]) {
                                if (self.special_company_date != nil) {
                                    chooseLB.text = self.special_company_date;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            if ([nodeData.name isEqualToString:@"入职时间"]) {
                                if (workTime != nil) {
                                    chooseLB.text = workTime;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            chooseLB.textAlignment = NSTextAlignmentCenter;
                            chooseLB.textColor = [UIColor lightGrayColor];
                            [cell addSubview:chooseLB];
                            [chooseLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.right.equalTo(cell.mas_right).offset(-20*KAdaptiveRateWidth);
                                make.height.mas_equalTo(30);
                                
                            }];
                            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                        }
                        
                    }
                    
                    cell.node = node;
                    
                    return cell;
                    
                }
                else if (node.type == 3) {
#pragma mark === 修改房产信息和车辆信息
                    CRMSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub"];
                    if(cell == nil){
                        cell = [[CRMSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub"];
                    }
                    subCellModel *nodeData = node.nodeData;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if (nodeData.BtnArr.count != 0) {
                        for (UIButton *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                        for (UILabel *lab in [cell subviews]) {
                            [lab removeFromSuperview];
                        }
                    } else {
                        for (UITextField *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                    UILabel *titleLB = [[UILabel alloc] init];
                    titleLB.textColor = [UIColor grayColor];
                    titleLB.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:titleLB];
                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(20*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(17);
                    }];
                    titleLB.text = nodeData.name;
                    
                    UIView *separator = [[UIView alloc]init];
                    separator.backgroundColor = [UIColor whiteColor];
                    [cell addSubview:separator];
                    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(10);
                        make.right.equalTo(cell.mas_right).offset(0);
                        make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                        make.height.mas_equalTo(0.5);
                    }];
                    
                    for (int i = 0; i < nodeData.BtnArr.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.tag = i+1;
                        if (nodeData.index == i+1) {
                            btn.selected = YES;
                        }
                        if (isEdit) {
                            btn.userInteractionEnabled = YES;
                        } else {
                            btn.userInteractionEnabled = NO;
                        }
                        
                        btn.layer.masksToBounds = YES;
                        btn.layer.cornerRadius = 5;
                        btn.layer.borderWidth = 0.3;
                        btn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
                        
                        [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                        
                        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageWithColor:TABBAR_BASE_COLOR] forState:UIControlStateSelected];
                        
                        btn.titleLabel.font = [UIFont systemFontOfSize:15];
                        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                        
                        if ([nodeData.identification isEqualToString:@"购车日期"] || [nodeData.identification isEqualToString:@"购房日期"]) {
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth+(kScreenWidth-20-4*70*KAdaptiveRateWidth)/4.0)*i+(kScreenWidth-20-4*70*KAdaptiveRateWidth)/4.0);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(70*KAdaptiveRateWidth);
                                
                            }];
                        } else {
                            if ([nodeData.identification isEqualToString:@"购车价格"] || [nodeData.identification isEqualToString:@"购房价格"]) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.left.equalTo(titleLB.mas_right).offset((80*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((35)*(i/2)+7.5);
                                    
                                    make.height.mas_equalTo(30);
                                    make.width.mas_equalTo(80*KAdaptiveRateWidth);
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.left.equalTo(titleLB.mas_right).offset((95*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((35)*(i/2)+7.5);
                                    
                                    make.height.mas_equalTo(30);
                                    make.width.mas_equalTo(95*KAdaptiveRateWidth);
                                }];
                            }
                            
                        }
                        
                    }
                    
                    return cell;
                }
            } else if (indexPath.section == 3) {
                LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latest" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[LatestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latest"];
                }
                cusrecordListModel *model = self.cusrecordListArr[indexPath.row];
                cell.contentLb.text = model.content;
                cell.timeLb.text = model.time;
                return cell;
            }
        } else {
            if (indexPath.section == 1) {
                TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
                if(node.type == 0){//类型为0的cell
                    CRMDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstLevel"];
                    if(cell == nil){
                        cell = [[CRMDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstLevel"];
                    }
                    if (node.isExpanded) {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                        } completion:NULL];
                    } else {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                        } completion:NULL];
                    }
                    UIView *separator = [[UIView alloc]init];
                    separator.backgroundColor = GRAY229;
                    [cell addSubview:separator];
                    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(10);
                        make.right.equalTo(cell.mas_right).offset(0);
                        make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                        make.height.mas_equalTo(0.5);
                    }];
                    cell.node = node;
                    cell.backgroundColor = [UIColor whiteColor];
                    [self loadDataForTreeViewCell:cell with:node indexPath:indexPath.row];
                    cell.arrowView.hidden = NO;
                    cell.contentTF.hidden = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    [cell setNeedsDisplay];
                    return cell;
                }
                if(node.type == 1){//类型为1的cell
                    CRMSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
                    if(cell == nil){
                        cell = [[CRMSecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
                    }
                    
                    if (node.isExpanded) {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
                        } completion:NULL];
                    } else {
                        [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            cell.arrowView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
                        } completion:NULL];
                    }
                    cell.node = node;
                    
                    //            cell.contentTF.textColor = [UIColor lightGrayColor];
                    [self loadDataForTreeViewCell:cell with:node indexPath:indexPath.row];
                    cell.arrowView.hidden = NO;
                    cell.contentTF.hidden = NO;
                    cell.contentTF.delegate = self;
                    subCellModel *nodeData = node.nodeData;
                    if ([nodeData.name isEqualToString:@"房产信息"] || [nodeData.name isEqualToString:@"车辆信息"]) {
                        cell.contentTF.hidden = YES;
                    }
                    cell.contentTF.returnKeyType = UIReturnKeyDone;
                    if (isEdit) {
                        cell.contentTF.userInteractionEnabled = YES;
                    } else {
                        cell.contentTF.userInteractionEnabled = NO;
                    }
                    //            cell.contentTF.placeholder = @"输入姓名";
                    //            superCellModel *nodeData = node.nodeData;
                    //            cell.contentTF.text = nodeData.TFText;
                    [cell setNeedsDisplay];
                    return cell;
                }
                else if (node.type == 2){//类型为2的cell
                    CRMSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub"];
                    if(cell == nil){
                        cell = [[CRMSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub"];
                    }
                    
                    subCellModel *nodeData = node.nodeData;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (nodeData.BtnArr.count != 0) {
                        for (UIButton *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    } else {
                        for (UITextField *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                    UILabel *titleLB = [[UILabel alloc] init];
                    titleLB.textColor = [UIColor grayColor];
                    titleLB.font = [UIFont systemFontOfSize:16];
                    [cell addSubview:titleLB];
                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(20*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(17);
                    }];
                    titleLB.text = nodeData.name;
                    if ([nodeData.name isEqualToString:@"婚姻状况"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+13*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                make.height.mas_equalTo(30);
                            }];
                        }
                    } else if ([nodeData.name isEqualToString:@"最高学历"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+18*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }else if ([nodeData.name isEqualToString:@"企业类型"]) {
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            if (i<3) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                    make.height.mas_equalTo(30);
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((110*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                    make.height.mas_equalTo(30);
                                }];
                            }
                            
                        }
                    } else if ([nodeData.name isEqualToString:@"现住宅类型"]) {
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((35)*(i/2)+9);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    } else if ([nodeData.name isEqualToString:@"房产类型"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }
                    
                    else if ([nodeData.name isEqualToString:@"客户来源"] ) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = GRAY229;
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        [titleLB removeFromSuperview];
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                make.top.equalTo(cell.mas_top).offset((30)*(i/2)+10);
                                make.height.mas_equalTo(30);
                                
                            }];
                            
                        }
                        cell.backgroundColor = [UIColor whiteColor];
                    }else if ([nodeData.name isEqualToString:@"贷款用途"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = GRAY229;
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        [titleLB removeFromSuperview];
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+15*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                        cell.backgroundColor = [UIColor whiteColor];
                    }
                    else if ([nodeData.name isEqualToString:@"共同借款人"]) {
                        [titleLB removeFromSuperview];
                        UILabel *titleLB = [[UILabel alloc] init];
                        titleLB.tag = 1000;
                        titleLB.textColor = [UIColor grayColor];
                        titleLB.font = [UIFont systemFontOfSize:17];
                        [cell addSubview:titleLB];
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(17);
                        }];
                        titleLB.text = nodeData.name;
                        cell.backgroundColor = kMyColor(242, 240, 255);
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }
                    else if ([nodeData.name isEqualToString:@"发薪形式"]) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            if (i<2) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((80*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                    make.centerY.mas_equalTo(cell.mas_centerY);
                                    make.height.mas_equalTo(30);
                                    
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth+7*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                    make.centerY.mas_equalTo(cell.mas_centerY);
                                    make.height.mas_equalTo(30);
                                    
                                }];
                            }
                            
                        }
                    }
                    else {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        for (int i=0; i<nodeData.BtnArr.count; i++) {
                            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                            btn.tag = i+1;
                            if (nodeData.index == i+1) {
                                btn.selected = YES;
                            }
                            if (isEdit) {
                                btn.userInteractionEnabled = YES;
                            } else {
                                btn.userInteractionEnabled = NO;
                            }
                            [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                            [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                            [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                            [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                            [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
                            btn.titleLabel.font = secondFont;
                            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [cell addSubview:btn];
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((65*KAdaptiveRateWidth+13*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                
                            }];
                        }
                    }
                    
                    if (nodeData.BtnArr.count == 0 && nodeData.type == 2) {
                        UIView *separator = [[UIView alloc]init];
                        separator.backgroundColor = [UIColor whiteColor];
                        [cell addSubview:separator];
                        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(10);
                            make.right.equalTo(cell.mas_right).offset(0);
                            make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                            make.height.mas_equalTo(0.5);
                        }];
                        //                if ([nodeData.name isEqualToString:@"融资方案"]) {
                        //                    separator.backgroundColor = GRAY229;
                        //                    [titleLB removeFromSuperview];
                        //                    UILabel *titleLB = [[UILabel alloc] init];
                        //                    titleLB.textColor = [UIColor grayColor];
                        //                    titleLB.font = [UIFont systemFontOfSize:17];
                        //                    [cell addSubview:titleLB];
                        //                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        //                        make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                        //                        make.centerY.mas_equalTo(cell.mas_centerY);
                        //                        make.height.mas_equalTo(17);
                        //                    }];
                        //                    titleLB.text = nodeData.name;
                        //                    UITextField *contentTF = [[UITextField alloc] init];
                        //                    NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                        //                    contentTF.placeholder = placeholder;
                        //                    if (isEdit) {
                        //                        contentTF.userInteractionEnabled = YES;
                        //                    } else {
                        //                        contentTF.userInteractionEnabled = NO;
                        //                    }
                        //                    contentTF.text = nodeData.TFText;
                        //                    contentTF.delegate = self;
                        //                    contentTF.returnKeyType = UIReturnKeyDone;
                        //                    contentTF.font = secondFont;
                        //                    contentTF.textColor = GRAY90;
                        //                    [cell addSubview:contentTF];
                        //                    [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                        //                        make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                        //                        make.centerY.mas_equalTo(cell.mas_centerY);
                        //                        make.height.mas_equalTo(30);
                        //                        make.width.mas_equalTo(200);
                        //                    }];
                        //                    if (nodeData.KeyType == 1) {
                        //                        contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        //                    }
                        //                    cell.backgroundColor = [UIColor whiteColor];
                        //                } else
                        if ([nodeData.name isEqualToString:@"职        位"]) {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入职位"];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.font = [UIFont systemFontOfSize:14];
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                        } else if ([nodeData.name isEqualToString:@"关        系"]) {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入关系"];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.text = nodeData.TFText;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                        }else if ([nodeData.name isEqualToString:@"以上哪些联系人可以知晓贷款"]) {
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            cell.backgroundColor = kMyColor(242, 240, 255);
                            titleLB.text = nodeData.name;
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入姓名"];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                        }else if ([nodeData.name isEqualToString:@"备注"]) {
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            //                    titleLB.text = nodeData.name;
                            cell.backgroundColor = GRAY229;//kMyColor(242, 240, 255)
                            UITextView *contentTF = [[UITextView alloc] init];
                            contentTF.tag = 9999;
                            //                    NSString *placeholder = [NSString stringWithFormat:@"输入备注"];
                            //                    contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.backgroundColor = [UIColor whiteColor];
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.layer.borderColor = kMyColor(242, 240, 255).CGColor;
                            contentTF.layer.borderWidth = 0.5f;
                            contentTF.font = [UIFont systemFontOfSize:14];
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            if (isEdit) {
                                contentTF.editable = YES;
                            } else {
                                contentTF.editable = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(5);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                if (self.remarkHeight > 200) {
                                    make.height.mas_equalTo(self.remarkHeight-10);
                                } else {
                                    make.height.mas_equalTo(190);
                                }
                                make.width.mas_equalTo(kScreenWidth-10);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                            self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 15)];
                            self.signLabel.text = @"输入备注（1500字以内）";
                            self.signLabel.textColor = GRAY138;
                            self.signLabel.font = [UIFont systemFontOfSize:14];
                            if (nodeData.TFText.length > 0) {
                                [self.signLabel removeFromSuperview];
                            } else {
                                [contentTF addSubview:self.signLabel];
                            }
                            if (nodeData.type == 2 ) {
                                
                            }
                        }else if ([nodeData.name isEqualToString:@"备注历史"]){
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            //                    titleLB.text = nodeData.name;
                            cell.backgroundColor = GRAY229;//kMyColor(242, 240, 255)
                            
                            NSInteger i = 4+personalInfoCount+AssetInfoCount+houseInfoCount+carInfoCount+workInfoCount+contactsInfoCount+self.isProject+self.remarkListArr.count - indexPath.row;
                            reamrkModel *remark = self.remarkListArr[i];
                            
                            UILabel *remarkLB = [[UILabel alloc]init];
                            [cell addSubview:remarkLB];
                            remarkLB.text = [NSString stringWithFormat:@"%@ : %@",remark.real_name,remark.remark];
                            remarkLB.textColor = [UIColor redColor];
                            remarkLB.numberOfLines = 0;
                            remarkLB.font = [UIFont systemFontOfSize:13];
                            [remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.top.equalTo(cell.mas_top).offset(10);
                                make.bottom.equalTo(cell.mas_bottom).offset(-15);
                                make.width.mas_equalTo(kScreenWidth-20);
                            }];
                            
                            UILabel *timeLb = [[UILabel alloc] init];
                            [cell addSubview:timeLb];
                            timeLb.text = remark.create_time;
                            timeLb.font = [UIFont systemFontOfSize:10];
                            [timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(cell.mas_right).offset(-10);
                                make.top.equalTo(remarkLB.mas_bottom).offset(2);
                                make.height.mas_equalTo(8);
                            }];
                            
                        }else if ([nodeData.name isEqualToString:@"方案"]){
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(15*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            cell.backgroundColor = GRAY229;//kMyColor(242, 240, 255)
                            UITextView *contentTF = [[UITextView alloc] init];
                            contentTF.tag = 99999;
                            
                            contentTF.delegate = self;
                            contentTF.backgroundColor = [UIColor whiteColor];
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.layer.borderColor = kMyColor(242, 240, 255).CGColor;
                            contentTF.layer.borderWidth = 0.5f;
                            contentTF.font = [UIFont systemFontOfSize:14];
                            [cell addSubview:contentTF];
                            contentTF.text = nodeData.TFText;
                            if (isEdit) {
                                contentTF.editable = YES;
                            } else {
                                contentTF.editable = NO;
                            }
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(5);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                if (self.projectHeight > 200) {
                                    make.height.mas_equalTo(self.projectHeight-10);
                                } else {
                                    make.height.mas_equalTo(190);
                                }
                                make.width.mas_equalTo(kScreenWidth-10);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                            }
                            self.projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 300, 15)];
                            self.projectLabel.text = @"输入融资方案（1500字以内）";
                            self.projectLabel.textColor = GRAY138;
                            self.projectLabel.font = [UIFont systemFontOfSize:14];
                            if (nodeData.TFText.length > 0) {
                                [self.projectLabel removeFromSuperview];
                            } else {
                                [contentTF addSubview:self.projectLabel];
                            }
                        } else {
                            UITextField *contentTF = [[UITextField alloc] init];
                            contentTF.text = nodeData.TFText;
                            
                            if ([nodeData.name isEqualToString:@"每月租金"]) {
                                contentTF.tag = 10001;
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                                
                            } else if ([nodeData.name isEqualToString:@"每月还款"]) {
                                
                                contentTF.tag = 10002;
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                            } else if ([nodeData.name isEqualToString:@"公积金金额"]) {
                                
                                contentTF.tag = 10003;
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                                
                            } else if ([nodeData.name isEqualToString:@"证件号码"] || [nodeData.name isEqualToString:@"身份证号码"]) {
                                contentTF.tag = 10004;
                                [contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                                }
                            } else {
                                if (nodeData.KeyType == 1) {
                                    contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                                }
                            }
                            
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(200);
                            }];
                            
                        }
                        
                    }
                    if (nodeData.type == 3) {
                        if ([nodeData.name isEqualToString:@"月       供"]) {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入月供"];
                            contentTF.placeholder = placeholder;
                            contentTF.text = nodeData.TFText;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            UILabel *unitLb = [[UILabel alloc] init];
                            unitLb.font = [UIFont systemFontOfSize:17];
                            unitLb.textColor = [UIColor grayColor];
                            unitLb.text = nodeData.UnitType;
                            [cell addSubview:unitLb];
                            [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(contentTF.mas_right).offset(3);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                        }else if ([nodeData.name isEqualToString:@"融资金额"]) {
                            
                            UIView *separator = [[UIView alloc]init];
                            separator.backgroundColor = GRAY229;
                            [cell addSubview:separator];
                            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.right.equalTo(cell.mas_right).offset(0);
                                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                                make.height.mas_equalTo(0.5);
                            }];
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            titleLB.text = nodeData.name;
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.font = secondFont;
                            contentTF.textAlignment = NSTextAlignmentCenter;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            contentTF.text = nodeData.TFText;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            UILabel *unitLb = [[UILabel alloc] init];
                            unitLb.font = [UIFont systemFontOfSize:17];
                            unitLb.textColor = [UIColor grayColor];
                            unitLb.text = nodeData.UnitType;
                            [cell addSubview:unitLb];
                            [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(contentTF.mas_right).offset(3);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                            cell.backgroundColor = [UIColor whiteColor];
                        } else {
                            UITextField *contentTF = [[UITextField alloc] init];
                            NSString *placeholder = [NSString stringWithFormat:@"输入%@",nodeData.name];
                            contentTF.placeholder = placeholder;
                            contentTF.delegate = self;
                            contentTF.returnKeyType = UIReturnKeyDone;
                            contentTF.font = secondFont;
                            contentTF.textColor = GRAY90;
                            [cell addSubview:contentTF];
                            if (isEdit) {
                                contentTF.userInteractionEnabled = YES;
                            } else {
                                contentTF.userInteractionEnabled = NO;
                            }
                            
                            contentTF.text = nodeData.TFText;
                            [contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            UILabel *unitLb = [[UILabel alloc] init];
                            unitLb.font = [UIFont systemFontOfSize:14];
                            unitLb.textColor = [UIColor grayColor];
                            unitLb.text = nodeData.UnitType;
                            [cell addSubview:unitLb];
                            [unitLb mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(contentTF.mas_right).offset(3);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                            }];
                            if (nodeData.KeyType == 1) {
                                contentTF.keyboardType = UIKeyboardTypeDecimalPad;
                            }
                        }
                    }
                    if (nodeData.type == 4) {
                        if ([nodeData.name isEqualToString:@"融资顾问"]||[nodeData.name isEqualToString:@"申请产品"]) {
                            UIView *separator = [[UIView alloc]init];
                            separator.backgroundColor = GRAY229;
                            [cell addSubview:separator];
                            [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10);
                                make.right.equalTo(cell.mas_right).offset(0);
                                make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                                make.height.mas_equalTo(0.5);
                            }];
                            [titleLB removeFromSuperview];
                            UILabel *titleLB = [[UILabel alloc] init];
                            titleLB.textColor = [UIColor grayColor];
                            titleLB.font = [UIFont systemFontOfSize:17];
                            [cell addSubview:titleLB];
                            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(cell.mas_left).offset(10*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(17);
                            }];
                            titleLB.text = nodeData.name;
                            UILabel *chooseLB = [[UILabel alloc]init];
                            chooseLB.font = [UIFont systemFontOfSize:16];
                            if ([nodeData.name isEqualToString:@"申请产品"]) {
                                if (self.returnNameArray.count != 0) {
                                    chooseLB.text = productName;
                                } else {
                                    if (self.productArr.count!=0) {
                                        for (int i=0; i<self.productArr.count; i++) {
                                            productModel *model = self.productArr[i];
                                            
                                            if (i ==0) {
                                                chooseLB.text = model.mechProName;
                                            } else {
                                                NSString *str = chooseLB.text;
                                                chooseLB.text = [NSString stringWithFormat:@"%@、%@",str,model.mechProName];
                                            }
                                        }
                                    } else {
                                        chooseLB.text = @"点击选取";
                                    }
                                }
                            } else {
                                
                                if (self.returnPeople.count != 0) {
                                    ContactModel *model = self.returnPeople[0];
                                    headPeopleName = model.realName;
                                    chooseLB.text = headPeopleName;
                                } else {
                                    chooseLB.text = headPeopleName;
                                }
                            }
                            
                            
                            chooseLB.textAlignment = NSTextAlignmentRight;
                            chooseLB.textColor = GRAY90;
                            [cell addSubview:chooseLB];
                            [chooseLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.right.equalTo(cell.mas_right).offset(-30*KAdaptiveRateWidth);
                                make.height.mas_equalTo(30);
                            }];
                            cell.backgroundColor = [UIColor whiteColor];
                            UIImageView *imageV = [[UIImageView alloc]init];
                            imageV.image = [UIImage imageNamed:@"箭头（右）"];
                            [cell addSubview:imageV];
                            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.right.equalTo(cell.mas_right).offset(-20*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(13);
                                make.width.mas_offset(7);
                            }];
                            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                        }
                        else {
                            UILabel *chooseLB = [[UILabel alloc]init];
                            chooseLB.font = [UIFont systemFontOfSize:14];
                            if ([nodeData.identification isEqualToString:@"购房日期"]) {
                                if (houseTime != nil) {
                                    chooseLB.text = houseTime;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            if ([nodeData.identification isEqualToString:@"购车日期"]) {
                                if (carTime != nil) {
                                    chooseLB.text = carTime;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            if ([nodeData.name isEqualToString:@"成立时间"]) {
                                if (self.special_company_date != nil) {
                                    chooseLB.text = self.special_company_date;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            if ([nodeData.name isEqualToString:@"入职时间"]) {
                                if (workTime != nil) {
                                    chooseLB.text = workTime;
                                } else {
                                    chooseLB.text = @"点击选取";
                                }
                            }
                            chooseLB.textAlignment = NSTextAlignmentCenter;
                            chooseLB.textColor = [UIColor lightGrayColor];
                            [cell addSubview:chooseLB];
                            [chooseLB mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset(5*KAdaptiveRateWidth);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.right.equalTo(cell.mas_right).offset(-20*KAdaptiveRateWidth);
                                make.height.mas_equalTo(30);
                                
                            }];
                            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                        }
                        
                    }
                    
                    cell.node = node;
                    
                    return cell;
                    
                }
                else if (node.type == 3) {
#pragma mark === 修改房产信息和车辆信息
                    CRMSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub"];
                    if(cell == nil){
                        cell = [[CRMSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sub"];
                    }
                    subCellModel *nodeData = node.nodeData;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if (nodeData.BtnArr.count != 0) {
                        for (UIButton *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                        for (UILabel *lab in [cell subviews]) {
                            [lab removeFromSuperview];
                        }
                    } else {
                        for (UITextField *btn in [cell subviews]) {
                            [btn removeFromSuperview];
                        }
                    }
                    UILabel *titleLB = [[UILabel alloc] init];
                    titleLB.textColor = [UIColor grayColor];
                    titleLB.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:titleLB];
                    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(20*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(17);
                    }];
                    titleLB.text = nodeData.name;
                    
                    UIView *separator = [[UIView alloc]init];
                    separator.backgroundColor = [UIColor whiteColor];
                    [cell addSubview:separator];
                    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(cell.mas_left).offset(10);
                        make.right.equalTo(cell.mas_right).offset(0);
                        make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                        make.height.mas_equalTo(0.5);
                    }];
                    
                    for (int i = 0; i < nodeData.BtnArr.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.tag = i+1;
                        if (nodeData.index == i+1) {
                            btn.selected = YES;
                        }
                        if (isEdit) {
                            btn.userInteractionEnabled = YES;
                        } else {
                            btn.userInteractionEnabled = NO;
                        }
                        
                        btn.layer.masksToBounds = YES;
                        btn.layer.cornerRadius = 5;
                        btn.layer.borderWidth = 0.3;
                        btn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
                        
                        [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                        
                        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageWithColor:TABBAR_BASE_COLOR] forState:UIControlStateSelected];
                        
                        btn.titleLabel.font = [UIFont systemFontOfSize:15];
                        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                        
                        if ([nodeData.identification isEqualToString:@"购车日期"] || [nodeData.identification isEqualToString:@"购房日期"]) {
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth+(kScreenWidth-20-4*70*KAdaptiveRateWidth)/4.0)*i+(kScreenWidth-20-4*70*KAdaptiveRateWidth)/4.0);
                                make.centerY.mas_equalTo(cell.mas_centerY);
                                make.height.mas_equalTo(30);
                                make.width.mas_equalTo(70*KAdaptiveRateWidth);
                                
                            }];
                        } else {
                            if ([nodeData.identification isEqualToString:@"购车价格"] || [nodeData.identification isEqualToString:@"购房价格"]) {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.left.equalTo(titleLB.mas_right).offset((80*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((35)*(i/2)+7.5);
                                    
                                    make.height.mas_equalTo(30);
                                    make.width.mas_equalTo(80*KAdaptiveRateWidth);
                                }];
                            } else {
                                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                    
                                    make.left.equalTo(titleLB.mas_right).offset((95*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+5*KAdaptiveRateWidth);
                                    make.top.equalTo(cell.mas_top).offset((35)*(i/2)+7.5);
                                    
                                    make.height.mas_equalTo(30);
                                    make.width.mas_equalTo(95*KAdaptiveRateWidth);
                                }];
                            }
                            
                        }
                        
                    }
                    
                    return cell;
                }
            } else if (indexPath.section == 2) {
                LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latest" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[LatestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latest"];
                }
                cusrecordListModel *model = self.cusrecordListArr[indexPath.row];
                cell.contentLb.text = model.content;
                cell.timeLb.text = model.time;
                return cell;
            }
        }
        
    }
    
    return cell;
}


/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(TreeViewNode*)node indexPath:(NSInteger)indexPathRow{
    if(node.type == 1){
        subCellModel *nodeData = node.nodeData;
        ((CRMSecondTableViewCell*)cell).titleLB.text = nodeData.name;
        ((CRMSecondTableViewCell*)cell).backgroundColor = kMyColor(242, 240, 255);
        ((CRMSecondTableViewCell*)cell).contentTF.placeholder = @"输入姓名";
        ((CRMSecondTableViewCell*)cell).contentTF.text = nodeData.TFText;
        
    }
    if(node.type == 0){
        subCellModel *nodeData = node.nodeData;
        ((CRMDetailsTableViewCell*)cell).titleLB.text = nodeData.name;
        
    }
    else{
        
    }
}
//选择按钮的点击事件
- (void)BtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    CRMSubTableViewCell *cell = (CRMSubTableViewCell*)[sender superview];
    UILabel *titleLb = [cell viewWithTag:1000];
    
    NSIndexPath *indexpath = [self.CRMDetailsTableView indexPathForCell:cell];
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (indexpath.section == 1) {
            TreeViewNode *node = [_sectionOneDisplayArray objectAtIndex:indexpath.row];
            subCellModel *nodeData = node.nodeData;
            if (sender.selected) {
                nodeData.index = sender.tag;
            } else {
                nodeData.index = 0;
            }
            NSMutableArray *tmp = [[NSMutableArray alloc]init];
            
            TreeViewNode *node3 = [[TreeViewNode alloc]init];
            node3.nodeLevel = 0;//根层cell
            node3.type = 3;//type 1的cell
            node3.sonNodes = nil;
            node3.isExpanded = FALSE;//关闭状态
            subCellModel *model3 = [[subCellModel alloc]init];
            model3.name = @"公积金范围";
            model3.index = 0;
            model3.BtnArr = [NSMutableArray arrayWithObjects:@"500以内",@"500-1500",@"1500以上",@"其他", nil];;
            model3.type = 1;
            if (self.CRMModel.cpfRange != nil) {
                model3.index = [self.CRMModel.cpfRange integerValue];
            } else {
                model3.index = 0;
            }
            node3.nodeData = model3;
            
            TreeViewNode *node4 = [[TreeViewNode alloc]init];
            node4.nodeLevel = 0;//根层cell
            node4.type = 2;//type 1的cell
            node4.sonNodes = nil;
            node4.isExpanded = FALSE;//关闭状态
            subCellModel *model4 = [[subCellModel alloc]init];
            model4.name = @"公积金金额";
            model4.index = 0;
            model4.KeyType = 1;
            model4.BtnArr = nil;
            model4.type = 2;
            if (![self.CRMModel.cpfMoney isEqual:@"(null)"]) {
                cpfMoney = self.CRMModel.cpfMoney;
                model4.TFText = cpfMoney;
            }
            node4.nodeData = model4;
            
            
            TreeViewNode *node1 = [[TreeViewNode alloc]init];
            node1.nodeLevel = 1;//根层cell
            node1.type = 2;//type 1的cell
            node1.sonNodes = nil;
            node1.isExpanded = FALSE;//关闭状态
            subCellModel *model1 = [[subCellModel alloc]init];
            model1.name = @"单位性质";
            model1.BtnArr = [NSMutableArray arrayWithObjects:@" 行政事业单位、社会团体",@" 国 企  ",@" 民 企  ",@" 外 资  ",@" 合 资  ",@" 私 营  ",@" 个 体  ", nil];
            model1.type = 1;
            if (self.CRMModel.work_type != nil) {
                model1.index = [self.CRMModel.work_type integerValue];
            } else {
                model1.index = 0;
            }
            node1.nodeData = model1;
            
            TreeViewNode *node7 = [[TreeViewNode alloc]init];
            node7.nodeLevel = 1;//根层cell
            node7.type = 2;//type 1的cell
            node7.sonNodes = nil;
            node7.isExpanded = FALSE;//关闭状态
            subCellModel *model7 = [[subCellModel alloc]init];
            model7.name = @"私营业主是否报税";
            model7.BtnArr = [NSMutableArray arrayWithObjects:@" 有   ",@" 无   ", nil];
            model7.type = 1;
            if (self.CRMModel.isbs) {
                model7.index = [self.CRMModel.isbs integerValue];
            } else {
                model7.index = 0;
            }
            node7.nodeData = model7;
            
            TreeViewNode *node8 = [[TreeViewNode alloc]init];
            node8.nodeLevel = 1;//根层cell
            node8.type = 3;//type 1的cell
            node8.sonNodes = nil;
            node8.isExpanded = FALSE;//关闭状态
            subCellModel *model8 = [[subCellModel alloc]init];
            model8.name = @"投保年限";
            model8.index = 0;
            model8.BtnArr = [NSMutableArray arrayWithObjects:@"1年内",@"1-2年",@"2年以上", nil];
            model8.type = 1;
            if (self.CRMModel.grbx_term_range != nil) {
                model8.index = [self.CRMModel.grbx_term_range integerValue];
            } else {
                model8.index = 0;
            }
            node8.nodeData = model8;
            
            TreeViewNode *node9 = [[TreeViewNode alloc]init];
            node9.nodeLevel = 0;//根层cell
            node9.type = 2;//type 1的cell
            node9.sonNodes = nil;
            node9.isExpanded = FALSE;//关闭状态
            subCellModel *model9 = [[subCellModel alloc]init];
            model9.name = @"保险金额/元";
            model9.index = 0;
            model9.KeyType = 1;
            model9.BtnArr = nil;
            model9.type = 2;
            if (![self.CRMModel.grbx_sum isEqual:@"(null)"]) {
                cpfMoney = self.CRMModel.grbx_sum;
                model9.TFText = cpfMoney;
            }
            node9.nodeData = model9;
            
            DLog(@"点击了self.CRMModel.cpfRange == %@  indexPath.section == %ld,indexPath.section.row == %ld,sender.tag == %ld ",self.CRMModel.cpfRange,indexpath.section,indexpath.row,sender.tag);
            // 受薪还是自由职业
            if (indexpath.row == 0 && sender.tag == 1) {
                
                if (isAddOccType == 0) {
                    [_sectionOneDataArray insertObject:node1 atIndex:indexpath.row+1];
                    subCellModel *model = node1.nodeData;
                    if (isAddPrivate == 0) {
                        if (model.index == 6) {
                            [_sectionOneDataArray insertObject:node7 atIndex:indexpath.row+2];
                            isAddPrivate = 1;
                        }
                    }
                }
                isAddOccType = 1;
                
            } else if (indexpath.row == 0 && sender.tag == 2){
                if (isAddOccType == 1) {
                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                    if (isAddPrivate == 1) {
                        [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                    }
                }
                isAddOccType = 0;
                isAddPrivate = 0;
            }
            //受薪
            if (isAddOccType == 1) {
                //受薪 并且 是否点击了为私企
                if (indexpath.row == 1 && sender.tag == 6) {
                    if (isAddPrivate == 0) {
                        [_sectionOneDataArray insertObject:node7 atIndex:indexpath.row+1];
                    }
                    isAddPrivate = 1;
                } else if (indexpath.row == 1 && sender.tag != 6){
                    if (isAddPrivate == 1) {
                        [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                    }
                    isAddPrivate = 0;
                }
                //是私营
                if (isAddPrivate == 1) {
                    //报税 －－ 点击了是否有公积金
                    if (indexpath.row == 3 && sender.tag == 1) {
                        
                        if (isAddAccumulationFund == 0) {
                            [_sectionOneDataArray insertObject:node3 atIndex:indexpath.row+1];
                            subCellModel *model = node3.nodeData;
                            if (isAddCpf == 0) {
                                if (model.index == 1) {
                                    [_sectionOneDataArray insertObject:node4 atIndex:indexpath.row+2];
                                    isAddCpf = 1;
                                }
                            }
                        }
                        isAddAccumulationFund = 1;
                    } else if (indexpath.row == 3 && sender.tag == 2) {
                        if (isAddAccumulationFund == 1) {
                            [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            if (isAddCpf == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            
                        }
                        isAddAccumulationFund = 0;
                        isAddCpf = 0;
                    }
                    
                    //有公积金 ---- 点击 公积金范围 是否 为其他
                    if (isAddAccumulationFund == 1) {
                        if (indexpath.row == 4 && sender.tag == 4) {
                            if (isAddCpf == 0) {
                                [_sectionOneDataArray insertObject:node4 atIndex:indexpath.row+1];
                                
                            }
                            isAddCpf = 1;
                        } else if (indexpath.row == 4 && sender.tag != 4) {
                            if (isAddCpf == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            isAddCpf = 0;
                            
                        }
                    }
                    
                    //有公积金
                    if (isAddAccumulationFund == 1) {
                        //有公积金并且为其他
                        if (isAddCpf == 1) {
                            // 点击的是是否有保险
                            if (indexpath.row == 7 && sender.tag == 1) {
                                if (isAddGRBXRange == 0) {
                                    [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                    [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 1;
                            } else if (indexpath.row == 7 && sender.tag != 1) {
                                if (isAddGRBXRange == 1) {
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 0;
                            }
                        } else{
                            // 点击的是是否有保险
                            if (indexpath.row == 6 && sender.tag == 1) {
                                if (isAddGRBXRange == 0) {
                                    [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                    [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 1;
                            } else if (indexpath.row == 6 && sender.tag != 1) {
                                if (isAddGRBXRange == 1) {
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 0;
                            }
                        }
                    } else {
                        //没有公积金
                        if (indexpath.row == 5 && sender.tag == 1) {
                            if (isAddGRBXRange == 0) {
                                [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 1;
                        } else if (indexpath.row == 5 && sender.tag != 1) {
                            if (isAddGRBXRange == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 0;
                        }
                    }
                } else {
                    //不是私营
                    //不是私营 并且 点击了是否有公积金
                    if (indexpath.row == 2 && sender.tag == 1) {
                        
                        if (isAddAccumulationFund == 0) {
                            [_sectionOneDataArray insertObject:node3 atIndex:indexpath.row+1];
                            if (isAddCpf == 1) {
                                
                                [_sectionOneDataArray insertObject:node4 atIndex:indexpath.row+2];
                            }
                        }
                        isAddAccumulationFund = 1;
                    } else if (indexpath.row == 2 && sender.tag == 2) {
                        if (isAddAccumulationFund == 1) {
                            [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            if (isAddCpf == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            
                        }
                        isAddAccumulationFund = 0;
                    }
                    //不是私营  有公积金 并且 点击了是否公积金范围为其他
                    if (isAddAccumulationFund == 1) {
                        if (indexpath.row == 3 && sender.tag == 4) {
                            if (isAddCpf == 0) {
                                [_sectionOneDataArray insertObject:node4 atIndex:indexpath.row+1];
                            }
                            isAddCpf = 1;
                            
                        } else if (indexpath.row == 3 && sender.tag != 4) {
                            if (isAddCpf == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            isAddCpf = 0;
                            
                        }
                    }
                    
                    
                    
                    if (isAddAccumulationFund == 1) {
                        //有公积金并且为其他
                        if (isAddCpf == 1) {
                            // 点击的是是否有保险
                            if (indexpath.row == 6 && sender.tag == 1) {
                                if (isAddGRBXRange == 0) {
                                    [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                    [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 1;
                            } else if (indexpath.row == 6 && sender.tag != 1) {
                                if (isAddGRBXRange == 1) {
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 0;
                            }
                        } else{
                            // 点击的是是否有保险
                            if (indexpath.row == 5 && sender.tag == 1) {
                                if (isAddGRBXRange == 0) {
                                    [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                    [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 1;
                            } else if (indexpath.row == 5 && sender.tag != 1) {
                                if (isAddGRBXRange == 1) {
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                    [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                }
                                isAddGRBXRange = 0;
                            }
                        }
                    } else {
                        //没有公积金
                        //点击是否有保险
                        if (indexpath.row == 4 && sender.tag == 1) {
                            if (isAddGRBXRange == 0) {
                                [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 1;
                        } else if (indexpath.row == 4 && sender.tag != 1) {
                            if (isAddGRBXRange == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 0;
                        }
                    }
                }
            } else {
                //自由职业
                //点击是否有公积金
                if (indexpath.row == 1 && sender.tag == 1) {
                    
                    if (isAddAccumulationFund == 0) {
                        [_sectionOneDataArray insertObject:node3 atIndex:indexpath.row+1];
                        if (isAddCpf == 1) {
                            
                            [_sectionOneDataArray insertObject:node4 atIndex:indexpath.row+2];
                        }
                    }
                    isAddAccumulationFund = 1;
                } else if (indexpath.row == 1 && sender.tag == 2) {
                    if (isAddAccumulationFund == 1) {
                        [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                        if (isAddCpf == 1) {
                            [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                        }
                        
                    }
                    isAddAccumulationFund = 0;
                }
                //有公积金 点击是否公积金范围为其他
                if (isAddAccumulationFund == 1) {
                    if (indexpath.row == 2 && sender.tag == 4) {
                        if (isAddCpf == 0) {
                            [_sectionOneDataArray insertObject:node4 atIndex:indexpath.row+1];
                        }
                        isAddCpf = 1;
                        
                    } else if (indexpath.row == 2 && sender.tag != 4) {
                        if (isAddCpf == 1) {
                            [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                        }
                        isAddCpf = 0;
                        
                    }
                }
                
                // 有公积金
                if (isAddAccumulationFund == 1) {
                    // 公积金范围为其他
                    if (isAddCpf == 1) {
                        //是否有保险
                        if (indexpath.row == 5 && sender.tag == 1) {
                            if (isAddGRBXRange == 0) {
                                [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 1;
                        } else if (indexpath.row == 5 && sender.tag != 1) {
                            if (isAddGRBXRange == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 0;
                        }
                    } else{
                        //公积金范围不是其他
                        //是否有保险
                        if (indexpath.row == 4 && sender.tag == 1) {
                            if (isAddGRBXRange == 0) {
                                [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                                [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 1;
                        } else if (indexpath.row == 4 && sender.tag != 1) {
                            if (isAddGRBXRange == 1) {
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                                [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            }
                            isAddGRBXRange = 0;
                        }
                    }
                } else {
                    // 没有公积金
                    //是否有保险
                    if (indexpath.row == 3 && sender.tag == 1) {
                        if (isAddGRBXRange == 0) {
                            [_sectionOneDataArray insertObject:node9 atIndex:indexpath.row+1];
                            [_sectionOneDataArray insertObject:node8 atIndex:indexpath.row+1];
                        }
                        isAddGRBXRange = 1;
                    } else if (indexpath.row == 3 && sender.tag != 1) {
                        if (isAddGRBXRange == 1) {
                            [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                            [_sectionOneDataArray removeObjectAtIndex:indexpath.row+1];
                        }
                        isAddGRBXRange = 0;
                    }
                }
            }
            
            
            
            for (TreeViewNode *node in _sectionOneDataArray) {
                [tmp addObject:node];
                
                if(node.isExpanded){
                    for(TreeViewNode *node2 in node.sonNodes){
                        [tmp addObject:node2];
                        if(node2.isExpanded){
                            for(TreeViewNode *node3 in node2.sonNodes){
                                [tmp addObject:node3];
                            }
                        }
                    }
                }
            }
            
            _sectionOneDisplayArray = [NSArray arrayWithArray:tmp];
            
        } else {
            
            NSMutableArray *tmp = [[NSMutableArray alloc]init];
            
            TreeViewNode *node = [_displayArray objectAtIndex:indexpath.row];
            subCellModel *nodeData = node.nodeData;
            if (sender.selected) {
                nodeData.index = sender.tag;
            } else {
                nodeData.index = 0;
            }
            
            
            TreeViewNode *node5 = [[TreeViewNode alloc]init];
            node5.nodeLevel = 2;//根层cell
            node5.type = 2;//type 2的cell
            node5.sonNodes = nil;
            node5.isExpanded = FALSE;//关闭状态
            subCellModel *model5 = [[subCellModel alloc]init];
            model5.name = @"购买价格／万元";
            model5.identification = @"购房总价格";
            model5.BtnArr = nil;
            model5.KeyType = 1;
            model5.type = 2;
            model5.index = 0;
            if (![self.CRMModel.asset_house_totalval isEqual:@"(null)"]) {
                model5.TFText = self.CRMModel.asset_house_totalval;;
            }
            node5.nodeData = model5;
            
            TreeViewNode *node7 = [[TreeViewNode alloc]init];
            node7.nodeLevel = 2;//根层cell
            node7.type = 2;//type 1的cell
            node7.sonNodes = nil;
            node7.isExpanded = FALSE;//关闭状态
            subCellModel *model7 = [[subCellModel alloc]init];
            model7.name = @"月 供／元";
            model7.identification = @"房产月供";
            model7.KeyType = 1;
            model7.BtnArr = nil;
            model7.type = 2;
            model7.index = 0;
            if (![self.CRMModel.asset_house_month isEqual:@"(null)"]) {
                model7.TFText = self.CRMModel.asset_house_month;
            }
            node7.nodeData = model7;
            
            
            TreeViewNode *node6 = [[TreeViewNode alloc]init];
            node6.nodeLevel = 2;//根层cell
            node6.type = 3;//type 1的cell
            node6.sonNodes = nil;
            node6.isExpanded = FALSE;//关闭状态
            subCellModel *model6 = [[subCellModel alloc]init];
            model6.name = @"月 供／元";
            model6.identification = @"购房月供";
            model6.BtnArr = [NSMutableArray arrayWithObjects:@"<3000",@"3000-6000",@">6000",@"其他", nil];
            model6.type = 4;
            model6.KeyType = 1;
            if (self.CRMModel.asset_house_monRange) {
                model6.index = [self.CRMModel.asset_house_monRange integerValue];
            } else {
                model6.index = 0;
            }
            node6.nodeData = model6;
            
            TreeViewNode *node13 = [[TreeViewNode alloc]init];
            node13.nodeLevel = 2;//根层cell
            node13.type = 3;//type 1的cell
            node13.sonNodes = nil;
            node13.isExpanded = FALSE;//关闭状态
            subCellModel *model13 = [[subCellModel alloc]init];
            model13.name = @"月 供／元";
            model13.identification = @"购车月供";
            model13.BtnArr = [NSMutableArray arrayWithObjects:@"<1500",@"1500-3000",@">3000",@"其他", nil];
            model13.type = 4;
            model13.KeyType = 1;
            if (self.CRMModel.asset_car_monRange) {
                model13.index = [self.CRMModel.asset_car_monRange integerValue];
            } else {
                model13.index = 0;
            }
            node13.nodeData = model13;
            
            
            TreeViewNode *node12 = [[TreeViewNode alloc]init];
            node12.nodeLevel = 2;//根层cell
            node12.type = 2;//type 2的cell
            node12.sonNodes = nil;
            node12.isExpanded = FALSE;//关闭状态
            subCellModel *model12 = [[subCellModel alloc]init];
            model12.name = @"购买价格／万元";
            model12.identification = @"购车总价格";
            model12.BtnArr = nil;
            model12.KeyType = 1;
            model12.type = 2;
            model12.index = 0;
            if (![self.CRMModel.asset_car_price isEqual:@"(null)"]) {
                model12.TFText = self.CRMModel.asset_car_price;;
            }
            node12.nodeData = model12;
            
            TreeViewNode *node14 = [[TreeViewNode alloc]init];
            node14.nodeLevel = 2;//根层cell
            node14.type = 2;//type 1的cell
            node14.sonNodes = nil;
            node14.isExpanded = FALSE;//关闭状态
            subCellModel *model14 = [[subCellModel alloc]init];
            model14.name = @"月 供／元";
            model14.identification = @"车辆月供";
            model14.KeyType = 1;
            model14.BtnArr = nil;
            model14.type = 2;
            model14.index = 0;
            if (![self.CRMModel.asset_car_month isEqual:@"(null)"]) {
                model14.TFText = self.CRMModel.asset_car_month;
            }
            node14.nodeData = model14;
            
            TreeViewNode *node27 = [[TreeViewNode alloc]init];
            node27.nodeLevel = 1;//根层cell
            node27.type = 2;//type 1的cell
            node27.sonNodes = nil;
            node27.isExpanded = FALSE;//关闭状态
            subCellModel *model27 = [[subCellModel alloc]init];
            model27.name = @"姓名";
            model27.BtnArr = nil;
            model27.identification = @"共同借款人姓名";
            model27.type = 2;
            model27.index = 0;
            if (![self.CRMModel.person_together_name isEqual:@"(null)"]) {
                model27.TFText = self.CRMModel.person_together_name;
            }
            node27.nodeData = model27;
            
            
            TreeViewNode *node3 = [[TreeViewNode alloc]init];
            node3.nodeLevel = 1;//根层cell
            node3.type = 2;//type 1的cell
            node3.sonNodes = nil;
            node3.isExpanded = FALSE;//关闭状态
            subCellModel *model3 = [[subCellModel alloc]init];
            model3.name = @"房产类型";
            model3.BtnArr = [NSMutableArray arrayWithObjects:@" 按 揭  ",@" 自 建  ",@" 全 款  ", nil];
            model3.type = 1;
            if (self.CRMModel.asset_house_type) {
                model3.index = [self.CRMModel.asset_house_type integerValue];
            } else {
                model3.index = 0;
            }
            node3.nodeData = model3;
            
            TreeViewNode *node10 = [[TreeViewNode alloc]init];
            node10.nodeLevel = 2;//根层cell
            node10.type = 2;//type 1的cell
            node10.sonNodes = nil;
            node10.isExpanded = FALSE;//关闭状态
            subCellModel *model10 = [[subCellModel alloc]init];
            model10.name = @"车辆类型";
            model10.BtnArr = [NSMutableArray arrayWithObjects:@" 按 揭  ",@" 全 款  ", nil];
            model10.type = 1;
            if (self.CRMModel.asset_car_type) {
                model10.index = [self.CRMModel.asset_car_type integerValue];
            } else {
                model10.index = 0;
            }
            node10.nodeData = model10;
            
            for (TreeViewNode *node in _dataArray) {
                superCellModel *model = node.nodeData;
                [tmp addObject:node];
                if ([model.name isEqualToString:@"个人信息"]) {
                    
                    if (self.isPersonalInfo == 0) {
                        personalInfoCount = 0;
                    } else {
                        personalInfoCount = node.sonNodes.count;
                    }
                }
#pragma mark == 修改点击资产信息事件
                if ([model.name isEqualToString:@"资产信息"]) {
                    if (self.isAssetInfo == 0) {
                        AssetInfoCount = 0;
                    } else {
                        AssetInfoCount = 2;
                    }
                    
                    for(TreeViewNode *node2 in node.sonNodes){
                        subCellModel *model1 = node2.nodeData;
                        
                        if ([model1.name isEqualToString:@"房产信息"]) {
                            DLog(@"房产1");
                            //房产展开
                            if (self.isHouseInfo == 1) {
                                //点击房产总价是否为其他
                                if (indexpath.row == 3+personalInfoCount+1 && sender.tag == 4) {
                                    if (isAddHouseTotal == 0) {
                                        DLog(@"房产2");
                                        [node2.sonNodes insertObject:node5 atIndex:2];
                                        houseInfoCount = houseInfoCount + 1;
                                    }
                                    isAddHouseTotal = 1;
                                } else if (indexpath.row == 3+personalInfoCount+1 && sender.tag != 4) {
                                    if (isAddHouseTotal == 1) {
                                        DLog(@"房产3");
                                        [node2.sonNodes removeObjectAtIndex:2];
                                        houseInfoCount = houseInfoCount - 1;
                                    }
                                    isAddHouseTotal = 0;
                                }
                                //房产总价为其他
                                if (isAddHouseTotal == 1) {
                                    // 点击是否为按揭
                                    if (indexpath.row == 3+personalInfoCount && sender.tag == 1) {
                                        if (isAddHouseInstallment == 0) {
                                            [node2.sonNodes insertObject:node6 atIndex:3];
                                            houseInfoCount = houseInfoCount + 1;
                                        }
                                        subCellModel *model = node6.nodeData;
                                        if (isAddHouseMonth == 0) {
                                            if (model.index == 4) {
                                                [node2.sonNodes insertObject:node7 atIndex:4];
                                                houseInfoCount = houseInfoCount + 1;
                                                isAddHouseMonth = 1;
                                            }
                                        }
                                        isAddHouseInstallment = 1;
                                    } else if (indexpath.row == 3+personalInfoCount && sender.tag != 1) {
                                        if (isAddHouseInstallment == 1) {
                                            [node2.sonNodes removeObjectAtIndex:3];
                                            houseInfoCount = houseInfoCount - 1;
                                            if (isAddHouseMonth == 1) {
                                                [node2.sonNodes removeObjectAtIndex:3];
                                                houseInfoCount = houseInfoCount - 1;
                                            }
                                            isAddHouseMonth = 0;
                                        }
                                        isAddHouseInstallment = 0;
                                    }
                                    //是按揭房
                                    if (isAddHouseInstallment == 1) {
                                        //是否点击 按揭范围为其他
                                        if (indexpath.row == 3+personalInfoCount+3 && sender.tag == 4) {
                                            if (isAddHouseMonth == 0) {
                                                DLog(@"房产4");
                                                [node2.sonNodes insertObject:node7 atIndex:4];
                                                houseInfoCount = houseInfoCount + 1;
                                            }
                                            isAddHouseMonth = 1;
                                        } else if (indexpath.row == 3+personalInfoCount+3 && sender.tag != 4) {
                                            if (isAddHouseMonth == 1) {
                                                DLog(@"房产5");
                                                [node2.sonNodes removeObjectAtIndex:4];
                                                houseInfoCount = houseInfoCount - 1;
                                            }
                                            isAddHouseMonth = 0;
                                        }
                                    }
                                    
                                } else  {
                                    //房产总价不是其他
                                    //是否点击了是按揭
                                    if (indexpath.row == 3+personalInfoCount && sender.tag == 1) {
                                        if (isAddHouseInstallment == 0) {
                                            [node2.sonNodes insertObject:node6 atIndex:2];
                                            houseInfoCount = houseInfoCount + 1;
                                            subCellModel *model = node6.nodeData;
                                            if (isAddHouseMonth == 0) {
                                                if (model.index == 4) {
                                                    [node2.sonNodes insertObject:node7 atIndex:3];
                                                    houseInfoCount = houseInfoCount + 1;
                                                    isAddHouseMonth = 1;
                                                }
                                            }
                                        }
                                        isAddHouseInstallment = 1;
                                    } else if (indexpath.row == 3+personalInfoCount && sender.tag != 1) {
                                        if (isAddHouseInstallment == 1) {
                                            [node2.sonNodes removeObjectAtIndex:2];
                                            houseInfoCount = houseInfoCount - 1;
                                            if (isAddHouseMonth == 1) {
                                                [node2.sonNodes removeObjectAtIndex:2];
                                                houseInfoCount = houseInfoCount - 1;
                                            }
                                            isAddHouseMonth = 0;
                                        }
                                        isAddHouseInstallment = 0;
                                    }
                                    //是按揭
                                    if (isAddHouseInstallment == 1) {
                                        //是否点击 房产月供为其他
                                        if (indexpath.row == 3+personalInfoCount+2 && sender.tag == 4) {
                                            if (isAddHouseMonth == 0) {
                                                DLog(@"房产6");
                                                [node2.sonNodes insertObject:node7 atIndex:3];
                                                houseInfoCount = houseInfoCount + 1;
                                            }
                                            isAddHouseMonth = 1;
                                        } else if (indexpath.row == 3+personalInfoCount+2 && sender.tag != 4) {
                                            if (isAddHouseMonth == 1) {
                                                DLog(@"房产7");
                                                [node2.sonNodes removeObjectAtIndex:3];
                                                houseInfoCount = houseInfoCount - 1;
                                            }
                                            isAddHouseMonth = 0;
                                        }
                                    }
                                    
                                    
                                }
                            }
                        } else if ([model1.name isEqualToString:@"车辆信息"]) {
                            //车辆信息展开
                            if (self.isCarInfo == 1) {
                                DLog(@"车辆1");
                                //点击是否车辆总价为其他
                                if (indexpath.row == 4+personalInfoCount+houseInfoCount+1 && sender.tag == 4) {
                                    if (isAddCarTotal == 0) {
                                        DLog(@"车辆2");
                                        [node2.sonNodes insertObject:node12 atIndex:2];
                                        carInfoCount = carInfoCount + 1;
                                    }
                                    isAddCarTotal = 1;
                                } else if (indexpath.row == 4+personalInfoCount+houseInfoCount+1 && sender.tag != 4) {
                                    if (isAddCarTotal == 1) {
                                        DLog(@"车辆3");
                                        [node2.sonNodes removeObjectAtIndex:2];
                                        carInfoCount = carInfoCount - 1;
                                    }
                                    isAddCarTotal = 0;
                                }
                                //车辆总价为其他
                                if (isAddCarTotal == 1) {
                                    //
                                    if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag == 1) {
                                        if (isAddCarInstallment == 0) {
                                            [node2.sonNodes insertObject:node13 atIndex:3];
                                            carInfoCount = carInfoCount + 1;
                                            subCellModel *model = node13.nodeData;
                                            if (isAddCarMonth == 0) {
                                                if (model.index == 4) {
                                                    [node2.sonNodes insertObject:node14 atIndex:4];
                                                    carInfoCount = carInfoCount + 1;
                                                    isAddCarMonth = 1;
                                                }
                                            }
                                        }
                                        isAddCarInstallment = 1;
                                    } else if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag != 1) {
                                        if (isAddCarInstallment == 1) {
                                            [node2.sonNodes removeObjectAtIndex:3];
                                            carInfoCount = carInfoCount - 1;
                                            if (isAddCarMonth == 1) {
                                                [node2.sonNodes removeObjectAtIndex:3];
                                                carInfoCount = carInfoCount - 1;
                                            }
                                            isAddCarMonth = 0;
                                        }
                                        isAddCarInstallment = 0;
                                    }
                                    if (isAddCarInstallment == 1) {
                                        if (indexpath.row == 4+personalInfoCount+houseInfoCount+3 && sender.tag == 4) {
                                            if (isAddCarMonth == 0) {
                                                DLog(@"车辆4");
                                                [node2.sonNodes insertObject:node14 atIndex:4];
                                                carInfoCount = carInfoCount + 1;
                                            }
                                            isAddCarMonth = 1;
                                        } else if (indexpath.row == 4+personalInfoCount+houseInfoCount+3 && sender.tag != 4) {
                                            if (isAddCarMonth == 1) {
                                                DLog(@"车辆5");
                                                [node2.sonNodes removeObjectAtIndex:4];
                                                carInfoCount = carInfoCount - 1;
                                            }
                                            isAddCarMonth = 0;
                                        }
                                    }
                                    
                                } else  {
                                    
                                    if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag == 1) {
                                        if (isAddCarInstallment == 0) {
                                            [node2.sonNodes insertObject:node13 atIndex:2];
                                            carInfoCount = carInfoCount + 1;
                                            subCellModel *model = node13.nodeData;
                                            if (isAddCarMonth == 0) {
                                                if (model.index == 4) {
                                                    [node2.sonNodes insertObject:node14 atIndex:3];
                                                    carInfoCount = carInfoCount + 1;
                                                    isAddCarMonth = 1;
                                                }
                                            }
                                        }
                                        isAddCarInstallment = 1;
                                    } else if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag != 1) {
                                        if (isAddCarInstallment == 1) {
                                            [node2.sonNodes removeObjectAtIndex:2];
                                            carInfoCount = carInfoCount - 1;
                                            if (isAddCarMonth == 1) {
                                                [node2.sonNodes removeObjectAtIndex:2];
                                                carInfoCount = carInfoCount - 1;
                                            }
                                            isAddCarMonth = 0;
                                        }
                                        isAddCarInstallment = 0;
                                    }
                                    
                                    if (isAddCarInstallment == 1) {
                                        if (indexpath.row == 4+personalInfoCount+houseInfoCount+2 && sender.tag == 4) {
                                            if (isAddCarMonth == 0) {
                                                DLog(@"车辆6");
                                                [node2.sonNodes insertObject:node14 atIndex:3];
                                                carInfoCount = carInfoCount + 1;
                                            }
                                            isAddCarMonth = 1;
                                        } else if (indexpath.row == 4+personalInfoCount+houseInfoCount+2 && sender.tag != 4) {
                                            if (isAddCarMonth == 1) {
                                                DLog(@"车辆7");
                                                [node2.sonNodes removeObjectAtIndex:3];
                                                carInfoCount = carInfoCount - 1;
                                            }
                                            isAddCarMonth = 0;
                                        }
                                    }
                                    
                                }
                                DLog(@"indexpath.row == %ld ... sender.tag == %ld ... houseCount == %ld ... carCount == %ld",indexpath.row,sender.tag,houseInfoCount,carInfoCount);
                                
                                /**
                                 if ([model1.identification isEqualToString:@"购车价格"] && sender.tag == 4) {
                                 
                                 if (isAddHouseTotal == 0) {
                                 [node2.sonNodes insertObject:node5 atIndex:2];
                                 houseInfoCount = houseInfoCount + 1;
                                 }
                                 isAddHouseTotal = 1;
                                 } else if ([model1.identification isEqualToString:@"购车价格"] && sender.tag != 4) {
                                 if (isAddHouseTotal == 1) {
                                 [node2.sonNodes removeObjectAtIndex:2];
                                 houseInfoCount = houseInfoCount - 1;
                                 }
                                 isAddHouseTotal = 0;
                                 }
                                 
                                 if ([model1.identification isEqualToString:@"购车月供"] && sender.tag == 4) {
                                 
                                 if (isAddHouseTotal == 1) {
                                 if (isAddHouseMonth == 0) {
                                 [node2.sonNodes insertObject:node7 atIndex:4];
                                 houseInfoCount = houseInfoCount + 1;
                                 }
                                 isAddHouseMonth = 1;
                                 } else {
                                 if (isAddHouseMonth == 0) {
                                 [node2.sonNodes insertObject:node7 atIndex:3];
                                 houseInfoCount = houseInfoCount + 1;
                                 }
                                 isAddHouseMonth = 1;
                                 }
                                 } else if ([model1.identification isEqualToString:@"购车月供"] && sender.tag != 4) {
                                 if (isAddHouseTotal == 1) {
                                 if (isAddHouseMonth == 1) {
                                 [node2.sonNodes removeObjectAtIndex:4];
                                 houseInfoCount = houseInfoCount - 1;
                                 }
                                 isAddHouseMonth = 0;
                                 } else {
                                 if (isAddHouseMonth == 0) {
                                 [node2.sonNodes removeObjectAtIndex:3];
                                 houseInfoCount = houseInfoCount - 1;
                                 }
                                 isAddHouseMonth = 1;
                                 }
                                 }
                                 */
                                
                            }
                            
                        }
                        
                        
                    }
                }
                DLog(@"model.name == %@",model.name);
                if ([model.name isEqualToString:@"工作信息"]) {
                    
                }
                if ([model.name isEqualToString:@"客户来源"]) {
                    
                }
                if ([model.name isEqualToString:@"联系人信息"]) {
                    if (self.isContactsInfo == 1) {
                        if ([titleLb.text isEqualToString:@"共同借款人"]) {
                            if (sender.tag == 1) {
                                if (isAddTogether == 0) {
                                    [node.sonNodes insertObject:node27 atIndex:node.sonNodes.count];
                                    isAddTogether = 1;
                                    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                                        contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                                    } else {
                                        contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                                    }
                                    
                                }
                            } else {
                                if (isAddTogether == 1) {
                                    [node.sonNodes removeObjectAtIndex:node.sonNodes.count-1];
                                    isAddTogether = 0;
                                    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                                        contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                                    } else {
                                        contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                if(node.isExpanded){
                    for(TreeViewNode *node2 in node.sonNodes){
                        [tmp addObject:node2];
                        
                        if(node2.isExpanded){
                            for(TreeViewNode *node3 in node2.sonNodes){
                                [tmp addObject:node3];
                            }
                        }
                    }
                }
            }
            
            
            _displayArray = [NSArray arrayWithArray:tmp];
        }
    } else {
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        
        TreeViewNode *node = [_displayArray objectAtIndex:indexpath.row];
        subCellModel *nodeData = node.nodeData;
        if (sender.selected) {
            nodeData.index = sender.tag;
        } else {
            nodeData.index = 0;
        }
        
        
        TreeViewNode *node5 = [[TreeViewNode alloc]init];
        node5.nodeLevel = 2;//根层cell
        node5.type = 2;//type 2的cell
        node5.sonNodes = nil;
        node5.isExpanded = FALSE;//关闭状态
        subCellModel *model5 = [[subCellModel alloc]init];
        model5.name = @"购买价格／万元";
        model5.identification = @"购房总价格";
        model5.BtnArr = nil;
        model5.KeyType = 1;
        model5.type = 2;
        model5.index = 0;
        if (![self.CRMModel.asset_house_totalval isEqual:@"(null)"]) {
            model5.TFText = self.CRMModel.asset_house_totalval;;
        }
        node5.nodeData = model5;
        
        TreeViewNode *node7 = [[TreeViewNode alloc]init];
        node7.nodeLevel = 2;//根层cell
        node7.type = 2;//type 1的cell
        node7.sonNodes = nil;
        node7.isExpanded = FALSE;//关闭状态
        subCellModel *model7 = [[subCellModel alloc]init];
        model7.name = @"月 供／元";
        model7.identification = @"房产月供";
        model7.KeyType = 1;
        model7.BtnArr = nil;
        model7.type = 2;
        model7.index = 0;
        if (![self.CRMModel.asset_house_month isEqual:@"(null)"]) {
            model7.TFText = self.CRMModel.asset_house_month;
        }
        node7.nodeData = model7;
        
        
        TreeViewNode *node6 = [[TreeViewNode alloc]init];
        node6.nodeLevel = 2;//根层cell
        node6.type = 3;//type 1的cell
        node6.sonNodes = nil;
        node6.isExpanded = FALSE;//关闭状态
        subCellModel *model6 = [[subCellModel alloc]init];
        model6.name = @"月 供／元";
        model6.identification = @"购房月供";
        model6.BtnArr = [NSMutableArray arrayWithObjects:@"<3000",@"3000-6000",@">6000",@"其他", nil];
        model6.type = 4;
        model6.KeyType = 1;
        if (self.CRMModel.asset_house_monRange) {
            model6.index = [self.CRMModel.asset_house_monRange integerValue];
        } else {
            model6.index = 0;
        }
        node6.nodeData = model6;
        
        TreeViewNode *node13 = [[TreeViewNode alloc]init];
        node13.nodeLevel = 2;//根层cell
        node13.type = 3;//type 1的cell
        node13.sonNodes = nil;
        node13.isExpanded = FALSE;//关闭状态
        subCellModel *model13 = [[subCellModel alloc]init];
        model13.name = @"月 供／元";
        model13.identification = @"购车月供";
        model13.BtnArr = [NSMutableArray arrayWithObjects:@"<1500",@"1500-3000",@">3000",@"其他", nil];
        model13.type = 4;
        model13.KeyType = 1;
        if (self.CRMModel.asset_car_monRange) {
            model13.index = [self.CRMModel.asset_car_monRange integerValue];
        } else {
            model13.index = 0;
        }
        node13.nodeData = model13;
        
        
        TreeViewNode *node12 = [[TreeViewNode alloc]init];
        node12.nodeLevel = 2;//根层cell
        node12.type = 2;//type 2的cell
        node12.sonNodes = nil;
        node12.isExpanded = FALSE;//关闭状态
        subCellModel *model12 = [[subCellModel alloc]init];
        model12.name = @"购买价格／万元";
        model12.identification = @"购车总价格";
        model12.BtnArr = nil;
        model12.KeyType = 1;
        model12.type = 2;
        model12.index = 0;
        if (![self.CRMModel.asset_car_price isEqual:@"(null)"]) {
            model12.TFText = self.CRMModel.asset_car_price;;
        }
        node12.nodeData = model12;
        
        TreeViewNode *node14 = [[TreeViewNode alloc]init];
        node14.nodeLevel = 2;//根层cell
        node14.type = 2;//type 1的cell
        node14.sonNodes = nil;
        node14.isExpanded = FALSE;//关闭状态
        subCellModel *model14 = [[subCellModel alloc]init];
        model14.name = @"月 供／元";
        model14.identification = @"车辆月供";
        model14.KeyType = 1;
        model14.BtnArr = nil;
        model14.type = 2;
        model14.index = 0;
        if (![self.CRMModel.asset_car_month isEqual:@"(null)"]) {
            model14.TFText = self.CRMModel.asset_car_month;
        }
        node14.nodeData = model14;
        
        TreeViewNode *node27 = [[TreeViewNode alloc]init];
        node27.nodeLevel = 1;//根层cell
        node27.type = 2;//type 1的cell
        node27.sonNodes = nil;
        node27.isExpanded = FALSE;//关闭状态
        subCellModel *model27 = [[subCellModel alloc]init];
        model27.name = @"姓名";
        model27.BtnArr = nil;
        model27.identification = @"共同借款人姓名";
        model27.type = 2;
        model27.index = 0;
        if (![self.CRMModel.person_together_name isEqual:@"(null)"]) {
            model27.TFText = self.CRMModel.person_together_name;
        }
        node27.nodeData = model27;
        
        
        TreeViewNode *node3 = [[TreeViewNode alloc]init];
        node3.nodeLevel = 1;//根层cell
        node3.type = 2;//type 1的cell
        node3.sonNodes = nil;
        node3.isExpanded = FALSE;//关闭状态
        subCellModel *model3 = [[subCellModel alloc]init];
        model3.name = @"房产类型";
        model3.BtnArr = [NSMutableArray arrayWithObjects:@" 按 揭  ",@" 自 建  ",@" 全 款  ", nil];
        model3.type = 1;
        if (self.CRMModel.asset_house_type) {
            model3.index = [self.CRMModel.asset_house_type integerValue];
        } else {
            model3.index = 0;
        }
        node3.nodeData = model3;
        
        TreeViewNode *node10 = [[TreeViewNode alloc]init];
        node10.nodeLevel = 2;//根层cell
        node10.type = 2;//type 1的cell
        node10.sonNodes = nil;
        node10.isExpanded = FALSE;//关闭状态
        subCellModel *model10 = [[subCellModel alloc]init];
        model10.name = @"车辆类型";
        model10.BtnArr = [NSMutableArray arrayWithObjects:@" 按 揭  ",@" 全 款  ", nil];
        model10.type = 1;
        if (self.CRMModel.asset_car_type) {
            model10.index = [self.CRMModel.asset_car_type integerValue];
        } else {
            model10.index = 0;
        }
        node10.nodeData = model10;
        
        for (TreeViewNode *node in _dataArray) {
            superCellModel *model = node.nodeData;
            [tmp addObject:node];
            if ([model.name isEqualToString:@"个人信息"]) {
                
                if (self.isPersonalInfo == 0) {
                    personalInfoCount = 0;
                } else {
                    personalInfoCount = node.sonNodes.count;
                }
            }
#pragma mark == 修改点击资产信息事件
            if ([model.name isEqualToString:@"资产信息"]) {
                if (self.isAssetInfo == 0) {
                    AssetInfoCount = 0;
                } else {
                    AssetInfoCount = 2;
                }
                
                for(TreeViewNode *node2 in node.sonNodes){
                    subCellModel *model1 = node2.nodeData;
                    
                    if ([model1.name isEqualToString:@"房产信息"]) {
                        DLog(@"房产1");
                        //房产展开
                        if (self.isHouseInfo == 1) {
                            //点击房产总价是否为其他
                            if (indexpath.row == 3+personalInfoCount+1 && sender.tag == 4) {
                                if (isAddHouseTotal == 0) {
                                    DLog(@"房产2");
                                    [node2.sonNodes insertObject:node5 atIndex:2];
                                    houseInfoCount = houseInfoCount + 1;
                                }
                                isAddHouseTotal = 1;
                            } else if (indexpath.row == 3+personalInfoCount+1 && sender.tag != 4) {
                                if (isAddHouseTotal == 1) {
                                    DLog(@"房产3");
                                    [node2.sonNodes removeObjectAtIndex:2];
                                    houseInfoCount = houseInfoCount - 1;
                                }
                                isAddHouseTotal = 0;
                            }
                            //房产总价为其他
                            if (isAddHouseTotal == 1) {
                                // 点击是否为按揭
                                if (indexpath.row == 3+personalInfoCount && sender.tag == 1) {
                                    if (isAddHouseInstallment == 0) {
                                        [node2.sonNodes insertObject:node6 atIndex:3];
                                        houseInfoCount = houseInfoCount + 1;
                                    }
                                    subCellModel *model = node6.nodeData;
                                    if (isAddHouseMonth == 0) {
                                        if (model.index == 4) {
                                            [node2.sonNodes insertObject:node7 atIndex:4];
                                            houseInfoCount = houseInfoCount + 1;
                                            isAddHouseMonth = 1;
                                        }
                                    }
                                    isAddHouseInstallment = 1;
                                } else if (indexpath.row == 3+personalInfoCount && sender.tag != 1) {
                                    if (isAddHouseInstallment == 1) {
                                        [node2.sonNodes removeObjectAtIndex:3];
                                        houseInfoCount = houseInfoCount - 1;
                                        if (isAddHouseMonth == 1) {
                                            [node2.sonNodes removeObjectAtIndex:3];
                                            houseInfoCount = houseInfoCount - 1;
                                        }
                                        isAddHouseMonth = 0;
                                    }
                                    isAddHouseInstallment = 0;
                                }
                                //是按揭房
                                if (isAddHouseInstallment == 1) {
                                    //是否点击 按揭范围为其他
                                    if (indexpath.row == 3+personalInfoCount+3 && sender.tag == 4) {
                                        if (isAddHouseMonth == 0) {
                                            DLog(@"房产4");
                                            [node2.sonNodes insertObject:node7 atIndex:4];
                                            houseInfoCount = houseInfoCount + 1;
                                        }
                                        isAddHouseMonth = 1;
                                    } else if (indexpath.row == 3+personalInfoCount+3 && sender.tag != 4) {
                                        if (isAddHouseMonth == 1) {
                                            DLog(@"房产5");
                                            [node2.sonNodes removeObjectAtIndex:4];
                                            houseInfoCount = houseInfoCount - 1;
                                        }
                                        isAddHouseMonth = 0;
                                    }
                                }
                                
                            } else  {
                                //房产总价不是其他
                                //是否点击了是按揭
                                if (indexpath.row == 3+personalInfoCount && sender.tag == 1) {
                                    if (isAddHouseInstallment == 0) {
                                        [node2.sonNodes insertObject:node6 atIndex:2];
                                        houseInfoCount = houseInfoCount + 1;
                                        subCellModel *model = node6.nodeData;
                                        if (isAddHouseMonth == 0) {
                                            if (model.index == 4) {
                                                [node2.sonNodes insertObject:node7 atIndex:3];
                                                houseInfoCount = houseInfoCount + 1;
                                                isAddHouseMonth = 1;
                                            }
                                        }
                                    }
                                    isAddHouseInstallment = 1;
                                } else if (indexpath.row == 3+personalInfoCount && sender.tag != 1) {
                                    if (isAddHouseInstallment == 1) {
                                        [node2.sonNodes removeObjectAtIndex:2];
                                        houseInfoCount = houseInfoCount - 1;
                                        if (isAddHouseMonth == 1) {
                                            [node2.sonNodes removeObjectAtIndex:2];
                                            houseInfoCount = houseInfoCount - 1;
                                        }
                                        isAddHouseMonth = 0;
                                    }
                                    isAddHouseInstallment = 0;
                                }
                                //是按揭
                                if (isAddHouseInstallment == 1) {
                                    //是否点击 房产月供为其他
                                    if (indexpath.row == 3+personalInfoCount+2 && sender.tag == 4) {
                                        if (isAddHouseMonth == 0) {
                                            DLog(@"房产6");
                                            [node2.sonNodes insertObject:node7 atIndex:3];
                                            houseInfoCount = houseInfoCount + 1;
                                        }
                                        isAddHouseMonth = 1;
                                    } else if (indexpath.row == 3+personalInfoCount+2 && sender.tag != 4) {
                                        if (isAddHouseMonth == 1) {
                                            DLog(@"房产7");
                                            [node2.sonNodes removeObjectAtIndex:3];
                                            houseInfoCount = houseInfoCount - 1;
                                        }
                                        isAddHouseMonth = 0;
                                    }
                                }
                                
                                
                            }
                        }
                    } else if ([model1.name isEqualToString:@"车辆信息"]) {
                        //车辆信息展开
                        if (self.isCarInfo == 1) {
                            DLog(@"车辆1");
                            //点击是否车辆总价为其他
                            if (indexpath.row == 4+personalInfoCount+houseInfoCount+1 && sender.tag == 4) {
                                if (isAddCarTotal == 0) {
                                    DLog(@"车辆2");
                                    [node2.sonNodes insertObject:node12 atIndex:2];
                                    carInfoCount = carInfoCount + 1;
                                }
                                isAddCarTotal = 1;
                            } else if (indexpath.row == 4+personalInfoCount+houseInfoCount+1 && sender.tag != 4) {
                                if (isAddCarTotal == 1) {
                                    DLog(@"车辆3");
                                    [node2.sonNodes removeObjectAtIndex:2];
                                    carInfoCount = carInfoCount - 1;
                                }
                                isAddCarTotal = 0;
                            }
                            //车辆总价为其他
                            if (isAddCarTotal == 1) {
                                //
                                if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag == 1) {
                                    if (isAddCarInstallment == 0) {
                                        [node2.sonNodes insertObject:node13 atIndex:3];
                                        carInfoCount = carInfoCount + 1;
                                        subCellModel *model = node13.nodeData;
                                        if (isAddCarMonth == 0) {
                                            if (model.index == 4) {
                                                [node2.sonNodes insertObject:node14 atIndex:4];
                                                carInfoCount = carInfoCount + 1;
                                                isAddCarMonth = 1;
                                            }
                                        }
                                    }
                                    isAddCarInstallment = 1;
                                } else if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag != 1) {
                                    if (isAddCarInstallment == 1) {
                                        [node2.sonNodes removeObjectAtIndex:3];
                                        carInfoCount = carInfoCount - 1;
                                        if (isAddCarMonth == 1) {
                                            [node2.sonNodes removeObjectAtIndex:3];
                                            carInfoCount = carInfoCount - 1;
                                        }
                                        isAddCarMonth = 0;
                                    }
                                    isAddCarInstallment = 0;
                                }
                                if (isAddCarInstallment == 1) {
                                    if (indexpath.row == 4+personalInfoCount+houseInfoCount+3 && sender.tag == 4) {
                                        if (isAddCarMonth == 0) {
                                            DLog(@"车辆4");
                                            [node2.sonNodes insertObject:node14 atIndex:4];
                                            carInfoCount = carInfoCount + 1;
                                        }
                                        isAddCarMonth = 1;
                                    } else if (indexpath.row == 4+personalInfoCount+houseInfoCount+3 && sender.tag != 4) {
                                        if (isAddCarMonth == 1) {
                                            DLog(@"车辆5");
                                            [node2.sonNodes removeObjectAtIndex:4];
                                            carInfoCount = carInfoCount - 1;
                                        }
                                        isAddCarMonth = 0;
                                    }
                                }
                                
                            } else  {
                                
                                if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag == 1) {
                                    if (isAddCarInstallment == 0) {
                                        [node2.sonNodes insertObject:node13 atIndex:2];
                                        carInfoCount = carInfoCount + 1;
                                        subCellModel *model = node13.nodeData;
                                        if (isAddCarMonth == 0) {
                                            if (model.index == 4) {
                                                [node2.sonNodes insertObject:node14 atIndex:3];
                                                carInfoCount = carInfoCount + 1;
                                                isAddCarMonth = 1;
                                            }
                                        }
                                    }
                                    isAddCarInstallment = 1;
                                } else if (indexpath.row == 4+personalInfoCount+houseInfoCount && sender.tag != 1) {
                                    if (isAddCarInstallment == 1) {
                                        [node2.sonNodes removeObjectAtIndex:2];
                                        carInfoCount = carInfoCount - 1;
                                        if (isAddCarMonth == 1) {
                                            [node2.sonNodes removeObjectAtIndex:2];
                                            carInfoCount = carInfoCount - 1;
                                        }
                                        isAddCarMonth = 0;
                                    }
                                    isAddCarInstallment = 0;
                                }
                                
                                if (isAddCarInstallment == 1) {
                                    if (indexpath.row == 4+personalInfoCount+houseInfoCount+2 && sender.tag == 4) {
                                        if (isAddCarMonth == 0) {
                                            DLog(@"车辆6");
                                            [node2.sonNodes insertObject:node14 atIndex:3];
                                            carInfoCount = carInfoCount + 1;
                                        }
                                        isAddCarMonth = 1;
                                    } else if (indexpath.row == 4+personalInfoCount+houseInfoCount+2 && sender.tag != 4) {
                                        if (isAddCarMonth == 1) {
                                            DLog(@"车辆7");
                                            [node2.sonNodes removeObjectAtIndex:3];
                                            carInfoCount = carInfoCount - 1;
                                        }
                                        isAddCarMonth = 0;
                                    }
                                }
                                
                            }
                            DLog(@"indexpath.row == %ld ... sender.tag == %ld ... houseCount == %ld ... carCount == %ld",indexpath.row,sender.tag,houseInfoCount,carInfoCount);
                            
                            /**
                             if ([model1.identification isEqualToString:@"购车价格"] && sender.tag == 4) {
                             
                             if (isAddHouseTotal == 0) {
                             [node2.sonNodes insertObject:node5 atIndex:2];
                             houseInfoCount = houseInfoCount + 1;
                             }
                             isAddHouseTotal = 1;
                             } else if ([model1.identification isEqualToString:@"购车价格"] && sender.tag != 4) {
                             if (isAddHouseTotal == 1) {
                             [node2.sonNodes removeObjectAtIndex:2];
                             houseInfoCount = houseInfoCount - 1;
                             }
                             isAddHouseTotal = 0;
                             }
                             
                             if ([model1.identification isEqualToString:@"购车月供"] && sender.tag == 4) {
                             
                             if (isAddHouseTotal == 1) {
                             if (isAddHouseMonth == 0) {
                             [node2.sonNodes insertObject:node7 atIndex:4];
                             houseInfoCount = houseInfoCount + 1;
                             }
                             isAddHouseMonth = 1;
                             } else {
                             if (isAddHouseMonth == 0) {
                             [node2.sonNodes insertObject:node7 atIndex:3];
                             houseInfoCount = houseInfoCount + 1;
                             }
                             isAddHouseMonth = 1;
                             }
                             } else if ([model1.identification isEqualToString:@"购车月供"] && sender.tag != 4) {
                             if (isAddHouseTotal == 1) {
                             if (isAddHouseMonth == 1) {
                             [node2.sonNodes removeObjectAtIndex:4];
                             houseInfoCount = houseInfoCount - 1;
                             }
                             isAddHouseMonth = 0;
                             } else {
                             if (isAddHouseMonth == 0) {
                             [node2.sonNodes removeObjectAtIndex:3];
                             houseInfoCount = houseInfoCount - 1;
                             }
                             isAddHouseMonth = 1;
                             }
                             }
                             */
                            
                        }
                        
                    }
                    
                    
                }
            }
            DLog(@"model.name == %@",model.name);
            if ([model.name isEqualToString:@"工作信息"]) {
                
            }
            if ([model.name isEqualToString:@"客户来源"]) {
                
            }
            if ([model.name isEqualToString:@"联系人信息"]) {
                if (self.isContactsInfo == 1) {
                    if ([titleLb.text isEqualToString:@"共同借款人"]) {
                        if (sender.tag == 1) {
                            if (isAddTogether == 0) {
                                [node.sonNodes insertObject:node27 atIndex:node.sonNodes.count];
                                isAddTogether = 1;
                                if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                                } else {
                                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                                }
                                
                            }
                        } else {
                            if (isAddTogether == 1) {
                                [node.sonNodes removeObjectAtIndex:node.sonNodes.count-1];
                                isAddTogether = 0;
                                if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
                                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                                } else {
                                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                                }
                                
                            }
                        }
                    }
                }
            }
            if(node.isExpanded){
                for(TreeViewNode *node2 in node.sonNodes){
                    [tmp addObject:node2];
                    
                    if(node2.isExpanded){
                        for(TreeViewNode *node3 in node2.sonNodes){
                            [tmp addObject:node3];
                        }
                    }
                }
            }
        }
        
        
        _displayArray = [NSArray arrayWithArray:tmp];
    }
    
    
    
    [self.CRMDetailsTableView reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.MyUserInfoModel.type isEqualToString:@"1"]) {
        if (indexPath.section == 2) {
            TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
            
            if(node.type == 2){
                //处理叶子节点选中，此处需要自定义
                subCellModel *model = node.nodeData;
                if (isEdit) {
                    if ([model.name isEqualToString:@"融资顾问"]) {
                        NSLog(@"融资顾问");
                        chooseViewController *choosePeople = [chooseViewController new];
                        choosePeople.seType = 1;
                        [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
                            self.returnPeople = returnMutableArray;
                            if (self.returnPeople.count != 0) {
                                
                                ContactModel *model = self.returnPeople[0];
                                headPeopleName = model.realName;
                                self.adviserId = [NSString stringWithFormat:@"%ld",model.userId];
                                NSLog(@"headPeopleID == %@",self.adviserId);
                                [self.CRMDetailsTableView reloadData];
                            } else {
                                
                                headPeopleName = @"点击选取";
                            }
                        }];
                        
                        [self.navigationController pushViewController:choosePeople animated:YES];
                    }else if ([model.name isEqualToString:@"申请产品"]) {
                        NSLog(@"申请产品");
                        ProductManageViewController *productChoose = [ProductManageViewController new];
                        productChoose.seType = 4;
                        //                    if (self.seType == 1) {
                        //                        productChoose.limit = 0;
                        //                        productChoose.limitArr = self.productArr;
                        //                    }
                        
                        if (self.returnNameArray.count == 0) {
                            NSMutableArray *proIDArray = [NSMutableArray arrayWithCapacity:0];
                            for (productModel *model  in self.productArr) {
                                [proIDArray addObject:model.ID];
                            }
                            self.returnIDArray = proIDArray;
                        }
                        
                        [productChoose returnIDMutableArray:^(NSMutableArray *returnIDMutableArray) {
                            self.returnIDArray = returnIDMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                            
                        }];
                        [productChoose returnNameMutableArray:^(NSMutableArray *returnNameMutableArray) {
                            self.returnNameArray = returnNameMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                            
                        }];
                        productChoose.taskMechProIDArr = self.returnIDArray;
                        productChoose.taskMechProNameArr = self.returnNameArray;
                        [self.navigationController pushViewController:productChoose animated:YES];
                    } else if ([model.name isEqualToString:@"购买日期"]) {
                        if ([model.identification isEqualToString:@"购房日期"]) {
                            ClickRowName = @"购房日期";
                        } else {
                            ClickRowName = @"购车日期";
                        }
                        
                        [tableView endEditing:YES];
                        _dateTimeSelectView.hidden = NO;
                        self.bgView.hidden = NO;
                        [UIView animateWithDuration:animateTime animations:^{
                            _dateTimeSelectView.frame = timeViewRect;
                        }];
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    } else if ([model.name isEqualToString:@"成立时间"]) {
                        ClickRowName = @"成立时间";
                        
                        [tableView endEditing:YES];
                        _dateTimeSelectView.hidden = NO;
                        self.bgView.hidden = NO;
                        [UIView animateWithDuration:animateTime animations:^{
                            _dateTimeSelectView.frame = timeViewRect;
                        }];
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    }else if ([model.name isEqualToString:@"入职时间"]) {
                        ClickRowName = @"入职时间";
                        
                        [tableView endEditing:YES];
                        _dateTimeSelectView.hidden = NO;
                        self.bgView.hidden = NO;
                        [UIView animateWithDuration:animateTime animations:^{
                            _dateTimeSelectView.frame = timeViewRect;
                        }];
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    }
                } else {
                    if ([model.name isEqualToString:@"申请产品"]) {
                        NSLog(@"申请产品");
                        ProductManageViewController *productChoose = [ProductManageViewController new];
                        productChoose.seType = 4;
                        if (self.seType == 1) {
                            productChoose.limit = 1;
                            productChoose.limitArr = self.productArr;
                        }
                        
                        [productChoose returnIDMutableArray:^(NSMutableArray *returnIDMutableArray) {
                            self.returnIDArray = returnIDMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                            
                        }];
                        [productChoose returnNameMutableArray:^(NSMutableArray *returnNameMutableArray) {
                            self.returnNameArray = returnNameMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                        }];
                        [self.navigationController pushViewController:productChoose animated:YES];
                    }
                }
                
            }else{
                if (indexPath.section == 2) {
                    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
                    if (node.type == 0) {
                        superCellModel *nodeData = node.nodeData;
                        if ([nodeData.name isEqualToString:@"备       注"]) {
                            self.remarkIndexPath = indexPath;
                            
                            [self.CRMDetailsTableView reloadData];
                            
                            if (self.isRemark) {
                                [self.CRMDetailsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.remarkIndexPath.row+1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//UITableViewScrollPositionBottom
                            }
                            
                        }
                        if ([nodeData.name isEqualToString:@"融资方案"]) {
                            
                        }
                    }
                }
                
                
            }
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            DLog(@"userMobile == %@",userMobile);
            NSString *callStr = [NSString stringWithFormat:@"tel:%@",userMobile];
            UIWebView *callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }
    } else {
        if (indexPath.section == 1) {
            TreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
            
            if(node.type == 2){
                //处理叶子节点选中，此处需要自定义
                subCellModel *model = node.nodeData;
                if (isEdit) {
                    if ([model.name isEqualToString:@"融资顾问"]) {
                        NSLog(@"融资顾问");
                        chooseViewController *choosePeople = [chooseViewController new];
                        choosePeople.seType = 1;
                        [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
                            self.returnPeople = returnMutableArray;
                            if (self.returnPeople.count != 0) {
                                
                                ContactModel *model = self.returnPeople[0];
                                headPeopleName = model.realName;
                                self.adviserId = [NSString stringWithFormat:@"%ld",model.userId];
                                NSLog(@"headPeopleID == %@",self.adviserId);
                                [self.CRMDetailsTableView reloadData];
                            } else {
                                
                                headPeopleName = @"点击选取";
                            }
                        }];
                        
                        [self.navigationController pushViewController:choosePeople animated:YES];
                    }else if ([model.name isEqualToString:@"申请产品"]) {
                        NSLog(@"申请产品");
                        ProductManageViewController *productChoose = [ProductManageViewController new];
                        productChoose.seType = 4;
                        //                    if (self.seType == 1) {
                        //                        productChoose.limit = 0;
                        //                        productChoose.limitArr = self.productArr;
                        //                    }
                        
                        if (self.returnNameArray.count == 0) {
                            NSMutableArray *proIDArray = [NSMutableArray arrayWithCapacity:0];
                            for (productModel *model  in self.productArr) {
                                [proIDArray addObject:model.ID];
                            }
                            self.returnIDArray = proIDArray;
                        }
                        
                        [productChoose returnIDMutableArray:^(NSMutableArray *returnIDMutableArray) {
                            self.returnIDArray = returnIDMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                            
                        }];
                        [productChoose returnNameMutableArray:^(NSMutableArray *returnNameMutableArray) {
                            self.returnNameArray = returnNameMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                            
                        }];
                        productChoose.taskMechProIDArr = self.returnIDArray;
                        productChoose.taskMechProNameArr = self.returnNameArray;
                        [self.navigationController pushViewController:productChoose animated:YES];
                    } else if ([model.name isEqualToString:@"购买日期"]) {
                        if ([model.identification isEqualToString:@"购房日期"]) {
                            ClickRowName = @"购房日期";
                        } else {
                            ClickRowName = @"购车日期";
                        }
                        
                        [tableView endEditing:YES];
                        _dateTimeSelectView.hidden = NO;
                        self.bgView.hidden = NO;
                        [UIView animateWithDuration:animateTime animations:^{
                            _dateTimeSelectView.frame = timeViewRect;
                        }];
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    } else if ([model.name isEqualToString:@"成立时间"]) {
                        ClickRowName = @"成立时间";
                        
                        [tableView endEditing:YES];
                        _dateTimeSelectView.hidden = NO;
                        self.bgView.hidden = NO;
                        [UIView animateWithDuration:animateTime animations:^{
                            _dateTimeSelectView.frame = timeViewRect;
                        }];
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    }else if ([model.name isEqualToString:@"入职时间"]) {
                        ClickRowName = @"入职时间";
                        
                        [tableView endEditing:YES];
                        _dateTimeSelectView.hidden = NO;
                        self.bgView.hidden = NO;
                        [UIView animateWithDuration:animateTime animations:^{
                            _dateTimeSelectView.frame = timeViewRect;
                        }];
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                    }
                } else {
                    if ([model.name isEqualToString:@"申请产品"]) {
                        NSLog(@"申请产品");
                        ProductManageViewController *productChoose = [ProductManageViewController new];
                        productChoose.seType = 4;
                        if (self.seType == 1) {
                            productChoose.limit = 1;
                            productChoose.limitArr = self.productArr;
                        }
                        
                        [productChoose returnIDMutableArray:^(NSMutableArray *returnIDMutableArray) {
                            self.returnIDArray = returnIDMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                            
                        }];
                        [productChoose returnNameMutableArray:^(NSMutableArray *returnNameMutableArray) {
                            self.returnNameArray = returnNameMutableArray;
                            if (self.returnNameArray.count == 0) {
                                productName = @"点击选取";
                            }
                            for (int i=0; i<self.returnNameArray.count ; i++) {
                                //        powerUserModel *model = self.powerUserArr[i];
                                if (i == 0 ) {
                                    productName = self.returnNameArray[0];
                                } else if (i!=0) {
                                    productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
                                }
                                [self.CRMDetailsTableView reloadData];
                            }
                        }];
                        [self.navigationController pushViewController:productChoose animated:YES];
                    }
                }
                
            }else{
                if (indexPath.section == 1) {
                    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
                    if (node.type == 0) {
                        superCellModel *nodeData = node.nodeData;
                        if ([nodeData.name isEqualToString:@"备       注"]) {
                            self.remarkIndexPath = indexPath;
                            
                            [self.CRMDetailsTableView reloadData];
                            
                            if (self.isRemark) {
                                [self.CRMDetailsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.remarkIndexPath.row+1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//UITableViewScrollPositionBottom
                            }
                            
                        }
                        if ([nodeData.name isEqualToString:@"融资方案"]) {
                            
                        }
                    }
                }
                
                
            }
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            DLog(@"userMobile == %@",userMobile);
            NSString *callStr = [NSString stringWithFormat:@"tel:%@",userMobile];
            UIWebView *callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        }
    }
}

#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *time = [NSString stringWithFormat:@"%@",dictDate[@"date"]];
    
    if ([ClickRowName isEqualToString:@"购房日期"]) {
        houseTime = time;
    }
    if ([ClickRowName isEqualToString:@"购车日期"]) {
        carTime = time;
    }
    if ([ClickRowName isEqualToString:@"成立时间"]) {
        //        buildTime = time;
        self.special_company_date = time;
    }
    if ([ClickRowName isEqualToString:@"入职时间"]) {
        workTime = time;
    }
    [self.CRMDetailsTableView reloadData];
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

#pragma mark -- 时间的选择
-(void)getTimeToValue:(NSString *)theTimeStr
{
    //    if ([ClickRowName isEqualToString:@"购房日期"]) {
    //        houseTime = theTimeStr;
    //    }
    //    if ([ClickRowName isEqualToString:@"购车日期"]) {
    //        carTime = theTimeStr;
    //    }
    //    if ([ClickRowName isEqualToString:@"成立时间"]) {
    //        buildTime = theTimeStr;
    //    }
    //    if ([ClickRowName isEqualToString:@"入职时间"]) {
    //        workTime = theTimeStr;
    //    }
    //    [self.CRMDetailsTableView reloadData];
    NSLog(@"我获取到时间了，时间是===%@",theTimeStr);
}
/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(CRMDetailsTableViewCell*) cell with:(double)degree{
    [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}
/*---------------------------------------
 修改cell的状态(关闭或打开)
 ----------------------------------------*/
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (TreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            
            superCellModel *model = node.nodeData;
            if ([model.name isEqualToString:@"个人信息"]) {
                self.isPersonalInfo = 1;
                personalInfoCount = node.sonNodes.count;
                
            }
            if ([model.name isEqualToString:@"资产信息"]) {
                self.isAssetInfo = 1;
                AssetInfoCount = 2;
                if (self.isHouseInfo == 1) {
                    if (isAddHouseTotal == 1) {
                        houseInfoCount = 6;
                        if (isAddHouseInstallment == 1) {
                            if (isAddHouseMonth == 1) {
                                houseInfoCount = 7;
                            }
                        } else {
                            houseInfoCount = 5;
                        }
                        
                    } else {
                        if (isAddHouseInstallment == 1) {
                            if (isAddHouseMonth == 1) {
                                houseInfoCount = 6;
                            } else {
                                houseInfoCount = 5;
                            }
                        } else {
                            houseInfoCount = 5;
                        }
                        
                    }
                    
                } else {
                    houseInfoCount = 0;
                }
                if (self.isCarInfo == 1) {
                    
                    if (isAddCarTotal == 1) {
                        carInfoCount = 5;
                        if (isAddCarInstallment == 1) {
                            if (isAddCarMonth == 1) {
                                carInfoCount = 6;
                            }
                        } else {
                            carInfoCount = 4;
                        }
                        
                    } else {
                        if (isAddCarInstallment == 1) {
                            if (isAddCarMonth == 1) {
                                carInfoCount = 5;
                            } else {
                                carInfoCount = 4;
                            }
                        } else {
                            carInfoCount = 3;
                        }
                        
                    }
                } else {
                    carInfoCount = 0;
                }
            }
            if ([model.name isEqualToString:@"工作信息"]) {
                self.isWorkInfo = 1;
                workInfoCount = 9;
            }
            
            if ([model.name isEqualToString:@"联系人信息"]) {
                
                self.isContactsInfo = 1;
                if (self.isMatesInfo == 1) {
                    matesInfoCount = 6;
                } else {
                    matesInfoCount = 0;
                }
                if (self.isRelativeInfo == 1) {
                    relativesInfoCount = 3;
                } else {
                    relativesInfoCount = 0;
                }
                if (self.isWorkmatesInfo == 1) {
                    workmatesInfoCount = 3;
                } else {
                    workmatesInfoCount = 0;
                }
                if (self.isOtherContactsInfo == 1) {
                    otherContactsInfoCount = 3;
                } else {
                    otherContactsInfoCount = 0;
                }
                if (isAddTogether == 1) {
                    isAddTogether = 1;
                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                    
                } else {
                    isAddTogether = 0;
                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                }
                if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                    contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                }
                
            }
            if ([model.name isEqualToString:@"备       注"]) {
                
                self.isRemark = 1;
            }
            if ([model.name isEqualToString:@"融资方案"]) {
                self.isProject = 1;
            }
            
            for(TreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                
                
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    
                    superCellModel *model = node2.nodeData;
                    if ([model.name isEqualToString:@"房产信息"]) {
                        self.isHouseInfo = 1;
                        if (isAddHouseTotal == 1) {
                            houseInfoCount = 6;
                            if (isAddHouseInstallment == 1) {
                                if (isAddHouseMonth == 1) {
                                    houseInfoCount = 7;
                                }
                            } else {
                                houseInfoCount = 5;
                            }
                            
                        } else {
                            if (isAddHouseInstallment == 1) {
                                if (isAddHouseMonth == 1) {
                                    houseInfoCount = 6;
                                } else {
                                    houseInfoCount = 5;
                                }
                            } else {
                                houseInfoCount = 4;
                            }
                            
                        }
                        if (self.isCarInfo == 1) {
                            if (isAddCarTotal == 1) {
                                carInfoCount = 5;
                                if (isAddCarInstallment == 1) {
                                    if (isAddCarMonth == 1) {
                                        carInfoCount = 6;
                                    }
                                } else {
                                    carInfoCount = 4;
                                }
                                
                            } else {
                                if (isAddCarInstallment == 1) {
                                    if (isAddCarMonth == 1) {
                                        carInfoCount = 5;
                                    } else {
                                        carInfoCount = 4;
                                    }
                                } else {
                                    carInfoCount = 3;
                                }
                                
                            }
                        } else {
                            carInfoCount = 0;
                        }
#pragma mark == 在这里更新 判断是否需要加一行之类的
                        
                    }
                    
                    if ([model.name isEqualToString:@"车辆信息"]) {
                        
                        self.isCarInfo = 1;
                        if (isAddCarTotal == 1) {
                            carInfoCount = 5;
                            if (isAddCarInstallment == 1) {
                                if (isAddCarMonth == 1) {
                                    carInfoCount = 6;
                                }
                            } else {
                                carInfoCount = 4;
                            }
                            
                        } else {
                            if (isAddCarInstallment == 1) {
                                if (isAddCarMonth == 1) {
                                    carInfoCount = 5;
                                } else {
                                    carInfoCount = 4;
                                }
                            } else {
                                carInfoCount = 3;
                            }
                            
                        }
                        if (self.isHouseInfo == 1) {
                            if (isAddHouseTotal == 1) {
                                houseInfoCount = 6;
                                if (isAddHouseInstallment == 1) {
                                    if (isAddHouseMonth == 1) {
                                        houseInfoCount = 7;
                                    }
                                } else {
                                    houseInfoCount = 5;
                                }
                            } else {
                                if (isAddHouseInstallment == 1) {
                                    if (isAddHouseMonth == 1) {
                                        houseInfoCount = 6;
                                    } else {
                                        houseInfoCount = 5;
                                    }
                                } else {
                                    houseInfoCount = 4;
                                }
                            }
                        } else {
                            houseInfoCount = 0;
                        }
                        DLog(@"houseInfoCount == %ld isAddHouseInstallment == %d isAddHouseTotal == %d isAddHouseMonth == %d",houseInfoCount,isAddHouseInstallment,isAddHouseTotal,isAddHouseMonth);
#pragma mark == 在这里更新 判断是否需要加一行之类的
                        
                    }
                    
                    if ([model.name isEqualToString:@"配偶/直系"]) {
                        
                        self.isMatesInfo = 1;
                        matesInfoCount = 6;
                        if (self.isRelativeInfo == 1) {
                            relativesInfoCount = 3;
                        } else {
                            relativesInfoCount = 0;
                        }
                        if (self.isWorkmatesInfo == 1) {
                            workmatesInfoCount = 3;
                        } else {
                            workmatesInfoCount = 0;
                        }
                        if (self.isOtherContactsInfo == 1) {
                            otherContactsInfoCount = 3;
                        } else {
                            otherContactsInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            //                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    if ([model.name isEqualToString:@"直系亲属"]) {
                        self.isRelativeInfo = 1;
                        relativesInfoCount = 3;
                        if (self.isMatesInfo == 1) {
                            matesInfoCount = 6;
                        } else {
                            matesInfoCount = 0;
                        }
                        if (self.isWorkmatesInfo == 1) {
                            workmatesInfoCount = 3;
                        } else {
                            workmatesInfoCount = 0;
                        }
                        if (self.isOtherContactsInfo == 1) {
                            otherContactsInfoCount = 3;
                        } else {
                            otherContactsInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            //                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            //                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    if ([model.name isEqualToString:@"单位同事"]) {
                        self.isWorkmatesInfo = 1;
                        workmatesInfoCount = 3;
                        if (self.isMatesInfo == 1) {
                            matesInfoCount = 6;
                        } else {
                            matesInfoCount = 0;
                        }
                        if (self.isRelativeInfo == 1) {
                            relativesInfoCount = 3;
                        } else {
                            relativesInfoCount = 0;
                        }
                        if (self.isOtherContactsInfo == 1) {
                            otherContactsInfoCount = 3;
                        } else {
                            otherContactsInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    if ([model.name isEqualToString:@"其他联系人"]) {
                        self.isOtherContactsInfo = 1;
                        otherContactsInfoCount = 3;
                        if (self.isMatesInfo == 1) {
                            matesInfoCount = 6;
                        } else {
                            matesInfoCount = 0;
                        }
                        if (self.isRelativeInfo == 1) {
                            relativesInfoCount = 3;
                        } else {
                            relativesInfoCount = 0;
                        }
                        if (self.isWorkmatesInfo == 1) {
                            workmatesInfoCount = 3;
                        } else {
                            workmatesInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    
                    for(TreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                } else {
                    superCellModel *model = node2.nodeData;
                    if ([model.name isEqualToString:@"房产信息"]) {
                        self.isHouseInfo = 0;
                        houseInfoCount = 0;
                        if (self.isCarInfo == 1) {
                            if (isAddCarTotal == 1) {
                                carInfoCount = 5;
                                if (isAddCarInstallment == 1) {
                                    if (isAddCarMonth == 1) {
                                        carInfoCount = 6;
                                    }
                                } else {
                                    carInfoCount = 4;
                                }
                            } else {
                                if (isAddCarInstallment == 1) {
                                    if (isAddCarMonth == 1) {
                                        carInfoCount = 5;
                                    } else {
                                        carInfoCount = 4;
                                    }
                                } else{
                                    carInfoCount = 3;
                                }
                                
                            }
                        } else {
                            carInfoCount = 0;
                        }
#pragma mark == 在这里更新 判断是否需要减一行之类的
                        
                    }
                    
                    if ([model.name isEqualToString:@"车辆信息"]) {
                        self.isCarInfo = 0;
                        carInfoCount = 0;
                        if (self.isHouseInfo == 1) {
                            if (isAddHouseTotal == 1) {
                                houseInfoCount = 6;
                                if (isAddHouseInstallment == 1) {
                                    if (isAddHouseMonth == 1) {
                                        houseInfoCount = 7;
                                    }
                                } else{
                                    houseInfoCount = 5;
                                }
                                
                            } else {
                                if (isAddHouseInstallment == 1) {
                                    if (isAddHouseMonth == 1) {
                                        houseInfoCount = 6;
                                    } else {
                                        houseInfoCount = 5;
                                    }
                                } else {
                                    houseInfoCount = 4;
                                }
                                
                            }
                        } else {
                            houseInfoCount = 0;
                        }
#pragma mark == 在这里更新 判断是否需要减一行之类的
                        
                    }
                    if ([model.name isEqualToString:@"配偶/直系"]) {
                        self.isMatesInfo = 0;
                        matesInfoCount = 0;
                        if (self.isRelativeInfo == 1) {
                            relativesInfoCount = 3;
                        } else {
                            relativesInfoCount = 0;
                        }
                        if (self.isWorkmatesInfo == 1) {
                            workmatesInfoCount = 3;
                        } else {
                            workmatesInfoCount = 0;
                        }
                        if (self.isOtherContactsInfo == 1) {
                            otherContactsInfoCount = 3;
                        } else {
                            otherContactsInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    if ([model.name isEqualToString:@"直系亲属"]) {
                        self.isRelativeInfo = 0;
                        relativesInfoCount = 0;
                        if (self.isMatesInfo == 1) {
                            matesInfoCount = 6;
                        } else {
                            matesInfoCount = 0;
                        }
                        if (self.isWorkmatesInfo == 1) {
                            workmatesInfoCount = 3;
                        } else {
                            workmatesInfoCount = 0;
                        }
                        if (self.isOtherContactsInfo == 1) {
                            otherContactsInfoCount = 3;
                        } else {
                            otherContactsInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                        
                    }
                    if ([model.name isEqualToString:@"单位同事"]) {
                        self.isWorkmatesInfo = 0;
                        workmatesInfoCount = 0;
                        if (self.isMatesInfo == 1) {
                            matesInfoCount = 6;
                        } else {
                            matesInfoCount = 0;
                        }
                        if (self.isRelativeInfo == 1) {
                            relativesInfoCount = 3;
                        } else {
                            relativesInfoCount = 0;
                        }
                        if (self.isOtherContactsInfo == 1) {
                            otherContactsInfoCount = 3;
                        } else {
                            otherContactsInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    if ([model.name isEqualToString:@"其他联系人"]) {
                        self.isOtherContactsInfo = 0;
                        otherContactsInfoCount = 0;
                        if (self.isMatesInfo == 1) {
                            matesInfoCount = 6;
                        } else {
                            matesInfoCount = 0;
                        }
                        if (self.isRelativeInfo == 1) {
                            relativesInfoCount = 3;
                        } else {
                            relativesInfoCount = 0;
                        }
                        if (self.isWorkmatesInfo == 1) {
                            workmatesInfoCount = 3;
                        } else {
                            workmatesInfoCount = 0;
                        }
                        if (isAddTogether == 1) {
                            isAddTogether = 1;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+7;
                        } else {
                            isAddTogether = 0;
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+6;
                        }
                        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
                            contactsInfoCount = matesInfoCount+relativesInfoCount+workmatesInfoCount+otherContactsInfoCount+4;
                        }
                    }
                    
                }
            }
        } else {
            
            superCellModel *model = node.nodeData;
            if ([model.name isEqualToString:@"个人信息"]) {
                self.isPersonalInfo = 0;
                personalInfoCount = 0;
                
            }
            if ([model.name isEqualToString:@"资产信息"]) {
                self.isAssetInfo = 0;
                self.isHouseInfo = 0;
                self.isCarInfo = 0;
                AssetInfoCount = 0;
                houseInfoCount = 0;
                carInfoCount = 0;
            }
            if ([model.name isEqualToString:@"工作信息"]) {
                self.isWorkInfo = 0;
                workInfoCount = 0;
            }
            if ([model.name isEqualToString:@"联系人信息"]) {
                self.isContactsInfo = 0;
                contactsInfoCount = 0;
            }
            if ([model.name isEqualToString:@"备       注"]) {
                self.isRemark = 0;
            }
            if ([model.name isEqualToString:@"融资方案"]) {
                self.isProject = 0;
            }
        }
    }
    DLog(@"%ld,%ld,%ld,%ld",personalInfoCount,AssetInfoCount,workInfoCount,contactsInfoCount);
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.CRMDetailsTableView reloadData];
}

#pragma mark -- textfield代理方法
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 11) {
        NSInteger kMaxLength = 4;
        
        NSString *toBeString = textField.text;
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
        if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (toBeString.length > kMaxLength) {
                    textField.text = [toBeString substringToIndex:kMaxLength];
                }
            }else{//有高亮选择的字符串，则暂不对文字进行统计和限制
                
            }
        }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        
    }
    if (textField.tag == 12) {
        NSLog(@"textField.text == %@",textField.text);
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if (textField.tag == 10004) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 11) {
        userName = [NSString stringWithFormat:@"%@",textField.text];
        
    } else if (textField.tag == 12) {
        userMobile = [NSString stringWithFormat:@"%@",textField.text];;
    } else {
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        NSMutableArray *tmpOne = [[NSMutableArray alloc]init];
        CRMSubTableViewCell *cell = (CRMSubTableViewCell*)[textField superview];
        subCellModel *nodeData = cell.node.nodeData;
        nodeData.TFText = textField.text;
        
        if (textField.tag == 10001 || textField.tag == 10002) {
            
            houseMoney = textField.text;
            NSLog(@"%@",houseMoney);
        } else if (textField.tag == 10003) {
            cpfMoney = textField.text;
            NSLog(@"%@",houseMoney);
        }
        for (TreeViewNode *node in _dataArray) {
            [tmp addObject:node];
            if (node.isExpanded) {
                for(TreeViewNode *node2 in node.sonNodes){
                    [tmp addObject:node2];
                    if (node2.isExpanded) {
                        for(TreeViewNode *node3 in node2.sonNodes){
                            [tmp addObject:node3];
                        }
                        
                    }
                }
            }
        }
        for (TreeViewNode *node in _sectionOneDataArray) {
            [tmpOne addObject:node];
            if (node.isExpanded) {
                for(TreeViewNode *node2 in node.sonNodes){
                    [tmpOne addObject:node2];
                    if (node2.isExpanded) {
                        for(TreeViewNode *node3 in node2.sonNodes){
                            [tmpOne addObject:node3];
                        }
                        
                    }
                }
            }
        }
        _sectionOneDisplayArray = [NSArray arrayWithArray:tmpOne];
        _displayArray = [NSArray arrayWithArray:tmp];
    }
    [textField resignFirstResponder];
    [self.CRMDetailsTableView reloadData];
    //    [self.CRMDetailsTableView endEditing:YES];
    
}
#pragma mark -- uitextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    CRMSubTableViewCell *cell = (CRMSubTableViewCell*)[textView superview];
    subCellModel *nodeData = cell.node.nodeData;
    nodeData.TFText = textView.text;
    
    for (TreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if (node.isExpanded) {
            for(TreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if (node2.isExpanded) {
                    for(TreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                    
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.CRMDetailsTableView reloadData];
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.tag == 9999) {
        CGSize constraintSize;
        constraintSize.width = textView.frame.size.width-16;
        constraintSize.height = MAXFLOAT;
        CGSize titleSize = [textView.text boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (titleSize.height <= 200.0) {
            self.remarkHeight = 200.0;
        } else {
            self.remarkHeight = titleSize.height;
        }
        if (textView.text.length > 1500) {
            textView.text = [textView.text substringToIndex:1500];
        }
        
        [self.signLabel removeFromSuperview];
        
    } else if (textView.tag == 99999) {
        CGSize constraintSize;
        constraintSize.width = textView.frame.size.width-16;
        constraintSize.height = MAXFLOAT;
        CGSize titleSize = [textView.text boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (titleSize.height <= 200.0) {
            self.projectHeight = 200.0;
        } else {
            self.projectHeight = titleSize.height;
        }
        if (textView.text.length > 1500) {
            textView.text = [textView.text substringToIndex:1500];
        }
        
        [self.projectLabel removeFromSuperview];
        
    }
}
#pragma mark --点击事件
-(void)stateBtnClick:(UIButton *)btn {
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    [self.navigationController.view addSubview:self.stateView];
}
- (void)picturesBtnClick:(UIButton *)btn {
    CRMPhotosViewController *CRMPhotos = [CRMPhotosViewController new];
    if (self.ishideNaviView) {
        CRMPhotos.ishideNaviView = 1;
    }
    CRMPhotos.PhotoModel = self.CRMModel;
    CRMPhotos.isUpdateCRM = isEdit;
    [CRMPhotos returnPhoto:^(CRMDetailsModel *photoModel) {
        self.CRMModel = photoModel;
    }];
    [self.navigationController pushViewController:CRMPhotos animated:YES];
}
- (void)picturesBtnOnClick:(UIButton *)btn {
    CRMPhotosViewController *CRMPhotos = [CRMPhotosViewController new];
    if (self.ishideNaviView) {
        CRMPhotos.ishideNaviView = 1;
    }
    CRMPhotos.PhotoModel = self.CRMModel;
    CRMPhotos.isUpdateCRM = isEdit;
    [CRMPhotos returnPhoto:^(CRMDetailsModel *photoModel) {
        self.CRMModel = photoModel;
    }];
    [self.navigationController pushViewController:CRMPhotos animated:YES];
}
- (void)buildOrderBtnClick:(UIButton *)btn {
    NSMutableDictionary *dic = [self dicWithData:@"updateCustomer"];
    NSLog(@"%@",dic);
    //    NSLog(@"self.user_id_type == %@",self.user_id_type);
    //    NSLog(@"self.user_house_type == %@",self.user_house_type);
    //    NSLog(@"self.mechProId == %@",self.mechProId);
    //    NSLog(@"self.user_house_money == %@",self.user_house_money);
    
    if (self.isCreateOrderCRM) {
        NSLog(@"执行了吗1");
        if ([self.user_id_type isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"请选择个人信息-->证件类型"];
        }else if ([self.user_id_type isEqualToString:@"1"]) {
            NSLog(@"执行了吗2");
            if (self.user_id_number.length == 0) {
                [MBProgressHUD showError:@"身份证输入有误"];
            }else if (self.mechProId == nil||[self.mechProId isEqual:@"null"]||self.mechProId.length == 0) {
                
                [MBProgressHUD showError:@"请选择申请产品"];
            } else {
                
                if([self.user_house_type isEqualToString:@"1"] || [self.user_house_type isEqualToString:@"2"]||[self.user_house_type isEqualToString:@"3"]){
                    //)&&[self.user_house_money isEqual:@"(null)"])||(([self.user_house_type isEqualToString:@"1"] || [self.user_house_type isEqualToString:@"2"]||[self.user_house_type isEqualToString:@"3"])&&[self.user_house_money isEqualToString:@""])
                    
                    if (self.user_house_money == nil || [self.user_house_money isEqual:@"(null)"] || self.user_house_money.length == 0) {
                        [MBProgressHUD showError:@"请输入每月租金或每月还款"];
                    }
                    NSLog(@"执行了要求输入租金或还款");
                } else {
                    JKAlertView *removeAlert = [[JKAlertView alloc] initWithTitle:@"生成订单" message:@"是否生成订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    removeAlert.tag = 1007;
                    [removeAlert show];
                }
            }
        }else if (self.mechProId == nil||[self.mechProId isEqual:@"null"]||self.mechProId.length == 0) {
            
            [MBProgressHUD showError:@"请选择申请产品"];
        } else {
            
            if([self.user_house_type isEqualToString:@"1"] || [self.user_house_type isEqualToString:@"2"]||[self.user_house_type isEqualToString:@"3"]){
                //)&&[self.user_house_money isEqual:@"(null)"])||(([self.user_house_type isEqualToString:@"1"] || [self.user_house_type isEqualToString:@"2"]||[self.user_house_type isEqualToString:@"3"])&&[self.user_house_money isEqualToString:@""])
                
                if (self.user_house_money == nil || [self.user_house_money isEqual:@"(null)"] || self.user_house_money.length == 0) {
                    [MBProgressHUD showError:@"请输入每月租金或每月还款"];
                }
                NSLog(@"执行了要求输入租金或还款");
            } else {
                JKAlertView *removeAlert = [[JKAlertView alloc] initWithTitle:@"生成订单" message:@"是否生成订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                removeAlert.tag = 1007;
                [removeAlert show];
            }
        }
        
    } else {
        [MBProgressHUD showError:@"暂无此权限"];
    }
    
}
- (void)ClickEdit {
    if (self.isUpdateCRM) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOK)];
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = right;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        
        
        [self.bottomView removeFromSuperview];
        isEdit = 1;
        if (![self.MyUserInfoModel.type isEqualToString:@"1"]) {
            self.CRMDetailsTableView.frame = CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight);
        } else {
            [self.view addSubview:self.bottomViewOne];
        }
        
        [self.CRMDetailsTableView reloadData];
    } else {
        [MBProgressHUD showError:@"暂无此权限"];
    }
}
//点击返回dismiss
- (void)clickDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ClickOK {
    
    [self.CRMDetailsTableView endEditing:YES];
    if ([userName isEqualToString:@""] || [userMobile isEqualToString:@""]) {
        [MBProgressHUD showError:@"姓名或手机号码为空"];
    } else if(userMobile.length != 11){
        [MBProgressHUD showError:@"手机号码有误"];
    } else{
        if (self.seType == 1) {
            NSMutableDictionary *dic = [self dicWithData:@"updateCustomer"];
            dic[@"state"] = state;
            //            NSLog(@"dic == %@",dic);
            DLog(@"self.occ_type == %@ self.work_type == %@",self.occ_type,self.work_type);
            if ([self.user_id_type isEqualToString:@"1"] && (self.user_id_number.length == 0)) {
                [MBProgressHUD showError:@"身份证输入有误"];
            }
            else if ((([self.user_id_type isEqualToString:@"1"]||[self.user_id_type isEqualToString:@"2"]||[self.user_id_type isEqualToString:@"3"])&&self.user_id_number == nil)||(([self.user_id_type isEqualToString:@"1"]||[self.user_id_type isEqualToString:@"2"]||[self.user_id_type isEqualToString:@"3"])&&[self.user_id_number isEqualToString:@""])) {
                [MBProgressHUD showError:@"请输入证件号码"];
            }
            else if ([self.iscpf isEqualToString:@"1"] && [self.cpfRange isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择公积金金额"];
            }
            else if ([self.iscpf isEqualToString:@"1"] && ([self.cpfRange isEqualToString:@"4"] && [Utils isBlankString:self.cpfMoney])) {
                [MBProgressHUD showError:@"请填写公积金金额"];
            }
            else if ([self.occ_type isEqualToString:@"1"] && [self.work_type isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择单位性质"];
            }
            else if ([self.work_type isEqualToString:@"6"] && [self.isbs isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择私营业主是否报税"];
            }
            else if ([self.isgrbx isEqualToString:@"1"] && ([self.grbx_term_range isEqualToString:@"0"] && [Utils isBlankString:self.grbx_sum])){
                [MBProgressHUD showError:@"请选择投保年限或填写保险金额"];
            }
            
            else if ([self.asset_house_type isEqualToString:@"1"] && [self.asset_house_monRange isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择房产月供金额"];
            }
            else if ([self.asset_house_monRange isEqualToString:@"4"] && [Utils isBlankString:self.asset_house_month]){
                [MBProgressHUD showError:@"请填写房产月供金额"];
            }
            else if ([self.asset_house_totalPrice isEqualToString:@"4"] && [Utils isBlankString:self.asset_house_totalval]){
                [MBProgressHUD showError:@"请填写购房价格"];
            }
            
            else if ([self.asset_car_type isEqualToString:@"1"] && [self.asset_car_monRange isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择车辆月供金额"];
            }
            else if ([self.asset_car_monRange isEqualToString:@"4"] && [Utils isBlankString:self.asset_car_month]){
                [MBProgressHUD showError:@"请填写车辆月供金额"];
            }
            else if ([self.asset_car_totalRange isEqualToString:@"4"] && [Utils isBlankString:self.asset_car_price]){
                [MBProgressHUD showError:@"请填写购车价格"];
            } else {
                
                [self requstToChangeCRMInfoWithDic:dic];
            }
            
        } else {
            NSMutableDictionary *dic = [self dicWithData:@"addCus"];
            NSLog(@"dic == %@",dic);
            if ([self.user_id_type isEqualToString:@"1"] && (self.user_id_number.length == 0 )) {
                [MBProgressHUD showError:@"身份证输入有误"];
            }
            else if ((([self.user_id_type isEqualToString:@"1"]||[self.user_id_type isEqualToString:@"2"]||[self.user_id_type isEqualToString:@"3"])&&self.user_id_number == nil)||(([self.user_id_type isEqualToString:@"1"]||[self.user_id_type isEqualToString:@"2"]||[self.user_id_type isEqualToString:@"3"])&&[self.user_id_number isEqualToString:@""])) {
                [MBProgressHUD showError:@"请输入证件号码"];
            }
            else if ([self.iscpf isEqualToString:@"1"] && [self.cpfRange isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择公积金金额"];
            }
            else if ([self.iscpf isEqualToString:@"1"] && ([self.cpfRange isEqualToString:@"4"] && [Utils isBlankString:self.cpfMoney])) {
                [MBProgressHUD showError:@"请填写公积金金额"];
            }
            else if ([self.occ_type isEqualToString:@"1"] && [self.work_type isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择单位性质"];
            }
            else if ([self.work_type isEqualToString:@"6"] && [self.isbs isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择私营业主是否报税"];
            }
            else if ([self.isgrbx isEqualToString:@"1"] && ([self.grbx_term_range isEqualToString:@"0"] && [Utils isBlankString:self.grbx_sum])){
                [MBProgressHUD showError:@"请选择投保年限或填写保险金额"];
            }
            
            else if ([self.asset_house_type isEqualToString:@"1"] && [self.asset_house_monRange isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择房产月供金额"];
            }
            else if ([self.asset_house_monRange isEqualToString:@"4"] && [Utils isBlankString:self.asset_house_month]){
                [MBProgressHUD showError:@"请填写房产月供金额"];
            }
            else if ([self.asset_house_totalPrice isEqualToString:@"4"] && [Utils isBlankString:self.asset_house_totalval]){
                [MBProgressHUD showError:@"请填写购房价格"];
            }
            
            else if ([self.asset_car_type isEqualToString:@"1"] && [self.asset_car_monRange isEqualToString:@"0"]){
                [MBProgressHUD showError:@"请选择车辆月供金额"];
            }
            else if ([self.asset_car_monRange isEqualToString:@"4"] && [Utils isBlankString:self.asset_car_month]){
                [MBProgressHUD showError:@"请填写车辆月供金额"];
            }
            else if ([self.asset_car_totalRange isEqualToString:@"4"] && [Utils isBlankString:self.asset_car_price]){
                [MBProgressHUD showError:@"请填写购车价格"];
            } else {
                
                [self requstToChangeCRMInfoWithDic:dic];
            }
        }
    }
}
#pragma mark -- ClickNotification
- (void)ClickNotification {
    UIButton *btn = [self.navigationController.navigationBar viewWithTag:999];
    if ([Utils isBlankString:self.CRMModel.audio_url] && [Utils isBlankString:self.CRMModel.tepl_url]) {
        [YBPopupMenu showRelyOnView:btn titles:@[@"定时提醒",@"等级设置"] icons:nil menuWidth:120 delegate:self];
    } else {
        [YBPopupMenu showRelyOnView:btn titles:@[@"定时提醒",@"等级设置",@"通话语音"] icons:nil menuWidth:120 delegate:self];
    }
}
- (void)ClickNotificationn{
    alermViewController *alerm = [alermViewController new];
    if (self.ishideNaviView) {
        alerm.ishideNaviView = 1;
    }
    alerm.CRMID = self.customerId;
    [self.navigationController pushViewController:alerm animated:YES];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (index == 0) {
        alermViewController *alerm = [alermViewController new];
        if (self.ishideNaviView) {
            alerm.ishideNaviView = 1;
        }
        alerm.CRMID = self.customerId;
        [self.navigationController pushViewController:alerm animated:YES];
    } else if (index == 1) {
        CRMSignView *signView = [[CRMSignView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) signCode:self.userSign customID:self.customerId];
        [self.navigationController.view addSubview:signView];
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        signView.cancelblock = ^{
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        };
        signView.block = ^(NSString *signCode) {
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
            if (![self.userSign isEqualToString:signCode]) {
                self.userSign = signCode;
                if (self.returnStarBlock != nil) {
                    self.returnStarBlock(self.userSign);
                }
            }
        };
    } else {
        if ([Utils isBlankString:self.CRMModel.tepl_url]) {
            CRMVoiceViewController *vc = [CRMVoiceViewController new];
            vc.type = @"1";
            vc.audio_url = self.CRMModel.audio_url;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            CRMVoiceViewController *vc = [CRMVoiceViewController new];
            vc.type = @"2";
            vc.urlStr = self.CRMModel.tepl_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)requstToChangeCRMInfoWithDic:(NSMutableDictionary *)dic {
    [MBProgressHUD showMessage:@"正在处理..."];
    [HttpRequestEngine UpdateOrAddCRMInfoWithDic:dic completion:^(id obj, NSString *errorStr) {
        NSDictionary *data = obj;
        NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
        DLog(@"data == %@",data);
        [MBProgressHUD hideHUD];
        if ([code isEqualToString:@"1"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
        } else {
            if (self.seType == 2) {
                if (self.isRefreshCRM != nil) {
                    NSString *str = @"1";
                    self.isRefreshCRM(str);
                }
            } else if (self.seType == 1) {
                if (self.CRMListModelBlock != nil) {
                    CRMListModel *model = [CRMListModel requestWithDic:dic];
                    self.CRMListModelBlock(model);
                }
            }
            [self.stateView removeFromSuperview];
            if (self.seType == 3) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [MBProgressHUD showSuccess:@"操作成功"];
        }
        if (data == nil) {
            [MBProgressHUD showError:@"网络连接出错"];
        }
    }];
}

//实现 方法
- (void)returnIsRefreshCRM:(ReturnIsRefreshCRMBlock)block {
    self.isRefreshCRM = block;
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
