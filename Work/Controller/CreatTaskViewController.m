//
//  CreatTaskViewController.m
//  Financeteam
//
//  Created by Zccf on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CreatTaskViewController.h"
#import "EditTypeAndNameTableViewCell.h"
#import "EditPeopleAndTimeTableViewCell.h"
#import "EditTypeTableViewCell.h"
#import "EditNameTableViewCell.h"
#import "EditJoinPeopleTableViewCell.h"
#import "powerUserModel.h"
#import "ProductManageViewController.h"
#import "LoginPeopleModel.h"
#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"
#import "ChoosePeopleViewController.h"
#import "ContactModel.h"
#import "chooseViewController.h"
#import "ProductChooseTableViewController.h"
@interface CreatTaskViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JKAlertViewDelegate,SelectDateTimeDelegate>{
    LoginPeopleModel *loginModel;
    NSString *stopTime;
    NSString *startTime;
    DateTimeSelectView *_dateTimeSelectView;
    NSInteger indexPathRow;
    NSArray *productTypeArr;
}
@property (nonatomic, strong) UITableView *creatTaskTableView;
@property (nonatomic, strong) NSArray *TypeArr;
@property (nonatomic, strong) NSArray *ImageArr;
@property (nonatomic, strong) NSMutableArray *taskMechProNameArr;
@property (nonatomic, strong) NSMutableArray *avilablePersonNameArr;
@property (nonatomic, strong) NSMutableArray *avilableNameArr;
@property (nonatomic, strong) NSMutableArray *avilablePersonImageArr;
@property (nonatomic, strong) NSMutableArray *avilableIconArr;
@property (nonatomic, strong) NSMutableArray *oldAvilableArr;
@property (nonatomic, strong) NSMutableArray *taskUserArr;
@property (nonatomic, strong) NSArray *returnIDArray;//从产品列表返回的产品ID数组
@property (nonatomic, strong) NSArray *returnNameArray;//从产品列表返回的产品Name数组
@property (nonatomic, strong) NSArray *returnPeople;
@property (nonatomic, strong) NSArray *returnAvilablePeople;
@property (nonatomic, strong) NSMutableArray *deletePersonArr;//此页面删除的人员
@property (nonatomic, strong) NSMutableArray *addPersonArr;//已经添加的人员
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *refiningStr;
@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *taskCount;
@end

@implementation CreatTaskViewController
static NSString *MechProName;
static NSString *productName = @"点击选取";
static NSString *headPeopleName = @"点击选取";
static NSString *headPeopleID;
//static NSString *stopTime = @"点击选取";
static NSString *avilableID;
static NSString *productIDs;


