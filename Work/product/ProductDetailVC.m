//
//  ProductDetailVC.m
//  365FinanceCircle
//
//  Created by kpkj-ios on 15/8/24.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import "ProductDetailVC.h"
#import "BianjiProductViewController.h"
#import "ProdOneCell.h"
#import "ProdTwoCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+ConvertURL.h"
#import "HttpRequestEngine.h"

#import "ApplyProductViewController.h"
#import "productTableViewCell.h"

#import "ApplyProductVC.h"

#import "friendCopViewController.h"
#import "proOneTableViewCell.h"
#import "ContactDetailsViewController.h"
@interface ProductDetailVC ()<UITableViewDataSource,UITableViewDelegate,JKAlertViewDelegate,UIActionSheetDelegate>
{
    NSArray * _nameArray;
    UITableView * _tableView;
    UIButton * _applyButton;
    UIButton * _bianjiButton;
    NSMutableDictionary * _contentDic;
    

}
@property (nonatomic, strong) NSArray *ModelArr;
@property(nonatomic,copy)NSString * isRefreshBianJi;
@property (nonatomic) LoginPeopleModel *loginModel;
@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) NSString *uid;//用于聊天的userid
@property(nonatomic, strong) NSString *mechName;//用于聊天的mechName
@end

@implementation ProductDetailVC
static BOOL isEdit;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"bj:%@",self.isRefreshBianJi);
    
    if ([self.isRefreshBianJi isEqualToString:@"9"]) {
        
        [_tableView reloadData];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isRefreshBianJi = @"0";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.navigationItem.title = @"产品详情";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //_product = [[FinanceProductModel alloc] init];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0,NaviHeight, self.view.bounds.size.width, self.view.bounds.size.height-NaviHeight);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    if ([self.product.publicity_mech_id isEqualToString:@"0"]) {
        _tableView.frame = CGRectMake(0,NaviHeight, self.view.bounds.size.width, self.view.bounds.size.height-NaviHeight-60);
        UIView * bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(0, kScreenHeight-60, self.view.bounds.size.width, 60);
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.frame = CGRectMake(10*KAdaptiveRateWidth, 10, kScreenWidth-20*KAdaptiveRateWidth, 40);
        if (IS_IPHONE_X) {
            _tableView.frame = CGRectMake(0,NaviHeight, self.view.bounds.size.width, self.view.bounds.size.height-NaviHeight-84);
            bottomView.frame = CGRectMake(0, kScreenHeight-84, self.view.bounds.size.width, 84);
        }
        _applyButton.tag   = 1;
        [_applyButton setTitle:@"我要申请" forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
        _applyButton.layer.cornerRadius = [UIAdaption getAdaptiveHeightWith5SHeight:5];
        [_applyButton setBackgroundColor:TABBAR_BASE_COLOR];
        [_applyButton addTarget:self action:@selector(applyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:_applyButton];
    }
    
    if (self.setype == 1) {
        
    } else {
        
//        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        _applyButton.tag   = 1;
//        [_applyButton setTitle:@"我要申请" forState:UIControlStateNormal];
//        _applyButton.titleLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
//        _applyButton.layer.cornerRadius = [UIAdaption getAdaptiveHeightWith5SHeight:5];
//        [_applyButton setBackgroundColor:TABBAR_BASE_COLOR];
//        [_applyButton addTarget:self action:@selector(applyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
////        [bottomView addSubview:_applyButton];
//        
//        _bianjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _bianjiButton.frame = CGRectMake(7.5,10, kScreenWidth-15, 40);
//        _bianjiButton.tag   = 0;
//        [_bianjiButton setTitle:@"编辑产品" forState:UIControlStateNormal];
//        _bianjiButton.titleLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
//        _bianjiButton.layer.masksToBounds = YES;
//        _bianjiButton.layer.cornerRadius = [UIAdaption getAdaptiveHeightWith5SHeight:5];
//        [_bianjiButton setBackgroundImage:[UIImage imageWithColor:customBlueColor] forState:UIControlStateNormal];
//        [_bianjiButton setBackgroundImage:[UIImage imageWithColor:GRAY229] forState:UIControlStateHighlighted];
//        [_bianjiButton addTarget:self action:@selector(applyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomView addSubview:_bianjiButton];
        
        NSArray *powerList = (NSArray *)self.MyUserInfoModel.powerList;
        NSMutableArray *funIdArray = [NSMutableArray array];
        for (int i=0; i<powerList.count; i++) {
            NSDictionary *powerDic = powerList[i];
            NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
            [funIdArray addObject:funId];
        }

        if (self.isPushPro) {
            
            if (![Utils isBlankString:self.product.myPushId]) {
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pushEdit"] style:UIBarButtonItemStylePlain target:self action:@selector(editPush)];
                self.navigationItem.rightBarButtonItems = @[rightItem];
                if ([funIdArray containsObject:@"11"]) {
                    if ([self.myMech_Id isEqualToString:self.product.mechId]) {
                        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"editPro"] style:UIBarButtonItemStylePlain target:self action:@selector(bianji)];
                        [rightItem setImageInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
                        self.navigationItem.rightBarButtonItems = @[leftItem,rightItem];
                    }
                }
            } else if (![Utils isBlankString:self.product.ptpId]) {
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cancelPush"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelPush)];
                self.navigationItem.rightBarButtonItem = rightItem;

            } else {
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"push"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToPush)];
                self.navigationItem.rightBarButtonItems = @[rightItem];
                if ([funIdArray containsObject:@"11"]) {
                    if ([self.myMech_Id isEqualToString:self.product.mechId]) {
                        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"editPro"] style:UIBarButtonItemStylePlain target:self action:@selector(bianji)];
                        [rightItem setImageInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
                        self.navigationItem.rightBarButtonItems = @[leftItem,rightItem];
                    }
                }
            }
        }
        if ([self.product.publicity_mech_id isEqualToString:@"0"]) {
            self.navigationItem.rightBarButtonItems = @[];
            if ([funIdArray containsObject:@"11"]) {
                if ([self.myMech_Id isEqualToString:self.product.mechId]) {
                    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"editPro"] style:UIBarButtonItemStylePlain target:self action:@selector(bianji)];
                    self.navigationItem.rightBarButtonItems = @[leftItem];
                }
            }
        }
        
        if (self.isFromMessage) {
            self.navigationItem.rightBarButtonItems = @[];
        }
        
    }
    _nameArray = [NSArray arrayWithObjects:@"申请条件:",@"申请材料:",@"费用说明:",@"备注信息:",nil];
    _contentDic = [[NSMutableDictionary alloc] init];
    
    [_tableView registerClass:[proOneTableViewCell class] forCellReuseIdentifier:@"oneCell"];
    [_tableView registerClass:[ProdTwoCell class] forCellReuseIdentifier:@"twoCell"];
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.layer.masksToBounds = YES;
    
    if ([self.product.publicity_mech_id isEqualToString:@"0"] && ![self.product.mechId isEqualToString:self.myMech_Id]) {
        self.uid = [NSString stringWithFormat:@"%@",self.product.mechUserid];
        [self.view addSubview:_btn1];
        
        [HttpRequestEngine queryCustomerServiceWithMech_id:self.product.mechId completion:^(id obj, NSString *errorStr) {
            if (errorStr == nil) {
                NSDictionary *dic = obj;
                self.uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
                _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,NaviHeight+20,50, 50);
                [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
                [_btn1.layer setCornerRadius:25];
            } else {
                [MBProgressHUD showError:errorStr];
                _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,NaviHeight+20,50, 50);
                [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
                
                [_btn1.layer setCornerRadius:25];
            }
        }];

        
        /**
         [HttpRequestEngine testForRequestWithMech_id:self.product.mechId completion:^(id obj, NSString *errorStr) {
         if (errorStr == nil) {
         NSDictionary *dic = obj;
         self.uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
         _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,84,50, 50);
         [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
         [_btn1.layer setCornerRadius:25];
         } else {
         [MBProgressHUD showError:errorStr];
         _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,84,50, 50);
         [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
         
         [_btn1.layer setCornerRadius:25];
         }
         }];
         
         
         */
        
    }
    
    if (![Utils isBlankString:self.product.ptpId]) {
//        self.product.ptpMechId;
//        self.product.ptpMechUserId;
//        self.product.ptpMechUserIcon;
        self.uid = [NSString stringWithFormat:@"%@",self.product.ptpMechUserId];
        [self.view addSubview:_btn1];
        
        [HttpRequestEngine queryCustomerServiceWithMech_id:self.product.mechId completion:^(id obj, NSString *errorStr) {
            if (errorStr == nil) {
                NSDictionary *dic = obj;
                self.uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
                _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,NaviHeight+20,50, 50);
                [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
                [_btn1.layer setCornerRadius:25];
            } else {
                [MBProgressHUD showError:errorStr];
                _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,NaviHeight+20,50, 50);
                [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
                [_btn1.layer setCornerRadius:25];
            }
        }];
        
        /**
         
         [HttpRequestEngine testForRequestWithMech_id:self.product.mechId completion:^(id obj, NSString *errorStr) {
         if (errorStr == nil) {
         NSDictionary *dic = obj;
         self.uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
         _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,84,50, 50);
         [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
         [_btn1.layer setCornerRadius:25];
         } else {
         [MBProgressHUD showError:errorStr];
         _btn1.frame = CGRectMake(kScreenWidth-60*KAdaptiveRateWidth,84,50, 50);
         [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_btn1 setBackgroundImage:[UIImage imageNamed:@"Services"] forState:UIControlStateNormal];
         [_btn1.layer setCornerRadius:25];
         }
         }];

         */
    }
    
}

