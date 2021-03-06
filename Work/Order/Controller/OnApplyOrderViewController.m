//
//  OnApplyOrderViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OnApplyOrderViewController.h"
#import "OrderDetailOneCell.h"
#import "OrderDetailTwoCell.h"
#import "OrderDetailThreeCell.h"
#import "OrderDetailModel.h"

#import "ContactModel.h"

#import "ChoosePeopleViewController.h"
#import "FDAlertView.h"
#import "ContentView.h"
#import "chooseViewController.h"
#import "ApplyProductViewController.h"

#import "GetOrderDetailViewController.h"
#import "UpdateOrderDetailViewController.h"


#import "friendCopViewController.h"
#import "ContactDetailsViewController.h"
@interface OnApplyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * lookInfoTableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)UIButton * lookInfoSBtn;

@property(nonatomic,strong)UIButton * updataInfoBtn;

@property(nonatomic,strong)NSArray * returnPeopleName;

@property(nonatomic,strong)NSArray * returnPeopleID;

@property(nonatomic,assign)NSInteger temp;

@property(nonatomic, strong) ContactModel *contactModel;

@property(nonatomic) LoginPeopleModel *myModel;
@property (nonatomic) UIButton *btn1;
@property(nonatomic, strong) NSString *uid;//用于聊天的userid
@property(nonatomic, strong) NSString *mechName;//用于聊天的mechName
@property(nonatomic, strong) NSString *pushOrReceiveMechineName;
@end

@implementation OnApplyOrderViewController

static BOOL isEdit;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    NSArray *powerList = (NSArray *)self.myModel.powerList;
    NSMutableArray *funIdArray = [NSMutableArray array];
    for (int i=0; i<powerList.count; i++) {
        NSDictionary *powerDic = powerList[i];
        NSString *funId = [NSString stringWithFormat:@"%@",powerDic[@"funId"]];
        [funIdArray addObject:funId];
    }
    if ([funIdArray containsObject:@"31"]) {
        self.ispush = 1;
    }
    [self loadData];
    
    
    if (![Utils isBlankString:self.myPushId]) {
        [self requestDataWithMech_id:self.mechanism_other_id];
    } else if (![Utils isBlankString:self.ptpId]){
        [self requestDataWithMech_id:self.ptpMechId];
    }
}

