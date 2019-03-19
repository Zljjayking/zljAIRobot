//
//  NoticeDetailsViewController.m
//  Financeteam
//
//  Created by Zccf on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "NoticeDetailsViewController.h"
#import "NoticeListModel.h"
#import "ContactModel.h"
#import "NoticeDetailsTableViewCell.h"
#import "ChoosePeopleViewController.h"
#import "chooseViewController.h"
#import "ContactDetailsViewController.h"
@interface NoticeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    LoginPeopleModel *myModel;
}
@property (nonatomic) NSMutableArray *NoticeListDataArr;//接收服务器穿回的数据
@property (nonatomic) NSMutableArray *NoticeListArr;
@property (nonatomic) NSMutableArray *releaseInfoArr;
@property (nonatomic) NSMutableArray *UserInfoArr;
@property (nonatomic) UITableView *NoticeDetailsTableView;
@property (nonatomic) NSString *headPeopleName;
@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *contentText;
@property (nonatomic) CGFloat titleTextHeight;
@property (nonatomic) CGFloat contentTextHeight;
@property (nonatomic) NSMutableArray *avilablePersonNameArr;
@property (nonatomic) NSMutableArray *avilablePersonImageArr;
@property (nonatomic, strong) NSMutableArray *avilableNameArr;//可用人员名字
@property (nonatomic, strong) NSMutableArray *avilableIconArr;//可用人员头像
@property (nonatomic, strong) NSMutableArray *oldAvilableArr;
@property (nonatomic,strong) NSMutableArray *powerUserArr;//可用人员
@property (nonatomic, strong) UIView *vv;
@property (nonatomic, strong) NSMutableArray *deletePersonArr;//此页面删除的人员
@property (nonatomic, strong) NSMutableArray *addPersonArr;//已经添加的人员
/*
 self.placeholderLb = [[UILabel alloc]init];
 self.placeholderLb.font = [UIFont systemFontOfSize:14];
 self.placeholderLb.frame =CGRectMake(5, 5, kScreenWidth - 4, 20);
 self.placeholderLb.enabled = NO;//lable必须设置为不可用
 self.placeholderLb.textColor = [UIColor lightGrayColor];
 [self.contentTV addSubview:self.placeholderLb];
 */
@end

