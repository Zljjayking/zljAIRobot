//
//  buyMeOrderDetailViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/8/10.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeOrderDetailViewController.h"
#import "approvalDetailTableViewCell.h"
#import "approvalStateTableViewCell.h"
#import "approvalChooseTableViewCell.h"
#import "approvalImageTableViewCell.h"
#import "approvalImageTwoTableViewCell.h"
#import "approvalTimeTableViewCell.h"
#import "approvalContentTableViewCell.h"
#import "approvalNoticeTableViewCell.h"
#import "approvalTFTableViewCell.h"
#import "approvalTFTwoTableViewCell.h"
#import "approvalLBTableViewCell.h"
#import "approcalLBTwoTableViewCell.h"
#import "buyMe_orderDetailOneTableViewCell.h"
#import "buyMeOrderBillView.h"
#import "HXPhotoPreviewViewController.h"
@interface buyMeOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *orderDetailTableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger mechCount;
@property (nonatomic, strong) NSMutableArray *kaoQinArr;
@property (nonatomic, strong) NSMutableArray *gaoPaiArr;
@property (nonatomic, strong) buyMeOrderBillView *orderBillView;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation buyMeOrderDetailViewController
/**
 {
 "child": [
 {
 "create_time": 1502160459000,
 "id": 9,
 "money": "400",
 "name": "考勤机",
 "orderId": 8,
 "preferential": 0,//优惠  0  不优惠 1
 "status": 0,
 "type": 2//1 高拍 2 打卡机
 },
 {
 "create_time": 1502160459000,
 "id": 10,
 "money": "800",
 "name": "高拍",
 "orderId": 8,
 "preferential": 0,
 "status": 0,
 "type": 1
 }
 ],
 "createTime":null,
 "ordIcon":null,
 "invoicing_state":0,//是否已经开发票 0 未开  1 已 开
 "id": 8,
 "invoicing": "0",//是否开发票 0 不开  1 开
 "end_time": 1533571200000,
 "icon": "/usericon/uic1484021733722.jpg",
 "money": "2550",
 "orderNo": "oa20170811093003382",
 "personSize": 10,
 "real_name": "翟良杰",
 "start_time": 1502035200000,
 "state": "2",
 "vipTime": "12"
 }
 */
- (UITableView *)orderDetailTableView {
    if (!_orderDetailTableView) {
        _orderDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10) style:UITableViewStylePlain];
        _orderDetailTableView.layer.cornerRadius = 10;

        _orderDetailTableView.delegate = self;
        _orderDetailTableView.dataSource = self;
        _orderDetailTableView.tableFooterView = [UIView new];
//        _orderDetailTableView.bounces = NO;
        _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderDetailTableView.backgroundColor = VIEW_BASE_COLOR;
        [_orderDetailTableView registerClass:[approvalDetailTableViewCell class] forCellReuseIdentifier:@"one"];
        [_orderDetailTableView registerClass:[approvalTFTableViewCell class] forCellReuseIdentifier:@"eight"];
        [_orderDetailTableView registerClass:[buyMe_orderDetailOneTableViewCell class] forCellReuseIdentifier:@"orderOne"];
        
    }
    return _orderDetailTableView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        _topView.backgroundColor = [UIColor whiteColor];
        
//        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth-20, 11)];
//        backV.backgroundColor = [UIColor whiteColor];
//        backV.layer.cornerRadius = 10;
//        [_topView addSubview:backV];
//        
//        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kScreenWidth-20, 9)];
//        backTwoV.backgroundColor = [UIColor whiteColor];
//        [_topView addSubview:backTwoV];
    }
    return _topView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
