//
//  searchApprovalViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "ApprovalDetailViewController.h"
#import "approvalDetailTableViewCell.h"
#import "approvalStateTableViewCell.h"
#import "approvalChooseTableViewCell.h"
#import "approvalImageTableViewCell.h"
#import "approvalImageTwoTableViewCell.h"
#import "approvalTimeTableViewCell.h"
#import "approvalContentTableViewCell.h"

#import "approvalNoticeTableViewCell.h"
#import "approvalTFTableViewCell.h"
#import "approvalTFTwoTableViewCell.h"
#import "approvalLBTableViewCell.h"
#import "approcalLBTwoTableViewCell.h"

#import "approvalFlowViewController.h"

#import "approvalHistoryViewController.h"

#import "approvalTypePicker.h"
#import "DatePickerTwoView.h"
#import "DatePickerThree.h"
#import "hourPickerView.h"

#import "approvalDetailModel.h"

#import "approvalIconModel.h"

#import "HXPhotoViewController.h"
#import "HXPhotoView.h"


#import "ContactModel.h"

#import "chooseViewController.h"


#import "approvalOrRejectView.h"
#import "IQKeyboardManager.h"
#import "approvalHistoryModel.h"

#import "DateTimeSelectView.h"
#import "signInModel.h"
@interface ApprovalDetailViewController ()<JKAlertViewDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,HXPhotoViewDelegate,SelectDateTimeDelegate>
{
    CGSize size;
    CGFloat rowHeight;
}

@property (strong, nonatomic) HXPhotoManager *manager;

@property (nonatomic, strong) UITableView *approvalDetailTableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) approvalDetailModel *model;
@property (nonatomic, strong) NSArray *childClassArr;
@property (nonatomic, strong) NSMutableArray *childClassNameArr;

@property (nonatomic, strong) approvalTypePicker *approvalTypePickerView;

@property (nonatomic, strong) DatePickerTwoView *datePickerOne;
@property (nonatomic, strong) DatePickerTwoView *datePickerTwo;
@property (nonatomic, strong) DatePickerThree *datePickerThree;
@property (nonatomic, strong) DatePickerThree *datePickerFour;

@property (nonatomic, strong) hourPickerView *hourPicker;

@property (nonatomic, strong) NSString *flowNameStr;
@property (nonatomic, strong) NSString *flowIdStr;

@property (nonatomic, strong) LoginPeopleModel *loginModel;

@property (nonatomic, strong) NSMutableArray *iconArr;

@property (nonatomic, strong) NSMutableArray *iconDicArr;

@property (nonatomic, strong) NSMutableArray *selectedImageArr;

@property (nonatomic, assign) NSInteger imageIndex;//上传图片用到的index值

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) BOOL isChooseHour;


@property (nonatomic, strong) NSMutableArray *noticePeopleMutableArr;

@property (nonatomic, strong) UIView *approvalBottomView;//审批的时候
@property (nonatomic, strong) UIView *editBottomView;//驳回的时候
@property (nonatomic, strong) UIView *editOrDeleteBottomView;//未提交的时候
@property (nonatomic, strong) UIView *recallBottomView;//撤回的时候

@property (nonatomic, strong) UIView *approvalView;

@property (nonatomic, strong) approvalOrRejectView *approvalOrrejectView;

@property (nonatomic, strong) NSMutableArray *historyArr;

@property (nonatomic, strong) UIView *vv;

@property (nonatomic, strong) NSMutableArray *deleteImgaeArr;
@property (nonatomic, assign) NSInteger deleteImageIndex;//删除图片用到的index值

@property (nonatomic, strong) DateTimeSelectView *dateTimeSelectViewOne;
@property (nonatomic, strong) NSString *qingJiaChoseStr;
@property (nonatomic, strong) NSString *qingJiaHourStr;
@property (nonatomic, assign) NSInteger dateTimeSelectStr;

@property (nonatomic, strong) DateTimeSelectView *dateTimeSelectViewTwo;

@property (nonatomic, strong) NSMutableArray *UploadImageArr;
@property (nonatomic, assign) BOOL isShowHour;

@property (nonatomic, strong) signInModel *signModel;
//@property (nonatomic, strong) NSString *flowID;
@end
/**
 id                         否	int         id
 seq_id                     否	int         申请流程id
 mech_id                    是	int         机构id
 user_id                    是	int         申请人id
 leave_type_id              是	int         请假类型、报销类型id
 start_time                 是	String      开始时间(请假日期， 加班时间,离职申请)
 end_time                   是	String      结束时间 (请假日期， 加班时间,离职申请)
 clock_time                 是	String      打卡时间 ，转正申请，交货日期
 hour                       是	int         时长（请假，加班）
 reimbursement_amount       是	float       报销金额/预算
 position                   是	String      职位(离职申请,转正申请)
 handover                   是	String      交接事项
 businessAddress            是	String      出差地址
 goodsPurchased             是	String      采购的物品
 apply_id                   是	int         使用人id
 specificationModel         是	String      规格型号
 number                     是	int         数量
 title                      是	String      标题
 leave_reason               是	String      请假原因/报销说明/离职原因/试用总结/行程说明/理由/申请原因/说明
 toUser                     是	int         通知人 （1,22）
 nextUserId                 否	int         下个环节id
 application_id             是	int         申请事项id
 flow_id                    是	int         流程id
 state_type                 是	int         1 未提交 2 撤回 3 审批中 4 驳回 5审批通过
 nowUserId                  否	int         当前批准id
 reason                     否	String      批准理由
 iconList                   是	List        图片
 iconList.icon              是	String      图片路径
 */
@implementation ApprovalDetailViewController
- (UIView *)approvalBottomView {
    if (!_approvalBottomView) {
        _approvalBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        if (IS_IPHONE_X) {
            _approvalBottomView.frame = CGRectMake(0, kScreenHeight - 68, kScreenWidth, 68);
        }
        _approvalBottomView.backgroundColor = [UIColor whiteColor];
        UIButton *rejectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rejectBtn setTitle:@"驳回" forState:UIControlStateNormal];
        [rejectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        rejectBtn.frame = CGRectMake(0, 0, kScreenWidth/2.0, 44);
        rejectBtn.tag = 1;
        [_approvalBottomView addSubview:rejectBtn];
        [rejectBtn addTarget:self action:@selector(approvalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-0.25, 8, 0.5, 28)];
        lineV.backgroundColor = GRAY180;
        [_approvalBottomView addSubview:lineV];
        
        UIButton *approvalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [approvalBtn setTitle:@"批准" forState:UIControlStateNormal];
        [approvalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        approvalBtn.frame = CGRectMake(kScreenWidth/2.0, 0, kScreenWidth/2.0, 44);
        approvalBtn.tag = 2;
        [_approvalBottomView addSubview:approvalBtn];
        [approvalBtn addTarget:self action:@selector(approvalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _approvalBottomView;
}
- (UIView *)editBottomView {
    if (!_editBottomView) {
        _editBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        if (IS_IPHONE_X) {
            _editBottomView.frame = CGRectMake(0, kScreenHeight - 68, kScreenWidth, 68);
        }
        _editBottomView.backgroundColor = [UIColor whiteColor];
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setTitle:@"编    辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        editBtn.frame = CGRectMake(0, 0, kScreenWidth, 44);
        editBtn.tag = 1;
        [_editBottomView addSubview:editBtn];
        [editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _editBottomView;
}

- (UIView *)editOrDeleteBottomView {
    if (!_editOrDeleteBottomView) {
        _editOrDeleteBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        if (IS_IPHONE_X) {
            _editOrDeleteBottomView.frame = CGRectMake(0, kScreenHeight - 68, kScreenWidth, 68);
        }
        _editOrDeleteBottomView.backgroundColor = [UIColor whiteColor];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        deleteBtn.frame = CGRectMake(0, 0, kScreenWidth/2.0, 44);
        deleteBtn.tag = 1;
        [_editOrDeleteBottomView addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-0.25, 8, 0.5, 28)];
        lineV.backgroundColor = GRAY180;
        [_editOrDeleteBottomView addSubview:lineV];
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        editBtn.frame = CGRectMake(kScreenWidth/2.0, 0, kScreenWidth/2.0, 44);
        editBtn.tag = 2;
        [_editOrDeleteBottomView addSubview:editBtn];
        [editBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editOrDeleteBottomView;
}
- (UIView *)recallBottomView {
    if (!_recallBottomView) {
        _recallBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44)];
        if (IS_IPHONE_X) {
            _recallBottomView.frame = CGRectMake(0, kScreenHeight - 68, kScreenWidth, 68);
        }
        _recallBottomView.backgroundColor = [UIColor whiteColor];
        UIButton *recallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [recallBtn setTitle:@"撤    回" forState:UIControlStateNormal];
        [recallBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        recallBtn.frame = CGRectMake(0, 0, kScreenWidth, 44);
        recallBtn.tag = 1;
        [_recallBottomView addSubview:recallBtn];
        [recallBtn addTarget:self action:@selector(recallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _recallBottomView;
}
- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.outerCamera = YES;
        _manager.goCamera = NO;
        _manager.lookGifPhoto = NO;
        _manager.lookLivePhoto = NO;
        _manager.openCamera = NO;
    }
    return _manager;
}

- (UITableView *)approvalDetailTableView {
    if (!_approvalDetailTableView) {
        _approvalDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10) style:UITableViewStylePlain];
        if (IS_IPHONE_X) {
            _approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight-NaviHeight-10-30);
        }
        _approvalDetailTableView.layer.cornerRadius = 10;
        _approvalDetailTableView.delegate = self;
        _approvalDetailTableView.dataSource = self;
        _approvalDetailTableView.tableFooterView = [UIView new];
        _approvalDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _approvalDetailTableView.backgroundColor = TABBAR_BASE_COLOR;
        [_approvalDetailTableView registerClass:[approvalDetailTableViewCell class] forCellReuseIdentifier:@"one"];
        [_approvalDetailTableView registerClass:[approvalStateTableViewCell class] forCellReuseIdentifier:@"two"];
        [_approvalDetailTableView registerClass:[approvalChooseTableViewCell class] forCellReuseIdentifier:@"three"];
        [_approvalDetailTableView registerClass:[approvalImageTableViewCell class] forCellReuseIdentifier:@"four"];
        [_approvalDetailTableView registerClass:[approvalTimeTableViewCell class] forCellReuseIdentifier:@"five"];
        [_approvalDetailTableView registerClass:[approvalContentTableViewCell class] forCellReuseIdentifier:@"six"];
        [_approvalDetailTableView registerClass:[approvalNoticeTableViewCell class] forCellReuseIdentifier:@"seven"];
        [_approvalDetailTableView registerClass:[approvalTFTableViewCell class] forCellReuseIdentifier:@"eight"];
        [_approvalDetailTableView registerClass:[approvalTFTwoTableViewCell class] forCellReuseIdentifier:@"nine"];
        [_approvalDetailTableView registerClass:[approvalLBTableViewCell class] forCellReuseIdentifier:@"ten"];
        [_approvalDetailTableView registerClass:[approvalImageTwoTableViewCell class] forCellReuseIdentifier:@"eleven"];
        [_approvalDetailTableView registerClass:[approcalLBTwoTableViewCell class] forCellReuseIdentifier:@"twelve"];
    }
    return _approvalDetailTableView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _topView.backgroundColor = TABBAR_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 6, kScreenWidth-20, 19)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 10;
        [_topView addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kScreenWidth-20, 9)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:backTwoV];
    }
    return _topView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _bottomView.backgroundColor = TABBAR_BASE_COLOR;
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 19)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 10;
        [_bottomView addSubview:backV];
        
        UIView *backTwoV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 9)];
        backTwoV.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:backTwoV];
    }
    return _bottomView;
}
- (void)viewWillAppear:(BOOL)animated {
//    if (self.type == 1) {
//        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TABBAR_BASE_COLOR;
    
    rowHeight = 14;
    self.noticePeopleMutableArr = [NSMutableArray arrayWithCapacity:0];
    
    self.vv = [[UIView alloc]initWithFrame:self.view.bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.loginModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.iconArr = [NSMutableArray arrayWithCapacity:0];
    self.iconDicArr = [NSMutableArray arrayWithCapacity:0];
    self.deleteImgaeArr = [NSMutableArray arrayWithCapacity:0];
    self.isChooseHour = 0;
    self.imageIndex = 0;
    self.deleteImageIndex = 0;
    self.isShowHour = 1;
    if (self.type == 1) {
        self.isEdit = 1;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
        self.model = [[approvalDetailModel alloc]init];
        switch ([self.application_id integerValue]) {
            case 1:
                self.title = @"报销审批";
                [self requestApprovalChildClass];
                break;
            case 2:
                self.title = @"请假审批";
                [self requestApprovalChildClass];
                [self requestWorkTime];
                break;
            case 3:
                self.title = @"离职审批";
                break;
            case 4:
                self.title = @"转正审批";
                break;
            case 5:
                self.title = @"加班审批";
                break;
            case 6:
                self.title = @"出差审批";
                break;
            case 7:
                self.title = @"补打卡审批";
                break;
            case 8:
                self.title = @"采购审批";
                break;
            case 9:
                self.title = @"普通审批";
                break;
            case 10:
                self.title = @"外勤审批";
                break;
            default:
                break;
        }
        
        
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(clickUpLoad)];
        self.navigationItem.rightBarButtonItem = rightItem;
    } else if (self.type == 2) {
        
        self.title = @"审批详情";
        
        self.isEdit = 0;
        
        [self requestDetails];
    } else {
        
        self.title = @"审批详情";
        self.isEdit = 0;
        self.model = self.detailModel;
    }
    
    [self.view addSubview:self.approvalDetailTableView];
    
    // Do any additional setup after loading the view.
}

