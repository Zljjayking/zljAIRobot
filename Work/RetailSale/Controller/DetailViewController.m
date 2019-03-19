//
//  DetailViewController.m
//  UI-Lesson-2-work
//
//  Created by archerzz on 15/4/27.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import "DetailViewController.h"
#import "LoginPeopleModel.h"
#import "HttpRequestEngine.h"
#import "CRMDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController ()

{
    Pjsip *sip;
    NSTimer *_timer;
    LoginPeopleModel *_myModel;
}

@property(nonatomic,copy)NSString * stateStr;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * callLabel;

@property (nonatomic, strong)UIButton *overButton;
@property (nonatomic, strong)UIButton *InfoButton;
@property (nonatomic,assign) BOOL isCall;//是否执行拨号

@property (nonatomic,assign)BOOL reg;
//@property (nonatomic, strong) NSString *domain;//服务器地址
@property (nonatomic, strong) NSString *userName;//用户名
@property (nonatomic, strong) NSString *passwd;//密码

@property (nonatomic, strong) NSMutableDictionary * dataDic;

@property (nonatomic,copy) NSString * isSuccess;//是否拨打成功 1 是 0 否

@property (nonatomic,copy) NSString * isStop;//是否暂停 1 是 0 否
- (void)initializeUserInterface;
- (void)handleOverButtonEvent:(UIButton *)sender;

// 开始
- (void)startTimer;
// 暂停
- (void)pauseTimer;
// 停止
- (void)stopTimer;
// 处理Timer事件
- (void)handleTimer;


