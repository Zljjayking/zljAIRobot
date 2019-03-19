//
//  choosePeopleViewController.m
//  Financeteam
//
//  Created by Zccf on 16/7/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "chooseViewController.h"
#import "LoginPeopleModel.h"
#import "ContactModel.h"
#import "choosePeopleTableViewCell.h"
#import "dept_idModel.h"
#import "PinYinForObjc.h"
#import "ChineseInclude.h"
#import "ExeResultViewController.h"
@interface chooseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sectionNameArr;
    NSMutableArray *contactsArr;
    UITableView *contactsTable;
    NSMutableDictionary *personObjectDics;
    NSMutableArray *array;
    NSMutableArray *SelectPeopleArr;
    LoginPeopleModel *loginModel;
    NSMutableArray *deptModelArr;
    NSMutableArray *avilableArr;
    NSMutableDictionary *sectionRows;
    NSMutableDictionary *chooseAllDic;
}
@property (nonatomic, strong) NSMutableArray *DaGouArr;
@property (nonatomic, strong) NSMutableArray *totalModel;
@property (nonatomic, strong) NSMutableArray *searchPeopleArr;
@end

@implementation chooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPeople)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    if (self.isExecutive) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [MBProgressHUD showMessage:@"加载中..."];
    self.title = @"选择人员";
    self.searchPeopleArr = [NSMutableArray array];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    if (self.seType == 1) {
        [self setupView];
        SelectPeopleArr = [NSMutableArray array];
        [self requestDataWith:(long)loginModel.jrqMechanismId andName:@""];
    } else if (self.seType == 2) {
        deptModelArr = [NSMutableArray array];
        [self setupView];
        self.DaGouArr = [NSMutableArray array];
        self.totalModel = [NSMutableArray array];
        [self requestDataWith:(long)loginModel.jrqMechanismId andName:@""];
    }
    contactsSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,NaviHeight, self.view.bounds.size.width, 40)];
    contactsSearchBar.delegate = self;
    contactsSearchBar.tintColor = TABBAR_BASE_COLOR;
    [contactsSearchBar setPlaceholder:@"搜索人员"];
    contactsSearchBar.keyboardType = UIKeyboardTypeDefault;
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:contactsSearchBar contentsController:self];
    searchDisplayController.active = NO;
    [searchDisplayController.searchResultsTableView registerClass:[choosePeopleTableViewCell class] forCellReuseIdentifier:@"cell"];
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.searchDisplayController.searchResultsTableView setTableFooterView:view];
    contactsTable.tableHeaderView = contactsSearchBar;
    // Do any additional setup after loading the view.
}
//加载页面
- (void)setupView {
    contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
    if (self.ishideNaviView) {
        contactsTable.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight);
    }
    [self.view addSubview:contactsTable];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [contactsTable setTableFooterView:view];
    [contactsTable registerClass:[choosePeopleTableViewCell class] forCellReuseIdentifier:@"cell"];
    contactsTable.delegate = self;
    contactsTable.dataSource = self;
  //  [MBProgressHUD showMessage:@"正在加载..."];
}
-(void)requestDataWith:(NSInteger)jrqId andName:(NSString *)string{

    
    [HttpRequestEngine getMechanUsersWithMechId:[NSString stringWithFormat:@"%ld",jrqId] andName:string completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            personObjectDics = [NSMutableDictionary dictionary];
            sectionRows = [NSMutableDictionary dictionary];
            chooseAllDic = [NSMutableDictionary dictionary];
            if ([(NSMutableArray *)obj count]>0) {
                NSMutableArray *data = [NSMutableArray array];
                data = obj;
                array = [NSMutableArray array];
                
                
                if (self.seType == 1) {
                    for (int i=0; i<data.count; i++) {
                        ContactModel *model = [data objectAtIndex:i];
                        model.tag = i+1;
                        model.isSelected = 0;
                        if (self.limited == 2) {
                            if (!model.deptId) {
                                [array addObject:model];
                            }
                            if (self.deleteArr.count != 0) {
                                
                                for (int i=0; i<self.deleteArr.count; i++) {
                                    
                                    ContactModel *model1 = self.deleteArr[i];
                                    if (model1.userId == model.userId && ![array containsObject:model]) {
                                        [array addObject:model];
                                    }
                                }
                                
                            }
                        } else if (self.limited == 1) {
                            [array addObject:model];
                        } else if (self.limited == 3) {
                            if (model.deptId == self.deptId) {
                                [array addObject:model];
                            }
                        } else if (self.limited == 4) {
                            if (!model.deptId) {
                                [array addObject:model];
                            } else {
                                if (self.deptId == model.deptId && model.userId != model.person_id) {
                                    [array addObject:model];
                                }
                                
                            }
                            if ([model.isCrps isEqualToString:@"1"]) {
                                [array removeObject:model];
                            }
                            if (self.deleteArr.count != 0) {
                                
                                for (int i=0; i<self.deleteArr.count; i++) {
                                    
                                    ContactModel *model1 = self.deleteArr[i];
                                    if (model1.userId == model.userId && ![array containsObject:model]) {
                                        [array addObject:model];
                                    }
                                }
                                
                            }
                        } else if (self.limited == 5) {
                            NSString *deptIdStr = [NSString stringWithFormat:@"%ld",model.deptId];
                            if (self.deptArr.count>0) {
                                for (NSString *deptId in self.deptArr) {
                                    
                                    if ([deptId isEqualToString:deptIdStr]) {
                                        [array addObject:model];
                                    }
                                }
                            } else {
                                if (model.deptId == self.deptId) {
                                    [array addObject:model];
                                }
                            }
                            
                        } else {
                            [array addObject:model];
                        }
                    }
                    if (self.limited == 1) {
                        if(self.limitArr.count != 0 ) {
                            for (int i=0; i<array.count; i++) {
                                ContactModel *model1 = array[i];
                                for (int j=0; j<self.limitArr.count; j++) {
                                    
                                    ContactModel *model2 = self.limitArr[j];
                                    if (model1.userId == model2.userId) {
                                        [array removeObject:model1];
                                        i = i-1;
                                    }
                                }
                            }
                        }
                    }else if (self.limited == 2 || self.limited == 4) {
                        //                    NSMutableArray *deleteUidArr = [NSMutableArray array];
                        //                    NSMutableArray *arrUidArr = [NSMutableArray array];
                        //                    if (self.deleteArr.count != 0) {
                        //
                        //                        for (int i=0; i<self.deleteArr.count; i++) {
                        //
                        //                            ContactModel *model1 = self.deleteArr[i];
                        //                            NSString * uid = [NSString stringWithFormat:@"%ld",model1.userId];
                        //                            [deleteUidArr addObject:uid];
                        //                        }
                        //                        for (int j=0; j<array.count; j++) {
                        //                            ContactModel *model2 = array[j];
                        //                            NSString * uid = [NSString stringWithFormat:@"%ld",model2.userId];
                        //                            [arrUidArr addObject:uid];
                        //                        }
                        //                        for (int i=0; i<deleteUidArr.count; i++) {
                        //                            NSString *uid = deleteUidArr[i];
                        //                            if (![arrUidArr containsObject:uid]) {
                        //                                ContactModel *model = self.deleteArr[i];
                        //                                model.isSelected = NO;
                        //                                [array addObject:model];
                        //                            }
                        //                        }
                        //                    }
                        if (self.limited == 4) {
                            if(self.limitArr.count != 0 ) {
                                for (int i=0; i<array.count; i++) {
                                    ContactModel *model1 = array[i];
                                    for (int j=0; j<self.limitArr.count; j++) {
                                        ContactModel *model2 = self.limitArr[j];
                                        if (model1.userId == model2.userId) {
                                            [array removeObject:model1];
                                            i = i-1;
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    //                if (self.limited == 5) {
                    //                    if (self.deptArr.count > 0) {
                    //
                    //                    }
                    //                }
                    for (int i=0; i<array.count; i++) {
                        ContactModel *model = [array objectAtIndex:i];
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    }
                    for (int i=0; i<[personObjectDics allKeys].count; i++) {
                        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][i]];
                        //                    if (i == 0) {
                        //                        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][i]];
                        //                    } else {
                        //                        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][i]];
                        //                    }
                    }
                } else if(self.seType == 2) {
#pragma mark == seType=2的时候
                    for (int i=0; i<data.count; i++) {
                        ContactModel *model = [data objectAtIndex:i];
                        model.tag = i+1;
                        model.isSelected = 0;
                        if (self.limited == 1) {
                            if (model.userId != loginModel.userId) {
                                if (model.powerId == (long)nil) {
                                    [array addObject:model];
                                }
                            }
                        } else if (self.limited == 2){
                            if (model.userId != loginModel.userId) {
                                [array addObject:model];
                            }
                        } else if (self.limited == 3) {
                            [array addObject:model];
                        } else if (self.limited == 4 || self.limited == 5) {
                            if (!model.deptId) {
                                [array addObject:model];
                            }
                        } else if (self.limited == 6) {
                            if (model.userId != loginModel.userId) {
                                [array addObject:model];
                            }
                        } else if (self.limited == 7) {
                            if (model.userId != loginModel.userId) {
                                if (!model.deptId) {
                                    [array addObject:model];
                                }
                            }
                        } else if (self.limited == 8) {
                            if ([model.isCrps isEqualToString:@"0"]) {
                                if (!model.deptId) {
                                    [array addObject:model];
                                } else {
                                    if (self.deptId == model.deptId && model.userId != model.person_id) {
                                        [array addObject:model];
                                    }
                                }
                            }
                            if (self.deleteArr.count != 0) {
                                
                                for (int i=0; i<self.deleteArr.count; i++) {
                                    
                                    ContactModel *model1 = self.deleteArr[i];
                                    if (model1.userId == model.userId && ![array containsObject:model]) {
                                        [array addObject:model];
                                    }
                                }
                            }
                        } else if (self.limited == 9) {
                            if ([Utils isBlankString:model.performanceId]) {
                                [array addObject:model];
                            }
                            
                            if (self.deleteArr.count != 0) {
                                
                                for (int i=0; i<self.deleteArr.count; i++) {
                                    
                                    ContactModel *model1 = self.deleteArr[i];
                                    if (model1.userId == model.userId && ![array containsObject:model]) {
                                        [array addObject:model];
                                    }
                                }
                            }
                        }
                    }
                    if (self.limited == 1) {
                        NSMutableArray *deleteUidArr = [NSMutableArray array];
                        NSMutableArray *arrUidArr = [NSMutableArray array];
                        if (self.deleteArr.count != 0) {
                            
                            for (int i=0; i<self.deleteArr.count; i++) {
                                
                                ContactModel *model1 = self.deleteArr[i];
                                NSString * uid = [NSString stringWithFormat:@"%ld",model1.userId];
                                [deleteUidArr addObject:uid];
                            }
                            for (int j=0; j<array.count; j++) {
                                ContactModel *model2 = array[j];
                                NSString * uid = [NSString stringWithFormat:@"%ld",model2.userId];
                                [arrUidArr addObject:uid];
                            }
                            for (int i=0; i<deleteUidArr.count; i++) {
                                NSString *uid = deleteUidArr[i];
                                if (![arrUidArr containsObject:uid]) {
                                    ContactModel *model = self.deleteArr[i];
                                    model.isSelected = NO;
                                    [array addObject:model];
                                }
                            }
                        }
                        
                        if (self.addArr.count != 0) {
                            for (int i=0; i<self.addArr.count; i++) {
                                ContactModel *model_1 = self.addArr[i];
                                for (int j=0; j<array.count; j++) {
                                    ContactModel *model_2 = array[j];
                                    if (model_2.userId == model_1.userId) {
                                        
                                        [array removeObject:model_2];
                                    }
                                }
                            }
                        }
                        
                    } else if (self.limited == 2) {
                        NSMutableArray *deleteUidArr = [NSMutableArray array];
                        NSMutableArray *arrUidArr = [NSMutableArray array];
                        if (self.deleteArr.count != 0) {
                            
                            for (int i=0; i<self.deleteArr.count; i++) {
                                
                                ContactModel *model1 = self.deleteArr[i];
                                NSString * uid = [NSString stringWithFormat:@"%ld",model1.userId];
                                [deleteUidArr addObject:uid];
                            }
                            for (int j=0; j<array.count; j++) {
                                ContactModel *model2 = array[j];
                                NSString * uid = [NSString stringWithFormat:@"%ld",model2.userId];
                                [arrUidArr addObject:uid];
                            }
                            for (int i=0; i<deleteUidArr.count; i++) {
                                NSString *uid = deleteUidArr[i];
                                if (![arrUidArr containsObject:uid]) {
                                    ContactModel *model = self.deleteArr[i];
                                    model.isSelected = NO;
                                    [array addObject:model];
                                }
                            }
                        }
                        
                        if (self.addArr.count != 0) {
                            for (int i=0; i<self.addArr.count; i++) {
                                ContactModel *model_1 = self.addArr[i];
                                for (int j=0; j<array.count; j++) {
                                    ContactModel *model_2 = array[j];
                                    if (model_2.userId == model_1.userId) {
                                        
                                        [array removeObject:model_2];
                                    }
                                }
                            }
                        }
                    } else if(self.limited == 3 || self.limited == 4 || self.limited == 6) {
                        if(self.limitArr.count != 0 ) {
                            for (int i=0; i<array.count; i++) {
                                ContactModel *model1 = array[i];
                                for (int j=0; j<self.limitArr.count; j++) {
                                    ContactModel *model2 = self.limitArr[j];
                                    if (model1.userId == model2.userId) {
                                        [array removeObject:model1];
                                        i = i-1;
                                    }
                                }
                            }
                        }
                    } else if (self.limited == 5 ) {
                        NSMutableArray *deleteUidArr = [NSMutableArray array];
                        NSMutableArray *arrUidArr = [NSMutableArray array];
                        if (self.deleteArr.count != 0) {
                            
                            for (int i=0; i<self.deleteArr.count; i++) {
                                
                                ContactModel *model1 = self.deleteArr[i];
                                NSString * uid = [NSString stringWithFormat:@"%ld",model1.userId];
                                [deleteUidArr addObject:uid];
                            }
                            for (int j=0; j<array.count; j++) {
                                ContactModel *model2 = array[j];
                                NSString * uid = [NSString stringWithFormat:@"%ld",model2.userId];
                                [arrUidArr addObject:uid];
                            }
                            for (int i=0; i<deleteUidArr.count; i++) {
                                NSString *uid = deleteUidArr[i];
                                if (![arrUidArr containsObject:uid]) {
                                    ContactModel *model = self.deleteArr[i];
                                    model.isSelected = NO;
                                    [array addObject:model];
                                }
                            }
                        }
                        //                    if (self.deleteArr.count != 0) {
                        //
                        //                        for (int i=0; i<self.deleteArr.count; i++) {
                        //
                        //                            ContactModel *model = self.deleteArr[i];
                        //                            model.isSelected = NO;
                        //                            [array addObject:model];
                        //                        }
                        //
                        //                    }
                    } else if (self.limited == 7) {
                        //                    NSLog(@"self.limitArr.count == %ld",self.limitArr.count);
                        if(self.limitArr.count != 0 ) {
                            for (int i=0; i<array.count; i++) {
                                ContactModel *model1 = array[i];
                                for (int j=0; j<self.limitArr.count; j++) {
                                    ContactModel *model2 = self.limitArr[j];
                                    if (model1.userId == model2.userId) {
                                        [array removeObject:model1];
                                        i = i-1;
                                    }
                                }
                            }
                        }
                    } else if (self.limited == 8) {
                        
                        if(self.limitArr.count != 0 ) {
                            for (int i=0; i<array.count; i++) {
                                ContactModel *model1 = array[i];
                                for (int j=0; j<self.limitArr.count; j++) {
                                    ContactModel *model2 = self.limitArr[j];
                                    if (model1.userId == model2.userId) {
                                        [array removeObject:model1];
                                        i = i-1;
                                    }
                                }
                            }
                        }
                    } else if (self.limited == 9) {
                        
                        
                        
                        if (self.limitArr.count) {
                            for ( int i=0; i<array.count; i++) {
                                ContactModel *model1 = array[i];
                                for (int j=0; j<self.limitArr.count; j++) {
                                    ContactModel *model2 = self.limitArr[j];
                                    if (model1.userId == model2.userId) {
                                        [array removeObject:model1];
                                        i = i-1;
                                    }
                                }
                            }
                        }
                    }
                    
                    for (int i=0; i<array.count; i++) {
                        ContactModel *model = [array objectAtIndex:i];
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",(long)model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",(long)model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    }
                    for (int i=0; i<[personObjectDics allKeys].count; i++) {
                        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][i]];
                        //                    if (i == 0) {
                        //                        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][i]];
                        //                    } else {
                        //                        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][i]];
                        //                    }
                    }
                    for (int i=0; i<[personObjectDics allKeys].count; i++) {
                        if (i == 0) {
                            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][i]];
                        } else {
                            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][i]];
                        }
                    }
                    //                NSLog(@"personObjectDics == %@",personObjectDics);
                    //                NSLog(@"sectionRows == %@",sectionRows);
                    for (int i=0; i<[personObjectDics allKeys].count; i++) {
                        dept_idModel *dept = [dept_idModel new];
                        dept.isSelected = 0;
                        NSArray *arr = [personObjectDics objectForKey:[personObjectDics allKeys][i]];
                        ContactModel *model = arr[0];
                        dept.dept_Name = model.deptName;
                        dept.dept_tag = i;
                        [deptModelArr addObject:dept];
                    }
                }
                [MBProgressHUD hideHUD];
                [contactsTable reloadData];
                
            }
            
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }
        
        

    }];
}

