//
//  ApplyProductVC.m
//  Financeteam
//
//  Created by 张正飞 on 16/9/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ApplyProductVC.h"

#import "UIImageView+WebCache.h"
#import "LGPhoto.h"
#import "STPhotoBrowserController.h"
#import "STConfig.h"
#import "UIButton+WebCache.h"
#import "WorkBtn.h"
#define HEADER_HEIGHT 100

#import <objc/runtime.h>
#import <objc/message.h>

#import "FDAlertView.h"
#import "RBCustomDatePickerView.h"
#import "LocationData.h"
#import "TimeButtonCell.h"
#import "PersonServiceCell.h"
#import "ButtonsModel.h"
#import "PersonInfoTextViewCell.h"
#import "OneButtonCell.h"
#import "ButtonsCell.h"
#import "TwoLabelCell.h"
#import "LevelOneCell.h"
#import "LevelTwoCell.h"
#import "LongLabelCell.h"
#import "RedLabelCell.h"
#import "CPITreeViewNode.h"
#import "LevelOneModel.h"
#import "LevelTwoModel.h"
#import "longLabelModel.h"
#import "CommonMoneyModel.h"
#import "RedLabelModel.h"
#import "UpOneButtonCell.h"
#import "UpTwoButtonCell.h"
#import "AddressButtonCell.h"
#import "citiesViewController.h"
@interface ApplyProductVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,SelectDateTimeDelegate,LGPhotoPickerViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate,STPhotoBrowserDelegate>

{
    LoginPeopleModel * loginModel;
    DateTimeSelectView *_dateTimeSelectView;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) NSInteger GRCellHeight;
@property (nonatomic, assign) NSInteger ZCCellHeight;

@property (nonatomic,strong) NSString * GRName;
@property (nonatomic,strong) NSString * ZCName;

@property(nonatomic,strong)NSMutableDictionary * dataDic;

@property(nonatomic,strong)UIView * topView;

@property(nonatomic,strong)UIView * bottomView;

@property(nonatomic,strong)UIView * backgroundView;

@property(nonatomic,strong)UIScrollView * mainScrollView;//主视图

@property(nonatomic,strong)UIImageView * leftImageView;

@property(nonatomic,strong)UIImageView * rightImageView;

@property(nonatomic,assign)NSInteger lastBtnTag;

@property(nonatomic,assign)NSInteger lastTag;

@property(nonatomic,assign)NSInteger proID;
@property(nonatomic,assign)NSInteger cityID;
@property(nonatomic,assign)NSInteger areaID;

//个人服务申请表
@property(nonatomic,strong)UITableView * psTableView;
@property(nonatomic,strong)NSArray * leftDataArray;
@property(nonatomic,strong)NSArray * rightDataArray;

//个人信息
@property(nonatomic,strong)UITableView * personalInfoTableView;
@property(nonatomic,strong)NSMutableArray * personalInfo;
@property(nonatomic,strong)NSMutableArray * buttonArrayOne;

//资产信息
@property(nonatomic,strong) UITableView * assetInfoTableView;
@property(nonatomic,strong) NSMutableArray * assetInfo;
@property(nonatomic,strong) NSMutableArray * buttonArrayTwo;

//工作信息
@property(nonatomic,strong) UITableView * workInfoTableView;
@property(nonatomic,strong) NSMutableArray * workInfo;
@property(nonatomic,strong) NSMutableArray * buttonArrayTree;

//联系人信息
@property(nonatomic,strong)UITableView * cpiTableView;
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组

//材料上传
@property (nonatomic, strong) UITableView *photosTableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, assign) NSInteger whitchBtn;//判断点击的是哪个按钮
@property (nonatomic, strong, nullable)UIView *currentView; //
@property (nonatomic, strong, nullable)NSArray *currentArray; //
@property (nonatomic, strong) UIView *whicthCell;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray;
@property (nonatomic, assign) LGShowImageType showType;

@property(nonatomic,strong)UITableView * materialUpTableView;
@property(nonatomic,strong)NSArray * sectionNameArray;
@property(nonatomic,strong)UIImagePickerController * imagePC;

@property(nonatomic,assign)NSInteger imageIndex;



//接口字段
//申请人性别
@property (nonatomic)NSInteger tabUSex;
//证件类型1身份证2护照3军官证
@property (nonatomic)NSInteger tabUIdType;
//婚姻状况1已婚2未婚3离异4丧偶
@property (nonatomic)NSInteger tabUMarry;
//有无子女1有2无
@property (nonatomic)NSInteger tabUChild;
//最高学历1本科及以上2大专3高中4高中及以下
@property (nonatomic)NSInteger tabUEdu;
//住宅类型1租用2商业按揭购房3公积金按揭购房4全款商品房5自建房6家族房7单位宿舍8其他
@property (nonatomic)NSInteger tabUHsType;
//租金或还款 如果tabUHsType为123则必填 元
@property (nonatomic)NSInteger tabUHsMoney;
//其他 如果tabUHsType为8则必填
@property (nonatomic,strong) NSString *tabUHsOther;
// 房产类型 1揭购房 2自建房 3全款房 4其他
@property (nonatomic)NSInteger houseType;
//单位性质1行政事业单位、社会团体 2国企 3民营 4外资 5合资 6私营 7个体
@property (nonatomic)NSInteger wkType;
//工资发放形式 1银行代发 2现金 3网银
@property (nonatomic)NSInteger wkMonType;
// 贷款用途1经营2消费
@property (nonatomic)NSInteger tabLoan;

//户口所在省
@property (nonatomic)NSInteger proId;
//户口所在市
@property (nonatomic)NSInteger cityId;
//户口所在区
@property (nonatomic)NSInteger areaId;

//住址省
@property (nonatomic)NSInteger adsProId;
//住址市
@property (nonatomic)NSInteger adsCityId;
//住址区
@property (nonatomic)NSInteger adsAreaId;

//房产地址 省
@property (nonatomic)NSInteger houseProId;
//房产地址 市
@property (nonatomic)NSInteger houseCityId;
//房产地址 区
@property (nonatomic)NSInteger houseAreaId;

//单位地址省
@property (nonatomic)NSInteger wkProId;
//单位地址市
@property (nonatomic)NSInteger wkCityId;
//单位地址区
@property (nonatomic)NSInteger wkAreaId;

//来本地时间
@property (nonatomic)long long  adsTime;
//开始居住时间
@property (nonatomic)long long  adsStarTime;

//购房时间
@property (nonatomic)long long  houseDate;

//购车时间
@property (nonatomic)long long  carDate;

//入职时间
@property (nonatomic)long long  wkDate;

//身份证正面
@property (nonatomic,strong) NSString *photoIdFront;
//身份证反面
@property (nonatomic,strong) NSString *photoIdBack;
//户口本
@property (nonatomic,strong) NSString *photoRegist;
@property (nonatomic,strong) NSString *photoRegist2;
@property (nonatomic,strong) NSString *photoRegist3;

//房产证
@property (nonatomic,strong) NSString *photoHouse;
@property (nonatomic,strong) NSString *photoHouse2;
@property (nonatomic,strong) NSString *photoHouse3;

//结婚证
@property (nonatomic,strong) NSString *photoMarry;
@property (nonatomic,strong) NSString *photoMarry2;
@property (nonatomic,strong) NSString *photoMarry3;

//工作收入证明
@property (nonatomic,strong) NSString *photoWork;
@property (nonatomic,strong) NSString *photoWork2;
@property (nonatomic,strong) NSString *photoWork3;

//工资流水证明
@property (nonatomic,strong) NSString *photoWages;
@property (nonatomic,strong) NSString *photoWages2;
@property (nonatomic,strong) NSString *photoWages3;

//其他证明
@property (nonatomic,strong) NSString *photoOther;
@property (nonatomic,strong) NSString *photoOther2;
@property (nonatomic,strong) NSString *photoOther3;
// 信用报告
@property (nonatomic,strong) NSString *photoCredit;
@property (nonatomic,strong) NSString *photoCredit2;
@property (nonatomic,strong) NSString *photoCredit3;
@property (nonatomic,strong) NSString *photoCredit4;
@property (nonatomic,strong) NSString *photoCredit5;
@property (nonatomic,strong) NSString *photoCredit6;
@property (nonatomic,strong) NSString *photoCredit7;
@property (nonatomic,strong) NSString *photoCredit8;
@property (nonatomic,strong) NSString *photoCredit9;
@property (nonatomic,strong) NSString *photoCredit10;


@property (nonatomic, strong) NSMutableArray *photoIdArr;
@property (nonatomic, strong) NSMutableArray *photoRegistArr;
@property (nonatomic, strong) NSMutableArray *photoHouseArr;
@property (nonatomic, strong) NSMutableArray *photoMarryArr;
@property (nonatomic, strong) NSMutableArray *photoWorkArr;
@property (nonatomic, strong) NSMutableArray *photoWagesArr;
@property (nonatomic, strong) NSMutableArray *photoOtherArr;
@property (nonatomic, strong) NSMutableArray *photoCreditArr;

@property (nonatomic,strong)UIView * vv;

@end

@implementation ApplyProductVC

static NSInteger step = 0;

static NSInteger temp;
static NSString * returnTimeOne;
static NSString * returnTimeTwo;
static NSString * returnTimeThree;
static NSString * returnTimeFour;
static NSString * returnTimeFive;

static NSString * returnAddressOne;
static NSString * returnAddressTwo;
static NSString * returnAddressThree;
static NSString * returnAddressFour;


- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

- (NSMutableArray *)actionSheetArray{
    if (!_actionSheetArray) {
        _actionSheetArray = [NSMutableArray array];
    }
    return _actionSheetArray;
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
    
    
    
    self.navigationItem.title = @"个人服务申请表";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    
    self.whicthCell = [[UIView alloc]init];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回（左）"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"完成对勾"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickONOk)];
    self.navigationItem.rightBarButtonItem = right;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    [self loadData];
    
    [self creatUI];
    
    [self reloadDataForDisplayArray];//初始化将要显示的数据
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.5;
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    // 选择时间界面
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"yyyy-MM-dd"];
    _dateTimeSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
    
}

