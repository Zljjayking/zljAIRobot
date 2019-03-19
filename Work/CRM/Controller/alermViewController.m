//
//  alermViewController.m
//  Financeteam
//
//  Created by Zccf on 16/8/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "alermViewController.h"
#import "alermTableViewCell.h"
#import "alermModel.h"
#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
@interface alermViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,SelectDateTimeDelegate>{
    DateTimeSelectView *_dateTimeSelectView;
}
@property (nonatomic, strong) UITableView *alermTableView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *alermArr;
@property (nonatomic, strong) NSString *whereStr;//判断是哪个选择时间的事件
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *alermDicArr;//拼接
@property (nonatomic, strong) NSString *alerm;//查询到的alerm;
//添加和修改提醒用到的6个控件
@property (nonatomic, strong) UIView *creatAlermView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIButton *ensureBtn;
@property (nonatomic, strong) UILabel *tishiLb;

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSDictionary *dateDic;

@property (nonatomic, strong) NSString *textFieldText;
@property (nonatomic, strong) NSString *timeBtnTitle;

@end
#define DBNAME    @"personinfo.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"
@implementation alermViewController

- (UITableView *)alermTableView {
    if (!_alermTableView) {
        _alermTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight) style:UITableViewStylePlain];
        if (self.ishideNaviView) {
            _alermTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-NaviHeight);
        }
        _alermTableView.delegate = self;
        _alermTableView.dataSource = self;
    }
    return _alermTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提醒";
    self.alermArr = [NSMutableArray array];
    self.alermDicArr = [NSMutableArray array];
    [self initUis];
    [self creatDataBase];
    
    // Do any additional setup after loading the view.
}
- (void)creatDataBase {
    self.db = [FMDatabase databaseWithPath:dataBasePath];
    if ([self.db open]) {
        BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS CRMAlerm (CRMID text, alerm text)"];
        
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
        FMResultSet *resultSet = [self.db executeQuery:@"select * from CRMAlerm where CRMID=?",self.CRMID];
        while ([resultSet next]) {
            self.alerm = [resultSet objectForColumnName:@"alerm"];
//            NSLog(@"name == %@",self.alerm);
        }
        if (self.alerm.length > 0) {
            NSData *JSONArrData = [self.alerm dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *theObject = [[NSMutableArray alloc] init];
            NSError *error = nil;
            theObject = [NSJSONSerialization JSONObjectWithData:JSONArrData options:NSJSONReadingMutableContainers error:&error];
            for (int i = 0; i<theObject.count; i++) {
                NSDictionary *alerm = theObject[i];
                alermModel *model = [alermModel requestWithDic:alerm];
                [self.alermArr addObject:model];
            }
        }
//        NSLog(@"self.alermArr.count == %ld",self.alermArr.count);
    }
    [self.db close];
    [self.alermTableView reloadData];
}
//创建视图
- (void)initUis {
    //alermTableView
    [self.alermTableView registerClass:[alermTableViewCell class] forCellReuseIdentifier:@"alerm"];
    [self.view addSubview:self.alermTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.alermTableView setTableFooterView:view];
    
    
    UIBarButtonItem *one = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"大加号"] style:UIBarButtonItemStylePlain target:self action:@selector(ClickAddAlerm)];
    self.navigationItem.rightBarButtonItem = one;
    self.creatAlermView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.tabBarController.view addSubview:self.creatAlermView];
    self.creatAlermView.alpha = 0.5;
    self.creatAlermView.backgroundColor = [UIColor blackColor];
    self.creatAlermView.hidden = YES;
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 200)];
    [self.tabBarController.view addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius = 10;
    self.centerView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    self.centerView.alpha = 1;
    self.centerView.hidden = YES;
    
    self.tishiLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 60, 30)];
    self.tishiLb.text = @"添加提醒";
    self.tishiLb.textAlignment = NSTextAlignmentCenter;
    self.tishiLb.font = [UIFont systemFontOfSize:16];
    [self.centerView addSubview:self.tishiLb];
    self.tishiLb.textColor = [UIColor grayColor];
    self.tishiLb.center = CGPointMake((kScreenWidth-30)/2.0, 20);
    
    self.titleTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 40)];
    self.titleTF.placeholder = @"请输入备注";
    [self.centerView addSubview:self.titleTF];
    [self.titleTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.titleTF.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleTF.layer.borderWidth = 0.5;
    self.titleTF.delegate = self;
    self.titleTF.textAlignment = NSTextAlignmentCenter;
    self.titleTF.center = CGPointMake((kScreenWidth-30)/2.0, 60);
    self.titleTF.returnKeyType = UIReturnKeyDone;
    
    self.timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeBtn.frame = CGRectMake(0, 0, kScreenWidth-60, 40);
    [self.timeBtn setTitle:@"点击选择时间" forState:UIControlStateNormal];
    [self.timeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.timeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.timeBtn.layer.borderWidth = 0.5;
    [self.centerView addSubview:self.timeBtn];
    [self.timeBtn addTarget:self action:@selector(chooseTime) forControlEvents:UIControlEventTouchUpInside];
    self.timeBtn.center = CGPointMake((kScreenWidth-30)/2.0, 115);
    
    self.ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ensureBtn.frame = CGRectMake(0, 0, 100, 40);
    [self.ensureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    self.ensureBtn.backgroundColor = TABBAR_BASE_COLOR;
    [self.ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.centerView addSubview:self.ensureBtn];
    self.ensureBtn.layer.masksToBounds = YES;
    self.ensureBtn.layer.cornerRadius = 5;
    [self.ensureBtn addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
    self.ensureBtn.center = CGPointMake((kScreenWidth-30)/2.0+((kScreenWidth-30)/2.0)/2.0, 170);
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 100, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = TABBAR_BASE_COLOR;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.centerView addSubview:cancelBtn];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.center = CGPointMake(((kScreenWidth-30)/2.0)/2.0, 170);
    
    // 选择时间界面
    
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.0;
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect];
    _dateTimeSelectView.delegateGetDate = self;
    [self.tabBarController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alermArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *Identifier = @"alerm";
    alermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[alermTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    alermModel *model = self.alermArr[indexPath.row];
    cell.timeLb.text = model.time;
    cell.titleLb.text = [NSString stringWithFormat:@"备注:%@",model.title];
    NSString *time = [NSString stringWithFormat:@"%@",model.time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    //设置一个字符串的时间
    NSMutableString *datestring = [NSMutableString stringWithFormat:@"%@",time];
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
    [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate * newdate = [dm dateFromString:datestring];
    long dd = (long)[newdate timeIntervalSince1970] - [datenow timeIntervalSince1970];
    NSString *timeString=@"";
    if (dd/3600<1 && dd/3600>=0)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/60];
        timeString=[NSString stringWithFormat:@"%@分钟后", timeString];
    }
    if (dd/3600>=1&&dd/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/3600];
        timeString=[NSString stringWithFormat:@"%@小时后", timeString];
    }
    if (dd/86400>=1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/86400];
        timeString=[NSString stringWithFormat:@"%@天后", timeString];
    }
    if (dd < 0) {
        timeString = @"已过期";
    }
    cell.timeLb1.text = timeString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    alermModel *model = self.alermArr[indexPath.row];
    self.timeBtnTitle = model.time;
    self.textFieldText = model.title;
    
    
    JKAlertManager * manager = [[JKAlertManager alloc]initWithPreferredStyle:UIAlertControllerStyleActionSheet title:nil message:nil ];
    [manager configueCancelTitle:@"取消" destructiveIndex:1 otherTitles:@[@"修改",@"删除"]];
    [manager configuePopoverControllerForActionSheetStyleWithSourceView:self.tabBarController.view sourceRect:self.tabBarController.view.bounds popoverArrowDirection:UIPopoverArrowDirectionAny];
    [manager showAlertFromController:self actionBlock:^(JKAlertManager *tempAlertManager, NSInteger actionIndex, NSString *actionTitle) {
        if (actionIndex == 0) {
            self.creatAlermView.hidden = NO;
            self.centerView.hidden = NO;
            [self.timeBtn setTitle:self.timeBtnTitle forState:UIControlStateNormal];
            self.titleTF.text = self.textFieldText;
            self.titleStr = self.textFieldText;
            /*
             NSString *year = self.dateDic[@"year"];
             NSString *month = self.dateDic[@"month"];
             NSString *day = self.dateDic[@"day"];
             NSString *hour = self.dateDic[@"hour"];
             NSString *minute = self.dateDic[@"minute"];
             */
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@",model.yearStr,model.monthStr,model.dayStr];
            NSString *time = [NSString stringWithFormat:@" %@:%@",model.hourStr,model.minuteStr];
            self.dateDic = [NSDictionary dictionaryWithObjects:@[model.yearStr,model.monthStr,model.dayStr,model.hourStr,model.minuteStr,date,time] forKeys:@[@"year",@"month",@"day",@"hour",@"minute",@"date",@"time"]];
            self.whereStr = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        } else if (actionIndex == 1) {
            NSString *key = [NSString stringWithFormat:@"%@%@",self.CRMID,model.time];
            [LocalPushCenter cancleLocalPushWithKey:key];
            [self.alermArr removeObject:model];
            [self.alermTableView reloadData];
            if ([self.db open]) {
                if (self.alermArr.count > 0) {
                    for (int i=0; i<self.alermArr.count; i++) {
                        alermModel *model = self.alermArr[i];
                        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[model.yearStr,model.monthStr,model.dayStr,model.hourStr,model.minuteStr,model.timeStr,model.time,model.title] forKeys:@[@"year",@"month",@"day",@"hour",@"minute",@"timeString",@"time",@"title"]];
                        NSError *parseError = nil;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
                        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"str == %@",str);
                        [self.alermDicArr addObject:str];
                        
                    }
                    NSString *alermStr = [NSString stringWithFormat:@"[%@]",[self.alermDicArr componentsJoinedByString:@","]];
                    BOOL update = [self.db executeUpdate:@"update CRMAlerm set alerm=? where CRMID like ?",alermStr,self.CRMID];
                    if (update) {
                        NSLog(@"更新数据成功");
                    }else{
                        NSLog(@"跟新数据失败");
                    }
                } else {
                    BOOL delete = [_db executeUpdate:@"delete from CRMAlerm where CRMID like ?",self.CRMID];
                    if (delete) {
                        NSLog(@"删除数据成功");
                    }else{
                        NSLog(@"删除数据失败");
                    }
                }
            }
            [self.db close];
        }
    }];
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"删除", nil];
//    actionSheet.tag = indexPath.row+1;
//    [actionSheet showInView:self.view];
//    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"buttonIndex == %ld",buttonIndex);
    NSInteger index = actionSheet.tag - 1;
    alermModel *model = self.alermArr[index];
    if (buttonIndex == 0) {
        self.creatAlermView.hidden = NO;
        self.centerView.hidden = NO;
        [self.timeBtn setTitle:self.timeBtnTitle forState:UIControlStateNormal];
        self.titleTF.text = self.textFieldText;
        self.titleStr = self.textFieldText;
        /*
         NSString *year = self.dateDic[@"year"];
         NSString *month = self.dateDic[@"month"];
         NSString *day = self.dateDic[@"day"];
         NSString *hour = self.dateDic[@"hour"];
         NSString *minute = self.dateDic[@"minute"];
         */
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@",model.yearStr,model.monthStr,model.dayStr];
        NSString *time = [NSString stringWithFormat:@" %@:%@",model.hourStr,model.minuteStr];
        self.dateDic = [NSDictionary dictionaryWithObjects:@[model.yearStr,model.monthStr,model.dayStr,model.hourStr,model.minuteStr,date,time] forKeys:@[@"year",@"month",@"day",@"hour",@"minute",@"date",@"time"]];
        self.whereStr = [NSString stringWithFormat:@"%ld",actionSheet.tag];
    } else if (buttonIndex == 1) {
        NSString *key = [NSString stringWithFormat:@"%@%@",self.CRMID,model.time];
        [LocalPushCenter cancleLocalPushWithKey:key];
        [self.alermArr removeObject:model];
        [self.alermTableView reloadData];
        if ([self.db open]) {
            if (self.alermArr.count > 0) {
                for (int i=0; i<self.alermArr.count; i++) {
                    alermModel *model = self.alermArr[i];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[model.yearStr,model.monthStr,model.dayStr,model.hourStr,model.minuteStr,model.timeStr,model.time,model.title] forKeys:@[@"year",@"month",@"day",@"hour",@"minute",@"timeString",@"time",@"title"]];
                    NSError *parseError = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"str == %@",str);
                    [self.alermDicArr addObject:str];
                    
                }
                NSString *alermStr = [NSString stringWithFormat:@"[%@]",[self.alermDicArr componentsJoinedByString:@","]];
                BOOL update = [self.db executeUpdate:@"update CRMAlerm set alerm=? where CRMID like ?",alermStr,self.CRMID];
                if (update) {
                    NSLog(@"更新数据成功");
                }else{
                    NSLog(@"跟新数据失败");
                }
            } else {
                BOOL delete = [_db executeUpdate:@"delete from CRMAlerm where CRMID like ?",self.CRMID];
                if (delete) {
                    NSLog(@"删除数据成功");
                }else{
                    NSLog(@"删除数据失败");
                }
            }
        }
        [self.db close];
    }
}
#pragma mark --SelectDateTimeDelegate 
- (void)getDate:(NSMutableDictionary *)dictDate {
    self.dateDic = dictDate;
    NSString *time = [NSString stringWithFormat:@"%@%@:00",dictDate[@"date"],dictDate[@"time"]];
    [self.timeBtn setTitle:time forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
    }];
}