//-(void)loadData:(NSString *)deptIdStr{
//    
//    
//    
//    [HttpRequestEngine getDeptDetailWithDeptId:deptIdStr completion:^(id obj, NSString *errorStr) {
//        
//        if (errorStr == nil) {
//            [self.userMapArray removeAllObjects];
//            [self.userMapArray addObjectsFromArray:obj[0]];
//            [self.persionListArray removeAllObjects];
//            [self.persionListArray addObjectsFromArray:obj[1]];
//            NSArray *arr = (NSArray *)obj;
//            if (arr.count == 3) {
//                [self.sonDeptList removeAllObjects];
//                [self.sonDeptList addObjectsFromArray:arr[2]];
//            }
//            
//            ContactModel *model = self.userMapArray[0];
//            self.deptId = model.deptId;
//            
//            
//        }else{
//            [MBProgressHUD showError:@"未查到数据"];
//            
//            [self.userMapArray removeAllObjects];
//            [self.persionListArray removeAllObjects];
//        }
//        
//    }];
//    
//    
//    
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return 1;
    } else {
        if (self.seType == 1) {
            return [personObjectDics allKeys].count;
        } else if(self.seType == 2) {
            return [personObjectDics allKeys].count+1;
        }
        return 0;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return searchResults.count;
    } else {
        if (self.seType == 1) {
            if ([[sectionRows objectForKey:[personObjectDics allKeys][section]] isEqualToString:@"1"]) {
                NSString *string = [personObjectDics allKeys][section];
                NSArray *arr = [personObjectDics objectForKey:string];
                //            NSLog(@"arr.count == %ld",arr.count);
                return arr.count;
            } else {
                return 0;
            }
        } else if (self.seType == 2) {
            if (section == 0) {
                return 0;
            } else {
                if ([[sectionRows objectForKey:[personObjectDics allKeys][section - 1]] isEqualToString:@"1"]) {
                    NSString *string = [personObjectDics allKeys][section-1];
                    NSArray *arr = [personObjectDics objectForKey:string];
                    //                NSLog(@"arr.count == %ld",arr.count);
                    return arr.count;
                } else {
                    return 0;
                }
            }
        }
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return 0;
    } else {
        if (self.seType == 1) {
            return 40;
        } else if (self.seType == 2) {
            return 40;
        }
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return nil;
    } else {
        if (self.seType == 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            view.backgroundColor = VIEW_BASE_COLOR;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 30)];
            titleLb.font = [UIFont systemFontOfSize:15];
            NSString *string = [personObjectDics allKeys][section];
            NSArray *arr = [personObjectDics objectForKey:string];
            ContactModel *model = arr[0];
            if (model.deptId == 0) {
                model.deptName = @"未分配人员";
            }
            titleLb.text = [NSString stringWithFormat:@"%@",model.deptName];
            
            [view addSubview:titleLb];
            titleLb.center = view.center;
            if ([[sectionRows objectForKey:[sectionRows allKeys][section]] isEqualToString:@"1"]) {
                UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（上）"]];
                arrow.frame = CGRectMake(kScreenWidth-40, 0, 15, 8);
                arrow.center = CGPointMake(kScreenWidth-30, view.center.y);
                [view addSubview:arrow];
            } else {
                UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（下）"]];
                arrow.frame = CGRectMake(kScreenWidth-40, 0, 15, 8);
                arrow.center = CGPointMake(kScreenWidth-30, view.center.y);
                [view addSubview:arrow];
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:btn];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame =CGRectMake(0, 0, kScreenWidth, 40);
            btn.tag = section+1;
            [btn addTarget:self action:@selector(ClickSection:) forControlEvents:UIControlEventTouchUpInside];
            return view;
        } else if (self.seType == 2) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            view.backgroundColor = VIEW_BASE_COLOR;
            view.tag = section;
            if (section == 0) {
                UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-40, 20)];
                titleLb.text = @"全选";
                [view addSubview:titleLb];
                titleLb.font = [UIFont systemFontOfSize:15];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10, 7.5, 25, 25);
                [view addSubview:btn];
                btn.selected = self.selectStatus;
                [btn addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
            } else {
                NSString *string = [personObjectDics allKeys][section-1];
                NSArray *arr = [personObjectDics objectForKey:string];
                ContactModel *model = arr[0];
                if (model.deptId == 0) {
                    model.deptName = @"未分配人员";
                }
                UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-40, 20)];
                titleLb.text = [NSString stringWithFormat:@"%@",model.deptName];
                titleLb.font = [UIFont systemFontOfSize:15];
                [view addSubview:titleLb];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view addSubview:btn];
                btn.tag = section*1000;
                btn.frame = CGRectMake(10, 7.5, 25, 25);
                if ([[chooseAllDic objectForKey:[personObjectDics allKeys][section-1]] isEqualToString:@"1"]) {
                    btn.selected = 1;
                } else {
                    btn.selected = 0;
                }
                [btn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(chooseDept:) forControlEvents:UIControlEventTouchUpInside];
                if ([[sectionRows objectForKey:[sectionRows allKeys][section-1]] isEqualToString:@"1"]) {
                    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（上）"]];
                    arrow.frame = CGRectMake(kScreenWidth-40, 0, 15, 8);
                    arrow.center = CGPointMake(kScreenWidth-30, view.center.y);
                    [view addSubview:arrow];
                } else {
                    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头（下）"]];
                    arrow.frame = CGRectMake(kScreenWidth-40, 0, 15, 8);
                    arrow.center = CGPointMake(kScreenWidth-30, view.center.y);
                    [view addSubview:arrow];
                }
                UIButton *sectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view addSubview:sectionBtn];
                sectionBtn.backgroundColor = [UIColor clearColor];
                sectionBtn.frame =CGRectMake(40, 0, kScreenWidth-40, 40);
                sectionBtn.tag = section;
                [sectionBtn addTarget:self action:@selector(ClickSection:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            return view;
        }
        
        return nil;
    }
    
}
- (void)ClickSection:(UIButton *)btn {
    NSInteger index = btn.tag - 1;
//    NSLog(@"index == %@",[personObjectDics allKeys][index]);
    if ([[sectionRows objectForKey:[personObjectDics allKeys][index]] isEqualToString:@"0"]) {
        [sectionRows setObject:@"1" forKey:[personObjectDics allKeys][index]];
    } else {
        [sectionRows setObject:@"0" forKey:[personObjectDics allKeys][index]];
    }
    [contactsTable reloadData];
}
- (void)chooseAll:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.selectStatus = 1;
        [self.DaGouArr removeAllObjects];
        for (int i = 0; i<[personObjectDics allKeys].count; i++) {
            [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][i]];
            NSString *string = [personObjectDics allKeys][i];
            NSArray *arr = [personObjectDics objectForKey:string];
            for (int j=0; j<arr.count;j++) {
                ContactModel *model = arr[j];
                model.isSelected = 1;
                [self.DaGouArr addObject:model];
            }
        }
        
    } else {
        self.selectStatus = 0;
        [self.DaGouArr removeAllObjects];
        for (int i = 0; i<[personObjectDics allKeys].count; i++) {
            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][i]];
            NSString *string = [personObjectDics allKeys][i];
            NSArray *arr = [personObjectDics objectForKey:string];
            for (int j=0; j<arr.count;j++) {
                ContactModel *model = arr[j];
                model.isSelected = 0;
                [self.DaGouArr removeObject:model];
            }
        }
    }
    [contactsTable reloadData];
}
- (void)chooseDept:(UIButton *)btn{
    UIView *view = [btn superview];
    btn.selected = !btn.selected;
    NSInteger index = view.tag-1;
    if (btn.selected) {
        [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][index]];
        NSString *string = [personObjectDics allKeys][index];
        NSArray *arr = [personObjectDics objectForKey:string];
        for (int i=0; i<arr.count; i++) {
            ContactModel *model = arr[i];
            if (model.isSelected == 1) {
                [self.DaGouArr removeObject:model];
            }
        }
        for (int j=0; j<arr.count;j++) {
            ContactModel *model = arr[j];
            model.isSelected = 1;
            [self.DaGouArr addObject:model];
        }
    } else {
        [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][index]];
        NSString *string = [personObjectDics allKeys][index];
        NSArray *arr = [personObjectDics objectForKey:string];
        for (int j=0; j<arr.count;j++) {
            ContactModel *model = arr[j];
            model.isSelected = 0;
            [self.DaGouArr removeObject:model];
        }
        
    }
    if (self.DaGouArr.count == array.count) {
        self.selectStatus = 1;
    } else {
        self.selectStatus = 0;
    }
    [contactsTable reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        choosePeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[choosePeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        ContactModel *model = searchResults[indexPath.row];
        [cell.headerImage sd_setImageWithURL:[model.iconUrl convertHostUrl]  placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        cell.nameLB.text = model.realName;
        cell.DaGouBtn.tag = model.tag;
        cell.DaGouBtn.selected = model.isSelected;
        if (self.seType == 1) {
            if (cell.DaGouBtn.selected) {
                cell.DaGouImage.image = [UIImage imageNamed:@"单选框（亮）"];
            } else {
                cell.DaGouImage.image = [UIImage imageNamed:@"单选框"];
            }
            [cell.DaGouBtn addTarget:self action:@selector(searchChoose:) forControlEvents:UIControlEventTouchUpInside];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else if (self.seType == 2) {
            if (cell.DaGouBtn.selected) {
                cell.DaGouImage.image = [UIImage imageNamed:@"checkbox_pressed"];
            } else {
                cell.DaGouImage.image = [UIImage imageNamed:@"checkbox_normal"];
            }
            [cell.DaGouBtn addTarget:self action:@selector(searchChooseAvilable:) forControlEvents:UIControlEventTouchUpInside];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    } else {
        choosePeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[choosePeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (self.seType == 1) {
            for (int i=0; i<[personObjectDics allKeys].count; i++) {
                if (indexPath.section == i) {
                    NSString *string = [personObjectDics allKeys][i];
                    NSArray *arr = [personObjectDics objectForKey:string];
                    for (int j=0; j<arr.count;j++) {
                        if (indexPath.row == j) {
                            ContactModel *model = arr[j];
                            
                            if (!model.iconUrl) {
                                cell.headerImage.image = [UIImage imageNamed:@"聊天头像"];
                            }else {
                                [cell.headerImage sd_setImageWithURL:[model.iconUrl convertHostUrl]  placeholderImage:[UIImage imageNamed:@"聊天头像"]];
                            }
                            cell.nameLB.text = model.realName;
                            cell.DaGouBtn.tag = model.tag;
                            
                            cell.DaGouBtn.selected = model.isSelected;
                            if (cell.DaGouBtn.selected) {
                                cell.DaGouImage.image = [UIImage imageNamed:@"单选框（亮）"];
                            } else {
                                cell.DaGouImage.image = [UIImage imageNamed:@"单选框"];
                            }
                            [cell.DaGouBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                            return cell;
                        }
                        
                    }
                    
                }
            }
        } else if (self.seType == 2) {
            for (int i=0; i<[personObjectDics allKeys].count; i++) {
                if (indexPath.section == i+1) {
                    NSString *string = [personObjectDics allKeys][i];
                    NSArray *arr = [personObjectDics objectForKey:string];
                    for (int j=0; j<arr.count;j++) {
                        if (indexPath.row == j) {
                            ContactModel *model = arr[j];
                            
                            if (!model.iconUrl) {
                                cell.headerImage.image = [UIImage imageNamed:@"聊天头像"];
                            }else {
                                [cell.headerImage sd_setImageWithURL:[model.iconUrl convertHostUrl]  placeholderImage:[UIImage imageNamed:@"聊天头像"]];
                            }
                            cell.nameLB.text = model.realName;
                            cell.DaGouBtn.tag = model.tag;
                            
                            cell.DaGouBtn.selected = model.isSelected;
                            if (cell.DaGouBtn.selected) {
                                cell.DaGouImage.image = [UIImage imageNamed:@"checkbox_pressed"];
                            } else {
                                cell.DaGouImage.image = [UIImage imageNamed:@"checkbox_normal"];
                            }
                            [cell.DaGouBtn addTarget:self action:@selector(chooseAvilable:) forControlEvents:UIControlEventTouchUpInside];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                            return cell;
                        }
                    }
                }
            }
        }
        
        return nil;
    }
    
}


#pragma mark -- 点击事件

//单选
- (void)choose:(UIButton *)btn {
    if (SelectPeopleArr.count != 0) {
        ContactModel *model = SelectPeopleArr[0];
        model.isSelected = 0;
        [SelectPeopleArr removeAllObjects];
    }
    choosePeopleTableViewCell *cell = (choosePeopleTableViewCell *)[btn superview];
    NSIndexPath *indexPath = [contactsTable indexPathForCell:cell];
    NSArray *sectionArr = [personObjectDics objectForKey:[personObjectDics allKeys][indexPath.section]];
    ContactModel *model = sectionArr[indexPath.row];
    model.isSelected = 1;
    [SelectPeopleArr addObject:model];
    [contactsTable reloadData];
    if (self.isExecutive) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPeople)];
        self.navigationItem.rightBarButtonItem = right;
    }
}

//搜索出的单选结果
- (void)searchChoose:(UIButton *)btn {
    if (SelectPeopleArr.count != 0) {
        ContactModel *model = SelectPeopleArr[0];
        model.isSelected = 0;
        [SelectPeopleArr removeAllObjects];
    }
    choosePeopleTableViewCell *cell = (choosePeopleTableViewCell *)[btn superview];
    NSIndexPath *indexPath = [searchDisplayController.searchResultsTableView indexPathForCell:cell];
    ContactModel *model = searchResults[indexPath.row];
    model.isSelected = 1;
    [SelectPeopleArr addObject:model];
    [contactsTable reloadData];
    contactsSearchBar.text = model.realName;
    [searchDisplayController.searchResultsTableView reloadData];
    if (self.isExecutive) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddPeople)];
        self.navigationItem.rightBarButtonItem = right;
    }
}
//多选
- (void)chooseAvilable:(UIButton *)btn {
    btn.selected = !btn.selected;
    choosePeopleTableViewCell *cell = (choosePeopleTableViewCell *)[btn superview];
    NSIndexPath *indexPath = [contactsTable indexPathForCell:cell];
    if (btn.selected) {
//        NSLog(@"选中");
        NSArray *sectionArr = [personObjectDics objectForKey:[personObjectDics allKeys][indexPath.section-1]];
        ContactModel *model = sectionArr[indexPath.row];
        model.isSelected = 1;
        [self.DaGouArr addObject:model];
        NSMutableArray *sectionCount = [NSMutableArray array];
        for (int i = 0; i<sectionArr.count; i++) {
            ContactModel *model = sectionArr[i];
            if (model.isSelected == 1) {
                [sectionCount addObject:model];
            } else {
                
            }
        }
        if (sectionCount.count == sectionArr.count) {
            [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][indexPath.section-1]];
        }else {
            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][indexPath.section-1]];
        }
    } else {
//        NSLog(@"未选中");
        NSArray *sectionArr = [personObjectDics objectForKey:[personObjectDics allKeys][indexPath.section-1]];
        ContactModel *model = sectionArr[indexPath.row];
        model.isSelected = 0;
        [self.DaGouArr removeObject:model];
        NSMutableArray *sectionCount = [NSMutableArray array];
        for (int i = 0; i<sectionArr.count; i++) {
            ContactModel *model = sectionArr[i];
            if (model.isSelected == 1) {
                [sectionCount addObject:model];
            } else {
                
            }
        }
        if (sectionCount.count == sectionArr.count) {
            [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][indexPath.section-1]];
        }else {
            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][indexPath.section-1]];
        }
    }
    if (self.DaGouArr.count == array.count) {
        self.selectStatus = 1;
    } else {
        self.selectStatus = 0;
    }
