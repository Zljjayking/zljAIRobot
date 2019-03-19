//
//  RetailSaleViewController.m
//  Financeteam
//
//  Created by Zccf on 16/8/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "RetailSaleViewController.h"

#import "DialViewController.h"

#import "RSTopView.h"
#import "JXAddressBook.h"
#import "PersonCell.h"
#import "RecordTableViewCell.h"
#import "PersonTableViewCell.h"
#import "PersonModel.h"
#import "DetailViewController.h"
#import "UpgradeTableViewCell.h"
@interface RetailSaleViewController ()<UITableViewDataSource,UIActionSheetDelegate,UITableViewDelegate,UIScrollViewDelegate,RSTopViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating>{
#pragma mark -- 更改的
//    NSArray *_dataArray;
    
    UIView * _lineView;

}
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic) NSInteger callCount;//自动拨号到第几个了。
@property (nonatomic, strong) NSUserDefaults *userDefaults;


@property (nonatomic, strong) UIButton * startBtn;
@property(nonatomic,strong)UIScrollView * mainScrollView;

@property(nonatomic,strong)RSTopView * rsTopView;

@property(nonatomic,strong)   NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSArray *searchList;

@property (strong,nonatomic) UITableView *tableView;

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *recordArr;//查询到的通话记录号码
@property (nonatomic, strong) NSMutableArray *dateArr;//查询到的日期
@property (nonatomic, strong) NSMutableArray *nameArr;//查询到的姓名
@property (nonatomic, strong) NSMutableArray *selectDate;//用于排序
@property (nonatomic, strong) NSString *record;//查询到的纪录
@property (nonatomic) NSInteger clickRow;
@property (nonatomic, strong) UITableView *recordTableView;
@end