- (UITableView *)creatTaskTableView {
    if (!_creatTaskTableView) {
        _creatTaskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight)];
        _creatTaskTableView.backgroundColor = VIEW_BASE_COLOR;
    }
    return _creatTaskTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    avilableID = @"";
    productIDs = @"";
    
    if (self.returnNameArray.count == 0) {
        productName = @"点击选取";
    }
    for (int i=0; i<self.returnNameArray.count ; i++) {
        //        powerUserModel *model = self.powerUserArr[i];
        if (i == 0 ) {
            productName = self.returnNameArray[0];
        } else if (i!=0) {
            productName = [NSString stringWithFormat:@"%@,%@",productName,self.returnNameArray[i]];
        }
        [self.creatTaskTableView reloadData];
    }
    headPeopleID = @"";
    if (self.returnPeople.count != 0) {
        ContactModel *model = self.returnPeople[0];
        headPeopleName = model.realName;
        headPeopleID = [NSString stringWithFormat:@"%ld",model.userId];
        [self.creatTaskTableView reloadData];
    } else {
        
        headPeopleName = @"点击选取";
    }
    
    if (self.taskUserArr.count != 0) {
        [self.avilableIconArr removeAllObjects];
        [self.avilableNameArr removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            for (int i=0; i<self.taskUserArr.count; i++) {
                ContactModel *model = self.taskUserArr[i];
                NSLog(@"model.iconUrl == %@",model.iconUrl);
                if ([model.iconUrl isEqualToString:@""]) {
                    model.iconUrl = @"";
                    [self.avilableIconArr addObject:model.iconUrl];
                } else if (model.iconUrl == nil) {
                    model.iconUrl = @"";
                    [self.avilableIconArr addObject:model.iconUrl];
                } else {
                    [self.avilableIconArr addObject:model.iconUrl];
                }
                [self.avilableNameArr addObject:model.realName];
                if (i == 0) {
                    avilableID = [NSString stringWithFormat:@"%ld",model.userId];
                } else {
                    avilableID = [NSString stringWithFormat:@"%@,%ld",avilableID,model.userId];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.creatTaskTableView reloadData];
            
            });
        });
    } else {
        [self.avilableIconArr removeAllObjects];
        [self.avilableNameArr removeAllObjects];
        [self.creatTaskTableView reloadData];
    }
    
    // 选择时间界面
    
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect];
    _dateTimeSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
}
- (void)tapBgView {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    stopTime = @"点击选取";
    startTime = @"点击选取";
    _refiningStr = @"点击选取";
    productTypeArr = @[@"已到访",@"办理中",@"新建CRM"];
//    self.avilablePersonImageArr = [NSMutableArray array];
//    self.avilablePersonNameArr = [NSMutableArray array];
    self.deletePersonArr = [NSMutableArray array];
    self.avilableIconArr = [NSMutableArray array];
    self.avilableNameArr = [NSMutableArray array];
    self.oldAvilableArr = [NSMutableArray array];
    self.taskUserArr = [NSMutableArray array];
    self.creatTaskTableView.delegate = self;
    self.creatTaskTableView.dataSource = self;
    self.addPersonArr = [NSMutableArray array];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.creatTaskTableView setTableFooterView:view];
    [self.creatTaskTableView registerClass:[EditTypeAndNameTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.creatTaskTableView registerClass:[EditNameTableViewCell class] forCellReuseIdentifier:@"name"];
    [self.creatTaskTableView registerClass:[EditPeopleAndTimeTableViewCell class] forCellReuseIdentifier:@"people"];
    [self.creatTaskTableView registerClass:[EditJoinPeopleTableViewCell class] forCellReuseIdentifier:@"join"];
    [self.creatTaskTableView registerClass:[EditTypeTableViewCell class] forCellReuseIdentifier:@"type"];
    [self.view addSubview:self.creatTaskTableView];
    self.creatTaskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.taskMechProNameArr = [NSMutableArray array];
    self.TypeArr = [NSArray arrayWithObjects:@"任务类型",@"任务名称",@"意向客户",@"订单数量",@"指定产品",@"任务内容",@"负责人",@"开始时间",@"截止时间",@"参与人", nil];
    self.ImageArr = [NSArray arrayWithObjects:@"负责人icon",@"截止时间",@"参与人icon", nil];
    self.navigationItem.title = @"添加任务";
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
//    self.navigationItem.leftBarButtonItem = left;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOk)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.seType == 1) {
        if (section == 0) {
            return 3;
        } else {
            return 5;
        }
    } else if (self.seType == 2) {
        if (section == 0) {
            return 5;
        } else {
            return 5;
        }
    } else if (self.seType == 3) {
        if (section == 0) {
            return 5;
        } else {
            return 5;
        }
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 12;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.seType == 1) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 44*KAdaptiveRateHeight;
            } else if (indexPath.row == 1) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 2) {
                return 37*KAdaptiveRateWidth+120;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 1) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 2) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 3) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 4) {
                return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
            }
        }

    } else if (self.seType == 2) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 1) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 2) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 3) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 4) {
                return 37*KAdaptiveRateWidth+120;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 1) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 2) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 3) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 4) {
                return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
            }
        }

    } else if (self.seType == 3) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 1) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 2) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 3) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 4) {
                return 37*KAdaptiveRateWidth+120;
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 1) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 2) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 3) {
                return 44*KAdaptiveRateHeight;
            }else if (indexPath.row == 4) {
                return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
            }
        }

    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"hehe"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hehe"];
    }
#pragma mark == 普通任务
    if (self.seType == 1) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TypeArr[0];
                cell.TypeNameLb.text = @"普通任务";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//关闭选择
                return cell;
            }
            else if (indexPath.row == 1) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TypeArr[1];