- (void)PeopleBtnClick:(UIButton *)btn {
    ContactDetailsViewController *ContactDetails = [ContactDetailsViewController new];
    ContactDetails.setype = 4;
    ContactDetails.uid = self.uid;
    ContactDetails.mechName = self.mechName;
    [self.navigationController pushViewController:ContactDetails animated:YES];
}

- (void)bianji {
    BianjiProductViewController *bianjiVc =[[BianjiProductViewController alloc]init];
    bianjiVc.product                      = self.product;
    
    [bianjiVc returnIsRefreshBianJi:^(NSArray *returnIsRefrshBianJi) {
        self.ModelArr = returnIsRefrshBianJi;
        if (self.ModelArr.count != 0) {
            self.product = self.ModelArr[0];
            [_tableView reloadData];
        }
    }];
    [self.navigationController  pushViewController:bianjiVc animated:YES];
}
-(void)applyButtonClicked:(UIButton *)sender
{
    if (!sender.tag) {
        
        LoginPeopleModel*  loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
        NSArray *powerList = (NSArray *)loginModel.powerList;
        
        NSMutableArray *funIdArray = [NSMutableArray array];
        for (int i=0; i<powerList.count; i++) {
            NSDictionary *powerDic = powerList[i];
            NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
            [funIdArray addObject:funId];
        }
        if ([funIdArray containsObject:@"11"]) {
            
//            //将地址写入沙盒
//            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *path=[paths objectAtIndex:0];
//            NSString *Json_path=[path stringByAppendingPathComponent:@"File.json"];
//            
//            [HttpRequestEngine areaListRequestCompletion:^(id obj,NSString * errorStr){
//                if (!errorStr)
//                {
//                    
//                    NSLog(@"%@",[obj writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");
//                    
//                }
//            }];
            
            BianjiProductViewController *bianjiVc =[[BianjiProductViewController alloc]init];
            bianjiVc.product                      = _product;
        
            [bianjiVc returnIsRefreshBianJi:^(NSArray *returnIsRefrshBianJi) {
                self.ModelArr = returnIsRefrshBianJi;
                if (self.ModelArr.count != 0) {
                    self.product = self.ModelArr[0];
                    [_tableView reloadData];
                }
            }];
            [self.navigationController  pushViewController:bianjiVc animated:YES];
        }else{
            
            [MBProgressHUD showError:@"暂无此权限"];
            
        }
        
    }else{
        //将地址写入沙盒
//        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path=[paths objectAtIndex:0];
////        NSLog(@"%@",path);
//        NSString *Json_path=[path stringByAppendingPathComponent:@"File.json"];
//        
//        [HttpRequestEngine areaListRequestCompletion:^(id obj,NSString * errorStr){
//            if (!errorStr)
//            {
//                
//                NSLog(@"%@",[obj writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");
//                
//            }
//        }];
        
//        ApplyProductViewController * applyProductVC = [[ApplyProductViewController alloc]init];
//        applyProductVC.product = _product;
        isEdit = 1 ;
        
        ApplyProductVC * apVC = [[ApplyProductVC alloc]init];
        apVC.product = _product;
        apVC.isUpdateCRM = isEdit;
        [self.navigationController pushViewController:apVC animated:YES];
        
    }
}