@implementation RetailSaleViewController
#pragma mark -- 更改的
//- (void)refreshPersonInfoTableView
//{
//    [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 对获取数据进行排序
//            _dataArray = [JXAddressBook sortPersonInfos:personInfos];
//            [_tableView reloadData];
//        });
//    }];
//}
- (void)refreshPersonInfoTableView {
    
    for (int i=0; i<2; i++) {
        PersonModel *person = [PersonModel new];
        person.phoneStr = [NSString stringWithFormat:@"15715144521"];
        person.nameStr = [NSString stringWithFormat:@"hhhh%d",i];
        person.callStateStr = @"3";
        [self.dataArray addObject:person];
    }
    NSLog(@"self.dataArray.count == %ld",self.dataArray.count);
    [self.tableView reloadData];
}
- (void)refreshSearchTableView:(NSString *)searchText
{
    [JXAddressBook searchPersonInfo:searchText addressBookBlock:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 直接获取数据
            self.searchList = personInfos;
            [self.tableView reloadData];
        });
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self creatDataBase];
}
- (void)createSearchBar
{
 
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
//    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.tintColor = TABBAR_BASE_COLOR;
    
    _searchController.searchBar.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 40);
    //    [self.view addSubview: _searchController.searchResultsController.view];
    // 添加 searchbar 到 headerview
    [self.mainScrollView addSubview: _searchController.searchBar];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"array==%@",self.excelArray);
    
    self.navigationItem.title = @"电销";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    self.dataArray = [NSMutableArray array];
    self.recordArr = [NSMutableArray array];
    self.selectDate = [NSMutableArray array];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.db = [FMDatabase databaseWithPath:dataBasePath];
    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    _lineView.hidden = YES;
    
    //初始化self.callCount
    NSString *callCount = [self.userDefaults objectForKey:@"callCount"];
    if (callCount.length == 0 || [callCount isEqualToString:@""] || callCount == nil || callCount == NULL || [callCount isEqual:[NSNull null]]) {
        self.callCount = 1;
    } else {
        self.callCount = [[self.userDefaults objectForKey:@"callCount"] integerValue];
    }
    NSLog(@"callCount == %@",callCount);
    NSLog(@"self.callCount == %ld",self.callCount);
    
    [self creatUI];
    [self createContactDB];//创建联系人数据库表
    if (self.testStr.length > 0) {
        [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth * 1, 0) animated:YES];
        [self.rsTopView resetBtnStatus:1+100];
    }
    
}
//创建数据库
- (void)creatDataBase {
    
    if ([self.db open]) {
        //phoneNumber 通话记录号码  date 拨号日期   isConnect 是否接通  time 接通时长
        BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS CallRecords (phoneNumber text, date text,name text)"];
        
        if (!result) {
            NSLog(@"fail to create table");
        }else {
            NSLog(@"create table success");
        }
    }else{
        NSLog(@"fail to open");
    }
    [self.db close];
    if ([self.db open]) {
        [self.recordArr removeAllObjects];
        [self.selectDate removeAllObjects];
        FMResultSet *resultSet = [self.db executeQuery:@"select * from CallRecords"];
        while ([resultSet next]) {
            
            NSString *phoneNumber = [resultSet objectForColumnName:@"phoneNumber"];
            
            
            NSString *dateStr = [resultSet objectForColumnName:@"date"];
            
            
            NSString *nameStr = [resultSet objectForColumnName:@"name"];
            
            
            PersonModel *personModel = [PersonModel new];
            personModel.nameStr = nameStr;
            personModel.phoneStr = phoneNumber;
            personModel.dateStr = dateStr;
            [self.recordArr addObject:personModel];
        }
    }
    [self.db close];
    
    
    NSString *k;
    PersonModel *model = [PersonModel new];
    for (PersonModel *model in self.recordArr) {
        NSString *dateStr = [model.dateStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@":" withString:@""];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"年" withString:@""];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@""];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"日" withString:@""];
        [self.selectDate addObject:dateStr];
    }
    //按时间排序
    for (int i=0; i<self.selectDate.count; i++) {
        for (int j=0; j<self.selectDate.count-1-i; j++) {
            if ([self.selectDate[j] integerValue] > [self.selectDate[j+1] integerValue]) {
                k = self.selectDate[j];
                model = self.recordArr[j];
                
                self.selectDate[j] = self.selectDate[j+1];
                self.selectDate[j+1] = k;
                
                self.recordArr[j] = self.recordArr[j+1];
                self.recordArr[j+1] = model;
            }
        }
    }
    self.recordArr = (NSMutableArray *)[[self.recordArr reverseObjectEnumerator] allObjects];
    [self.recordTableView reloadData];
}
- (void)createContactDB {
    if ([self.db open]) {
        //phoneNumber 通话记录号码  date 拨号日期   isConnect 是否接通  time 接通时长
        BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS Contacts (name text, phoneNumber text,state text)"];
        
        if (!result) {
            NSLog(@"fail to create table");
        }else {
            NSLog(@"create table success");
        }
    }else{
        NSLog(@"fail to open");
    }
    [self.db close];
//    NSLog(@"self.excelArray.count == %ld",self.excelArray.count);
//    if (self.excelArray.count > 0) {
//        if ([self.db open]) {
//            BOOL success =  [_db executeUpdate:@"DELETE FROM Contacts"];
//            if (success) {
//                NSLog(@"删除数据成功");
//            }else{
//                NSLog(@"删除数据失败");
//            }
//        }
//        [self.db close];
//        for (int i = 0; i<self.excelArray.count; i++) {
//            NSString *phoneNum = [NSString stringWithFormat:@"%@",self.excelArray[i]];
//            if ([self.db open]) {
//                BOOL insert = [self.db executeUpdate:@"INSERT INTO Contacts(name,phoneNumber,state) VALUES(?,?,?)",@"",phoneNum,@"3"];
//                if (insert) {
//                    NSLog(@"插入数据成功");
//                }else{
//                    NSLog(@"插入数据失败");
//                }
//            }
//            [self.db close];
//        }
//    }
    
    if ([self.db open]) {
        [self.dataArray removeAllObjects];
        //        [self.selectDate removeAllObjects];
        FMResultSet *resultSet = [self.db executeQuery:@"select * from Contacts"];
        while ([resultSet next]) {
            
            NSString *phoneNumber = [resultSet objectForColumnName:@"phoneNumber"];
            
            
            NSString *stateStr = [resultSet objectForColumnName:@"state"];
            
            
            NSString *nameStr = [resultSet objectForColumnName:@"name"];
            
            
            PersonModel *personModel = [PersonModel new];
            personModel.nameStr = nameStr;
            personModel.phoneStr = phoneNumber;
            personModel.callStateStr = stateStr;
            [self.dataArray addObject:personModel];
        }
    }
    [self.tableView reloadData];
    [self.db close];

}