#pragma mark --加载数据
-(void)loadData{
    
    /*******个人服务申请表******/
    _leftDataArray = @[@"您申请的贷款额度",@"您申请的期限",@"您可接受的月还款额"];
    _rightDataArray = @[@"万元",@"年",@"元"];
    
    /*******个人信息******/
    _personalInfo = [@[@"姓        名",@"性        别",@"移动电话",@"证件类型",@"证件号码",@"婚姻状况",@"子       女",@"最高学历",@"Q        Q",@"邮       箱",@"户口所在地",@"户口详细地址",@"户口邮政编码",@"现住宅地址",@"住宅详细地址",@"住宅邮政编码",@"现住宅类型",@"哈哈",@"住宅电话",@"来本地时间",@"起始居住时间"] mutableCopy];
    
    ButtonsModel * model1 = [[ButtonsModel alloc]init];
    model1.name = @"性        别";
    model1.BtnArr = [NSMutableArray arrayWithObjects:@"男", @"女",nil];
    model1.index = 0;
    
    ButtonsModel * model2 = [[ButtonsModel alloc]init];
    model2.name = @"证件类型";
    model2.BtnArr = [NSMutableArray arrayWithObjects:@"身份证",@"护照",@"军官证", nil];
    model2.index = 0;
    
    ButtonsModel * model3 = [[ButtonsModel alloc]init];
    model3.name = @"婚姻状况";
    model3.BtnArr = [NSMutableArray arrayWithObjects:@"已婚",@"未婚",@"离异",@"丧偶", nil];
    model3.index = 0;
    
    ButtonsModel * model4 = [[ButtonsModel alloc]init];
    model4.name = @"子       女";
    model4.BtnArr = [NSMutableArray arrayWithObjects:@"有",@"无", nil];
    model4.index = 0;
    
    ButtonsModel * model5 = [[ButtonsModel alloc]init];
    model5.name = @"最高学历";
    model5.BtnArr = [NSMutableArray arrayWithObjects:@"本科及以上",@"大专",@"高中",@"高中以下", nil];
    model5.index = 0;
    
    ButtonsModel * model6 = [[ButtonsModel alloc]init];
    model6.name = @"现住宅类型";
    model6.BtnArr = [NSMutableArray arrayWithObjects:@"租用",@"商业按揭购房",@"公积金按揭购房",@"全款商品房",@"自建房",@"家族房",@"单位宿舍",@"其他", nil];
    model6.index = 0;
    _buttonArrayOne = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,model5,model6, nil];
    
    /******资产信息******/
    _assetInfo = [@[@"房产类型",@"其他房产类型",@"购买单价",@"房产地址",@"房产详细地址",@"购买日期",@"建筑面积",@"产权比例",@"贷款年限",@"月供",@"贷款余额",@"车辆品牌",@"购买价格",@"月供贷款",@"购买时间"] mutableCopy];
    
    ButtonsModel * model7 = [[ButtonsModel alloc]init];
    model7.name = @"房产类型";;
    model7.BtnArr = [NSMutableArray arrayWithObjects:@"按揭房",@"自建房",@"全款房",@"其他", nil];
    model7.index = 0;
    _buttonArrayTwo = [NSMutableArray arrayWithObjects:model7, nil];
    
    /******工作信息******/
    _workInfo = [@[@"单位名称",@"单位地址",@"单位详细地址",@"单位性质",@"所属行业",@"单位电话",@"所属部门",@"担任职位",@"入职时间",@"月总收入(含其他收入)",@"发薪日",@"发薪形式"] mutableCopy];
    
    ButtonsModel * model8 = [[ButtonsModel alloc]init];
    model8.name = @"单位性质";
    model8.BtnArr = [NSMutableArray arrayWithObjects:@"行政事业单位、社会团体",@"国企",@"民营",@"外资",@"合资",@"私营",@"个体", nil];
    model8.index = 0;
    
    ButtonsModel * model9 = [[ButtonsModel alloc]init];
    model9.name = @"发薪形式";
    model9.BtnArr = [NSMutableArray arrayWithObjects:@"银行代发",@"现金",@"网银", nil];
    model9.index = 0;
    _buttonArrayTree = [NSMutableArray arrayWithObjects:model8, model9,nil];
    
    /******联系人信息******/
    CPITreeViewNode * node3 = [[CPITreeViewNode alloc]init];
    node3.nodeLevel = 0;//根层cell
    node3.type = 1;//type 1的cell
    node3.sonNodes = nil;
    node3.isExpanded = FALSE;//关闭状态
    LevelOneModel *tmp3 =[[LevelOneModel alloc]init];
    tmp3.name = @"配偶(直系)";
    tmp3.sonCount = @"7";
    node3.nodeData = tmp3;
    
    CPITreeViewNode * node4 = [[CPITreeViewNode alloc]init];
    node4.nodeLevel = 0;
    node4.type = 1;
    node4.sonNodes = nil;
    node4.isExpanded = FALSE;
    LevelOneModel *tmp4 =[[LevelOneModel alloc]init];
    tmp4.name = @"直系亲属";
    tmp4.sonCount = @"4";
    node4.nodeData = tmp4;
    
    CPITreeViewNode * node5 = [[CPITreeViewNode alloc]init];
    node5.nodeLevel = 0;
    node5.type = 1;
    node5.sonNodes = nil;
    node5.isExpanded = FALSE;
    LevelOneModel *tmp5=[[LevelOneModel alloc]init];
    tmp5.name = @"单位同事";
    tmp5.sonCount = @"4";
    node5.nodeData = tmp5;
    
    CPITreeViewNode * node6 = [[CPITreeViewNode alloc]init];
    node6.nodeLevel = 0;
    node6.type = 1;
    node6.sonNodes = nil;
    node6.isExpanded = FALSE;
    LevelOneModel *tmp6 =[[LevelOneModel alloc]init];
    tmp6.name = @"其他联系人";
    tmp6.sonCount = @"4";
    node6.nodeData = tmp6;
    
    CPITreeViewNode * node26 = [[CPITreeViewNode alloc]init];
    node26.nodeLevel = 0;
    node26.type = 3;
    node26.sonNodes = nil;
    node26.isExpanded = FALSE;
    longLabelModel *tmp26 = [[longLabelModel alloc]init];
    tmp26.longLabelString = @"以上哪些联系人可以知晓贷款";
    tmp26.longTextString = @" ";
    node26.nodeData = tmp26;
    
    CPITreeViewNode * node27 = [[CPITreeViewNode alloc]init];
    node27.nodeLevel = 0;
    node27.type = 4;
    node27.sonNodes = nil;
    node27.isExpanded = FALSE;
    CommonMoneyModel *tmp27 = [[CommonMoneyModel alloc]init];
    tmp27.commonMoneyString = @"共同贷款人";
    tmp27.commonMoneyText = @" ";
    node27.nodeData = tmp27;
    
    CPITreeViewNode * node28 = [[CPITreeViewNode alloc]init];
    node28.nodeLevel = 0;
    node28.type = 5;
    node28.sonNodes = nil;
    node28.isExpanded = FALSE;
    ButtonsModel * tmp28 = [[ButtonsModel alloc]init];
    tmp28.name = @"贷款用途";
    tmp28.BtnArr = [NSMutableArray arrayWithObjects:@"经营", @"消费",nil];
    tmp28.type = 1;
    tmp28.index = 0;
    node28.nodeData = tmp28;
    
    CPITreeViewNode * node29 = [[CPITreeViewNode alloc]init];
    node29.nodeLevel = 0;
    node29.type = 6;
    node29.sonNodes = nil;
    node29.isExpanded = FALSE;
    RedLabelModel * tmp29 = [[RedLabelModel alloc]init];
    tmp29.leftRedString = @"详细用途说明";
    tmp29.redString = @"(如不实将不能通过审核)";
    
    node29.nodeData = tmp29;
    
    //第一层节点
    CPITreeViewNode * node7 = [[CPITreeViewNode alloc]init];
    node7.nodeLevel = 1;//
    node7.type = 2;//type 2的cell
    node7.sonNodes = nil;
    node7.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp7 =[[LevelTwoModel alloc]init];
    tmp7.nameString = @"姓名";
    tmp7.textString = @" ";
    tmp7.num = @"1";
    node7.nodeData = tmp7;
    
    CPITreeViewNode * node8 = [[CPITreeViewNode alloc]init];
    node8.nodeLevel = 1;//
    node8.type = 2;//type 2的cell
    node8.sonNodes = nil;
    node8.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp8 =[[LevelTwoModel alloc]init];
    tmp8.nameString = @"身份证号码";
    tmp8.textString = @" ";
    tmp8.num = @"2";
    node8.nodeData = tmp8;
    
    CPITreeViewNode * node9 = [[CPITreeViewNode alloc]init];
    node9.nodeLevel = 1;//
    node9.type = 2;//type 2的cell
    node9.sonNodes = nil;
    node9.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp9=[[LevelTwoModel alloc]init];
    tmp9.nameString = @"移动电话";
    tmp9.textString = @" ";
    tmp9.num = @"3";
    node9.nodeData = tmp9;
    
    CPITreeViewNode * node10 = [[CPITreeViewNode alloc]init];
    node10.nodeLevel = 1;//
    node10.type = 2;//type 2的cell
    node10.sonNodes = nil;
    node10.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp10 =[[LevelTwoModel alloc]init];
    tmp10.nameString = @"单位名称";
    tmp10.textString = @" ";
    tmp10.num = @"4";
    node10.nodeData = tmp10;
    
    CPITreeViewNode * node11 = [[CPITreeViewNode alloc]init];
    node11.nodeLevel = 1;//
    node11.type = 2;//type 2的cell
    node11.sonNodes = nil;
    node11.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp11 =[[LevelTwoModel alloc]init];
    tmp11.nameString = @"单位地址";
    tmp11.textString = @" ";
    tmp11.num = @"5";
    node11.nodeData = tmp11;
    
    CPITreeViewNode * node12 = [[CPITreeViewNode alloc]init];
    node12.nodeLevel = 1;//
    node12.type = 2;//type 2的cell
    node12.sonNodes = nil;
    node12.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp12 =[[LevelTwoModel alloc]init];
    tmp12.nameString = @"单位电话";
    tmp12.textString = @" ";
    tmp12.num = @"6";
    node12.nodeData = tmp12;
    
    CPITreeViewNode * node13 = [[CPITreeViewNode alloc]init];
    node13.nodeLevel = 1;//
    node13.type = 2;//type 2的cell
    node13.sonNodes = nil;
    node13.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp13 =[[LevelTwoModel alloc]init];
    tmp13.nameString = @"居住地址";
    tmp13.textString = @" ";
    tmp13.num = @"7";
    node13.nodeData = tmp13;
    
    CPITreeViewNode * node14 = [[CPITreeViewNode alloc]init];
    node14.nodeLevel = 1;//
    node14.type = 2;//type 2的cell
    node14.sonNodes = nil;
    node14.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp14 =[[LevelTwoModel alloc]init];
    tmp14.nameString = @"姓名";
    tmp14.textString = @" ";
    tmp14.num = @"8";
    node14.nodeData = tmp14;
    
    CPITreeViewNode * node15 = [[CPITreeViewNode alloc]init];
    node15.nodeLevel = 1;//
    node15.type = 2;//type 2的cell
    node15.sonNodes = nil;
    node15.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp15 =[[LevelTwoModel alloc]init];
    tmp15.nameString = @"关系";
    tmp15.textString = @" ";
    tmp15.num = @"9";
    node15.nodeData = tmp15;
    
    CPITreeViewNode * node16 = [[CPITreeViewNode alloc]init];
    node16.nodeLevel = 1;//
    node16.type = 2;//type 2的cell
    node16.sonNodes = nil;
    node16.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp16 =[[LevelTwoModel alloc]init];
    tmp16.nameString = @"亲属手机";
    tmp16.textString = @" ";
    tmp16.num = @"10";
    node16.nodeData = tmp16;
    
    CPITreeViewNode * node17 = [[CPITreeViewNode alloc]init];
    node17.nodeLevel = 1;//
    node17.type = 2;//type 2的cell
    node17.sonNodes = nil;
    node17.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp17 =[[LevelTwoModel alloc]init];
    tmp17.nameString = @"亲属单位";
    tmp17.textString = @" ";
    tmp17.num = @"11";
    node17.nodeData = tmp17;
    
    CPITreeViewNode * node18 = [[CPITreeViewNode alloc]init];
    node18.nodeLevel = 1;//
    node18.type = 2;//type 2的cell
    node18.sonNodes = nil;
    node18.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp18 =[[LevelTwoModel alloc]init];
    tmp18.nameString = @"姓名";
    tmp18.textString = @" ";
    tmp18.num = @"12";
    node18.nodeData = tmp18;
    
    CPITreeViewNode * node19 = [[CPITreeViewNode alloc]init];
    node19.nodeLevel = 1;//
    node19.type = 2;//type 2的cell
    node19.sonNodes = nil;
    node19.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp19=[[LevelTwoModel alloc]init];
    tmp19.nameString = @"职务";
    tmp19.textString = @" ";
    tmp19.num = @"13";
    node19.nodeData = tmp19;
    
    CPITreeViewNode * node20 = [[CPITreeViewNode alloc]init];
    node20.nodeLevel = 1;//
    node20.type = 2;//type 2的cell
    node20.sonNodes = nil;
    node20.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp20 =[[LevelTwoModel alloc]init];
    tmp20.nameString = @"同事手机";
    tmp20.textString = @" ";
    tmp20.num = @"14";
    node20.nodeData = tmp20;
    
    CPITreeViewNode * node21 = [[CPITreeViewNode alloc]init];
    node21.nodeLevel = 1;//
    node21.type = 2;//type 2的cell
    node21.sonNodes = nil;
    node21.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp21 =[[LevelTwoModel alloc]init];
    tmp21.nameString = @"同事单位";
    tmp21.textString = @" ";
    tmp21.num = @"15";
    node21.nodeData = tmp21;
    
    CPITreeViewNode * node22 = [[CPITreeViewNode alloc]init];
    node22.nodeLevel = 1;//
    node22.type = 2;//type 2的cell
    node22.sonNodes = nil;
    node22.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp22 =[[LevelTwoModel alloc]init];
    tmp22.nameString = @"姓名";
    tmp22.textString = @" ";
    tmp22.num = @"16";
    node22.nodeData = tmp22;
    
    CPITreeViewNode * node23 = [[CPITreeViewNode alloc]init];
    node23.nodeLevel = 1;//
    node23.type = 2;//type 2的cell
    node23.sonNodes = nil;
    node23.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp23 =[[LevelTwoModel alloc]init];
    tmp23.nameString = @"关系";
    tmp23.textString = @" ";
    tmp23.num = @"17";
    node23.nodeData = tmp23;
    
    CPITreeViewNode * node24 = [[CPITreeViewNode alloc]init];
    node24.nodeLevel = 1;//
    node24.type = 2;//type 2的cell
    node24.sonNodes = nil;
    node24.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp24 =[[LevelTwoModel alloc]init];
    tmp24.nameString = @"其他联系人手机";
    tmp24.textString = @" ";
    tmp24.num = @"18";
    node24.nodeData = tmp24;
    
    CPITreeViewNode * node25 = [[CPITreeViewNode alloc]init];
    node25.nodeLevel = 1;//
    node25.type = 2;//type 2的cell
    node25.sonNodes = nil;
    node25.isExpanded = FALSE;//关闭状态
    LevelTwoModel *tmp25 =[[LevelTwoModel alloc]init];
    tmp25.nameString = @"其他联系人单位";
    tmp25.textString = @" ";
    tmp25.num = @"19";
    node25.nodeData = tmp25;
    
    node3.sonNodes = [NSMutableArray arrayWithObjects:node7,node8,node9,node10,node11,node12,node13, nil];
    node4.sonNodes = [NSMutableArray arrayWithObjects:node14,node15,node16,node17, nil];
    node5.sonNodes = [NSMutableArray arrayWithObjects:node18,node19,node20,node21, nil];
    node6.sonNodes = [NSMutableArray arrayWithObjects:node22,node23,node24,node25, nil];
    
    _dataArray = [NSMutableArray arrayWithObjects:node3,node4,node5,node6, node26,node27,node28,node29,nil];
    
    /******材料上传******/
    self.titleArr = [NSArray arrayWithObjects:@"身份证",@"户口簿",@"房产信息",@"结婚证明",@"工作收入证明",@"工资流水证明",@"信用报告",@"其他", nil];
    
    self.photoIdFront = self.PhotoModel.photoIdFront;
    self.photoIdBack = self.PhotoModel.photoIdBack;
    //    NSLog(@"self.PhotoModel == %@",self.PhotoModel);
    NSLog(@"self.photoIdFront == %@ \n self.photoIdBack == %@",self.photoIdFront,self.photoIdBack);
    self.photoIdArr = [NSMutableArray array];
    if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
        
    } else {
//        [self.photoIdArr addObject:@"/mechpro/mpro1474271889948.jpg"];
//        self.photoIdFront = @"/mechpro/mpro1474271889948.jpg";
        [self.photoIdArr addObject:self.photoIdFront];
    }
    if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
        
    } else {
//        [self.photoIdArr addObject:@"/mechpro/mpro1474271889948.jpg"];
//        self.photoIdBack = @"/mechpro/mpro1474271889948.jpg";
        [self.photoIdArr addObject:self.photoIdBack];
        
    }
    self.photoRegist = self.PhotoModel.photoRegist;
    self.photoRegist2 = self.PhotoModel.photoRegist2;
    self.photoRegist3 = self.PhotoModel.photoRegist3;
    self.photoRegistArr = [NSMutableArray array];
    if (self.photoRegist.length == 0 || [self.photoRegist isEqualToString:@""] || self.photoRegist == nil || self.photoRegist == NULL || [self.photoRegist isEqual:[NSNull null]] || [self.photoRegist isEqualToString:@"(null)"] || [self.photoRegist isEqualToString:@"null"]) {
        
    } else {
        [self.photoRegistArr addObject:self.photoRegist];
    }
    if (self.photoRegist2.length == 0 || [self.photoRegist2 isEqualToString:@""] || self.photoRegist2 == nil || self.photoRegist2 == NULL || [self.photoRegist2 isEqual:[NSNull null]] || [self.photoRegist2 isEqualToString:@"(null)"] || [self.photoRegist2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoRegistArr addObject:self.photoRegist2];
    }
    if (self.photoRegist3.length == 0 || [self.photoRegist3 isEqualToString:@""] || self.photoRegist3 == nil || self.photoRegist3 == NULL || [self.photoRegist3 isEqual:[NSNull null]] || [self.photoRegist3 isEqualToString:@"(null)"] || [self.photoRegist3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoRegistArr addObject:self.photoRegist3];
    }
    
    
    self.photoHouse = self.PhotoModel.photoHouse;
    self.photoHouse2 = self.PhotoModel.photoHouse2;
    self.photoHouse3 = self.PhotoModel.photoHouse3;
    self.photoHouseArr = [NSMutableArray array];
    if (self.photoHouse.length == 0 || [self.photoHouse isEqualToString:@""] || self.photoHouse == nil || self.photoHouse == NULL || [self.photoHouse isEqual:[NSNull null]] || [self.photoHouse isEqualToString:@"(null)"] || [self.photoHouse isEqualToString:@"null"]) {
        
    } else {
        [self.photoHouseArr addObject:self.photoHouse];
    }
    if (self.photoHouse2.length == 0 || [self.photoHouse2 isEqualToString:@""] || self.photoHouse2 == nil || self.photoHouse2 == NULL || [self.photoHouse2 isEqual:[NSNull null]] || [self.photoHouse2 isEqualToString:@"(null)"] || [self.photoHouse2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoHouseArr addObject:self.photoHouse2];
    }
    if (self.photoHouse3.length == 0 || [self.photoHouse3 isEqualToString:@""] || self.photoHouse3 == nil || self.photoHouse3 == NULL || [self.photoHouse3 isEqual:[NSNull null]] || [self.photoHouse3 isEqualToString:@"(null)"] || [self.photoHouse3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoHouseArr addObject:self.photoHouse3];
    }
    
    self.photoMarry = self.PhotoModel.photoMarry;
    self.photoMarry2 = self.PhotoModel.photoMarry2;
    self.photoMarry3 = self.PhotoModel.photoMarry3;
    self.photoMarryArr = [NSMutableArray array];
    if (self.photoMarry.length == 0 || [self.photoMarry isEqualToString:@""] || self.photoMarry == nil || self.photoMarry == NULL || [self.photoMarry isEqual:[NSNull null]] || [self.photoMarry isEqualToString:@"(null)"] || [self.photoMarry isEqualToString:@"null"]) {
        
    } else {
        [self.photoMarryArr addObject:self.photoMarry];
    }
    if (self.photoMarry2.length == 0 || [self.photoMarry2 isEqualToString:@""] || self.photoMarry2 == nil || self.photoMarry2 == NULL || [self.photoMarry2 isEqual:[NSNull null]] || [self.photoMarry2 isEqualToString:@"(null)"] || [self.photoMarry2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoMarryArr addObject:self.photoMarry2];
    }
    if (self.photoMarry3.length == 0 || [self.photoMarry3 isEqualToString:@""] || self.photoMarry3 == nil || self.photoMarry3 == NULL || [self.photoMarry3 isEqual:[NSNull null]] || [self.photoMarry3 isEqualToString:@"(null)"] || [self.photoMarry3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoMarryArr addObject:self.photoMarry3];
    }
    
    self.photoWork = self.PhotoModel.photoWork;
    self.photoWork2 = self.PhotoModel.photoWork2;
    self.photoWork3 = self.PhotoModel.photoWork3;
    self.photoWorkArr = [NSMutableArray array];
    if (self.photoWork.length == 0 || [self.photoWork isEqualToString:@""] || self.photoWork == nil || self.photoWork == NULL || [self.photoWork isEqual:[NSNull null]] || [self.photoWork isEqualToString:@"(null)"] || [self.photoWork isEqualToString:@"null"]) {
        
    } else {
        [self.photoWorkArr addObject:self.photoWork];
    }
    if (self.photoWork2.length == 0 || [self.photoWork2 isEqualToString:@""] || self.photoWork2 == nil || self.photoWork2 == NULL || [self.photoWork2 isEqual:[NSNull null]] || [self.photoWork2 isEqualToString:@"(null)"] || [self.photoWork2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWorkArr addObject:self.photoWork2];
    }
    if (self.photoWork3.length == 0 || [self.photoWork3 isEqualToString:@""] || self.photoWork3 == nil || self.photoWork3 == NULL || [self.photoWork3 isEqual:[NSNull null]] || [self.photoWork3 isEqualToString:@"(null)"] || [self.photoWork3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWorkArr addObject:self.photoWork3];
    }
    
    self.photoWages = self.PhotoModel.photoWages;
    self.photoWages2 = self.PhotoModel.photoWages2;
    self.photoWages3 = self.PhotoModel.photoWages3;
    self.photoWagesArr = [NSMutableArray array];
    if (self.photoWages.length == 0 || [self.photoWages isEqualToString:@""] || self.photoWages == nil || self.photoWages == NULL || [self.photoWages isEqual:[NSNull null]] || [self.photoWages isEqualToString:@"(null)"] || [self.photoWages isEqualToString:@"null"]) {
        
    } else {
        [self.photoWagesArr addObject:self.photoWages];
    }
    if (self.photoWages2.length == 0 || [self.photoWages2 isEqualToString:@""] || self.photoWages2 == nil || self.photoWages2 == NULL || [self.photoWages2 isEqual:[NSNull null]] || [self.photoWages2 isEqualToString:@"(null)"] || [self.photoWages2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWagesArr addObject:self.photoWages2];
    }
    if (self.photoWages3.length == 0 || [self.photoWages3 isEqualToString:@""] || self.photoWages3 == nil || self.photoWages3 == NULL || [self.photoWages3 isEqual:[NSNull null]] || [self.photoWages3 isEqualToString:@"(null)"] || [self.photoWages3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoWagesArr addObject:self.photoWages3];
    }
    
    
    self.photoOther = self.PhotoModel.photoOther;
    self.photoOther2 = self.PhotoModel.photoOther2;
    self.photoOther3 = self.PhotoModel.photoOther3;
    self.photoOtherArr = [NSMutableArray array];
    if (self.photoOther.length == 0 || [self.photoOther isEqualToString:@""] || self.photoOther == nil || self.photoOther == NULL || [self.photoOther isEqual:[NSNull null]] || [self.photoOther isEqualToString:@"(null)"] || [self.photoOther isEqualToString:@"null"]) {
        
    } else {
        [self.photoOtherArr addObject:self.photoOther];
    }
    if (self.photoOther2.length == 0 || [self.photoOther2 isEqualToString:@""] || self.photoOther2 == nil || self.photoOther2 == NULL || [self.photoOther2 isEqual:[NSNull null]] || [self.photoOther2 isEqualToString:@"(null)"] || [self.photoOther2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoOtherArr addObject:self.photoOther2];
    }
    if (self.photoOther3.length == 0 || [self.photoOther3 isEqualToString:@""] || self.photoOther3 == nil || self.photoOther3 == NULL || [self.photoOther3 isEqual:[NSNull null]] || [self.photoOther3 isEqualToString:@"(null)"] || [self.photoOther3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoOtherArr addObject:self.photoOther3];
    }
    
    self.photoCredit = self.PhotoModel.photoCredit;
    self.photoCredit2 = self.PhotoModel.photoCredit2;
    self.photoCredit3 = self.PhotoModel.photoCredit3;
    self.photoCredit4 = self.PhotoModel.photoCredit4;
    self.photoCredit5 = self.PhotoModel.photoCredit5;
    self.photoCredit6 = self.PhotoModel.photoCredit6;
    self.photoCredit7 = self.PhotoModel.photoCredit7;
    self.photoCredit8 = self.PhotoModel.photoCredit8;
    self.photoCredit9 = self.PhotoModel.photoCredit9;
    self.photoCredit10 = self.PhotoModel.photoCredit10;
    
    self.photoCreditArr = [NSMutableArray array];
    if (self.photoCredit.length == 0 || [self.photoCredit isEqualToString:@""] || self.photoCredit == nil || self.photoCredit == NULL || [self.photoCredit isEqual:[NSNull null]] || [self.photoCredit isEqualToString:@"(null)"] || [self.photoCredit isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit];
    }
    if (self.photoCredit2.length == 0 || [self.photoCredit2 isEqualToString:@""] || self.photoCredit2 == nil || self.photoCredit2 == NULL || [self.photoCredit2 isEqual:[NSNull null]] || [self.photoCredit2 isEqualToString:@"(null)"] || [self.photoCredit2 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit2];
    }
    if (self.photoCredit3.length == 0 || [self.photoCredit3 isEqualToString:@""] || self.photoCredit3 == nil || self.photoCredit3 == NULL || [self.photoCredit3 isEqual:[NSNull null]] || [self.photoCredit3 isEqualToString:@"(null)"] || [self.photoCredit3 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit3];
    }
    if (self.photoCredit4.length == 0 || [self.photoCredit4 isEqualToString:@""] || self.photoCredit4 == nil || self.photoCredit4 == NULL || [self.photoCredit4 isEqual:[NSNull null]] || [self.photoCredit4 isEqualToString:@"(null)"] || [self.photoCredit4 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit4];
    }
    if (self.photoCredit5.length == 0 || [self.photoCredit5 isEqualToString:@""] || self.photoCredit5 == nil || self.photoCredit5 == NULL || [self.photoCredit5 isEqual:[NSNull null]] || [self.photoCredit5 isEqualToString:@"(null)"] || [self.photoCredit5 isEqualToString:@"null"]) {
        
    } else {
        [self.photoCreditArr addObject:self.photoCredit5];
    }
    if (![Utils isBlankString:self.photoCredit6]) {
        [self.photoCreditArr addObject:self.photoCredit6];
    }
    if (![Utils isBlankString:self.photoCredit7]) {
        [self.photoCreditArr addObject:self.photoCredit7];
    }
    if (![Utils isBlankString:self.photoCredit8]) {
        [self.photoCreditArr addObject:self.photoCredit8];
    }
    if (![Utils isBlankString:self.photoCredit9]) {
        [self.photoCreditArr addObject:self.photoCredit9];
    }
    if (![Utils isBlankString:self.photoCredit10]) {
        [self.photoCreditArr addObject:self.photoCredit10];
    }
}

