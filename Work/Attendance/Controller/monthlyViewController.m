//
//  monthlyViewController.m
//  Financeteam
//
//  Created by Zccf on 2017/6/19.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "monthlyViewController.h"

#import "MaterialsHeadView.h"
#import "ItemViewCell.h"
#import "PotionCell.h"
//模型
#import "CompoundViewModel.h"
#import "RowNameList.h"
#import "CellContents.h"
#import "ChildCellModels.h"
#import "ColumnNamesList.h"
#import "CellContents.h"
#import "RowModels.h"
#import "UIView+GoodView.h"
#import "MPublicManager.h"
#import "HttpRequestEngine.h"
#import "monthlyModel.h"
#import "rankingModel.h"
#import "MonthlyBaseModel.h"
#import "LoginPeopleModel.h"
#define SCREEN  [UIScreen mainScreen].bounds.size
#define Color_RGB(r,g,b,a) ([UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)])
@interface monthlyViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ItemViewCellDelegate,MaterialsHeadViewDelegate>{
    UITableView        * _scoreTableView;
    UITableView        * _leftTableView;
    NSMutableArray     * _dataArray;
    NSIndexPath        * _indexPath;//记录点击的行
    CGRect               _selectFrame;//记录点击的那个Item的frame
    MaterialsHeadView  * _topView;
    CompoundViewModel  *  _compoundListModel;
    UIScrollView       * _bgeScrollView;//低部ScrollView
    BOOL               _scoreTableViewIsRolling,
    _leftTableViewIsRolling,
    _backgroundScrolViewIsRolling;
}
@property (nonatomic, strong) UIButton *contentBtn;//应出勤天数

@property (nonatomic, strong) NSString *mech_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *dept_id;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *bangArr;//早到榜
@property (nonatomic, strong) NSMutableArray *bangArrLate;//迟到榜
@property (nonatomic, strong) LoginPeopleModel *myInfoModel;
@property (nonatomic, strong) MonthlyBaseModel *baseModel;
@end