#pragma mark-tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        proOneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_product)
        {
            [cell.mechProIcon sd_setImageWithURL:[_product.mechProIcon convertHostUrl] placeholderImage:[UIImage imageNamed:@"work_product"]];
            cell.mechProNameLB.text = _product.mechProName;

            cell.mechProTypeLB.text = _product.mechProType;
            cell.mechProNameLB.text = _product.mechProName;
            if ([_product.tabInterestRate isEqual:@"null"]) {
                cell.tabInterestRateLB.text = @"";
            }else{
                cell.tabInterestRateLB.text = [NSString stringWithFormat:@"%@",_product.tabInterestRate];
            }
            cell.dayLB.text = [NSString stringWithFormat:@"放款时间：%@-%@",_product.minDay,_product.maxDay];
            cell.cashLB.text = [NSString stringWithFormat:@"放款金额：%@-%@",_product.minCash,_product.maxCash];
            cell.methodLB.text = _product.method;
        }
        return cell;
    }
    else
    {
        ProdTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell" forIndexPath:indexPath];
        cell.nameLabel.text = _nameArray[indexPath.row-1];
        if (_product)
        {
            switch (indexPath.row)
            {
                case 1:
                    if ([_product.appliCondition isEqual:@"null"]) {
                        cell.label.text = @" ";
                    }else{
                    cell.label.text = _product.appliCondition;
                    }
                    break;
                case 2:
                    if ([_product.appliMaterials isEqual:@"null"]) {
                        cell.label.text = @" ";
                    }else{
                        cell.label.text = _product.appliMaterials;
                    }

                    break;
                case 3:
                    if ([_product.costDescription isEqual:@"null"]) {
                        cell.label.text = @" ";
                    }else{
                        cell.label.text = _product.costDescription;
                    }
                    
                    break;
                default:
                    if ([_product.mechProtext isEqual:@"null"]) {
                        cell.label.text = @" ";
                    }else{
                        cell.label.text = _product.mechProtext;
                    }
                    break;
            }
        }
        return cell;
    }
}