//                cell.self.taskName = self.model.name;
                cell.NameTF.placeholder = @"输入任务名称";
                cell.NameTF.tag = 100;
                cell.NameTF.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
             else if (indexPath.row == 2) {
                EditTypeAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.TypeLb.text = self.TypeArr[5];
//                TaskListModel *Model = self.taskInfoArr[0];
//                cell.contentTv.text = Model.content;
                if (cell.contentTv.text.length != 0) {
                    cell.placeholderLb.hidden = YES;
                }
                cell.contentTv.tag = 103;
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
                cell.TypeNameLb.text = self.TypeArr[6];
//                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = headPeopleName;
                cell.contentLb.tag = 200;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 1) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TypeArr[7];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = startTime;
                cell.contentLb.tag = 202;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else if (indexPath.row == 2) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TypeArr[8];
//                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = stopTime;
                cell.contentLb.tag = 201;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else if (indexPath.row == 3) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                cell.TypeNameLb.text = self.TypeArr[9];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.separetor.hidden = YES;
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
                [self.avilablePersonNameArr addObject:@" "];
                [self.avilablePersonNameArr insertObjects:self.avilableNameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonNameArr.count-1, self.avilableNameArr.count)]];
                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObject:@"增加群聊（大加）"];
                [self.avilablePersonImageArr insertObjects:self.avilableIconArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonImageArr.count-1, self.avilableIconArr.count)]];
                
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
                    if (i == self.avilablePersonImageArr.count - 1) {
                        imageV.layer.cornerRadius = 1;
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(btn.mas_centerY);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    } else {
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    }
                    
                    if (i != self.avilablePersonImageArr.count - 1) {

                        NSString *imagePath = [NSString stringWithFormat:@"%@%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                        NSURL *imageURL = [NSURL URLWithString:imagePath];
                        [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                        }];
                        
                        
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+1000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(btn.mas_centerX).offset(20*KAdaptiveRateWidth);
                            make.top.equalTo(btn.mas_top);
                            make.width.mas_equalTo(15*KAdaptiveRateWidth);
                            make.height.mas_equalTo(15*KAdaptiveRateWidth);
                        }];
                    } else {
                        imageV.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
                    }
                    if (i == self.avilablePersonImageArr.count - 1) {
                        
                    }
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            } 
        }
#pragma mark == CRM任务
    } else if (self.seType == 2) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TypeArr[0];
                cell.TypeNameLb.text = @"CRM任务";
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
#pragma mark == 新增电销任务细化
            else if (indexPath.row == 1) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = @"细化类型";
                cell.TypeNameLb.text = _refiningStr;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else if (indexPath.row == 2) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TypeArr[1];
                //                cell.self.taskName = self.model.name;
                cell.NameTF.placeholder = @"输入任务名称";
                cell.NameTF.tag = 100;
                cell.NameTF.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 3) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TypeArr[2];
                
                cell.NameTF.placeholder = @"输入意向客户数量";
                cell.NameTF.tag = 101;
                cell.NameTF.delegate = self;
                cell.NameTF.keyboardType = UIKeyboardTypeDecimalPad;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 4) {
                EditTypeAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.TypeLb.text = self.TypeArr[5];
                //                TaskListModel *Model = self.taskInfoArr[0];
                //                cell.contentTv.text = Model.content;
                if (cell.contentTv.text.length != 0) {
                    cell.placeholderLb.hidden = YES;
                }
                cell.contentTv.tag = 103;
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
                cell.TypeNameLb.text = self.TypeArr[6];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = headPeopleName;
                cell.contentLb.tag = 200;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 1) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TypeArr[7];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = startTime;
                cell.contentLb.tag = 202;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else if (indexPath.row == 2) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TypeArr[8];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = stopTime;
                cell.contentLb.tag = 201;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else if (indexPath.row == 3) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                cell.TypeNameLb.text = self.TypeArr[9];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.separetor.hidden = YES;
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
                [self.avilablePersonNameArr addObject:@" "];
                [self.avilablePersonNameArr insertObjects:self.avilableNameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonNameArr.count-1, self.avilableNameArr.count)]];
                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObject:@"增加群聊（大加）"];
                [self.avilablePersonImageArr insertObjects:self.avilableIconArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonImageArr.count-1, self.avilableIconArr.count)]];
                
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
                    if (i == self.avilablePersonImageArr.count - 1) {
                        imageV.layer.cornerRadius = 1;
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(btn.mas_centerY);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    } else {
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    }
                    if (i != self.avilablePersonImageArr.count - 1) {

                        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                        NSURL *imageURL = [NSURL URLWithString:imagePath];
                        [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                        }];

                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+1000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(btn.mas_centerX).offset(20*KAdaptiveRateWidth);
                            make.top.equalTo(btn.mas_top);
                            make.width.mas_equalTo(15*KAdaptiveRateWidth);
                            make.height.mas_equalTo(15*KAdaptiveRateWidth);
                        }];
                    } else {
                        imageV.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
                    }
                    if (i == self.avilablePersonImageArr.count - 1) {
                        
                    }
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            } 
        }
