//
//  ChoosePeopleViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/31.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ChoosePeopleViewController.h"
#import "LoginPeopleModel.h"
#import "ContactModel.h"
#import "choosePeopleTableViewCell.h"
#import "dept_idModel.h"
@interface ChoosePeopleViewController ()<UITableViewDelegate,UITableViewDataSource>
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
}

@property (nonatomic, strong) NSMutableArray *DaGouArr;
@property (nonatomic, strong) NSMutableArray *totalModel;

@end

@implementation ChoosePeopleViewController
static NSString *contactIDs;
static int tag;
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    tag = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    contactIDs = @"";
    avilableArr = [NSMutableArray array];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOk)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    // Do any additional setup after loading the view.
    if (self.seType == 1) {
        [self setupView];
        SelectPeopleArr = [NSMutableArray array];
        [self requestDataWith:(long)loginModel.jrqMechanismId andName:@""];
    } else if (self.seType == 2) {
        deptModelArr = [NSMutableArray array];
        self.selectType = 0;
        self.selectStatus = 0;
        self.isProductAdd = 0;
        [self setupView];
        self.DaGouArr = [NSMutableArray array];
        self.totalModel = [NSMutableArray array];
        [self requestDataWith:(long)loginModel.jrqMechanismId andName:@""];
    }
}

//加载页面
- (void)setupView {
    contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
    [self.view addSubview:contactsTable];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [contactsTable setTableFooterView:view];
    [contactsTable registerClass:[choosePeopleTableViewCell class] forCellReuseIdentifier:@"cell"];
    contactsTable.delegate = self;
    contactsTable.dataSource = self;
}