@implementation NoticeDetailsViewController
static BOOL isEdit;
static NSString *peopleStr;
- (UITableView *)NoticeDetailsTableView {
    if (!_NoticeDetailsTableView) {
        _NoticeDetailsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStyleGrouped];
        _NoticeDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (self.ishideNaviView) {
            _NoticeDetailsTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - NaviHeight);
        }
    }
    return _NoticeDetailsTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.deletePersonArr = [NSMutableArray array];
    if (self.powerUserArr.count != 0) {
        [self.avilableIconArr removeAllObjects];
        [self.avilableNameArr removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            for (int i=0; i<self.powerUserArr.count; i++) {
                ContactModel *model = self.powerUserArr[i];
                
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
                    peopleStr = [NSString stringWithFormat:@"%ld",model.userId];
                } else {
                    peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,model.userId];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
                [self.NoticeDetailsTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
            });
        });
    } else {
        [self.avilableIconArr removeAllObjects];
        [self.avilableNameArr removeAllObjects];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.NoticeDetailsTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.vv = [[UIView alloc]initWithFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    if (self.setype == 1) {
        [self initUIs];
    } else {
        [self setupView];
    }
    // Do any additional setup after loading the view.
}
//请求列表数据
- (void)requestForNoticeListData:(NSDictionary *)dic {
    self.NoticeListDataArr = [NSMutableArray array];
    self.NoticeListArr = [NSMutableArray array];
    self.releaseInfoArr = [NSMutableArray array];
    self.UserInfoArr = [NSMutableArray array];
    [self.NoticeListDataArr removeAllObjects];
    self.powerUserArr = [NSMutableArray array];
    [HttpRequestEngine getNoticeDetailsWith:dic completion:^(id obj, NSString *errorStr) {
        NSLog(@"obj == %@",obj);
        if ([(NSMutableArray *)obj count]>0) {
            self.NoticeListDataArr = obj;
            NSArray *NoticeArr = self.NoticeListDataArr[0];
            if (NoticeArr.count != 0) {
                NoticeListModel *NoticeModel = NoticeArr[0];
                [self.NoticeListArr addObject:NoticeModel];
                self.titleText = NoticeModel.nameStr;
                self.contentText = NoticeModel.signStr;
            }
            
            NSArray *releaseArr = self.NoticeListDataArr[1];
            if (releaseArr.count != 0) {
                ContactModel *releaseModel = releaseArr[0];
                self.headPeopleName = releaseModel.realName;
                [self.releaseInfoArr addObject:releaseModel];
            }
            NSArray *UserInfoArr = self.NoticeListDataArr[2];
            if (UserInfoArr.count != 0) {
                for (int i=0; i<UserInfoArr.count; i++) {
                    ContactModel *Model = UserInfoArr[i];
                    [self.powerUserArr addObject:Model];
                    [self.avilableNameArr addObject:Model.realName];
                    [self.avilableIconArr addObject:Model.iconUrl];
                }
            }
            [self.NoticeDetailsTableView reloadData];
        }else{
            [self.NoticeListDataArr removeAllObjects];
            if (errorStr != nil) {
                [MBProgressHUD showError:@"网络错误"];
            } else {
//                [MBProgressHUD showError:@"未查询到数据"];
            }
        }
    }];
}
- (void)initUIs {
    isEdit = 0;
    self.avilableIconArr = [NSMutableArray array];
    self.avilableNameArr = [NSMutableArray array];
    self.oldAvilableArr = [NSMutableArray array];
    self.navigationItem.title = @"公告详情";
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"编辑"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickEdit)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"inter"] = @"selBulletin";
    dic[@"uid"] = [NSString stringWithFormat:@"%ld",myModel.userId];
    NSLog(@"myModel.userId == %ld",myModel.userId);
    dic[@"bid"] = self.bid;
    NSLog(@"dic == %@",dic);
    [self requestForNoticeListData:dic];
    self.NoticeDetailsTableView.delegate = self;
    self.NoticeDetailsTableView.dataSource = self;
    [self.NoticeDetailsTableView registerClass:[NoticeDetailsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.NoticeDetailsTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.NoticeDetailsTableView setTableFooterView:view];
}
- (void)setupView {
    isEdit = 1;
    self.titleText = @"";
    self.contentText = @"";
    self.avilableIconArr = [NSMutableArray array];
    self.avilableNameArr = [NSMutableArray array];
    self.oldAvilableArr = [NSMutableArray array];
    self.powerUserArr = [NSMutableArray array];
    self.navigationItem.title = @"公告详情";
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickCreate)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    self.NoticeDetailsTableView.delegate = self;
    self.NoticeDetailsTableView.dataSource = self;
    [self.NoticeDetailsTableView registerClass:[NoticeDetailsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.NoticeDetailsTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.NoticeDetailsTableView setTableFooterView:view];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 40;
    } else {
        if (isEdit) {
            return 40;
        } else {
            return 10;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITextView *tv = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        tv.font = [UIFont systemFontOfSize:14];
        tv.text = self.titleText;
        self.titleTextHeight = tv.contentSize.height;
        if (self.titleTextHeight > 60) {
            return self.titleTextHeight;
        } else {
            return 60;
        }
    }
    if (indexPath.section == 1) {
        UITextView *tv = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        tv.font = [UIFont systemFontOfSize:14];
        tv.text = self.contentText;
        self.contentTextHeight = tv.contentSize.height;
        if (self.contentTextHeight>120) {
            return self.contentTextHeight;
        } else {
            return 120;
        }
    }
    if (indexPath.section == 2) {
        if (isEdit) {
            return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
        } else {
            if ((self.avilableNameArr.count)%5) {
                return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5+1)+10;
            }
            return (55*KAdaptiveRateWidth+10) * ((self.avilableNameArr.count)/5)+10;
        }
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    view.backgroundColor = VIEW_BASE_COLOR;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 20)];
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    if (section == 0) {
        if (isEdit) {
            label.text = [NSString stringWithFormat:@"公告标题"];
        } else {
            label.text = [NSString stringWithFormat:@"发布者:"];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, kScreenWidth -70, 20)];
            [view addSubview:nameLabel];
            nameLabel.font = [UIFont systemFontOfSize:14];
            nameLabel.textColor = [UIColor redColor];
            nameLabel.text = self.headPeopleName;
        }
    } else if (section == 2) {
        label.text = [NSString stringWithFormat:@"通知人员[%ld人]",self.powerUserArr.count];
    } else {
        if (isEdit) {
            label.text = @"公告内容";
        } else {
            label.text = @"";
        }
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NoticeDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NoticeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        UILabel *label = [cell.contentTV viewWithTag:1001];
        [label removeFromSuperview];
        cell.contentTV.delegate = self;
        cell.contentTV.text = self.titleText;
        cell.contentTV.tag = 1000;
        cell.contentTV.hidden = NO;
        if (isEdit) {
            cell.contentTV.userInteractionEnabled = YES;
        } else {
            cell.contentTV.userInteractionEnabled = NO;
        }
        
        UILabel *placeholderLb = [[UILabel alloc]init];
        placeholderLb.tag = 1001;
        placeholderLb.font = [UIFont systemFontOfSize:14];
        placeholderLb.frame =CGRectMake(5, 5, kScreenWidth - 4, 20);
        placeholderLb.enabled = NO;//lable必须设置为不可用
        placeholderLb.textColor = [UIColor lightGrayColor];
        if (cell.contentTV.text.length != 0) {
            placeholderLb.hidden = YES;
        }
        [cell.contentTV addSubview:placeholderLb];
        placeholderLb.text = @"请输入公告标题";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        NoticeDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NoticeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.contentTV.hidden = NO;
        UILabel *label = [cell.contentTV viewWithTag:1003];
        [label removeFromSuperview];
        cell.contentTV.delegate = self;
        cell.contentTV.text = self.contentText;
        cell.contentTV.tag = 1002;
        if (isEdit) {
            cell.contentTV.userInteractionEnabled = YES;
        } else {
            cell.contentTV.userInteractionEnabled = NO;
        }
        UILabel *placeholderLb = [[UILabel alloc]init];
        placeholderLb.font = [UIFont systemFontOfSize:14];
        placeholderLb.tag = 1003;
        placeholderLb.frame =CGRectMake(5, 5, kScreenWidth - 4, 20);
        placeholderLb.enabled = NO;//lable必须设置为不可用
        placeholderLb.textColor = [UIColor lightGrayColor];
        if (cell.contentTV.text.length != 0) {
            placeholderLb.hidden = YES;
        }
        [cell.contentTV addSubview:placeholderLb];
        placeholderLb.text = @"请输入公告内容";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
//        NoticeDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//        if (cell == nil) {
//            cell = [[NoticeDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        }
//        cell.contentTV.hidden = YES;
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"people"];
        }
        cell.backgroundColor = [UIColor whiteColor];
        self.avilablePersonNameArr = [NSMutableArray array];
        self.avilablePersonImageArr = [NSMutableArray array];
        if (isEdit) {
            [self.avilablePersonNameArr addObject:@" "];
            [self.avilablePersonNameArr insertObjects:self.avilableNameArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.avilablePersonNameArr.count-1, self.avilableNameArr.count)]];
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
                if (i == self.avilablePersonImageArr.count-1) {
                    [imageV.layer setCornerRadius:1];
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
                        label.font = [UIFont systemFontOfSize:12];
                        [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(btn.mas_bottom);
                            make.left.equalTo(btn.mas_left).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(12);
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
                
            }
        } else {
            self.avilablePersonNameArr = self.avilableNameArr;
            self.avilablePersonImageArr = self.avilableIconArr;
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
                [imageV sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"聊天头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    UILabel *label = [[UILabel alloc]init];
                    [btn addSubview:label];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.font = [UIFont systemFontOfSize:12];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(btn.mas_bottom);
                        make.left.equalTo(btn.mas_left).offset(0);
                        make.right.equalTo(btn.mas_right).offset(0);
                        make.height.mas_equalTo(12);
                    }];
                    label.text = self.avilablePersonNameArr[i];
                }];
                
            }
        }
        
        self.oldAvilableArr = self.avilablePersonNameArr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)returnIsRefreshNotice:(ReturnIsRefreshNoticeBlock)block {
    self.isRefreshNotice = block;
}
#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    [self.NoticeDetailsTableView endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
}
#pragma mark -- 点击事件
- (void)BtnClick:(UIButton *)Btn {
    if (Btn.tag%2000 == self.avilableIconArr.count) {
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

        chooseViewController *choosePeople = [chooseViewController new];
        if (self.ishideNaviView) {
            choosePeople.ishideNaviView = 1;
        }
        choosePeople.seType = 2;
        choosePeople.limited = 3;
        choosePeople.limitArr = self.powerUserArr;
        [choosePeople returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
            [self.powerUserArr addObjectsFromArray:returnAvilableMutableArray];
            for (int i=0; i<returnAvilableMutableArray.count; i++) {
                ContactModel *model = returnAvilableMutableArray[i];
                if (![self.addPersonArr containsObject:model]) {
                    NSLog(@"执行增加");
                    [self.addPersonArr addObject:model];
                }
            }

        }];
        [self.navigationController pushViewController:choosePeople animated:YES];
    } else {
        NSInteger index = Btn.tag%2000;
        ContactModel *model = self.powerUserArr[index];
        ContactDetailsViewController * cdVC = [[ContactDetailsViewController alloc]init];
        if (self.ishideNaviView) {
            cdVC.ishideNaviView = 1;
        }
        cdVC.uid = [NSString stringWithFormat:@"%ld", model.userId];
        cdVC.setype = 3;
        [self.navigationController pushViewController:cdVC animated:YES];
    }
    
}
- (void)deleteBtnClick:(UIButton *)Btn {
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //获取可用人员数据
        
        NSLog(@"sup.tag == %ld",Btn.tag);
        ContactModel *powerUser = self.powerUserArr[Btn.tag%1000];
        [self.deletePersonArr addObject:powerUser];
        [self.powerUserArr removeObjectAtIndex:Btn.tag%1000];
        [self.avilableNameArr removeAllObjects];
        [self.avilableIconArr removeAllObjects];
        for (int i = 0; i < self.powerUserArr.count; i++) {
            ContactModel *powerUser = self.powerUserArr[i];
            NSString *name = powerUser.realName;
            if (i == 0) {
                peopleStr = [NSString stringWithFormat:@"%ld",powerUser.userId];
            } else {
                peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,powerUser.userId];
            }
            
            [self.avilableNameArr addObject:name];
            NSString *icon = powerUser.iconUrl;
            
            [self.avilableIconArr addObject:icon];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [self.NoticeDetailsTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
        });
    });
    
}
- (void)ClickEdit {
    if (self.isUpdateNotice) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickOK)];
        self.navigationItem.rightBarButtonItem = right;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
        isEdit = 1;
        [self.NoticeDetailsTableView reloadData];
    } else {
        [MBProgressHUD showError:@"暂无此权限"];
    }
}

