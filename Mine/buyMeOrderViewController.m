//
//  buyMeOrderViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/8/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "buyMeOrderViewController.h"
#import "buyMeOrderTableViewCell.h"
#import "buyMeOrderModel.h"
#import "buyMeOrderDetailViewController.h"
@interface buyMeOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *orderListTableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *orderDic;
@property (nonatomic, strong) NSMutableArray *dataMutableArr;
@property (nonatomic, strong) NSMutableArray *allBillKeysArray;
@end

@implementation buyMeOrderViewController
- (UITableView *)orderListTableView {
    if (!_orderListTableView) {
        _orderListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        _orderListTableView.delegate = self;
        _orderListTableView.dataSource = self;
        _orderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderListTableView.tableFooterView = [UIView new];
        [_orderListTableView registerClass:[buyMeOrderTableViewCell class] forCellReuseIdentifier:@"bill"];
        _orderListTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            _orderDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [self getOrderList];
        }];
    }
    return _orderListTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买记录";
    self.page = 0;
    self.allBillKeysArray = [NSMutableArray arrayWithCapacity:0];
    self.dataMutableArr = [NSMutableArray arrayWithCapacity:0];
    self.orderDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [self.view addSubview:self.orderListTableView];
    [self getOrderList];
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.orderListTableView.center.y/2.0+20, 90, 90) imageName:@"noData" title:@"暂无购买记录"];
    [self.orderListTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    // Do any additional setup after loading the view.
}
- (void)getOrderList {
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    [HttpRequestEngine getBuyMeOrderWithMech_id:self.myMech_Id page:page Completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            NSArray *arr = [NSArray arrayWithArray:obj];
            NSMutableArray *mutableArr = [NSMutableArray array];
            if (arr.count) {
                for (NSDictionary *dic in arr) {
                    buyMeOrderModel *bill = [buyMeOrderModel requestWithDic:dic];
                    if ([bill.state isEqualToString:@"0"]) {
                        [self.dataMutableArr addObject:bill];
                        [mutableArr addObject:bill];
                    }
                }
                [self.orderListTableView.footer endRefreshing];
                if (arr.count < 10) {
                    [self.orderListTableView.footer noticeNoMoreData];
                }
                self.blankV.hidden = YES;
//                [self prepareBillListDatasourceWithArray:self.dataMutableArr andToDictionary:self.orderDic];
                
            } else {
                [self.orderListTableView.footer endRefreshing];
                [self.orderListTableView.footer noticeNoMoreData];
                if (self.page == 0) {
                    self.blankV.hidden = NO;
                }
            }
            [self.orderListTableView reloadData];
        } else {
            [self.orderListTableView.footer endRefreshing];
            [MBProgressHUD showError:errorStr];
        }

    }];
}
#pragma mark-排序billList
- (void)prepareBillListDatasourceWithArray:(NSArray *)array andToDictionary:(NSMutableDictionary *)dic
{
    for (buyMeOrderModel *model in array) {
        
        
        NSString *yearAndMonth = [model.createTime substringWithRange:NSMakeRange(0, 7)];
        if (![dic objectForKey:yearAndMonth]) {
            NSMutableArray *arr = [NSMutableArray array];
            [dic setObject:arr forKey:yearAndMonth];
            
        }
        if ([[dic objectForKey:yearAndMonth] containsObject:model]) {
            return;
        }
        [[dic objectForKey:yearAndMonth] addObject:model];
    }
    [self.allBillKeysArray removeAllObjects];
    [self.allBillKeysArray addObjectsFromArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    self.allBillKeysArray =  (NSMutableArray *)[[self.allBillKeysArray reverseObjectEnumerator] allObjects];
    [self.orderListTableView reloadData];
    if (self.allBillKeysArray.count == 0) {
        self.blankV.hidden = NO;
    } else {
        self.blankV.hidden = YES;
    }
    
}

- (void)setupView {
    [self.view addSubview:self.orderListTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *arr = [self.orderDic objectForKey:self.allBillKeysArray[section]];
    return self.dataMutableArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    buyMeOrderModel *model = self.dataMutableArr[indexPath.row];
    buyMeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bill"];
    if (cell == nil) {
        cell = [[buyMeOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
    }
    
    NSString *str = [NSString stringWithFormat:@"购买时长:%@个月",model.vipTime];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttributes:@{NSForegroundColorAttributeName:customBlue,
                            NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(5, [model.vipTime length])];//添加属性
//    [attStr addAttributes:@{NSForegroundColorAttributeName:GRAY180,
//                            NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, 7)];//添加属性
    
//    cell.createTimeLB.attributedText = attStr;
    
    cell.moneyLB.text = [Utils stringToMoneyWithValue:[model.money doubleValue]];
    
    cell.timeLB.text = model.createTime;
    
    cell.stateLB.text = [NSString stringWithFormat:@"订单号:%@",model.orderNo];
    switch ([model.flag integerValue]) {
        case 1:
        {
            cell.createTimeLB.text = @"初始支付";
        }
            break;
        case 2:
        {
            cell.createTimeLB.text = @"时间扩容";
        }
            break;
            
        case 3:
        {
            cell.createTimeLB.text = @"条数扩容";
        }
            break;
        case 4:
        {
            cell.createTimeLB.text = @"购买设备";
        }
            break;
        default:
        {
            cell.createTimeLB.text = @"未知状态";
        }
            break;
    }
    cell.createTimeLB.text = [NSString stringWithFormat:@"购买%@条智能客服线路",model.personSize];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    buyMeOrderModel *model = self.dataMutableArr[indexPath.row];
    buyMeOrderDetailViewController *detailVC = [buyMeOrderDetailViewController new];
    detailVC.ID = model.Id;
    detailVC.model = model;
//    [self.navigationController pushViewController:detailVC animated:YES];
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