#pragma mark --创建UI
-(void)creatUI{
    
    /******上部的按钮******/
    NSArray * titleArray  = @[@"----",@"----",@"----",@"----",@"----",@"----"];
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(40, NaviHeight, kScreenWidth-80, 40)];
    //按钮的间距和宽度和高度
    CGFloat kBtnSpace = 0;
    CGFloat kBtnWidth = (kScreenWidth-80-kBtnSpace*(titleArray.count))/titleArray.count;
    CGFloat kBtnHeight = self.topView.bounds.size.height;
    //循环创建按钮
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kBtnSpace+ i*(kBtnWidth+kBtnSpace), 0, kBtnWidth, kBtnHeight)];
        btn.backgroundColor = VIEW_BASE_COLOR;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置选中状态的文字颜色
        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateSelected];
        btn.tag = 100+i;
        // btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn addTarget:self action:@selector(BtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
            _lastBtnTag = i+100;
        }
        [self.topView addSubview:btn];
    }
    
    [self.view addSubview:self.topView];
    
    
    /******下部的按钮******/
    NSArray * titlesArray = @[@"上一步",@"下一步"];
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2, self.bottomView.bounds.size.width)];
    self.backgroundView.backgroundColor = TABBAR_BASE_COLOR;
    [self.bottomView addSubview:self.backgroundView];
    
    CGFloat BtnWidth = kScreenWidth/titlesArray.count;
    CGFloat BtnHeight = self.bottomView.bounds.size.height;
    
    for (int i = 0; i < titlesArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(i*BtnWidth, 0, BtnWidth, BtnHeight)];
        btn.backgroundColor = [UIColor clearColor];
        
        [btn setTitle:titlesArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [btn setTitleColor:TABBAR_BASE_COLOR forState:UIControlStateNormal];
        //设置选中状态的文字颜色
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.tag = 200+i;
        
        [btn addTarget:self action:@selector(BtnsClick:) forControlEvents:UIControlEventTouchDown];
        if (i == 0) {
            btn.selected = YES;
            _lastTag = i+200;
        }
        [self.bottomView addSubview:btn];
        
    }
    [self.view addSubview:self.bottomView];
    self.bottomView.userInteractionEnabled = YES;
    
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, NaviHeight, 40, 40)];
    _leftImageView.backgroundColor = VIEW_BASE_COLOR;
    _leftImageView.image = [UIImage imageNamed:@"矢量智能对象"];
    _leftImageView.tag = 10;
    
    [self.view addSubview:_leftImageView];
    
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-40, NaviHeight, 40, 40)];
    _rightImageView.image = [UIImage imageNamed:@"矢量智能对象@2x_53"];
    _rightImageView.backgroundColor = VIEW_BASE_COLOR;
    [self.view addSubview:_rightImageView];
    
    /******主视图******/
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight+40, kScreenWidth, kScreenHeight-NaviHeight-40-50)];
    _mainScrollView.pagingEnabled = YES;
    //设置内容视图的大小
    _mainScrollView.contentSize = CGSizeMake(6*kScreenWidth, kScreenHeight-NaviHeight-40-50);
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    _mainScrollView.delegate = self;
    
    [self.view addSubview:_mainScrollView];
    
    /*****添加子视图*****/
    [self addChildView];
    
    
}

#pragma mark --添加子TableView
-(void)addChildView{
    //个人服务申请表
    _psTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-NaviHeight-40-50) style:UITableViewStylePlain];
    _psTableView.separatorColor = GRAY229;
    _psTableView.delegate=self;
    _psTableView.dataSource = self;
    _psTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mainScrollView addSubview:_psTableView];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_psTableView setTableFooterView:view];
    _psTableView.tag = 100;
    [_psTableView registerNib:[UINib nibWithNibName:@"PersonServiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonServiceID"];
    
    //个人信息
    _personalInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*1, 0, kScreenWidth, kScreenHeight-NaviHeight-40-50) style:UITableViewStylePlain];
    _personalInfoTableView.delegate=self;
    _personalInfoTableView.separatorColor = GRAY229;
    _personalInfoTableView.dataSource = self;
    _personalInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mainScrollView addSubview:_personalInfoTableView];
    _personalInfoTableView.tag =101;
    [_personalInfoTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextViewCellID"];
    [_personalInfoTableView registerNib:[UINib nibWithNibName:@"TimeButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TimeButtonCellID"];
    [_personalInfoTableView registerNib:[UINib nibWithNibName:@"AddressButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddressButtonCellID"];
    [_personalInfoTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsModelID"];
    [_personalInfoTableView registerNib:[UINib nibWithNibName:@"PersonServiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonServiceID"];
    
    
    
    //资产信息
    _assetInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight-NaviHeight-40-50) style:UITableViewStylePlain];
    _assetInfoTableView.separatorColor = GRAY229;
    _assetInfoTableView.delegate=self;
    _assetInfoTableView.dataSource = self;
    _assetInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mainScrollView addSubview:_assetInfoTableView];
    _assetInfoTableView.tag = 102;
    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TwoLabelCellID"];
    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextViewCellID"];
    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"TimeButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TimeButtonCellID"];
    [_assetInfoTableView registerNib:[UINib nibWithNibName:@"AddressButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddressButtonCellID"];
    [_assetInfoTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsModelID"];
    
    //工作信息
    _workInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight-NaviHeight-40-50) style:UITableViewStylePlain];
    _workInfoTableView.separatorColor = GRAY229;
    _workInfoTableView.delegate=self;
    _workInfoTableView.dataSource = self;
    _workInfoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mainScrollView addSubview:_workInfoTableView];
    _workInfoTableView.tag = 103;
    [_workInfoTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextViewCellID"];
    [_workInfoTableView registerNib:[UINib nibWithNibName:@"PersonServiceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonServiceCellId"];
    [_workInfoTableView registerNib:[UINib nibWithNibName:@"TimeButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TimeButtonCellID"];
    [_workInfoTableView registerNib:[UINib nibWithNibName:@"AddressButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AddressButtonCellID"];
    [_workInfoTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsModelID"];
    
    //联系人信息
    _cpiTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*4, 0, kScreenWidth, kScreenHeight-NaviHeight-40-50) style:UITableViewStylePlain];
    _cpiTableView.separatorColor = GRAY229;
    _cpiTableView.delegate = self;
    _cpiTableView.dataSource = self;
    [self.mainScrollView addSubview:_cpiTableView];
    _cpiTableView.tag = 104;
    [_cpiTableView registerNib:[UINib nibWithNibName:@"LevelOneCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LevelOneCellID"];
    [_cpiTableView registerNib:[UINib nibWithNibName:@"LevelTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LevelTwoCellID"];
    [_cpiTableView registerNib:[UINib nibWithNibName:@"LongLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LongLabelCellID"];
    [_cpiTableView registerNib:[UINib nibWithNibName:@"PersonInfoTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonInfoTextViewCellID"];
    [_cpiTableView registerClass:[ButtonsCell class] forCellReuseIdentifier:@"ButtonsCellID"];
    [_cpiTableView registerNib:[UINib nibWithNibName:@"RedLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RedLabelCellID"];
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor clearColor];
    [_cpiTableView setTableFooterView:view2];
    
    //材料上传
    _photosTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth*5, 0, kScreenWidth, kScreenHeight-NaviHeight-40-50) style:UITableViewStyleGrouped];
    _photosTableView.separatorColor = GRAY229;
    _photosTableView.delegate = self;
    _photosTableView.dataSource = self;
    [self.mainScrollView addSubview:_photosTableView];
    _photosTableView.tag = 105;
    [_materialUpTableView registerNib:[UINib nibWithNibName:@"UpOneButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpOneButtonCellID"];
    [_materialUpTableView registerNib:[UINib nibWithNibName:@"UpTwoButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpTwoButtonCellID"];
    
}

#pragma mark --TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == 100) {
        return 1;
    }else if (tableView.tag == 101){
        return 1;
    }else if (tableView.tag == 102){
        return 1;
    }else if (tableView.tag == 103){
        return 1;
    }else if (tableView.tag == 104){
        return 1;
    }else if (tableView.tag == 105){
        
        return 8;
    }
    
    else{
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 100) {
        return 3;
    }else if (tableView.tag == 101){
        return 21;
    }else if (tableView.tag == 102){
        return 15;
    }else if (tableView.tag == 103){
        return 12;
    }else if (tableView.tag == 104){
        
        return self.displayArray.count;
        
    }else if (tableView.tag == 105){
        return 1;
    }
    
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 105) {
        return 25;
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView.tag == 105) {
        if (section == 7) {
            return 0.1;
        }else{
            return 5;
        }
        
    }else{
        return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
#pragma mark 个人服务申请表
    /******个人服务申请表******/
    if (tableView.tag == 100) {
        if (indexPath.section == 0 && indexPath.row == 0) {//申请的贷款额度
            
            PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.leftLabel.text = _leftDataArray[indexPath.row];
            
            cell.rightLabel.text = _rightDataArray[indexPath.row];
            
            cell.centerTextView.tag = 1000;
            cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
            
        }else if (indexPath.section == 0 && indexPath.row == 1){//申请的期限
            
            PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.leftLabel.text = _leftDataArray[indexPath.row];
            
            cell.rightLabel.text = _rightDataArray[indexPath.row];
            
            cell.centerTextView.tag = 1001;
            cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            
            return cell;
        }else if (indexPath.section == 0 && indexPath.row == 2){//月还款额
            
            PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.leftLabel.text = _leftDataArray[indexPath.row];
            
            cell.rightLabel.text = _rightDataArray[indexPath.row];
            
            cell.centerTextView.tag = 1002;
            cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            
            return cell;
        }
    }
    
#pragma mark 个人信息
    /******个人信息******/
    else if (tableView.tag == 101){
        
        if (indexPath.section == 0 && indexPath.row == 0) {  //姓名
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1003;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"xingming"];
            
            return cell;
            
        }else if (indexPath.row == 1){// 性别
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            ButtonsModel * nodeData = _buttonArrayOne[0];
            
            if (nodeData.BtnArr.count != 0) {
                
                for (UIButton *btn in [cell subviews]) {
                    
                    [btn removeFromSuperview];
                }
            }
            
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            
            if ([nodeData.name isEqualToString:@"性        别"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+10;
                    if (nodeData.index == i+10) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:[NSString stringWithFormat:@" %@",nodeData.BtnArr[i]] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+2*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(26);
                        
                    }];
                }
            }
            
            return cell;
            
        }
        else if (indexPath.row == 2){//移动电话
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1004;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"dianhua"];
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        }else if (indexPath.row == 3){//证件类型
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            ButtonsModel * nodeData = _buttonArrayOne[1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"证件类型"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+20;
                    if (nodeData.index == i+20) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(26);
                        
                    }];
                }
            }
            return cell;
            
        }
        else if (indexPath.row == 4){//证件号码
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1005;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"zhengjian"];
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        }else if (indexPath.row == 5){//婚姻状况
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            ButtonsModel * nodeData = _buttonArrayOne[2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"婚姻状况"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+30;
                    if (nodeData.index == i+30) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(26);
                        
                    }];
                }
            }
            return cell;
            
        }
        else if (indexPath.row == 6){//子 女
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            ButtonsModel * nodeData = _buttonArrayOne[3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"子       女"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+40;
                    if (nodeData.index == i+40) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((50*KAdaptiveRateWidth+2*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(26);
                        
                    }];
                }
            }
            return cell;
            
        }else if (indexPath.row == 7){//最高学历
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            ButtonsModel * nodeData = _buttonArrayOne[4];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"最高学历"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+50;
                    if (nodeData.index == i+50) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+10*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((25)*(i/2)+10);
                        
                        make.height.mas_equalTo(26);
                        
                    }];
                }
            }
            return cell;
        }
        else if (indexPath.row == 8){//QQ
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1006;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"qq"];
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        }else if (indexPath.row == 9){//邮箱
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1007;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"youxiang"];
            cell.personInfoTextView.keyboardType = UIKeyboardTypeEmailAddress;
            return cell;
        }else if (indexPath.row == 10){//户口所在地
            
            AddressButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.addressLabel.text = _personalInfo[indexPath.row];
            
            cell.addressButton.tag = indexPath.row;
            
            [cell.addressButton addTarget:self action:@selector(AddressChooseOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addressButton setTitle:returnAddressOne forState:UIControlStateNormal];
            [cell.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            return cell;
        }else if (indexPath.row == 11){//户口详细地址
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1008;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"hukoudizhi"];
            return cell;
        }else if (indexPath.row == 12){//户口邮政编码
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1009;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"hukouyoubian"];
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        }else if (indexPath.row == 13){//现住宅地址
            
            AddressButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.addressLabel.text = _personalInfo[indexPath.row];
            
            cell.addressButton.tag = indexPath.row;
            
            [cell.addressButton addTarget:self action:@selector(AddressChooseOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addressButton setTitle:returnAddressTwo forState:UIControlStateNormal];
            [cell.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            return cell;
        }else if (indexPath.row == 14){//住宅详细地址
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1010;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"zhuzhaidizhi"];
            return cell;
        }else if (indexPath.row == 15){//住宅邮政编码
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1011;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"zhuzhaiyoubian"];
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        }else if (indexPath.row == 16){//现住宅类型
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            ButtonsModel * nodeData = _buttonArrayOne[5];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"现住宅类型"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+60;
                    if (nodeData.index == i+60) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(GRBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((100*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%2)+10*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((21)*(i/2)+9);
                        make.height.mas_equalTo(22);
                    }];
                }
            }
            return cell;
        }else if (indexPath.row == 17){
            ButtonsModel * model = _buttonArrayOne[5];
            
            if (model.index == 60 ) {
                
                PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
                
                cell.leftLabel.text = self.GRName;
                
                cell.rightLabel.text = @"元";
                
                cell.centerTextView.tag = 1050;
                
                cell.centerTextView.delegate = self;
                cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.centerTextView.text = self.dataDic[@"zuyong"];
                
                return cell;
            }
            else if (model.index == 61) {
                PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
                
                cell.leftLabel.text = self.GRName;
                
                cell.rightLabel.text = @"元";
                
                cell.centerTextView.tag = 1051;
                
                cell.centerTextView.delegate = self;
                cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.centerTextView.text = self.dataDic[@"zuyong"];
                return cell;
                
                
            }
            else if (model.index == 62) {
                PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceID"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
                
                cell.leftLabel.text = self.GRName;
                
                cell.rightLabel.text = @"元";
                
                cell.centerTextView.tag = 1052;
                
                cell.centerTextView.delegate = self;
                cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                cell.centerTextView.text = self.dataDic[@"zongyong"];
                return cell;
                
            }
            else if (model.index == 67) {
                
                PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
                
                cell.personInfoLabel.text = self.GRName;
                
                cell.personInfoTextView.tag = 1053;
                cell.personInfoTextView.delegate = self;
                cell.personInfoTextView.text = self.dataDic[@"qitazhuzhai"];
                
                return cell;
                
            }
        }
        else if (indexPath.row == 18){//住宅电话
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _personalInfo[indexPath.row];
            cell.personInfoTextView.tag = 1012;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.personInfoTextView.text = self.dataDic[@"zhuzhaidianhua"];
            
            return cell;
            
        }else if (indexPath.row == 19){//来本地时间
            
            TimeButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.timeLabel.text = _personalInfo[indexPath.row];
            
            cell.timeButton.tag = indexPath.row;
            [cell.timeButton addTarget:self action:@selector(timeChoiceOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.timeButton setTitle:returnTimeOne forState:UIControlStateNormal];
            
            return cell;
            
        }else if (indexPath.row == 20){//起始居住时间
            
            TimeButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.timeLabel.text = _personalInfo[indexPath.row];
            
            cell.timeButton.tag = indexPath.row;
            [cell.timeButton addTarget:self action:@selector(timeChoiceOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.timeButton setTitle:returnTimeTwo forState:UIControlStateNormal];
            
            return cell;
        }
    }
    
#pragma mark 资产信息
    /******资产信息******/
    else if (tableView.tag == 102){
        
        if (indexPath.row == 0) {//房产类型
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            ButtonsModel * nodeData = _buttonArrayTwo[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"房产类型"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+70;
                    if (nodeData.index == i+70) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(ZCBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+1*KAdaptiveRateWidth)*(i%3)+10*KAdaptiveRateWidth);
                        make.top.equalTo(cell.mas_top).offset((25)*(i/3)+2);
                        
                        make.height.mas_equalTo(22);
                    }];
                }
            }
            return cell;
            
        }else if (indexPath.row == 1){
            
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = self.ZCName;
            
            cell.personInfoTextView.tag = 1054;
            cell.personInfoTextView.delegate = self;
            
            cell.personInfoTextView.text = self.dataDic[@"qitafangchan"];
            
            return cell;
            
        }
        
        else if  (indexPath.row == 2) {//购买单价
            
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.rightLabel.text = @"元/㎡";
            
            cell.assetInfiTextView.tag = 1013;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"goumaidanjia"];
            
            return cell;
        }else if (indexPath.row == 3){//房产地址
            AddressButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.addressLabel.text = _assetInfo[indexPath.row];
            
            cell.addressButton.tag = indexPath.row;
            
            [cell.addressButton addTarget:self action:@selector(AddressChooseOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addressButton setTitle:returnAddressThree forState:UIControlStateNormal];
            [cell.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            return cell;
        }else if (indexPath.row == 5){//购买日期
            
            TimeButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.timeLabel.text = _assetInfo[indexPath.row];
            
            cell.timeButton.tag = indexPath.row;
            [cell.timeButton addTarget:self action:@selector(timeChoiceOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.timeButton setTitle:returnTimeThree forState:UIControlStateNormal];
            
            return cell;
        }
        else if (indexPath.row == 6){//建筑面积
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.rightLabel.text = @"元/㎡";
            
            cell.assetInfiTextView.tag = 1014;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"jianzhumianji"];
            return cell;
            
        }else if (indexPath.row == 7){//产权比例
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.nameLabel.text = _assetInfo[indexPath.row];
            
            cell.assetInfiTextView.tag = 1015;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"chanquanbili"];
            cell.rightLabel.text = @"%";
            return cell;
            
        }
        else if (indexPath.row == 8){//贷款年限
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.rightLabel.text = @"年";
            
            cell.assetInfiTextView.tag = 1016;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"daikuannianxian"];
            return cell;
            
        }
        else if (indexPath.row == 9){//月供
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            cell.rightLabel.text = @"元";
            
            cell.assetInfiTextView.tag = 1017;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"yuegong"];
            return cell;
            
        }
        else if (indexPath.row == 10){//贷款余额
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.rightLabel.text = @"万元";
            
            cell.assetInfiTextView.tag = 1018;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"daikuanyue"];
            return cell;
            
        }else if (indexPath.row == 12){//购买价格
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.rightLabel.text = @"万元";
            
            cell.assetInfiTextView.tag = 1019;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"goumaijiage"];
            return cell;
            
        }else if (indexPath.row == 13){//月供贷款
            TwoLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLabelCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.assetInfiTextView.tintColor = TABBAR_BASE_COLOR;
            cell.nameLabel.text = _assetInfo[indexPath.row];
            cell.rightLabel.text = @"元";
            
            cell.assetInfiTextView.tag = 1020;
            cell.assetInfiTextView.delegate = self;
            cell.assetInfiTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.assetInfiTextView.text = self.dataDic[@"yuegongdaikuan"];
            return cell;
            
        }else if (indexPath.row == 4){//房产详细地址
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            cell.personInfoLabel.text = _assetInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1021;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"fangchandizhi"];
            
            return cell;
        }else if (indexPath.row == 11){//车辆品牌
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _assetInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1022;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"cheliangpinpai"];
            
            return cell;
        }else if (indexPath.row == 14){//购买时间
            TimeButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.timeLabel.text = _assetInfo[indexPath.row];
            
            cell.timeButton.tag = indexPath.row;
            [cell.timeButton addTarget:self action:@selector(timeChoiceOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.timeButton setTitle:returnTimeFour forState:UIControlStateNormal];
            
            return cell;
        }
        
    }
