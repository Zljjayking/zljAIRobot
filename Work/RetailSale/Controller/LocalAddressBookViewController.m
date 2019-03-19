//
//  LocalAddressBookViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "LocalAddressBookViewController.h"
//#import "MySearchDisplayController.h"
#import  "PersonModel.h"

#import "JXAddressBook.h"
#import "PersonCell.h"
#import "MBProgressHUD+MJ.h"

#define  mainWidth [UIScreen mainScreen].bounds.size.width
#define  mainHeigth  [UIScreen mainScreen].bounds.size.height

@interface LocalAddressBookViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property(nonatomic,strong)   NSMutableArray *listContent;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) PersonModel *people;
@property (strong, nonatomic) NSArray *searchList;

@property (strong,nonatomic) UITableView *tableView;
@end

@implementation LocalAddressBookViewController

{
    
    
    UISearchBar *_searchBar;
    
    
    NSArray *_dataArray;
    NSArray *_searchArray;
}
- (void)refreshPersonInfoTableView
{
    [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 对获取数据进行排序
            _dataArray = [JXAddressBook sortPersonInfos:personInfos];
            [_tableView reloadData];
//            _tableView.tableHeaderView = _searchBar;
        });
    }];
}
- (void)refreshSearchTableView:(NSString *)searchText
{
    [JXAddressBook searchPersonInfo:searchText addressBookBlock:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 直接获取数据
            
            self.searchList = personInfos;
            NSLog(@"self.searchList.count == %ld",self.searchList.count);
            [self.tableView reloadData];
//            [_searchBar.searchResultsTableView reloadData];
        });
    }];
}
- (void)createTableView
{
    _dataArray = [NSArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
    UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PersonCell class] forCellReuseIdentifier:@"PersonCell"];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
}
- (void)createSearchBar
{
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
//    [self.view addSubview: _searchController.searchResultsController.view];
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = _searchController.searchBar;
}

#pragma mark -
#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
    [self createSearchBar];
    [self refreshPersonInfoTableView];
}

#pragma mark -
#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return 1;
    } else {
        return _dataArray.count;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return @"";
    } else {
        return JXSpellFromIndex(section);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        
        return self.searchList.count;
    } else {
        return ((NSArray *)[_dataArray objectAtIndex:section]).count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdenfer = @"PersonCell";
    
    //    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenfer];
    //    }
    PersonCell *personcell=(PersonCell*)[tableView dequeueReusableCellWithIdentifier:cellIdenfer];
    if(personcell==nil)
    {
        personcell=[[PersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenfer];
    }
    JXPersonInfo *personInfo = nil;
    
    if (self.searchController.active) {
        
        if (self.searchList.count > 0) {
            personInfo = [self.searchList objectAtIndex:indexPath.row];
            [personcell setData:personInfo];
        }
    }else {
        NSArray *subArr = [_dataArray objectAtIndex:indexPath.section];
        personInfo = [subArr objectAtIndex:indexPath.row];
        [personcell setData:personInfo];
    }
    
    //    cell.textLabel.text = personInfo.fullName;
    
    //    if (personInfo.phone.count>0) {
    //        cell.detailTextLabel.text = [personInfo.phone[0] allObjects][0];
    //
    ////        cell.detailTextLabel.text = [personInfo.phone[0] objectForKey:((NSDictionary *)personInfo.phone[0]).allKeys[0]];
    //    }else {
    //        cell.detailTextLabel.text = @"暂无联系方式";
    //
    //    }
    return personcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JXPersonInfo *personInfo = nil;
    if (_searchController.active) {
        personInfo = [self.searchList objectAtIndex:indexPath.row];
    }else {
        personInfo = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    NSLog(@"当前选择的用户信息为:\n%@", personInfo);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_searchController.active) {
        return 0;
    }
    
    if (((NSArray *)[_dataArray objectAtIndex:section]).count==0) {
        return 0;
    }
    return 30;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_searchController.active) {
        return @[];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 27; i++) {
        [arr addObject:JXSpellFromIndex(i)];
    }
    return arr;
}

#pragma mark -
#pragma mark - SearchBarDelegate

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    [self refreshSearchTableView:searchText];
//}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = searchController.searchBar.text;
    if (searchString.length > 0) {
        [self refreshSearchTableView:searchString];

    }
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    if (self.searchList!= nil) {
//        [self.searchList removeAllObjects];
//    }
//    //过滤数据
//    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
//    //刷新表格
//    [_tableView reloadData];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {
//    self.searchController.active = NO;
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