//        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 19)];
//        backV.backgroundColor = [UIColor whiteColor];
//        backV.layer.cornerRadius = 10;
//        [_bottomView addSubview:backV];
//        
//        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 9)];
//        backTwoV.backgroundColor = [UIColor whiteColor];
//        [_bottomView addSubview:backTwoV];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    self.kaoQinArr = [NSMutableArray arrayWithCapacity:0];
    self.gaoPaiArr = [NSMutableArray arrayWithCapacity:0];
    self.dataList = [NSMutableArray arrayWithCapacity:0];
    [self requestOrderDetail];
    
    
    // Do any additional setup after loading the view.
}
- (void)requestOrderDetail {
    [HttpRequestEngine getBuyMeOrderDetailWithID:self.ID completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            self.dataDic = obj;
            NSArray *mechArr = self.dataDic[@"child"];
            NSString *urlStr = self.dataDic[@"ordIcon"];
            if (![Utils isBlankString:urlStr]) {
                HXPhotoModel *model = [[HXPhotoModel alloc] init];
                model.type = HXPhotoModelMediaTypeWebImage;
                model.imageURL = urlStr;
                model.bigURL = [urlStr stringByReplacingOccurrencesOfString:@"_min.jpg" withString:@".jpg"];
                NSData *data = [NSData dataWithContentsOfURL:[model.imageURL convertHostUrl]];
                UIImage *image = [UIImage imageWithData:data];
                if (image != nil) {
                    model.imageSize = CGSizeMake(image.size.width, image.size.height);
                    model.thumbPhoto = image;
                    model.previewPhoto = image;
                } else {
                    model.imageSize = CGSizeMake(kScreenWidth, kScreenWidth);
                    model.thumbPhoto = [UIImage imageNamed:@"placeholderImg"];
                    model.previewPhoto = [UIImage imageNamed:@"placeholderImg"];
                }
                [self.dataList addObject:model];
                
            }

            if (mechArr.count) {
                for (NSDictionary *dic in mechArr) {
                    NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
                    if ([type isEqualToString:@"2"]) {
                        [self.kaoQinArr addObject:dic];
                    } else {
                        [self.gaoPaiArr addObject:dic];
                    }
                }
                if (self.kaoQinArr.count && self.gaoPaiArr.count) {
                    self.mechCount = 2;
                } else {
                    self.mechCount = 1;
                }
            } else {
                self.mechCount = 0;
            }
            [self.view addSubview:self.orderDetailTableView];
            switch ([self.model.flag integerValue]) {
                case 1:
                {
                    self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 465);
                    if (self.mechCount) {
                        self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 465+60*self.mechCount);
                        if (465+60*self.mechCount > kScreenHeight - NaviHeight-10 || 465 > kScreenHeight - NaviHeight-10) {
                            self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10);
                        }
                    }
                }
                    break;
                case 2:
                {
                    self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 405);
                    if (405 > kScreenHeight - NaviHeight-10) {
                        self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10);
                    }
                }
                    break;
                case 3:
                {
                    self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 405);
                    if (405 > kScreenHeight - NaviHeight-10) {
                        self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10);
                    }
                }
                    break;
                case 4:
                {
                    self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 345);
                    if (self.mechCount) {
                        self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 345+60*self.mechCount);
                        if (345+60*self.mechCount > kScreenHeight - NaviHeight-10) {
                            self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10);
                        }
                    }
                }
                    break;
                default:
                {
                    self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 465);
                    if (self.mechCount) {
                        self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, 465+60*self.mechCount);
                        if (465+60*self.mechCount > kScreenHeight - NaviHeight-10) {
                            self.orderDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10);
                        }
                    }
                }
                    break;
            }
            [self.orderDetailTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 95;
    } else{
        return 60;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.topView;
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        view.backgroundColor = VIEW_BASE_COLOR;
        
        UIImageView *upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"approvalDown"]];
        upImage.frame = CGRectMake(0, 0, kScreenWidth-20, 26);
        [view addSubview:upImage];
        
        return view;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        view.backgroundColor = VIEW_BASE_COLOR;
        
        UIImageView *upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"approvalUp"]];
        upImage.frame = CGRectMake(0, 0, kScreenWidth-20, 15);
        [view addSubview:upImage];
        
        return view;
        
    } else {
        return self.bottomView;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        switch ([self.model.flag integerValue]) {
            case 1:
            {
                if (self.mechCount) {
                    return 5+self.mechCount;
                }
                return 5;
            }
                break;
            case 2:
                return 4;
                break;
            case 3:
                return 4;
                break;
            case 4:
            {
                if (self.mechCount) {
                    return 3+self.mechCount;
                }
                return 3;
            }
                break;
                
            default:
            {
                if (self.mechCount) {
                    return 5+self.mechCount;
                }
                return 5;
            }
                break;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            approvalDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[approvalDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            cell.orderNumLB.text = [NSString stringWithFormat:@"订单号：%@",self.model.orderNo];
            [cell.headerImage sd_setImageWithURL:[self.dataDic[@"icon"] convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
            cell.nameLB.text = self.dataDic[@"real_name"];
            cell.dayLB.text = [Utils stringToMoneyWithValue:[self.dataDic[@"money"] doubleValue]];
            cell.dayLB.textColor = customRedColor;
            cell.numberLB.text = self.model.createTime;
            cell.numberLB.textColor = GRAY229;
            cell.seperator1.hidden = YES;
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
            if (cell == nil) {
                cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
            }
            cell.chooseTF.enabled = NO;
            switch ([self.model.flag integerValue]) {
                case 1:
                    cell.chooseTF.text = @"初始支付";
                    break;
                case 2:
                    cell.chooseTF.text = @"时间扩容";
                    break;
                case 3:
                    cell.chooseTF.text = @"条数扩容";
                    break;
                case 4:
                    cell.chooseTF.text = @"购买设备";
                    break;
                    
                default:
                    cell.chooseTF.text = @"未知状态";
                    break;
            }
            
            cell.chooseTF.keyboardType = UIKeyboardTypeDecimalPad;
            cell.titleLabel.text = @"订单类型";
            cell.star.hidden = YES;
            return cell;
        } else {
            switch ([self.model.flag integerValue]) {
                case 1:
                {
                    buyMe_orderDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderOne"];
                    if (cell == nil) {
                        cell = [[buyMe_orderDetailOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderOne"];
                    }
                    cell.stateLB.enabled = NO;
                    cell.stateLB.delegate = self;
                    cell.arrowImage.hidden = YES;
                    if (indexPath.row == 1) {
                        cell.titleLB.text = @"条数档位";
                        cell.stateLB.text = [NSString stringWithFormat:@"%@条",self.dataDic[@"personSize"]];
                    } else if(indexPath.row == 2) {
                        cell.titleLB.text = @"购买时长";
                        cell.stateLB.text = [NSString stringWithFormat:@"%@个月",self.dataDic[@"vipTime"]];
                    } else if(indexPath.row == 3+self.mechCount) {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        cell.selectedBackgroundView = [[UIView alloc] init];
                        cell.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
                        cell.arrowImage.hidden = NO;
                        NSString *invoicing_state = [NSString stringWithFormat:@"%@",self.dataDic[@"invoicing_state"]];
                        if ([invoicing_state integerValue] == 1) {
                            cell.titleLB.text = @"电子发票已开具";
                            cell.stateLB.placeholder = @"点击查看";
                        } else {
                            cell.titleLB.text = @"电子发票未开具";
                            cell.stateLB.placeholder = @"去开具";
                        }
                    } else if(indexPath.row == 4+self.mechCount) {
                        cell.stateLB.hidden = YES;
                        cell.titleLB.hidden = YES;
                        cell.arrowImage.hidden = YES;
                        cell.seperator.hidden = YES;
                        UILabel *titleLB = [[UILabel alloc]init];
                        [cell addSubview:titleLB];
                        titleLB.numberOfLines = 0;
                        titleLB.textColor = GRAY200;
                        titleLB.font = [UIFont systemFontOfSize:11];
                        titleLB.text = @"1.如需开具发票，请在订单完成后30天内申请开具\n2.申请开具发票后，我们将在3个工作日内为您开具发票";
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(20);
                            make.right.equalTo(cell.mas_right).offset(-20);
                            make.centerY.equalTo(cell.mas_centerY);
                        }];
                    } else {
                        if (self.kaoQinArr.count && self.gaoPaiArr.count) {
                            if (indexPath.row == 3) {
                                cell.titleLB.text = @"考勤机";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.kaoQinArr.count];
                            } else {
                                cell.titleLB.text = @"高拍仪";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.gaoPaiArr.count];
                            }
                        } else {
                            if (self.kaoQinArr.count) {
                                cell.titleLB.text = @"考勤机";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.kaoQinArr.count];
                            }
                            if (self.gaoPaiArr.count) {
                                cell.titleLB.text = @"高拍仪";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.gaoPaiArr.count];
                            }
                        }
                    }
                    return cell;
                }
                    break;
                case 2:
                {
                    buyMe_orderDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderOne"];
                    if (cell == nil) {
                        cell = [[buyMe_orderDetailOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderOne"];
                    }
                    cell.stateLB.enabled = NO;
                    cell.stateLB.delegate = self;
                    cell.arrowImage.hidden = YES;
                    if(indexPath.row == 1) {
                        cell.titleLB.text = @"购买时长";
                        cell.stateLB.text = [NSString stringWithFormat:@"%@个月",self.dataDic[@"vipTime"]];
                    } else if(indexPath.row == 2) {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        cell.selectedBackgroundView = [[UIView alloc] init];
                        cell.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
                        cell.arrowImage.hidden = NO;
                        NSString *invoicing_state = [NSString stringWithFormat:@"%@",self.dataDic[@"invoicing_state"]];
                        if ([invoicing_state integerValue] == 1) {
                            cell.titleLB.text = @"电子发票已开具";
                            cell.stateLB.placeholder = @"点击查看";
                        } else {
                            cell.titleLB.text = @"电子发票未开具";
                            cell.stateLB.placeholder = @"去开具";
                        }
                    } else if(indexPath.row == 3) {
                        cell.stateLB.hidden = YES;
                        cell.titleLB.hidden = YES;
                        cell.arrowImage.hidden = YES;
                        cell.seperator.hidden = YES;
                        UILabel *titleLB = [[UILabel alloc]init];
                        [cell addSubview:titleLB];
                        titleLB.numberOfLines = 0;
                        titleLB.textColor = GRAY200;
                        titleLB.font = [UIFont systemFontOfSize:11];
                        titleLB.text = @"1.如需开具发票，请在订单完成后30天内申请开具\n2.申请开具发票后，我们将在3个工作日内为您开具发票";
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(20);
                            make.right.equalTo(cell.mas_right).offset(-20);
                            make.centerY.equalTo(cell.mas_centerY);
                        }];
                    }
                    return cell;
                }
                    break;
                case 3:
                {
                    buyMe_orderDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderOne"];
                    if (cell == nil) {
                        cell = [[buyMe_orderDetailOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderOne"];
                    }
                    cell.stateLB.enabled = NO;
                    cell.stateLB.delegate = self;
                    cell.arrowImage.hidden = YES;
                    if(indexPath.row == 1) {
                        cell.titleLB.text = @"条数档位";
                        cell.stateLB.text = [NSString stringWithFormat:@"%@条",self.dataDic[@"vipTime"]];
                    } else if(indexPath.row == 2) {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        cell.selectedBackgroundView = [[UIView alloc] init];
                        cell.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
                        cell.arrowImage.hidden = NO;
                        NSString *invoicing_state = [NSString stringWithFormat:@"%@",self.dataDic[@"invoicing_state"]];
                        if ([invoicing_state integerValue] == 1) {
                            cell.titleLB.text = @"电子发票已开具";
                            cell.stateLB.placeholder = @"点击查看";
                        } else {
                            cell.titleLB.text = @"电子发票未开具";
                            cell.stateLB.placeholder = @"去开具";
                        }
                    } else if(indexPath.row == 3) {
                        cell.stateLB.hidden = YES;
                        cell.titleLB.hidden = YES;
                        cell.arrowImage.hidden = YES;
                        cell.seperator.hidden = YES;
                        UILabel *titleLB = [[UILabel alloc]init];
                        [cell addSubview:titleLB];
                        titleLB.numberOfLines = 0;
                        titleLB.textColor = GRAY200;
                        titleLB.font = [UIFont systemFontOfSize:11];
                        titleLB.text = @"1.如需开具发票，请在订单完成后30天内申请开具\n2.申请开具发票后，我们将在3个工作日内为您开具发票";
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(20);
                            make.right.equalTo(cell.mas_right).offset(-20);
                            make.centerY.equalTo(cell.mas_centerY);
                        }];
                    }
                    return cell;
                }
                    break;
                case 4:
                {
                    buyMe_orderDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderOne"];
                    if (cell == nil) {
                        cell = [[buyMe_orderDetailOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderOne"];
                    }
                    cell.stateLB.enabled = NO;
                    cell.stateLB.delegate = self;
                    cell.arrowImage.hidden = YES;
                    
                    if(indexPath.row == 1+self.mechCount) {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        cell.selectedBackgroundView = [[UIView alloc] init];
                        cell.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
                        cell.arrowImage.hidden = NO;
                        NSString *invoicing_state = [NSString stringWithFormat:@"%@",self.dataDic[@"invoicing_state"]];
                        if ([invoicing_state integerValue] == 1) {
                            cell.titleLB.text = @"电子发票已开具";
                            cell.stateLB.placeholder = @"点击查看";
                        } else {
                            cell.titleLB.text = @"电子发票未开具";
                            cell.stateLB.placeholder = @"去开具";
                        }
                    } else if(indexPath.row == 2+self.mechCount) {
                        cell.stateLB.hidden = YES;
                        cell.titleLB.hidden = YES;
                        cell.arrowImage.hidden = YES;
                        cell.seperator.hidden = YES;
                        UILabel *titleLB = [[UILabel alloc]init];
                        [cell addSubview:titleLB];
                        titleLB.numberOfLines = 0;
                        titleLB.textColor = GRAY200;
                        titleLB.font = [UIFont systemFontOfSize:11];
                        titleLB.text = @"1.如需开具发票，请在订单完成后30天内申请开具\n2.申请开具发票后，我们将在3个工作日内为您开具发票";
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(20);
                            make.right.equalTo(cell.mas_right).offset(-20);
                            make.centerY.equalTo(cell.mas_centerY);
                        }];
                    }  else {
                        if (self.kaoQinArr.count && self.gaoPaiArr.count) {
                            if (indexPath.row == 1) {
                                cell.titleLB.text = @"考勤机";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.kaoQinArr.count];
                            } else {
                                cell.titleLB.text = @"高拍仪";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.gaoPaiArr.count];
                            }
                        } else {
                            if (self.kaoQinArr.count) {
                                cell.titleLB.text = @"考勤机";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.kaoQinArr.count];
                            }
                            if (self.gaoPaiArr.count) {
                                cell.titleLB.text = @"高拍仪";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.gaoPaiArr.count];
                            }
                        }
                    }
                    return cell;
                }
                    break;
                default:
                {
                    buyMe_orderDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderOne"];
                    if (cell == nil) {
                        cell = [[buyMe_orderDetailOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderOne"];
                    }
                    cell.stateLB.enabled = NO;
                    cell.stateLB.delegate = self;
                    cell.arrowImage.hidden = YES;
                    if (indexPath.row == 1) {
                        cell.titleLB.text = @"条数档位";
                        cell.stateLB.text = [NSString stringWithFormat:@"%@条",self.dataDic[@"personSize"]];
                    } else if(indexPath.row == 2) {
                        cell.titleLB.text = @"购买时长";
                        cell.stateLB.text = [NSString stringWithFormat:@"%@个月",self.dataDic[@"vipTime"]];
                    } else if(indexPath.row == 3+self.mechCount) {
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        cell.selectedBackgroundView = [[UIView alloc] init];
                        cell.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
                        cell.arrowImage.hidden = NO;
                        NSString *invoicing_state = [NSString stringWithFormat:@"%@",self.dataDic[@"invoicing_state"]];
                        if ([invoicing_state integerValue] == 1) {
                            cell.titleLB.text = @"电子发票已开具";
                            cell.stateLB.placeholder = @"点击查看";
                        } else {
                            cell.titleLB.text = @"电子发票未开具";
                            cell.stateLB.placeholder = @"去开具";
                        }
                    } else if(indexPath.row == 4+self.mechCount) {
                        cell.stateLB.hidden = YES;
                        cell.titleLB.hidden = YES;
                        cell.arrowImage.hidden = YES;
                        cell.seperator.hidden = YES;
                        UILabel *titleLB = [[UILabel alloc]init];
                        [cell addSubview:titleLB];
                        titleLB.numberOfLines = 0;
                        titleLB.textColor = GRAY200;
                        titleLB.font = [UIFont systemFontOfSize:11];
                        titleLB.text = @"1.如需开具发票，请在订单完成后30天内申请开具\n2.申请开具发票后，我们将在3个工作日内为您开具发票";
                        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(cell.mas_left).offset(20);
                            make.right.equalTo(cell.mas_right).offset(-20);
                            make.centerY.equalTo(cell.mas_centerY);
                        }];
                    }  else {
                        if (self.kaoQinArr.count && self.gaoPaiArr.count) {
                            if (indexPath.row == 3) {
                                cell.titleLB.text = @"考勤机";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.kaoQinArr.count];
                            } else {
                                cell.titleLB.text = @"高拍仪";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.gaoPaiArr.count];
                            }
                        } else {
                            if (self.kaoQinArr.count) {
                                cell.titleLB.text = @"考勤机";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.kaoQinArr.count];
                            }
                            if (self.gaoPaiArr.count) {
                                cell.titleLB.text = @"高拍仪";
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld台",self.gaoPaiArr.count];
                            }
                        }
                    }
                    return cell;
                }
                    break;
            }
            