#pragma mark 工作信息
    /******工作信息******/
    else if (tableView.tag == 103){
        if (indexPath.row == 0) {//单位名称
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _workInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1023;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"danweimingcheng"];
            
            return cell;
            
        }else if (indexPath.row == 1){//单位地址
            AddressButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.addressLabel.text = _workInfo[indexPath.row];
            
            cell.addressButton.tag = indexPath.row;
            
            [cell.addressButton addTarget:self action:@selector(AddressChooseOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.addressButton setTitle:returnAddressFour forState:UIControlStateNormal];
            [cell.addressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            return cell;
            
        }else if (indexPath.row == 2){//单位详细地址
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            
            cell.personInfoLabel.text = _workInfo[indexPath.row];
            cell.personInfoTextView.tag = 1024;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"danweidizhi"];
            
            return cell;
        }else if (indexPath.row == 3){//单位性质
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsModelID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsModelID"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            ButtonsModel * nodeData = _buttonArrayTree[0];
            
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"单位性质"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+80;
                    if (nodeData.index == i+80) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    //                    [btn addTarget:self action:@selector(SelectBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    if (i == 0) {
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(titleLB.mas_right).offset((90*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*(i%1)+10*KAdaptiveRateWidth);
                            make.top.equalTo(cell.mas_top).offset(6);
                            make.height.mas_equalTo(22);
                            
                        }];
                    } else {
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(titleLB.mas_right).offset((70*KAdaptiveRateWidth)*((i-1)%3)+10*KAdaptiveRateWidth);
                            make.top.equalTo(cell.mas_top).offset((21)*(((i-1)/3)+1)+6);
                            make.height.mas_equalTo(22);
                            
                        }];
                    }
                }
            }
            return cell;
            
        }
        else if (indexPath.row == 4){//所属行业
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            cell.personInfoLabel.text = _workInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1025;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"suoshuhangye"];
            
            return cell;
        }
        else if (indexPath.row == 5){//单位电话
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            cell.personInfoLabel.text = _workInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1026;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.personInfoTextView.text = self.dataDic[@"danweidianhua"];
            
            return cell;
        }
        else if (indexPath.row == 6){//所属部门
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            cell.personInfoLabel.text = _workInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1027;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"suoshubumen"];
            
            return cell;
        }else if (indexPath.row == 7){//担任职位
            PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.personInfoTextView.tintColor = TABBAR_BASE_COLOR;
            cell.personInfoLabel.text = _workInfo[indexPath.row];
            
            cell.personInfoTextView.tag = 1028;
            cell.personInfoTextView.delegate = self;
            cell.personInfoTextView.text = self.dataDic[@"danrenzhiwei"];
            
            return cell;
        }else if (indexPath.row == 8){//入职时间
            TimeButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TimeButtonCellID"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.timeLabel.text = _workInfo[indexPath.row];
            
            cell.timeButton.tag = indexPath.row;
            [cell.timeButton addTarget:self action:@selector(timeChoiceOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.timeButton setTitle:returnTimeFive forState:UIControlStateNormal];
            
            return cell;
            
            
        }else if (indexPath.row == 9){//月总收入
            
            PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
            cell.leftLabel.text = _workInfo[indexPath.row];
            
            cell.centerTextView.tag = 1029;
            cell.centerTextView.delegate = self;
            cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.centerTextView.text = self.dataDic[@"yuezongshouru"];
            cell.rightLabel.text = @"元";
            
            return cell;
        }else if (indexPath.row == 10){//发薪日
            
            PersonServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonServiceCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.centerTextView.tintColor = TABBAR_BASE_COLOR;
            cell.leftLabel.text = _workInfo[indexPath.row];
            cell.rightLabel.text = @"日";
            
            cell.centerTextView.tag = 1030;
            cell.centerTextView.delegate = self;
            cell.centerTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            cell.centerTextView.text = self.dataDic[@"faxinri"];
            
            
            return cell;
        }else if (indexPath.row == 11){//发薪形式
            
            ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsID"];
            if (cell == nil) {
                cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsID"];
            }
            ButtonsModel * nodeData = _buttonArrayTree[1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (nodeData.BtnArr.count != 0) {
                for (UIButton *btn in [cell subviews]) {
                    [btn removeFromSuperview];
                }
            }
            UILabel *titleLB = [[UILabel alloc] init];
            titleLB.textColor = [UIColor blackColor];
            titleLB.font = [UIFont systemFontOfSize:16];
            titleLB.textColor = GRAY90;
            [cell addSubview:titleLB];
            [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(18);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.mas_equalTo(17);
            }];
            titleLB.text = nodeData.name;
            if ([nodeData.name isEqualToString:@"发薪形式"]) {
                for (int i=0; i<nodeData.BtnArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = i+90;
                    if (nodeData.index == i+90) {
                        btn.selected = YES;
                    }
                    [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                    [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+10*KAdaptiveRateWidth)*i+10*KAdaptiveRateWidth);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.mas_equalTo(22);
                        
                    }];
                }
            }
            return cell;
            
        }
        
    }
#pragma mark 联系人信息
    /******联系人信息******/
    else if (tableView.tag == 104){
        
        if (indexPath.section == 0) {
            CPITreeViewNode * node = [_displayArray objectAtIndex:indexPath.row];
            if (node.type == 1) {
                LevelOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelOneCellID"];
                
                cell.node = node;
                [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
                [cell setNeedsDisplay]; //重新描绘cell
                
                return cell;
            }else if (node.type == 2){
                
                LevelTwoModel *nodeData = node.nodeData;
                
                if ([nodeData.num isEqualToString:@"1"]) {
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    
                    cell.rightTextView.tag = 1031;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"peiouxingming"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"2"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1032;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    cell.rightTextView.text = self.dataDic[@"peioushenfen"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"3"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1033;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    cell.rightTextView.text = self.dataDic[@"peioudianhua"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"4"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1034;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"peioudanwei"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"5"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1035;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"peioudanweidizhi"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"6"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1036;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    cell.rightTextView.text = self.dataDic[@"peioudanweidianhua"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"7"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1037;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"peioujuzhudizhi"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"8"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1038;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"qinshuxingming"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"9"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1039;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"qinshuguanxi"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"10"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1040;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    cell.rightTextView.text = self.dataDic[@"qinshudianhua"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"11"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1041;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"qinshudanwei"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"12"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1042;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"tongshixingming"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"13"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1043;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"tongshizhiwu"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"14"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1044;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    cell.rightTextView.text = self.dataDic[@"tongshidianhua"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"15"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1045;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"tongshidanwei"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"16"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1046;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"qitaxingming"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"17"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1047;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"qitaguanxi"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"18"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1048;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    cell.rightTextView.text = self.dataDic[@"qitadianhua"];
                    
                    return cell;
                }else if ([nodeData.num isEqualToString:@"19"]){
                    LevelTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LevelTwoCellID"];
                    cell.nameLabel.text = nodeData.nameString;
                    cell.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.backgroundColor = VIEW_BASE_COLOR;
                    cell.rightTextView.tintColor = TABBAR_BASE_COLOR;
                    cell.rightTextView.tag = 1049;
                    cell.rightTextView.delegate = self;
                    cell.rightTextView.text = self.dataDic[@"qitadanwei"];
                    
                    return cell;
                }
                
                
            }else if (node.type == 3){
                
                LongLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LongLabelCellID"];
                
                
                cell.node = node;
                
                [self loadDataForTreeViewCell:cell with:node];
                [cell setNeedsDisplay];
                
                return cell;
                
            }else if (node.type == 4){
                PersonInfoTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInfoTextViewCellID"];
                
                cell.node = node;
                [self loadDataForTreeViewCell:cell with:node];
                [cell setNeedsDisplay];
                
                return cell;
            }else if (node.type == 5){
                
                ButtonsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonsCellID"];
                if (cell == nil) {
                    cell = [[ButtonsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonsCellID"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *separator = [[UIView alloc]init];
                separator.backgroundColor = VIEW_BASE_COLOR;
                [cell addSubview:separator];
                [separator mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.mas_left).offset(10);
                    make.right.equalTo(cell.mas_right).offset(0);
                    make.bottom.equalTo(cell.mas_bottom).offset(-0.2);
                    make.height.mas_equalTo(0.2);
                }];
                
                cell.node = node;
                
                ButtonsModel * nodeData = node.nodeData;
                //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (nodeData.BtnArr.count != 0) {
                    for (UIButton *btn in [cell subviews]) {
                        [btn removeFromSuperview];
                    }
                }
                UILabel *titleLB = [[UILabel alloc] init];
                titleLB.textColor = [UIColor blackColor];
                titleLB.font = [UIFont systemFontOfSize:16];
                titleLB.textColor = GRAY90;
                [cell addSubview:titleLB];
                [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.mas_left).offset(18);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                    make.height.mas_equalTo(17);
                }];
                titleLB.text = nodeData.name;
                if ([nodeData.name isEqualToString:@"贷款用途"]) {
                    for (int i=0; i<nodeData.BtnArr.count; i++) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.tag = i+95;
                        if (nodeData.index == i+95) {
                            btn.selected = YES;
                        }
                        [btn setImage:[UIImage imageNamed:@"单选框1"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"单选框1（亮）"] forState:UIControlStateSelected];
                        [btn setTitle:nodeData.BtnArr[i] forState:UIControlStateNormal];
                        [btn setTitleColor:GRAY90 forState:UIControlStateNormal];
                        btn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [btn addTarget:self action:@selector(SelectBtnsOnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(titleLB.mas_right).offset((60*KAdaptiveRateWidth+5*KAdaptiveRateWidth)*i+5*KAdaptiveRateWidth);
                            make.centerY.mas_equalTo(cell.mas_centerY);
                            make.height.mas_equalTo(22);
                            
                        }];
                    }
                }
                return cell;
                
            }
            else if (node.type == 6){
                RedLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RedLabelCellID"];
                
                cell.node = node;
                [self loadDataForTreeViewCell:cell with:node];
                [cell setNeedsDisplay];
                
                return cell;
            }
        }
    }
#pragma mark 材料上传
    /******材料上传******/
    else if (tableView.tag == 105){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIButton *btn in [cell subviews]) {
            [btn removeFromSuperview];
        }
        for (UILabel *title in [cell subviews]) {
            [title removeFromSuperview];
        }
        if (indexPath.section == 0) {
            for (int i=0; i<2; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 1000+i;
                
//                [btn setImage:[UIImage imageNamed:@"IconHome@2x.png"] forState:UIControlStateNormal];//给button添加image
//                btn.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,btn.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//                
//                [btn setTitle:@"首页" forState:UIControlStateNormal];//设置button的title
//                btn.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
//                btn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
//                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
//                btn.titleEdgeInsets = UIEdgeInsetsMake(71, -btn.titleLabel.bounds.size.width-50, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
                
                //    [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
                
                
                //   button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
                
                
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(10);
                    make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                UILabel *title = [[UILabel alloc] init];
                [cell addSubview:title];
                title.textAlignment = NSTextAlignmentCenter;
                title.font = [UIFont systemFontOfSize:12];
                [title mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn.mas_bottom).offset(5);
                    make.left.equalTo(cell.mas_left).offset(6+i*(62));
                    make.width.mas_equalTo(62);
                    make.height.mas_equalTo(15);
                }];
                
                if (i == 0) {
                    if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
                        
                    } else {
                        [btn sd_setBackgroundImageWithURL:[self.photoIdFront convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                        if (self.isUpdateCRM) {
                            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            deleteBtn.tag = i+10000;
                            [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                            [btn addSubview:deleteBtn];
                            
                            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(btn.mas_top).offset(0);
                                make.right.equalTo(btn.mas_right).offset(0);
                                make.height.mas_equalTo(20);
                                make.width.mas_equalTo(20);
                            }];
                        }
                    }
                    title.text = @"身份证正面";
                } else if (i == 1) {
                    if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
                    } else {
                        [btn sd_setBackgroundImageWithURL:[self.photoIdBack convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                        if (self.isUpdateCRM) {
                            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                            deleteBtn.tag = i+10000;
                            [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                            [btn addSubview:deleteBtn];
                            [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.top.equalTo(btn.mas_top).offset(0);
                                make.right.equalTo(btn.mas_right).offset(0);
                                make.height.mas_equalTo(20);
                                make.width.mas_equalTo(20);
                            }];
                        }
                    }
                    title.text = @"身份证反面";
                }
            }
        } else if (indexPath.section == 1) {
            
            if (self.photoRegistArr.count == 3) {
                for (int i=0; i<self.photoRegistArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 2000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoRegistArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+20000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoRegistArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 2000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoRegistArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+20000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 2000+self.photoRegistArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoRegistArr.count*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }else if (indexPath.section == 2) {
            
            if (self.photoHouseArr.count == 3) {
                for (int i=0; i<self.photoHouseArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 3000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoHouseArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+30000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoHouseArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 3000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoHouseArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+30000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 3000+self.photoHouseArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoHouseArr.count*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }else if (indexPath.section == 3) {
            
            if (self.photoMarryArr.count == 3) {
                for (int i=0; i<self.photoMarryArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 4000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoMarryArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+40000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoMarryArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 4000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoMarryArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+40000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 4000+self.photoMarryArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoMarryArr.count*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }else if (indexPath.section == 4) {
            
            if (self.photoWorkArr.count == 3) {
                for (int i=0; i<self.photoWorkArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 5000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoWorkArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+50000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoWorkArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 5000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoWorkArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+50000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 5000+self.photoWorkArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoWorkArr.count*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }else if (indexPath.section == 5) {
            
            if (self.photoWagesArr.count == 3) {
                for (int i=0; i<self.photoWagesArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 6000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoWagesArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+60000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoWagesArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 6000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoWagesArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+60000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 6000+self.photoWagesArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoWagesArr.count*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }else if (indexPath.section == 6) {
            
            if (self.photoCreditArr.count == 10) {
                for (int i=0; i<self.photoCreditArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 7000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (60)+15);
                        make.left.equalTo(cell.mas_left).offset(12+i%5*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoCreditArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+70000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoCreditArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 7000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).offset(i/5 * (60)+15);
                        make.left.equalTo(cell.mas_left).offset(12+i%5*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoCreditArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+70000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 7000+self.photoCreditArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(self.photoCreditArr.count/5 * (60)+15);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoCreditArr.count%5*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }else if (indexPath.section == 7) {
            
            if (self.photoOtherArr.count == 3) {
                for (int i=0; i<self.photoOtherArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 8000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoOtherArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+80000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
            } else {
                for (int i=0; i<self.photoOtherArr.count; i++) {
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.tag = 8000+i;
                    [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:btn];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.left.equalTo(cell.mas_left).offset(12+i*(50+12));
                        make.width.mas_equalTo(50);
                        make.height.mas_equalTo(50);
                    }];
                    btn.layer.masksToBounds = YES;
                    btn.layer.cornerRadius = 5;
                    [btn sd_setBackgroundImageWithURL:[self.photoOtherArr[i] convertHostUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"选择人员（小头像）"]];
                    if (self.isUpdateCRM) {
                        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        deleteBtn.tag = i+80000;
                        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        [btn addSubview:deleteBtn];
                        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(btn.mas_top).offset(0);
                            make.right.equalTo(btn.mas_right).offset(0);
                            make.height.mas_equalTo(20);
                            make.width.mas_equalTo(20);
                        }];
                    }
                }
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = 8000+self.photoOtherArr.count;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.left.equalTo(cell.mas_left).offset(12+self.photoOtherArr.count*(50+12));
                    make.width.mas_equalTo(50);
                    make.height.mas_equalTo(50);
                }];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;
                [btn setBackgroundImage:[UIImage imageNamed:@"增加群聊（大加）"] forState:UIControlStateNormal];
            }
            
        }
        return cell;
    }
    
    return cell;
    
}

- (void)BtnClick:(UIButton *)sender {
    self.whicthCell = [sender superview];
    if (self.isUpdateCRM) {
        self.whitchBtn = sender.tag;
        if (sender.tag == 1000) {
            if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
                [action showInView:self.navigationController.view];
            } else {
                //                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
                //                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                // /mechpro/mpro1474271889948.jpg
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdFront];
                
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                browserVc.isIDBack = NO;
                [browserVc show];
            }
        } else if (sender.tag == 1001) {
            if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
                [action showInView:self.navigationController.view];
            } else {
                //                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
                //                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdBack];
                browserVc.isIDBack = YES;
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else {
            switch (sender.tag/1000) {
                case 2:
                {
                    NSInteger index = sender.tag%2000;
                    [self photoActionWithNSMutableArr:self.photoRegistArr index:index];
                }
                    break;
                case 3:
                {
                    NSInteger index = sender.tag%3000;
                    [self photoActionWithNSMutableArr:self.photoHouseArr index:index];
                }
                    break;
                case 4:
                {
                    NSInteger index = sender.tag%4000;
                    [self photoActionWithNSMutableArr:self.photoMarryArr index:index];
                }
                    break;
                case 5:
                {
                    NSInteger index = sender.tag%5000;
                    [self photoActionWithNSMutableArr:self.photoWorkArr index:index];
                }
                    break;
                case 6:
                {
                    NSInteger index = sender.tag%6000;
                    [self photoActionWithNSMutableArr:self.photoWagesArr index:index];
                }
                    break;
                case 7:
                {
                    NSInteger index = sender.tag%7000;
                    [self photoActionWithNSMutableArr:self.photoCreditArr index:index];
                }
                    break;
                case 8:
                {
                    NSInteger index = sender.tag%8000;
                    [self photoActionWithNSMutableArr:self.photoOtherArr index:index];
                }
                    break;
                default:
                    break;
            }
        }
    } else {
        self.whitchBtn = sender.tag;
        if (sender.tag == 1000) {
            if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
            } else {
                //                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
                //                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdFront];
                browserVc.isIDBack = NO;
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else  if (sender.tag == 1001) {
            if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
            } else {
                //                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
                //                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = 1; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = @[self.photoIdBack];
                browserVc.isIDBack = YES;
                browserVc.currentPage = 0;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else {
            switch (sender.tag/1000) {
                case 2:
                {
                    NSInteger index = sender.tag%2000;
                    [self photoActionWithNSMutableArr:self.photoRegistArr index:index];
                }
                    break;
                case 3:
                {
                    NSInteger index = sender.tag%3000;
                    [self photoActionWithNSMutableArr:self.photoHouseArr index:index];
                }
                    break;
                case 4:
                {
                    NSInteger index = sender.tag%4000;
                    [self photoActionWithNSMutableArr:self.photoMarryArr index:index];
                }
                    break;
                case 5:
                {
                    NSInteger index = sender.tag%5000;
                    [self photoActionWithNSMutableArr:self.photoWorkArr index:index];
                }
                    break;
                case 6:
                {
                    NSInteger index = sender.tag%6000;
                    [self photoActionWithNSMutableArr:self.photoWagesArr index:index];
                }
                    break;
                case 7:
                {
                    NSInteger index = sender.tag%7000;
                    [self photoActionWithNSMutableArr:self.photoCreditArr index:index];
                }
                    break;
                case 8:
                {
                    NSInteger index = sender.tag%8000;
                    [self photoActionWithNSMutableArr:self.photoOtherArr index:index];
                }
                    break;
                default:
                    break;
            }
        }
    }
    
}


- (void)photoActionWithNSMutableArr:(NSMutableArray *)array index:(NSInteger)index {
    NSLog(@"array.count == %ld",array.count);
    if (self.isUpdateCRM) {
        if (array.count != 0) {
            if (index == array.count) {
                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
                [action showInView:self.navigationController.view];
            } else {
                //                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
                //                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = array.count; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = array;
                browserVc.isIDBack = NO;
                browserVc.currentPage = index;
                browserVc.delegate = self;
                [browserVc show];
            }
        } else {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
            [action showInView:self.navigationController.view];
        }
    } else {
        if (array.count != 0) {
            if (index == array.count) {
                
            } else {
                //                UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"浏览", nil];
                //                [action showInView:self.navigationController.view];
                //启动图片浏览器
                STPhotoBrowserController *browserVc = [[STPhotoBrowserController alloc] init];
                browserVc.sourceImagesContainerView = self.whicthCell; // 原图的父控件
                browserVc.countImage = array.count; // 图片总数
                
                self.currentView = self.whicthCell;
                self.currentArray = array;
                browserVc.isIDBack = NO;
                browserVc.currentPage = index;
                browserVc.delegate = self;
                [browserVc show];
            }
        }
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.whitchBtn == 1000) {
        if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
            if (buttonIndex == 0) {
                //拍照
                [self takePhone];
            } else if (buttonIndex == 1) {
                //从相册选取
                [self takeLocalPhoto];
                
            }
        } else {
            if (buttonIndex == 0) {
                
                //启动图片浏览器
                
                             
            }
        }
    } else if (self.whitchBtn == 1001) {
        if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
            if (buttonIndex == 0) {
                //拍照
                [self takePhone];
            } else if (buttonIndex == 1) {
                //从相册选取
                [self takeLocalPhoto];
            }
        } else {
            if (buttonIndex == 0) {
                //浏览照片
            }
        }
    } else {
        switch (self.whitchBtn/1000) {
            case 2:
            {
                NSInteger index = self.whitchBtn%2000;
                [self clickedButtonAtIndexWithArr:self.photoRegistArr index:index buttonIndex:buttonIndex whitchBtn:2];
            }
                break;
            case 3:
            {
                NSInteger index = self.whitchBtn%3000;
                [self clickedButtonAtIndexWithArr:self.photoHouseArr index:index buttonIndex:buttonIndex whitchBtn:3];
            }
                break;
            case 4:
            {
                NSInteger index = self.whitchBtn%4000;
                [self clickedButtonAtIndexWithArr:self.photoMarryArr index:index buttonIndex:buttonIndex whitchBtn:4];
            }
                break;
            case 5:
            {
                NSInteger index = self.whitchBtn%5000;
                [self clickedButtonAtIndexWithArr:self.photoWorkArr index:index buttonIndex:buttonIndex whitchBtn:5];
            }
                break;
            case 6:
            {
                NSInteger index = self.whitchBtn%6000;
                [self clickedButtonAtIndexWithArr:self.photoWagesArr index:index buttonIndex:buttonIndex whitchBtn:6];
            }
                break;
            case 7:
            {
                NSInteger index = self.whitchBtn%7000;
                [self clickedButtonAtIndexWithArr:self.photoCreditArr index:index buttonIndex:buttonIndex whitchBtn:7];
            }
                break;
            case 8:
            {
                NSInteger index = self.whitchBtn%8000;
                [self clickedButtonAtIndexWithArr:self.photoOtherArr index:index buttonIndex:buttonIndex whitchBtn:8];
            }
                break;
            default:
                break;
        }
    }
    
}
- (void)clickedButtonAtIndexWithArr:(NSMutableArray *)arr index:(NSInteger)index buttonIndex:(NSInteger)buttonIndex whitchBtn:(NSInteger)whitchBtn{
    if (arr.count != 0) {
        if (index == arr.count) {
            if (buttonIndex == 0) {
                //拍照
                [self takePhone];
            } else if (buttonIndex == 1) {
                //从相册选取
                [self takeLocalPhoto];
                
            }
        } else {
            if (buttonIndex == 0) {
                //启动图片浏览器
                
            }
        }
    } else {
        if (buttonIndex == 0) {
            //拍照
            [self takePhone];
        } else if (buttonIndex == 1) {
            //从相册选取
            [self takeLocalPhoto];
        }
    }
}


//打开照相机拍照
-(void)takePhone{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    //    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"打开了照相机");
    }];
}
//打开本地相册
-(void)takeLocalPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     };
    picker.navigationBar.titleTextAttributes = textAttributes;
    [picker.navigationBar setBarTintColor:kMyColor(29, 46, 55)];
    [picker.navigationBar setTranslucent:NO];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
        NSLog(@"打开了相册");
    }];
    
    
}