#pragma mark tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 150;
    }else
    {
        CGFloat s;
        switch (indexPath.row)
        {
            case 1:
            {
                if ([_product.appliCondition isEqual:@"null"]) {
                    s = 0;
                }else{
                    s = [_product.appliCondition heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:kScreenWidth-26];
                }
                
            }
                break;
            case 2:
                if ([_product.appliMaterials isEqual:@"null"]) {
                    s = 0;
                }else{
                    s = [_product.appliMaterials heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:kScreenWidth-26];
                }
                break;
            case 3:
                
                if ([_product.costDescription isEqual:@"null"]) {
                    s = 0;
                }else{
                    s = [_product.costDescription heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:kScreenWidth-26];
                }
                break;
            default:
                if ([_product.mechProtext isEqual:@"null"]) {
                    s = 0;
                }else{
                    s = [_product.mechProtext heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:kScreenWidth-26];
                }
                break;
        }
        
        CGFloat defaultHeight = 67;
        
        CGFloat height = s+67 > defaultHeight ? s+67 : defaultHeight;

        return height;
    }
}
#pragma mark == == rightItem 的点击事件
- (void)editPush {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"撤销或添加推送" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"撤销推送" otherButtonTitles:@"添加推送", nil];
    [actionSheet showInView:self.navigationController.view];
