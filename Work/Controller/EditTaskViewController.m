//
//  EditTaskViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditTaskViewController.h"
#import "EditTypeAndNameTableViewCell.h"
#import "EditPeopleAndTimeTableViewCell.h"
#import "RemoveTableViewCell.h"
#import "EditTypeTableViewCell.h"
#import "EditNameTableViewCell.h"
#import "EditJoinPeopleTableViewCell.h"
#import "TaskListModel.h"
#import "powerUserModel.h"
#import "productModel.h"
#import "ProductManageViewController.h"
#import "completionStatusTableViewCell.h"
#import "ContactDetailsViewController.h"
@interface EditTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *editTaskTableView;
@property (nonatomic, strong) NSArray *TyptArr;
@property (nonatomic, strong) NSArray *ImageArr;
@property (nonatomic, strong) NSMutableArray *taskUserArr;
@property (nonatomic, strong) NSDictionary *requsetDic;
@property (nonatomic, strong) NSMutableArray *taskMechProNameArr;
@property (nonatomic, strong) NSMutableArray *taskMechProIDArr;
@property (nonatomic, strong) NSMutableArray *taskInfoArr;
@property (nonatomic, strong) NSMutableArray *avilableNameArr;//可用人员名字
@property (nonatomic, strong) NSMutableArray *avilableIconArr;//可用人员头像
@property (nonatomic, strong) NSMutableArray *oldAvilableArr;//存储旧的可用人员
@property (nonatomic, strong) NSMutableArray *avilablePersonNameArr;
@property (nonatomic, strong) NSMutableArray *avilablePersonImageArr;
@property (nonatomic, strong) NSArray *returnIDArray;//从产品列表返回的产品ID数组
@property (nonatomic, strong) NSArray *returnNameArray;//从产品列表返回的产品Name数组
@property (nonatomic, strong) NSMutableArray *peopleArr;
@end

@implementation EditTaskViewController
static NSString *MechProName;
/*
 NSDictionary *parameters = @{@"inter": @"updTask",@"id":[NSString stringWithFormat:@"%@",self.model.ID],@"name":self.rightName,@"count":funid,@"personId":peoplestr,@"cuserId":peoplestr,@"content":peoplestr,@"stopTime":peoplestr,@"uid":peoplestr,@"mechProId":peoplestr};
 */
static NSString *name;
static NSString *count;
static NSString *personId;
static NSString *cuserId;
static NSString *content;
static NSString *stopTime;
static NSString *uid;
static NSString *mechProId;

