//
//  UpgradeViewController.m
//  Financeteam
//
//  Created by Zccf on 16/6/23.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "UpgradeViewController.h"
#import "UpgradeTableViewCell.h"
#import "ContactModel.h"
#import "ChoosePeopleViewController.h"
#import "chooseViewController.h"
@interface UpgradeViewController ()<UITableViewDelegate,UITableViewDataSource,JKAlertViewDelegate>{
    LoginPeopleModel *myModel;
    
}
@property (nonatomic,strong) UITableView *UpgradeTableView;
@property (nonatomic) NSMutableArray *UpgradeListDataArr;//接收服务器穿回的数据
@property (nonatomic, strong) NSString *isRefreshUpgrade;
@property (nonatomic, strong) NSMutableArray *returnPeople;

@property (nonatomic, strong) NSIndexPath * indexData;
@end

@implementation UpgradeViewController
static NSString *PeopleName;
static NSString *PeopleID;
- (UITableView *)UpgradeTableView {
    if (!_UpgradeTableView) {
        _UpgradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _UpgradeTableView.delegate = self;
        _UpgradeTableView.dataSource = self;
    
        [_UpgradeTableView registerClass:[UpgradeTableViewCell class] forCellReuseIdentifier:@"cell"];
        _UpgradeTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestDataWithMid:[NSString stringWithFormat:@"%ld",myModel.jrqMechanismId]];
        }];
    }
    return _UpgradeTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.isRefreshUpgrade isEqualToString:@"1"]) {
        [self.UpgradeTableView.header beginRefreshing];
    }
    PeopleID = @"";
    if (self.returnPeople.count != 0) {
        
        ContactModel *model = self.returnPeople[0];
        PeopleName = model.realName;
        PeopleID = [NSString stringWithFormat:@"%ld",model.userId];
        NSString *title = [NSString stringWithFormat:@"确认要提升%@的等级吗?",PeopleName];
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"温馨提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1000;
        [alert show];
    }
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self addUpgradePersonWithUid:PeopleID];
        }
    }else if (alertView.tag == 2000){
        if (buttonIndex == 1) {
            
        ContactModel *model = self.UpgradeListDataArr[self.indexData.row];
        NSString *uid = [NSString stringWithFormat:@"%ld",model.userId];
        NSString *mechanId = [NSString stringWithFormat:@"%ld",myModel.jrqMechanismId];
        [self removeUpgradeWithUid:uid mechanId:mechanId];
        [self.UpgradeListDataArr removeObjectAtIndex:self.indexData.row];
        [self.UpgradeTableView reloadData];
            
        }
    }
        
    
    [self.returnPeople removeAllObjects];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.returnPeople = [NSMutableArray array];
    self.navigationItem.title = @"人员列表";
    myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAdd)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.UpgradeListDataArr = [NSMutableArray array];
    [self initUIs];
    // Do any additional setup after loading the view.
}
- (void)viewDidDisappear:(BOOL)animated {
    [self.returnPeople removeAllObjects];
}
- (void)initUIs {
    [self.view addSubview:self.UpgradeTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.UpgradeTableView setTableFooterView:view];
    [self requestDataWithMid:[NSString stringWithFormat:@"%ld",myModel.jrqMechanismId]];
}
- (void)requestDataWithMid:(NSString *)mid {
    
    [self.UpgradeListDataArr removeAllObjects];
    [HttpRequestEngine getUpgradePersonListWithMid:mid completion:^(id obj, NSString *errorStr) {
        
        NSDictionary *data = obj;
        if (data) {
            NSArray *all = data[@"allList"];
            NSDictionary *dic = data[@"CJRMap"];
            ContactModel *model = [ContactModel requestWithDic:dic];
            [self.UpgradeListDataArr addObject:model];
            for (int i=0; i<all.count; i++) {
                NSDictionary *dic = all[i];
                NSLog(@"dic == %@",dic);
                ContactModel *model = [ContactModel requestWithDic:dic];
                [self.UpgradeListDataArr addObject:model];
            }
            NSLog(@"dic == %@",dic);
            [self.UpgradeTableView.header endRefreshing];
            [self.UpgradeTableView reloadData];
        } else {
            [MBProgressHUD showError:@"网络错误"];
        }
        
    }];
    
}
- (void)ClickAdd {
    if (self.isEditUpgrade) {
        chooseViewController *choosePeople = [chooseViewController new];
        choosePeople.seType = 1;
        choosePeople.limited = 1;
        choosePeople.limitArr = self.UpgradeListDataArr;
        [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
            [self.returnPeople addObjectsFromArray:returnMutableArray];
        }];
        [self.navigationController pushViewController:choosePeople animated:YES];
    } else {
        [MBProgressHUD showError:@"暂无此权限"];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60*KAdaptiveRateWidth;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.UpgradeListDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpgradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UpgradeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    ContactModel *model = self.UpgradeListDataArr[indexPath.row];
    NSString *iconURl = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,model.iconUrl];
    
    NSURL *icon = [NSURL URLWithString:iconURl];
    [cell.headerImage sd_setImageWithURL:icon placeholderImage:[UIImage imageNamed:@"聊天头像"]];
    cell.nameLB.text = model.realName;
    if (indexPath.row == 0) {
        cell.signLB.text = @"创建人";
    } else {
        cell.signLB.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDeleteUpgrade) {
        if (indexPath.row != 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        
        return NO;
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    }
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
        self.indexData = indexPath;
        
         ContactModel *model = self.UpgradeListDataArr[indexPath.row];
        
        NSString * message = [NSString stringWithFormat:@"确定要删除%@的等级吗？",model.realName];
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2000;
        [alert show];
     
    }
}
#pragma mark -- 删除人员
- (void)removeUpgradeWithUid:(NSString *)uid mechanId:(NSString *)mechanId{
    
    [HttpRequestEngine removeUpgradePersonWithUid:uid mechanId:mechanId completion:^(id obj, NSString *errorStr) {
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
        [self.UpgradeTableView.header beginRefreshing];
    }];
}
#pragma mark -- 新增等级提升人员
- (void)addUpgradePersonWithUid:(NSString *)uid {
    [HttpRequestEngine addUpgradePersonWithUid:uid completion:^(id obj, NSString *errorStr) {
        NSDictionary *data = obj;
        NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
        if ([code isEqualToString:@"1"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
        } else {
            [MBProgressHUD showSuccess:@"操作成功"];
            
        }
        if (data == nil) {
            [MBProgressHUD showError:@"网络错误"];
        }
        [self.UpgradeTableView.header beginRefreshing];
    }];
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
