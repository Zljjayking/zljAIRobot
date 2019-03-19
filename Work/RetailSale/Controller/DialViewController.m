//
//  DialViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/8/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "DialViewController.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>

@interface DialViewController ()

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSMutableDictionary * dataDic;

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString *dateStr;//拨号日期
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *phoneNumberStr;
@property (nonatomic, strong) NSString *phoneNumber;//号码
@property (nonatomic, strong) NSString *Name;//姓名
@property (nonatomic, strong) NSString *record;//查询到的纪录
// 初始化用户界面
- (void)initializeUserInterface;
// 电话按钮点击
- (void)handleSpecailButtonWithText:(NSString *)text;
// 数字按钮点击
- (void)handleButtonEvent:(UIButton *)sender;
// 增加按钮点击
- (void)handleAddButtonEvent:(UIButton *)sender;
// 删除按钮点击
- (void)handleDeleteButtonEvent:(UIButton *)sender;

@end

@implementation DialViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
    
    [self creatDataBase];
    [self initializeUserInterface];
   
}
//创建数据库
- (void)creatDataBase {
    self.db = [FMDatabase databaseWithPath:dataBasePath];
    if ([self.db open]) {
        //phoneNumber 通话记录号码  date 拨号日期   isConnect 是否接通  time 接通时长
        BOOL result=[self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS CallRecords (phoneNumber text, date text,name text)"];
        
        if (!result) {
            NSLog(@"fail to create table");
        }else {
            NSLog(@"create table success");
        }
    }else{
        NSLog(@"fail to open");
    }
    [self.db close];
}

- (void)initializeUserInterface
{
    
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 64, CGRectGetWidth(self.view.bounds)-100, 40)];
    // 设置用户交互
    phoneTextField.userInteractionEnabled = NO;
  //  phoneTextField.backgroundColor = [UIColor yellowColor];
    // 设置字体
    phoneTextField.font = [UIFont systemFontOfSize:30];
    // 设置对其方式
    phoneTextField.textColor = [UIColor whiteColor];
    phoneTextField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    
    
    NSArray *dataSource = @[@"1", @"2", @"3",
                            @"4", @"5", @"6",
                            @"7", @"8", @"9",
                            @"*", @"0", @"#"];
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 3; j ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.backgroundColor = [UIColor clearColor];
            // 设置坐标
            [button setFrame:CGRectMake((kScreenWidth-210*KAdaptiveRateWidth)/4.0 + j * (70*KAdaptiveRateWidth+(kScreenWidth-210*KAdaptiveRateWidth)/4.0), i * 80*KAdaptiveRateWidth + 150*KAdaptiveRateWidth, 70*KAdaptiveRateWidth, 70*KAdaptiveRateWidth)];
            // 设置标题
            [button setTitle:dataSource[3 * i + j] forState:UIControlStateNormal];
            // 设置标题颜色
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // 设置字体大小
            button.titleLabel.font = [UIFont systemFontOfSize:25*KAdaptiveRateWidth];
            
            button.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
            button.layer.borderWidth = 2.0;
            button.layer.cornerRadius = 35.0*KAdaptiveRateWidth;
            
            button.showsTouchWhenHighlighted = YES;
            
            // 添加事件
            [button addTarget:self
                       action:@selector(handleButtonEvent:)
             forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }
    
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton setBackgroundImage:
     [UIImage imageNamed:@"icon_voip_free_call"]
                          forState:UIControlStateNormal];
    [callButton setBounds:CGRectMake(0, 0, 60, 60)];
    [callButton setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight-50)];
    [callButton addTarget:self
                   action:@selector(handleCallButtonEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callButton];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"GoBack"] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(20, 70, 30, 30)];
    [addButton addTarget:self
                  action:@selector(handleAddButtonEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
 //   deleteButton.hidden = YES;
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"椭圆-8"] forState:UIControlStateNormal];
    [deleteButton setFrame:CGRectMake(kScreenWidth-50, 70, 30, 30)];
    [deleteButton addTarget:self action:@selector(handleDeleteButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    self.addButton = addButton;
    self.deleteButton = deleteButton;
    
}

// 电话按钮点击
- (void)handleSpecailButtonWithText:(NSString *)text
{
    if (text.length > 0) {
       // self.addButton.hidden = NO;
       // self.deleteButton.hidden = NO;
    } else {
      //  self.addButton.hidden = YES;
       // self.deleteButton.hidden = YES;
    }
}

#pragma mark - UIButtonEvent methods

- (void)handleButtonEvent:(UIButton *)sender
{
    
    NSString *text = sender.titleLabel.text;
    self.phoneTextField.text = [self.phoneTextField.text stringByAppendingString:text];
    
    [self handleSpecailButtonWithText:self.phoneTextField.text];
}

- (void)handleCallButtonEvent:(UIButton *)sender
{
    if (self.phoneTextField.text.length > 0) {
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
        self.dateStr=[dateformatter stringFromDate:senddate];
        
        self.phoneNumber = self.phoneTextField.text;
        
        if (self.Name.length == 0) {
            self.Name = @" ";
        }
        if ([self.db open]) {
            FMResultSet *resultSet = [self.db executeQuery:@"select * from CallRecords where phoneNumber=?",self.phoneNumber];
            while ([resultSet next]){
                self.record = [resultSet objectForColumnName:@"phoneNumber"];
            }
            if ([self.record isEqual:[NSNull null]] || self.record == nil || self.record.length == 0) {
                BOOL insert = [self.db executeUpdate:@"INSERT INTO CallRecords(phoneNumber,date,name) VALUES(?,?,?)",self.phoneNumber,self.dateStr,self.Name];
                if (insert) {
                    NSLog(@"插入数据成功");
                }else{
                    NSLog(@"插入数据失败");
                }
            } else {
                BOOL update = [self.db executeUpdate:@"UPDATE CallRecords SET date=?,name=? WHERE phoneNumber=?",self.dateStr,self.Name,self.phoneNumber];
//                BOOL update1 = [self.db executeUpdate:@"UPDATE CallRecords SET name=? WHERE phoneNumber=?",self.Name,self.phoneNumber];
                if (update) {
                    NSLog(@"更新数据成功");
                }else{
                    NSLog(@"更新数据失败");
                }
//                if (update1) {
//                    NSLog(@"更新数据成功");
//                }else{
//                    NSLog(@"更新数据失败");
//                }
            }
        }
        [self.db close];
        
        
        DetailViewController * detailVC = [[DetailViewController alloc] init];
        // 传值
        detailVC.phoneNumber = self.phoneTextField.text;
        // 推送
        [self presentViewController:detailVC animated:YES completion:nil];
  
        
    }
    
}

- (void)handleAddButtonEvent:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleDeleteButtonEvent:(UIButton *)sender
{
    NSString *text = self.phoneTextField.text;
    if (text.length > 0) {
        text = [text substringToIndex:text.length - 1];
        self.phoneTextField.text = text;
        [self handleSpecailButtonWithText:text];
    }
}

-(NSMutableDictionary *)dataDic{
    
    if (_dataDic == nil) {
        _dataDic = [[NSMutableDictionary alloc]init];
    }
    
    return _dataDic;
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