- (void)requestDataWithMech_id:(NSString *)mech_id {
    [HttpRequestEngine getMechineByMech_id:mech_id completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            NSDictionary *dic = obj;
            self.pushOrReceiveMechineName = dic[@"name"];
        } else {
            self.pushOrReceiveMechineName = @"未知";
        }
    }];
    
}

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
    _lookInfoTableView.bounces = NO;
    _lookInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _lookInfoTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_lookInfoTableView];
    
    [_lookInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_X) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 84, 0));
        } else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(NaviHeight, 0, 60, 0));
        }
    }];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.lookInfoTableView setTableFooterView:view];
    

    _lookInfoSBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, kScreenHeight-50, (kScreenWidth-40)/2.0, 40)];
    [_lookInfoSBtn setBackgroundColor:TABBAR_BASE_COLOR];
    [_lookInfoSBtn setTitle:@"查看信息" forState:UIControlStateNormal];
    [_lookInfoSBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _lookInfoSBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _lookInfoSBtn.layer.cornerRadius = 5.0;
    _lookInfoSBtn.layer.masksToBounds = YES;
    [self.view addSubview:_lookInfoSBtn];
    [_lookInfoSBtn addTarget:self action:@selector(lookInfoSClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _updataInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(10+kScreenWidth/2.0, kScreenHeight-50, (kScreenWidth-40)/2.0, 40)];
    [_updataInfoBtn setBackgroundColor:[UIColor whiteColor]];
    [_updataInfoBtn setTitle:@"修改信息" forState:UIControlStateNormal];
    [_updataInfoBtn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
    _updataInfoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _updataInfoBtn.layer.cornerRadius = 5.0;
    _updataInfoBtn.layer.masksToBounds = YES;
    [_updataInfoBtn.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){242/255.0,242/255.0,242/255.0,1});
    [_updataInfoBtn.layer setBorderColor:color];
    [self.view addSubview:_updataInfoBtn];
    [_updataInfoBtn addTarget:self action:@selector(updataInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderOneCellID"];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderTwoCellID"];
    
    [_lookInfoTableView registerNib:[UINib nibWithNibName:@"OrderDetailThreeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderThreeCellID"];
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.layer.masksToBounds = YES;
    OrderDetailModel * model = self.dataArray[0];
    if ([self.publicity_mech_id isEqualToString:@"0"]) {
        
        self.uid = [NSString stringWithFormat:@"%ld",model.userId];
    } else {
        self.uid = [NSString stringWithFormat:@"%ld",model.tabUserId];
    }
    
    self.mechName = [NSString stringWithFormat:@"%@",model.mechName];
    [self.view addSubview:_btn1];
    _btn1.frame = CGRectMake(kScreenWidth-70,140,50, 50);
    if (IS_IPHONE_X) {
        _lookInfoSBtn.frame = CGRectMake(10, kScreenHeight-74, (kScreenWidth-40)/2.0, 40);
        _updataInfoBtn.frame = CGRectMake(10+kScreenWidth/2.0, kScreenHeight-74, (kScreenWidth-40)/2.0, 40);
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
    if (![Utils isBlankString:self.myPushId] || ![Utils isBlankString:self.ptpId]) {
        return 7;
    }
    return 6;
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
        cell.iconImageView.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFill
        cell.nameLabel.text = model.mpName;
        [cell.pushBtn removeTarget:self action:@selector(orderEditPush) forControlEvents:UIControlEventTouchUpInside];
        [cell.pushBtn removeTarget:self action:@selector(orderCancelPush) forControlEvents:UIControlEventTouchUpInside];
        [cell.pushBtn removeTarget:self action:@selector(orderPush) forControlEvents:UIControlEventTouchUpInside];
        if (model.tabSpeed == 1) {
            cell.speedLabel.text = @"申请中";
            cell.speedLabel.backgroundColor = UIColorFromRGB(0xa4c989, 1);
            
            UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"分配审批人" style:UIBarButtonItemStylePlain target:self action:@selector(OnClick)];
            
            if ([self.publicity_mech_id isEqualToString:@"0"]) {
                if ([self.jrq_mechanism_id isEqualToString:self.myMech_Id] && self.isAssignedApprover) {
                    self.navigationItem.rightBarButtonItem = right;
                }
            } else {
                if ([Utils isBlankString:self.myPushId] && self.isAssignedApprover) {
                    self.navigationItem.rightBarButtonItem = right;
                }
            }
            
            
            [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
            
            if (self.ispush) {
                
                if (![Utils isBlankString:self.myPushId]) {
                    _lookInfoSBtn.frame = CGRectMake(10, kScreenHeight-50, (kScreenWidth-20), 40);
                    _updataInfoBtn.hidden = YES;
                    if (model.tabSpeed == 1 || model.tabSpeed == 2 || model.tabSpeed == 7) {
                        cell.pushBtn.hidden = NO;
                        [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"编辑推送"] forState:UIControlStateNormal];
                        [cell.pushBtn addTarget:self action:@selector(orderEditPush) forControlEvents:UIControlEventTouchUpInside];
                    } else {
                        cell.pushBtn.hidden = YES;
                    }
                } else if (![Utils isBlankString:self.ptpId]) {
                    
                    if (model.tabSpeed == 1 || model.tabSpeed == 2 || model.tabSpeed == 7) {
                        cell.pushBtn.hidden = NO;
                        [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"取消推送"] forState:UIControlStateNormal];
                        [cell.pushBtn addTarget:self action:@selector(orderCancelPush) forControlEvents:UIControlEventTouchUpInside];
                    } else {
                        cell.pushBtn.hidden = YES;
                    }
                    
                } else {
                    
                    if (model.tabSpeed == 1) {
                        cell.pushBtn.hidden = NO;
                        [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"推送订单"] forState:UIControlStateNormal];
                        [cell.pushBtn addTarget:self action:@selector(orderPush) forControlEvents:UIControlEventTouchUpInside];
                    } else {
                        cell.pushBtn.hidden = YES;
                    }
                }
            }
            if ([self.publicity_mech_id isEqualToString:@"0"] && ![self.jrq_mechanism_id isEqualToString:self.myMech_Id]) {
                cell.pushBtn.hidden = YES;
            }
        }else if (model.tabSpeed == 2){
            cell.speedLabel.text = @"审批中";
            cell.speedLabel.backgroundColor = UIColorFromRGB(0x889fda, 1);
            
            if (![Utils isBlankString:self.myPushId] ) {
                
                if (model.tabSpeed == 1 || model.tabSpeed == 2 || model.tabSpeed == 7) {
                    cell.pushBtn.hidden = NO;
                    [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"编辑推送"] forState:UIControlStateNormal];
                    [cell.pushBtn addTarget:self action:@selector(orderEditPush) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    cell.pushBtn.hidden = YES;
                }
            } else if (![Utils isBlankString:self.ptpId]) {
                
                if (model.tabSpeed == 1 || model.tabSpeed == 2 || model.tabSpeed == 7) {
                    cell.pushBtn.hidden = NO;
                    [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"取消推送"] forState:UIControlStateNormal];
                    [cell.pushBtn addTarget:self action:@selector(orderCancelPush) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    cell.pushBtn.hidden = YES;
                }
                
            }
            
        }else if (model.tabSpeed == 3){
            cell.speedLabel.text = @"审批成功";
            cell.speedLabel.backgroundColor = customBlueColor;
       
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
            if (![Utils isBlankString:self.myPushId] ) {
                
                if (model.tabSpeed == 1 || model.tabSpeed == 2 || model.tabSpeed == 7) {
                    cell.pushBtn.hidden = NO;
                    [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"编辑推送"] forState:UIControlStateNormal];
                    [cell.pushBtn addTarget:self action:@selector(orderEditPush) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    cell.pushBtn.hidden = YES;
                }
            } else if (![Utils isBlankString:self.ptpId]) {
                
                if (model.tabSpeed == 1 || model.tabSpeed == 2 || model.tabSpeed == 7) {
                    cell.pushBtn.hidden = NO;
                    [cell.pushBtn setBackgroundImage:[UIImage imageNamed:@"取消推送"] forState:UIControlStateNormal];
                    [cell.pushBtn addTarget:self action:@selector(orderCancelPush) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    cell.pushBtn.hidden = YES;
                }
                
            }
        }
        
        
        return cell;
    }else {
        if (![Utils isBlankString:self.myPushId] || ![Utils isBlankString:self.ptpId]) {
            if (indexPath.row == 1) {
                OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (![Utils isBlankString:self.myPushId]) {
                    cell.leftLabel.text = @"推  送  至:";
                } else {
                    cell.leftLabel.text = @"接  收  自:";
                }
                
                cell.rightLabel.text = self.pushOrReceiveMechineName;
                return cell;
            }else if (indexPath.row == 2){
                
                OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.leftLabel.text = @"申  请  人:";
                cell.rightLabel.text = model.tabUName;
                
                return cell;
            }else if (indexPath.row == 3){
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
            }else if (indexPath.row == 4){
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
            }else if (indexPath.row == 5){
                OrderDetailTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTwoCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.leftLabel.text = @"申请额度:";
                if (model.tabQuota ) {
                    cell.rightLabel.text = [NSString stringWithFormat:@"%g万元",model.tabQuota];
                }else{
                    cell.rightLabel.text = @"未知";
                }
                
                return cell;
            }else if (indexPath.row == 6){
                
                OrderDetailThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OrderThreeCellID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.phoneLabel.text = @"联系方式:";
                [cell.phoneButton setTitle:model.tabUMobile forState:UIControlStateNormal];
                [cell.phoneButton setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
                
                cell.phoneButton.tag = 100;
                [cell.phoneButton addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
        } else {
            if (indexPath.row == 1){
                
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
            }
        }
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
    }else{
        return 60.f;
    }
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

/*
-(void)GoBack{
    NSLog(@"gg:%ld",self.temp);
    
    if (self.temp == 88) {
        
        if (self.isRefreshMyOrder != nil) {
            NSString * string = @"111";
            self.isRefreshMyOrder(string);
        }
 
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
*/
 
-(void)OnClick{
    
    if (self.isAssignedApprover) {
        
        chooseViewController * choosePeopleVC = [[chooseViewController alloc]init];
        choosePeopleVC.seType = 1;
        
        [choosePeopleVC returnMutableArray:^(NSMutableArray *returnMutableArray) {
            
            self.returnPeopleName = returnMutableArray;
            
            if (self.returnPeopleName.count != 0) {
                
                ContactModel * model = self.returnPeopleName[0];
                
                NSInteger colorRange = 0;
                if (model.realName.length == 2) {
                    colorRange = 2;
                }else if (model.realName.length == 3){
                    colorRange = 3;
                }else if (model.realName.length == 4){
                    colorRange = 4;
                }else if (model.realName.length == 5){
                    colorRange = 5;
                }
                
                NSString * str = [NSString stringWithFormat:@"确认将此订单分配给%@吗？",model.realName];
                NSMutableAttributedString * message = [[NSMutableAttributedString alloc]initWithString:str];
                //设置：在0-3个单位长度内的内容显示成红色
                [message addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, colorRange)];
                
                FDAlertView * alertView = [[FDAlertView alloc]init];
                alertView.center = self.navigationController.view.center;
                
                ContentView * contentView = [[ContentView alloc]init];
                contentView.frame = CGRectMake(0, 0, kScreenWidth-50, 120);
                
                [contentView ContentViewWithMessage:message andBlock:^{
                    
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    NSDictionary *parameters = @{@"inter": @"updOrderExamineuser",@"userId":[NSString stringWithFormat:@"%ld",self.myModel.userId],@"oid":[NSString stringWithFormat:@"%@",self.orderID],@"examineuser":[NSString stringWithFormat:@"%ld",model.userId]};
                    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *data = [NSDictionary changeType:responseObject];
                        NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                        if ([code isEqualToString:@"1"]) {
                            [MBProgressHUD showError:@"分配失败"];
                        } else {
                            [MBProgressHUD showSuccess:@"分配成功"];
                            
                            
                            [self.lookInfoTableView.header beginRefreshing];
                            [self loadData];
                            
                            self.temp = 88;
                            
                            
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"Error: %@", error);
                    }];
                    
                }];
                
                alertView.contentView = contentView;
                
                [alertView show];
                
            }
            
            
        }];
        
        [self.navigationController pushViewController:choosePeopleVC animated:YES];
        
    }else{
        [MBProgressHUD showError:@"暂无此权限"];
    }
    
}


-(void)lookInfoSClick:(UIButton *)sender{
    if (self.dataArray.count != 0) {
        
    
    
    GetOrderDetailViewController * getOrderDetailVC = [[GetOrderDetailViewController alloc]init];
    
    OrderDetailModel * model = self.dataArray[0];
    
    getOrderDetailVC.orderDetail = model;
    
    [self.navigationController pushViewController:getOrderDetailVC animated:YES];
    }
}

-(void)updataInfoClick:(UIButton *)sender{
    if (self.dataArray.count != 0) {
    
    UpdateOrderDetailViewController * updateOrderDetailVC = [[UpdateOrderDetailViewController alloc]init];
    
    OrderDetailModel * model = self.dataArray[0];
    
    updateOrderDetailVC.orderDetail = model;
        
        isEdit = 1;
        
        updateOrderDetailVC.isUpdateCRM = isEdit;
        
        
    
    [self.navigationController pushViewController:updateOrderDetailVC animated:YES];
    
    }
}

-(void)returnIsRefreshMyOrder:(ReturnIsRefreshMyOrderBlock)block{
    
    self.isRefreshMyOrder = block;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"gg:%ld",self.temp);
    
    if (self.temp == 88) {
        
        if (self.isRefreshMyOrder != nil) {
            NSString * string = @"111";
            self.isRefreshMyOrder(string);
        }
        
    }
}
#pragma mark == == rightItem 的点击事件
- (void)orderEditPush {
    JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"撤销推送" message:@"撤销向好友企业推送的订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)orderCancelPush {
    JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"撤回" message:@"是否撤回好友企业推送的该订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)orderPush {
    DLog(@"self.myPushId == %@,self.ptpId == %@",self.myPushId,self.ptpId);
    if ([Utils isBlankString:self.myPushId] && [Utils isBlankString:self.ptpId]) {
        friendCopViewController *friend = [friendCopViewController new];
        friend.type = 5;
        friend.orderID = [NSString stringWithFormat:@"%@",self.orderID];
        friend.productId = [NSString  stringWithFormat:@"%@",self.orderModel.proId];
        friend.publicity_mech_id = self.orderModel.publicity_mech_id;
        friend.refreshNameBlock = ^(NSString *name){
            self.myPushId = @"1";
            self.refreshBlock();
            self.pushOrReceiveMechineName = name;
            [self.lookInfoTableView reloadData];
            self.navigationItem.rightBarButtonItem = nil;
        };
        [self.navigationController pushViewController:friend animated:YES];
    }
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (![Utils isBlankString:self.myPushId]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"inter"] = @"delRelationOrder";
        dic[@"orderId"] = [NSString stringWithFormat:@"%@",self.orderID];
        dic[@"mechId"] = [NSString stringWithFormat:@"%ld",self.myModel.jrqMechanismId];
        dic[@"mechIdother"] = self.orderModel.delId;
        dic[@"userId"] = [NSString stringWithFormat:@"%ld",self.myModel.userId];
        
        if (buttonIndex == 1) {
            [HttpRequestEngine removeOrderPushRelationshipWithDic:dic completion:^(id obj, NSString *errorStr) {
                if (errorStr == nil) {
                    NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                    NSString *errorMsg = [NSString stringWithFormat:@"%@",obj[@"errorMsg"]];
                    if ([code isEqualToString:@"200"]) {
                        [MBProgressHUD showSuccess:@"撤回成功"];
                        self.myPushId = @"";
                        self.refreshBlock();
                        [self.lookInfoTableView reloadData];
//                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBProgressHUD showError:errorMsg];
                    }
                } else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        }
    } else if (![Utils isBlankString:self.ptpId]) {
        if (buttonIndex == 1) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"inter"] = @"delRelationOrder";
            dic[@"orderId"] = [NSString stringWithFormat:@"%@",self.orderID];
            dic[@"mechId"] = [NSString stringWithFormat:@"%ld",self.myModel.jrqMechanismId];
            dic[@"mechIdother"] = self.orderModel.delId;
            dic[@"userId"] = [NSString stringWithFormat:@"%ld",self.myModel.userId];
            [HttpRequestEngine removeOrderPushRelationshipWithDic:dic completion:^(id obj, NSString *errorStr) {
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