//            return cell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *invoicing_state = self.dataDic[@"invoicing_state"];
    if (indexPath.section == 1) {
        switch ([self.model.flag integerValue]) {
            case 1:
            {
                if (indexPath.row == 3+self.mechCount) {
                    if (![invoicing_state integerValue]) {
                        [self setBuyMeOrderBillViewWithID:self.model.Id];
                    } else {
                        [self popImageView];
                    }

                }
            }
                break;
            case 2:
            {
                if (indexPath.row == 2) {
                    if (![invoicing_state integerValue]) {
                        [self setBuyMeOrderBillViewWithID:self.model.Id];
                    } else {
                        [self popImageView];
                    }

                }
            }
                break;
            case 3:
            {
                if (indexPath.row == 2) {
                    if (![invoicing_state integerValue]) {
                        [self setBuyMeOrderBillViewWithID:self.model.Id];
                    } else {
                        [self popImageView];
                    }
                }
            }
                break;
            case 4:
            {
                if (indexPath.row == 1+self.mechCount) {
                    if (![invoicing_state integerValue]) {
                        [self setBuyMeOrderBillViewWithID:self.model.Id];
                    } else {
                        [self popImageView];
                    }

                }
            }
                break;
            default:
            {
                if (indexPath.row == 3+self.mechCount) {
                    if (![invoicing_state integerValue]) {
                        [self setBuyMeOrderBillViewWithID:self.model.Id];
                    } else {
                        [self popImageView];
                    }

                }
            }
                break;
        }
    }
}