//    NSLog(@"self.DaGouArr.count == %ld",self.DaGouArr.count);
    [contactsTable reloadData];
}
//搜索出的多选结果
- (void)searchChooseAvilable:(UIButton *)btn {
    btn.selected = !btn.selected;
    choosePeopleTableViewCell *cell = (choosePeopleTableViewCell *)[btn superview];
    NSIndexPath *indexPath = [searchDisplayController.searchResultsTableView indexPathForCell:cell];
    if (btn.selected) {
//        NSLog(@"选中");
        ContactModel *model = searchResults[indexPath.row];
        model.isSelected = 1;
        [self.DaGouArr addObject:model];
//        if (sectionCount.count == sectionArr.count) {
//            [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][indexPath.section-1]];
//        }else {
//            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][indexPath.section-1]];
//        }
//        NSArray *sectionArr = [personObjectDics objectForKey:[personObjectDics allKeys][indexPath.section-1]];
//
//        NSMutableArray *sectionCount = [NSMutableArray array];
//        for (int i = 0; i<sectionArr.count; i++) {
//            ContactModel *model = sectionArr[i];
//            if (model.isSelected == 1) {
//                [sectionCount addObject:model];
//            } else {
//                
//            }
//        }
//        if (sectionCount.count == sectionArr.count) {
//            [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][indexPath.section-1]];
//        }else {
//            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][indexPath.section-1]];
//        }
    } else {
//        NSLog(@"未选中");
        ContactModel *model = searchResults[indexPath.row];
        model.isSelected = 0;
        [self.DaGouArr addObject:model];
//        NSArray *sectionArr = [personObjectDics objectForKey:[personObjectDics allKeys][indexPath.section-1]];
//        ContactModel *model = sectionArr[indexPath.row];
//        model.isSelected = 0;
//        [self.DaGouArr removeObject:model];
//        NSMutableArray *sectionCount = [NSMutableArray array];
//        for (int i = 0; i<sectionArr.count; i++) {
//            ContactModel *model = sectionArr[i];
//            if (model.isSelected == 1) {
//                [sectionCount addObject:model];
//            } else {
//                
//            }
//        }
//        if (sectionCount.count == sectionArr.count) {
//            [chooseAllDic setObject:@"1" forKey:[personObjectDics allKeys][indexPath.section-1]];
//        }else {
//            [chooseAllDic setObject:@"0" forKey:[personObjectDics allKeys][indexPath.section-1]];
//        }
    }
    if (self.DaGouArr.count == array.count) {
        self.selectStatus = 1;
    } else {
        self.selectStatus = 0;
    }
//    NSLog(@"self.DaGouArr.count == %ld",self.DaGouArr.count);
    [contactsTable reloadData];
    [searchDisplayController.searchResultsTableView reloadData];
}
- (void)ClickAddPeople {
    if (self.seType == 1) {
        if (self.isExecutive) {
            ContactModel * model = SelectPeopleArr[0];
            
            NSString *userId = [NSString stringWithFormat:@"%ld",model.userId];
            
            [self sureSearchOnClick:userId];
            
        } else {
            if (self.returnNSMutableArrayBlock != nil) {
                if (SelectPeopleArr.count!=0) {
                    self.returnNSMutableArrayBlock(SelectPeopleArr);
                } else {
                    NSMutableArray *arr = [NSMutableArray array];
                    
                    self.returnNSMutableArrayBlock(arr);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        // [self.navigationController popViewControllerAnimated:YES];
    } else if (self.seType == 2) {
        
        if (self.returnAvilableNSMutableArrayBlock != nil) {
            if (self.DaGouArr.count!=0) {
                
                self.returnAvilableNSMutableArrayBlock(self.DaGouArr);
            } else {
                NSMutableArray *arr = [NSMutableArray array];
                self.returnAvilableNSMutableArrayBlock(arr);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)sureSearchOnClick:(NSString *)userId{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"inter"] = @"implementPower";
    
    dic[@"startTime"] = self.startTime;
    
    dic[@"endTime"] = self.endTime;
    
//    if (self.mechId.length != 0) {
//        dic[@"mechId"] = self.mechId;
//    }
//    
//    if (self.deptId.length != 0) {
//        
//        dic[@"deptId"] = self.deptId;
//    }
//    if (userId.length != 0) {
//        
//    }
    dic[@"userId"] = userId;
    NSLog(@"dic:%@",dic);
    [MBProgressHUD showMessage:@"正在加载.."];
    
    [HttpRequestEngine searchExecutiveWithDic:dic completion:^(id obj, NSString *errorStr) {
        
        [MBProgressHUD hideHUD];
        //            NSLog(@"obj == %@",obj);
        if (errorStr == nil) {
            
            NSDictionary * dict = obj;
            
            
            ExeResultViewController * exeResultVC = [[ExeResultViewController alloc]init];
            
            exeResultVC.dataDic = dict;
            
            [self.navigationController pushViewController:exeResultVC animated:YES];
            
            
        }else{
            
            NSLog(@"%@",errorStr);
        }
    }];

    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"YYYY-MM-dd"];
//    NSDate *dt1 = [[NSDate alloc] init];
//    NSDate *dt2 = [[NSDate alloc] init];
//    
//    dt1 = [df dateFromString:self.MstartTime];
//    dt2 = [df dateFromString:self.MendTime];
//    
//    NSComparisonResult result = [dt1 compare:dt2];
//    
//    if (self.startTime.length == 0 || self.endTime.length == 0) {
//        
//        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择时间" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        
//        [alertV show] ;
//        
//        
//    }else if (self.mechId.length == 0 && self.deptId.length == 0 && self.userId.length == 0){
//        
//        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择公司、部门、或人员" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        
//        [alertV show] ;
//        
//        
//    } else if (result == NSOrderedDescending ) {
//        
//        JKAlertView * alertV = [[JKAlertView alloc]initWithTitle:@"温馨提示" message:@"您选择的时间不合法" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        
//        [alertV show] ;
//        
//    }else{
//        
//    }
}

// 联系人搜索，可实现汉字搜索，汉语拼音搜索和拼音首字母搜索，
// 输入联系人名称，进行搜索， 返回搜索结果searchResults
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    searchDisplayController
    UIView *topView = searchDisplayController.searchBar.subviews[0];
    
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"确定" forState:UIControlStateNormal];  //@"取消"
        }
    }
    
    searchResults = [[NSMutableArray alloc]init];
    
        if (contactsSearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:contactsSearchBar.text]) {
    
            for (ContactModel *contact in array)
            {
                
                if ([ChineseInclude isIncludeChineseInString:contact.realName]) {
                    NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:contact.realName];
                    NSRange titleResult=[tempPinYinStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length>0) {
                        [searchResults addObject:contact];
                    }
                    else {
                        NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.realName];
                        NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                        if (titleHeadResult.length>0) {
                            [searchResults  addObject:contact];
                        }
                    }
//                    NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:contact.realName];
//                    NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
//                    if (titleHeadResult.length>0) {
//                        [searchResults  addObject:contact];
//                    }
                }
                else {
                    NSRange titleResult=[contact.realName rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                    if (titleResult.length>0) {
                        [searchResults  addObject:contact];
                    }
                }
            }