@implementation monthlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myInfoModel = [LoginPeopleModel requestWithDic:[LocalMeManager sharedPersonalInfoManager].loginPeopleInfo];
    self.mech_id = [NSString stringWithFormat:@"%ld",self.myInfoModel.jrqMechanismId];
    self.user_id = [NSString stringWithFormat:@"%ld",self.myInfoModel.userId];
    self.dept_id = [NSString stringWithFormat:@"%@",self.myInfoModel.dept_id];
    self.time = [NSString stringWithFormat:@"%@",[Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM"]];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.bangArr = [NSMutableArray arrayWithCapacity:0];
    self.bangArrLate = [NSMutableArray arrayWithCapacity:0];
//    [self requestData];
    
    self.dateChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.dateChooseBtn];
    [self.dateChooseBtn setImage:[UIImage imageNamed:@"tongJiRiLi"] forState:UIControlStateNormal];
    [self.dateChooseBtn setTitle:[NSString stringWithFormat:@" %@",[Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM"]] forState:UIControlStateNormal];
    self.dateChooseBtn.titleLabel.font = [UIFont systemFontOfSize:16];//dbdbdb   cdcdcd
    [self.dateChooseBtn setTitleColor:GRAY50 forState:UIControlStateNormal];
    [self.dateChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-30*KAdaptiveRateWidth);
        make.top.equalTo(self.view.mas_top).offset(6*KAdaptiveRateWidth);
        make.height.mas_equalTo(30);
    }];
    [self.dateChooseBtn addTarget:self action:@selector(dateChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *down = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头（下）"]];
    [self.view addSubview:down];
    [down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12*KAdaptiveRateWidth);
        make.centerY.equalTo(self.dateChooseBtn.mas_centerY);
        make.height.mas_equalTo(7);
        make.width.mas_equalTo(12);
    }];
    
    UILabel *leftLB = [[UILabel alloc]init];
    [self.view addSubview:leftLB];
    leftLB.textColor = GRAY70;
    leftLB.text = @"应出勤";
    leftLB.font = customFont(15);
    [leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.dateChooseBtn.mas_centerY);
    }];
    
    self.contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentBtn setBackgroundImage:[UIImage imageNamed:@"monthCircle"] forState:UIControlStateNormal];
    
    [self.contentBtn setTitleColor:GRAY70 forState:UIControlStateNormal];
    self.contentBtn.titleLabel.font = customFont(15);
    [self.view addSubview:self.contentBtn];
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLB.mas_right).offset(2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.centerY.equalTo(self.dateChooseBtn.mas_centerY);
    }];
    
    UILabel *rightLB = [[UILabel alloc]init];
    [self.view addSubview:rightLB];
    rightLB.textColor = GRAY70;
    rightLB.text = @"天";
    rightLB.font = customFont(15);
    [rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentBtn.mas_right).offset(2);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.dateChooseBtn.mas_centerY);
    }];
    
    
    UIButton *bang1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bang1];
    [bang1 addTarget:self action:@selector(bangOneClick:) forControlEvents:UIControlEventTouchUpInside];
    [bang1 setBackgroundImage:[UIImage imageNamed:@"zaodaobang"] forState:UIControlStateNormal];
    [bang1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60*KAdaptiveRateWidth);
        make.height.mas_equalTo(60*KAdaptiveRateWidth);
        make.top.equalTo(self.dateChooseBtn.mas_bottom).offset(12*KAdaptiveRateWidth);
        make.centerX.equalTo(self.view.mas_centerX).offset(-70);
    }];
    
    UIButton *bang2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bang2];
    [bang2 addTarget:self action:@selector(bangTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bang2 setBackgroundImage:[UIImage imageNamed:@"lateBang"] forState:UIControlStateNormal];
    [bang2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60*KAdaptiveRateWidth);
        make.height.mas_equalTo(64*KAdaptiveRateWidth);
        make.top.equalTo(self.dateChooseBtn.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.centerX.equalTo(self.view.mas_centerX).offset(70);
    }];
    
    // Do any additional setup after loading the view.
}
- (void)reloadData {
    [MBProgressHUD showMessage:@""];
    self.time = [self.dateChooseBtn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [HttpRequestEngine getMonthlyStatisticsWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
        
        if ([Utils isBlankString:errorStr]) {
            [MBProgressHUD hideHUD];
            NSArray *dataArr = obj;
            if (dataArr.count) {
                [self.dataArr removeAllObjects];
                for (int i = 0; i<dataArr.count; i++) {
                    NSDictionary *dic = dataArr[i];
                    monthlyModel *model = [monthlyModel requestWithDic:dic];
                    [self.dataArr addObject:model];
                }
                
                [HttpRequestEngine getMonthAttendanceRankingWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
                    if ([Utils isBlankString:errorStr]) {
                        [self.bangArr removeAllObjects];
                        NSArray *dataArr = obj;
                        for (int i=0; i<dataArr.count; i++) {
                            NSDictionary *dic = dataArr[i];
                            rankingModel *model = [rankingModel requestWithDic:dic];
                            if ([model.count integerValue]>0) {
                                [self.bangArr addObject:model];
                            }
                        }
                    }
                }];
                
                for (monthlyModel *model in self.dataArr) {
                    if ([model.late_time integerValue] > 0) {
                        [self.bangArrLate addObject:model];
                    }
                }
                if (self.bangArrLate.count) {
                    for (int i = 0; i<self.bangArrLate.count-1; ++i) {
                        for (int j=0; j<self.bangArrLate.count-i-1; ++j) {
                            monthlyModel *model1 = self.bangArrLate[j];
                            monthlyModel *model2 = self.bangArrLate[j+1];
                            if ([model1.late_time intValue] < [model2.late_time intValue]) {
                                monthlyModel* tempModel = model1;
                                [self.bangArrLate replaceObjectAtIndex:j withObject:model2];
                                [self.bangArrLate replaceObjectAtIndex:j+1 withObject:tempModel];
                            }
                        }
                    }
                }
                
                [self initData];
                [_leftTableView removeFromSuperview];
                [_scoreTableView removeFromSuperview];
                [_bgeScrollView removeFromSuperview];
                [_topView removeFromSuperview];
                [self uiConfigure];
                
                
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }
    }];
    [HttpRequestEngine getMonthlyBaseDataWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
        [MBProgressHUD hideHUD];
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dataDic = obj;
            self.baseModel = [MonthlyBaseModel requestWithDic:dataDic];
            [self.contentBtn setTitle:self.baseModel.Normal forState:UIControlStateNormal];
        } else {
//            [MBProgressHUD showError:errorStr];
        }
    }];

}
- (void)requestData {
    [MBProgressHUD showMessage:@""];
    [HttpRequestEngine getMonthlyStatisticsWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            [MBProgressHUD hideHUD];
            NSArray *dataArr = obj;
            if (dataArr.count) {
                [self.dataArr removeAllObjects];
                for (int i = 0; i<dataArr.count; i++) {
                    NSDictionary *dic = dataArr[i];
                    monthlyModel *model = [monthlyModel requestWithDic:dic];
                    [self.dataArr addObject:model];
                }
                [HttpRequestEngine getMonthAttendanceRankingWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
                    if ([Utils isBlankString:errorStr]) {
                        [self.bangArr removeAllObjects];
                        NSArray *dataArr = obj;
                        for (int i=0; i<dataArr.count; i++) {
                            NSDictionary *dic = dataArr[i];
                            rankingModel *model = [rankingModel requestWithDic:dic];
                            if ([model.count integerValue]) {
                                [self.bangArr addObject:model];
                            }
                        }
                    }
                }];
                for (monthlyModel *model in self.dataArr) {
                    if ([model.late_time integerValue] > 0) {
                        [self.bangArrLate addObject:model];
                    }
                }
                if (self.bangArrLate.count) {
                    for (int i = 0; i<self.bangArrLate.count-1; ++i) {
                        for (int j=0; j<self.bangArrLate.count-i-1; ++j) {
                            monthlyModel *model1 = self.bangArrLate[j];
                            monthlyModel *model2 = self.bangArrLate[j+1];
                            if ([model1.late_time intValue] < [model2.late_time intValue]) {
                                monthlyModel* tempModel = model1;
                                [self.bangArrLate replaceObjectAtIndex:j withObject:model2];
                                [self.bangArrLate replaceObjectAtIndex:j+1 withObject:tempModel];
                            }
                        }
                    }
                }
                [self initData];
                [self uiConfigure];
                UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"signMark"]];
                [self.view addSubview:imageV];
                imageV.frame = CGRectMake(5, _topView.bottom+SCREEN.height-_topView.height-114*KAdaptiveRateWidth-140+8, 15, 15);
                
                UILabel *signLB = [[UILabel alloc]initWithFrame:CGRectMake(23, _topView.bottom+SCREEN.height-_topView.height-114*KAdaptiveRateWidth-76-NaviHeight, kScreenWidth-30, 30)];
                if (IS_IPHONE_X) {
                    signLB.frame = CGRectMake(23, _topView.bottom+SCREEN.height-_topView.height-114*KAdaptiveRateWidth-85-NaviHeight, kScreenWidth-30, 30);
                }
                [self.view addSubview:signLB];
                signLB.textColor = UIColorFromRGB(0xbfbfbf, 1);
                signLB.font = [UIFont systemFontOfSize:10];
                signLB.numberOfLines = 0;
                signLB.text = @"月报统计日期如果是当前日期，统计数据为本月一号至当前日期前一天的统计数据，如果是之前月份，则为整月统计数据。";
                [self isAddFoontView];
            }
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:errorStr];
        }
        
    }];
    [HttpRequestEngine getMonthlyBaseDataWithMech_id:self.mech_id user_id:self.user_id dept_id:self.dept_id time:self.time completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSDictionary *dataDic = obj;
            self.baseModel = [MonthlyBaseModel requestWithDic:dataDic];
            [self.contentBtn setTitle:self.baseModel.Normal forState:UIControlStateNormal];
        } else {
//            [MBProgressHUD showError:errorStr];
        }
    }];
}