- (UITableView *)editTaskTableView {
    if (!_editTaskTableView) {
        _editTaskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        if (self.ishideNaviView) {
            _editTaskTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight);
        }
        _editTaskTableView.backgroundColor = VIEW_BASE_COLOR;
    }
    return _editTaskTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MechProName = @"";
    name = @"";
    count = @"";
    personId = @"";
    cuserId = @"";
    content = @"";
    stopTime = @"";
    uid = @"";
    mechProId = @"";
    if (self.returnNameArray.count == 0) {
        MechProName = @"";
    }
    for (int i=0; i<self.returnNameArray.count ; i++) {
//        powerUserModel *model = self.powerUserArr[i];
        if (i == 0 ) {
            MechProName = self.returnNameArray[0];
        } else if (i!=0) {
            MechProName = [NSString stringWithFormat:@"%@,%@",MechProName,self.returnNameArray[i]];
        }
//        [self.editTaskTableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.avilableIconArr = [NSMutableArray array];
    self.avilableNameArr = [NSMutableArray array];
    self.oldAvilableArr = [NSMutableArray array];
    [self.touchViewArr addObject:self.editTaskTableView];
    if (self.seType == 1) {
        self.navigationItem.title = @"任务详情";
        self.view.backgroundColor = VIEW_BASE_COLOR;
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        self.peopleArr = [NSMutableArray array];
        [self setupView];
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)setupView {
//    TaskListModel *model = self.model;
    self.TyptArr = [NSArray arrayWithObjects:@"任务类型",@"任务名称",@"意向客户",@"订单数量",@"指定产品",@"任务内容",@"负责人",@"开始时间",@"截止时间",@"参与人", nil];
    self.ImageArr = [NSArray arrayWithObjects:@"负责人icon",@"截止时间",@"参与人icon", nil];
    self.editTaskTableView.delegate = self;
    self.editTaskTableView.dataSource = self;
    [self.editTaskTableView registerClass:[EditTypeAndNameTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.editTaskTableView registerClass:[EditNameTableViewCell class] forCellReuseIdentifier:@"name"];
    [self.editTaskTableView registerClass:[EditPeopleAndTimeTableViewCell class] forCellReuseIdentifier:@"people"];
    [self.editTaskTableView registerClass:[EditJoinPeopleTableViewCell class] forCellReuseIdentifier:@"join"];
    [self.editTaskTableView registerClass:[EditTypeTableViewCell class] forCellReuseIdentifier:@"type"];
    [self.editTaskTableView registerClass:[RemoveTableViewCell class] forCellReuseIdentifier:@"remove"];
    [self.editTaskTableView registerClass:[completionStatusTableViewCell class] forCellReuseIdentifier:@"status"];
    [self.view addSubview:self.editTaskTableView];
    self.editTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#pragma mark === 获取任务详情
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parameters = @{@"inter":@"taskInfo",@"taskId":[NSString stringWithFormat:@"%@",self.model.ID]};
    [manager.requestSerializer setTimeoutInterval:5.0f];
    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject;
        NSLog(@"data == %@",data);
        self.requsetDic = [NSDictionary changeType:data];
        self.taskUserArr = [NSMutableArray array];
        self.taskMechProIDArr = [NSMutableArray array];
        self.taskMechProNameArr = [NSMutableArray array];
        self.taskInfoArr = [NSMutableArray array];
        if (!self.requsetDic) {
            [MBProgressHUD showError:@"数据请求出错"];
        } else {
            NSArray *taskUser = self.requsetDic[@"taskUser"];
            //获取可用人员数据
            for (int i = 0; i < taskUser.count; i++) {
                NSDictionary *dic = taskUser[i];
                powerUserModel *powerUser = [powerUserModel new];
                powerUser.ID = dic[@"id"];
                powerUser.real_name = dic[@"real_name"];
                powerUser.count = [NSString stringWithFormat:@"%@",dic[@"count"]];
                powerUser.state = [NSString stringWithFormat:@"%@",dic[@"state"]];
                NSString *icon = dic[@"icon"];

                powerUser.icon = icon;
                [self.taskUserArr addObject:powerUser];
                NSString *name = dic[@"real_name"];

                [self.avilableNameArr addObject:name];
                
                [self.avilableIconArr addObject:icon];
                [self.peopleArr addObject:powerUser];
            }
            
            NSArray *taskMechPro = self.requsetDic[@"taskMechPro"];
            for (int i=0; i < taskMechPro.count; i++) {
                NSDictionary *task = taskMechPro[i];
                productModel *model = [productModel new];
                model.ID = [NSString stringWithFormat:@"%@",task[@"id"]];
                model.mechanName = [NSString stringWithFormat:@"%@",task[@"name"]];
                [self.taskMechProIDArr addObject:model];
                NSString *name = [NSString stringWithFormat:@"%@",task[@"name"]];
                [self.taskMechProNameArr addObject:name];
            }
            NSDictionary *taskInfo = self.requsetDic[@"taskInfo"];
            TaskListModel *taskInfoModel = [TaskListModel new];
            taskInfoModel.content = taskInfo[@"content"];
            taskInfoModel.ID = taskInfo[@"id"];
            taskInfoModel.cpId = taskInfo[@"cpId"];
            uid = [NSString stringWithFormat:@"%@",taskInfo[@"cpId"]];
            taskInfoModel.createTime = taskInfo[@"createTime"];
            taskInfoModel.count = [NSString stringWithFormat:@"%@",taskInfo[@"count"]];
            taskInfoModel.cpName = taskInfo[@"cpName"];
            taskInfoModel.name = taskInfo[@"name"];
            taskInfoModel.personId = taskInfo[@"personId"];
            taskInfoModel.type = taskInfo[@"type"];
            taskInfoModel.personName = taskInfo[@"personName"];
            taskInfoModel.stopTime = taskInfo[@"stopTime"];
            taskInfoModel.startTime = taskInfo[@"createTime"];
            taskInfoModel.dxState = [NSString stringWithFormat:@"%@",taskInfo[@"dxState"]];
            self.model = taskInfoModel;
            [self.taskInfoArr addObject:taskInfoModel];
            [self.editTaskTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch ([[NSString stringWithFormat:@"%@",self.model.type] integerValue]) {
        case 3:
            switch (section) {
                case 0:
                    return 3;
                    break;
                case 1:
                    return 5;
                    break;
                case 2:
                    if (self.isDelTask) {
                        return self.taskUserArr.count+3;
                    } else {
                        return self.taskUserArr.count+2;
                    }
                    
                    break;
                default:
                    return 0;
                    break;
            }

            break;
        case 2:
            switch (section) {
                case 0:
                    return 5;
                    break;
                case 1:
                    return 5;
                    break;
                case 2:
                    if (self.isDelTask) {
                        return self.taskUserArr.count+3;
                    } else {
                        return self.taskUserArr.count+2;
                    }
                    
                    break;
                default:
                    return 0;
                    break;
            }

            break;
        case 1:
            switch (section) {
                case 0:
                    return 5;
                    break;
                case 1:
                    return 5;
                    break;
                case 2:
                    if (self.isDelTask) {
                        return self.taskUserArr.count+3;
                    } else {
                        return self.taskUserArr.count+2;
                    }
                    
                    break;
                default:
                    return 0;
                    break;
            }

            break;
        
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch ([[NSString stringWithFormat:@"%@",self.model.type] integerValue]) {
        case 3:
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return 50*KAdaptiveRateWidth;
                } else if (indexPath.row == 1) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 2) {
                    TaskListModel *Model = self.taskInfoArr[0];
                    NSString *content = Model.content;
                    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth - 24*KAdaptiveRateWidth];
//                    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth - 24*KAdaptiveRateWidth, MAXFLOAT)];
                    
                    if (height > 120) {
                        return 37*KAdaptiveRateWidth+height;
                    } else {
                        return 37*KAdaptiveRateWidth+120;
                    }
                    
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 1) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 2) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 3) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 4) {
                    if ((self.avilableNameArr.count)%5) {
                        return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
                    }
                    return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5)+10;
                }
            } else if (indexPath.section == 2) {
                if (self.isDelTask) {
                    if (indexPath.row == self.taskUserArr.count+2) {
                        return 60*KAdaptiveRateWidth;
                    } else {
                        return 25;
                    }
                } else {
                    return 25;
                }
            }

            break;
        case 2:
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 1) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 2) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 3) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 4) {
//                    return 112*KAdaptiveRateHeight;
                    TaskListModel *Model = self.taskInfoArr[0];
                    NSString *content = Model.content;
//                    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth - 24*KAdaptiveRateWidth, MAXFLOAT)];
                    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth - 24*KAdaptiveRateWidth];
                    if (height > 120) {
                        return 37*KAdaptiveRateWidth+height;
                    } else {
                        return 37*KAdaptiveRateWidth+120;
                    }
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 1) {
                    return 44*KAdaptiveRateWidth;
                } else if (indexPath.row == 2) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 3) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 4) {
                    if ((self.avilableNameArr.count)%5) {
                        return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
                    }
                    return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5)+10;
                }
            } else if (indexPath.section == 2) {
                if (self.isDelTask) {
                    if (indexPath.row == self.taskUserArr.count+2) {
                        return 60*KAdaptiveRateWidth;
                    } else {
                        return 25;
                    }
                } else {
                    return 25;
                }

            }

            break;
        case 1:
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    return 50*KAdaptiveRateWidth;
                } else if (indexPath.row == 1) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 2) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 3) {
                    return 50*KAdaptiveRateWidth;
                }else if (indexPath.row == 4) {

                    TaskListModel *Model = self.taskInfoArr[0];
                    NSString *content = Model.content;
//                    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth - 24*KAdaptiveRateWidth, MAXFLOAT)];
                    CGFloat height = [content heightWithFont:[UIFont systemFontOfSize:16] constrainedToWidth:kScreenWidth - 24*KAdaptiveRateWidth];
                    if (height > 120) {
                        return 37*KAdaptiveRateWidth+height;
                    } else {
                        return 37*KAdaptiveRateWidth+120;
                    }
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 0) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 1) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 2) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 3) {
                    return 44*KAdaptiveRateWidth;
                }else if (indexPath.row == 4) {
                    
                    if ((self.avilableNameArr.count)%5) {
                        return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
                    }
                    return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5)+10;
                }
            } else if (indexPath.section == 2) {
                if (self.isDelTask) {
                    if (indexPath.row == self.taskUserArr.count+2) {
                        return 60*KAdaptiveRateWidth;
                    } else {
                        return 25;
                    }
                } else {
                    return 25;
                }
            }
            break;
        
    }
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1||section == 2) {
        return 12;
    }
    return 12;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView beginUpdates];