-(void)creatUI{
    
    self.rsTopView = [[RSTopView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 36)];
    self.rsTopView.titleArray = @[@"拨号记录",@"联系人"];
    self.rsTopView.delegate = self;
    [self.view addSubview:self.rsTopView];
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenHeight-100)];
    _mainScrollView.pagingEnabled = YES;
    //设置内容视图的大小
    _mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, 0);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    [self addChildView];
}
//添加子视图
-(void)addChildView{
    
    self.recordTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.recordTableView.frame = CGRectMake(0, 0, kScreenWidth, _mainScrollView.frame.size.height);
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    [self.recordTableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"record"];
    UIView *record = [UIView new];
    record.backgroundColor = [UIColor clearColor];
    [self.recordTableView setTableFooterView:record];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, _mainScrollView.frame.size.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
    UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:@"PersonCell"];
    [self.tableView registerClass:[UpgradeTableViewCell class] forCellReuseIdentifier:@"import"];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self.mainScrollView addSubview:self.tableView];
    [self.mainScrollView addSubview:self.recordTableView];
    
//    [self createSearchBar];
//    [self refreshPersonInfoTableView];
    
    UIButton * bohaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bohaoBtn.frame = CGRectMake((self.mainScrollView.frame.size.width/2.0-30), self.mainScrollView.frame.size.height-70, 60, 60);
    [bohaoBtn setBackgroundImage:[UIImage imageNamed:@"拨号盘"] forState:UIControlStateNormal];
    [bohaoBtn addTarget:self action:@selector(bohaoOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:bohaoBtn];

    self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startBtn.frame = CGRectMake((self.mainScrollView.frame.size.width+self.mainScrollView.frame.size.width/2.0-30), self.mainScrollView.frame.size.height-70, 60, 60);
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"开始"] forState:UIControlStateNormal];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [self.startBtn addTarget:self action:@selector(startOrStopClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:self.startBtn];
}
//拨号按钮点击事件
-(void)bohaoOnClick:(UIButton *)sender{
    
    
    DialViewController * dialVC = [[DialViewController alloc]init];
    
    dialVC.view.backgroundColor = [UIColor colorWithRed:61/255.0 green:60/255.0 blue:65/255.0 alpha:1.0];
    
    [self presentViewController:dialVC animated:YES completion:nil];
    
}
- (void)startOrStopClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (self.callCount == 1) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"是否开始自动拨号?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
            action.tag = 100;
            [action showInView:self.view];
        } else {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"请选择自动拨号方式?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从上次结束时开始",@"从头开始", nil];
            action.tag = 101;
            [action showInView:self.view];
        }
        
    } else {
        [self stopCall];
    }
}
//开始自动拨打
- (void)startCall {
    if (self.callCount > 0 && self.callCount<=self.dataArray.count) {
        PersonModel *personInfo = _dataArray[self.callCount-1];
        [self clickPerson:personInfo index:(self.callCount-1)];
    } else {
        [MBProgressHUD showSuccess:@"已拨打完毕"];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startCall) object:nil];
        self.startBtn.selected = NO;
    }
}
//暂停自动拨打
- (void)stopCall {
    [MBProgressHUD showSuccess:@"暂停拨号"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startCall) object:nil];
}
//分页按钮点击事件
-(void)clickButton:(NSInteger)page{
    
    [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth *page, 0) animated:YES];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.mainScrollView) {
        //contentOffset 偏移量
        NSInteger  page = scrollView.contentOffset.x/kScreenWidth;
        [self.rsTopView resetBtnStatus:page+100];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
     self.searchController.active = NO;
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.recordTableView) {
        return 1;
    } else {
//        if (self.searchController.active) {
//            return 1;
//        } else {
#pragma mark -- 更改的
////            return _dataArray.count;
//            return 1;
//        }
        return 2;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.recordTableView) {
        return nil;
    } else {
//        if (self.searchController.active) {
//            return @"";
//        } else {
//            return JXSpellFromIndex((int)section);
//        }
#pragma mark -- 更改的
        return nil;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.recordTableView) {
        return self.recordArr.count;
    } else {
//        if (self.searchController.active) {
//            return self.searchList.count;
//        } else {
#pragma mark -- 更改的
//            return ((NSArray *)[_dataArray objectAtIndex:section]).count;
//            return self.dataArray.count;
//        }
        if (section == 0) {
            return 1;
        } else {
            return self.dataArray.count;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer = @"PersonCell";
    static NSString *identifier = @"record";
    if (tableView == self.recordTableView) {
        RecordTableViewCell *recordcell=(RecordTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if(recordcell==nil)
        {
            recordcell=[[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        PersonModel *personModel = self.recordArr[indexPath.row];
        [recordcell setData:personModel];
        NSString *nameStr = [personModel.nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (nameStr.length == 0) {
            recordcell.txImage.hidden = NO;

        } else {
            recordcell.txImage.hidden = YES;

        }
        return recordcell;
    } else {
#pragma mark -- 更改的
//        PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
//        if(personcell==nil)
//        {
//            personcell=[[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
//        }
//        JXPersonInfo *personInfo = nil;
//        
//        if (self.searchController.active) {
//            
//            if (self.searchList.count > 0) {
//                personInfo = [self.searchList objectAtIndex:indexPath.row];
//                [personcell setData:personInfo];
//                
//            }
//        }else {
//            NSArray *subArr = [_dataArray objectAtIndex:indexPath.section];
//            personInfo = [subArr objectAtIndex:indexPath.row];
//            [personcell setData:personInfo];
//            
//        }
//        if (personInfo.fullName.length == 0) {
//            personcell.txImage.hidden = NO;
//        } else {
//            personcell.txImage.hidden = YES;
//        }
//        return personcell;
        
        
        if (indexPath.section == 0) {
            //import
            UpgradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"import"];
            if (cell == nil) {
                cell = [[UpgradeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"import"];
            }
            cell.headerImage.image = [UIImage imageNamed:@"导入"];
            cell.nameLB.text = @"导入Excel表格";
            cell.nameLB.font = [UIFont systemFontOfSize:15];
            cell.signLB.hidden = YES;
            return cell;
        } else {
            PersonTableViewCell *recordcell=(PersonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
            if(recordcell==nil)
            {
                recordcell=[[PersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
            }
            PersonModel *personModel = self.dataArray[indexPath.row];
            [recordcell setData:personModel];
            NSString *nameStr = [personModel.nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (nameStr.length == 0) {
                recordcell.txImage.hidden = NO;
            } else {
                recordcell.txImage.hidden = YES;
            }
            return recordcell;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.recordTableView) {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打此号码",@"删除此条",@"全部删除", nil];
        action.tag = 102;
        self.clickRow = indexPath.row;
        [action showInView:self.navigationController.view];
    } else {
        if (indexPath.section == 0) {
            
        } else {
            PersonModel *personInfo = [_dataArray objectAtIndex:indexPath.row];
            //点击联系人事件
            [self clickPerson:personInfo index:-1];
        }
        
    }
    
}
//点击了联系人列表
- (void)clickPerson:(PersonModel *)personInfo index:(NSInteger)index{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSString *dateStr=[dateformatter stringFromDate:senddate];
    
//    NSString *phoneStr = [[personInfo.phone[0] allObjects][0] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *phoneStr = [personInfo.phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (phoneStr.length != 0) {
        if ([self.db open]) {
            FMResultSet *resultSet = [self.db executeQuery:@"select * from CallRecords where phoneNumber=?",phoneStr];
            while ([resultSet next]){
                self.record = [resultSet objectForColumnName:@"phoneNumber"];
            }
            if ([self.record isEqual:[NSNull null]] || self.record == nil || self.record.length == 0) {
                BOOL insert = [self.db executeUpdate:@"INSERT INTO CallRecords(phoneNumber,date,name) VALUES(?,?,?)",phoneStr,dateStr,personInfo.nameStr];
                if (insert) {
                    NSLog(@"插入数据成功");
                }else{
                    NSLog(@"插入数据失败");
                }
            } else {
                BOOL update = [self.db executeUpdate:@"UPDATE CallRecords SET date=?,name=? WHERE phoneNumber=?",dateStr,personInfo.nameStr,phoneStr];
//                BOOL update1 = [self.db executeUpdate:@"UPDATE CallRecords SET name=? WHERE phoneNumber=?",personInfo.nameStr,phoneStr];
                if (update) {
                    NSLog(@"更新数据成功");
                }else{
                    NSLog(@"更新数据失败");
                }
//                if (update1) {
//                    NSLog(@"更新数据成功");
//                }else{
//                    NSLog(@"更新数据失败");
//                }
            }
        }
        [self.db close];
        
        DetailViewController * detailVC = [[DetailViewController alloc] init];
        // 传值
        detailVC.phoneNumber = phoneStr;
        if (index != -1) {
            if (self.callCount <= self.dataArray.count) {
                NSString *callId = [NSString stringWithFormat:@"%ld",self.callCount];
                detailVC.callCount = callId;
                [detailVC returnCallCountBlock:^(NSDictionary *callCountDic) {
                    NSLog(@"callCount == %@",callCountDic);
                    if ([[callCountDic objectForKey:callId] isEqualToString:@"1"]) {
                        //                    NSLog(@"拨打成功");
                        personInfo.callStateStr = @"1";
                    } else if ([[callCountDic objectForKey:callId] isEqualToString:@"0"]) {
                        //                    NSLog(@"拨打失败");
                        personInfo.callStateStr = @"0";
                    } else {
                        //                    NSLog(@"未接通");
                        personInfo.callStateStr = @"2";
                    }
                    if ([self.db open]) {
                        BOOL update = [self.db executeUpdate:@"UPDATE Contacts SET state=? WHERE phoneNumber=?",personInfo.callStateStr,personInfo.phoneStr];
                        if (update) {
                            NSLog(@"更新数据成功");
                        }else{
                            NSLog(@"更新数据失败");
                        }
                    }
                    [self.tableView reloadData];
                    self.callCount = self.callCount+1;
                    NSString *callcount = [NSString stringWithFormat:@"%ld",self.callCount];
                    [self.userDefaults removeObjectForKey:@"callCount"];
                    [self.userDefaults setObject:callcount forKey:@"callCount"];
                    NSString *callcount1 = [self.userDefaults objectForKey:@"callCount"];
                    NSLog(@"callcount1 == %@",callcount1);
                    if ([[callCountDic objectForKey:@"isStop"] isEqualToString:@"1"]) {
                        self.startBtn.selected = NO;
                    } else {
                        [self performSelector:@selector(startCall) withObject:nil afterDelay:0];
                    }
                }];
                NSString *callCount = [NSString stringWithFormat:@"%ld",self.callCount];
                [self.userDefaults removeObjectForKey:@"callCount"];
                [self.userDefaults setObject:callCount forKey:@"callCount"];
                // 推送
                [self presentViewController:detailVC animated:YES completion:nil];
            } else {
                [MBProgressHUD showSuccess:@"已拨打完毕"];
            }
        } else {
            [self presentViewController:detailVC animated:YES completion:nil];
        }
        
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 102) {
        PersonModel *model = self.recordArr[self.clickRow];
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        NSString *dateStr=[dateformatter stringFromDate:senddate];
        if (buttonIndex == 2) {
            [self.recordArr removeAllObjects];
            if ([self.db open]) {
                BOOL success =  [_db executeUpdate:@"DELETE FROM CallRecords"];
                if (success) {
                    NSLog(@"删除数据成功");
                }else{
                    NSLog(@"删除数据失败");
                }
            }
            [self.db close];
            [self.recordTableView reloadData];
        } else if (buttonIndex == 1) {
            [self.recordArr removeObject:model];
            if ([self.db open]) {
                BOOL delete = [_db executeUpdate:@"delete from CallRecords where phoneNumber=?",model.phoneStr];
                if (delete) {
                    NSLog(@"删除数据成功");
                }else{
                    NSLog(@"删除数据失败");
                }
            }
            [self.recordTableView reloadData];
        } else if (buttonIndex == 0) {
            if ([self.db open]) {
                BOOL update = [self.db executeUpdate:@"UPDATE CallRecords SET date=?,name=? WHERE phoneNumber=?",dateStr,model.nameStr,model.phoneStr];
//                BOOL update1 = [self.db executeUpdate:@"UPDATE CallRecords SET name=? WHERE phoneNumber=?",model.nameStr,model.phoneStr];
                if (update) {
                    NSLog(@"更新数据成功");
                }else{
                    NSLog(@"更新数据失败");
                }
//                if (update1) {
//                    NSLog(@"更新数据成功");
//                }else{
//                    NSLog(@"更新数据失败");
//                }
            }
            [self.db close];
            DetailViewController * detailVC = [[DetailViewController alloc] init];
            //传值
            detailVC.phoneNumber = model.phoneStr;
            // 推送
            [self presentViewController:detailVC animated:YES completion:nil];
        }
    } else if (actionSheet.tag == 101) {
        if (buttonIndex == 0) {
            self.callCount = [[self.userDefaults objectForKey:@"callCount"] integerValue];
            [self performSelector:@selector(startCall) withObject:nil afterDelay:0];
        } else if (buttonIndex == 1) {
            self.callCount = 1;
            [self performSelector:@selector(startCall) withObject:nil afterDelay:0];
        } else {
            self.startBtn.selected = NO;
        }
    } else if (actionSheet.tag == 100) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(startCall) withObject:nil afterDelay:0];
        } else {
            self.startBtn.selected = NO;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (section == 0) {
            return 12*KAdaptiveRateWidth;
        } else {
            return 0;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.recordTableView) {
        return 0;
    } else {
        if (_searchController.active) {
            return 0;
        }
#pragma mark -- 更改的
//        if (((NSArray *)[_dataArray objectAtIndex:section]).count==0) {
//            return 0;
//        }
//        return 30;
        return 0.1;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.recordTableView) {
        return nil;
    } else {
        if (_searchController.active) {
            return @[];
        }
#pragma mark -- 更改的
//        NSMutableArray *arr = [NSMutableArray array];
//        for (int i = 0; i < 27; i++) {
//            [arr addObject:JXSpellFromIndex(i)];
//        }
//        return arr;
        return @[];
    }
}

#pragma mark -
#pragma mark - SearchBarDelegate


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length > 0) {
        [self refreshSearchTableView:searchString];
        
    }

}
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    self.searchList = @[];
    //    self.tableView.tableHeaderView = searchController.searchBar;
    [self.tableView reloadData];
    [self.mainScrollView addSubview:searchController.searchBar];
    NSLog(@"didPresentSearchController");
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    [self.tableView reloadData];
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}


- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }

    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }

    return nil;
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