#pragma mark == 早到榜 迟到榜 点击方法
- (void)bangOneClick:(UIButton *)sender {
    self.clickBangOne(self.bangArr);
}
- (void)bangTwoClick:(UIButton *)sender {
    self.clickBangTwo(self.bangArrLate);
}
- (void)initData {
    int Rows = (int)self.dataArr.count;
    _compoundListModel = [[CompoundViewModel alloc] init];
    _compoundListModel.ColumnNamesList=[[NSMutableArray alloc] init];
    _compoundListModel.RowNameList=[[NSMutableArray alloc] init];
    _compoundListModel.RowModels=[[NSMutableArray alloc] init];
    //药剂列表
    for (int i=0; i<self.dataArr.count; i++) {
        monthlyModel *model = self.dataArr[i];
        RowNameList * rowNameListModel = [[RowNameList alloc] init];
        rowNameListModel.RowName=[NSString stringWithFormat:@"%@",model.name];
        [_compoundListModel.RowNameList addObject:rowNameListModel];
    }
    //头
    NSArray * weedsArray = @[@"出勤(天)",@"迟到(次)",@"早退(次)",@"缺勤(天)",@"外勤(小时)",@"加班(小时)",@"出差(天)",@"请假(天)",@"旷工(天)"];
    //头宽度
    NSArray * doseArray = @[@"4",@"4",@"4",@"4",@"4",@"4",@"4",@"4",@"4"];
    ///
    for (int i=0; i<weedsArray.count; i++) {
        ColumnNamesList * columnNamesListModel = [[ColumnNamesList alloc] init];
        columnNamesListModel.ChildList=[[NSMutableArray alloc] init];
        int number =[doseArray[i] intValue];
        for (int a=0; a<number; a++) {
            int content = arc4random()%10;
            [columnNamesListModel.ChildList addObject:[NSString stringWithFormat:@"%d",content]];
        }
        columnNamesListModel.ColumnName=weedsArray[i];
        [_compoundListModel.ColumnNamesList addObject:columnNamesListModel];
    }
    //每一行 每一组 的评分
    for (int i=0; i<Rows; i++) {
        RowModels * rowModelsModel = [[RowModels alloc] init];
        rowModelsModel.ChildCellModels=[[NSMutableArray alloc] init];
        monthlyModel *monthModel = self.dataArr[i];
        NSDictionary *dataDic = monthModel.dataDic;
        for (int c=0; c<weedsArray.count; c++) {
            NSString *str = weedsArray[c];
            ChildCellModels * model = [[ChildCellModels alloc] init];
            model.CellContents=[[NSMutableArray alloc] init];
            model.count = [dataDic objectForKey:str];
            
            int number =[doseArray[c] intValue];
            for (int b=0;b<number;b++) {
                CellContents * cellContentsModel = [[CellContents alloc] init];
                int content = arc4random()%10;
                cellContentsModel.Content=[NSString stringWithFormat:@"%d",content];
                [model.CellContents addObject:cellContentsModel];
            }
            
            [rowModelsModel.ChildCellModels addObject:model];
        }
        [_compoundListModel.RowModels addObject:rowModelsModel];
    }
    
    
}
- (void)addtopView {
    _topView = [[MaterialsHeadView alloc] initWithFrame:CGRectMake(0, 120*KAdaptiveRateWidth, SCREEN.width, 35) withCompoundViewModel:_compoundListModel];
    _topView.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    _topView.delegate=self;
    [self.view addSubview:_topView];
}
- (void)uiConfigure {
    [self addtopView];
    ///tableView 宽
    CGFloat tableViewWidth=[self tableViewWidthWithCompoundListModel:_compoundListModel];
    ///行高
    CGFloat rowHeiht=35;
    _leftTableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, _topView.bottom, 70, SCREEN.height-_topView.height-114*KAdaptiveRateWidth-140)];
    _leftTableView.delegate=self;
    _leftTableView.dataSource=self;
    _leftTableView.bounces=NO;
    _leftTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _leftTableView.showsVerticalScrollIndicator=NO;
    _leftTableView.rowHeight=rowHeiht;
    [self.view addSubview:_leftTableView];
    
    _bgeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(70, _topView.bottom, SCREEN.width-70, SCREEN.height-_topView.height-114*KAdaptiveRateWidth-140)];
    _bgeScrollView.bounces=NO;
    _bgeScrollView.delegate=self;
    _bgeScrollView.showsVerticalScrollIndicator = NO;
    _bgeScrollView.showsHorizontalScrollIndicator = NO;
    _bgeScrollView.backgroundColor = VIEW_BASE_COLOR;
    _bgeScrollView.contentSize=CGSizeMake(tableViewWidth, SCREEN.height-_topView.height-114*KAdaptiveRateWidth-140);
    [self.view addSubview:_bgeScrollView];
    
    _scoreTableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableViewWidth, _bgeScrollView.height)];
    _scoreTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _scoreTableView.delegate=self;
    _scoreTableView.dataSource=self;
    _scoreTableView.bounces=NO;
    _scoreTableView.showsVerticalScrollIndicator=NO;
    _scoreTableView.rowHeight=rowHeiht;
    [_bgeScrollView addSubview:_scoreTableView];
    
    
    
}