//            for (NSArray *section in self.searchPeopleArr) {
//                
//            }
        } else if (contactsSearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:contactsSearchBar.text]) {
            for (ContactModel *contact in array)
            {
                NSString *tempStr = contact.realName;
                NSRange titleResult=[tempStr rangeOfString:contactsSearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:contact];
                }
                
            }
//            for (NSArray *section in self.dataSource) {
//                
//            }
        }
    [searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark -- 点击cancell Button 点击事件
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    UIView *topView = searchDisplayController.searchBar.subviews[0];
//    if (self.seType == 1 && SelectPeopleArr.count != 0) {
//        for (UIView *subView in topView.subviews) {
//            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//                UIButton *cancelButton = (UIButton*)subView;
//                //            [cancelButton setTitle:@"确定" forState:UIControlStateNormal];  //@"取消"
//                if ([cancelButton.titleLabel.text isEqualToString:@"确定"]) {
//                    if (SelectPeopleArr.count!=0) {
//                        self.returnNSMutableArrayBlock(SelectPeopleArr);
//                    } else {
//                        NSMutableArray *arr = [NSMutableArray array];
//                        
//                        self.returnNSMutableArrayBlock(arr);
//                    }
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//            }
//        }
//    }
}

// searchbar 点击上浮，完毕复原
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //UIStatusBarStyleBlackTranslucent //UIStatusBarStyleLightContent
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    //准备搜索前，把上面调整的TableView调整回全屏幕的状态
    [UIView animateWithDuration:0.3 animations:^{
        contactsTable.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-NaviHeight-48);
        if (IS_IPHONE_X) {
            contactsTable.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-NaviHeight-48);
        }
    }];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    //搜索结束后，恢复原状
    [UIView animateWithDuration:0.3 animations:^{
        contactsTable.frame = CGRectMake(0, NaviHeight, self.view.bounds.size.width, self.view.bounds.size.height-NaviHeight-48+44);
    }];
    return YES;
}





//实现returnMutableArray 方法
- (void)returnMutableArray:(ReturnNSMutableArrayBlock)block {
    
    self.returnNSMutableArrayBlock = block;
}
//实现returnMutableArray 方法
- (void)returnAvilableMutableArray:(ReturnAvilableNSMutableArrayBlock)block {
    self.returnAvilableNSMutableArrayBlock = block;
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