- (void)requestWorkTime {
    NSString *mech_id = [NSString stringWithFormat:@"%ld",self.MyUserInfoModel.jrqMechanismId];
    [HttpRequestEngine getConfigurationWithMech_id:mech_id Completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            self.signModel = [signInModel requestWithDic:obj];
        } else {
            JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"企业未设置工作时间" message:@"请进入考勤-设置-签到设置设置企业工作时间" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
            alert.tag = 3;
            [alert show];
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    [self.approvalDetailTableView endEditing:YES];
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    switch ([self.application_id integerValue]) {
        case 1:
            self.title = @"报销审批";
            break;
        case 2:
        {
            self.hourPicker = [[hourPickerView alloc]initWithCustomeHeight:250];
            _dateTimeSelectViewOne = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMddHHmmss"];
            _dateTimeSelectViewOne.delegateGetDate = self;
            
            _dateTimeSelectViewTwo = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMddHHmmss"];
            _dateTimeSelectViewTwo.delegateGetDate = self;
        }
            break;
        case 3:
        {
            self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
            self.datePickerTwo = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
        }
            break;
        case 4:
        {
            self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
        }
            break;
        case 5:
        {
//            self.datePickerThree = [[DatePickerThree alloc]initWithCustomeHeight:250];
//            self.datePickerFour = [[DatePickerThree alloc]initWithCustomeHeight:250];
            
            _dateTimeSelectViewOne = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMddHHmm"];
            _dateTimeSelectViewOne.delegateGetDate = self;
            
            _dateTimeSelectViewTwo = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMddHHmm"];
            _dateTimeSelectViewTwo.delegateGetDate = self;
        }
            break;
        case 6:
        {
            self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
            self.datePickerTwo = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
            self.hourPicker = [[hourPickerView alloc]initWithCustomeHeight:250];
        }
            break;
        case 7:
        {
            self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
        }
            break;
        case 8:
        {
            self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
        }
            break;
        case 9:
            
            break;
        case 10:
        {
//            self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
//            self.datePickerTwo = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
//            self.hourPicker = [[hourPickerView alloc]initWithCustomeHeight:250];
            
            _dateTimeSelectViewOne = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMddHHmm"];
            _dateTimeSelectViewOne.delegateGetDate = self;
            
            _dateTimeSelectViewTwo = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyyMMddHHmm"];
            _dateTimeSelectViewTwo.delegateGetDate = self;
        }
        default:
            break;
    }
    
    
    
    [self.approvalDetailTableView reloadData];
}
- (void)requestDetails {
    [MBProgressHUD showMessage:@"正在加载..."];
    [HttpRequestEngine getApprovalDetailWithId:self.ID mech_id:self.mech_id seq_id:self.seq_id completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            self.model = [approvalDetailModel requestWithDic:obj];
            self.application_id = self.model.application_id;
            NSArray *iconArr = obj[@"iconList"];
            for (NSDictionary *dic in iconArr) {
                approvalIconModel *iconModel = [approvalIconModel requestWithDic:dic];
                NSString *iconURL = [NSString stringWithFormat:@"%@",[iconModel.icon stringByReplacingOccurrencesOfString:@".jpg" withString:@"_min.jpg"]];
                
                [self.iconArr addObject:iconURL];
            }
            
            if ([self.model.state_type isEqualToString:@"未提交"] || [self.model.state_type isEqualToString:@"撤回"] || [self.model.state_type isEqualToString:@"驳回"]) {
                
                self.isEdit = 0;
            }
            if (self.indexID == 2) {
                self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 44);
                if (IS_IPHONE_X) {
                    self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 24 - 44);
                }
                [self.view addSubview:self.approvalBottomView];
            } else {
                if ([self.seq_id isEqualToString:@"1"] && [self.model.state_type isEqualToString:@"审批中"]) {
                    self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 44);
                    if (IS_IPHONE_X) {
                        self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 24 - 44);
                    }
                    [self.view addSubview:self.recallBottomView];
                }
                if ([self.model.state_type isEqualToString:@"未提交"]) {
                    self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 44);
                    if (IS_IPHONE_X) {
                        self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 24 - 44);
                    }
                    [self.view addSubview:self.editOrDeleteBottomView];
                }
                if ([self.model.state_type isEqualToString:@"驳回"]) {
                    self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 44);
                    if (IS_IPHONE_X) {
                        self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 24 - 44);
                    }
                    [self.view addSubview:self.editOrDeleteBottomView];
                }
                if ([self.model.state_type isEqualToString:@"撤回"]) {
                    self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 44);
                    if (IS_IPHONE_X) {
                        self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight+5, kScreenWidth-20, kScreenHeight - NaviHeight - 10 - 24 - 44);
                    }
                    [self.view addSubview:self.editOrDeleteBottomView];
                }
            }
            [self.approvalDetailTableView reloadData];
            [self requestApprovalChildClass];
            [MBProgressHUD hideHUD];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (void)requestApprovalChildClass{
    [HttpRequestEngine getApprovalChildWithApplicationId:self.application_id completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            
            self.childClassArr = (NSArray *)obj;
            if (self.childClassArr.count) {
                self.childClassNameArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in self.childClassArr) {
                    NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                    [self.childClassNameArr addObject:name];
                }
                _approvalTypePickerView = [[approvalTypePicker alloc] initWithCustomeHeight:250 titleArray:self.childClassNameArr];
                self.datePickerOne = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
                self.datePickerTwo = [[DatePickerTwoView alloc]initWithCustomeHeight:250];
                [self.approvalDetailTableView reloadData];
            }
            
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25;
    }
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 40;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        return 95;
    } else if (indexPath.section == 1) {
        switch ([self.application_id integerValue]) {
            case 1:
            {
                if (indexPath.row == 2) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 || indexPath.row == 1) {
                    return 70;
                }
                if (self.isEdit) {
                    if (indexPath.row == 3) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 4) {
                        return 22;
                    }
                    if (indexPath.row == 5) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 3) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 4) {
                            return 22;
                        }
                        if (indexPath.row == 5) {
                            
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 3) {
                            return 22;
                        }
                        if (indexPath.row == 4) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }

                        }
                    }

                }
                
                
            }
                break;
            case 2:
            {
                if (indexPath.row == 4) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
                    return 70;
                }
                if (self.isEdit) {
                    
                    if (indexPath.row == 6) {
                        return 22;
                    }
                    if (indexPath.row == 7) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                    if (indexPath.row == 5) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        
                        if (indexPath.row == 6) {
                            return 22;
                        }
                        if (indexPath.row == 7) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                        if (indexPath.row == 5) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                    } else {
                        if (indexPath.row == 5) {
                            return 22;
                        }
                        if (indexPath.row == 6) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
            }
                break;
            case 3:
            {
                if (indexPath.row == 4) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
                    return 70;
                }
                if (self.isEdit) {
                    if (indexPath.row == 5) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 6) {
                        return 22;
                    }
                    if (indexPath.row == 7) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 5) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 6) {
                            return 22;
                        }
                        if (indexPath.row == 7) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }else {
                        if (indexPath.row == 5) {
                            return 22;
                        }
                        if (indexPath.row == 6) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
            }
                break;
            case 4:
            {
                if (indexPath.row == 2) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 || indexPath.row == 1  ) {
                    return 70;
                }
                if (self.isEdit) {
                    if (indexPath.row == 3) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 4) {
                        return 22;
                    }
                    if (indexPath.row == 5) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 3) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 4) {
                            return 22;
                        }
                        if (indexPath.row == 5) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 3) {
                            return 22;
                        }
                        if (indexPath.row == 4) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
            }
                break;
            case 5:
            {
                if (indexPath.row == 3) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 ) {
                    return 70;
                }
                if (self.isEdit) {
                    
                    if (indexPath.row == 4) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 5) {
                        return 22;
                    }
                    if (indexPath.row == 6) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 4) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 5) {
                            return 22;
                        }
                        if (indexPath.row == 6) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 4) {
                            return 22;
                        }
                        if (indexPath.row == 5) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
                
            }
                break;
            case 6:
            {
                if (indexPath.row == 4) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                
                if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
                    return 70;
                }
                if (self.isEdit) {
                    if (indexPath.row == 5) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 6) {
                        return 22;
                    }
                    if (indexPath.row == 7) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 5) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 6) {
                            return 22;
                        }
                        if (indexPath.row == 7) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 5) {
                            return 22;
                        }
                        if (indexPath.row == 6) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
                
            }
                break;
            case 7:
            {
                if (indexPath.row == 1) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 ) {
                    return 70;
                }
                if (self.isEdit) {
                    
                    if (indexPath.row == 2) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 3) {
                        return 22;
                    }
                    if (indexPath.row == 4) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 2) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 3) {
                            return 22;
                        }
                        if (indexPath.row == 4) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 2) {
                            return 22;
                        }
                        if (indexPath.row == 3) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
            }
                break;
            case 8:
            {
                if (indexPath.row == 7) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6) {
                    return 70;
                }
                if (self.isEdit) {
                    
                    if (indexPath.row == 8) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 9) {
                        return 22;
                    }
                    if (indexPath.row == 10) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 8) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 9) {
                            return 22;
                        }
                        if (indexPath.row == 10) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 8) {
                            return 22;
                        }
                        if (indexPath.row == 9) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }

            }
                break;
            case 9:
            {
                if (indexPath.row == 1) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                if (indexPath.row == 0 ) {
                    return 70;
                }
                if (self.isEdit) {
                    
                    if (indexPath.row == 2) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 3) {
                        return 22;
                    }
                    if (indexPath.row == 4) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 2) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 3) {
                            return 22;
                        }
                        if (indexPath.row == 4) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 2) {
                            return 22;
                        }
                        if (indexPath.row == 3) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
            }
                break;
            case 10:
            {
                if (indexPath.row == 4) {
                    if (self.type == 2) {
                        CGFloat Height = [self.model.leave_reason heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        
                        rowHeight = Height;
                    }
                    if (rowHeight<14) {
                        rowHeight = 14;
                    }
                    return 50+rowHeight;
                }
                
                if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
                    return 70;
                }
                if (self.isEdit) {
                    if (indexPath.row == 5) {
                        CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                        if (Height < 15) {
                            return 80;
                        } else {
                            return 40+25+Height;
                        }
                    }
                    if (indexPath.row == 6) {
                        return 22;
                    }
                    if (indexPath.row == 7) {
                        if (self.iconArr.count+self.UploadImageArr.count >= 4) {
                            return ((kScreenWidth-40-9)/4.0)*2+23;
                        } else {
                            return ((kScreenWidth-40-9)/4.0)+23;
                        }
                    }
                } else {
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (indexPath.row == 5) {
                            CGFloat Height = [self.model.toUserName heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
                            if (Height < 15) {
                                return 80;
                            } else {
                                return 40+25+Height;
                            }
                        }
                        if (indexPath.row == 6) {
                            return 22;
                        }
                        if (indexPath.row == 7) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    } else {
                        if (indexPath.row == 5) {
                            return 22;
                        }
                        if (indexPath.row == 6) {
                            if (self.iconArr.count > 4) {
                                return ((kScreenWidth-40-9)/4.0)*2+23;
                            } else {
                                return ((kScreenWidth-40-9)/4.0)+23;
                            }
                        }
                    }
                }
                
            }
                break;
        }
    }
    return 80;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        switch ([self.application_id integerValue]) {
            case 1:
            {
                if (self.isEdit) {
                    return 6;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 6;
                        } else {
                            return 4;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 5;
                        } else {
                            return 3;
                        }
                    }
                }
            }
                break;
            case 2:
            {
                if (self.isEdit) {
                    return 8;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 8;
                        } else {
                            return 6;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 7;
                        } else {
                            return 5;
                        }
                    }

                }
                
            }
                break;
            case 3:
            {
                if (self.isEdit) {
                    return 8;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 8;
                        } else {
                            return 6;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 7;
                        } else {
                            return 5;
                        }
                    }

                }
                
            }
                break;
            case 4:
            {
                if (self.isEdit) {
                    return 6;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 6;
                        } else {
                            return 4;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 5;
                        } else {
                            return 3;
                        }
                    }

                }
            }
                break;
            case 5:
            {
                if (self.isEdit) {
                    return 7;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 7;
                        } else {
                            return 5;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 6;
                        } else {
                            return 4;
                        }
                    }
                    
                }
            }
                break;
            case 6:
            {
                if (self.isEdit) {
                    return 8;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 8;
                        } else {
                            return 6;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 7;
                        } else {
                            return 5;
                        }
                    }
                
                }
                
            }
                break;
            case 7:
            {
                if (self.isEdit) {
                    return 5;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 5;
                        } else {
                            return 3;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 4;
                        } else {
                            return 2;
                        }
                    }
                    
                }
                
            }
                break;
            case 8:
            {
                if (self.isEdit) {
                    return 11;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 11;
                        } else {
                            return 9;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 10;
                        } else {
                            return 8;
                        }
                    }
                }
            }
                break;
            case 9:
            {
                if (self.isEdit) {
                    return 5;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 5;
                        } else {
                            return 3;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 4;
                        } else {
                            return 2;
                        }
                    }
                }
            }
                break;
            case 10:
            {
                if (self.isEdit) {
                    return 8;
                } else {
                    
                    if (![Utils isBlankString:self.model.toUserName]) {
                        if (self.iconArr.count) {
                            return 8;
                        } else {
                            return 6;
                        }
                    } else {
                        if (self.iconArr.count) {
                            return 7;
                        } else {
                            return 5;
                        }
                    }
                    
                }
                
            }
                break;
        }
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.topView;
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        view.backgroundColor = TABBAR_BASE_COLOR;
        
        UIImageView *upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"approvalDown"]];
        upImage.frame = CGRectMake(0, 0, kScreenWidth-20, 26);
        [view addSubview:upImage];
        
        return view;

    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        view.backgroundColor = TABBAR_BASE_COLOR;
        
        UIImageView *upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"approvalUp"]];
        upImage.frame = CGRectMake(0, 0, kScreenWidth-20, 15);
        [view addSubview:upImage];
        
        return view;

    } else {
        return self.bottomView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            approvalDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
            if (cell == nil) {
                cell = [[approvalDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
            }
            
            if (self.type == 1) {
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr = [dateFormatter stringFromDate:date];
                cell.timeLB.text = dateStr;
                cell.nameLB.text = [NSString stringWithFormat:@"%@",self.loginModel.realName];
                [cell.headerImage sd_setImageWithURL:[self.loginModel.iconURL convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
            } else {
                cell.timeLB.text = self.model.create_time;
                [cell.headerImage sd_setImageWithURL:[self.model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
                if ([Utils isBlankString:self.model.nick_name]) {
                    cell.nameLB.text = @" ";
                } else {
                    cell.nameLB.text = [NSString stringWithFormat:@"%@",self.model.nick_name];
                }
            }
            
            switch ([self.application_id integerValue]) {
                case 1:
                    cell.dayLB.text = @"报销审批";
                    break;
                case 2:
                    cell.dayLB.text = @"请假审批";
                    break;
                case 3:
                    cell.dayLB.text = @"离职审批";
                    break;
                case 4:
                    cell.dayLB.text = @"转正审批";
                    break;
                case 5:
                    cell.dayLB.text = @"加班审批";
                    break;
                case 6:
                    cell.dayLB.text = @"出差审批";
                    break;
                case 7:
                    cell.dayLB.text = @"补打卡审批";
                    break;
                case 8:
                    cell.dayLB.text = @"采购审批";
                    break;
                case 9:
                    cell.dayLB.text = @"普通审批";
                    break;
                case 10:
                    cell.dayLB.text = @"外勤审批";
                    break;
                default:
                    break;
            }
            
            if (self.isEdit) {
                cell.numberLB.text = [[self.model.create_time substringFromIndex:11] substringToIndex:5];
            }else {
                cell.numberLB.text = self.model.deptName;
            }
            
            return cell;
        } else {
            approvalStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
            if (cell == nil) {
                cell = [[approvalStateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
            }
            if (self.isEdit == 1) {
                cell.stateV.backgroundColor = kMyColor(223, 74, 44);
                cell.stateLB.text = @"审批流";
                if (![Utils isBlankString:self.model.flow_name]) {
                    cell.titleLB.text = self.self.model.flow_name;
                    cell.titleLB.textColor = [UIColor blackColor];
                } else {
                    cell.titleLB.text = @"请选择审批流程";
                    cell.titleLB.textColor = GRAY180;
                }
            } else {
                if ([self.model.state_type isEqualToString:@"未提交"] || [self.model.state_type isEqualToString:@"撤回"]) {
                    cell.stateV.backgroundColor = UIColorFromRGB(0xfa4a4a4,1);
                } else if ([self.model.state_type isEqualToString:@"驳回"]){
                    cell.stateV.backgroundColor = UIColorFromRGB(0xfFF0000,1);
                } else if ([self.model.state_type isEqualToString:@"通过"]) {
                    cell.stateV.backgroundColor = UIColorFromRGB(0xf2aa515,1);
                } else {
                    cell.stateV.backgroundColor = UIColorFromRGB(0xf4E9CF0,1);
                }
                
                
                cell.stateLB.text = self.model.state_type;
                
                cell.titleLB.text = self.model.nextNickName;
            }
            
            return cell;
        }
    } else {
        switch ([self.application_id integerValue]) {
#pragma mark == 报销审批cell
            case 1:
            {
                if (indexPath.row == 0) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    
                    cell.titleLabel.text = @"报销类型";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                        
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择类型";
                        cell.arrow.hidden = NO;
                    }
                    NSString *typeName;
                    for (NSDictionary *dic in self.childClassArr) {
                        if ([self.model.leave_type_id isEqualToString:[NSString stringWithFormat:@"%@",dic[@"id"]]]) {
                            typeName = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        }
                    }
                    cell.chooseTF.text = typeName;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _approvalTypePickerView.confirmOneBlock = ^(NSString *choseStr) {
                        
                        cell.chooseTF.text = choseStr;
                        for (NSDictionary *dic in weakSelf.childClassArr) {
                            NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                            NSString *ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                            if ([choseStr isEqualToString:name]) {
                                weakSelf.model.leave_type_id = ID;
                            }
                        }
                        
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _approvalTypePickerView.cannelOneBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    
                    cell.chooseTF.inputView = _approvalTypePickerView;
                    
                    return cell;
                } else if (indexPath.row == 1){
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"输入金额";
                    }
                    cell.chooseTF.text = self.model.reimbursement_amount;
                    
                    cell.chooseTF.keyboardType = UIKeyboardTypeDecimalPad;
                    
                    cell.titleLabel.text = @"报销金额(元)";
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"报销说明";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                        
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.text = @"输入说明";
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 3) {
                            
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 4) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 5) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    [self.deleteImgaeArr addObject:imageURL];
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 3) {
                                
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 4) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 5) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                        [self.deleteImgaeArr addObject:imageURL];
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 3) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 4) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                        [self.deleteImgaeArr addObject:imageURL];
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                    
                }
            }
                break;
#pragma mark == 请假审批cell
            case 2:
            {
                if (indexPath.row == 0) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    
                    cell.titleLabel.text = @"请假类型";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择类型";
                        cell.arrow.hidden = NO;
                    }
                    NSString *typeName;
                    for (NSDictionary *dic in self.childClassArr) {
                        if ([self.model.leave_type_id isEqualToString:[NSString stringWithFormat:@"%@",dic[@"id"]]]) {
                            typeName = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        }
                    }
                    cell.chooseTF.text = typeName;
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _approvalTypePickerView.confirmOneBlock = ^(NSString *choseStr) {
                        
                        cell.chooseTF.text = choseStr;
                        for (NSDictionary *dic in weakSelf.childClassArr) {
                            NSString *name = [NSString stringWithFormat:@"%@",dic[@"name"]];
                            NSString *ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                            if ([choseStr isEqualToString:name]) {
                                weakSelf.model.leave_type_id = ID;
                            }
                        }
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _approvalTypePickerView.cannelOneBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    
                    cell.chooseTF.inputView = _approvalTypePickerView;
                    
                    return cell;
                } else if (indexPath.row == 1){
                    approvalTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
                    if (cell == nil) {
                        cell = [[approvalTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
                    }
                    
                    
                    cell.stateLB.delegate = self;
                    if (!self.isEdit) {
                        cell.stateLB.enabled = NO;
                        if (![Utils isBlankString:self.model.hour]) {
                            
                            if (([[Utils stringToDate:self.model.end_time withDateFormat:@"yyyy-MM-dd HH:mm"]  timeIntervalSinceDate:[Utils stringToDate:self.model.start_time withDateFormat:@"yyyy-MM-dd HH:mm"]])/(3600*24)>=1) {
                                if ([self.model.hour integerValue] < 8) {
                                    cell.stateLB.text = [NSString stringWithFormat:@"0天 %@小时",self.model.hour];
                                }else {
                                    if (![self.model.hour contains:@"."]) {
                                        if ([self.model.hour integerValue]%8>0) {
                                            cell.stateLB.text = [NSString stringWithFormat:@"%ld天 %ld小时",[self.model.hour integerValue]/8,[self.model.hour integerValue]-([self.model.hour integerValue]/8)*8];
                                        } else {
                                            cell.stateLB.text = [NSString stringWithFormat:@"%ld天",[self.model.hour integerValue]/8];
                                        }
                                    } else {
                                        cell.stateLB.text = [NSString stringWithFormat:@"%ld天 %g小时",[self.model.hour integerValue]/8,[self.model.hour floatValue]-([self.model.hour integerValue]/8)*8];
                                        
                                    }
                                }
                            } else {
                                cell.stateLB.text = [NSString stringWithFormat:@"0天 %@小时",self.model.hour];
                                if ([self.model.hour integerValue] >= 8) {
                                    cell.stateLB.text = [NSString stringWithFormat:@"1天"];
                                }
                            }
                        }
                        
                    } else {
                        
                        self.qingJiaHourStr = [NSString stringWithFormat:@"%g",[self.model.hour floatValue]];
                        if (![Utils isBlankString:self.qingJiaChoseStr]) {
                            self.qingJiaHourStr = [NSString stringWithFormat:@"%g",[self.model.hour floatValue]+[self.qingJiaChoseStr floatValue]];
                        }
                        
                        if (![Utils isBlankString:self.qingJiaHourStr]) {
                            if (self.isShowHour) {
                                if (([[Utils stringToDate:[self.model.end_time substringToIndex:10] withDateFormat:@"yyyy-MM-dd"]  timeIntervalSinceDate:[Utils stringToDate:[self.model.start_time substringToIndex:10] withDateFormat:@"yyyy-MM-dd"]])/(3600*24)>=1) {
                                    if ([self.qingJiaHourStr floatValue] < 8) {
                                        cell.stateLB.text = [NSString stringWithFormat:@"0天 %@小时",self.qingJiaHourStr];
                                    }else {
                                        
                                        if (![self.qingJiaHourStr contains:@"."]) {
                                            if ([self.qingJiaHourStr integerValue]%8>0) {
                                                cell.stateLB.text = [NSString stringWithFormat:@"%ld天 %ld小时",[self.qingJiaHourStr integerValue]/8,[self.qingJiaHourStr integerValue]-([self.qingJiaHourStr integerValue]/8)*8];
                                            } else {
                                                cell.stateLB.text = [NSString stringWithFormat:@"%ld天",([self.qingJiaHourStr integerValue])/8];
                                            }
                                        } else {
                                            cell.stateLB.text = [NSString stringWithFormat:@"%ld天 %.1f小时",[self.qingJiaHourStr integerValue]/8,[self.qingJiaHourStr floatValue]-([self.qingJiaHourStr integerValue]/8)*8];
                                        }
                                        
                                    }
                                }else {
                                    cell.stateLB.text = [NSString stringWithFormat:@"0天 %@小时",self.qingJiaHourStr];
                                    if ([self.qingJiaHourStr integerValue] >= 8) {
                                        cell.stateLB.text = [NSString stringWithFormat:@"1天"];
                                    }
                                    
                                }
                            } else {
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld天 -小时",([self.qingJiaHourStr integerValue]-8)/8];
                            }
                            
                        } else {
                            cell.stateLB.text = @"";
                        }
//                        self.model.hour = self.qingJiaHourStr;
                        __weak typeof (self) weakSelf = self;
                        _hourPicker.confirmOneBlock = ^(NSString *choseHour) {
                            
                            weakSelf.isShowHour = 1;
                            
                            if ([self.model.hour floatValue]>=8) {
                                
                                if ([Utils isBlankString:weakSelf.qingJiaChoseStr] && [self.model.hour floatValue]>8) {
                                    weakSelf.model.hour = [NSString stringWithFormat:@"%ld",(([self.model.hour integerValue]-8)/8)*8];
                                }
                                weakSelf.qingJiaChoseStr = choseHour;
                            }else {
                                weakSelf.model.hour = choseHour;
                            }
                            
                            
                            [weakSelf.approvalDetailTableView endEditing:YES];
                            
                        };
                        
                        _hourPicker.cannelOneBlock = ^(){
                            [weakSelf.approvalDetailTableView endEditing:YES];
                        };
                        
                        if (self.isChooseHour) {
                            cell.stateLB.enabled = NO;
                            cell.stateLB.inputView = self.hourPicker;
                            cell.stateLB.placeholder = @"请选择时长";
                        }else {
                            cell.stateLB.enabled = NO;
                            cell.stateLB.placeholder = @"时长";
                        }
                        
                    }
                    cell.stateLB.tag = indexPath.row+1;
                    cell.titleLB.text = @"请假时长";
                    
                    
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"开始时间";
                    
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else{
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择开始时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.text = self.model.start_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.start_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _dateTimeSelectViewOne;
                    
                    return cell;
                } else if (indexPath.row == 3) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"结束时间";
                    
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    }else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择结束时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.text = self.model.end_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerTwo.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.end_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerTwo.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _dateTimeSelectViewTwo;
                    
                    return cell;
                } else if (indexPath.row == 4) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.titleLabel.text = @"请假原因";
                    cell.placeholder.text = @"输入原因";
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else{
                    if (self.isEdit) {
                        if (indexPath.row == 5) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 6) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 7) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 5) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 7) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 5) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 离职审批cell
            case 3:
            {
                if (indexPath.row == 0) {
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"职位";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.position;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.position;
                        cell.chooseTF.placeholder = @"输入职位";
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 1) {
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.star.hidden = YES;
                    cell.titleLabel.text = @"交接事项";
                    cell.chooseTF.text = self.model.handover;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"输入交接事项";
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"入职时间";
                    cell.star.hidden = NO;
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择入职时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.text = self.model.start_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.start_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerOne;
                    
                    return cell;
                } else if (indexPath.row == 3) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"离职时间";
                    cell.star.hidden = NO;
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择离职时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.text = self.model.end_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerTwo.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.end_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerTwo.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerTwo;
                    
                    return cell;
                } else if (indexPath.row == 4) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"离职原因";
                    cell.placeholder.text = @"输入原因";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 5) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 6) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 7) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 5) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 7) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 5) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 转正审批cell
            case 4:
            {
                if (indexPath.row == 0) {
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"职位";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.position;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.position;
                        cell.chooseTF.placeholder = @"输入职位";
                    }
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 1) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"入职时间";
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.clock_time;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.clock_time;
                        cell.chooseTF.placeholder = @"选择入职时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerOne;
                    
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"试用总结";
                    cell.placeholder.text = @"输入试用总结";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 3) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 4) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 5) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 3) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 4) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 5) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 3) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 4) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 加班审批cell
            case 5:
            {
                if (indexPath.row == 0) {
                    approvalTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
                    if (cell == nil) {
                        cell = [[approvalTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
                    }
                    
                    cell.stateLB.delegate = self;
                    if (!self.isEdit) {
                        cell.stateLB.enabled = NO;
                        cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                    } else {
                        if (![Utils isBlankString:self.model.hour]) {
                            cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                        } else {
                            cell.stateLB.text = @"";
                        }
                        __weak typeof (self) weakSelf = self;
                        _hourPicker.confirmOneBlock = ^(NSString *choseHour) {
                            
                            cell.stateLB.text = choseHour;
                            weakSelf.model.hour = [choseHour substringToIndex:1];
                            [weakSelf.approvalDetailTableView endEditing:YES];
                            
                        };
                        
                        _hourPicker.cannelOneBlock = ^(){
                            [weakSelf.approvalDetailTableView endEditing:YES];
                        };
                        
                        if (self.isChooseHour) {
                            cell.stateLB.enabled = YES;
                            cell.stateLB.inputView = self.hourPicker;
                            cell.stateLB.placeholder = @"请选择时长";
                        }else {
                            cell.stateLB.enabled = NO;
                            cell.stateLB.placeholder = @"时长";
                        }
                    }
                    cell.titleLB.text = @"加班时长";
                    
                    return cell;
                } else if (indexPath.row == 1) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"开始时间";
                    cell.star.hidden = NO;
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择开始时间";
                        cell.arrow.hidden = NO;
                    }
                    if (![Utils isBlankString:self.model.start_time]) {
                        cell.chooseTF.text = self.model.start_time;
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerThree.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.start_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerThree.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _dateTimeSelectViewOne;
                    
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"结束时间";
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择结束时间";
                        cell.arrow.hidden = NO;
                    }
                    
                    cell.chooseTF.text = self.model.end_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerFour.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.end_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerFour.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _dateTimeSelectViewTwo;
                    
                    return cell;
                } else if (indexPath.row == 3) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"加班原因";
                    cell.placeholder.text = @"输入原因";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 4) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 5) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 6) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 4) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 5) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 4) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 5) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 出差审批cell
            case 6:
            {
                if (indexPath.row == 0) {
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    if ([self.application_id integerValue] == 6) {
                        
                    }
                    cell.titleLabel.text = @"出差地址";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.businessAddress;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"输入出差地址";
                        cell.chooseTF.text = self.model.businessAddress;
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 1){
                    approvalTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
                    if (cell == nil) {
                        cell = [[approvalTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
                    }
                    
                    
                    cell.stateLB.delegate = self;
                    if (!self.isEdit) {
                        cell.stateLB.enabled = NO;
                        
                        if ([self.model.hour integerValue] < 8) {
                            cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                        }else {
                            cell.stateLB.text = [NSString stringWithFormat:@"%ld天",[self.model.hour integerValue]/8];
                        }
                    } else {
                        
                        if (![Utils isBlankString:self.model.hour]) {
                            if ([self.model.hour integerValue] < 8) {
                                cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                            }else {
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld天",[self.model.hour integerValue]/8];
                            }
                        } else {
                            cell.stateLB.text = @"";
                        }
                        __weak typeof (self) weakSelf = self;
                        _hourPicker.confirmOneBlock = ^(NSString *choseHour) {
                            
                            cell.stateLB.text = choseHour;
                            weakSelf.model.hour = [choseHour substringToIndex:1];
                            [weakSelf.approvalDetailTableView endEditing:YES];
                            
                        };
                        
                        _hourPicker.cannelOneBlock = ^(){
                            [weakSelf.approvalDetailTableView endEditing:YES];
                        };
                        
                        cell.stateLB.enabled = NO;
                        cell.stateLB.placeholder = @"时长";
                    }
                    cell.stateLB.tag = indexPath.row+1;
                    cell.titleLB.text = @"出差时长";
                    
                    
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"开始时间";
                    
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else{
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择开始时间";
                        cell.arrow.hidden = NO;
                    }
                    
                    if (![Utils isBlankString:[self.model.start_time stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""]]) {
                        cell.chooseTF.text = [self.model.start_time substringToIndex:10];
                    }
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.start_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerOne;
                    
                    return cell;
                } else if (indexPath.row == 3) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"结束时间";
                    
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    }else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择结束时间";
                        cell.arrow.hidden = NO;
                    }
                    if (![Utils isBlankString:[self.model.end_time stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""]]) {
                        cell.chooseTF.text = [self.model.end_time substringToIndex:10];
                    }
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerTwo.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.end_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerTwo.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerTwo;
                    
                    return cell;
                }else if (indexPath.row == 4) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"行程说明";
                    cell.placeholder.text = @"输入行程说明";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 5) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 6) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 7) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 5) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 7) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 5) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 补打卡审批cell
            case 7:
            {
                if (indexPath.row == 0) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"补打卡日期";
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.clock_time;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择日期";
                        cell.arrow.hidden = NO;
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.clock_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerOne;
                    
                    return cell;
                } else if (indexPath.row == 1) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"补打卡理由";
                    cell.placeholder.text = @"输入补打卡理由";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 2) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 3) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 4) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 2) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 3) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 4) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 2) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 3) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 采购审批cell
            case 8:
            {
                if (indexPath.row == 0){
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"预算(元)";
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.reimbursement_amount;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.reimbursement_amount;
                        cell.chooseTF.placeholder = @"输入金额";
                        cell.chooseTF.keyboardType = UIKeyboardTypeDecimalPad;
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 1){
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"采购物品";
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.goodsPurchased;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.goodsPurchased;
                        cell.chooseTF.placeholder = @"输入物品名称";
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 2){
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"规格型号";
                    cell.star.hidden = YES;
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.specificationModel;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.specificationModel;
                        cell.chooseTF.placeholder = @"输入型号说明";
                    }
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 3){
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"数量";
                    cell.star.hidden = NO;
                    cell.chooseTF.keyboardType = UIKeyboardTypeNumberPad;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.number;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.number;
                        cell.chooseTF.placeholder = @"输入物品数量";
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 4) {
                    approvalLBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ten"];
                    if (cell == nil) {
                        cell = [[approvalLBTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ten"];
                    }
                    cell.titleLabel.text = @"采购人";
                    cell.star.hidden = NO;
                    cell.heheLB.text = self.loginModel.realName;
                    
                    if (!self.isEdit) {
                        cell.heheLB.text = self.model.nick_name;
                    }
                    return cell;
                } else if (indexPath.row == 5) {
                    approcalLBTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twelve"];
                    if (cell == nil) {
                        cell = [[approcalLBTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twelve"];
                    }
                    cell.titleLabel.text = @"接管人";
                    cell.star.hidden = NO;
                    cell.heheLB.text = self.model.apply_name;
                    
//                    if (self.type == 2) {
//                        cell.heheLB.text = self.model.apply_name;
//                    }
                    if ([Utils isBlankString:self.model.apply_name]) {
                        cell.heheLB.text = @"选择接管人";
                        cell.heheLB.textColor = GRAY190;
                    }
                    if (!self.isEdit) {
                        cell.arrow.hidden = YES;
                    } else {
                        cell.arrow.hidden = NO;
                    }
                    return cell;
                } else if (indexPath.row == 6) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"交货日期";
//                    cell.star.hidden = YES;
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.clock_time;
                        cell.arrow.hidden = YES;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择日期";
                        cell.arrow.hidden = NO;
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.clock_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _datePickerOne;
                    
                    return cell;
                } else if (indexPath.row == 7) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"申请原因";
                    cell.placeholder.text = @"输入原因";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    }else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 8) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 9) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 10) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }

                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 8) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 9) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 10) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 8) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 9) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 普通审批
            case 9:
            {
                if (indexPath.row == 0){
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    cell.titleLabel.text = @"标题";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.title;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.text = self.model.title;
                        cell.chooseTF.placeholder = @"输入审批标题";
                    }
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 1) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"说明";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.text = @"输入说明";
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;
                    
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 2) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 3) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 4) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                if (self.type == 2) {
                                    
                                }
                            }
                            
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                                
                                
                            }
                            
                            return cell;
                        }
                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 2) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 3) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 4) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        } else {
                            if (indexPath.row == 2) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 3) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