#pragma mark == 销售任务
    } else if (self.seType == 3) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TypeArr[0];
                cell.TypeNameLb.text = @"销售任务";
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 1) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TypeArr[1];
                cell.NameTF.placeholder = @"输入任务名称";
                cell.NameTF.tag = 100;
                cell.NameTF.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
            else if (indexPath.row == 2) {
                EditNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
                }
                cell.TypeLb.text = self.TypeArr[3];
                
                cell.NameTF.placeholder = @"输入订单数量";
                cell.NameTF.keyboardType = UIKeyboardTypeDecimalPad;
                cell.NameTF.tag = 101;
                cell.NameTF.delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 3) {
                EditTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"type" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"type"];
                }
                cell.TypeLb.text = self.TypeArr[4];
                cell.TypeNameLb.text = productName;
                cell.TypeNameLb.tag = 102;

                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if (indexPath.row == 4) {
                EditTypeAndNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditTypeAndNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                cell.TypeLb.text = self.TypeArr[5];
                if (cell.contentTv.text.length != 0) {
                    cell.placeholderLb.hidden = YES;
                }
                cell.contentTv.tag = 103;
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
                cell.TypeNameLb.text = self.TypeArr[6];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = headPeopleName;
                cell.contentLb.tag = 200;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            } else if (indexPath.row == 1) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TypeArr[7];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = startTime;
                cell.contentLb.tag = 202;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else if (indexPath.row == 2) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[1]];
                cell.TypeNameLb.text = self.TypeArr[8];
                //                TaskListModel *Model = self.taskInfoArr[0];
                cell.contentLb.text = stopTime;
                cell.contentLb.tag = 201;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
                
            }else if (indexPath.row == 3) {
                EditPeopleAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"people" forIndexPath:indexPath];
                if (!cell) {
                    cell = [[EditPeopleAndTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
                }
                cell.TypeImage.image = [UIImage imageNamed:self.ImageArr[2]];
                cell.TypeNameLb.text = self.TypeArr[9];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.separetor.hidden = YES;
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
                [self.avilablePersonNameArr addObject:@" "];
                [self.avilablePersonNameArr insertObjects:self.avilableNameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonNameArr.count-1, self.avilableNameArr.count)]];
                self.avilablePersonImageArr = [NSMutableArray array];
                [self.avilablePersonImageArr addObject:@"增加群聊（大加）"];
                [self.avilablePersonImageArr insertObjects:self.avilableIconArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonImageArr.count-1, self.avilableIconArr.count)]];
                
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
                    if (i == self.avilablePersonImageArr.count - 1) {
                        imageV.layer.cornerRadius = 1;
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.equalTo(btn.mas_centerY);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    } else {
                        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0*KAdaptiveRateWidth);
                            make.centerX.equalTo(btn.mas_centerX);
                            make.height.mas_equalTo(42*KAdaptiveRateWidth);
                            make.width.mas_equalTo(42*KAdaptiveRateWidth);
                        }];
                    }
                    
                    if (i != self.avilablePersonImageArr.count - 1) {

                        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",PHOTO_ADDRESS,self.avilablePersonImageArr[i]];
                        NSURL *imageURL = [NSURL URLWithString:imagePath];
                        [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
                        }];
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+1000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerX.equalTo(btn.mas_centerX).offset(20*KAdaptiveRateWidth);
                            make.top.equalTo(btn.mas_top);
                            make.width.mas_equalTo(15*KAdaptiveRateWidth);
                            make.height.mas_equalTo(15*KAdaptiveRateWidth);
                        }];
                    } else {
                        imageV.image = [UIImage imageNamed:self.avilablePersonImageArr[i]];
                    }
                    if (i == self.avilablePersonImageArr.count - 1) {
                        
                    }
                }
                self.oldAvilableArr = self.avilablePersonNameArr;
                
                return cell;
            } 
        }
    }
    
    return cell;
}
#pragma mark -- cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.seType == 2) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            ProductChooseTableViewController *productChoose = [[ProductChooseTableViewController alloc]init];
            productChoose.dataArr                           = productTypeArr;
            productChoose.title                             = @"任务细化类型";
            [productChoose makeTableviewFrame];
            [self.navigationController pushViewController:productChoose animated:YES];
            
            [productChoose returnText:^(NSString *returnStr) {
                if (returnStr.length > 0) {
                    _refiningStr = returnStr;
                    
                    [self.creatTaskTableView reloadData];
                }
            }];
        }
    }
    
    if (self.seType == 3) {
        //销售任务中section == 0 row == 3 点击事件
        if (indexPath.section == 0) {
            if (indexPath.row == 3) {
                ProductManageViewController *productChoose = [ProductManageViewController new];
                productChoose.seType = 4;
//                productChoose.limit = 1;
                [productChoose returnIDMutableArray:^(NSMutableArray *returnIDMutableArray) {
//                    self.returnIDArray = [NSMutableArray array];
                    self.returnIDArray = returnIDMutableArray;
//                    NSLog(@"self.returnIDArray.count == %ld",self.returnIDArray.count);
                }];
                [productChoose returnNameMutableArray:^(NSMutableArray *returnNameMutableArray) {
//                    self.returnNameArray = [NSMutableArray array];
                    self.returnNameArray = returnNameMutableArray;
//                    NSLog(@"self.returnNameArray.count == %ld",self.returnNameArray.count);
                }];
                productChoose.taskMechProNameArr = self.returnNameArray;
                productChoose.taskMechProIDArr = self.returnIDArray;
                [self.navigationController pushViewController:productChoose animated:YES];
            }
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            _dateTimeSelectView.hidden = NO;
            self.bgView.hidden = NO;
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
            [UIView animateWithDuration:animateTime animations:^{
                _dateTimeSelectView.frame = timeViewRect;
            }];
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            indexPathRow = 1;
        } else if (indexPath.row == 2) {
            _dateTimeSelectView.hidden = NO;
            self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
            self.bgView.hidden = NO;
            [UIView animateWithDuration:animateTime animations:^{
                _dateTimeSelectView.frame = timeViewRect;
            }];
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            indexPathRow = 2;
        }else if (indexPath.row == 0) {
            chooseViewController *choosePeople = [chooseViewController new];
            choosePeople.seType = 1;
            [choosePeople returnMutableArray:^(NSMutableArray *returnMutableArray) {
                self.returnPeople = returnMutableArray;
            }];
            [self.navigationController pushViewController:choosePeople animated:YES];
        }
    }
    
}