#pragma mark -- 数据请求
-(void)requestDataWith:(NSInteger)jrqId andName:(NSString *)string{
//    [sectionNameArr removeAllObjects];
    [MBProgressHUD showMessage:@"正在加载..."];
    [HttpRequestEngine getMechanUsersWithMechId:[NSString stringWithFormat:@"%ld",jrqId] andName:string completion:^(id obj, NSString *errorStr) {
        // 排序
        if (self.seType == 1) {
            personObjectDics = [NSMutableDictionary dictionary];
            if ([(NSMutableArray *)obj count]>0) {
                array = [NSMutableArray array];
                array = obj;
                NSLog(@"self.limitArr == %@",self.limitArr);
                
                NSMutableArray *hehe = [NSMutableArray array];
                for (int i=0; i<array.count; i++) {
                    ContactModel *model = array[i];
                    for (int j=0; j<self.limitArr.count; j++) {
                        ContactModel *jj = self.limitArr[j];
                        if (jj.userId == model.userId) {
                            [hehe addObject:model];
                        }
                    }
                }
                
                NSLog(@"array == %@",array);
                if (self.limited == 1) {
                    [array removeObjectsInArray:hehe];
                    NSLog(@"array == %@",array);
                    for (int i=0; i<array.count; i++) {
                        ContactModel *model = [array objectAtIndex:i];
                        model.tag = i+1;
                        model.isSelected = 0;
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    }
                } else {
                    for (int i=0; i<array.count; i++) {
                        ContactModel *model = [array objectAtIndex:i];
                        model.tag = i+1;
                        model.isSelected = 0;
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    }
                }
                
            }else{
                contactsArr  = [NSMutableArray arrayWithArray:(NSMutableArray *)obj];
            }
            [MBProgressHUD hideHUD];
            [contactsTable reloadData];
        } else if (self.seType == 2) {
            personObjectDics = [NSMutableDictionary dictionary];
            if ([(NSMutableArray *)obj count]>0) {
                array = [NSMutableArray array];
                array = obj;
                for (int i=0; i<array.count; i++) {
                    ContactModel *model = [array objectAtIndex:i];
                    if (self.limited == 2) {
                        model.tag = i+1;
                        model.isSelected = 0;
                        [avilableArr addObject:model];
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    } else {
                        if (model.userId == loginModel.userId) {
                            
                        } else {
                            if (self.limited ==1) {
                                if (model.powerId == (long)nil) {
                                    model.tag = i+1;
                                    model.isSelected = 0;
                                    [avilableArr addObject:model];
                                    NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                                    if (!personArr) {
                                        personArr = [NSMutableArray array];
                                        [personArr addObject:model];
                                        [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                                    }else {
                                        [personArr addObject:model];
                                    }
                                }
                            } else {
                                model.tag = i+1;
                                model.isSelected = 0;
                                [avilableArr addObject:model];
                                NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                                if (!personArr) {
                                    personArr = [NSMutableArray array];
                                    [personArr addObject:model];
                                    [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                                }else {
                                    [personArr addObject:model];
                                }
                                
                            }
                            
                        }
                    }
                    
                    
                }
                
                for (int i=0; i<[personObjectDics allKeys].count; i++) {
                    dept_idModel *dept = [dept_idModel new];
                    dept.isSelected = 0;
                    NSArray *arr = [personObjectDics objectForKey:[personObjectDics allKeys][i]];
                    ContactModel *model = arr[0];
                    dept.dept_Name = model.deptName;
                    dept.dept_tag = i;
                    [deptModelArr addObject:dept];
                }
                
            }else{
                contactsArr  = [NSMutableArray arrayWithArray:(NSMutableArray *)obj];
            }
            [MBProgressHUD hideHUD];
            [contactsTable reloadData];
        }
        
    }];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.seType == 1) {
        return [personObjectDics allKeys].count;
    } else if (self.seType == 2) {
        return [personObjectDics allKeys].count+1;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.seType == 1) {
        for (int i=0; i<[personObjectDics allKeys].count; i++) {
            if (section == i) {
                NSString *string = [personObjectDics allKeys][i];
                NSArray *arr = [personObjectDics objectForKey:string];
                return arr.count;
            }
        }
    } else if (self.seType == 2) {
        if (section == 0) {
            return 0;
        }
        for (int i=0; i<[personObjectDics allKeys].count; i++) {
            if (section == i+1) {
                NSString *string =[NSString stringWithFormat:@"%@",[personObjectDics allKeys][i]];
                NSMutableArray *arr = [NSMutableArray array];
                arr = [personObjectDics objectForKey:string];
                
                return arr.count;
            }
        }
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 30;
    if (self.seType == 1) {
        return 30;
    } else if (self.seType == 2) {
        return 40;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.seType == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        view.backgroundColor = VIEW_BASE_COLOR;
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-20, 30)];
        titleLb.font = [UIFont systemFontOfSize:14];
        for (int i=0; i<[personObjectDics allKeys].count; i++) {
            if (section == i) {
                NSString *string = [personObjectDics allKeys][i];
                NSArray *arr = [personObjectDics objectForKey:string];
                ContactModel *model = arr[0];
                if (!model.deptId) {
                    model.deptName = @"未分配人员";
                }
                titleLb.text = [NSString stringWithFormat:@"部门:%@",model.deptName];
            }
        }
        [view addSubview:titleLb];
        titleLb.center = view.center;
        return view;
    } else if (self.seType == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        view.backgroundColor = VIEW_BASE_COLOR;
        view.tag = section;
        if (section == 0) {
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-40, 20)];
            titleLb.text = @"全选";
            [view addSubview:titleLb];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 7.5, 25, 25);
            [view addSubview:btn];
            btn.selected = self.selectStatus;
            [btn addTarget:self action:@selector(chooseAll:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
        }
        for (int i=0; i<[personObjectDics allKeys].count; i++) {
            if (section == i+1) {
                NSString *string = [personObjectDics allKeys][i];
                NSArray *arr = [personObjectDics objectForKey:string];
                ContactModel *model = arr[0];
                if (!model.deptId) {
                    model.deptName = @"未分配人员";
                }
                UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth-40, 20)];
                titleLb.text = [NSString stringWithFormat:@"部门:%@",model.deptName];
                [view addSubview:titleLb];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view addSubview:btn];
                btn.tag = section*1000;
                btn.frame = CGRectMake(10, 7.5, 25, 25);
                
                dept_idModel *dept_model = deptModelArr[i];
                btn.selected = dept_model.isSelected;
                [btn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"checkbox_pressed"] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(chooseDept:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return view;
    }
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
                            cell.headerImage.image = [UIImage imageNamed:@"选择人员（小头像）"];
                        }else {
                            [cell.headerImage sd_setImageWithURL:[model.iconUrl convertHostUrl]  placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
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
                            cell.headerImage.image = [UIImage imageNamed:@"选择人员（小头像）"];
                        }else {
                            [cell.headerImage sd_setImageWithURL:[model.iconUrl convertHostUrl]  placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
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
#pragma mark -- 点击事件
- (void)choose:(UIButton *)btn {
    if (SelectPeopleArr.count != 0) {
        ContactModel *model = SelectPeopleArr[0];
        model.isSelected = 0;
        [SelectPeopleArr removeAllObjects];
    }
    [personObjectDics removeAllObjects];
    for (int i=0; i<array.count; i++) {
        ContactModel *model = [array objectAtIndex:i];
        
        if (model.tag == btn.tag) {
            model.isSelected = 1;
            [SelectPeopleArr addObject:model];
        }
        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
        if (!personArr) {
            personArr = [NSMutableArray array];
            [personArr addObject:model];
            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
        }else {
            [personArr addObject:model];
        }
    }
    
    [contactsTable reloadData];
    
}

- (void)chooseAvilable:(UIButton *)btn {
    btn.selected = !btn.selected;
    choosePeopleTableViewCell *cell = (choosePeopleTableViewCell *)[btn superview];
    NSIndexPath *indexPath = [contactsTable indexPathForCell:cell];
    
    if (btn.selected) {
        NSLog(@"选中");
        
        [personObjectDics removeAllObjects];
        for (int i=0; i<array.count; i++) {
            ContactModel *model = [array objectAtIndex:i];
            if (self.limited == 2) {
                if (model.userId == loginModel.userId) {
                    if (model.tag == btn.tag) {
                        model.isSelected = 1;
                        //                [SelectPeopleArr addObject:model];
                        [self.DaGouArr addObject:model];
                    }
                    NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                    if (!personArr) {
                        personArr = [NSMutableArray array];
                        [personArr addObject:model];
                        [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                    }else {
                        [personArr addObject:model];
                    }
                } else {
                    
                }
            } else {
                if (self.limited ==1) {
                    if (model.powerId == (long)nil) {
                        if (model.tag == btn.tag) {
                            model.isSelected = 1;
                            //                [SelectPeopleArr addObject:model];
                            [self.DaGouArr addObject:model];
                        }
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    }
                } else {
                    if (model.tag == btn.tag) {
                        model.isSelected = 1;
                        //                [SelectPeopleArr addObject:model];
                        [self.DaGouArr addObject:model];
                    }
                    NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                    if (!personArr) {
                        personArr = [NSMutableArray array];
                        [personArr addObject:model];
                        [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                    }else {
                        [personArr addObject:model];
                    }
                }
            }
            
            
        }
        
        
        NSLog(@"[personObjectDics allKeys] == %@",[personObjectDics allKeys]);
        NSString *string =[NSString stringWithFormat:@"%@",[personObjectDics allKeys][indexPath.section-1]];
        NSMutableArray *arr = [NSMutableArray array];
        arr = [personObjectDics objectForKey:string];
        int j = 0;
        for (int i=0; i<arr.count; i++) {
            ContactModel *model = arr[i];
            if (model.isSelected == 0) {
                
                dept_idModel *dept_id = deptModelArr[indexPath.section-1];
                dept_id.isSelected = 0;
            } else {
                j = j+1;
            }
            if (i == arr.count-1) {
                if (j==arr.count) {
                    dept_idModel *dept_id = deptModelArr[indexPath.section-1];
                    dept_id.isSelected = 1;
                }
            }
        }
    } else {
        NSLog(@"未选中");
        [personObjectDics removeAllObjects];
        for (int i=0; i<array.count; i++) {
            ContactModel *model = [array objectAtIndex:i];
            if (self.limited == 2) {
                if (model.tag == btn.tag) {
                    model.isSelected = 0;
                    //                [SelectPeopleArr addObject:model];
                    [self.DaGouArr removeObject:model];
                }
                NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                if (!personArr) {
                    personArr = [NSMutableArray array];
                    [personArr addObject:model];
                    [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                }else {
                    [personArr addObject:model];
                }
            } else {
                if (model.userId == loginModel.userId) {
                    
                } else {
                    if (self.limited ==1) {
                        if (model.powerId == (long)nil) {
                            if (model.tag == btn.tag) {
                                model.isSelected = 0;
                                //                [SelectPeopleArr addObject:model];
                                [self.DaGouArr removeObject:model];
                            }
                            NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                            if (!personArr) {
                                personArr = [NSMutableArray array];
                                [personArr addObject:model];
                                [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                            }else {
                                [personArr addObject:model];
                            }
                        }
                    } else {
                        if (model.tag == btn.tag) {
                            model.isSelected = 0;
                            //                [SelectPeopleArr addObject:model];
                            [self.DaGouArr removeObject:model];
                        }
                        NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        if (!personArr) {
                            personArr = [NSMutableArray array];
                            [personArr addObject:model];
                            [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                        }else {
                            [personArr addObject:model];
                        }
                    }
                }
            }
        }

        
        dept_idModel *dept_id = deptModelArr[indexPath.section-1];
        dept_id.isSelected = 0;
        NSString *string = [personObjectDics allKeys][indexPath.section-1];
        NSMutableArray *arr = [NSMutableArray array];
        arr = [personObjectDics objectForKey:string];
        

    }
    if (self.DaGouArr.count == avilableArr.count) {
        self.selectStatus = 1;
    } else {
        self.selectStatus = 0;
    }

    [contactsTable reloadData];
}
- (void)chooseAll:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.selectStatus = 1;
//        [deptModelArr removeAllObjects];
        [self.DaGouArr removeAllObjects];
//        [personObjectDics removeAllObjects];
        for (int i = 0; i<[personObjectDics allKeys].count; i++) {
            dept_idModel *model = deptModelArr[i];
            [deptModelArr removeObject:model];
            model.isSelected = 1;
            [deptModelArr insertObject:model atIndex:i];
            NSString *string = [personObjectDics allKeys][i];
            NSArray *arr = [personObjectDics objectForKey:string];
            [personObjectDics removeObjectForKey:string];
            for (int j=0; j<arr.count;j++) {
                ContactModel *model = arr[j];
                model.isSelected = 1;
                [self.DaGouArr addObject:model];
                NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                if (!personArr) {
                    personArr = [NSMutableArray array];
                    [personArr addObject:model];
                    [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                }else {
                    [personArr addObject:model];
                }
            }
            
        }
        
    } else {
        self.selectStatus = 0;
//        [deptModelArr removeAllObjects];
        [self.DaGouArr removeAllObjects];
        for (int i = 0; i<[personObjectDics allKeys].count; i++) {
            dept_idModel *model = deptModelArr[i];
            [deptModelArr removeObject:model];
            model.isSelected = 0;
            
            [deptModelArr insertObject:model atIndex:i];
            NSString *string = [personObjectDics allKeys][i];
            NSArray *arr = [personObjectDics objectForKey:string];
            [personObjectDics removeObjectForKey:string];
            for (int j=0; j<arr.count;j++) {
                ContactModel *model = arr[j];
                model.isSelected = 0;
                [self.DaGouArr removeObject:model];
                NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                if (!personArr) {
                    personArr = [NSMutableArray array];
                    [personArr addObject:model];
                    [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
                }else {
                    [personArr addObject:model];
                }
            }
            
        }
    }
    [contactsTable reloadData];
}
- (void)chooseDept:(UIButton *)btn {
    UIView *view = [btn superview];
    btn.selected = !btn.selected;
    NSInteger index = view.tag-1;
//    NSLog(@"%ld",view.tag);
    if (btn.selected) {
        dept_idModel *dept_id = deptModelArr[index];
        dept_id.isSelected = 1;
        NSString *string = [personObjectDics allKeys][index];
        NSArray *arr = [personObjectDics objectForKey:string];
//        NSLog(@"arr = %@",arr);
        [personObjectDics removeObjectForKey:string];
//        NSLog(@"personObjectDics == %@",personObjectDics);
        for (int j=0; j<arr.count;j++) {
            ContactModel *model = arr[j];
            model.isSelected = 1;
            [self.DaGouArr addObject:model];
            NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
            if (!personArr) {
                personArr = [NSMutableArray array];
                [personArr addObject:model];
                [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
            }else {
                [personArr addObject:model];
            }
        }
        
        
//        NSLog(@"personObjectDics == %@",personObjectDics);
    } else {
        dept_idModel *dept_id = deptModelArr[index];
        dept_id.isSelected = 0;
        NSString *string = [personObjectDics allKeys][index];
        NSArray *arr = [personObjectDics objectForKey:string];
        [personObjectDics removeObjectForKey:string];
        for (int j=0; j<arr.count;j++) {
            ContactModel *model = arr[j];
            model.isSelected = 0;
            [self.DaGouArr removeObject:model];
            NSMutableArray * personArr = [personObjectDics objectForKey:[NSString stringWithFormat:@"%ld",model.deptId]];
            if (!personArr) {
                personArr = [NSMutableArray array];
                [personArr addObject:model];
                [personObjectDics setObject:personArr forKey:[NSString stringWithFormat:@"%ld",model.deptId]];
            }else {
                [personArr addObject:model];
            }
        }
        
    }
    if (self.DaGouArr.count == avilableArr.count) {
        self.selectStatus = 1;
    } else {
        self.selectStatus = 0;
    }
    [contactsTable reloadData];
}
- (void)ClickOk {
    if (self.seType == 1) {
        if (self.returnNSMutableArrayBlock != nil) {
            if (SelectPeopleArr.count!=0) {
                self.returnNSMutableArrayBlock(SelectPeopleArr);
            } else {
                NSMutableArray *arr = [NSMutableArray array];
                
                self.returnNSMutableArrayBlock(arr);
            }
            [self.navigationController popViewControllerAnimated:YES];
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