#pragma mark == 外出审批
            case 10:
            {
                if (indexPath.row == 0) {
                    approvalTFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eight"];
                    if (cell == nil) {
                        cell = [[approvalTFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eight"];
                    }
                    if ([self.application_id integerValue] == 6) {
                        
                    }
                    cell.titleLabel.text = @"外勤地址";
                    
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.chooseTF.text = self.model.businessAddress;
                    } else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"输入外勤地址";
                        cell.chooseTF.text = self.model.businessAddress;
                    }
                    
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    return cell;
                } else if (indexPath.row == 1){
                    approvalTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"five"];
                    if (cell == nil) {
                        cell = [[approvalTimeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"five"];
                    }
                    
                    
                    cell.stateLB.delegate = self;
                    if (!self.isEdit) {
                        cell.stateLB.enabled = NO;
                        
                        if ([self.model.hour integerValue] < 8) {
                            cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                        }else {
                            cell.stateLB.text = [NSString stringWithFormat:@"%ld天",[self.model.hour integerValue]/8];
                        }
                        cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                    } else {
                        
                        if (![Utils isBlankString:self.model.hour]) {
                            if ([self.model.hour integerValue] < 8) {
                                cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                            }else {
                                cell.stateLB.text = [NSString stringWithFormat:@"%ld天",[self.model.hour integerValue]/8];
                            }
                            cell.stateLB.text = [NSString stringWithFormat:@"%@小时",self.model.hour];
                        } else {
                            cell.stateLB.text = @"";
                        }
                        __weak typeof (self) weakSelf = self;
                        _hourPicker.confirmOneBlock = ^(NSString *choseHour) {
                            
                            cell.stateLB.text = choseHour;
                            weakSelf.model.hour = [choseHour substringToIndex:1];
                            [weakSelf.approvalDetailTableView endEditing:YES];
                            
                        };
                        
                        _hourPicker.cannelOneBlock = ^(){
                            [weakSelf.approvalDetailTableView endEditing:YES];
                        };
                        
//                        if (self.isChooseHour) {
//                            cell.stateLB.enabled = YES;
//                            cell.stateLB.inputView = self.hourPicker;
//                            cell.stateLB.placeholder = @"请选择时长";
//                        }else {
//                            cell.stateLB.enabled = NO;
//                            cell.stateLB.placeholder = @"时长";
//                        }
                        cell.stateLB.enabled = NO;
                        cell.stateLB.placeholder = @"时长";
                    }
                    cell.stateLB.tag = indexPath.row+1;
                    cell.titleLB.text = @"外勤时长";
                    
                    
                    return cell;
                } else if (indexPath.row == 2) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"开始时间";
                    
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    } else{
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择开始时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.text = self.model.start_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerOne.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.start_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerOne.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _dateTimeSelectViewOne;
                    
                    return cell;
                } else if (indexPath.row == 3) {
                    approvalChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
                    if (cell == nil) {
                        cell = [[approvalChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
                    }
                    cell.titleLabel.text = @"结束时间";
                    
                    cell.star.hidden = NO;
                    if (!self.isEdit) {
                        cell.chooseTF.enabled = NO;
                        cell.arrow.hidden = YES;
                    }else {
                        cell.chooseTF.enabled = YES;
                        cell.chooseTF.placeholder = @"选择结束时间";
                        cell.arrow.hidden = NO;
                    }
                    cell.chooseTF.text = self.model.end_time;
                    cell.chooseTF.tag = indexPath.row+1;
                    cell.chooseTF.delegate = self;
                    __weak typeof (self) weakSelf = self;
                    _datePickerTwo.confirmBlock = ^(NSString *choseDate,NSString *restDate) {
                        
                        cell.chooseTF.text = choseDate;
                        weakSelf.model.end_time = choseDate;
                        [weakSelf.approvalDetailTableView endEditing:YES];
                        
                    };
                    
                    _datePickerTwo.cannelBlock = ^(){
                        [weakSelf.approvalDetailTableView endEditing:YES];
                    };
                    cell.chooseTF.inputView = _dateTimeSelectViewTwo;
                    
                    return cell;
                }
                
                else if (indexPath.row == 4) {
                    approvalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"six"];
                    if (cell == nil) {
                        cell = [[approvalContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"six"];
                    }
                    cell.titleLabel.text = @"行程说明";
                    cell.placeholder.text = @"输入行程说明";
                    if (!self.isEdit) {
                        cell.chooseTF.userInteractionEnabled = NO;
                    } else {
                        cell.chooseTF.userInteractionEnabled = YES;
                    }
                    if (![Utils isBlankString:self.model.leave_reason]) {
                        cell.placeholder.hidden = YES;
                    }
                    cell.chooseTF.text = self.model.leave_reason;
                    cell.placeholder.tag = indexPath.row+1000;
                    cell.chooseTF.tag = indexPath.row+1;;
                    cell.chooseTF.delegate = self;
                    
                    return cell;
                } else {
                    if (self.isEdit) {
                        if (indexPath.row == 5) {
                            approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                            if (cell == nil) {
                                cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                            }
                            cell.star.hidden = YES;
                            cell.titleLabel.text = @"通知对象";
                            cell.contentLb.text = @"点击选择通知对象";
                            if (!self.isEdit) {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                } else {
                                    cell.contentLb.text = @" ";
                                }
                                cell.arrow.hidden = YES;
                            } else {
                                if (![Utils isBlankString:self.model.toUserName]) {
                                    cell.contentLb.text = self.model.toUserName;
                                    cell.contentLb.textColor = [UIColor blackColor];
                                } else {
                                    cell.contentLb.text = @"点击选择通知对象";
                                    cell.contentLb.textColor = GRAY190;
                                }
                                cell.arrow.hidden = NO;
                            }
                            
                            if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                
                            }
                            
                            return cell;
                        } else if (indexPath.row == 6) {
                            approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                            if (cell == nil) {
                                cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                            }
                            
                            cell.titleLB.text = @"图片";
                            
                            return cell;
                        } else if (indexPath.row == 7) {
                            approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                            if (cell == nil) {
                                cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                            }
                            if (self.type == 1) {
                                self.manager.photoMaxNum = 8;
                                HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                photoView.delegate = self;
                                photoView.backgroundColor = [UIColor whiteColor];
                                [cell addSubview:photoView];
                            } else {
                                self.manager.photoMaxNum = 8-self.iconArr.count;
                                
                                
                                if (cell.photoView == nil) {
                                    cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                    cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    [cell addSubview:cell.photoView];
                                }
                                [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                cell.photoView.tag = 1000;
                                cell.photoView.deleteBlock = ^(NSString *imageURL){
                                    [self.deleteImgaeArr addObject:imageURL];
                                    [self.iconArr removeObject:imageURL];
                                    self.manager.photoMaxNum = 8 - self.iconArr.count;
                                };
                                
                                cell.photoView.delegate = self;
                                cell.photoView.backgroundColor = [UIColor whiteColor];
                            }
                            return cell;
                        }

                    } else {
                        if (![Utils isBlankString:self.model.toUserName]) {
                            if (indexPath.row == 5) {
                                approvalNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seven"];
                                if (cell == nil) {
                                    cell = [[approvalNoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"seven"];
                                }
                                cell.star.hidden = YES;
                                cell.titleLabel.text = @"通知对象";
                                cell.contentLb.text = @"点击选择通知对象";
                                if (!self.isEdit) {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                    } else {
                                        cell.contentLb.text = @" ";
                                    }
                                    cell.arrow.hidden = YES;
                                } else {
                                    if (![Utils isBlankString:self.model.toUserName]) {
                                        cell.contentLb.text = self.model.toUserName;
                                        cell.contentLb.textColor = [UIColor blackColor];
                                    } else {
                                        cell.contentLb.text = @"点击选择通知对象";
                                        cell.contentLb.textColor = GRAY190;
                                    }
                                    cell.arrow.hidden = NO;
                                }
                                
                                if ([cell.contentLb.text isEqualToString:@"点击选择通知对象"]) {
                                    
                                }
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 7) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }

                        } else {
                            if (indexPath.row == 5) {
                                approvalImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
                                if (cell == nil) {
                                    cell = [[approvalImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
                                }
                                
                                cell.titleLB.text = @"图片";
                                
                                return cell;
                            } else if (indexPath.row == 6) {
                                approvalImageTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eleven"];
                                if (cell == nil) {
                                    cell = [[approvalImageTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"eleven"];
                                }
                                if (self.type == 1) {
                                    self.manager.photoMaxNum = 8;
                                    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
                                    photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                    photoView.delegate = self;
                                    photoView.backgroundColor = [UIColor whiteColor];
                                    [cell addSubview:photoView];
                                } else {
                                    self.manager.photoMaxNum = 8-self.iconArr.count;
                                    
                                    
                                    if (cell.photoView == nil) {
                                        cell.photoView = [HXPhotoView layoutPhotoWithUrlArray:self.iconArr isEdit:self.isEdit photoManager:self.manager];
                                        cell.photoView.frame = CGRectMake(10, 10, kScreenWidth - 40,0);
                                        [cell addSubview:cell.photoView];
                                    }
                                    [cell.photoView reloadDataWithManager:self.manager isEdit:self.isEdit UrlArray:self.iconArr];
                                    cell.photoView.tag = 1000;
                                    cell.photoView.deleteBlock = ^(NSString *imageURL){
                                        [self.deleteImgaeArr addObject:imageURL];
                                        [self.iconArr removeObject:imageURL];
                                        self.manager.photoMaxNum = 8 - self.iconArr.count;
                                    };
                                    
                                    cell.photoView.delegate = self;
                                    cell.photoView.backgroundColor = [UIColor whiteColor];
                                }
                                return cell;
                            }
                        }
                    }
                }
            }
                break;
            default:
                break;
        }
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEdit == 1) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            approvalFlowViewController *approvalFlow = [approvalFlowViewController new];
            approvalFlow.type = 1;
            approvalFlow.application_id = self.application_id;

            approvalFlow.flow_id = [NSString stringWithFormat:@"%@",self.model.flow_id];
            approvalFlow.returnFlowNameBlock = ^(NSString *str) {
                self.flowNameStr = str;
                self.model.flow_name = str;
            };
            approvalFlow.returnFlowIdBlock = ^(NSString *str) {
                self.flowIdStr = str;
                self.model.flow_id = str;
                [self.approvalDetailTableView reloadData];
            };
            [self.navigationController pushViewController:approvalFlow animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"1"] && indexPath.row == 3){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"2"] && indexPath.row == 5){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"3"] && indexPath.row == 5){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"4"] && indexPath.row == 3){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"5"] && indexPath.row == 4){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"6"] && indexPath.row == 5){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"7"] && indexPath.row == 2){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"8"] && indexPath.row == 8){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"9"] && indexPath.row == 2){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"10"] && indexPath.row == 5){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 2;
            choose.limited = 3;
            [choose returnAvilableMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.toUserName = model.realName;
                            self.model.toUser = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.toUserName = [NSString stringWithFormat:@"%@,%@",self.model.toUserName,model.realName];
                            self.model.toUser = [NSString stringWithFormat:@"%@,%ld",self.model.toUser,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }else if (indexPath.section == 1 && [self.application_id isEqualToString:@"8"] && indexPath.row == 5){
            chooseViewController *choose = [chooseViewController new];
            choose.seType = 1;
            choose.limited = 1;
            [choose returnMutableArray:^(NSMutableArray *returnAvilableMutableArray) {
                self.noticePeopleMutableArr = [NSMutableArray arrayWithArray:returnAvilableMutableArray];
                if (self.noticePeopleMutableArr.count) {
                    
                    for (int i = 0; i<self.noticePeopleMutableArr.count; i++) {
                        ContactModel *model = self.noticePeopleMutableArr[i];
                        if (i == 0) {
                            self.model.apply_name = model.realName;
                            self.model.apply_id = [NSString stringWithFormat:@"%ld",model.userId];
                        }else {
                            self.model.apply_name = [NSString stringWithFormat:@"%@,%@",self.model.apply_name,model.realName];
                            self.model.apply_id = [NSString stringWithFormat:@"%@,%ld",self.model.apply_id,model.userId];
                        }
                    }
                    [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            [self.navigationController pushViewController:choose animated:YES];
        }
    }else {
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            [self requestHistory];
            
            
        }
    }
}
- (void)requestHistory {
    self.historyArr = [NSMutableArray arrayWithCapacity:0];
    [HttpRequestEngine getApprovalHistoryWithID:self.ID mech_id:self.mech_id completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *arr = (NSArray *)obj;
            for (NSDictionary *dic in arr) {
                approvalHistoryModel *model = [approvalHistoryModel requestWithDic:dic];
                
                [self.historyArr addObject:model];
            }
            approvalHistoryViewController *approvalHistory = [approvalHistoryViewController new];

            approvalHistory.historyArr = self.historyArr;
            [self.navigationController pushViewController:approvalHistory animated:YES];
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    switch ([self.application_id integerValue]) {
        case 1:
        {
            switch (textField.tag) {
                case 1:
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 2:
        {
            switch (textField.tag) {
                case 1:
                case 2:
                case 3:
                case 4:
                {
                    self.dateTimeSelectStr = textField.tag;
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 3:
        {
            switch (textField.tag) {
                case 3:
                case 4:
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 4:
        {
            switch (textField.tag) {
                case 2:
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 5:
        {
            switch (textField.tag) {
                case 2:
                case 3:
                {
                    self.dateTimeSelectStr = textField.tag;
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 6:
        {
            switch (textField.tag) {
                case 2:
                case 3:
                case 4:
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 7:
        {
            switch (textField.tag) {
                case 1:
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 8:
        {
            switch (textField.tag) {
                case 7:
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
        case 10:
        {
            switch (textField.tag) {
                case 2:
                case 3:
                case 4:
                {
                    self.dateTimeSelectStr = textField.tag;
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = NO;
                }
                    break;
            }
        }
            break;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch ([self.application_id integerValue]) {
        case 1:
        {
            switch (textField.tag) {
                case 1:
//                    self.model.leave_type_id = textField.text;
                {
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 2:
                    self.model.reimbursement_amount = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (textField.tag) {
                case 1:
//                    self.model.leave_type_id = textField.text;
                    break;
                case 2:
                    if (self.model.hour.length) {
                        
                    }
                    break;
                case 3:
                {
                    
                    if (![Utils isBlankString:self.model.start_time]) {
                        

                        if (![Utils isBlankString:self.model.end_time]) {
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"YYYY-MM-dd HH:mm" MaxDate:self.model.end_time]) {
                                
                                self.model.end_time = self.model.start_time;
                                self.model.hour = @"0";
                            }
                        }
                        
                    }
                    if (![Utils isBlankString:self.model.start_time] && ![Utils isBlankString:self.model.end_time]) {
                        if (![self.model.start_time isEqualToString:self.model.end_time]) {
                            self.isChooseHour = 0;
                            //是否同一天的
                            if (![[self.model.start_time substringToIndex:10] isEqualToString:[self.model.end_time substringToIndex:10]]) {
                                self.isChooseHour = 1;

                                self.model.hour = [Utils getHoursWithSignModel:self.signModel theStartTime:self.model.start_time theEndTime:self.model.end_time];
                                self.isShowHour = 1;
                            } else{
                                self.model.hour = [Utils getHoursWithSignModel:self.signModel startTime:self.model.start_time endTime:self.model.end_time];
                                
                            }
                            textField.inputView = nil;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 0;
                            self.model.hour = @"0";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 4:
                {
                    
                    if (![Utils isBlankString:self.model.end_time]) {
                        
                        
                        if (![Utils isBlankString:self.model.start_time]) {
                            
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"YYYY-MM-dd HH:mm" MaxDate:self.model.end_time]) {
                                
                                self.model.start_time = self.model.end_time;
                                self.model.hour = @"0";
                            }
                            
                        }
                    }
                    if (![Utils isBlankString:self.model.start_time] && ![Utils isBlankString:self.model.end_time]) {
                        if (![self.model.start_time isEqualToString:self.model.end_time]) {
                            self.isChooseHour = 0;
                            //是否同一天的
                            if (![[self.model.start_time substringToIndex:10] isEqualToString:[self.model.end_time substringToIndex:10]]) {
                                if (([[Utils stringToDate:[self.model.end_time substringToIndex:10] withDateFormat:@"yyyy-MM-dd"]  timeIntervalSinceDate:[Utils stringToDate:[self.model.start_time substringToIndex:10] withDateFormat:@"yyyy-MM-dd"]])/(3600*24)>=1) {
                                    self.isChooseHour = 1;

                                    self.isShowHour = 1;
                                    self.model.hour = [Utils getHoursWithSignModel:self.signModel theStartTime:self.model.start_time theEndTime:self.model.end_time];
                                }
                            } else{
                                self.model.hour = [Utils getHoursWithSignModel:self.signModel startTime:self.model.start_time endTime:self.model.end_time];

                            }
                            
                            textField.inputView = nil;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 0;
                            self.model.hour = @"0";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 5:
//                    self.model.leave_reason = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (textField.tag) {
                case 1:
                    self.model.position = textField.text;
                    break;
                case 2:
                    self.model.handover = textField.text;
                    break;
                case 3:
                {
                    self.model.start_time = textField.text;
                    if (![Utils isBlankString:self.model.end_time]) {
                        if (![Utils compareTwoDateWithMinDate:self.model.start_time MaxDate:self.model.end_time]) {
//                            NSDate *date = [Utils stringToDate:self.model.end_time withDateFormat:@"YYYY-MM-dd"];
//                            NSDate *lastDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];//前一天
                            self.model.end_time = self.model.start_time;
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 4:
                {
                    self.model.end_time = textField.text;
                    if (![Utils isBlankString:self.model.end_time]) {
                        if (![Utils compareTwoDateWithMinDate:self.model.start_time MaxDate:self.model.end_time]) {

                            self.model.start_time = self.model.end_time;
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 5:
//                    self.model.leave_reason = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            switch (textField.tag) {
                case 1:
                    self.model.position = textField.text;
                    break;
                case 2:
                {
                    self.model.clock_time = textField.text;
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 3:
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:
        {
            switch (textField.tag) {
                case 1:
                    self.model.hour = textField.text;
                    break;
                case 2:
                {
                    
                    if (![Utils isBlankString:self.model.start_time]) {
                        NSString *minute = [self.model.start_time substringFromIndex:14];
                        if ([minute integerValue] < 15 && [minute integerValue]>=0) {
                            self.model.start_time = [NSString stringWithFormat:@"%@00",[self.model.start_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 15 && [minute integerValue] < 30) {
                            self.model.start_time = [NSString stringWithFormat:@"%@30",[self.model.start_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 30 && [minute integerValue] < 45) {
                            self.model.start_time = [NSString stringWithFormat:@"%@30",[self.model.start_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 45 && [minute integerValue] < 60){
                            NSDate *date = [Utils stringToDate:self.model.start_time withDateFormat:@"YYYY-MM-dd HH:mm"];
                            NSDate *lastDay = [NSDate dateWithTimeInterval:60*60 sinceDate:date];
                            self.model.start_time = [NSString stringWithFormat:@"%@00",[[Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd HH:mm"] substringToIndex:14]];
                        }
                        if (![Utils isBlankString:self.model.end_time]) {
                            
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"YYYY-MM-dd HH:mm" MaxDate:self.model.end_time]) {
                                
                                NSDate *date = [Utils stringToDate:self.model.start_time withDateFormat:@"YYYY-MM-dd HH:mm"];
                                NSDate *lastDay = [NSDate dateWithTimeInterval:60*30 sinceDate:date];//前半小时
                                self.model.end_time = [Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd HH:mm"];
                                
                                
                            }
                        }
                        
                    }
                    if (![Utils isBlankString:self.model.start_time] && ![Utils isBlankString:self.model.end_time]) {
                        if (![self.model.start_time isEqualToString:self.model.end_time]) {
                            self.isChooseHour = 0;
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                            NSDate *start = [dateFormatter dateFromString:self.model.start_time];
                            NSDate *end = [dateFormatter dateFromString:self.model.end_time];
                            NSTimeInterval time = [end timeIntervalSinceDate:start];
                            
//                            long int hours = ((long int)time)/3600;
//                            long int minutes = ((long int)time)%3600/60;
//                            if (minutes && minutes > 0) {
//                                if (minutes > 30) {
//                                    hours = hours+1;
//                                    if (hours%24 > 8) {
//                                        hours = (hours/24 + 1)*8;
//                                    } else {
//                                        hours = (hours/24)*8+hours%24;
//                                    }
//                                    self.model.hour = [NSString stringWithFormat:@"%ld",hours];
//                                } else if (minutes <= 30 && minutes > 0) {
//                                    if (hours%24 > 8) {
//                                        hours = (hours/24 + 1)*8;
//                                    } else {
//                                        hours = (hours/24)*8+hours%24;
//                                    }
//                                    float a = hours+0.5;
//                                    
//                                    self.model.hour = [NSString stringWithFormat:@"%g",a];
//                                }
//                            } else {
//                                if (hours%24 > 8) {
//                                    hours = (hours/24 + 1)*8;
//                                } else {
//                                    hours = (hours/24)*8+hours%24;
//                                }
//                                self.model.hour = [NSString stringWithFormat:@"%ld",hours];
//                            }
                            self.model.hour = [NSString stringWithFormat:@"%g",time/3600.0];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 0;
                            self.model.hour = @"";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 3:
                {
                    if (![Utils isBlankString:self.model.end_time]) {
                        
                        NSString *minute = [self.model.end_time substringFromIndex:14];
                        if ([minute integerValue] < 15 && [minute integerValue]>=0) {
                            self.model.end_time = [NSString stringWithFormat:@"%@00",[self.model.end_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 15 && [minute integerValue] < 30) {
                            self.model.end_time = [NSString stringWithFormat:@"%@30",[self.model.end_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 30 && [minute integerValue] < 45) {
                            self.model.end_time = [NSString stringWithFormat:@"%@30",[self.model.end_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 45 && [minute integerValue] < 60){
                            NSDate *date = [Utils stringToDate:self.model.end_time withDateFormat:@"YYYY-MM-dd HH:mm"];
                            NSDate *lastDay = [NSDate dateWithTimeInterval:60*60 sinceDate:date];
                            self.model.end_time = [NSString stringWithFormat:@"%@00",[[Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd HH:mm"] substringToIndex:14]];
                        }
                        
                        if (![Utils isBlankString:self.model.start_time]) {
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time  DateFormat:@"YYYY-MM-dd HH:mm" MaxDate:self.model.end_time]) {
                                
                                
                                NSDate *date = [Utils stringToDate:self.model.end_time withDateFormat:@"YYYY-MM-dd HH:mm"];
                                NSDate *nextDay = [NSDate dateWithTimeInterval:-60*30 sinceDate:date];//后半小时
                                self.model.start_time = [Utils dateToString:nextDay withDateFormat:@"YYYY-MM-dd HH:mm"];
                            }
                        }
                        
                    }
                    if (![Utils isBlankString:self.model.start_time] && ![Utils isBlankString:self.model.end_time]) {
                        if (![self.model.start_time isEqualToString:self.model.end_time]) {
                            self.isChooseHour = 0;
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                            NSDate *start = [dateFormatter dateFromString:self.model.start_time];
                            NSDate *end = [dateFormatter dateFromString:self.model.end_time];
                            NSTimeInterval time = [end timeIntervalSinceDate:start];
                            
//                            long int hours = ((long int)time)/3600;
//                            long int minutes = ((long int)time)%3600/60;
//                            if (minutes && minutes > 0) {
//                                if (minutes > 30) {
//                                    hours = hours+1;
//                                    if (hours%24 > 8) {
//                                        hours = (hours/24 + 1)*8;
//                                    } else {
//                                        hours = (hours/24)*8+hours%24;
//                                    }
//                                    self.model.hour = [NSString stringWithFormat:@"%ld",hours];
//                                } else if (minutes <= 30 && minutes > 0) {
//                                    if (hours%24 > 8) {
//                                        hours = (hours/24 + 1)*8;
//                                    } else {
//                                        hours = (hours/24)*8+hours%24;
//                                    }
//                                    float a = hours+0.5;
//                                    self.model.hour = [NSString stringWithFormat:@"%g",a];
//                                }
//                            } else {
//                                if (hours%24 > 8) {
//                                    hours = (hours/24 + 1)*8;
//                                } else {
//                                    hours = (hours/24)*8+hours%24;
//                                }
//                                
//                                self.model.hour = [NSString stringWithFormat:@"%ld",hours];
//                            }
                            self.model.hour = [NSString stringWithFormat:@"%g",time/3600.0];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 1;
                            self.model.hour = @"";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 4:
//                    self.model.leave_reason = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 6:
        {
            switch (textField.tag) {
                case 1:
                    self.model.businessAddress = textField.text;
                    break;
                case 2:
                    if (self.model.hour.length) {
                        self.model.hour = [textField.text substringToIndex:1];
                    }
                    break;
                case 3:
                {
                    self.model.start_time = [NSString stringWithFormat:@"%@ 00:00:00",textField.text];
                    if (![Utils isBlankString:[self.model.start_time stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""]]) {
                        if (![Utils isBlankString:[self.model.end_time stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""]]) {
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"yyyy-MM-dd HH:mm:ss"  MaxDate:self.model.end_time]) {
                                self.model.end_time = [NSString stringWithFormat:@"%@ 23:59:59",[self.model.start_time substringToIndex:10]];
                            }
                        }
                    }
                    if (![Utils isBlankString:[self.model.start_time stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""]] && ![Utils isBlankString:[self.model.end_time stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""]]) {
                        if (![[self.model.start_time substringToIndex:10] isEqualToString:[self.model.end_time substringToIndex:10]]) {
                            self.isChooseHour = 0;
                            self.model.hour = [NSString stringWithFormat:@"%.0f",([[Utils stringToDate:self.model.end_time withDateFormat:@"yyyy-MM-dd HH:mm:ss"]  timeIntervalSinceDate:[Utils stringToDate:self.model.start_time withDateFormat:@"yyyy-MM-dd HH:mm:ss"]])/(3600*24)*8];
                            textField.inputView = nil;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 1;
                            self.model.hour = @"8";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
//                        self.model.end_time = [NSString stringWithFormat:@"%@ 23:59:59",self.model.end_time];
                    }
                    
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 4:
                {
                    self.model.end_time = [NSString stringWithFormat:@"%@ 23:59:59",textField.text];
                    if (![Utils isBlankString:[self.model.end_time stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""]]) {
                        if (![Utils isBlankString:[self.model.end_time stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""]]) {
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"yyyy-MM-dd HH:mm:ss"  MaxDate:self.model.end_time]) {
                                self.model.start_time = [NSString stringWithFormat:@"%@ 00:00:00",[self.model.end_time substringToIndex:10]];
                            }
                        }
                    }
                    if (![Utils isBlankString:[self.model.start_time stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""]] && ![Utils isBlankString:[self.model.end_time stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""]]) {
                        if (![[self.model.start_time substringToIndex:10] isEqualToString:[self.model.end_time substringToIndex:10]]) {
                            self.isChooseHour = 0;
                            self.model.hour = [NSString stringWithFormat:@"%.0f",([[Utils stringToDate:self.model.end_time withDateFormat:@"yyyy-MM-dd HH:mm:ss"]  timeIntervalSinceDate:[Utils stringToDate:self.model.start_time withDateFormat:@"yyyy-MM-dd HH:mm:ss"]])/(3600*24)*8];
                            textField.inputView = nil;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 1;
                            self.model.hour = @"8";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
//                        self.model.end_time = [NSString stringWithFormat:@"%@ 23:59:59",self.model.end_time];
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 5:
                    //                    self.model.leave_reason = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 7:
        {
            switch (textField.tag) {
                case 1:
                {
                    self.model.clock_time = textField.text;
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 2:
                    
                    break;
                default:
                    break;
            }
        }
            break;
        case 8:
        {
            switch (textField.tag) {
                case 1:
                    self.model.reimbursement_amount = textField.text;
                    break;
                case 2:
                {
                    self.model.goodsPurchased = textField.text;
                }
                    break;
                case 3:
                {
                    self.model.specificationModel = textField.text;
                    
                }
                    break;
                case 4:
                    self.model.number = textField.text;
                    break;
                case 5:
//                    self.model.number = textField.text;
                    break;
                case 6:
                {
                    self.model.clock_time = textField.text;
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 7:
//                    self.model.leave_reason = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 9:
        {
            switch (textField.tag) {
                case 1:
                    self.model.title = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 10:
        {
            switch (textField.tag) {
                case 1:
                    self.model.businessAddress = textField.text;
                    break;
                case 2:
                    if (self.model.hour.length) {
                        self.model.hour = [textField.text substringToIndex:1];
                    }
                    break;
                case 3:
                {
//                    self.model.start_time = textField.text;
                    
                    if (![Utils isBlankString:self.model.start_time]) {
                        
                        NSString *minute = [self.model.start_time substringFromIndex:14];
                        if ([minute integerValue] < 15 && [minute integerValue]>=0) {
                            self.model.start_time = [NSString stringWithFormat:@"%@00",[self.model.start_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 15 && [minute integerValue] < 30) {
                            self.model.start_time = [NSString stringWithFormat:@"%@30",[self.model.start_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 30 && [minute integerValue] < 45) {
                            self.model.start_time = [NSString stringWithFormat:@"%@30",[self.model.start_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 45 && [minute integerValue] < 60){
                            NSDate *date = [Utils stringToDate:self.model.start_time withDateFormat:@"YYYY-MM-dd HH:mm"];
                            NSDate *lastDay = [NSDate dateWithTimeInterval:60*60 sinceDate:date];
                            self.model.start_time = [NSString stringWithFormat:@"%@00",[[Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd HH:mm"] substringToIndex:14]];
                        }
                        
                        if (![Utils isBlankString:self.model.end_time]) {
                            
                            if (![[self.model.start_time substringToIndex:10] isEqualToString:[self.model.end_time substringToIndex:10]]) {
                                self.model.end_time = [self.model.end_time stringByReplacingOccurrencesOfString:[self.model.end_time substringToIndex:10] withString:[self.model.start_time substringToIndex:10]];
                                
                            }
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"YYYY-MM-dd HH:mm" MaxDate:self.model.end_time]) {
                                
                                self.model.end_time = self.model.start_time;
                                self.model.hour = @"0";
                            }
                        }
                    }
                    if (![Utils isBlankString:self.model.start_time] && ![Utils isBlankString:self.model.end_time]) {
                        if (![self.model.start_time isEqualToString:self.model.end_time]) {
                            self.isChooseHour = 0;
                            self.model.hour = [NSString stringWithFormat:@"%g",([[Utils stringToDate:self.model.end_time withDateFormat:@"yyyy-MM-dd HH:mm"]  timeIntervalSinceDate:[Utils stringToDate:self.model.start_time withDateFormat:@"yyyy-MM-dd HH:mm"]])/(3600)*1.0];
                            textField.inputView = nil;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 1;
                            self.model.hour = @"0";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 4:
                {
//                    self.model.end_time = textField.text;
                    if (![Utils isBlankString:self.model.end_time]) {
                        
                        NSString *minute = [self.model.end_time substringFromIndex:14];
                        if ([minute integerValue] < 15 && [minute integerValue]>=0) {
                            self.model.end_time = [NSString stringWithFormat:@"%@00",[self.model.end_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 15 && [minute integerValue] < 30) {
                            self.model.end_time = [NSString stringWithFormat:@"%@30",[self.model.end_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 30 && [minute integerValue] < 45) {
                            self.model.end_time = [NSString stringWithFormat:@"%@30",[self.model.end_time substringToIndex:14]];
                        } else if ([minute integerValue] >= 45 && [minute integerValue] < 60){
                            NSDate *date = [Utils stringToDate:self.model.end_time withDateFormat:@"YYYY-MM-dd HH:mm"];
                            NSDate *lastDay = [NSDate dateWithTimeInterval:60*60 sinceDate:date];
                            self.model.end_time = [NSString stringWithFormat:@"%@00",[[Utils dateToString:lastDay withDateFormat:@"YYYY-MM-dd HH:mm"] substringToIndex:14]];
                        }
                        
                        if (![Utils isBlankString:self.model.start_time]) {
                            
                            if (![[self.model.start_time substringToIndex:10] isEqualToString:[self.model.end_time substringToIndex:10]]) {
                                self.model.start_time = [self.model.start_time stringByReplacingOccurrencesOfString:[self.model.start_time substringToIndex:10] withString:[self.model.end_time substringToIndex:10]];
                                
                            }
                            if (![Utils compareTwoDateWithMinDate:self.model.start_time DateFormat:@"YYYY-MM-dd HH:mm" MaxDate:self.model.end_time]) {
                                
                                self.model.start_time = self.model.end_time;
                                self.model.hour = @"0";
                            }
                        }
                    }
                    if (![Utils isBlankString:self.model.start_time] && ![Utils isBlankString:self.model.end_time]) {
                        if (![self.model.start_time isEqualToString:self.model.end_time]) {
                            self.isChooseHour = 0;
                            self.model.hour = [NSString stringWithFormat:@"%g",([[Utils stringToDate:self.model.end_time withDateFormat:@"yyyy-MM-dd HH:mm"]  timeIntervalSinceDate:[Utils stringToDate:self.model.start_time withDateFormat:@"yyyy-MM-dd HH:mm"]])/(3600.0)];
                            textField.inputView = nil;
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        } else {
                            //这里时长变成选择的模式
                            self.isChooseHour = 1;
                            self.model.hour = @"0";
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
                            [self.approvalDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                    manager.enableAutoToolbar = YES;
                }
                    break;
                case 5:
                    //                    self.model.leave_reason = textField.text;
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    [self.approvalDetailTableView reloadData];
}
- (void)textViewDidChange:(UITextView *)textView {
    NSString *str = textView.text;
    
    CGFloat Height = [str heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:kScreenWidth-80];
    
    rowHeight = Height;
    
    UILabel *label = [self.approvalDetailTableView viewWithTag:textView.tag+999];
    if (str.length > 0) {
        label.hidden = YES;
    } else {
        label.hidden = NO;
    }
    
    if (rowHeight<14) {
        rowHeight = 14;
    }

    [self.approvalDetailTableView beginUpdates];
    [self.approvalDetailTableView endUpdates];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.model.leave_reason = textView.text;
}

- (void)photoViewChangeComplete:(NSArray<HXPhotoModel *> *)allList Photos:(NSArray<HXPhotoModel *> *)photos Videos:(NSArray<HXPhotoModel *> *)videos Original:(BOOL)isOriginal
{
    NSLog(@"%ld - %ld - %ld",allList.count,photos.count,videos.count);
    
    /*
     关于为什么照片模型里面只有 thumbPhoto 这个才有值
     为了优化相册列表以及预览大图列表快速滑动内存暴增的问题，
     如果缓存了imageData或者原图的image,用户图片过多时这会导致内存的增大,
     而且当快速滑动遇到图片过大时可能导致滑动卡顿 / 内存警告⚠️程序被杀。
     故不缓存imageData和image 只保留 thumbPhoto 缩略图
     这样可以保证在选择照片/快速滑动过程中,不会因为内存过大导致程序被杀 和 滑动流畅丝滑。
     所以要获取已选图片的原图可以选择HXPhotoTools提供的快速获取已选照片的全部原图 或
     快速获取已选照片的全图高清图片,获取高清图片消耗内存很小而且图片质量也很高
     当然您也可以自己根据指定方法控制传入的size来获取不同质量的图片。
     提醒：在用户没有选择原图的时候不要使用原图上传，获取image时size稍微缩小一点这样可以保证上传快内存消耗小一点。在使用快速获取原图方法时,请将这个方法写在上传方法里! 在获取原图Image的过程中会比较消耗内存.
     */
    
    // 获取数组里面图片的 HD(高清)图片  传入的数组里装的是 HXPhotoModel  -- 这个方法必须写在点击上传的位置
    //    [HXPhotoTools fetchHDImageForSelectedPhoto:photos completion:^(NSArray<UIImage *> *images) {
    //        NSLog(@"%@",images);
    //    }];
    /*
     如果真的觉得这个方法获取的高清图片还达不到你想要的效果,你可以按住 command 点击上面方法修改以下属性来获取你想要的图片
     
     // 这里的size 是普通图片的时候  想要更高质量的图片 可以把 1.5 换成 2 或者 3
     如果觉得内存消耗过大可以 调小一点
     
     CGSize size = CGSizeMake(model.endImageSize.width * 1.5, model.endImageSize.height * 1.5);
     
     // 这里是判断图片是否过长 因为图片如果长了 上面的size就显的有点小了获取出来的图片就变模糊了,所以这里把宽度 换成了屏幕的宽度,这个可以保证即不影响内存也不影响质量 如果觉得质量达不到你的要求,可以乘上 1.5 或者 2 . 当然你也可以不按我这样给size,自己测试怎么给都可以
     if (model.endImageSize.height > model.endImageSize.width / 9 * 20) {
     size = CGSizeMake([UIScreen mainScreen].bounds.size.width, model.endImageSize.height);
     }
     */
    
    NSLog(@"photos.count == %ld",photos.count);
    
    if (photos.count) {
        self.UploadImageArr = [NSMutableArray arrayWithArray:photos];
    }
//    [self.approvalDetailTableView reloadData];
    if (self.type == 2) {
        
    }
    //  获取数组里面图片的原图 传入的数组里装的是 HXPhotoModel  -- 这个方法必须写在点击上传的地方获取 此方法会增大内存. 获取原图图片之后请将选中数组中模型里面的数据全部清空
    [HXPhotoTools fetchOriginalForSelectedPhoto:photos completion:^(NSArray<UIImage *> *images) {
        NSLog(@"images == %@",images);
    }];
    
    /*
     
     // 获取图片资源
     [photos enumerateObjectsUsingBlock:^(HXPhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
     // 小图  - 这个字段会一直有值
     model.thumbPhoto;
     
     // 大图  - 这个字段没有值,  如果是通过相机拍照的这个字段一直有值跟 thumbPhoto 是一样的
     model.previewPhoto;
     
     // imageData  - 这个字段没有值 请根据指定方法获取
     model.imageData;
     
     // livePhoto  - 这个字段只有当查看过livePhoto之后才会有值
     model.livePhoto;
     
     // isCloseLivePhoto 判断当前图片是否关闭了 livePhoto 功能 YES-关闭 NO-开启
     model.isCloseLivePhoto;
     
     // 获取imageData - 通过相册获取时有用 / 通过相机拍摄的无效
     [HXPhotoTools FetchPhotoDataForPHAsset:model.asset completion:^(NSData *imageData, NSDictionary *info) {
     NSLog(@"%@",imageData);
     }];
     
     // 获取image - PHImageManagerMaximumSize 是原图尺寸 - 通过相册获取时有用 / 通过相机拍摄的无效
     CGSize size = PHImageManagerMaximumSize; // 通过传入 size 的大小来控制图片的质量
     [HXPhotoTools FetchPhotoForPHAsset:model.asset Size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
     NSLog(@"%@",image);
     }];
     
     // 如果是通过相机拍摄的照片只有 thumbPhoto、previewPhoto和imageSize 这三个字段有用可以通过 type 这个字段判断是不是通过相机拍摄的
     if (model.type == HXPhotoModelMediaTypeCameraPhoto);
     }];
     
     // 如果是相册选取的视频 要获取视频URL 必须先将视频压缩写入文件,得到的文件路径就是视频的URL 如果是通过相机录制的视频那么 videoURL 这个字段就是视频的URL 可以看需求看要不要压缩
     [videos enumerateObjectsUsingBlock:^(HXPhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
     // 视频封面
     model.thumbPhoto;
     
     // previewPhoto 这个也是视频封面 如果是在相册选择的视频 这个字段有可能没有值,只有当用户通过3DTouch 预览过之后才会有值 而且比 thumbPhoto 清晰  如果视频是通过相机拍摄的视频 那么 previewPhoto 这个字段跟 thumbPhoto 是同一张图片也是比较清晰的
     model.previewPhoto;
     
     // 如果是通过相机录制的视频 需要通过 model.VideoURL 这个字段来压缩写入文件
     if (model.type == HXPhotoModelMediaTypeCameraVideo) {
     [self compressedVideoWithURL:model.videoURL success:^(NSString *fileName) {
     NSLog(@"%@",fileName); // 视频路径也是视频URL;
     } failure:^{
     // 压缩写入失败
     }];
     }else { // 如果是在相册里面选择的视频就需要用过 model.avAsset 这个字段来压缩写入文件
     [self compressedVideoWithURL:model.avAsset success:^(NSString *fileName) {
     NSLog(@"%@",fileName); // 视频路径也是视频URL;
     } failure:^{
     // 压缩写入失败
     }];
     }
     }];
     
     // 判断照片、视频 或 是否是通过相机拍摄的
     [allList enumerateObjectsUsingBlock:^(HXPhotoModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
     if (model.type == HXPhotoModelMediaTypeCameraVideo) {
     // 通过相机录制的视频
     }else if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
     // 通过相机拍摄的照片
     }else if (model.type == HXPhotoModelMediaTypePhoto) {
     // 相册里的照片
     }else if (model.type == HXPhotoModelMediaTypePhotoGif) {
     // 相册里的GIF图
     }else if (model.type == HXPhotoModelMediaTypeLivePhoto) {
     // 相册里的livePhoto
     }
     }];
     
     */
}
- (void)uploadImageWithDataDic:(NSMutableDictionary *)dic {
    
    // 获取数组里面图片原图的 imageData 资源 传入的数组里装的是 HXPhotoModel  -- 这个方法必须写在点击上传的位置
    NSData *imageData = self.selectedImageArr[self.imageIndex];
    [HttpRequestEngine uploadImageData:imageData fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
        if (errorStr)
        {
            [MBProgressHUD showError:errorStr toView:self.view];
        }else{
            if (self.imageIndex != self.selectedImageArr.count-1) {
                self.imageIndex = self.imageIndex+1;
                [self uploadImageWithDataDic:dic];
                NSDictionary *dic = [NSDictionary changeType:obj];
                NSString *imagePath = dic[@"errorMsg"];
                [self.iconArr addObject:imagePath];
            } else {
                NSDictionary *dic1 = [NSDictionary changeType:obj];
                NSString *imagePath = dic1[@"errorMsg"];
                [self.iconArr addObject:imagePath];
                
                for (NSString *iconStr in self.iconArr) {
                    NSDictionary *dic = @{@"icon":[iconStr stringByReplacingOccurrencesOfString:@"_min.jpg" withString:@".jpg"]};
                    [self.iconDicArr addObject:dic];
                }
                if (self.iconDicArr.count) {
                    dic[@"iconList"] = self.iconDicArr;
                }
                
                [HttpRequestEngine addApprovalWithDic:dic completion:^(id obj, NSString *errorStr) {
                    
                    if ([Utils isBlankString:errorStr]) {
                        self.refreshBlock();
                        [MBProgressHUD hideHUD];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBProgressHUD showError:errorStr];
                    }
                }];
            }
            
        }
    }];

}
- (void)uploadDataSeqID:(NSString *)seqId {
    
    NSMutableDictionary *dic = [self getDicWithDataSeqID:seqId];
    
    if (dic) {
        [MBProgressHUD showMessage:@"提交中..."];
        if (self.deleteImgaeArr.count){
            [self deleteImgaeWithDic:dic];
        } else {
            if (self.UploadImageArr.count) {
                // 获取数组里面图片原图的 imageData 资源 传入的数组里装的是 HXPhotoModel  -- 这个方法必须写在点击上传的位置
                [HXPhotoTools fetchImageDataForSelectedPhoto:self.UploadImageArr completion:^(NSArray<NSData *> *imageDatas) {
                    NSLog(@"imageDatas.count == %ld",imageDatas.count);
                    self.selectedImageArr = [NSMutableArray arrayWithArray:imageDatas];
                    [self uploadImageWithDataDic:dic];
                }];
            } else {
                if (self.iconArr.count) {
                    for (NSString *iconStr in self.iconArr) {
                        NSDictionary *dic = @{@"icon":[iconStr stringByReplacingOccurrencesOfString:@"_min.jpg" withString:@".jpg"]};
                        [self.iconDicArr addObject:dic];
                    }
                    if (self.iconDicArr.count) {
                        dic[@"iconList"] = self.iconDicArr;
                    }
                }
                
                [HttpRequestEngine addApprovalWithDic:dic completion:^(id obj, NSString *errorStr) {
                    
                    if ([Utils isBlankString:errorStr]) {
                        self.refreshBlock();
                        [MBProgressHUD hideHUD];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        [MBProgressHUD showError:errorStr];
                    }
                }];
            }
        }
        
        
    }
    
}
- (NSMutableDictionary *)getDicWithDataSeqID:(NSString *)seqID {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (![Utils isBlankString:self.model.flow_id]) {
        dic[@"flow_id"] = self.model.flow_id;
    } else {
        [MBProgressHUD showError:@"请选择审批流程"];
        return nil;
    }
    if (![Utils isBlankString:seqID]) {
        dic[@"seq_id"] = seqID;
    }
    if (![Utils isBlankString:self.ID]) {
        dic[@"id"] = self.ID;
    }
    dic[@"mech_id"] = @(self.loginModel.jrqMechanismId);
    dic[@"user_id"] = @(self.loginModel.userId);
    
    dic[@"application_id"] = self.application_id;
    dic[@"state_type"] = self.model.state_type;
    if (![Utils isBlankString:self.model.toUser]) {
        dic[@"toUser"] = self.model.toUser;
    }
    switch ([self.application_id integerValue]) {
        case 1:
        {
            if (![Utils isBlankString:self.model.leave_type_id]) {
                dic[@"leave_type_id"] = self.model.leave_type_id;
            }else {
                [MBProgressHUD showError:@"请选择报销类型"];
                return nil;
            }
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入报销说明"];
                return nil;
            }
            if (![Utils isBlankString:self.model.reimbursement_amount]) {
                dic[@"reimbursement_amount"] = self.model.reimbursement_amount;
            } else {
                [MBProgressHUD showError:@"请输入报销金额"];
                return nil;
            }
            
        }
            break;
        case 2:
        {
            if (![Utils isBlankString:self.model.leave_type_id]) {
                dic[@"leave_type_id"] = self.model.leave_type_id;
            }else {
                [MBProgressHUD showError:@"请选择请假类型"];
                return nil;
            }
            
            if ([Utils isBlankString:self.model.start_time]) {
                [MBProgressHUD showError:@"请选择开始时间"];
                return nil;
            } else {
                dic[@"start_time"] = self.model.start_time;
            }
            
            
            if ([Utils isBlankString:self.model.end_time]) {
                [MBProgressHUD showError:@"请选择结束时间"];
                return nil;
            } else {
                dic[@"end_time"] = self.model.end_time;
            }
            if (self.isShowHour) {
                if (![Utils isBlankString:self.qingJiaHourStr] && [self.qingJiaHourStr floatValue] > 0) {
                    dic[@"hour"] = self.qingJiaHourStr;
                }else {
                    [MBProgressHUD showError:@"请选择请假时长"];
                    return nil;
                }
            } else {
                [MBProgressHUD showError:@"请选择请假时长"];
                return nil;
            }
            
            
            if (![Utils isBlankString:self.qingJiaHourStr] && [self.qingJiaHourStr floatValue] > 0) {
                dic[@"hour"] = self.qingJiaHourStr;
            }else {
                [MBProgressHUD showError:@"请选择请假时长"];
                return nil;
            }
            
            
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入请假原因"];
                return nil;
            }
        }
            break;
        case 3:
        {
            if ([Utils isBlankString:self.model.start_time]) {
                [MBProgressHUD showError:@"请选择入职时间"];
                return nil;
            } else {
                dic[@"start_time"] = self.model.start_time;
            }
            
            if ([Utils isBlankString:self.model.end_time]) {
                [MBProgressHUD showError:@"请选择离职时间"];
                return nil;
            } else {
                dic[@"end_time"] = self.model.end_time;
            }
            dic[@"handover"] = self.model.handover;
            
            if (![Utils isBlankString:self.model.position]) {
                dic[@"position"] = self.model.position;
            }else {
                [MBProgressHUD showError:@"请输入职位"];
                return nil;
            }
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入离职原因"];
                return nil;
            }
        }
            break;
        case 4:
        {
            
            if (![Utils isBlankString:self.model.position]) {
                dic[@"position"] = self.model.position;
            }else {
                [MBProgressHUD showError:@"请输入职位"];
                return nil;
            }
            if (![Utils isBlankString:self.model.clock_time]) {
                dic[@"clock_time"] = self.model.clock_time;
            } else {
                [MBProgressHUD showError:@"请选择入职时间"];
                return nil;
            }
            
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入试用总结"];
                return nil;
            }
        }
            break;
        case 5:
        {
            if ([Utils isBlankString:self.model.start_time]) {
                [MBProgressHUD showError:@"请选择开始时间"];
                return nil;
            } else {
                dic[@"start_time"] = self.model.start_time;
            }
            
            if ([Utils isBlankString:self.model.end_time]) {
                [MBProgressHUD showError:@"请选择结束时间"];
                return nil;
            } else {
                dic[@"end_time"] = self.model.end_time;
            }
            
            if (![Utils isBlankString:self.model.hour] && [self.model.hour integerValue]>0) {
                dic[@"hour"] = self.model.hour;
            }else {
                [MBProgressHUD showError:@"请选择加班时长"];
                return nil;
            }
            
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入加班原因"];
                return nil;
            }
        }
            break;
        case 6:
        {
            if ([Utils isBlankString:self.model.start_time]) {
                [MBProgressHUD showError:@"请选择开始时间"];
                return nil;
            } else {
                dic[@"start_time"] = self.model.start_time;
            }
            
            if ([Utils isBlankString:self.model.end_time]) {
                [MBProgressHUD showError:@"请选择结束时间"];
                return nil;
            } else {
                dic[@"end_time"] = self.model.end_time;
            }
            dic[@"hour"] = self.model.hour;
            if (![Utils isBlankString:self.model.businessAddress]) {
                dic[@"businessAddress"] = self.model.businessAddress;
            }else {
                [MBProgressHUD showError:@"请输入出差地址"];
                return nil;
            }
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入行程说明"];
                return nil;
            }
        }
            break;
        case 7:
        {
            if (![Utils isBlankString:self.model.clock_time]) {
                dic[@"clock_time"] = self.model.clock_time;
            } else {
                [MBProgressHUD showError:@"请选择补打卡时间"];
                return nil;
            }
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入补打卡理由"];
                return nil;
            }
        }
            break;
        case 8:
        {
            
            if (![Utils isBlankString:self.model.clock_time]) {
                dic[@"clock_time"] = self.model.clock_time;
            }else {
                [MBProgressHUD showError:@"请选择交接日期"];
                return nil;
            }
            
            dic[@"specificationModel"] = self.model.specificationModel;
            
            if (![Utils isBlankString:self.model.reimbursement_amount]) {
                dic[@"reimbursement_amount"] = self.model.reimbursement_amount;
            }else {
                [MBProgressHUD showError:@"请输入预算金额"];
                return nil;
            }
            
            if (![Utils isBlankString:self.model.goodsPurchased]) {
                dic[@"goodsPurchased"] = self.model.goodsPurchased;
            }else {
                [MBProgressHUD showError:@"请输入物品名称"];
                return nil;
            }
            
            if (![Utils isBlankString:self.model.number]) {
                dic[@"number"] = self.model.number;
            }else {
                [MBProgressHUD showError:@"请输入物品数量"];
                return nil;
            }
            
            if (![Utils isBlankString:self.model.apply_id]) {
                dic[@"apply_id"] = self.model.apply_id;
            }else {
                [MBProgressHUD showError:@"请选择接受人"];
                return nil;
            }
            
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入申请原因"];
                return nil;
            }
        }
            break;
        case 9:
        {
            if (![Utils isBlankString:self.model.title]) {
                dic[@"title"] = self.model.title;
            }else {
                [MBProgressHUD showError:@"请输入审批标题"];
                return nil;
            }
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入说明"];
                return nil;
            }
        }
            break;
        case 10:
        {
            dic[@"start_time"] = self.model.start_time;
            dic[@"end_time"] = self.model.end_time;
            dic[@"hour"] = self.model.hour;
            if (![Utils isBlankString:self.model.businessAddress]) {
                dic[@"businessAddress"] = self.model.businessAddress;
            }else {
                [MBProgressHUD showError:@"请输入外勤地址"];
                return nil;
            }
            if (![Utils isBlankString:self.model.leave_reason]) {
                dic[@"leave_reason"] = self.model.leave_reason;
            }else {
                [MBProgressHUD showError:@"请输入行程说明"];
                return nil;
            }
        }
            break;
        default:
            break;
    }
    return dic;
}
- (void)photoViewUpdateFrame:(CGRect)frame WithView:(UIView *)view
{
    NSLog(@"%@",NSStringFromCGRect(frame));
}

// 压缩视频并写入沙盒文件
- (void)compressedVideoWithURL:(id)url success:(void(^)(NSString *fileName))success failure:(void(^)())failure
{
    AVURLAsset *avAsset;
    if ([url isKindOfClass:[NSURL class]]) {
        avAsset = [AVURLAsset assetWithURL:url];
    }else if ([url isKindOfClass:[AVAsset class]]) {
        avAsset = (AVURLAsset *)url;
    }
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSString *fileName = @""; // 这里是自己定义的文件路径
        
        NSDate *nowDate = [NSDate date];
        NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]];
        
        NSString *numStr = [NSString stringWithFormat:@"%d",arc4random()%10000];
        fileName = [fileName stringByAppendingString:dateStr];
        fileName = [fileName stringByAppendingString:numStr];
        
        // ````` 这里取的是时间加上一些随机数  保证每次写入文件的路径不一样
        fileName = [fileName stringByAppendingString:@".mp4"]; // 视频后缀
        NSString *fileName1 = [NSTemporaryDirectory() stringByAppendingString:fileName]; //文件名称
        exportSession.outputURL = [NSURL fileURLWithPath:fileName1];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(fileName1);
                        }
                    });
                }
                    break;
                case AVAssetExportSessionStatusExporting:
                    break;
                case AVAssetExportSessionStatusFailed:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (failure) {
                            failure();
                        }
                    });
                }
                    break;
                case AVAssetExportSessionStatusUnknown:
                    break;
                case AVAssetExportSessionStatusWaiting:
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)clickUpLoad {
    self.model.state_type = @"3";
    [self.approvalDetailTableView endEditing:YES];
    
    [self uploadDataSeqID:self.seq_id];
}

- (void)popBack {
    if (self.isEdit == 1) {

        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"是否保存该审批" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"不保存退出" otherButtonTitles:@"保存", nil];
        [action showInView:self.navigationController.view];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        self.model.state_type = @"1";
        [self.approvalDetailTableView endEditing:YES];
        [self uploadDataSeqID:self.seq_id];
    }
}
- (void)approvalBtnClick:(UIButton *)sender {
    

    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    if (sender.tag == 1) {
        NSString *userID = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
        self.approvalOrrejectView = [approvalOrRejectView initWithTitle:@"驳回" ID:self.ID seqID:self.seq_id mech_id:self.mech_id nowUserId:userID frame:CGRectMake(0, kScreenHeight, kScreenWidth, 260)];
        self.approvalOrrejectView.bgView.hidden = YES;
        self.approvalOrrejectView.bgView.hidden = NO;
        [self.navigationController.view addSubview:self.approvalOrrejectView.bgView];
        [self.navigationController.view addSubview:self.approvalOrrejectView];
        
        __weak typeof(self) weakSelf = self;
        self.approvalOrrejectView.isPopBlock = ^(){
            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        };
        self.approvalOrrejectView.isSuccessBlock = ^(){
            weakSelf.refreshBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [UIView animateWithDuration:0.2 animations:^{
            
            self.approvalOrrejectView.frame = CGRectMake(0, kScreenHeight-260, kScreenWidth, 260);
            
        }];
    } else {
        NSString *userID = [NSString stringWithFormat:@"%ld",self.loginModel.userId];
        self.approvalOrrejectView = [approvalOrRejectView initWithTitle:@"批准" ID:self.ID seqID:self.seq_id mech_id:self.mech_id nowUserId:userID frame:CGRectMake(0, kScreenHeight, kScreenWidth, 260)];
        self.approvalOrrejectView.bgView.hidden = YES;
        self.approvalOrrejectView.bgView.hidden = NO;
        [self.navigationController.view addSubview:self.approvalOrrejectView.bgView];
        [self.navigationController.view addSubview:self.approvalOrrejectView];
        
        __weak typeof(self) weakSelf = self;
        self.approvalOrrejectView.isPopBlock = ^(){
            weakSelf.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
        };
        self.approvalOrrejectView.isSuccessBlock = ^(){
            weakSelf.refreshBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [UIView animateWithDuration:0.2 animations:^{
            
            self.approvalOrrejectView.frame = CGRectMake(0, kScreenHeight-260, kScreenWidth, 260);
            
        }];
    }
}

- (void)editBtnClick:(UIButton *)sender {
    
}

- (void)deleteBtnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"删除审批申请" message:@"删除后将无法恢复,确认要删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alert.tag = 1;
        [alert show];
    } else {
        self.isEdit = 1;
        if (!self.isChooseHour) {
            self.isChooseHour = 1;
        }
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
        self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight, kScreenWidth-20, kScreenHeight-NaviHeight-10);
        if (IS_IPHONE_X) {
            self.approvalDetailTableView.frame = CGRectMake(10, NaviHeight, kScreenWidth-20, kScreenHeight-NaviHeight-10-30);
        }
        self.editOrDeleteBottomView.hidden = YES;
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(clickUpLoad)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [self.approvalDetailTableView reloadData];
    }
}

- (void)recallBtnClick:(UIButton *)sender {
    JKAlertView *alert = [[JKAlertView alloc]initWithTitle:@"撤回审批申请" message:@"确认要撤回该审批申请吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤回", nil];
    alert.tag = 2;
    [alert show];
}
- (void)alertView:(JKAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [HttpRequestEngine deleteApprovalWithID:self.ID completion:^(id obj, NSString *errorStr) {
                if ([Utils isBlankString:errorStr]) {
                    self.refreshBlock();
                    if (self.iconArr.count) {
                        self.deleteImgaeArr = [NSMutableArray arrayWithArray:self.iconArr];
                        [self deleteImage];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        }
    }else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            self.model.state_type = @"1";
            [self.approvalDetailTableView endEditing:YES];
            [HttpRequestEngine recallApprovalWithID:self.ID seq_id:self.model.seq_id mech_id:self.mech_id completion:^(id obj, NSString *errorStr) {
                if ([Utils isBlankString:errorStr]) {
                    self.refreshBlock();
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [MBProgressHUD showError:errorStr];
                }
            }];
        }
    }else if (alertView.tag == 3) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)deleteImage {
    NSString *imageURL = [self.deleteImgaeArr[self.deleteImageIndex] stringByReplacingOccurrencesOfString:@"_min.jpg" withString:@".jpg"];
    [HttpRequestEngine deleteImageWithUrl:imageURL completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            if (self.deleteImageIndex != self.deleteImgaeArr.count-1) {
                self.deleteImageIndex = self.deleteImageIndex+1;
                [self deleteImage];
            } else {
                return ;
            }
        }
    }];
}
- (void)deleteImgaeWithDic:(NSMutableDictionary *)dic {
    NSString *imageURL = [self.deleteImgaeArr[self.deleteImageIndex] stringByReplacingOccurrencesOfString:@"_min.jpg" withString:@".jpg"];
    [HttpRequestEngine deleteImageWithUrl:imageURL completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            if (self.deleteImageIndex != self.deleteImgaeArr.count-1) {
                self.deleteImageIndex = self.deleteImageIndex+1;
                [self deleteImgaeWithDic:dic];
                
            } else {
                
                if (self.UploadImageArr.count) {
                    // 获取数组里面图片原图的 imageData 资源 传入的数组里装的是 HXPhotoModel  -- 这个方法必须写在点击上传的位置
                    [HXPhotoTools fetchImageDataForSelectedPhoto:self.UploadImageArr completion:^(NSArray<NSData *> *imageDatas) {
                        NSLog(@"imageDatas.count == %ld",imageDatas.count);
                        self.selectedImageArr = [NSMutableArray arrayWithArray:imageDatas];
                        [self uploadImageWithDataDic:dic];
                    }];
                } else {
                    if (self.iconArr.count) {
                        for (NSString *iconStr in self.iconArr) {
                            NSDictionary *dic = @{@"icon":[iconStr stringByReplacingOccurrencesOfString:@"_min.jpg" withString:@".jpg"]};
                            [self.iconDicArr addObject:dic];
                        }
                        if (self.iconDicArr.count) {
                            dic[@"iconList"] = self.iconDicArr;
                        }
                    }
                    
                    [HttpRequestEngine addApprovalWithDic:dic completion:^(id obj, NSString *errorStr) {
                        
                        if ([Utils isBlankString:errorStr]) {
                            self.refreshBlock();
                            [MBProgressHUD hideHUD];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [MBProgressHUD showError:errorStr];
                        }
                    }];
                }
                
            }
        } else {
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
}
#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    
    switch ([self.application_id integerValue]) {
        case 2:
        {
            self.qingJiaChoseStr = @"";
            if (self.dateTimeSelectStr == 3) {
                self.model.start_time = [NSString stringWithFormat:@"%@%@",dictDate[@"date"],dictDate[@"time"]];
            } else if (self.dateTimeSelectStr == 4) {
                self.model.end_time = [NSString stringWithFormat:@"%@%@",dictDate[@"date"],dictDate[@"time"]];
            }
        }
            break;
        case 5:
        {
            if (self.dateTimeSelectStr == 2) {
                self.model.start_time = [NSString stringWithFormat:@"%@%@",dictDate[@"date"],dictDate[@"time"]];
            } else if (self.dateTimeSelectStr == 3) {
                self.model.end_time = [NSString stringWithFormat:@"%@%@",dictDate[@"date"],dictDate[@"time"]];
            }
        }
            break;
        case 10:
        {
            if (self.dateTimeSelectStr == 3) {
                self.model.start_time = [NSString stringWithFormat:@"%@%@",dictDate[@"date"],dictDate[@"time"]];
            } else if (self.dateTimeSelectStr == 4) {
                self.model.end_time = [NSString stringWithFormat:@"%@%@",dictDate[@"date"],dictDate[@"time"]];
            }
        }
            break;
    }
    [self.approvalDetailTableView endEditing:YES];
}

- (void)cancelDate {
    self.qingJiaChoseStr = @"";
    [self.approvalDetailTableView endEditing:YES];
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
