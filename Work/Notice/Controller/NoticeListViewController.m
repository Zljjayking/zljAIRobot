//
//  NoticeListViewController.m
//  Financeteam
//
//  Created by Zccf on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeListTableViewCell.h"
#import "NoticeDetailsViewController.h"
#import "NoticeListModel.h"
@interface NoticeListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    LoginPeopleModel *myModel;
    
}
@property (nonatomic,strong) UITableView *NoticeTableView;
@property (nonatomic) NSMutableArray *NoticeListDataArr;//接收服务器穿回的数据
@property (nonatomic, strong) NSString *isRefreshNotice;
@end

@implementation NoticeListViewController
- (UITableView *)NoticeTableView {
    if (!_NoticeTableView) {
        _NoticeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        if (self.ishideNaviView) {
            _NoticeTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight);
        }
        _NoticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _NoticeTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.isRefreshNotice isEqualToString:@"1"]) {
        [self.NoticeTableView.header beginRefreshing];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公告";
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAdd)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.NoticeListDataArr = [NSMutableArray array];
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-0, 80, 80) imageName:@"noData" title:@"暂无公告信息!"];
    [self.NoticeTableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    [self initUIs];
    // Do any additional setup after loading the view.
}
//初始化页面
- (void)initUIs {
    myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    self.NoticeTableView.delegate = self;
    self.NoticeTableView.dataSource = self;
    
    [self.NoticeTableView registerClass:[NoticeListTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.NoticeTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"inter"] = @"selBulletin";
        dic[@"uid"] = [NSString stringWithFormat:@"%ld",myModel.userId];
        [self requestForNoticeListData:dic];
    }];
    [self.view addSubview:self.NoticeTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.NoticeTableView setTableFooterView:view];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"inter"] = @"selBulletin";
    dic[@"uid"] = [NSString stringWithFormat:@"%ld",myModel.userId];
    [self requestForNoticeListData:dic];
}
//请求列表数据
- (void)requestForNoticeListData:(NSDictionary *)dic {
    [self.NoticeListDataArr removeAllObjects];
    [HttpRequestEngine requestForNotice:dic completion:^(id obj, NSString *errorStr) {
        if (errorStr == nil) {
            if ([(NSMutableArray *)obj count]>0) {
                self.NoticeListDataArr = obj;
                [self.NoticeTableView.header endRefreshing];
                [MBProgressHUD hideHUD];
                self.blankV.hidden = YES;
            }else{
                [self.NoticeListDataArr removeAllObjects];
                [self.NoticeTableView.header endRefreshing];
                [MBProgressHUD hideHUD];
                self.blankV.hidden = NO;
            }
            [self.NoticeTableView reloadData];
        } else {
            [MBProgressHUD showError:errorStr];
            self.blankV.hidden = NO;
        }
        
        
        [self.NoticeTableView reloadData];
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.NoticeListDataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    view.backgroundColor = VIEW_BASE_COLOR;
    if (section != 0) {
        view.frame = CGRectMake(0, 0, kScreenWidth, 10);
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*KAdaptiveRateHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NoticeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NoticeListModel *model = self.NoticeListDataArr[indexPath.section];
    cell.NameLb.text = model.nameStr;
    cell.SignLb.text = model.signStr;
    cell.TimeLb.text = model.timeStr;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoticeListModel *model = self.NoticeListDataArr[indexPath.section];
    NoticeDetailsViewController *noticeDetails = [NoticeDetailsViewController new];
    if (self.ishideNaviView) {
        noticeDetails.ishideNaviView = 1;
    }
    noticeDetails.isUpdateNotice = self.isUpdateNotice;
    noticeDetails.setype = 1;
    [noticeDetails returnIsRefreshNotice:^(NSString *returnIsRefrshNotice) {
        self.isRefreshNotice = returnIsRefrshNotice;
    }];
    noticeDetails.bid = model.ID;
    [self.navigationController pushViewController:noticeDetails animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDeleteNotice) {
        return YES;
    } else {
        
        return NO;
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

        /*此处处理自己的代码，如删除数据*/
        NoticeListModel *model = self.NoticeListDataArr[indexPath.section];
        NSString *bid = [NSString stringWithFormat:@"%@",model.ID];
        [self removeNoticeWithBid:bid];
        [self.NoticeListDataArr removeObjectAtIndex:indexPath.section];
        [self.NoticeTableView reloadData];
        /*删除tableView中的一行*/
    }
}
#pragma mark -- 删除公告
- (void)removeNoticeWithBid:(NSString *)bid {
    [HttpRequestEngine removeNoticeWithBid:bid completion:^(id obj, NSString *errorStr) {
        NSDictionary *data = obj;
        NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
        if ([code isEqualToString:@"1"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
        } else {
            [MBProgressHUD showSuccess:@"删除成功"];
            
        }
        if (data == nil) {
            [MBProgressHUD showError:@"网络错误"];
        }
        [self.NoticeTableView.header beginRefreshing];
    }];
}
#pragma mark -- 点击事件
//点击导航栏右侧加号的事件
- (void)ClickAdd {
    if (self.isAddnotice) {
        NoticeDetailsViewController *noticeDetails = [NoticeDetailsViewController new];
        if (self.ishideNaviView) {
            noticeDetails.ishideNaviView = 1;
        }
        noticeDetails.setype = 2;
        [noticeDetails returnIsRefreshNotice:^(NSString *returnIsRefrshNotice) {
            self.isRefreshNotice = returnIsRefrshNotice;
        }];
        [self.navigationController pushViewController:noticeDetails animated:YES];
    } else {
        [MBProgressHUD showError:@"暂无此权限"];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    self.isRefreshNotice = @"0";
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
