//
//  ApproveDetailViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/22.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ApproveDetailViewController.h"
#import "OrderDetailOneCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderDetailThreeCell.h"
#import "OrderDetailFourCell.h"
#import "OrderDetailModel.h"

#import "FDAlertView.h"
#import "FailureView.h"
#import "SuccessView.h"
#import "OngoingView.h"

#import "ChooseResultView.h"

#import "GetOrderDetailViewController.h"
#import "ContactDetailsViewController.h"
@interface ApproveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(nonatomic,strong)UITableView * lookInfoTableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)UIButton * lookInfoBtn;

@property(nonatomic,strong)UIView * vv;

@property(nonatomic,assign)NSInteger temp;

@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) NSString *uid;//用于聊天的userid
@property(nonatomic, strong) NSString *mechName;//用于聊天的mechName
@property(nonatomic, strong) NSString *pushOrReceiveMechineName;
@end

@implementation ApproveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
//    if (![Utils isBlankString:self.myPushId]) {
//        [self requestDataWithMech_id:self.mechanism_other_id];
//    } else if (![Utils isBlankString:self.ptpId]){
//        [self requestDataWithMech_id:self.ptpMechId];
//    }
}

//- (void)requestDataWithMech_id:(NSString *)mech_id {
//    [HttpRequestEngine getMechineByMech_id:mech_id completion:^(id obj, NSString *errorStr) {
//        if (errorStr == nil) {
//            NSDictionary *dic = obj;
//            self.pushOrReceiveMechineName = dic[@"name"];
//        } else {
//            self.pushOrReceiveMechineName = @"未知";
//        }
//    }];
//
//}
-(void)loadData{
    
    NSInteger oId = [self.orderID integerValue];
    
    [HttpRequestEngine getOrderDetailWithOid:oId completion:^(id obj, NSString *errorStr) {
        
        [self.lookInfoTableView.header endRefreshing];
        if (errorStr == nil) {
            [self.dataArray removeAllObjects];
            
            [self.dataArray addObjectsFromArray:obj];
            
            [self creatUI];
            [self.lookInfoTableView reloadData];
        }else{
            [MBProgressHUD showError:@"未查询到数据"];
            
            [self.dataArray removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
}

-(void)creatUI{
    
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
//    self.navigationItem.leftBarButtonItem = left;
//    
//    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    _lookInfoTableView = [[UITableView alloc]init];
    _lookInfoTableView.delegate = self;
    _lookInfoTableView.dataSource = self;
//    _lookInfoTableView.bounces = NO;
    _lookInfoTableView.showsVerticalScrollIndicator = NO;
    _lookInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_lookInfoTableView];
    
    [_lookInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (self.ishideNaviView) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60, 0));
//        }
        if (IS_IPHONE_X) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 84, 0));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 60, 0));
        }
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.lookInfoTableView setTableFooterView:view];
    
    _lookInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-50, kScreenWidth-20, 40)];
    if (self.ishideNaviView) {
        _lookInfoBtn.frame = CGRectMake(10, kScreenHeight-NaviHeight-50, kScreenWidth-20, 40);
    }
    [_lookInfoBtn setBackgroundColor:TABBAR_BASE_COLOR];
    [_lookInfoBtn setTitle:@"查看信息" forState:UIControlStateNormal];
    [_lookInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lookInfoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _lookInfoBtn.layer.cornerRadius = 5.0;
    _lookInfoBtn.layer.masksToBounds = YES;
    [self.view addSubview:_lookInfoBtn];
 
    [_lookInfoBtn addTarget:self action:@selector(lookInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderOneCellID"];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderTwoCellID"];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailThreeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderThreeCellID"];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailFourCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderFourCellID"];
    
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.layer.masksToBounds = YES;
    OrderDetailModel * model = self.dataArray[0];
    if ([self.publicity_mech_id isEqualToString:@"0"]) {
        self.uid = [NSString stringWithFormat:@"%ld",model.userId];
    } else {
        self.uid = [NSString stringWithFormat:@"%ld",model.tabUserId];
    }
    self.mechName = [NSString stringWithFormat:@"%@",model.mechName];
    if (!self.isFromConversations) {
        [self.view addSubview:_btn1];
    }
    _btn1.frame = CGRectMake(kScreenWidth-70,140,50, 50);
    if (IS_IPHONE_X) {
        _lookInfoBtn.frame = CGRectMake(10, kScreenHeight-74, kScreenWidth-20, 40);
        _btn1.frame = CGRectMake(kScreenWidth-70,140+24,50, 50);
    }
    [_btn1 addTarget:self action:@selector(PeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btn1 sd_setBackgroundImageWithURL:[model.UserIcon convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    if ([self.jrq_mechanism_id isEqualToString:self.myMech_Id]) {
        self.uid = [NSString stringWithFormat:@"%ld",model.tabUserId];
        [_btn1 sd_setBackgroundImageWithURL:[model.tabUserIcon convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    [_btn1.layer setCornerRadius:25];
    
    if (![Utils isBlankString:self.ptpId]) {
        self.uid = [NSString stringWithFormat:@"%@",self.ptpMechUserId];
        [_btn1 sd_setBackgroundImageWithURL:[self.ptpMechUserIcon convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
}

- (void)PeopleBtnClick:(UIButton *)btn {
    ContactDetailsViewController *ContactDetails = [ContactDetailsViewController new];
    ContactDetails.setype = 4;
    ContactDetails.uid = self.uid;
    ContactDetails.mechName = self.mechName;
    [self.navigationController pushViewController:ContactDetails animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailCell"];
    }
    
    OrderDetailModel * model = self.dataArray[indexPath.section];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        OrderDetailOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderOneCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,model.mpIcon];
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        [cell.iconImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"work_product"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];

        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.nameLabel.text = model.mpName;
        
        if (model.tabSpeed == 1) {
            cell.speedLabel.text = @"申请中";
            cell.speedLabel.backgroundColor = UIColorFromRGB(0xa4c989, 1);
        
        }else if (model.tabSpeed == 2){
            cell.speedLabel.text = @"审批中";
            cell.speedLabel.backgroundColor = UIColorFromRGB(0x889fda, 1);
           
            UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
            right.tag = 24;
            self.navigationItem.rightBarButtonItem = right;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

            
        }else if (model.tabSpeed == 3){
            cell.speedLabel.text = @"审批成功";
            cell.speedLabel.backgroundColor = customBlueColor;
            
            UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
            right.tag = 23;
            self.navigationItem.rightBarButtonItem = right;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

       
        }else if (model.tabSpeed == 4){
            cell.speedLabel.text = @"已签约";
            cell.speedLabel.backgroundColor = customGreenColor;
          
        }else if (model.tabSpeed == 5){
            cell.speedLabel.text = @"已放款";
            cell.speedLabel.backgroundColor = UIColorFromRGB(0xeb6877, 1);
          
        }else if (model.tabSpeed == 6){
            cell.speedLabel.text = @"已成功";
            cell.speedLabel.backgroundColor = UIColorFromRGB(0xeb6877, 1);
            
       
        }else if (model.tabSpeed == 7){
            cell.speedLabel.text = @"未通过";
            cell.speedLabel.backgroundColor = [UIColor lightGrayColor];
            
            UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
            self.navigationItem.rightBarButtonItem = right;
            right.tag = 22;
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

        
        }
    
        return cell;
    }else if (indexPath.row == 1){
        
        OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = @"申  请  人:";
        cell.rightLabel.text = model.tabUName;
        
        return cell;
    }else if (indexPath.row == 2){
        OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = @"申请时间:";
        
        /****日期转换****/
        NSString * time = [NSString stringWithFormat:@"%zd000",model.tabCreateTime];
        NSInteger number = [time integerValue]/1000;
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate * comformTime = [NSDate dateWithTimeIntervalSince1970:number];
        NSString * comformTimeStr = [formatter stringFromDate:comformTime];
        
        cell.rightLabel.text = comformTimeStr;
        
        return cell;
    }else if (indexPath.row == 3){
        OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = @"放款时间:";
        if (model.tableFinishTime) {
            
            /****日期转换****/
            NSString * time = [NSString stringWithFormat:@"%zd000",model.tableFinishTime];
            NSInteger number = [time integerValue]/1000;
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate * comformTime = [NSDate dateWithTimeIntervalSince1970:number];
            NSString * comformTimeStr = [formatter stringFromDate:comformTime];
            
            cell.rightLabel.text = comformTimeStr;
            
        }else{
            cell.rightLabel.text = @"尚未放款";
        }
        
        return cell;
    }else if (indexPath.row == 4){
        OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = @"申请额度:";
        if (model.tabQuota ) {
            cell.rightLabel.text = [NSString stringWithFormat:@"%g万元",model.tabQuota];
        }else{
            cell.rightLabel.text = @"未知";
        }
        
        return cell;
    }else if (indexPath.row == 5){
        OrderDetailThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderThreeCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.phoneLabel.text = @"联系方式:";
        [cell.phoneButton setTitle:model.tabUMobile forState:UIControlStateNormal];
        [cell.phoneButton setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
        
        cell.phoneButton.tag = 100;
        [cell.phoneButton addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.row == 6){
        
        OrderDetailFourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFourCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (model.failureCause.length != 0 && model.tabSpeed == 7) {
            cell.TopLabel.text = @"失败原因:";
            cell.BottomTextView.userInteractionEnabled = NO;
            cell.BottomTextView.text = [NSString stringWithFormat:@"%@",model.failureCause];

        }else if (model.examineInfo.length != 0 && model.tabSpeed == 2){
            
            cell.TopLabel.text = @"审批备注:";
            cell.BottomTextView.userInteractionEnabled = NO;
            cell.BottomTextView.text = [NSString stringWithFormat:@"%@",model.examineInfo];
        }else if (model.tabSpeed == 3){
            
            cell.TopLabel.text = @"";
            cell.BottomTextView.userInteractionEnabled = NO;
            cell.BottomTextView.text = @"";
        }
        
        
        
        
        return cell;
        
    }
    
    return cell;
}

-(void)phoneClick:(UIButton *)sender{
    
        /*******拨打电话********/
    
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",sender.titleLabel.text];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 90.f;
    }else if (indexPath.row == 6){
        return 160.f;
    }
    else{
        return 60.f;
    }
}

-(NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.temp == 66) {
        if (self.isRefreshApproveOrder != nil) {
            NSString * string = @"99";
            self.isRefreshApproveOrder(string);
        }
    }
}

-(void)ApproveOnClick:(UIBarButtonItem *)item{
    
    if (item.tag == 22) {
        
        FDAlertView * alertView = [[FDAlertView alloc]init];
        alertView.center = self.navigationController.view.center;
        OrderDetailModel* model = self.dataArray[0];
        
        FailureView * failureView = [[FailureView alloc]init];
        failureView.frame = CGRectMake(0, 0, kScreenWidth-50, 200);
        [failureView FailureViewWithClickBlock:^{
            
            FDAlertView * alertView = [[FDAlertView alloc]init];
            alertView.center = self.navigationController.view.center;
            ChooseResultView * chooseView = [[ChooseResultView alloc]init];
            chooseView.frame = CGRectMake(0, 0, kScreenWidth-50, 280);
            
            [chooseView ChooseResultViewWithOngoingBlock:^{
                
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 24;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];
                
            } SuccessBlock:^{
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 23;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];

            } FailureBlock:^{
                
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 22;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];
                

            } andSendBlock:^{
                
                JKAlertView * alert = [[JKAlertView alloc]initWithTitle:@"请选择审批结果" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                [alert show] ;

                
            }];
            alertView.contentView = chooseView;
            [alertView show];

            
        } andSendBlock:^{
            
            NSInteger  oid = [self.orderID integerValue];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDictionary *parameters = @{@"inter":@"updateOrderInfo",@"oid":[NSString stringWithFormat:@"%ld",oid],@"speed":[NSString stringWithFormat:@"7"],@"failurecause":[NSString stringWithFormat:@"%@",failureView.textView.text]};
            
            [manager POST:ORDER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"==:%@",responseObject);
                NSData *data = responseObject;
                NSString *code = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if ([code isEqualToString:@"false"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"修改失败"]];
                } else {
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"修改成功"]];
                    //  [self.navigationController popViewControllerAnimated:YES];
                    [self.lookInfoTableView.header beginRefreshing];
                    [self loadData];
                    
                    self.temp = 66;
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                
            }];
        }];
        
        NSString * textString = [NSString stringWithFormat:@"%@",model.failureCause];
        failureView.textView.text = textString;

        alertView.contentView = failureView;
        
        [alertView show];
        
    }else if (item.tag == 23){
        
        FDAlertView * alertView = [[FDAlertView alloc]init];
        alertView.center = self.navigationController.view.center;

        SuccessView * successView = [[SuccessView alloc]init];
        successView.frame = CGRectMake(0, 0, kScreenWidth-50, 140);
        
        OrderDetailModel* model = self.dataArray[0];
        
        [successView SuccessViewWithClickBlock:^{
            FDAlertView * alertView = [[FDAlertView alloc]init];
            alertView.center = self.navigationController.view.center;
            ChooseResultView * chooseView = [[ChooseResultView alloc]init];
            chooseView.frame = CGRectMake(0, 0, kScreenWidth-50, 280);
            [chooseView ChooseResultViewWithOngoingBlock:^{
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 24;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];
            } SuccessBlock:^{
                
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 23;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];
                
            } FailureBlock:^{
                
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 22;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];

            } andSendBlock:^{
               
            JKAlertView * alert = [[JKAlertView alloc]initWithTitle:@"请选择审批结果" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                    
            [alert show] ;
              
            }];
            alertView.contentView = chooseView;
            [alertView show];
            
        } andSendBlock:^{
            
            if (successView.quotaTextField.text.length == 0) {
                
                JKAlertView * alert = [[JKAlertView alloc]initWithTitle:@"请输入贷款额度" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                [alert show] ;
                
            }else{
                
                NSInteger  oid = [self.orderID integerValue];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                NSString * quotaStr = [NSString stringWithFormat:@"%@",successView.quotaTextField.text];
                //  CGFloat quota = [quotaStr floatValue];
                NSDictionary *parameters = @{@"inter":@"updateOrderInfo",@"oid":[NSString stringWithFormat:@"%ld",oid],@"speed":[NSString stringWithFormat:@"3"],@"quota":quotaStr};
                
                
                NSLog(@"parameters == %@",parameters);
                
                [manager POST:ORDER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //NSLog(@"==:%@",responseObject);
                    NSData *data = responseObject;
                    NSString *code = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    if ([code isEqualToString:@"false"]) {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"修改失败"]];
                    } else {
                        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"修改成功"]];
                        //  [self.navigationController popViewControllerAnimated:YES];
                        [self.lookInfoTableView.header beginRefreshing];
                        [self loadData];
                        self.temp = 66;
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                    
                }];
                
            }
            
        }];
      
        NSString * textString = [NSString stringWithFormat:@"%g",model.tabQuota];
        successView.quotaTextField.text = textString;
        alertView.contentView = successView;
        [alertView show];
        
    }else if (item.tag == 24){
        
        OrderDetailModel* model = self.dataArray[0];
        
        FDAlertView * alertView = [[FDAlertView alloc]init];
        alertView.center = self.navigationController.view.center;
        
        OngoingView * ongoingView = [[OngoingView alloc]init];
        ongoingView.frame = CGRectMake(0, 0, kScreenWidth-50, 200);
        
        [ongoingView OngoingViewWithClickBlock:^{
            FDAlertView * alertView = [[FDAlertView alloc]init];
            alertView.center = self.navigationController.view.center;
            ChooseResultView * chooseView = [[ChooseResultView alloc]init];
            chooseView.frame = CGRectMake(0, 0, kScreenWidth-50, 280);
            [chooseView ChooseResultViewWithOngoingBlock:^{
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 24;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];

            } SuccessBlock:^{
                
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 23;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];
                
                
            } FailureBlock:^{
                UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"进入审批" style:UIBarButtonItemStylePlain target:self action:@selector(ApproveOnClick:)];
                right.tag = 22;
                self.navigationItem.rightBarButtonItem = right;
                [self ApproveOnClick:right];
                
            } andSendBlock:^{
                
                JKAlertView * alert = [[JKAlertView alloc]initWithTitle:@"请选择审批结果" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                
                [alert show] ;

                
            }];
            alertView.contentView = chooseView;
            [alertView show];

        } andSendBlock:^{
             NSInteger  oid = [self.orderID integerValue];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSDictionary *parameters = @{@"inter":@"updateOrderInfo",@"oid":[NSString stringWithFormat:@"%ld",oid],@"speed":[NSString stringWithFormat:@"2"],@"examineInfo":[NSString stringWithFormat:@"%@",ongoingView.textView.text]};
            
            [manager POST:ORDER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //NSLog(@"==:%@",responseObject);
                NSData *data = responseObject;
                NSString *code = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                if ([code isEqualToString:@"false"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"修改失败"]];
                } else {
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"修改成功"]];
                    //  [self.navigationController popViewControllerAnimated:YES];
                    [self.lookInfoTableView.header beginRefreshing];
                    [self loadData];
                    self.temp = 66;
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                
            }];
            
            
        }];
        
        NSString * textString = [NSString stringWithFormat:@"%@",model.examineInfo];
        ongoingView.textView.text = textString;
        ongoingView.textView.delegate = self;
        alertView.contentView = ongoingView;
        [alertView show];
        
    }
    
}
- (void)textViewDidChange:(UITextView *)textView {
    //字数限制操作
    if (textView.text.length >= 120) {
        
        textView.text = [textView.text substringToIndex:120];
    }
}
-(void)lookInfoClick:(UIButton *)sender{
    if (self.dataArray.count != 0) {
        
        GetOrderDetailViewController * getOrderDetailVC = [[GetOrderDetailViewController alloc]init];
        
        if (self.ishideNaviView) {
            getOrderDetailVC.ishideNaviView = 1;
        }
        
        OrderDetailModel * model = self.dataArray[0];
        
        getOrderDetailVC.orderDetail = model;
        
        [self.navigationController pushViewController:getOrderDetailVC animated:YES];
        
    }
}

-(void)returnIsRefreshApproveOrder:(ReturnIsRefreshApproveOrderBlock)block{
    self.isRefreshApproveOrder = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of fany resources that can be recreated.
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