- (void)cancelDate {
    [UIView animateWithDuration:0.3 animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
    }];
}
#pragma mark -- 点击添加alerm
- (void)ClickAddAlerm {
    self.titleTF.text = @"";
    [self.timeBtn setTitle:@"点击选择时间" forState:UIControlStateNormal];
    self.dateDic = nil;
    
    self.creatAlermView.hidden = NO;
    self.centerView.hidden = NO;
    
    self.whereStr = @"添加";

}

//点击选择时间
- (void)chooseTime {
    [self.titleTF resignFirstResponder];
    _dateTimeSelectView.hidden = NO;
    self.bgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _dateTimeSelectView.frame = timeViewRect;
    }];
}
//点击确定创建
- (void)ensure {
    [self.titleTF resignFirstResponder];
    if ([self.timeBtn.titleLabel.text isEqualToString:@"点击选择时间"]) {
        [MBProgressHUD showError:@"请选择提醒时间"];
    } else {
        self.creatAlermView.hidden = YES;
        self.centerView.hidden = YES;
        [self.alermDicArr removeAllObjects];
        NSString *year = self.dateDic[@"year"];
        NSString *month = self.dateDic[@"month"];
        NSString *day = self.dateDic[@"day"];
        NSString *hour = self.dateDic[@"hour"];
        NSString *minute = self.dateDic[@"minute"];
        NSString *title = self.titleStr;
        NSString *time = [NSString stringWithFormat:@"%@%@:00",self.dateDic[@"date"],self.dateDic[@"time"]];
        NSLog(@"time == %@",time);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *datenow = [NSDate date];
        //设置一个字符串的时间
        NSMutableString *datestring = [NSMutableString stringWithFormat:@"%@",time];
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
        [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate * newdate = [dm dateFromString:datestring];
        long dd = (long)[newdate timeIntervalSince1970] - [datenow timeIntervalSince1970];
        NSString *timeString=@"";
        if (dd/3600<1 && dd/3600>=0)
        {
            timeString = [NSString stringWithFormat:@"%ld", dd/60];
            timeString=[NSString stringWithFormat:@"%@分钟后", timeString];
        }
        if (dd/3600>=1&&dd/86400<1)
        {
            timeString = [NSString stringWithFormat:@"%ld", dd/3600];
            timeString=[NSString stringWithFormat:@"%@小时后", timeString];
        }
        if (dd/86400>=1)
        {
            timeString = [NSString stringWithFormat:@"%ld", dd/86400];
            timeString=[NSString stringWithFormat:@"%@天后", timeString];
        }
        if (dd < 0) {
            timeString = @"已过期";
        }
        if ([self.whereStr isEqualToString:@"添加"]) {
            NSLog(@"执行了添加");
            alermModel *model = [alermModel new];
            model.yearStr = year;
            model.monthStr = month;
            model.dayStr = day;
            model.hourStr = hour;
            model.minuteStr = minute;
            model.timeStr = timeString;
            model.time = time;
            model.title = title;
            [self.alermArr addObject:model];
            if ([self.db open]) {
                for (int i=0; i<self.alermArr.count; i++) {
                    alermModel *model = self.alermArr[i];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[model.yearStr,model.monthStr,model.dayStr,model.hourStr,model.minuteStr,model.timeStr,model.time,model.title] forKeys:@[@"year",@"month",@"day",@"hour",@"minute",@"timeString",@"time",@"title"]];
                    NSError *parseError = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"str == %@",str);
                    [self.alermDicArr addObject:str];
                }
                NSString *alermStr = [NSString stringWithFormat:@"[%@]",[self.alermDicArr componentsJoinedByString:@","]];
                FMResultSet *resultSet = [self.db executeQuery:@"select * from CRMAlerm where CRMID=?",self.CRMID];
                NSString *alerm = [resultSet objectForColumnName:@"CRMID"];
                if ([alerm isEqual:[NSNull null]]) {
                    BOOL insert = [self.db executeUpdate:@"INSERT INTO CRMAlerm(CRMID,alerm) VALUES(?,?)",self.CRMID,alermStr];
                    if (insert) {
                        NSLog(@"插入数据成功");
                    }else{
                        NSLog(@"插入数据失败");
                    }
                } else {
                    BOOL update = [self.db executeUpdate:@"UPDATE CRMAlerm SET alerm=? WHERE CRMID=?",alermStr,self.CRMID];
                    if (update) {
                        NSLog(@"更新数据成功");
                    }else{
                        NSLog(@"跟新数据失败");
                    }
                }
            }
            [self.db close];
            NSDate *alermTime = [LocalPushCenter fireDateWithYear:[year integerValue] month:[month integerValue] day:[day integerValue] week:0 hour:[hour integerValue] minute:[minute integerValue] second:0];
            NSString *key = [NSString stringWithFormat:@"%@%@",self.CRMID,time];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"响铃" forKey:key];
            NSString *title = [NSString stringWithFormat:@"%@需要您处理",model.title];
            [LocalPushCenter localPushForDate:alermTime forKey:nil alertBody:@"温馨提醒" alertAction:title soundName:@"布谷鸟.caf" launchImage:nil userInfo:dic badgeCount:1 repeatInterval:0];
        } else if ([self.whereStr integerValue] > 0) {
            NSLog(@"执行了修改");
            NSInteger index = [self.whereStr integerValue] - 1;
            alermModel *model = self.alermArr[index];
            model.yearStr = year;
            model.monthStr = month;
            model.dayStr = day;
            model.hourStr = hour;
            model.minuteStr = minute;
            model.timeStr = timeString;
            model.time = time;
            model.title = title;
            if ([self.db open]) {
                for (int i=0; i<self.alermArr.count; i++) {
                    alermModel *model = self.alermArr[i];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[model.yearStr,model.monthStr,model.dayStr,model.hourStr,model.minuteStr,model.timeStr,model.time,model.title] forKeys:@[@"year",@"month",@"day",@"hour",@"minute",@"timeString",@"time",@"title"]];
                    NSError *parseError = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"str == %@",str);
                    [self.alermDicArr addObject:str];
                }
                NSString *alermStr = [NSString stringWithFormat:@"[%@]",[self.alermDicArr componentsJoinedByString:@","]];
                //            FMResultSet *resultSet = [self.db executeQuery:@"select * from CRMAlerm where CRMID=?;",[NSNumber numberWithInteger:*(self.CRMID)]];
                //            NSString *alerm = [resultSet objectForColumnName:@"alerm"];
                BOOL update = [self.db executeUpdate:@"update CRMAlerm set alerm=? where CRMID=?",alermStr,self.CRMID];
                if (update) {
                    NSLog(@"更新数据成功");
                }else{
                    NSLog(@"更新数据失败");
                }
            }
            [self.db close];
            NSDate *alermTime = [LocalPushCenter fireDateWithYear:[year integerValue] month:[month integerValue] day:[day integerValue] week:0 hour:[hour integerValue] minute:[minute integerValue] second:0];
            NSString *key = [NSString stringWithFormat:@"%@%@",self.CRMID,time];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"响铃" forKey:key];
            NSString *title = [NSString stringWithFormat:@"%@需要您处理",model.title];
            [LocalPushCenter localPushForDate:alermTime forKey:nil alertBody:@"温馨提醒" alertAction:title soundName:@"布谷鸟.caf" launchImage:nil userInfo:dic badgeCount:1 repeatInterval:0];
        }
        
        [self.alermTableView reloadData];
        
    }
}

#pragma mark == textFieldDelegate;
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    }];
    _dateTimeSelectView.hidden = YES;
    self.bgView.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.titleStr = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
}
//取消按钮点击事件
- (void)cancelBtn {
    [self.titleTF resignFirstResponder];
    self.creatAlermView.hidden = YES;
    self.centerView.hidden = YES;
    [self cancelDate];
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