//    [tableView endUpdates];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hh"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hh"];
//    }
#pragma mark == 普通任务
    if ([[NSString stringWithFormat:@"%@",self.model.type] isEqualToString:@"3"]) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TyptArr[0];
                cell.TypeNameLb.text = @"普通任务";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 1) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                TaskListModel *Model = self.taskInfoArr[0];
                cell.TypeLb.text = self.TyptArr[1];
                cell.NameTF.text = Model.name;
                cell.NameTF.placeholder = @"输入任务名称";
                cell.NameTF.userInteractionEnabled = NO;
                cell.NameTF.clearButtonMode = UITextFieldViewModeNever;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 2) {
                EditTypeAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.TypeLb.text = self.TyptArr[5];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentTv.text = Model.content;
                cell.contentTv.userInteractionEnabled = NO;
                cell.uibutton.hidden = YES;
                if (cell.contentTv.text.length != 0) {
                    cell.placeholderLb.hidden = YES;
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[0]];
                cell.TypeNameLb.text = self.TyptArr[6];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.personName;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }else if (indexPath.row == 1) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TyptArr[7];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.startTime;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else if (indexPath.row == 2) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TyptArr[8];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.stopTime;
                //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else if (indexPath.row == 3) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                cell.TypeNameLb.text = self.TyptArr[9];
                cell.separetor.hidden = YES;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            } else if (indexPath.row == 4) {
                EditJoinPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"join" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditJoinPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"join"];
                }
                //    cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                //    cell.TypeNameLb.text = self.TyptArr[7];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.avilablePersonNameArr = [NSMutableArray array];
                [self.avilablePersonNameArr addObjectsFromArray:self.avilableNameArr];

                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObjectsFromArray:self.avilableIconArr];

                
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
                for (int i = 0; i < self.avilablePersonImageArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+2000;
                    
                    [cell addSubview:btn];
                    
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (55*KAdaptiveRateWidth+10)+10);
                        make.left.equalTo(cell.mas_left).offset(i%5 * (55*KAdaptiveRateWidth + 7.5*KAdaptiveRateWidth)+7.5*KAdaptiveRateWidth);
                        make.width.mas_equalTo(55*KAdaptiveRateWidth);
                        make.height.mas_equalTo(55*KAdaptiveRateWidth);
                    }];
                    
                    UIImageView *imageV = [[UIImageView alloc]init];
                    imageV.layer.masksToBounds = YES;
                    [imageV.layer setCornerRadius:21*KAdaptiveRateWidth];
                    [btn addSubview:imageV];
                    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                        make.centerX.equalTo(btn.mas_centerX);
                        make.height.mas_equalTo(42*KAdaptiveRateWidth);
                        make.width.mas_equalTo(42*KAdaptiveRateWidth);
                    }];
                    NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                    NSURL *imageURL = [NSURL URLWithString:imagePath];
                    [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                    }];
                    
                    UILabel *label = [[UILabel alloc]init];
                    [btn addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:11];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(btn.mas_bottom);
                        make.left.equalTo(btn.mas_left).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(11);
                    }];
                    label.text = self.avilablePersonNameArr[i];
                    
                    
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            }
        } else if (indexPath.section == 2) {
            
            if (indexPath.row == self.taskUserArr.count+2) {
                RemoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remove" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[RemoveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remove"];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.removeBtn setTitle:@"删除任务" forState:UIControlStateNormal];
                [cell.removeBtn addTarget:self action:@selector(removeRight:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            } else {
                
                if (indexPath.row == 0) {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = YES;
                    cell.bottomSeparatoerLine.hidden = YES;
                    cell.leftSeparatoerLine.hidden = YES;
                    cell.rightSeparatoerLine.hidden = YES;
                    cell.titleLb.hidden = NO;
                    cell.titleLb.text = @"参与人完成任务情况:";
                    cell.statusLb.hidden = YES;
                    cell.countLb.hidden = YES;
                    cell.nameLb.hidden = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else if (indexPath.row == 1) {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = NO;
                    cell.bottomSeparatoerLine.hidden = NO;
                    cell.leftSeparatoerLine.hidden = NO;
                    cell.rightSeparatoerLine.hidden = NO;
                    cell.titleLb.hidden = YES;
                    cell.statusLb.hidden = NO;
                    cell.countLb.hidden = NO;
                    cell.nameLb.hidden = NO;
                    cell.nameLb.text = @"参与人";
                    cell.nameLb.textColor = [UIColor blackColor];
                    cell.statusLb.text = @"状态";
                    cell.statusLb.textColor = [UIColor blackColor];
                    cell.countLb.text = @"完成数量";
                    cell.countLb.textColor = [UIColor blackColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = NO;
                    cell.bottomSeparatoerLine.hidden = NO;
                    cell.leftSeparatoerLine.hidden = NO;
                    cell.rightSeparatoerLine.hidden = NO;
                    cell.titleLb.hidden = YES;
                    cell.statusLb.hidden = NO;
                    cell.countLb.hidden = NO;
                    cell.nameLb.hidden = NO;
                    powerUserModel *model = self.taskUserArr[indexPath.row - 2];
                    cell.nameLb.text = model.real_name;
                    cell.nameLb.textColor = [UIColor grayColor];
                    if ([model.state isEqualToString:@"1"]) {
                        [cell.statusLb setTextColor:[UIColor grayColor]];
                        cell.statusLb.text = @"未完成";
                    } else {
                        [cell.statusLb setTextColor:[UIColor redColor]];
                        cell.statusLb.text = @"完成";
                    }
                    cell.countLb.text = model.count;
                    cell.countLb.textColor = [UIColor grayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        }
#pragma mark == CRM任务
    } else if ([[NSString stringWithFormat:@"%@",self.model.type] isEqualToString:@"2"]) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TyptArr[0];
                
                cell.TypeNameLb.text = @"CRM任务";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 1) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = @"细化类型";
                NSString *dxState;
                switch ([self.model.dxState integerValue]) {
                    case 1:
                        dxState = @"待处理";
                        break;
                    case 2:
                        dxState = @"邀约中";
                        break;
                    case 3:
                        dxState = @"已到访";
                        break;
                    case 4:
                        dxState = @"办理中";
                        break;
                    case 5:
                        dxState = @"新建CRM";
                        break;
                }
                cell.TypeNameLb.text = dxState;
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 2) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TyptArr[1];
                cell.NameTF.text = self.model.name;
                cell.NameTF.userInteractionEnabled = NO;
                cell.NameTF.clearButtonMode = UITextFieldViewModeNever;
                cell.NameTF.placeholder = @"输入任务名称";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 3) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TyptArr[2];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.NameTF.text = Model.count;
                cell.NameTF.placeholder = @"输入意向客户数量";
                cell.NameTF.userInteractionEnabled = NO;
                cell.NameTF.clearButtonMode = UITextFieldViewModeNever;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 4) {
                EditTypeAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.TypeLb.text = self.TyptArr[5];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentTv.text = Model.content;
                cell.contentTv.userInteractionEnabled = NO;
                cell.uibutton.hidden = YES;
                if (cell.contentTv.text.length != 0) {
                    cell.placeholderLb.hidden = YES;
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[0]];
                cell.TypeNameLb.text = self.TyptArr[6];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.personName;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 1) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TyptArr[7];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.startTime;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else if (indexPath.row == 2) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TyptArr[8];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.stopTime;
                //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else if (indexPath.row == 3) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                cell.TypeNameLb.text = self.TyptArr[9];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.separetor.hidden = YES;
                return cell;
                
            } else if (indexPath.row == 4) {
                EditJoinPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"join" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditJoinPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"join"];
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.avilablePersonNameArr = [NSMutableArray array];
                [self.avilablePersonNameArr addObjectsFromArray:self.avilableNameArr];
                

                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObjectsFromArray:self.avilableIconArr];

                
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
                for (int i = 0; i < self.avilablePersonImageArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+2000;
                    
                    [cell addSubview:btn];
                    
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (55*KAdaptiveRateWidth+10)+10);
                        make.left.equalTo(cell.mas_left).offset(i%5 * (55*KAdaptiveRateWidth + 7.5*KAdaptiveRateWidth)+7.5*KAdaptiveRateWidth);
                        make.width.mas_equalTo(55*KAdaptiveRateWidth);
                        make.height.mas_equalTo(55*KAdaptiveRateWidth);
                    }];
                    UIImageView *imageV = [[UIImageView alloc]init];
                    [btn addSubview:imageV];
                    imageV.layer.masksToBounds = YES;
                    [imageV.layer setCornerRadius:21*KAdaptiveRateWidth];
                    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                        make.centerX.equalTo(btn.mas_centerX);
                        make.height.mas_equalTo(42*KAdaptiveRateWidth);
                        make.width.mas_equalTo(42*KAdaptiveRateWidth);
                    }];
                    
                    NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                    NSURL *imageURL = [NSURL URLWithString:imagePath];
                    [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"]];
                    UILabel *label = [[UILabel alloc]init];
                    [btn addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:11];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(btn.mas_bottom);
                        make.left.equalTo(btn.mas_left).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(11);
                    }];
                    label.text = self.avilablePersonNameArr[i];
                    

                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            }
        }else if (indexPath.section == 2) {
            if (indexPath.row == self.taskUserArr.count+2) {
                RemoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remove" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[RemoveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remove"];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.removeBtn setTitle:@"删除任务" forState:UIControlStateNormal];
                [cell.removeBtn addTarget:self action:@selector(removeRight:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            } else {
                
                if (indexPath.row == 0) {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = YES;
                    cell.bottomSeparatoerLine.hidden = YES;
                    cell.leftSeparatoerLine.hidden = YES;
                    cell.rightSeparatoerLine.hidden = YES;
                    cell.titleLb.hidden = NO;
                    cell.titleLb.text = @"参与人完成任务情况:";
                    cell.statusLb.hidden = YES;
                    cell.countLb.hidden = YES;
                    cell.nameLb.hidden = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else if (indexPath.row == 1) {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = NO;
                    cell.bottomSeparatoerLine.hidden = NO;
                    cell.leftSeparatoerLine.hidden = NO;
                    cell.rightSeparatoerLine.hidden = NO;
                    cell.titleLb.hidden = YES;
                    cell.statusLb.hidden = NO;
                    cell.countLb.hidden = NO;
                    cell.nameLb.hidden = NO;
                    cell.nameLb.text = @"参与人";
                    cell.nameLb.textColor = [UIColor blackColor];
                    cell.statusLb.text = @"状态";
                    cell.statusLb.textColor = [UIColor blackColor];
                    cell.countLb.text = @"完成数量";
                    cell.countLb.textColor = [UIColor blackColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = NO;
                    cell.bottomSeparatoerLine.hidden = NO;
                    cell.leftSeparatoerLine.hidden = NO;
                    cell.rightSeparatoerLine.hidden = NO;
                    cell.titleLb.hidden = YES;
                    cell.statusLb.hidden = NO;
                    cell.countLb.hidden = NO;
                    cell.nameLb.hidden = NO;
                    powerUserModel *model = self.taskUserArr[indexPath.row - 2];
                    cell.nameLb.text = model.real_name;
                    cell.nameLb.textColor = [UIColor grayColor];
                    if ([model.state isEqualToString:@"1"]) {
                        [cell.statusLb setTextColor:[UIColor grayColor]];
                        cell.statusLb.text = @"未完成";
                    } else {
                        [cell.statusLb setTextColor:[UIColor redColor]];
                        cell.statusLb.text = @"完成";
                    }
                    cell.countLb.text = model.count;
                    cell.countLb.textColor = [UIColor grayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            }
        }
#pragma mark == 销售任务
    } else if ([[NSString stringWithFormat:@"%@",self.model.type] isEqualToString:@"1"]) {
        if (indexPath.section != 1 && indexPath.row != 2) {
            
        }
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TyptArr[0];
                
                cell.TypeNameLb.text = @"销售任务";
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                return cell;
            }
            else if (indexPath.row == 1) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TyptArr[1];
                cell.NameTF.text = self.model.name;
                cell.NameTF.placeholder = @"输入任务名称";
                cell.NameTF.userInteractionEnabled = NO;
                cell.NameTF.clearButtonMode = UITextFieldViewModeNever;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 2) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TyptArr[3];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.NameTF.text = Model.count;
                cell.NameTF.placeholder = @"输入订单数量";
                cell.NameTF.userInteractionEnabled = NO;
                cell.NameTF.clearButtonMode = UITextFieldViewModeNever;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                return cell;
            }
            else if (indexPath.row == 3) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TyptArr[4];
                if (self.returnNameArray && self.returnIDArray) {
                    cell.TypeNameLb.text = MechProName;
                } else {
                    if (self.taskMechProNameArr.count == 1) {
                        MechProName = self.taskMechProNameArr[0];
                    } else {
                    
                        for (int i = 0; i < self.taskMechProNameArr.count; i++) {
                            if (i == 0 ) {
                                MechProName = self.taskMechProNameArr[0];
                            } else if (i!=0) {
                                MechProName = [NSString stringWithFormat:@"%@、%@",MechProName,self.taskMechProNameArr[i]];
                            }
                        }
                    }
                    
                    cell.TypeNameLb.text = MechProName;
                }
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else if (indexPath.row == 4) {
                EditTypeAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                
                cell.TypeLb.text = self.TyptArr[5];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentTv.text = Model.content;
                cell.contentTv.userInteractionEnabled = NO;
                cell.uibutton.hidden = YES;
                if (cell.contentTv.text.length != 0) {
                    cell.placeholderLb.hidden = YES;
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[0]];
                cell.TypeNameLb.text = self.TyptArr[6];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.personName;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 1) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TyptArr[7];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.startTime;
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else if (indexPath.row == 2) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TyptArr[8];
                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = Model.stopTime;
                //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
                
            }else if (indexPath.row == 3) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                cell.TypeNameLb.text = self.TyptArr[9];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.separetor.hidden = YES;
                return cell;
                
            } else if (indexPath.row == 4) {
                EditJoinPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"join" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditJoinPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"join"];
                }
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.avilablePersonNameArr = [NSMutableArray array];
                [self.avilablePersonNameArr addObjectsFromArray:self.avilableNameArr];
                

                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObjectsFromArray:self.avilableIconArr];

                
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
                for (int i = 0; i < self.avilablePersonImageArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+2000;
                    
                    [cell addSubview:btn];
                    
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (55*KAdaptiveRateWidth+10)+10);
                        make.left.equalTo(cell.mas_left).offset(i%5 * (55*KAdaptiveRateWidth + 7.5*KAdaptiveRateWidth)+7.5*KAdaptiveRateWidth);
                        make.width.mas_equalTo(55*KAdaptiveRateWidth);
                        make.height.mas_equalTo(55*KAdaptiveRateWidth);
                    }];
                    UIImageView *imageV = [[UIImageView alloc]init];
                    [btn addSubview:imageV];
                    imageV.layer.masksToBounds = YES;
                    [imageV.layer setCornerRadius:21*KAdaptiveRateWidth];
                    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                        make.centerX.equalTo(btn.mas_centerX);
                        make.height.mas_equalTo(42*KAdaptiveRateWidth);
                        make.width.mas_equalTo(42*KAdaptiveRateWidth);
                    }];
                    
                    NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                    NSURL *imageURL = [NSURL URLWithString:imagePath];
                    [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"]];
                    UILabel *label = [[UILabel alloc]init];
                    [btn addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:11];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(btn.mas_bottom);
                        make.left.equalTo(btn.mas_left).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(11);
                    }];
                    label.text = self.avilablePersonNameArr[i];
                    
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            }
        }else if (indexPath.section == 2) {
            if (indexPath.row == self.taskUserArr.count+2) {
                RemoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remove" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[RemoveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remove"];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.removeBtn setTitle:@"删除任务" forState:UIControlStateNormal];
                [cell.removeBtn addTarget:self action:@selector(removeRight:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            } else {
                
                if (indexPath.row == 0) {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = YES;
                    cell.bottomSeparatoerLine.hidden = YES;
                    cell.leftSeparatoerLine.hidden = YES;
                    cell.rightSeparatoerLine.hidden = YES;
                    cell.titleLb.hidden = NO;
                    cell.titleLb.text = @"参与人完成任务情况:";
                    cell.statusLb.hidden = YES;
                    cell.countLb.hidden = YES;
                    cell.nameLb.hidden = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else if (indexPath.row == 1) {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = NO;
                    cell.bottomSeparatoerLine.hidden = NO;
                    cell.leftSeparatoerLine.hidden = NO;
                    cell.rightSeparatoerLine.hidden = NO;
                    cell.titleLb.hidden = YES;
                    cell.statusLb.hidden = NO;
                    cell.countLb.hidden = NO;
                    cell.nameLb.hidden = NO;
                    cell.nameLb.text = @"参与人";
                    cell.nameLb.textColor = [UIColor blackColor];
                    cell.statusLb.text = @"状态";
                    cell.statusLb.textColor = [UIColor blackColor];
                    cell.countLb.text = @"完成数量";
                    cell.countLb.textColor = [UIColor blackColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                } else {
                    completionStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"status" forIndexPath:indexPath];
                    if (!cell) {
                        cell = [[completionStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
                    }
                    cell.topSeparatoerLine.hidden = NO;
                    cell.bottomSeparatoerLine.hidden = NO;
                    cell.leftSeparatoerLine.hidden = NO;
                    cell.rightSeparatoerLine.hidden = NO;
                    cell.titleLb.hidden = YES;
                    cell.statusLb.hidden = NO;
                    cell.countLb.hidden = NO;
                    cell.nameLb.hidden = NO;
                    powerUserModel *model = self.taskUserArr[indexPath.row - 2];
                    cell.nameLb.text = model.real_name;
                    cell.nameLb.textColor = [UIColor grayColor];
                    if ([model.state isEqualToString:@"1"]) {
                        [cell.statusLb setTextColor:[UIColor grayColor]];
                        cell.statusLb.text = @"未完成";
                    } else {
                        [cell.statusLb setTextColor:[UIColor redColor]];
                        cell.statusLb.text = @"完成";
                    }
                    cell.countLb.text = model.count;
                    cell.countLb.textColor = [UIColor grayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                
            }
        }
        
    }
    return nil;
}
#pragma mark -- 所有的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            
            if ([[NSString stringWithFormat:@"%@",self.model.type] isEqualToString:@"1"]) {
                ProductManageViewController *product = [ProductManageViewController new];
                product.seType = 4;
                product.limit = 1;
                product.limitArr = self.taskMechProIDArr;
                [self.navigationController pushViewController:product animated:YES];
            }
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
        }
    }
}
- (void)BtnClick:(UIButton *)Btn {
    if (Btn.tag%2000 == self.avilableIconArr.count) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            powerUserModel *model = [powerUserModel new];
            model.icon = @"/usericon/uic1449551822974.jpg";
            model.ID = @"12";
            model.real_name = @"测试";
            [self.avilableIconArr removeAllObjects];
            [self.avilableNameArr removeAllObjects];
            [self.taskUserArr insertObject:model atIndex:self.taskUserArr.count];
            //获取可用人员数据
            for (int i = 0; i < self.taskUserArr.count; i++) {
                powerUserModel *powerUser = self.taskUserArr[i];
                NSString *name = powerUser.real_name;
                if ([name isEqualToString:@""]) {
                    name = @"测试";
                }
                [self.avilableNameArr addObject:name];
                NSString *icon = @"聊天头像";

                [self.avilableIconArr addObject:icon];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//                [self.editTaskTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [self.editTaskTableView reloadData];
            });
        });
    }
    NSInteger index = Btn.tag%2000;
    powerUserModel *model = self.peopleArr[index];
    ContactDetailsViewController * cdVC = [[ContactDetailsViewController alloc]init];
    cdVC.uid = [NSString stringWithFormat:@"%@", model.ID];
    cdVC.setype = 3;
    [self.navigationController pushViewController:cdVC animated:YES];
    
}
- (void)deleteBtnClick:(UIButton *)Btn {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //获取可用人员数据
        
        NSLog(@"sup.tag == %ld",Btn.tag);
        
        [self.taskUserArr removeObjectAtIndex:Btn.tag%1000];
        [self.avilableNameArr removeAllObjects];
        [self.avilableIconArr removeAllObjects];
        for (int i = 0; i < self.taskUserArr.count; i++) {
            powerUserModel *powerUser = self.taskUserArr[i];
            NSString *name = powerUser.real_name;
            if ([name isEqualToString:@""]) {
                name = @"测试";
            }
            [self.avilableNameArr addObject:name];
            NSString *icon = @"聊天头像";

            [self.avilableIconArr addObject:icon];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.editTaskTableView reloadData];
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//            [self.editTaskTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
        });
    });
    
}