- (void)deleteBtnClick:(UIButton *)Btn {
    
    if (Btn.tag == 10000) {
        self.photoIdFront = @"";
    } else if (Btn.tag == 10001) {
        self.photoIdBack = @"";
    } else {
        switch (Btn.tag/10000) {
            case 2:
            {
                NSInteger index = Btn.tag%20000;
                [self.photoRegistArr removeObjectAtIndex:index];
            }
                break;
            case 3:
            {
                NSInteger index = Btn.tag%30000;
                [self.photoHouseArr removeObjectAtIndex:index];
            }
                break;
            case 4:
            {
                NSInteger index = Btn.tag%40000;
                [self.photoMarryArr removeObjectAtIndex:index];
            }
                break;
            case 5:
            {
                NSInteger index = Btn.tag%50000;
                [self.photoWorkArr removeObjectAtIndex:index];
            }
                break;
            case 6:
            {
                NSInteger index = Btn.tag%60000;
                [self.photoWagesArr removeObjectAtIndex:index];
            }
                break;
            case 7:
            {
                NSInteger index = Btn.tag%70000;
                [self.photoCreditArr removeObjectAtIndex:index];
            }
                break;
            case 8:
            {
                NSInteger index = Btn.tag%80000;
                [self.photoOtherArr removeObjectAtIndex:index];
            }
                break;
            default:
                break;
        }
    }
    [self.photosTableView reloadData];
    
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (navigationController.viewControllers.count == 3) {
        
        Method method = class_getInstanceMethod([self class], @selector(drawRect:));
        class_replaceMethod([[[[navigationController viewControllers][2].view subviews][1] subviews][0] class],@selector(drawRect:),method_getImplementation(method),method_getTypeEncoding(method));
    }
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextAddRect(ref, rect);
    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, 0, NO);
    [[UIColor colorWithRed:0 green:0 blue:0 alpha:0]setFill];
    CGContextDrawPath(ref, kCGPathEOFill);
    
    CGContextAddArc(ref, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2, arcWitch, 0, 0, NO);
    [[UIColor whiteColor]setStroke];
    CGContextStrokePath(ref);
}