#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *time = [NSString stringWithFormat:@"%@%@:00",dictDate[@"date"],dictDate[@"time"]];
    if (indexPathRow == 1) {
        startTime = time;
    } else {
        stopTime = time;
    }
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
    [self.creatTaskTableView reloadData];
    
}
- (void)cancelDate {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
}
-(void)getTimeToValue:(NSString *)theTimeStr
{
//    stopTime = theTimeStr;
//    [self.creatTaskTableView reloadData];
    NSLog(@"我获取到时间了，时间是===%@",theTimeStr);
}

- (void)BtnClick:(UIButton *)Btn {
    if (self.deletePersonArr.count > self.addPersonArr.count) {
        for (int i=0; i<self.deletePersonArr.count; i++) {
            ContactModel *mode1 = self.deletePersonArr[i];
            for (int j=0; j<self.addPersonArr.count; j++) {
                ContactModel *model2 = self.addPersonArr[j];
                if (model2.userId == mode1.userId) {
                    [self.deletePersonArr removeObject:mode1];
                    [self.addPersonArr removeObject:model2];
                    i=i-1;
                    j=j-1;
                }
            }
        }
    } else if (self.deletePersonArr.count < self.addPersonArr.count) {
        for (int i=0; i<self.addPersonArr.count; i++) {
            ContactModel *mode1 = self.addPersonArr[i];
            for (int j=0; j<self.deletePersonArr.count; j++) {
                ContactModel *model2 = self.deletePersonArr[j];
                if (model2.userId == mode1.userId) {
                    [self.deletePersonArr removeObject:model2];
                    [self.addPersonArr removeObject:mode1];
                    i=i-1;
                    j=j-1;
                }
            }
        }
    } else {
        for (int i=0; i<self.addPersonArr.count; i++) {
            ContactModel *mode1 = self.addPersonArr[i];
            for (int j=0; j<self.deletePersonArr.count; j++) {
                ContactModel *model2 = self.deletePersonArr[j];
                if (model2.userId == mode1.userId) {
                    [self.deletePersonArr removeObject:model2];
                    [self.addPersonArr removeObject:mode1];
                    i=i-1;
                    j=j-1;
                }
            }
        }
    }
    if (Btn.tag%2000 == self.avilableIconArr.count) {
        chooseViewController *choosePeople = [chooseViewController new];
        choosePeople.seType = 2;
        choosePeople.limited = 2;
        choosePeople.deleteArr = self.deletePersonArr;
        choosePeople.addArr = self.addPersonArr;
        [choosePeople returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
            self.deletePersonArr = [NSMutableArray array];
            [self.taskUserArr addObjectsFromArray:returnAvilableMutableArray];
            for (int i=0; i<returnAvilableMutableArray.count; i++) {
                ContactModel *model = returnAvilableMutableArray[i];
                if (![self.addPersonArr containsObject:model]) {
                    [self.addPersonArr addObject:model];
                }
            }
        }];
        [self.navigationController pushViewController:choosePeople animated:YES];
       
    }
    
}
- (void)deleteBtnClick:(UIButton *)Btn {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //获取可用人员数据
        ContactModel *powerUser = self.taskUserArr[Btn.tag%1000];
        [self.deletePersonArr addObject:powerUser];
        NSLog(@"sup.tag == %ld",Btn.tag);
//        [self.taskUserArr addObjectsFromArray:self.returnAvilablePeople];
        [self.taskUserArr removeObjectAtIndex:Btn.tag%1000];
        [self.avilableNameArr removeAllObjects];
        [self.avilableIconArr removeAllObjects];
        for (int i = 0; i < self.taskUserArr.count; i++) {
            ContactModel *model = self.taskUserArr[i];
            NSString *name = model.realName;
            if ([name isEqualToString:@""]) {
                name = @"测试";
            }
            [self.avilableNameArr addObject:name];
            NSString *icon = model.iconUrl;
            if ([icon isEqualToString:@""]) {
                icon = @"/usericon/uic1449551822974.jpg";
            }
            if (i == 0) {
                avilableID = [NSString stringWithFormat:@"%ld",model.userId];
            } else {
                avilableID = [NSString stringWithFormat:@"%@,%ld",avilableID,model.userId];
            }

            [self.avilableIconArr addObject:icon];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.creatTaskTableView reloadData];
            //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            //            [self.editTaskTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
        });
    });
    
}