#pragma mark 计算内容宽度
-(CGFloat)tableViewWidthWithCompoundListModel:(CompoundViewModel *)CompoundViewModel {
    CGFloat with=0;
    for (ColumnNamesList *model in _compoundListModel.ColumnNamesList) {
        CGSize RowNameSize = [MPublicManager workOutSizeWithStr:model.ColumnName andFont:[UIFont systemFontOfSize:13] value:[NSValue valueWithCGSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]];
        //评分label宽度
        CGFloat scoreLabelWith=15;
        CGFloat tiemWidth=0;
        ///label个数
        NSInteger labelNumber =model.ChildList.count;
        tiemWidth=(scoreLabelWith*labelNumber)+((labelNumber-1)*2)+10;
        with+=MAX(RowNameSize.width+10, tiemWidth);
    }
    int totalWidth=SCREEN.width-70;
    if (with<totalWidth && _compoundListModel.ColumnNamesList.count==1) {
        return totalWidth;
    } else if (with<totalWidth){
        return totalWidth;
    }
    return with;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _compoundListModel.RowNameList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_scoreTableView) {
        static NSString * identofier = @"scoreCellId";
        ItemViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identofier];
        if (!cell) {
            cell=[[ItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identofier withItem:_compoundListModel indexPath:indexPath];
            cell.delegate=self;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.indexPath=indexPath;
        cell.selectedItemFrame=_selectFrame;
//        [cell reloadItemWithModel:_compoundListModel];
        if (_indexPath.row==indexPath.row) {
            cell.type=CellDefaultType;
        } else {
            cell.type=CellDefaultType;
        }
//        cell.CompoundViewModel=_compoundListModel;
        return cell;
        
    } else {
        static NSString * identofier = @"rightCellId";
        PotionCell * cell =[tableView dequeueReusableCellWithIdentifier:identofier];
        if (!cell) {
            cell=[[PotionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identofier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        }
        RowNameList *model =_compoundListModel.RowNameList[indexPath.row];
        cell.contentStr=model.RowName;
        if (_indexPath.row==indexPath.row) {
            cell.isSelected=NO;
        } else {
            cell.isSelected=NO;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_leftTableView) {
        _indexPath =indexPath;
        [_scoreTableView reloadData];
        [_leftTableView reloadData];
    }
}
#pragma mark MaterialsHeadViewDelegate
- (void)topViewClick:(CGRect)selectedFrame {
    _selectFrame=selectedFrame;
    [_scoreTableView reloadData];
}
- (void)topScrollViewContentOffset:(CGPoint)Offset IsRolling:(BOOL)isRolling{
    if (isRolling) {
        _backgroundScrolViewIsRolling=NO;
        [_bgeScrollView setContentOffset:Offset animated:NO];
    }
}

#pragma mark scrollViewWillBeginDragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView==_scoreTableView) {
        _scoreTableViewIsRolling=YES;
        _leftTableViewIsRolling=NO;
    }
    if (scrollView == _leftTableView) {
        _scoreTableViewIsRolling=NO;
        _leftTableViewIsRolling=YES;
    }
    if (scrollView==_bgeScrollView) {
        _backgroundScrolViewIsRolling=YES;
        _topView.isRolling=NO;
    }
}
#pragma mark ScrollViewDidScrol
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //左右滑动
    if (scrollView==_bgeScrollView &&  _backgroundScrolViewIsRolling) {
        [_topView setHeaderScrollViewContentOffset:scrollView.contentOffset];
    }
    //上下滑动
    if (scrollView==_scoreTableView && _scoreTableViewIsRolling) {
        [_leftTableView setContentOffset:scrollView.contentOffset animated:NO];
    }
    //滑动左边tableview
    if (scrollView == _leftTableView && _leftTableViewIsRolling) {
        [_scoreTableView setContentOffset:scrollView.contentOffset animated:NO];
    }
    
}
#pragma mark ItemViewCellDelegate 点击 获取详情数据
- (void)tapClickItemFrame:(CGRect )ItemFrameframe withIndexPath:(NSIndexPath *)indexPath TransverseRow:(int)transverseRow {
    //    _indexPath=indexPath;
    //    _selectFrame=ItemFrameframe;
    //    _topView.selectedFrame=ItemFrameframe;
    //    [_scoreTableView reloadData];
    //    [_leftTableView reloadData];
}