#pragma mark -- UIImagePickerView

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    [HttpRequestEngine uploadImageData:[self getDataWitdImgae:image] fileName:@"front.jpg" completion:^(id obj, NSString *errorStr) {
        if (errorStr)
        {
            [MBProgressHUD showError:errorStr toView:self.view];
        }else{
            
            NSDictionary *dic = [NSDictionary changeType:obj];
            
            switch (self.whitchBtn) {
                case 1000:
                {
                    self.photoIdFront = dic[@"errorMsg"];
                    [self.photoIdArr addObject:self.photoIdFront];
                }
                    break;
                case 1001:
                {
                    self.photoIdBack = dic[@"errorMsg"];
                    [self.photoIdArr addObject:self.photoIdBack];
                }
                    break;
                default:
                    break;
            }
            switch (self.whitchBtn/1000) {
                case 2:
                {
                    [self.photoRegistArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 3:
                {
                    [self.photoHouseArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 4:
                {
                    [self.photoMarryArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 5:
                {
                    [self.photoWorkArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 6:
                {
                    [self.photoWagesArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 7:
                {
                    [self.photoCreditArr addObject:dic[@"errorMsg"]];
                }
                    break;
                case 8:
                {
                    [self.photoOtherArr addObject:dic[@"errorMsg"]];
                }
                    break;
                default:
                    break;
            }
            [MBProgressHUD showSuccess:@"上传成功"];
            [self.photosTableView reloadData];
        }
        
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    CGPoint position = CGPointMake(kScreenWidth*5, 0);
    [_mainScrollView setContentOffset:position animated:NO];
    

}
#pragma mark -- 图片转Data
-(NSData  *)getDataWitdImgae:(UIImage *)originalImage{
    
    NSData *baseData = UIImageJPEGRepresentation(originalImage, 0.5);
    return baseData;
    
}


#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(STPhotoBrowserController *)browser placeholderImageForIndex:(NSInteger)index
{
    if (self.whitchBtn == 1001) {
        return [self.currentView.subviews[2] currentImage];
    } else {
        return [self.currentView.subviews[index] currentImage];
    }
    //    return [self.currentView.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(STPhotoBrowserController *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [self.currentArray[index] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
    
    return [urlStr convertHostUrl];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        _psTableView.estimatedRowHeight = 20;
        _psTableView.rowHeight = UITableViewAutomaticDimension;
        return _psTableView.rowHeight;
        
    }else if (tableView.tag == 101){
        if (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 10 || indexPath.row == 13) {
            return 52;
        }else if (indexPath.row == 7){
            return 65;
        }else if (indexPath.row == 16){
            return 100;
        }else if (indexPath.row == 17){
            return self.GRCellHeight;
        }
        
        else{
            _personalInfoTableView.estimatedRowHeight = 20;
            _personalInfoTableView.rowHeight = UITableViewAutomaticDimension;
            return _personalInfoTableView.rowHeight;
        }
    }else if (tableView.tag == 102){
        if (indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1){
            return self.ZCCellHeight;
        }
        else{
            _assetInfoTableView.estimatedRowHeight = 20;
            _assetInfoTableView.rowHeight = UITableViewAutomaticDimension;
            return _assetInfoTableView.rowHeight;
            
            
        }
        
    }else if (tableView.tag == 103){
        
        if (indexPath.row == 3) {
            return 70;
        }else{
            _workInfoTableView.estimatedRowHeight = 20;
            _workInfoTableView.rowHeight = UITableViewAutomaticDimension;
            return _workInfoTableView.rowHeight;
        }
        
    }else if (tableView.tag == 104){
        
        return 52;
    }else if (tableView.tag == 105){
        if (indexPath.section == 6) {
            if (self.photoCreditArr.count/5) {
                return 140;
            } else {
                return 80;
            }
        }
        return 80;
    }
    
    else{
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 105) {
        return self.titleArr[section];
    }else{
        return nil;
    }
    
    
}

#pragma mark --初始化将要显示的cell的数据
/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CPITreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CPITreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CPITreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.cpiTableView reloadData];
}


/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void)loadDataForTreeViewCell:(UITableViewCell*)cell with:(CPITreeViewNode*)node{
    
    
    if(node.type == 1){
        LevelOneModel *nodeData = node.nodeData;
        ((LevelOneCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        ((LevelOneCell*)cell).name.text = nodeData.name;
        
        [((LevelOneCell*)cell).arrowView setImage:[UIImage imageNamed:@"箭头（上）"]];
        
    }else if (node.type == 3){
        
        longLabelModel * nodeData = node.nodeData;
        
        ((LongLabelCell*)cell).longLabel.text = nodeData.longLabelString;
        
        ((LongLabelCell*)cell).longTextView.tag = 1060;
        ((LongLabelCell*)cell).longTextView.delegate = self;
        ((LongLabelCell*)cell).longTextView.text = self.dataDic[@"zhixiaodaikuan"];
        
        ((LongLabelCell*)cell).longTextView.tintColor = TABBAR_BASE_COLOR;
        ((LongLabelCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }else if (node.type == 4){
        
        CommonMoneyModel * nodeData = node.nodeData;
        ((PersonInfoTextViewCell*)cell).personInfoLabel.text = nodeData.commonMoneyString;
        
        ((PersonInfoTextViewCell*)cell).personInfoTextView.tag = 1061;
        ((PersonInfoTextViewCell*)cell).personInfoTextView.delegate = self;
        ((PersonInfoTextViewCell*)cell).personInfoTextView.text = self.dataDic[@"gongtongdaikuan"];
        
        ((PersonInfoTextViewCell*)cell).personInfoTextView.tintColor = TABBAR_BASE_COLOR;
        ((PersonInfoTextViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if (node.type == 6){
        
        RedLabelModel * nodeData = node.nodeData;
        ((RedLabelCell *)cell).leftRedLabel.text = nodeData.leftRedString;
        ((RedLabelCell *)cell).redLabel.text = nodeData.redString;
        
        ((RedLabelCell *)cell).redText.tag = 1062;
        ((RedLabelCell *)cell).redText.delegate = self;
        ((RedLabelCell *)cell).redText.text = self.dataDic[@"xiangxishuoming"];
        ((RedLabelCell *)cell).redText.tintColor = TABBAR_BASE_COLOR;
        ((RedLabelCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else{
        
    }
    
}


/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 104) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CPITreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
        [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
        if(node.type == 2){
            //处理叶子节点选中，此处需要自定义
        }
        else if (node.type == 3){
            
        }else if (node.type == 4){
            
        }else if (node.type == 5){
            
        }else if (node.type == 6){
            
        }
        else{
            LevelOneCell *cell = (LevelOneCell*)[tableView cellForRowAtIndexPath:indexPath];
            if(cell.node.isExpanded ){
                [self rotateArrow:cell with:M_PI];
            }
            else{
                [self rotateArrow:cell with:0];
            }
        }
        
    }
    
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(LevelOneCell*) cell with:(double)degree{
    [UIView animateWithDuration:0.00 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void)reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    
    for (CPITreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CPITreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CPITreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.cpiTableView reloadData];
}

#pragma mark -- 选择按钮的点击事件
-(void)SelectBtnsOnClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    
    
    if (sender.tag == 10 || sender.tag == 11) {
        
        
        ButtonsModel * model1 = _buttonArrayOne[0];
        if (sender.selected) {
            
            model1.index = sender.tag;
            if (model1.index == 10) {
                self.tabUSex = 1;
            }else if (model1.index == 11){
                self.tabUSex = 2;
            }else{
                self.tabUSex = 0;
            }
            
        }else{
            self.tabUSex = 0;
            model1.index = 0;
        }
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 20 || sender.tag == 21 || sender.tag == 22){
        ButtonsModel * model2 = _buttonArrayOne[1];
        
        if (sender.selected) {
            model2.index = sender.tag;
            if (model2.index == 20) {
                self.tabUIdType = 1;
            }else if (model2.index == 21){
                self.tabUIdType = 2;
            }else if (model2.index == 22){
                self.tabUIdType = 3;
            }else{
                self.tabUIdType = 0;
            }
            
        }else{
            self.tabUIdType = 0;
            model2.index = 0;
        }
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 30 || sender.tag == 31 || sender.tag == 32 || sender.tag == 33){
        
        ButtonsModel * model3 = _buttonArrayOne[2];
        if (sender.selected) {
            
            model3.index = sender.tag;
            if (model3.index == 30) {
                self.tabUMarry = 1;
            }else if (model3.index == 31){
                self.tabUMarry = 2;
            }else if (model3.index == 32){
                self.tabUMarry = 3;
            }else if (model3.index == 33){
                self.tabUMarry = 4;
            }else{
                self.tabUMarry = 0;
            }
        }else{
            self.tabUMarry = 0;
            model3.index = 0;
        }
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 40 || sender.tag == 41 ){
        
        ButtonsModel * model4 = _buttonArrayOne[3];
        
        if (sender.selected) {
            
            model4.index = sender.tag;
            if (model4.index == 40) {
                self.tabUChild = 1;
            }else if (model4.index == 41){
                self.tabUChild = 2;
            }else{
                self.tabUChild = 0;
            }
            
        }else{
            self.tabUChild = 0;
            model4.index = 0;
        }
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 50 || sender.tag == 51 || sender.tag == 52 || sender.tag == 53){
        
        ButtonsModel * model5 = _buttonArrayOne[4];
        if (sender.selected) {
            model5.index = sender.tag;
            if (model5.index == 50) {
                self.tabUEdu = 1;
            }else if (model5.index == 51){
                self.tabUEdu = 2;
            }else if (model5.index == 52){
                self.tabUEdu = 3;
            }else if (model5.index == 53){
                self.tabUEdu = 4;
            }else{
                self.tabUEdu = 0;
            }
            
        }else{
            self.tabUEdu = 0;
            model5.index = 0;
        }
        
        [_personalInfoTableView reloadData];
    }else if (sender.tag == 80 || sender.tag == 81 || sender.tag == 82 || sender.tag == 83||sender.tag == 84 || sender.tag == 85 || sender.tag == 86 ){
        
        ButtonsModel * model8 = _buttonArrayTree[0];
        if (sender.selected) {
            model8.index = sender.tag;
            if (model8.index == 80) {
                self.wkType = 1;
            }else if (model8.index == 81){
                self.wkType = 2;
            }else if (model8.index == 82){
                self.wkType = 3;
            }else if (model8.index == 83){
                self.wkType = 4;
            }else if (model8.index == 84){
                self.wkType = 5;
            }else if (model8.index == 85){
                self.wkType = 6;
            }else if (model8.index == 86){
                self.wkType = 7;
            }else{
                self.wkType = 0;
            }
            
        }else{
            self.wkType = 0;
            model8.index = 0;
        }
        NSLog(@"wk==%ld",self.wkType);
        [_workInfoTableView reloadData];
    }else if (sender.tag == 90 || sender.tag == 91 || sender.tag == 92  ){
        
        ButtonsModel * model9 = _buttonArrayTree[1];
        if (sender.selected) {
            
            model9.index = sender.tag;
            if (model9.index == 90) {
                self.wkMonType = 1;
            }else if (model9.index == 91){
                self.wkMonType = 2;
            }else if (model9.index == 92){
                self.wkMonType = 3;
            }else{
                self.wkMonType = 0;
            }
        }else{
            self.wkMonType = 0;
            model9.index = 0;
        }
        [_workInfoTableView reloadData];
    }
    else if (sender.tag == 95 || sender.tag == 96 ){
        CPITreeViewNode * node = [_dataArray objectAtIndex:6];
        ButtonsModel * model10 = node.nodeData;
        
        if (sender.selected) {
            model10.index = sender.tag;
            if (model10.index == 95) {
                self.tabLoan = 1;
            }else if (model10.index == 96){
                self.tabLoan = 2;
            }else{
                self.tabLoan = 0;
            }
        }else{
            self.tabLoan = 0;
            model10.index = 0;
        }
        
        [_cpiTableView reloadData];
        
    }
}

#pragma mark --选择地址的点击事件

-(void)AddressChooseOnClick:(UIButton *)sender{
    
    if (sender.tag == 10) {
//        __weak LocationView * weakView = self.locaView;
//        weakView.locaBlock = ^(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str){
//            
//            self.proID = num1;
//            self.cityID = num2;
//            self.areaID = num3;
//            returnAddressOne =str;
//            
//            [_personalInfoTableView reloadData];
//        };
        
        citiesViewController *citiesVC = [[citiesViewController alloc]init];
        citiesVC.type = 5;
        citiesVC.limited = 2;
        citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
            self.proID = [selectedProID integerValue];
            self.cityID = [selectedCityID integerValue];
            self.areaID = [selectedAreaID integerValue];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
            returnAddressOne =str;
            [_personalInfoTableView reloadData];
        };
        citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:citiesVC animated:YES completion:nil];
    }else if (sender.tag == 13){
        
//        __weak LocationView * weakView = self.locaView;
//        weakView.locaBlock = ^(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str){
//            
//            self.adsProId = num1;
//            self.adsCityId = num2;
//            self.adsAreaId = num3;
//            
//            returnAddressTwo =str;
//            [_personalInfoTableView reloadData];
//            
//        };
        
        citiesViewController *citiesVC = [[citiesViewController alloc]init];
        citiesVC.type = 5;
        citiesVC.limited = 2;
        citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
            self.adsProId = [selectedProID integerValue];
            self.adsCityId = [selectedCityID integerValue];
            self.adsAreaId = [selectedAreaID integerValue];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
            returnAddressTwo =str;
            [_personalInfoTableView reloadData];
        };
        citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:citiesVC animated:YES completion:nil];
    }else if (sender.tag == 3){
        
//        __weak LocationView * weakView = self.locaView;
//        weakView.locaBlock = ^(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str){
//            
//            self.houseProId = num1;
//            self.houseCityId = num2;
//            self.houseAreaId = num3;
//            
//            returnAddressThree =str;
//            [_assetInfoTableView reloadData];
//            
//        };
        
        citiesViewController *citiesVC = [[citiesViewController alloc]init];
        citiesVC.type = 5;
        citiesVC.limited = 2;
        citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
            self.houseProId = [selectedProID integerValue];
            self.houseCityId = [selectedCityID integerValue];
            self.houseAreaId = [selectedAreaID integerValue];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
            returnAddressThree =str;
            [_assetInfoTableView reloadData];
        };
        citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:citiesVC animated:YES completion:nil];
    }else if (sender.tag == 1){
        
//        __weak LocationView * weakView = self.locaView;
//        weakView.locaBlock = ^(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str){
//            
//            self.wkProId = num1;
//            self.wkCityId = num2;
//            self.wkAreaId = num3;
//            
//            returnAddressFour =str;
//            [_workInfoTableView reloadData];
//            
//        };
        
        citiesViewController *citiesVC = [[citiesViewController alloc]init];
        citiesVC.type = 5;
        citiesVC.limited = 2;
        citiesVC.proAndCityAndAreaBlock = ^(NSString *selectedProName, NSString *selectedCityName, NSString *selectedAreaName, NSString *selectedProID, NSString *selectedCityID, NSString *selectedAreaID) {
            self.wkProId = [selectedProID integerValue];
            self.wkCityId = [selectedCityID integerValue];
            self.wkAreaId = [selectedAreaID integerValue];
            
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",selectedProName,selectedCityName,selectedAreaName];
            returnAddressFour =str;
            [_workInfoTableView reloadData];
        };
        citiesVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:citiesVC animated:YES completion:nil];
    }
}


#pragma mark --选择时间的点击事件

-(void)timeChoiceOnClick:(UIButton *)sender{
    
    if (sender.tag == 19 ) {
        temp = 1;
    }else if (sender.tag == 20){
        temp = 2;
    }else if (sender.tag == 5){
        temp = 3;
    }else if (sender.tag == 14){
        temp = 4;
    }else if (sender.tag == 8){
        temp = 5;
    }
    
    _dateTimeSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _dateTimeSelectView.frame = timeViewRect;
    } completion:^(BOOL finished) {
        
    }];
    
    
}
#pragma mark --SelectDateTimeDelegate
- (void)getDate:(NSMutableDictionary *)dictDate {
    NSString *timeString = [NSString stringWithFormat:@"%@",dictDate[@"date"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    
    if (temp == 1) {
        returnTimeOne = timeString;
        [_personalInfoTableView reloadData];
        
        
        NSDate* date = [formatter dateFromString:timeString]; //------------将字符串按formatter转成nsdate
        
        self.adsTime = [date timeIntervalSince1970]*1000;
        
        NSLog(@"时间戳:%zd",self.adsTime);
        
        
    }
    if (temp == 2) {
        returnTimeTwo = timeString;
        [_personalInfoTableView reloadData];
        
        NSDate* date = [formatter dateFromString:timeString]; //------------将字符串按formatter转成nsdate
        
        self.adsStarTime = [date timeIntervalSince1970]*1000;
        
        NSLog(@"时间戳:%zd",self.adsStarTime);
        
        
    }
    if (temp == 3) {
        returnTimeThree = timeString;
        [_assetInfoTableView reloadData];
        NSDate* date = [formatter dateFromString:timeString]; //------------将字符串按formatter转成nsdate
        
        self.houseDate = [date timeIntervalSince1970]*1000;
        
        NSLog(@"时间戳:%zd",self.houseDate);
        
        
    }
    if (temp == 4) {
        returnTimeFour = timeString;
        [_assetInfoTableView reloadData];
        
        NSDate* date = [formatter dateFromString:timeString]; //------------将字符串按formatter转成nsdate
        
        self.carDate = [date timeIntervalSince1970]*1000;
        
        NSLog(@"时间戳:%zd",self.carDate);
        
        
    }
    if (temp == 5) {
        returnTimeFive = timeString;
        [_workInfoTableView reloadData];
        
        NSDate* date = [formatter dateFromString:timeString]; //------------将字符串按formatter转成nsdate
        
        self.wkDate= [date timeIntervalSince1970]*1000;
        
        NSLog(@"时间戳:%zd",self.wkDate);
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
    }];
}
- (void)cancelDate {
    [UIView animateWithDuration:0.2 animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
    }];
}

#pragma mark --ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.mainScrollView) {
        //contentOffset 偏移量
        NSInteger  page = scrollView.contentOffset.x/kScreenWidth;
        
        step = page;
        
        //1把上一次选中的按钮的状态selected = NO
        UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
        lastBtn.selected = NO;
        //2把传来的按钮的状态selected = YES
        UIButton *selectBtn = [self.topView viewWithTag:page+100];
        selectBtn.selected = YES;
        //3更新lastBtnTag的值
        _lastBtnTag = page+100;
        
        if (step == 0) {
            UIImageView* leftIV = [self.view viewWithTag:10];
            leftIV.image = [UIImage imageNamed:@"矢量智能对象"];
            
            self.navigationItem.title = @"个人服务申请表";
        }else if (step == 1){
            UIImageView* leftIV = [self.view viewWithTag:10];
            leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_70"];
            
            self.navigationItem.title = @"个人信息";
        }else if (step == 2){
            UIImageView* leftIV = [self.view viewWithTag:10];
            leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_21"];
            
            self.navigationItem.title = @"资产信息";
        }else if (step == 3){
            UIImageView* leftIV = [self.view viewWithTag:10];
            leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x (1)"];
            
            self.navigationItem.title = @"工作信息";
        }else if (step == 4){
            UIImageView* leftIV = [self.view viewWithTag:10];
            leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_22"];
            
            self.navigationItem.title = @"联系人信息";
        }else if (step == 5){
            UIImageView* leftIV = [self.view viewWithTag:10];
            leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_53"];
            
            self.navigationItem.title = @"材料上传";
        }
        
        
    }
}


#pragma mark --点击下部按钮
-(void)BtnsClick:(UIButton *)sender{
    
    UIButton * lastButton = [self.bottomView viewWithTag:_lastTag];
    lastButton.selected = NO;
    
    sender.selected = YES;
    
    _lastTag = sender.tag;
    
    if (sender.tag == 201) {
        
        step++;
        
        if (step > 5) {
            
            int num =5;
            step = num;
            
            JKAlertView * firstAlertView = [[JKAlertView alloc]initWithTitle:@"已经是最后一步了" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [firstAlertView show];
        }
        else  {
            
            [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth *step, 0) animated:YES];
            if (step == 0) {
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"个人服务申请表";
            }else if (step == 1){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_70"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"个人信息";
            }else if (step == 2){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_21"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"资产信息";
            }else if (step == 3){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x (1)"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"工作信息";
            }else if (step == 4){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_22"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"联系人信息";
            }else if (step == 5){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_53"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"材料上传";
            }
        }
        CGFloat newX = (sender.tag-200) * sender.bounds.size.width;
        CGRect rect = sender.bounds;
        rect.origin.x = newX;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.backgroundView.frame = rect;
            
        }];
        
    }else if (sender.tag == 200){
        
        step--;
        
        if (step < 0 ) {
            int num = 0;
            step = num;
            
            JKAlertView * firstAlertView = [[JKAlertView alloc]initWithTitle:@"已经是第一步了" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [firstAlertView show];
            
        } else  {
            [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth *step, 0) animated:YES];
            if (step == 0) {
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"个人服务申请表";
            }else if (step == 1){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_70"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"个人信息";
            }else if (step == 2){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_21"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"资产信息";
            }else if (step == 3){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x (1)"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"工作信息";
            }else if (step == 4){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_22"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"联系人信息";
            }else if (step == 5){
                UIImageView* leftIV = [self.view viewWithTag:10];
                leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_53"];
                UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
                lastBtn.selected = NO;
                UIButton *selectBtn = [self.topView viewWithTag:step+100];
                selectBtn.selected = YES;
                _lastBtnTag = step+100;
                self.navigationItem.title = @"材料上传";
            }
            
        }
        
        CGFloat newX = (sender.tag-200) * sender.bounds.size.width;
        CGRect rect = sender.bounds;
        rect.origin.x = newX;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.backgroundView.frame = rect;
            
        }];
    }
}

#pragma mark --点击上方按钮
-(void)BtnOnClick:(UIButton *)btn{
    
    //1把上一次选中的按钮的状态selected = NO
    UIButton *lastBtn = [self.topView viewWithTag:_lastBtnTag];
    lastBtn.selected = NO;
    //2把选中的按钮的状态selected = YES
    btn.selected = YES;
    //3更新lastBtnTag的值
    _lastBtnTag = btn.tag;
    
    NSInteger page = btn.tag - 100;
    
    if (btn.tag == 100) {
        step = 0;
    }else if (btn.tag == 101){
        step = 1;
    }else if (btn.tag == 102){
        step = 2;
    }else if (btn.tag == 103){
        step = 3;
    }else if (btn.tag == 104){
        step = 4;
    }else if (btn.tag == 105){
        step = 5;
    }
    [self.mainScrollView setContentOffset:CGPointMake(kScreenWidth * page, 0) animated:YES];
    if (step == 0) {
        UIImageView* leftIV = [self.view viewWithTag:10];
        leftIV.image = [UIImage imageNamed:@"矢量智能对象"];
        
        self.navigationItem.title = @"个人服务申请表";
    }else if (step == 1){
        UIImageView* leftIV = [self.view viewWithTag:10];
        leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_70"];
        
        self.navigationItem.title = @"个人信息";
    }else if (step == 2){
        UIImageView* leftIV = [self.view viewWithTag:10];
        leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_21"];
        
        self.navigationItem.title = @"资产信息";
    }else if (step == 3){
        UIImageView* leftIV = [self.view viewWithTag:10];
        leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x (1)"];
        
        self.navigationItem.title = @"工作信息";
    }else if (step == 4){
        UIImageView* leftIV = [self.view viewWithTag:10];
        leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_22"];
        
        self.navigationItem.title = @"联系人信息";
    }else if (step == 5){
        UIImageView* leftIV = [self.view viewWithTag:10];
        leftIV.image = [UIImage imageNamed:@"矢量智能对象@2x_53"];
        
        self.navigationItem.title = @"材料上传";
    }
    
}

#pragma mark --提交按钮点击事件

-(void)ClickONOk{
    
    loginModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    UITextView * tabQuota = [self.psTableView viewWithTag:1000];
    //   UITextView * tabUName = [self.personalInfoTableView viewWithTag:1003];
    //  UITextView * tabUMobile = [self.personalInfoTableView viewWithTag:1004];
//    UITextView * tabUIdNum = [self.personalInfoTableView viewWithTag:1005];
    NSString * moblileStr = [NSString stringWithFormat:@"%@",self.dataDic[@"dianhua"]];
    NSString *IDNum = self.dataDic[@"zhengjian"];
    if (tabQuota.text.length == 0) {
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入申请额度" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }else if (self.dataDic[@"xingming"] == nil){
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入您的姓名" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }else if (self.dataDic[@"dianhua"] == nil){
        
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入您的手机号码" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }else if (moblileStr.length != 11 || ![[moblileStr substringToIndex:1] isEqualToString:@"1"]){
        [MBProgressHUD showError:@"手机号码输入有误！"];
    }else if (self.tabUIdType != 1 && self.tabUIdType != 2 && self.tabUIdType != 3){
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请选择您的证件类型" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }else if (IDNum.length == 0){
        JKAlertView *alert = [[JKAlertView alloc] initWithTitle:@"请输入您的证件号" message:nil delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        
        NSMutableDictionary * parameters = [self dicWithInterType:@"newOrder" MechProId:[_product.ID integerValue] andTabUserId:loginModel.userId];
        
        NSLog(@"parameter:%@",parameters);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:ORDER parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"==:%@",responseObject);
            NSData *data = responseObject;
            NSString *code = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([code isEqualToString:@"false"]) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"申请失败"]];
            } else {
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"申请成功"]];
                [self.navigationController popViewControllerAnimated:YES];
                step = 0;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            
        }];
        
    }
}