//    JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"编辑推送" message:@"撤销或添加推送好友企业" delegate:self cancelButtonTitle:nil otherButtonTitles:@"撤销",@"添加", nil];
//    [alert show];
}
- (void)cancelPush {
    JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"撤回推送" message:@"是否撤回友好企业推送的该产品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)clickToPush {
    friendCopViewController *friend = [friendCopViewController new];
    friend.type = 4;
    friend.productId = self.product.ID;
    friend.refreshBlock = ^{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"pushEdit"] style:UIBarButtonItemStylePlain target:self action:@selector(editPush)];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.product.myPushId = @"1";
        self.refreshBlock();
    };
    [self.navigationController pushViewController:friend animated:YES];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"inter"] = @"queryRelationProduct";
    dic[@"productId"] = self.product.ID;
    dic[@"mechId"] = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
    
    if (buttonIndex == 0) {
        [HttpRequestEngine getMechanOfProductPushedWith:dic completion:^(id obj, NSString *errorStr) {
            if (errorStr == nil) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                NSString *errorMsg = [NSString stringWithFormat:@"%@",obj[@"errorMsg"]];
                NSArray *dataArr = obj[@"data"];
                if ([code isEqualToString:@"200"]) {
                    NSMutableArray *mechanism_other_id_Arr = [NSMutableArray array];
                    if (dataArr.count > 0) {
                        for (NSDictionary *dic in dataArr) {
                            NSString *ID = [NSString stringWithFormat:@"%@",dic[@"mechanism_other_id"]];
                            [mechanism_other_id_Arr addObject:ID];
                        }
                    }
                    friendCopViewController *friend = [friendCopViewController new];
                    friend.type = 2;
                    friend.mechanIDArr = mechanism_other_id_Arr;
                    friend.productId = self.product.ID;
                    friend.refreshCountBlcok = ^(NSInteger count){
                        self.refreshBlock();
                        if (count == 0) {
                            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"push"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToPush)];
                            self.navigationItem.rightBarButtonItem = rightItem;
                        }
                    };
                    friend.refreshBlock = ^{
                        
                    };
                    [self.navigationController pushViewController:friend animated:YES];
                } else {
                    [MBProgressHUD showError:errorMsg];
                }
            } else {
                [MBProgressHUD showError:errorStr];
            }
        }];
    } else if (buttonIndex == 1) {
        [HttpRequestEngine getMechanOfProductPushedWith:dic completion:^(id obj, NSString *errorStr) {
            if (errorStr == nil) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                NSString *errorMsg = [NSString stringWithFormat:@"%@",obj[@"errorMsg"]];
                NSArray *dataArr = obj[@"data"];
                if ([code isEqualToString:@"200"]) {
                    NSMutableArray *mechanism_other_id_Arr = [NSMutableArray array];
                    if (dataArr.count > 0) {
                        for (NSDictionary *dic in dataArr) {
                            NSString *ID = [NSString stringWithFormat:@"%@",dic[@"mechanism_other_id"]];
                            [mechanism_other_id_Arr addObject:ID];
                        }
                    }
                    
                    friendCopViewController *friend = [friendCopViewController new];
                    friend.type = 3;
                    friend.productId = self.product.ID;
                    friend.mechanIDArr = mechanism_other_id_Arr;
                    friend.refreshBlock = ^{
                        
                        self.refreshBlock();
                    };
                    [self.navigationController pushViewController:friend animated:YES];
                } else {
                    [MBProgressHUD showError:errorMsg];
                }
            } else {
                [MBProgressHUD showError:errorStr];
            }
        }];
    }
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (![Utils isBlankString:self.product.myPushId]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"inter"] = @"queryRelationProduct";
        dic[@"productId"] = self.product.ID;
        dic[@"mechId"] = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
        
        if (buttonIndex == 0) {
            [HttpRequestEngine getMechanOfProductPushedWith:dic completion:^(id obj, NSString *errorStr) {
                if (errorStr == nil) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    NSString *errorMsg = [NSString stringWithFormat:@"%@",obj[@"errorMsg"]];
                    NSArray *dataArr = obj[@"data"];
                    if ([code isEqualToString:@"200"]) {
                        NSMutableArray *mechanism_other_id_Arr = [NSMutableArray array];
                        if (dataArr.count > 0) {
                            for (NSDictionary *dic in dataArr) {
                                NSString *ID = [NSString stringWithFormat:@"%@",dic[@"mechanism_other_id"]];
                                [mechanism_other_id_Arr addObject:ID];
                            }
                        }
                        friendCopViewController *friend = [friendCopViewController new];
                        friend.type = 2;
                        friend.mechanIDArr = mechanism_other_id_Arr;
                        friend.productId = self.product.ID;
                        friend.refreshCountBlcok = ^(NSInteger count){
                            self.refreshBlock();
                            if (count == 0) {
                                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"push"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToPush)];
                                self.navigationItem.rightBarButtonItem = rightItem;
                            }
                        };
                        friend.refreshBlock = ^{
                            
                        };
                        [self.navigationController pushViewController:friend animated:YES];
                    } else {
                        [MBProgressHUD showError:errorMsg];
                    }
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        } else if (buttonIndex == 1) {
            [HttpRequestEngine getMechanOfProductPushedWith:dic completion:^(id obj, NSString *errorStr) {
                if (errorStr == nil) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    NSString *errorMsg = [NSString stringWithFormat:@"%@",obj[@"errorMsg"]];
                    NSArray *dataArr = obj[@"data"];
                    if ([code isEqualToString:@"200"]) {
                        NSMutableArray *mechanism_other_id_Arr = [NSMutableArray array];
                        if (dataArr.count > 0) {
                            for (NSDictionary *dic in dataArr) {
                                NSString *ID = [NSString stringWithFormat:@"%@",dic[@"mechanism_other_id"]];
                                [mechanism_other_id_Arr addObject:ID];
                            }
                        }
                        
                        friendCopViewController *friend = [friendCopViewController new];
                        friend.type = 3;
                        friend.productId = self.product.ID;
                        friend.mechanIDArr = mechanism_other_id_Arr;
                        friend.refreshBlock = ^{
                            
                            self.refreshBlock();
                        };
                        [self.navigationController pushViewController:friend animated:YES];
                    } else {
                        [MBProgressHUD showError:errorMsg];
                    }
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        }
    } else if (![Utils isBlankString:self.product.ptpId]) {
        if (buttonIndex == 1) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"inter"] = @"delRelationProduct";
            dic[@"productId"] = self.product.ID;
            dic[@"mechId"] = [NSString stringWithFormat:@"%ld",self.loginModel.jrqMechanismId];
            dic[@"mechIdother"] = self.product.mechId;
            dic[@"userId"] = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
            [HttpRequestEngine removeProductRelationSheepWithDic:dic completion:^(id obj, NSString *errorStr) {
                if (errorStr == nil) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    NSString *errorMsg = [NSString stringWithFormat:@"%@",obj[@"errorMsg"]];
                    if ([code isEqualToString:@"200"]) {
                        [MBProgressHUD showSuccess:@"撤回成功"];
                        self.refreshBlock();
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBProgressHUD showError:errorMsg];
                    }
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
            
        }
    }
}
@end