- (void)removeRight:(UIButton *)Btn {
    
    if (iOS8Later) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除任务" message:@"确定删除该任务吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *fangQi = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            NSDictionary *parameters = @{@"inter": @"delTask",@"id":[NSString stringWithFormat:@"%@",self.model.ID]};
            [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *data = [NSDictionary changeType:responseObject];
                NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                if ([code isEqualToString:@"1"]) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                } else {
                    if (self.isRefreshTask != nil) {
                        NSString *str = @"1";
                        self.isRefreshTask(str);
                    }
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                NSLog(@"JSON: %@", data);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
            }];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:fangQi];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"删除任务" message:@"确定删除该任务吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 2;
        [alert show];
    }
}
- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)ClickOk {
    if (iOS8Later) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改任务" message:@"确定修改?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *fangQi = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:fangQi];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"修改任务" message:@"确定修改?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }
    
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1) {
                if (alertView.tag == 2) {
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [AFJSONResponseSerializer serializer];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    NSDictionary *parameters = @{@"inter": @"delTask",@"id":[NSString stringWithFormat:@"%@",self.model.ID]};
                    [manager POST:REQUEST_HOST parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        
                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *data = [NSDictionary changeType:responseObject];
                        NSString *code = [NSString stringWithFormat:@"%@",[data objectForKey:@"code"]];
                        if ([code isEqualToString:@"1"]) {
                            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                        } else {
                            if (self.isRefreshTask != nil) {
                                NSString *str = @"1";
                                self.isRefreshTask(str);
                            }
                            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@",[data objectForKey:@"errorMsg"]]];
                        }
                        NSLog(@"JSON: %@", data);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"Error: %@", error);
                    }];
                    
                } else if (alertView.tag == 1) {
        
                }
        
    }
    
}
//实现returnMutableArray 方法
- (void)returnIsRefreshTask:(ReturnIsRefreshTaskBlock)block {
    self.isRefreshTask = block;
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