-(NSMutableDictionary *)dicWithInterType:(NSString *)interType MechProId:(NSInteger)mechProId andTabUserId:(NSInteger)tabUserId{
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    dic[@"inter"] = interType;
    dic[@"mechProId"] = @(mechProId);
    dic[@"tabUserId"] = @(tabUserId);
    
    UITextView * tabQuota = [self.psTableView viewWithTag:1000];
    
    dic[@"tabQuota"]= @([tabQuota.text floatValue]);
    
    UITextView * tabRepayMonth = [self.psTableView viewWithTag:1002];
    if (![tabRepayMonth.text isEqual:@"(null)"]) {
        
        dic[@"tabRepayMonth"] = @([tabRepayMonth.text floatValue]);
    }
    
    UITextView * tabTerm = [self.psTableView viewWithTag:1001];
    
    if (![tabTerm.text isEqual:@"(null)"]) {
        
        dic[@"tabTerm"] = @([tabTerm.text integerValue]);
    }
    
    dic[@"tabUName"] = self.dataDic[@"xingming"];
    
    dic[@"tabUMobile"] = self.dataDic[@"dianhua"];
    dic[@"tabUIdType"] = @(self.tabUIdType);
    dic[@"tabUIdNum"] = self.dataDic[@"zhengjian"];
    
    if (self.tabUSex != 0) {
        dic[@"tabUSex"] = @(self.tabUSex);
    }
    
    if (self.tabUMarry != 0) {
        dic[@"tabUMarry"] = @(self.tabUMarry);
    }
    
    if (self.tabUChild != 0) {
        dic[@"tabUChild"] = @(self.tabUChild);
    }
    
    if (self.tabUEdu != 0) {
        dic[@"tabUEdu"] = @(self.tabUEdu);
    }
    
    if (![self.dataDic[@"qq"] isEqual:@"(null)"]) {
        
        dic[@"tabUqqNum"] = self.dataDic[@"qq"];
    }
    if (![self.dataDic[@"qq"] isEqual:@"(null)"]) {
        dic[@"tabUEmail"] = self.dataDic[@"youxiang"];
    }
    if (self.proID != 0) {
        
        dic[@"proId"] = @(self.proID);
    }
    if (self.cityID != 0) {
        dic[@"cityId"] = @(self.cityID);
    }
    
    if (self.areaID != 0) {
        dic[@"areaId"] = @(self.areaID);
    }
    
    if (![self.dataDic[@"hukoudizhi"] isEqual:@"(null)"]) {
        
        dic[@"tabURegi"] = self.dataDic[@"hukoudizhi"];
    }
    if (![self.dataDic[@"hukouyoubian"] isEqual:@"(null)"]) {
        
        dic[@"tabUPostAds"] = self.dataDic[@"hukouyoubian"];
    }
    
    if (self.adsProId != 0) {
        
        dic[@"adsProId"] = @(self.adsProId);
    }
    if (self.adsCityId != 0) {
        dic[@"adsCityId"] = @(self.adsCityId);
    }
    
    if (self.adsAreaId != 0) {
        dic[@"adsAreaId"] = @(self.adsAreaId);
    }
    
    if (![self.dataDic[@"zhuzhaidizhi"] isEqual:@"(null)"]) {
        
        dic[@"tabUAds"] = self.dataDic[@"zhuzhaidizhi"];
    }
    if (![self.dataDic[@"zhuzhaiyoubian"] isEqual:@"(null)"]) {
        
        dic[@"tabUPostAdsRegi"] = self.dataDic[@"zhuzhaiyoubian"];
    }
    
    if (self.tabUHsType != 0) {
        dic[@"tabUHsType"] = @(self.tabUHsType);
    }
    if (![self.dataDic[@"zuyong"] isEqualToString:@"0"]) {
        dic[@"tabUHsMoney"] = @([self.dataDic[@"zuyong"] integerValue]);
    }
    if (![self.dataDic[@"qitazhuzhai"] isEqualToString:@"0"]) {
        dic[@"tabUHsOther"] = self.dataDic[@"qitazhuzhai"] ;
    }
    
    if (![self.dataDic[@"zhuzhaidianhua"] isEqual:@"(null)"]) {
        
        dic[@"tabUTel"] = self.dataDic[@"zhuzhaidianhua"];
    }
    
    
    if (self.houseType != 0) {
        
        dic[@"houseType"] = @(self.houseType);
    }
    if (![self.dataDic[@"qitafangchan"] isEqual:@"(null)"]) {
        dic[@"houseTypeOther"] =self.dataDic[@"qitafangchan"];
    }
    
    if (![self.dataDic[@"goumaidanjia"] isEqual:@"(null)"]) {
        dic[@"housePrice"] = @([self.dataDic[@"goumaidanjia"] integerValue]);
    }
    
    if (self.houseProId != 0) {
        dic[@"houseProId"] = @(self.houseProId);
    }
    if (self.houseCityId != 0) {
        dic[@"houseCityId"] = @(self.houseCityId);
    }
    if (self.houseAreaId != 0) {
        dic[@"houseAreaId"] = @(self.houseAreaId);
    }
    
    if (![self.dataDic[@"fangchandizhi"] isEqual:@"(null)"]) {
        dic[@"houseDetail"] = self.dataDic[@"fangchandizhi"];
    }
    
    if (![self.dataDic[@"jianzhumianji"] isEqual:@"(null)"]) {
        dic[@"houseArea"] = @([self.dataDic[@"jianzhumianji"] integerValue]);
    }
    
    if (![self.dataDic[@"chanchuanbili"] isEqual:@"(null)"]) {
        dic[@"houseProperty"] = @([self.dataDic[@"chanquanbili"] integerValue]);
    }
    
    if (![self.dataDic[@"daikuannianxian"] isEqual:@"(null)"]) {
        dic[@"houseYear"] = @([self.dataDic[@"daikuannianxian"] floatValue]);
    }
    
    if (![self.dataDic[@"yuegong"] isEqual:@"(null)"]) {
        dic[@"houseMonth"] = @([self.dataDic[@"yuegong"] integerValue]);
    }
    
    if (![self.dataDic[@"daikuanyue"] isEqual:@"(null)"]) {
        dic[@"houseMoney"] = @([self.dataDic[@"daikuanyue"] floatValue]);
    }
    
    if (![self.dataDic[@"cheliangpinpai"] isEqual:@"(null)"]) {
        dic[@"carName"] = self.dataDic[@"cheliangpinpai"];
    }
    
    if (![self.dataDic[@"goumaijiage"] isEqual:@"(null)"]) {
        dic[@"carPrice"] = @([self.dataDic[@"goumaijiage"] floatValue]);
    }
    
    if (![self.dataDic[@"yuegongdaikuan"] isEqual:@"(null)"]) {
        dic[@"carMonth"] = @([self.dataDic[@"yuegongdaikuan"] integerValue]);
    }
    
    if (![self.dataDic[@"danweimingcheng"] isEqual:@"(null)"]) {
        dic[@"wkName"] = self.dataDic[@"danweimingcheng"];
    }
    
    if (self.wkProId != 0) {
        dic[@"wkProId"] = @(self.wkProId);
    }
    if (self.wkCityId != 0) {
        dic[@"wkCityId"] = @(self.wkCityId);
    }
    if (self.wkAreaId != 0) {
        dic[@"wkAreaId"] = @(self.wkAreaId);
    }
    if (![self.dataDic[@"danweidizhi"] isEqual:@"(null)"]) {
        dic[@"wkAds"] = self.dataDic[@"danweidizhi"];
    }
    if (self.wkType != 0) {
        dic[@"wkType"] = @(self.wkType);
    }
    if (![self.dataDic[@"suoshuhangye"] isEqual:@"(null)"]) {
        dic[@"wkIndu"] = self.dataDic[@"suoshuhangye"];
    }
    if (![self.dataDic[@"danweidianhua"] isEqual:@"(null)"]) {
        dic[@"wkTel"] = self.dataDic[@"danweidianhua"];
    }
    if (![self.dataDic[@"suoshubumen"] isEqual:@"(null)"]) {
        dic[@"wkPart"] = self.dataDic[@"suoshubumen"];
    }
    if (![self.dataDic[@"danrenzhiwei"] isEqual:@"(null)"]) {
        dic[@"wkJob"] = self.dataDic[@"danrenzhiwei"];
    }
    if (![self.dataDic[@"yuezongshouru"] isEqual:@"(null)"]) {
        dic[@"wkMoney"] = self.dataDic[@"yuezongshouru"];
    }
    if (![self.dataDic[@"faxinri"] isEqual:@"(null)"]) {
        dic[@"wkMonDate"] = self.dataDic[@"faxinri"];
    }
    
    if (self.wkMonType != 0) {
        dic[@"wkMonType"] = @(self.wkMonType);
    }
    
    if (![self.dataDic[@"peiouxingming"] isEqual:@"(null)"]) {
        dic[@"dearName"] = self.dataDic[@"peiouxingming"];
    }
    if (![self.dataDic[@"peioushenfen"] isEqual:@"(null)"]) {
        dic[@"idCard"] = self.dataDic[@"peioushenfen"];
    }
    if (![self.dataDic[@"peioudianhua"] isEqual:@"(null)"]) {
        dic[@"perMobile"] = self.dataDic[@"peioudianhua"];
    }
    if (![self.dataDic[@"peioudanwei"] isEqual:@"(null)"]) {
        dic[@"companyName"] = self.dataDic[@"peioudanwei"];
    }
    if (![self.dataDic[@"peioudanweidizhi"] isEqual:@"(null)"]) {
        dic[@"companyAddress"] = self.dataDic[@"peioudanweidizhi"];
    }
    if (![self.dataDic[@"peioudanweidianhua"] isEqual:@"(null)"]) {
        dic[@"companyTel"] = self.dataDic[@"peioudanweidianhua"];
    }
    if (![self.dataDic[@"peioujuzhudizhi"] isEqual:@"(null)"]) {
        dic[@"perAddress"] = self.dataDic[@"peioujuzhudizhi"];
    }
    if (![self.dataDic[@"qinshuxingming"] isEqual:@"(null)"]) {
        dic[@"perFamName"] = self.dataDic[@"qinshuxingming"];
    }
    if (![self.dataDic[@"qinshuguanxi"] isEqual:@"(null)"]) {
        dic[@"perFamShip"] = self.dataDic[@"qinshuguanxi"];
    }
    if (![self.dataDic[@"qinshudianhua"] isEqual:@"(null)"]) {
        dic[@"perFamMobile"] = self.dataDic[@"qinshudianhua"];
    }
    if (![self.dataDic[@"qinshudanwei"] isEqual:@"(null)"]) {
        dic[@"perFamCompany"] = self.dataDic[@"qinshudanwei"];
    }
    if (![self.dataDic[@"tongshixingming"] isEqual:@"(null)"]) {
        dic[@"perCollName"] = self.dataDic[@"tongshidanwei"];
    }
    if (![self.dataDic[@"tongshizhiwu"] isEqual:@"(null)"]) {
        dic[@"perCollWork"] = self.dataDic[@"tongshizhiwu"];
    }
    if (![self.dataDic[@"tongshidianhua"] isEqual:@"(null)"]) {
        dic[@"perCollMobile"] = self.dataDic[@"tongshidianhua"];
    }
    if (![self.dataDic[@"tongshidanwei"] isEqual:@"(null)"]) {
        dic[@"perCollCompany"] = self.dataDic[@"tongshidanwei"];
    }
    if (![self.dataDic[@"qitaxingming"] isEqual:@"(null)"]) {
        dic[@"perOtherName"] = self.dataDic[@"qitaxingming"];
    }
    if (![self.dataDic[@"qitaguanxi"] isEqual:@"(null)"]) {
        dic[@"perOtherShip"] = self.dataDic[@"qitaguanxi"];
    }
    if (![self.dataDic[@"qitadianhua"] isEqual:@"(null)"]) {
        dic[@"perOtherMobile"] = self.dataDic[@"qitadianhua"];
    }
    if (![self.dataDic[@"qitadanwei"] isEqual:@"(null)"]) {
        dic[@"perOtherCompany"] = self.dataDic[@"qitadanwei"];
    }
    
    if (![self.dataDic[@"zhixiaodaikuan"] isEqual:@"(null)"]) {
        dic[@"perKnow"] = self.dataDic[@"zhixiaodaikuan"];
    }
    if (![self.dataDic[@"gongtongdaikuan"] isEqual:@"(null)"]) {
        dic[@"perTogetherName"] = self.dataDic[@"gongtongdaikuan"];
    }
    if (![self.dataDic[@"xiangxishuoming"] isEqual:@"(null)"]) {
        dic[@"tabLoanDetail"] = self.dataDic[@"xiangxishuoming"];
    }
    
    if (self.tabLoan != 0) {
        dic[@"tabLoan"] = @(self.tabLoan);
    }
    
    
    
    if (self.adsTime != 0000000000) {
        dic[@"adsTime"] = @(self.adsTime);
    }
    if (self.adsStarTime != 0000000000) {
        dic[@"adsStarTime"] = @(self.adsStarTime);
    }
    if (self.houseDate != 0000000000) {
        dic[@"houseDate"] = @(self.houseDate);
    }
    if (self.carDate != 0000000000) {
        dic[@"carDate"] = @(self.carDate);
    }
    if (self.wkDate != 0000000000) {
        dic[@"wkDate"] = @(self.wkDate);
    }
    
    
    if (self.photoIdFront.length == 0 || [self.photoIdFront isEqualToString:@""] || self.photoIdFront == nil || self.photoIdFront == NULL || [self.photoIdFront isEqual:[NSNull null]] || [self.photoIdFront isEqualToString:@"(null)"] || [self.photoIdFront isEqualToString:@"null"]) {
        self.PhotoModel.photoIdFront = @"";
    } else {
        self.photoIdFront = [self.photoIdFront stringByReplacingOccurrencesOfString:@"_min" withString:@""];
        self.PhotoModel.photoIdFront = self.photoIdFront;
        
        dic[@"photoIdFront"] = self.photoIdFront;
    }
    if (self.photoIdBack.length == 0 || [self.photoIdBack isEqualToString:@""] || self.photoIdBack == nil || self.photoIdBack == NULL || [self.photoIdBack isEqual:[NSNull null]] || [self.photoIdBack isEqualToString:@"(null)"] || [self.photoIdBack isEqualToString:@"null"]) {
        self.PhotoModel.photoIdBack = @"";
    } else {
        self.photoIdBack = [self.photoIdBack stringByReplacingOccurrencesOfString:@"_min" withString:@""];
        self.PhotoModel.photoIdBack = self.photoIdBack;
        
        dic[@"photoIdBack"] = self.photoIdBack;

    }
    
    if (self.photoRegistArr.count) {
        for (int i = 0; i < self.photoRegistArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoRegist = [self.photoRegistArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoRegist"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoRegist%d",i+1];
            }
            [dic setObject:photoRegist forKey:keyStr];
        }
    }
    
//    switch (self.photoRegistArr.count) {
//        case 1:
//        {
//            self.photoRegist = self.photoRegistArr[0];
//            self.photoRegist = [self.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoRegist = self.photoRegist;
//            
//            dic[@"photoRegist"] = self.photoRegist;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoRegist = self.photoRegistArr[0];
//            self.photoRegist = [self.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoRegist = self.photoRegist;
//            
//            dic[@"photoRegist"] = self.photoRegist;
//
//            
//            self.photoRegist2 = self.photoRegistArr[1];
//            self.photoRegist2 = [self.photoRegist2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoRegist2 = self.photoRegist2;
//            
//            dic[@"photoRegist2"] = self.photoRegist2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoRegist = self.photoRegistArr[0];
//            self.photoRegist = [self.photoRegist stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoRegist = self.photoRegist;
//            
//            dic[@"photoRegist"] = self.photoRegist;
//
//            self.photoRegist2 = self.photoRegistArr[1];
//            self.photoRegist2 = [self.photoRegist2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoRegist2 = self.photoRegist2;
//            
//            dic[@"photoRegist2"] = self.photoRegist2;
//
//            self.photoRegist3 = self.photoRegistArr[2];
//            self.photoRegist3 = [self.photoRegist3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoRegist3 = self.photoRegist3;
//            
//            dic[@"photoRegist3"] = self.photoRegist3;
//
//        }
//            break;
//        default:
//            break;
//    }
    
    if (self.photoHouseArr.count) {
        for (int i = 0; i < self.photoHouseArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoHouse = [self.photoHouseArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoHouse"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoHouse%d",i+1];
            }
            [dic setObject:photoHouse forKey:keyStr];
        }
    }
//    switch (self.photoHouseArr.count) {
//        case 1:
//        {
//            self.photoHouse = self.photoHouseArr[0];
//            self.photoHouse = [self.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoHouse = self.photoHouse;
//            dic[@"photoHouse"] = self.photoHouse;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoHouse = self.photoHouseArr[0];
//            self.photoHouse = [self.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoHouse = self.photoHouse;
//            dic[@"photoHouse"] = self.photoHouse;
//
//            self.photoHouse2 = self.photoHouseArr[1];
//            self.photoHouse2 = [self.photoHouse2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoHouse2 = self.photoHouse2;
//            dic[@"photoHouse2"] = self.photoHouse2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoHouse = self.photoHouseArr[0];
//            self.photoHouse = [self.photoHouse stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoHouse = self.photoHouse;
//            dic[@"photoHouse"] = self.photoHouse;
//
//            self.photoHouse2 = self.photoHouseArr[1];
//            self.photoHouse2 = [self.photoHouse2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoHouse2 = self.photoHouse2;
//            dic[@"photoHouse2"] = self.photoHouse2;
//
//            self.photoHouse3 = self.photoHouseArr[2];
//            self.photoHouse3 = [self.photoHouse3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoHouse3 = self.photoHouse3;
//            dic[@"photoHouse3"] = self.photoHouse3;
//
//        }
//            break;
//        default:
//            break;
//    }
    
    if (self.photoMarryArr.count) {
        for (int i = 0; i < self.photoMarryArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoMarry = [self.photoMarryArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoMarry"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoMarry%d",i+1];
            }
            [dic setObject:photoMarry forKey:keyStr];
        }
    }
//    switch (self.photoMarryArr.count) {
//        case 1:
//        {
//            self.photoMarry = self.photoMarryArr[0];
//            self.photoMarry = [self.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoMarry = self.photoMarry;
//            dic[@"photoMarry"] = self.photoMarry;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoMarry = self.photoMarryArr[0];
//            self.photoMarry = [self.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoMarry = self.photoMarry;
//            dic[@"photoMarry"] = self.photoMarry;
//
//            self.photoMarry2 = self.photoMarryArr[1];
//            self.photoMarry2 = [self.photoMarry2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoMarry2 = self.photoMarry2;
//            dic[@"photoMarry2"] = self.photoMarry2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoMarry = self.photoMarryArr[0];
//            self.photoMarry = [self.photoMarry stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoMarry = self.photoMarry;
//            dic[@"photoMarry"] = self.photoMarry;
//
//            self.photoMarry2 = self.photoMarryArr[1];
//            self.photoMarry2 = [self.photoMarry2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoMarry2 = self.photoMarry2;
//            dic[@"photoMarry2"] = self.photoMarry2;
//
//            self.photoMarry3 = self.photoMarryArr[2];
//            self.photoMarry3 = [self.photoMarry3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoMarry3 = self.photoMarry3;
//            dic[@"photoMarry3"] = self.photoMarry3;
//
//        }
//            break;
//        default:
//            break;
//    }
    
    
    if (self.photoWorkArr.count) {
        for (int i = 0; i < self.photoWorkArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoWork = [self.photoWorkArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoWork"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoWork%d",i+1];
            }
            [dic setObject:photoWork forKey:keyStr];
        }
    }