- (void)setBuyMeOrderBillViewWithID:(NSString *)Id {
    NSString *signText = @"开票须知：\n应国家税务局要求，自2017年7月1日起，开具增值税普通发票，须同时提供企业抬头及税号";
    CGFloat height = [signText heightWithFont:[UIFont systemFontOfSize:10] constrainedToWidth:kScreenWidth-40*KAdaptiveRateWidth] + 20 + 40 + 15 + 75;
    self.orderBillView = [[buyMeOrderBillView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, height) ID:Id type:0];
    __weak typeof(self) weakSelf = self;
    self.orderBillView.submmitBlock = ^{
        weakSelf.orderBillView.bgView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.orderBillView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height);
        }completion:^(BOOL finished) {
            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
            [weakSelf.orderBillView removeFromSuperview];
        }];
    };
    [self.navigationController.view addSubview:self.orderBillView.bgView];
    [self.navigationController.view addSubview:self.orderBillView];
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    self.orderBillView.bgView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.orderBillView.frame = CGRectMake(0, kScreenHeight-height, kScreenWidth, height);
        
    }];

}
- (void)popImageView {
    
    HXPhotoPreviewViewController *vc = [[HXPhotoPreviewViewController alloc] init];
    vc.selectedComplete = YES;
    vc.modelList = self.dataList;
    vc.webImageCount = 1;
    vc.index = 0;
    vc.manager = nil;
    [self presentViewController:vc animated:YES completion:nil];
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