@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(void)loadData{
    
    
    _myModel = [LoginPeopleModel requestWithDic:[[LocalMeManager sharedPersonalInfoManager] loginPeopleInfo]];
    
    NSString* mobileStr = [NSString stringWithFormat:@"%ld",_myModel.mobile];
    
    [HttpRequestEngine GetSIPInfoWithMobile:mobileStr completion:^(id obj, NSString *errorStr) {
        
        if (errorStr == nil) {
            self.dataDic = obj;
            self.domain = [NSString stringWithFormat:@"%@",self.dataDic[@"serverIp"]];
            self.userName = [NSString stringWithFormat:@"%@",self.dataDic[@"account"]];
            self.passwd = [NSString stringWithFormat:@"%@",self.dataDic[@"password"]];
            self.pjSip = [[Pjsip alloc] init];
            self.reg = [self.pjSip registerToServer:self.domain username:self.userName passwd:self.passwd];
            if (self.reg == 0)
            {
                [self initializeUserInterface];
                //启动拨号倒计时
                [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:1] afterDelay:0];
                
            } else {
                [MBProgressHUD showError:@"话机注册失败"];
                if (self.callCountBlock != nil) {
                    self.isSuccess = @"0";
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.isSuccess,self.isStop] forKeys:@[self.callCount,@"isStop"]];
                    self.callCountBlock(dic);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }else{
            
            [MBProgressHUD showError:@"话机注册失败"];
            if (self.callCountBlock != nil) {
                self.isSuccess = @"0";
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.isSuccess,self.isStop] forKeys:@[self.callCount,@"isStop"]];
                self.callCountBlock(dic);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
}
- (void)reflashGetKeyBt:(NSNumber *)second{
    if ([second integerValue] == 0) {
        if (self.isCall == 1) {
            [self.overButton removeTarget:self action:@selector(OverButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            //拨打电话
            [self.pjSip makeCall:self.phoneNumber domain:self.domain];
            
            [self.overButton addTarget:self action:@selector(handleOverButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        int i = [second intValue];
        [self performSelector:@selector(reflashGetKeyBt:) withObject:[NSNumber numberWithInt:i-1] afterDelay:1];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"calling" object:nil];
    
    self.isCall = 1;
    self.isStop = @"0";
    self.view.backgroundColor = [UIColor colorWithRed:61/255.0 green:60/255.0 blue:65/255.0 alpha:1.0];
    
    //获取端口号 账户等信息
    [self loadData];
    
    [self setupAudio];
    
}


- (void)initializeUserInterface
{
   
    //显示电话号
    UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                CGRectGetWidth(self.view.bounds), 60)];
    [numberLabel setCenter:CGPointMake(CGRectGetMidX(self.view.bounds),
                                       CGRectGetMinY(self.view.bounds) + 80)];
    [numberLabel setText:_phoneNumber];
    [numberLabel setTextAlignment:NSTextAlignmentCenter];
    [numberLabel setFont:[UIFont systemFontOfSize:30]];
    [numberLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:numberLabel];
    
    //正在呼叫..
    self.callLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       CGRectGetWidth(self.view.bounds), 60)];
    [self.callLabel setCenter:CGPointMake(CGRectGetMidX(self.view.bounds),
                                        CGRectGetMaxY(numberLabel.frame) + 50)];
    [self.callLabel setText:@"正在呼叫中.."];
    [self.callLabel setTextAlignment:NSTextAlignmentCenter];
    [self.callLabel setBackgroundColor:[UIColor clearColor]];
    [self.callLabel setTextColor:[UIColor whiteColor]];
    [self.callLabel setTag:101];
    [self.view addSubview:self.callLabel];
    self.callLabel.hidden = NO;
    
    
    //显示通话界面
    NSArray * imgs = @[@"speeker", @"信息采集", @"静音"];
    NSArray * labels = @[@"扬声器",@"信息采集",@"静音"];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+1;
        [button setFrame:CGRectMake((kScreenWidth-180*KAdaptiveRateWidth)/4.0 + i * ((kScreenWidth-180*KAdaptiveRateWidth)/4.0+60*KAdaptiveRateWidth) , CGRectGetMidY(self.view.bounds) / 2.0 + 70*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth)];
        [button setBackgroundColor:[UIColor clearColor]];
        button.layer.masksToBounds = YES;
        [button.layer setCornerRadius:30*KAdaptiveRateWidth];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.layer.borderWidth = 2.0f;
        button.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
        [button setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(handleCallButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UILabel * label = [[UILabel alloc]init];
        [label setFrame:CGRectMake((kScreenWidth-180*KAdaptiveRateWidth)/4.0 + i * ((kScreenWidth-180*KAdaptiveRateWidth)/4.0+60*KAdaptiveRateWidth) , CGRectGetMidY(self.view.bounds) / 2.0 + 138*KAdaptiveRateWidth, 60*KAdaptiveRateWidth, 20*KAdaptiveRateWidth)];
        label.text = labels[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
    if (self.callCount.length > 0) {
        UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [stopBtn setBounds:CGRectMake(0, 0, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth)];
        [stopBtn setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) / 2.0 + 198*KAdaptiveRateWidth)];
        [stopBtn.layer setCornerRadius:30*KAdaptiveRateWidth];
        stopBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        stopBtn.layer.borderWidth = 2.0f;
        [stopBtn setBackgroundColor:[UIColor clearColor]];
        stopBtn.layer.borderColor = TABBAR_BASE_COLOR.CGColor;
        [stopBtn setImage:[UIImage imageNamed:@"暂停 (2)"] forState:UIControlStateNormal];
        [stopBtn setImage:[UIImage imageNamed:@"暂停 (2)"] forState:UIControlStateHighlighted];
        [self.view addSubview:stopBtn];
        [stopBtn addTarget:self action:@selector(stopButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * label = [[UILabel alloc]init];
        [label setBounds:CGRectMake(0, 0, 200*KAdaptiveRateWidth, 20*KAdaptiveRateWidth)];
        [label setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) / 2.0 + 246*KAdaptiveRateWidth)];
        label.text = @"暂停自动拨号";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
    //挂断按钮初始化
    self.overButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.overButton setBounds:CGRectMake(0, 0, 60*KAdaptiveRateWidth, 60*KAdaptiveRateWidth)];
    [self.overButton setCenter:CGPointMake(CGRectGetMidX(self.view.bounds), 450*KAdaptiveRateWidth)];
    [self.overButton setBackgroundImage:[UIImage imageNamed:@"free_call_通话_挂断_正常状态"] forState:UIControlStateNormal];
    [self.overButton setBackgroundImage:[UIImage imageNamed:@"free_call_通话_挂断_按下状态"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.overButton];
    [self.overButton addTarget:self action:@selector(OverButtonEvent:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)stopButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor lightGrayColor];
        self.isStop = @"1";
    } else {
        sender.backgroundColor = [UIColor clearColor];
        self.isStop = @"0";
    }
}

-(void)notice:(NSNotification *)noti{
    
    NSLog(@"状态==%@",noti.userInfo);
    
    self.stateStr = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"state"]];
    
    if ([self.stateStr isEqualToString:@"DISCONNCTD"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopTimer];
            if ([self.callLabel.text isEqualToString:@"正在呼叫中.."]) {
                if (self.callCountBlock != nil) {
                    self.isSuccess = @"2";
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.isSuccess,self.isStop] forKeys:@[self.callCount,@"isStop"]];
                    self.callCountBlock(dic);
                }
            } else {
                if (self.callCountBlock != nil) {
                    self.isSuccess = @"1";
                    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.isSuccess,self.isStop] forKeys:@[self.callCount,@"isStop"]];
                    self.callCountBlock(dic);
                }
            }
            self.callLabel.text = @"通话结束";
            [self.pjSip callHangup];
            [self.pjSip unregister];
            
        });
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if ([self.stateStr isEqualToString:@"CONFIRMED"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.callLabel.text = @"00:00:00";
            [self startTimer];
        });
    }
    
}