//    switch (self.photoWorkArr.count) {
//        case 1:
//        {
//            self.photoWork = self.photoWorkArr[0];
//            self.photoWork = [self.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWork = self.photoWork;
//            dic[@"photoWork"] = self.photoWork;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoWork = self.photoWorkArr[0];
//            self.photoWork = [self.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWork = self.photoWork;
//            dic[@"photoWork"] = self.photoWork;
//
//            self.photoWork2 = self.photoWorkArr[1];
//            self.photoWork2 = [self.photoWork2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWork2 = self.photoWork2;
//            dic[@"photoWork2"] = self.photoWork2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoWork = self.photoWorkArr[0];
//            self.photoWork = [self.photoWork stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWork = self.photoWork;
//            dic[@"photoWork"] = self.photoWork;
//
//            self.photoWork2 = self.photoWorkArr[1];
//            self.photoWork2 = [self.photoWork2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWork2 = self.photoWork2;
//            dic[@"photoWork2"] = self.photoWork2;
//
//            self.photoWork3 = self.photoWorkArr[2];
//            self.photoWork3 = [self.photoWork3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWork3 = self.photoWork3;
//            dic[@"photoWork3"] = self.photoWork3;
//
//        }
//            break;
//        default:
//            break;
//    }
    
    if (self.photoWagesArr.count) {
        for (int i = 0; i < self.photoWagesArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoWages = [self.photoWagesArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoWages"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoWages%d",i+1];
            }
            [dic setObject:photoWages forKey:keyStr];
        }
    }
//    switch (self.photoWagesArr.count) {
//        case 1:
//        {
//            self.photoWages = self.photoWagesArr[0];
//            self.photoWages = [self.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWages = self.photoWages;
//            dic[@"photoWages"] = self.photoWages;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoWages = self.photoWagesArr[0];
//            self.photoWages = [self.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWages = self.photoWages;
//            dic[@"photoWages"] = self.photoWages;
//
//            self.photoWages2 = self.photoWagesArr[1];
//            self.photoWages2 = [self.photoWages2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWages2 = self.photoWages2;
//            dic[@"photoWages2"] = self.photoWages2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoWages = self.photoWagesArr[0];
//            self.photoWages = [self.photoWages stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWages = self.photoWages;
//            dic[@"photoWages"] = self.photoWages;
//
//            self.photoWages2 = self.photoWagesArr[1];
//            self.photoWages2 = [self.photoWages2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWages2 = self.photoWages2;
//            dic[@"photoWages2"] = self.photoWages2;
//
//            self.photoWages3 = self.photoWagesArr[2];
//            self.photoWages3 = [self.photoWages3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoWages3 = self.photoWages3;
//            dic[@"photoWages3"] = self.photoWages3;
//
//        }
//            break;
//        default:
//            break;
//    }
    
    if (self.photoCreditArr.count) {
        for (int i = 0; i < self.photoCreditArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoCredit = [self.photoCreditArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoCredit"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoCredit%d",i+1];
            }
            [dic setObject:photoCredit forKey:keyStr];
        }
    }
//    switch (self.photoCreditArr.count) {
//        case 1:
//        {
//            self.photoCredit = self.photoCreditArr[0];
//            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit = self.photoCredit;
//            dic[@"photoCredit"] = self.photoCredit;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoCredit = self.photoCreditArr[0];
//            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit = self.photoCredit;
//            dic[@"photoCredit"] = self.photoCredit;
//
//            self.photoCredit2 = self.photoCreditArr[1];
//            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit2 = self.photoCredit2;
//            dic[@"photoCredit2"] = self.photoCredit2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoCredit = self.photoCreditArr[0];
//            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit = self.photoCredit;
//            dic[@"photoCredit"] = self.photoCredit;
//
//            self.photoCredit2 = self.photoCreditArr[1];
//            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit2 = self.photoCredit2;
//            dic[@"photoCredit2"] = self.photoCredit2;
//
//            self.photoCredit3 = self.photoCreditArr[2];
//            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit3 = self.photoCredit3;
//            dic[@"photoCredit3"] = self.photoCredit3;
//
//        }
//            break;
//        case 4:
//        {
//            self.photoCredit = self.photoCreditArr[0];
//            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit = self.photoCredit;
//            dic[@"photoCredit"] = self.photoCredit;
//
//            self.photoCredit2 = self.photoCreditArr[1];
//            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit2 = self.photoCredit2;
//            dic[@"photoCredit2"] = self.photoCredit2;
//
//            self.photoCredit3 = self.photoCreditArr[2];
//            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit3 = self.photoCredit3;
//            dic[@"photoCredit3"] = self.photoCredit3;
//
//            self.photoCredit4 = self.photoCreditArr[3];
//            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit4 = self.photoCredit4;
//            dic[@"photoCredit4"] = self.photoCredit4;
//
//        }
//            break;
//        case 5:
//        {
//            self.photoCredit = self.photoCreditArr[0];
//            self.photoCredit = [self.photoCredit stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit = self.photoCredit;
//            dic[@"photoCredit"] = self.photoCredit;
//
//            self.photoCredit2 = self.photoCreditArr[1];
//            self.photoCredit2 = [self.photoCredit2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit2 = self.photoCredit2;
//            dic[@"photoCredit2"] = self.photoCredit2;
//
//            self.photoCredit3 = self.photoCreditArr[2];
//            self.photoCredit3 = [self.photoCredit3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit3 = self.photoCredit3;
//            dic[@"photoCredit3"] = self.photoCredit3;
//
//            self.photoCredit4 = self.photoCreditArr[3];
//            self.photoCredit4 = [self.photoCredit4 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit4 = self.photoCredit4;
//            dic[@"photoCredit4"] = self.photoCredit4;
//
//            self.photoCredit5 = self.photoCreditArr[4];
//            self.photoCredit5 = [self.photoCredit5 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoCredit5 = self.photoCredit5;
//            dic[@"photoCredit5"] = self.photoCredit5;
//
//        }
//            break;
//        default:
//            break;
//    }
    
    
    if (self.photoOtherArr.count) {
        for (int i = 0; i < self.photoOtherArr.count; i++) {
            NSString *keyStr = @"";
            NSString *photoOther = [self.photoOtherArr[i] stringByReplacingOccurrencesOfString:@"_min" withString:@""];
            if (i == 0) {
                keyStr = [NSString stringWithFormat:@"photoOther"];
            } else {
                keyStr = [NSString stringWithFormat:@"photoOther%d",i+1];
            }
            [dic setObject:photoOther forKey:keyStr];
        }
    }

//    switch (self.photoOtherArr.count) {
//        case 1:
//        {
//            self.photoOther = self.photoOtherArr[0];
//            self.photoOther = [self.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoOther = self.photoOther;
//            dic[@"photoOther"] = self.photoOther;
//
//        }
//            break;
//        case 2:
//        {
//            self.photoOther = self.photoOtherArr[0];
//            self.photoOther = [self.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoOther = self.photoOther;
//            dic[@"photoOther"] = self.photoOther;
//
//            self.photoOther2 = self.photoOtherArr[1];
//            self.photoOther2 = [self.photoOther2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoOther2 = self.photoOther2;
//            dic[@"photoOther2"] = self.photoOther2;
//
//        }
//            break;
//        case 3:
//        {
//            self.photoOther = self.photoOtherArr[0];
//            self.photoOther = [self.photoOther stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoOther = self.photoOther;
//            dic[@"photoOther"] = self.photoOther;
//
//            self.photoOther2 = self.photoOtherArr[1];
//            self.photoOther2 = [self.photoOther2 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoOther2 = self.photoOther2;
//            dic[@"photoOther2"] = self.photoOther2;
//
//            self.photoOther3 = self.photoOtherArr[2];
//            self.photoOther3 = [self.photoOther3 stringByReplacingOccurrencesOfString:@"_min" withString:@""];
//            self.PhotoModel.photoOther3 = self.photoOther3;
//            dic[@"photoOther3"] = self.photoOther3;
//
//        }
//            break;
//        default:
//            break;
//    }

    
    
    return dic;
}

-(void)GoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    step = 0;
    returnTimeOne = @" ";
    returnTimeTwo = @" ";
    returnTimeThree = @" ";
    returnTimeFour = @" ";
    returnTimeFive = @" ";
    
    returnAddressOne = @" ";
    returnAddressTwo = @" ";
    returnAddressThree = @" ";
    returnAddressFour = @" ";
    
}


-(LocationView*)locaView
{
    if (_locaView == nil)
    {
        _locaView = [[LocationView alloc] init];
        _locaView.frame = self.view.bounds;
        [self.view addSubview:_locaView];
        return _locaView;
    }
    [_locaView reloadData];
    return _locaView;
}


-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [[NSMutableDictionary alloc]init];
    }
    return _dataDic;
}

#pragma mark --TextViewDelegate


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    switch (textView.tag) {
        case 1003:
        {
            [self.dataDic setValue:textView.text forKey:@"xingming"];
            
        }
            break;
        case 1004:
        {
            [self.dataDic setValue:textView.text forKey:@"dianhua"];
            
        }
            break;
        case 1005:
        {
            [self.dataDic setValue:textView.text forKey:@"zhengjian"];
            
        }
            break;
        case 1006:
        {
            [self.dataDic setValue:textView.text forKey:@"qq"];
            
        }
            break;
        case 1007:
        {
            [self.dataDic setValue:textView.text forKey:@"youxiang"];
            
        }
            break;
        case 1008:
        {
            [self.dataDic setValue:textView.text forKey:@"hukoudizhi"];
            
        }
            break;
        case 1009:
        {
            [self.dataDic setValue:textView.text forKey:@"hukouyoubian"];
            
        }
            break;
        case 1010:
        {
            [self.dataDic setValue:textView.text forKey:@"zhuzhaidizhi"];
            
        }
            break;
        case 1011:
        {
            [self.dataDic setValue:textView.text forKey:@"zhuzhaiyoubian"];
            
        }
            break;
        case 1012:
        {
            [self.dataDic setValue:textView.text forKey:@"zhuzhaidianhua"];
            
        }
            break;
        case 1013:
        {
            [self.dataDic setValue:textView.text forKey:@"goumaidanjia"];
            
        }
            break;
        case 1014:
        {
            [self.dataDic setValue:textView.text forKey:@"jianzhumianji"];
            
        }
            break;
        case 1015:
        {
            [self.dataDic setValue:textView.text forKey:@"chanquanbili"];
            
        }
            break;
        case 1016:
        {
            [self.dataDic setValue:textView.text forKey:@"daikuannianxian"];
            
        }
            break;
        case 1017:
        {
            [self.dataDic setValue:textView.text forKey:@"yuegong"];
            
        }
            break;
        case 1018:
        {
            [self.dataDic setValue:textView.text forKey:@"daikuanyue"];
            
        }
            break;
        case 1019:
        {
            [self.dataDic setValue:textView.text forKey:@"goumaijiage"];
            
        }
            break;
        case 1020:
        {
            [self.dataDic setValue:textView.text forKey:@"yuegongdaikuan"];
            
        }
            break;
        case 1021:
        {
            [self.dataDic setValue:textView.text forKey:@"fangchandizhi"];
            
        }
            break;
        case 1022:
        {
            [self.dataDic setValue:textView.text forKey:@"cheliangpinpai"];
            
        }
            break;
        case 1023:
        {
            [self.dataDic setValue:textView.text forKey:@"danweimingcheng"];
            
        }
            break;
        case 1024:
        {
            [self.dataDic setValue:textView.text forKey:@"danweidizhi"];
            
        }
            break;
        case 1025:
        {
            [self.dataDic setValue:textView.text forKey:@"suoshuhangye"];
            
        }
            break;
        case 1026:
        {
            [self.dataDic setValue:textView.text forKey:@"danweidianhua"];
            
        }
            break;
        case 1027:
        {
            [self.dataDic setValue:textView.text forKey:@"suoshubumen"];
            
        }
            break;
        case 1028:
        {
            [self.dataDic setValue:textView.text forKey:@"danrenzhiwei"];
            
        }
            break;
        case 1029:
        {
            [self.dataDic setValue:textView.text forKey:@"yuezongshouru"];
            
        }
            break;
        case 1030:
        {
            [self.dataDic setValue:textView.text forKey:@"faxinri"];
            
        }
            break;
        case 1031:
        {
            [self.dataDic setValue:textView.text forKey:@"peiouxingming"];
            
        }
            break;
        case 1032:
        {
            [self.dataDic setValue:textView.text forKey:@"peioushenfen"];
            
        }
            break;
        case 1033:
        {
            [self.dataDic setValue:textView.text forKey:@"peioudianhua"];
            
        }
            break;
        case 1034:
        {
            [self.dataDic setValue:textView.text forKey:@"peioudanwei"];
            
        }
            break;
        case 1035:
        {
            [self.dataDic setValue:textView.text forKey:@"peioudanweidizhi"];
            
        }
            break;
        case 1036:
        {
            [self.dataDic setValue:textView.text forKey:@"peioudanweidianhua"];
            
        }
            break;
        case 1037:
        {
            [self.dataDic setValue:textView.text forKey:@"peioujuzhudizhi"];
            
        }
            break;
        case 1038:
        {
            [self.dataDic setValue:textView.text forKey:@"qinshuxingming"];
            
        }
            break;
        case 1039:
        {
            [self.dataDic setValue:textView.text forKey:@"qinshuguanxi"];
            
        }
            break;
        case 1040:
        {
            [self.dataDic setValue:textView.text forKey:@"qinshudianhua"];
            
        }
            break;
        case 1041:
        {
            [self.dataDic setValue:textView.text forKey:@"qinshudanwei"];
            
        }
            break;
        case 1042:
        {
            [self.dataDic setValue:textView.text forKey:@"tongshixingming"];
            
        }
            break;
        case 1043:
        {
            [self.dataDic setValue:textView.text forKey:@"tongshizhiwu"];
            
        }
            break;
        case 1044:
        {
            [self.dataDic setValue:textView.text forKey:@"tongshidianhua"];
            
        }
            break;
        case 1045:
        {
            [self.dataDic setValue:textView.text forKey:@"tongshidanwei"];
            
        }
            break;
        case 1046:
        {
            [self.dataDic setValue:textView.text forKey:@"qitaxingming"];
            
        }
            break;
        case 1047:
        {
            [self.dataDic setValue:textView.text forKey:@"qitaguanxi"];
            
        }
            break;
        case 1048:
        {
            [self.dataDic setValue:textView.text forKey:@"qitadianhua"];
            
        }
            break;
        case 1049:
        {
            [self.dataDic setValue:textView.text forKey:@"qitadanwei"];
            
        }
            break;
        case 1050:
        {
            [self.dataDic setValue:textView.text forKey:@"zuyong"];
            
        }
            break;
        case 1051:
        {
            [self.dataDic setValue:textView.text forKey:@"zuyong"];
            
        }
            break;
        case 1052:
        {
            [self.dataDic setValue:textView.text forKey:@"zuyong"];
            
        }
            break;
        case 1053:
        {
            [self.dataDic setValue:textView.text forKey:@"qitazhuzhai"];
            
        }
            break;
        case 1054:
        {
            [self.dataDic setValue:textView.text forKey:@"qitafangchan"];
        }
            break;
        case 1060:
        {
            [self.dataDic setValue:textView.text forKey:@"zhixiaodaikuan"];
        }
            break;
        case 1061:
        {
            [self.dataDic setValue:textView.text forKey:@"gongtongdaikuan"];
        }
            break;
        case 1062:
        {
            [self.dataDic setValue:textView.text forKey:@"xiangxishuoming"];
        }
            break;
        default:
            break;
    }
    
    return YES;
}




#pragma mark --现住宅类型按钮点击事件

-(void)GRBtnOnClick:(UIButton *)sender{
    if (sender.tag == 60)
    {
        
        self.GRCellHeight = 50;
        self.GRName = @"每月租金";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        
        self.tabUHsType = 1;
        
        [_personalInfoTableView reloadData];
        
    }
    else if (sender.tag == 61)
    {
        self.GRCellHeight = 50;
        self.GRName = @"每月还款";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 2;
        
        [_personalInfoTableView reloadData];
        
        
    }
    else if (sender.tag == 62)
    {
        self.GRCellHeight = 50;
        self.GRName = @"每月还款";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 3;
        
        [_personalInfoTableView reloadData];
        
    }
    else if (sender.tag == 67)
    {
        self.GRCellHeight = 50;
        self.GRName = @"其他具体类型";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 8;
        
        [_personalInfoTableView reloadData];
        
        
    }
    else if (sender.tag == 63)
    {
        self.GRCellHeight = 0;
        self.GRName = @"";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 4;
        
        [_personalInfoTableView reloadData];
    }
    else if (sender.tag == 64)
    {
        self.GRCellHeight = 0;
        self.GRName = @"";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 5;
        
        [_personalInfoTableView reloadData];
    }
    
    else if (sender.tag == 65)
    {
        self.GRCellHeight = 0;
        self.GRName = @"";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 6;
        
        [_personalInfoTableView reloadData];
    }
    else if (sender.tag == 66)
    {
        self.GRCellHeight = 0;
        self.GRName = @"";
        
        ButtonsModel * model6 = _buttonArrayOne[5];
        
        model6.index = sender.tag;
        self.tabUHsType = 7;
        
        [_personalInfoTableView reloadData];
    }else{
        self.tabUHsType = 0;
    }
    
    
    
    // [self.personalInfoTableView reloadData];
    
}


#pragma mark --房产类型按钮点击事件
-(void)ZCBtnOnClick:(UIButton *)sender{
    
    if (sender.tag == 73) {
        self.ZCCellHeight = 50;
        self.ZCName = @"其他房产类型";
        ButtonsModel * model7 = _buttonArrayTwo[0];
        
        model7.index = sender.tag;
        self.houseType = 4;
        
        [_assetInfoTableView reloadData];
        
    }else if(sender.tag == 70){
        
        self.ZCCellHeight = 0;
        self.ZCName = @" ";
        
        ButtonsModel * model7 = _buttonArrayTwo[0];
        
        model7.index = sender.tag;
        self.houseType = 1;
        
        [_assetInfoTableView reloadData];
    }
    else if(sender.tag == 71){
        
        self.ZCCellHeight = 0;
        self.ZCName = @" ";
        
        ButtonsModel * model7 = _buttonArrayTwo[0];
        
        model7.index = sender.tag;
        self.houseType = 2;
        
        [_assetInfoTableView reloadData];
    }
    
    else if(sender.tag == 72){
        
        self.ZCCellHeight = 0;
        self.ZCName = @" ";
        
        ButtonsModel * model7 = _buttonArrayTwo[0];
        
        model7.index = sender.tag;
        self.houseType = 3;
        
        [_assetInfoTableView reloadData];
    }else{
        self.houseType = 0;
    }
    
    
}


#pragma mark -- 键盘弹出和消失的通知方法
-(void) keyboardWillShow:(NSNotification *)note{
    [self.navigationController.view addSubview:self.vv];
    self.vv.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.vv addGestureRecognizer:tap];
}
- (void)hideKeyboard {
    
    [self.psTableView endEditing:YES];
    [self.personalInfoTableView endEditing:YES];
    [self.assetInfoTableView endEditing:YES];
    [self.workInfoTableView endEditing:YES];
    [self.cpiTableView endEditing:YES];
    
    [self.vv removeFromSuperview];
}
- (void)keyboardDidHide:(NSNotification *)note{
    [self.vv removeFromSuperview];
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