- (void)ClickOK {
    NSString *titleText = self.titleText;
    titleText = [titleText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    titleText = [titleText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *contentText = self.contentText;
    contentText = [contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    for (int i=0; i<self.powerUserArr.count ; i++) {
        ContactModel *model = self.powerUserArr[i];
        if (i == 0 ) {
            peopleStr = [NSString stringWithFormat:@"%ld",model.userId];
        } else if (i!=0) {
            peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,model.userId];
        }
    }
    if (titleText.length == 0) {
        [MBProgressHUD showError:@"公告标题为空"];
    } else if (contentText.length == 0) {
        [MBProgressHUD showError:@"公告内容为空"];
    } else if (peopleStr.length == 0) {
        [MBProgressHUD showError:@"通知人员为空"];
    } else {
        [self updataNoiceWithTitle:self.titleText content:self.contentText userIds:peopleStr bid:self.bid];
    }

}
- (void)ClickCreate {
    NSString *titleText = self.titleText;
    titleText = [titleText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    titleText = [titleText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *contentText = self.contentText;
    contentText = [contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    contentText = [contentText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    for (int i=0; i<self.powerUserArr.count ; i++) {
        ContactModel *model = self.powerUserArr[i];
        if (i == 0 ) {
            peopleStr = [NSString stringWithFormat:@"%ld",model.userId];
        } else if (i!=0) {
            peopleStr = [NSString stringWithFormat:@"%@,%ld",peopleStr,model.userId];
        }
    }
    if (titleText.length == 0) {
        [MBProgressHUD showError:@"公告标题为空"];
    } else if (contentText.length == 0) {
        [MBProgressHUD showError:@"公告内容为空"];
    } else if (peopleStr.length == 0) {
        [MBProgressHUD showError:@"通知人员为空"];
    } else {
        [self createNoiceWithTitle:self.titleText content:self.contentText userIds:peopleStr Uid:[NSString stringWithFormat:@"%ld",myModel.userId]];
    }
}
- (void)createNoiceWithTitle:(NSString *)title content:(NSString *)content userIds:(NSString *)userIds Uid:(NSString *)uid {
    [HttpRequestEngine creatNoticeWithTitle:title content:content userIds:userIds Uid:uid completion:^(id obj, NSString *errorStr) {
        NSDictionary *data = obj;
        NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
        if ([code  isEqualToString:@"1"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
        } else {
            if (self.isRefreshNotice != nil) {
                NSString *str = @"1";
                self.isRefreshNotice(str);
            }
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"操作成功"];
        }
        if (data == nil) {
            [MBProgressHUD showError:@"网络错误"];
        }
    }];
}
- (void)updataNoiceWithTitle:(NSString *)title content:(NSString *)content userIds:(NSString *)userIds bid:(NSString *)bid {
    [HttpRequestEngine updataNoticeWithTitle:title content:content userIds:userIds bid:bid completion:^(id obj, NSString *errorStr) {
        NSDictionary *data = obj;
        NSString *code = [NSString stringWithFormat:@"%@",data[@"code"]];
        if ([code  isEqualToString:@"1"]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",data[@"errorMsg"]]];
        } else {
            if (self.isRefreshNotice != nil) {
                NSString *str = @"1";
                self.isRefreshNotice(str);
            }
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"操作成功"];
        }
        if (data == nil) {
            [MBProgressHUD showError:@"网络错误"];
        }
    }];
}

#pragma mark -- textView代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
//        [textView resignFirstResponder];
        return YES; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}



- (void)textViewDidChange:(UITextView *)textView {
    if (textView.tag == 1000) {
        UILabel *lab = [textView viewWithTag:1001];
        if (textView.text.length==0) {
            lab.hidden = NO;
        }else {
            lab.hidden = YES;
        }
        self.titleText = textView.text;
        [self.NoticeDetailsTableView beginUpdates];
        [self.NoticeDetailsTableView endUpdates];
    } else {
        UILabel *lab = [textView viewWithTag:1003];
        if (textView.text.length==0) {
            lab.hidden = NO;
        }else {
            lab.hidden = YES;
        }
        if (textView.text.length > 1999) {
            textView.text = [textView.text substringToIndex:1999];
        }
        self.contentText = textView.text;
        [self.NoticeDetailsTableView beginUpdates];
        [self.NoticeDetailsTableView endUpdates];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 1000) {
        UILabel *lab = [textView viewWithTag:1001];
        if (textView.text.length==0) {
            lab.hidden = NO;
        }else {
            lab.hidden = YES;
        }
        self.titleText = textView.text;
        NSString *headerData = self.titleText;
        headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [self.NoticeDetailsTableView reloadData];
    } else {
        UILabel *lab = [textView viewWithTag:1003];
        if (textView.text.length==0) {
            lab.hidden = NO;
        }else {
            lab.hidden = YES;
        }
        self.contentText = textView.text;
        [self.NoticeDetailsTableView reloadData];
    }
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