- (void)GoBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        self.taskName = textField.text;
    } else if (textField.tag == 101) {
        self.taskCount = textField.text;
    }
}
- (void)ClickOk {
//    UITextField *NameTF = [self.creatTaskTableView viewWithTag:100];
    UITextField *CountTF = [self.creatTaskTableView viewWithTag:101];
//    UILabel *productLB = [self.creatTaskTableView viewWithTag:102];
    UITextView *contentTv = [self.creatTaskTableView viewWithTag:103];
    
    UILabel *timeLB = [self.creatTaskTableView viewWithTag:201];
    UILabel *startLb = [self.creatTaskTableView viewWithTag:202];

    for (int i=0; i<self.returnIDArray.count; i++) {
        if (i==0) {
            productIDs = self.returnIDArray[0];
        } else {
            productIDs = [NSString stringWithFormat:@"%@,%@",productIDs,self.returnIDArray[i]];
        }
    }
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    if (self.seType == 1) {
        if (self.taskName.length==0 ) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入任务名称" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ( contentTv.text.length == 0) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入任务内容" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if (headPeopleID.length == 0){
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择负责人" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([startLb.text isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择开始时间" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([timeLB.text isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择截止时间" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([avilableID isEqualToString:@""]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择参与人" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        } else {

            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *dt1 = [[NSDate alloc] init];
            NSDate *dt2 = [[NSDate alloc] init];
            dt1 = [df dateFromString:startTime];
            dt2 = [df dateFromString:stopTime];
            NSComparisonResult result = [dt1 compare:dt2];
            if (result == NSOrderedDescending) {
                [MBProgressHUD showError:@"时间区间有误"];
            } else {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                NSDictionary *parameters = @{@"inter":@"addTask",@"type":@"3",@"name":[NSString stringWithFormat:@"%@",self.taskName],@"count":[NSString stringWithFormat:@"%@",self.taskCount],@"personId":[NSString stringWithFormat:@"%@",headPeopleID],@"cuserId":[NSString stringWithFormat:@"%@",avilableID],@"content":[NSString stringWithFormat:@"%@",contentTv.text],@"startTime":[NSString stringWithFormat:@"%@",startLb.text],@"stopTime":[NSString stringWithFormat:@"%@",timeLB.text],@"uid":[NSString stringWithFormat:@"%ld",loginModel.userId],@"mechProId":productIDs};
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
                        [MBProgressHUD showSuccess:@"创建成功!"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    NSLog(@"JSON: %@", data);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                }];

            }
        }
    } else if (self.seType == 2) {
        if (self.taskName.length==0 ) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入任务名称" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([_refiningStr isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择任务细化类型" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ( self.taskCount.length == 0) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入意向客户数量" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ( contentTv.text.length == 0) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入任务内容" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if (headPeopleID.length == 0){
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择负责人" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([startLb.text isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择开始时间" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([timeLB.text isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择截止时间" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        } else if ([avilableID isEqualToString:@""]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择参与人" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }  else {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *dt1 = [[NSDate alloc] init];
            NSDate *dt2 = [[NSDate alloc] init];
            dt1 = [df dateFromString:startTime];
            dt2 = [df dateFromString:stopTime];
            NSComparisonResult result = [dt1 compare:dt2];
            if (result == NSOrderedDescending) {
                [MBProgressHUD showError:@"时间区间有误"];
            } else {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                NSString *dxState;
                if ([self.refiningStr isEqualToString:@"待处理"]){
                    dxState = @"1";
                } else if ([self.refiningStr isEqualToString:@"邀约中"]){
                    dxState = @"2";
                } else if ([self.refiningStr isEqualToString:@"已到访"]){
                    dxState = @"3";
                } else if ([self.refiningStr isEqualToString:@"办理中"]){
                    dxState = @"4";
                } else {
                    dxState = @"5";
                }
                
                NSDictionary *parameters = @{@"inter": @"addTask",@"type":@"2",@"dxState":dxState,@"name":[NSString stringWithFormat:@"%@",self.taskName],@"count":[NSString stringWithFormat:@"%@",self.taskCount],@"personId":[NSString stringWithFormat:@"%@",headPeopleID],@"cuserId":[NSString stringWithFormat:@"%@",avilableID],@"content":[NSString stringWithFormat:@"%@",contentTv.text],@"startTime":[NSString stringWithFormat:@"%@",startLb.text],@"stopTime":[NSString stringWithFormat:@"%@",timeLB.text],@"uid":[NSString stringWithFormat:@"%ld",loginModel.userId],@"mechProId":productIDs};
                NSLog(@"parameters == %@",parameters);
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
                        [MBProgressHUD showSuccess:@"创建成功!"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    NSLog(@"JSON: %@", data);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                }];
            }
        }
    } else if (self.seType == 3) {
        if (self.taskName.length==0 ) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入任务名称" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        } else if ( self.taskCount.length == 0) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入订单数量" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ( productIDs.length == 0) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择指定产品" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ( contentTv.text.length == 0) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入任务内容" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if (headPeopleID.length == 0){
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择负责人" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([startLb.text isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择开始时间" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        }else if ([timeLB.text isEqualToString:@"点击选取"]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择截止时间" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        } else if ([avilableID isEqualToString:@""]) {
            JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择参与人" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];//||headPeopleID == 0||timeLB.text == 0
        } else {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSDate *dt1 = [[NSDate alloc] init];
            NSDate *dt2 = [[NSDate alloc] init];
            dt1 = [df dateFromString:startTime];
            dt2 = [df dateFromString:stopTime];
            NSComparisonResult result = [dt1 compare:dt2];
            if (result == NSOrderedDescending) {
                [MBProgressHUD showError:@"时间区间有误"];
            } else {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                NSDictionary *parameters = @{@"inter": @"addTask",@"type":@"1",@"name":self.taskName,@"count":self.taskCount,@"personId":headPeopleID,@"cuserId":avilableID,@"content":contentTv.text,@"startTime":[NSString stringWithFormat:@"%@",startLb.text],@"stopTime":timeLB.text,@"uid":[NSString stringWithFormat:@"%ld",loginModel.userId],@"mechProId":productIDs};
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
                        [MBProgressHUD showSuccess:@"创建成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    NSLog(@"JSON: %@", data);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                }];
            }
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
