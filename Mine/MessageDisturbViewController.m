//
//  MessageDisturbViewController.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MessageDisturbViewController.h"
#import "MDOneTableViewCell.h"
#import "MDTwoTableViewCell.h"
//#import "NCDateTimeSelectView.h"
#import "DateTimeSelectView.h"
@interface MessageDisturbViewController ()<UITableViewDelegate,UITableViewDataSource,SelectDateTimeDelegate>

@property(nonatomic,strong)UITableView * messageDisTableView;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic,assign)CGFloat cellHeight;

//@property (nonatomic, strong) NCDateTimeSelectView * dateTimeSelectView;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *endT;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL isON;
@property (nonatomic,assign) int spansMin;
@property (nonatomic, strong) DateTimeSelectView *dateTimeSelectView;
@end

@implementation MessageDisturbViewController
- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}
- (UITableView *)messageDisTableView {
    if (!_messageDisTableView) {
        _messageDisTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NaviHeight, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        
    }
    return _messageDisTableView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息免打扰";
    self.view.backgroundColor = VIEW_BASE_COLOR;
    [self creatUI];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}
-(void)creatUI{
    
    self.messageDisTableView.delegate = self;
    self.messageDisTableView.dataSource = self;
    self.messageDisTableView.bounces = NO;
    self.messageDisTableView.backgroundColor = VIEW_BASE_COLOR;
    [self.view addSubview:self.messageDisTableView];
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.messageDisTableView setTableFooterView:view];
    
    [self.messageDisTableView registerClass:[MDOneTableViewCell class] forCellReuseIdentifier:@"MDOneTableViewCellID"];
    [self.messageDisTableView registerClass:[MDTwoTableViewCell class] forCellReuseIdentifier:@"MDTwoTableViewCellID"];
    
    //选择界面上面的背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView)];
    [self.bgView addGestureRecognizer:tap];
    [self.navigationController.view addSubview:self.bgView];
    self.bgView.hidden = YES;
    
    // 选择界面
    _dateTimeSelectView = [[DateTimeSelectView alloc] initWithFrame:hideTimeViewRect formatter:@"HH:mm"];
    _dateTimeSelectView.delegateGetDate = self;
    [self.navigationController.view addSubview:_dateTimeSelectView];
    _dateTimeSelectView.hidden = YES;
    
    
    
    self.startTime = @"点击选取";
    self.endTime = @"点击选取";
    
    [[RCIMClient sharedRCIMClient] getNotificationQuietHours:^(NSString *startTime, int spansMin) {
        
        if (startTime.length != 0) {
            self.startTime = startTime;
        }
        
        if (spansMin>0 && spansMin <1440) {
            self.spansMin = spansMin;
            NSDateFormatter * dm = [[NSDateFormatter alloc]init];
            //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
            [dm setDateFormat:@"HH:mm:ss"];
            NSDate * newdate = [dm dateFromString:self.startTime];
            NSDateFormatter * dm1 = [[NSDateFormatter alloc]init];
            //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
            [dm1 setDateFormat:@"HH:mm:ss"];
            NSDate * newdate1 = [dm1 dateFromString:@"00:00:00"];
            if (([newdate timeIntervalSince1970] - [newdate1 timeIntervalSince1970])/60 + spansMin >= 1440) {
                int dd = (int)([newdate timeIntervalSince1970] - [newdate1 timeIntervalSince1970])/60 + spansMin - 1440;
                
                self.endTime = [NSString stringWithFormat:@"(次日)%02d:%02d:00",dd/60,dd%60];
                self.endT = [NSString stringWithFormat:@"%02d:%02d:00",dd/60,dd%60];
                
            } else {
                int dd = (int)([newdate timeIntervalSince1970] - [newdate1 timeIntervalSince1970])/60 + spansMin;
                self.endTime = [NSString stringWithFormat:@"%02d:%02d:00",dd/60,dd%60];
                self.endT = [NSString stringWithFormat:@"%02d:%02d:00",dd/60,dd%60];
            }
            self.isON = 1;
            self.cellHeight = 45;
            
        }
        NSLog(@"spansMin == %d",spansMin);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageDisTableView reloadData];
        });
    } error:^(RCErrorCode status) {
        
        self.startTime = @"点击选取";
        self.endTime = @"点击选取";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messageDisTableView reloadData];
        });
        
    }];
    
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.isON == 1) {
        return 3;
    } else {
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 13;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        MDOneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MDOneTableViewCellID" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MDOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MDOneTableViewCellID"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.leftLabel.text = @"消息免打扰";
        if (self.isON) {
            [cell.rightSwitch setOn:YES animated:NO];
        }
        
        [cell.rightSwitch addTarget:self action:@selector(getValueOnClick:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
        
    }
    else if (indexPath.row == 1){
        MDTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MDTwoTableViewCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MDTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MDTwoTableViewCellID"];
        }
  
        cell.leftLabel.text = @"起始时间";
        cell.rightLabel.text = self.startTime;
        return cell;

    }else if (indexPath.row == 2){
        MDTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MDTwoTableViewCellID" forIndexPath:indexPath];
        if (!cell) {
            cell = [[MDTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MDTwoTableViewCellID"];
        }
        cell.leftLabel.text = @"结束时间";
        cell.rightLabel.text = self.endTime;
        return cell;

    }

    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==1) {
        self.index = 1;
        _dateTimeSelectView.hidden = NO;
        self.bgView.hidden = NO;
        [UIView animateWithDuration:animateTime animations:^{
            _dateTimeSelectView.frame = timeViewRect;
        }];
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    }
    if (indexPath.row == 2) {
        self.index = 2;
        _dateTimeSelectView.hidden = NO;
        self.bgView.hidden = NO;
        [UIView animateWithDuration:animateTime animations:^{
            _dateTimeSelectView.frame = timeViewRect;
        }];
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
    }
}
- (void)getDate:(NSMutableDictionary *)dictDate {
    [UIView animateWithDuration:animateTime animations:^{
        _dateTimeSelectView.frame = hideTimeViewRect;
    } completion:^(BOOL finished) {
        _dateTimeSelectView.hidden = YES;
        self.bgView.hidden = YES;
        self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    }];
    if (self.index == 1) {
        self.startTime = [NSString stringWithFormat:@"%@:00",[[dictDate objectForKey:@"time"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        NSLog(@"endT == %@",self.endT);
        if (self.endT.length != 0) {
            NSDateFormatter * dm = [[NSDateFormatter alloc]init];
            //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
            [dm setDateFormat:@"HH:mm:ss"];
            NSDate * newdate = [dm dateFromString:self.startTime];
            NSDateFormatter * dm1 = [[NSDateFormatter alloc]init];
            //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
            [dm1 setDateFormat:@"HH:mm:ss"];
            NSDate * newdate1 = [dm1 dateFromString:self.endT];
            int dd = (int)([newdate1 timeIntervalSince1970] - [newdate timeIntervalSince1970])/60;
            NSLog(@"dd == %d",dd);
            if (dd<0) {
                
                int spanMins = 1440+dd;
                self.endTime = [NSString stringWithFormat:@"(次日)%@",self.endT];
                [[RCIMClient sharedRCIMClient] setNotificationQuietHours:self.startTime spanMins:spanMins success:^{
                    NSLog(@"success");
                } error:^(RCErrorCode status) {
                    NSLog(@"status == %ld",status);
                }];
            } else {
                
                //            int spanMin = dd/60
                self.endTime = self.endT;
                [[RCIMClient sharedRCIMClient] setNotificationQuietHours:self.startTime spanMins:(int)dd success:^{
                    NSLog(@"success");
                } error:^(RCErrorCode status) {
                    NSLog(@"status == %ld",status);
                }];
            }
        }
        
    } else {
        self.endT = [NSString stringWithFormat:@"%@:00",[[dictDate objectForKey:@"time"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
        [dm setDateFormat:@"HH:mm:ss"];
        NSDate * newdate = [dm dateFromString:self.startTime];
        NSDateFormatter * dm1 = [[NSDateFormatter alloc]init];
        //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
        [dm1 setDateFormat:@"HH:mm:ss"];
        NSDate * newdate1 = [dm1 dateFromString:self.endT];
        int dd = (int)([newdate1 timeIntervalSince1970] - [newdate timeIntervalSince1970])/60;
        NSLog(@"dd == %d",dd);
        if (dd<0) {
            self.endTime = [NSString stringWithFormat:@"(次日)%@",self.endT];
            self.spansMin = 1440+dd;
            int spans = 1440+dd;
            [[RCIMClient sharedRCIMClient] setNotificationQuietHours:self.startTime spanMins:spans success:^{
                NSLog(@"success");
            } error:^(RCErrorCode status) {
                NSLog(@"status == %ld",status);
            }];
        } else {
            self.spansMin = dd;
            self.endTime = self.endT;
            [[RCIMClient sharedRCIMClient] setNotificationQuietHours:self.startTime spanMins:dd success:^{
                NSLog(@"success");
            } error:^(RCErrorCode status) {
                NSLog(@"status == %ld",status);
            }];
        }
        
    }
    
    [self.messageDisTableView reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 45;
}


-(void)getValueOnClick:(UISwitch *)sender{
    
    if (sender.isOn) {
        
        NSLog(@"On");
        self.isON = 1;
        self.cellHeight = 45;
        
        [[RCIMClient sharedRCIMClient] setNotificationQuietHours:self.startTime spanMins:self.spansMin success:^{
            NSLog(@"success");
        } error:^(RCErrorCode status) {
            NSLog(@"status == %ld",status);
        }];
        
        
        [self.messageDisTableView reloadData];
        
    }else{
        
        NSLog(@"Off");
        self.isON = 0;
        self.cellHeight = 0;
        [[RCIMClient sharedRCIMClient] removeNotificationQuietHours:^{
            NSLog(@"success");
        } error:^(RCErrorCode status) {
            NSLog(@"status == %ld",status);
        }];
        
        [self.messageDisTableView reloadData];
    }
}


-(void)GoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
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