-(void)setupAudio{
    
    //初始化播放器的时候如下设置
    AudioSessionInitialize(NULL,NULL, NULL, (__bridge void *)(self));
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    //1.设置后台运行模式：在plist文件中添加Required background modes，并且设置item 0=App plays audio or streams audio/video using AirPlay（其实可以直接通过Xcode在Project Targets-Capabilities-Background Modes中设置）
    
    //2.设置AVAudioSession的类型为AVAudioSessionCategoryPlayback并且调用setActive::方法启动会话。
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    /**
     设置完音频会话类型之后需要调用setActive: error:方法将会话激活才能起作用。
     如果一个应用已经在播放音频，打开我们的应用之后设置了在后台播放的会话类型，此时其他应用的音频会停止而播放我们的音频;
     如果希望我们的程序音频播放完之后（关闭或退出到后台之后）能够继续播放其他应用的音频的话则可以调用setActive: error:方法关闭会话。
     */
    [audioSession setActive:YES error:nil];
    
    
    /**
     AVAudioSession 会话类型                            说明                      是否要求输入  是否要求输出	是否遵从静音键
     
     AVAudioSessionCategoryAmbient          混音播放，可以与其他音频应用同时播放          否           是           是
     
     AVAudioSessionCategorySoloAmbient      独占播放                                 否           是           是
     
     AVAudioSessionCategoryPlayback         后台播放，也是独占的                       否           是           否
     
     AVAudioSessionCategoryRecord           录音模式，用于录音时使用	是                  否           否           否
     
     AVAudioSessionCategoryPlayAndRecord	播放和录音，此时可以录音也可以播放            是           是           否
     
     AVAudioSessionCategoryAudioProcessing	硬件解码音频，此时不能播放和录制             否           否            否
     
     AVAudioSessionCategoryMultiRoute       多种输入输出，例如可以耳机、USB设备同时播放    是           是           否
     
     注意：是否遵循静音键表示在播放过程中如果用户通过硬件设置为静音是否能关闭声音。
     */
    
    
}

- (void)handleCallButtonEvent:(UIButton *)sender
{

    
    sender.selected = !sender.selected;


    if (sender.tag == 1) {
        
        if (sender.selected) {
            sender.backgroundColor = [UIColor lightGrayColor];
        
            [self XxxxSpeaker:YES];


        } else {
            sender.backgroundColor = [UIColor clearColor];
            
            [self XxxxSpeaker:NO];

        }
        
    }else if (sender.tag == 2) {
        
        
        CRMDetailsViewController *CRMDetails = [CRMDetailsViewController new];
        CRMDetails.seType = 3;
        CRMDetails.customerId = [NSString stringWithFormat:@"%ld",_myModel.userId];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:CRMDetails];
        [self presentViewController:navi animated:YES completion:nil];
        
        
    } else if (sender.tag == 3) {
        
        if (sender.selected) {
            sender.backgroundColor = [UIColor lightGrayColor];
            

            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            if (![audioSession.category isEqualToString:AVAudioSessionCategoryAudioProcessing])
                [audioSession setCategory:AVAudioSessionCategoryAudioProcessing error:nil];

        } else {
            sender.backgroundColor = [UIColor clearColor];
            
            [self XxxxSpeaker:NO];

        }
        
    }
    
}

//开启扬声器
-(void) XxxxSpeaker:(bool)bOpen
{
    UInt32 route;
    OSStatus error;
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    
    error = AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,
                                     sizeof (sessionCategory),
                                     &sessionCategory
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
    
}




- (void)handleOverButtonEvent:(UIButton *)sender
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
//        self.callLabel.text = @"通话结束";
    });
    self.isCall = 0;
    [self.pjSip callHangup];
    [self.pjSip unregister];
    
//    [self dismissViewControllerAnimated:YES completion:nil];

    NSLog(@"电话挂断并注销");

}
- (void)OverButtonEvent:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
        self.callLabel.text = @"通话结束";
        if (self.callCountBlock != nil) {
            self.isSuccess = @"1";
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[self.isSuccess,self.isStop] forKeys:@[self.callCount,@"isStop"]];
            NSLog(@"dic == %@",dic);
            self.callCountBlock(dic);
        }
    });
    self.isCall = 0;
    [self.pjSip unregister];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"只注销");
}
#pragma mark - NSTimer methods

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(handleTimer)
                                            userInfo:nil
                                             repeats:YES];
}
- (void)pauseTimer
{
    _timer.fireDate = [NSDate distantFuture];
}
- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}
- (void)handleTimer
{
    
    // 通过标签获取视图
    UILabel *showTimeLabel = (UILabel *)[self.view viewWithTag:101];
    // 获取标签的文本
    NSString *timeString = showTimeLabel.text;
    // 创建日期格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置样式
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    // 转换成date
    NSDate *date = [dateFormatter dateFromString:timeString];
    // 在此基础上加1s
    date = [date dateByAddingTimeInterval:1];
    // 最终转换成文本即可
    dispatch_async(dispatch_get_main_queue(), ^{
        showTimeLabel.text = [dateFormatter stringFromDate:date];
    });
    
}
- (void)returnCallCountBlock:(ReturnCallCountBlock)block {
    self.callCountBlock = block;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