#pragma mark
- (void)isAddFoontView {
    int rows = (int)_compoundListModel.RowNameList.count;
    int rowHeight =rows*44;
    if (rowHeight> _leftTableView.height) {
//        _leftTableView.tableFooterView=[self addFootViewIsLeftTableView:YES];
//        _scoreTableView.tableFooterView=[self addFootViewIsLeftTableView:NO];
    }
}
- (UIView *)addFootViewIsLeftTableView:(BOOL)isLeftTableView {
    CGFloat width =[self tableViewWidthWithCompoundListModel:_compoundListModel];
    if (isLeftTableView) {
        width=_leftTableView.width;
    }
    UIView * footView  =[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    footView.backgroundColor=[UIColor whiteColor];
    //横线
    UIView * lineViwe = [[UIView alloc] initWithFrame:CGRectMake(0, 15, width, 0.5)];
    lineViwe.backgroundColor=Color_RGB(217, 217, 217, 1);
    [footView addSubview:lineViwe];
    
    if (!isLeftTableView) {
        UILabel * footLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN.width/2-50-70, 0, 100, 30)];
        footLabel.backgroundColor=[UIColor whiteColor];
        footLabel.text=@"我是有底线的";
        footLabel.font=[UIFont systemFontOfSize:13];
        footLabel.textColor=[[UIColor darkTextColor] colorWithAlphaComponent:0.4];
        footLabel.textAlignment=NSTextAlignmentCenter;
        //        [footView addSubview:footLabel];
    }
    return footView;
}
- (void)dateChooseBtnClick:(UIButton *)sender {
    self.showDate();
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
