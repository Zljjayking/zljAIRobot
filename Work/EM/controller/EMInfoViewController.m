//
//  EMInfoViewController.m
//  Financeteam
//
//  Created by Zccf on 17/4/20.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "EMInfoViewController.h"
#import "employeeModel.h"
#import "employeeTableViewCell.h"
#import "EMInfoDetailViewController.h"
@interface EMInfoViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic) LoginPeopleModel *loginModel;
@property (nonatomic) NSString *searchName;
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation EMInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.tableView.contentInset = UIEdgeInsetsMake(imageH, 0, 0, 0);
#ifdef __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
//    if (iOS11Later) {
//        self.tableView.contentInset = UIEdgeInsetsMake(imageH-64, 0, 0, 0);
//    }
    [self.tableView registerClass:[employeeTableViewCell class] forCellReuseIdentifier:@"employee"];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page = self.page+1;
        [self requestData];
    }];
    
    //[self.view addSubview:self.employeeTableView];
    
    self.dataArr = [NSMutableArray array];
    self.page = 0;
    self.headerImage.image = [UIImage imageNamed:@"emImageThree"];
    
    self.isSearch = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
    
    self.blankV = [[blankView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-40, self.view.center.y/2.0-40, 80, 80) imageName:@"noData" title:@"暂无员工数据"];
    [self.tableView addSubview:self.blankV];
    self.blankV.hidden = YES;
    
    [self settitleView];
    
    [self requestData];
    
    __weak typeof (self) weakSelf = self;
    self.refBlock = ^(){
        
        weakSelf.page = 0;
        [weakSelf requestData];
    };
    // Do any additional setup after loading the view.
}
- (void)settitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 35)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 0, 250, 35);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 18;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:8];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    
    searchBar.placeholder = @"|搜索员工姓名或手机号码";
    [titleView addSubview:searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}
- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestData {
    
    NSString *page = [NSString stringWithFormat:@"%ld",self.page];
    int mechId = (int)self.loginModel.jrqMechanismId ;
    [HttpRequestEngine getEmployeeWithSearchName:self.searchName page:page mechId:mechId completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *dataArr = (NSArray *)obj;
            if (dataArr.count == 0 && self.page == 0) {
                [self.dataArr removeAllObjects];
                [self.tableView reloadData];
                self.blankV.hidden = NO;
                [self.tableView reloadData];
            } else {
                self.blankV.hidden = YES;
                if (self.page == 0) {
                    [self.dataArr removeAllObjects];
                }
                for (NSDictionary *data in dataArr) {
                    employeeModel *model = [employeeModel requestWithDic:data];
                    [self.dataArr addObject:model];
                }
                
                [self.tableView.footer endRefreshing];
                
                if (dataArr.count < 10) {
                    [self.tableView.footer noticeNoMoreData];
                }
                [self.tableView reloadData];
                
            }
            [MBProgressHUD hideHUD];
        } else {
            if (self.page == 0) {
                [self.dataArr removeAllObjects];
                [self.tableView reloadData];
                self.blankV.hidden = NO;
            }
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataArr.count - 1) {
        return 0.1;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    if (section == self.dataArr.count - 1) {
        view.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }
    view.backgroundColor = VIEW_BASE_COLOR;
    return view;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (employeeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID1 = @"employee";
    employeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
    if (!cell) {
        cell = [[employeeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
    }
    
    employeeModel *model = self.dataArr[indexPath.section];
    
    [cell.headImage sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    cell.nameLb.text = model.real_name;
    
    cell.mobileLb.text = model.mobile;
    
    if ([model.sex isEqualToString:@"2"]) {
        cell.sexImage.image = [UIImage imageNamed:@"性别女"];
    } else {
        cell.sexImage.image = [UIImage imageNamed:@"男"];
    }
    
    if ([model.dataFlag isEqualToString:@"0"]) {
        cell.signImage.image = [UIImage imageNamed:@"未完善"];
    } else if ([model.dataFlag isEqualToString:@"1"]) {
        cell.signImage.image = [UIImage imageNamed:@"已完善"];
    } else {
        cell.signImage.image = [UIImage imageNamed:@"未完善"];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    employeeModel *model = self.dataArr[indexPath.section];
    EMInfoDetailViewController *infoDetail = [[EMInfoDetailViewController alloc] init];
    infoDetail.userId = model.userId;
    infoDetail.block = ^(){
        self.page = 0;
        [self requestData];
    };
    [self.navigationController pushViewController:infoDetail animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    /**
     if (self.isSearch) {
     if (searchText.length == 0) {
     self.page = 0;
     self.searchName = @"";
     [self requestData];
     }
     }
     */
    self.page = 0;
    self.isSearch = 1;
    self.searchName = searchBar.text;
    [self requestData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
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
