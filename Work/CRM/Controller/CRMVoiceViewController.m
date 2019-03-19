//
//  CRMVoiceViewController.m
//  Financeteam
//
//  Created by hchl on 2018/5/7.
//  Copyright © 2018年 xzy. All rights reserved.
//

#import "CRMVoiceViewController.h"
#import <AVKit/AVKit.h>
#import "CRMVoiceOneTableViewCell.h"
#import "CRMVoiceTwoTableViewCell.h"
#import "CRMVoiceModel.h"
#import "WYWebProgressLayer.h"
#define FIT_W [UIScreen mainScreen].bounds.size.width / 375
#define FIT_H [UIScreen mainScreen].bounds.size.height / 667
@interface CRMVoiceViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    //__block BOOL _isSliderTouch;
    BOOL _isPlaying;
    float _total; //总时间
    WYWebProgressLayer *_progressLayer; ///< 网页加载进度条
}

@property (nonatomic, strong) UITableView *voiceTable;

@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,weak) UIImageView *musicImageView;
@property (nonatomic,weak) UIButton *playButton;
@property (nonatomic,weak) UILabel *beginTimeLabel;
@property (nonatomic,weak) UILabel *endTimeLabel;
@property (nonatomic,weak) UISlider *progressSlider;
@property (nonatomic,assign) __block BOOL isSliderTouch;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger oldVoiceBtnTag;//记录上一个点击播放的按钮tag
@property (nonatomic, assign) NSInteger nVoiceBtnTag;//记录现在点击播放的按钮tag
@property (nonatomic, strong) CRMVoiceModel *oldModel;//记录上一个点击的model
@property (nonatomic, strong) CRMVoiceModel *nModel;//记录现在点击的model

@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIProgressView *loadingProgressView;

@end

@implementation CRMVoiceViewController
- (UITableView *)voiceTable {
    if (!_voiceTable) {
        _voiceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, kScreenWidth, kScreenHeight-NaviHeight-60) style:UITableViewStylePlain];
        _voiceTable.delegate = self;
        _voiceTable.dataSource = self;
        [_voiceTable registerClass:[CRMVoiceOneTableViewCell class] forCellReuseIdentifier:@"one"];
        [_voiceTable registerClass:[CRMVoiceTwoTableViewCell class] forCellReuseIdentifier:@"two"];
        [_voiceTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _voiceTable.tableFooterView = [UIView new];
        _voiceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _voiceTable.backgroundColor = UIColorFromRGB(0xf2f2f2, 1);
    }
    return _voiceTable;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player pause];
    _webView.delegate = nil;
}
#pragma mark 版本适配
- (void)createWebView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.reloadButton];
    [self.view addSubview:self.webView];
    _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 2)];
    if (IS_IPHONE_X) {
        self.webView.frame = CGRectMake(0, NaviHeight, self.view.bounds.size.width, self.view.bounds.size.height - NaviHeight);
        _progressLayer = [WYWebProgressLayer layerWithFrame:CGRectMake(0, 87, SCREEN_WIDTH, 2)];
    }
    [self.view.layer addSublayer:_progressLayer];
    //    [self.view addSubview:self.loadingProgressView];
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
    //        [self.view addSubview:self.wk_WebView];
    //        [self.view addSubview:self.loadingProgressView];
    //    } else {
    //        [self.view addSubview:self.webView];
    //    }
}

- (UIWebView*)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, NaviHeight, self.view.bounds.size.width, self.view.bounds.size.height - NaviHeight)];
        _webView.delegate = self;
        _webView.backgroundColor = VIEW_BASE_COLOR;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _isPullRefresh) {
            _webView.scrollView.refreshControl = self.refreshControl;
        }
    }
    return _webView;
}

- (UIProgressView*)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, NaviHeight, self.view.bounds.size.width, 2)];
        _loadingProgressView.progressTintColor = [UIColor greenColor];
    }
    return _loadingProgressView;
}

- (UIRefreshControl*)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(webViewReload) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)webViewReload {
    [_webView reload];
}
- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.view.center;
        _reloadButton.layer.cornerRadius = 75.0;
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"您的网络有问题，请检查您的网络设置" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadButton.titleLabel.numberOfLines = 0;
        _reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 100;
        _reloadButton.frame = rect;
        _reloadButton.enabled = NO;
    }
    return _reloadButton;
}

- (void)loadRequest {
    if (![self.urlStr hasPrefix:@"http"]) {//是否具有http前缀
        self.urlStr = [NSString stringWithFormat:@"http://%@",self.urlStr];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
    //        [_wk_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    //    } else {
    //        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    //    }
}

#pragma mark WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.hidden = NO;
    // 不加载空白网址
    if ([request.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //导航栏配置
    [_refreshControl endRefreshing];
    
    [_progressLayer finishedLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.hidden = YES;
    [_progressLayer finishedLoad];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2, 1);
    self.title = @"通话语音";
    self.oldVoiceBtnTag = 0;
    if ([self.type isEqualToString:@"1"]) {
        [self createUI];
    } else {
        //        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        //        [MBProgressHUD showMessage:@"加载中..."];
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //
        //            for (int i=0; i<9; i++) {
        //                CRMVoiceModel *model = [CRMVoiceModel new];
        //                model.isMechine = i%2;
        //                model.voiceUrl = @"http://120.78.166.79:8111/airobot//5/2/13/audio_flow/1525502533087.wav";
        //                model.text = @"测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本";
        //                model.isPlaying = 0;
        //                NSURL *fileURL = [NSURL URLWithString:model.voiceUrl];
        //                AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
        //                CMTime duration = playerItem.asset.duration;
        //                NSTimeInterval total = CMTimeGetSeconds(duration);
        //                NSUInteger second = 0;
        //                second = total;
        //                model.time = [NSString stringWithFormat:@"%lu",second];
        //                [self.dataArr addObject:model];
        //            }
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [self.view addSubview:self.voiceTable];
        //                [MBProgressHUD hideHUD];
        //            });
        //        });
        
        [self createWebView];
        [self loadRequest];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    __weak typeof(self) weakSelf = self;
    CGFloat imageViewWidth = 375 *FIT_W * .7;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_music_bg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = imageViewWidth /2;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-80*FIT_H);
        make.centerX.equalTo(weakSelf.view);
        make.width.height.equalTo(@(imageViewWidth));
    }];
    self.musicImageView = imageView;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"icon_stop"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView);
    }];
    self.playButton = playButton;
    
    //    UILabel *musicNameLabel = [[UILabel alloc]init];
    //    musicNameLabel.text = @"告白气球.mp3";
    //    musicNameLabel.font = [UIFont systemFontOfSize:17.f];
    //    musicNameLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:musicNameLabel];
    //    [musicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(weakSelf.view);
    //        make.top.equalTo(imageView.mas_bottom).offset(30);
    //    }];
    //
    //    UILabel *sizeLabel = [[UILabel alloc]init];
    //    sizeLabel.text = @"5.58MB";
    //    sizeLabel.font = [UIFont systemFontOfSize:15.f];
    //    sizeLabel.textAlignment = NSTextAlignmentCenter;
    //    sizeLabel.textColor = [UIColor grayColor];
    //    [self.view addSubview:sizeLabel];
    //    [sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(weakSelf.view);
    //        make.top.equalTo(musicNameLabel.mas_bottom).offset(10);
    //    }];
    
    UISlider *slider = [[UISlider alloc]init];
    slider.minimumTrackTintColor = UIColorFromRGB(0x37ccff, 1);
    slider.maximumTrackTintColor = UIColorFromRGB(0x484848, 1);
    [slider setThumbImage:[UIImage imageNamed:@"icon_sliderButton"] forState:UIControlStateNormal];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(- 70 *FIT_H);
        make.width.equalTo(@(imageViewWidth));
        make.centerX.equalTo(weakSelf.view);
    }];
    self.progressSlider = slider;
    
    UILabel *leftTimeLabel = [[UILabel alloc]init];
    leftTimeLabel.text = @"00:00";
    leftTimeLabel.textColor = [UIColor grayColor];
    leftTimeLabel.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:leftTimeLabel];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(slider.mas_left).offset(-8);
        make.centerY.equalTo(slider);
    }];
    self.beginTimeLabel = leftTimeLabel;
    
    UILabel *rightTimeLabel = [[UILabel alloc]init];
    rightTimeLabel.text = @"00:00";
    rightTimeLabel.textColor = [UIColor grayColor];
    rightTimeLabel.font = [UIFont systemFontOfSize:12.f];
    [self.view addSubview:rightTimeLabel];
    [rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(slider.mas_right).offset(8);
        make.centerY.equalTo(slider);
    }];
    self.endTimeLabel = rightTimeLabel;
    
    [self settingPlayer];
}

- (void)settingPlayer{
    //    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"A-Lin-无人知晓的我" withExtension:@".mp3"];
    //http://120.78.166.79:8111/airobot//5/2/13/audio_flow/1525502533087.wav
    NSURL *fileURL = [NSURL URLWithString:self.audio_url];
    
    self.playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback  error:nil];
    
    CMTime duration = self.player.currentItem.asset.duration;
    NSTimeInterval total = CMTimeGetSeconds(duration);
    self.endTimeLabel.text = [self timeIntervalToMMSSFormat:total];
    
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //更新时间和进度条
        float current = CMTimeGetSeconds(weakSelf.player.currentItem.currentTime);
        _total = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        weakSelf.beginTimeLabel.text = [weakSelf timeIntervalToMMSSFormat:CMTimeGetSeconds(time)];
        if (!weakSelf.isSliderTouch) {
            //拖动slider的时候不更新进度条
            weakSelf.progressSlider.value = current / _total;
        }
        
    }];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playToEnd{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01* NSEC_PER_SEC)); dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.progressSlider.value = 0;
        self.playButton.selected = NO;
        self.beginTimeLabel.text = @"00:00";
        [self stopLayer:self.musicImageView.layer];
        _isPlaying = NO;
        self.player = nil;
        self.playerItem = nil;
        self.oldModel.isPlaying = 0;
        [self.voiceTable reloadData];
    });
    
}

#pragma mark - 进度条状态改变
- (void)sliderTouchDown:(UISlider *)slider{
    _isSliderTouch = YES;
}

- (void)sliderValueChange:(UISlider *)slider{
    [self.player seekToTime:CMTimeMakeWithSeconds(slider.value * _total, self.player.currentItem.currentTime.timescale)];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.03* NSEC_PER_SEC)); dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //不延迟执行会造成slider瞬间回弹
        _isSliderTouch = NO;
    });
    
}

#pragma mark - 图片旋转动画
//暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

//停止动画
- (void)stopLayer:(CALayer *)layer{
    [layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark - Action
- (void)playButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (self.player == nil) {
        [self settingPlayer];
    }
    if (button.selected) {
        [self.player play];
        _isPlaying == YES ? [self resumeLayer:self.musicImageView.layer] : [self startAnimate];
        _isPlaying = YES;
    }else{
        [self.player pause];
        [self pauseLayer:self.musicImageView.layer];
    }
}

- (void)startAnimate{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.speed = 1;
    rotationAnimation.duration = 25;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999999;
    rotationAnimation.removedOnCompletion = NO;
    [self.musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - 设置时间数据
- (void)updateProgressLabelCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration {
    self.beginTimeLabel.text = [self timeIntervalToMMSSFormat:currentTime];
    self.endTimeLabel.text = [self timeIntervalToMMSSFormat:duration];
    [self.progressSlider setValue:currentTime / duration animated:YES];
    
}

#pragma mark - 时间转化
- (NSString *)timeIntervalToMMSSFormat:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}










- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRMVoiceModel *model = self.dataArr[indexPath.row];
    if (indexPath.row%2) {
        CRMVoiceOneTableViewCell *cellOne = [tableView dequeueReusableCellWithIdentifier:@"one" forIndexPath:indexPath];
        cellOne.voiceBtn.tag = indexPath.row+1;
        [cellOne.voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cellOne.model = model;
        cellOne.voiceImage.tag = indexPath.row + 1000;
        return cellOne;
    } else {
        CRMVoiceTwoTableViewCell *cellTwo = [tableView dequeueReusableCellWithIdentifier:@"two" forIndexPath:indexPath];
        cellTwo.voiceBtn.tag = indexPath.row+1;
        [cellTwo.voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cellTwo.model = model;
        cellTwo.voiceImage.tag = indexPath.row + 1000;
        return cellTwo;
    }
    
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.player pause];
    [self pauseLayer:self.musicImageView.layer];
    self.playButton.selected = NO;
}


- (void)voiceBtnClick:(UIButton *)btn {
    CRMVoiceModel *model = self.dataArr[btn.tag-1];
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag-1 inSection:0];
    
    if (self.oldVoiceBtnTag == 0) {
        self.oldVoiceBtnTag = btn.tag;
        self.nVoiceBtnTag = btn.tag;
        NSURL *fileURL = [NSURL URLWithString:model.voiceUrl];
        self.playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback  error:nil];
        [self.player play];
        [self animateImageWithModel:model];
    }else {
        self.nVoiceBtnTag = btn.tag;
        self.oldModel.isPlaying = 0;
        if (self.oldVoiceBtnTag == self.nVoiceBtnTag) {
            if (self.player != nil) {
                [self.player pause];
                [self playToEnd];
                
            } else {
                NSURL *fileURL = [NSURL URLWithString:model.voiceUrl];
                self.playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
                self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
                [self.player play];
                
                [self animateImageWithModel:model];
            }
            
        } else {
            self.oldVoiceBtnTag = self.nVoiceBtnTag;
            NSURL *fileURL = [NSURL URLWithString:model.voiceUrl];
            self.playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
            self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
            [self.player play];
            [self animateImageWithModel:model];
        }
    }
    
}

- (void)animateImageWithModel:(CRMVoiceModel *)model {
    model.isPlaying = !model.isPlaying;
    self.oldModel = model;
    [self.voiceTable reloadData];
    //    if (indexPath.row%2) {
    //        CRMVoiceOneTableViewCell *cell = [self.voiceTable cellForRowAtIndexPath:indexPath];
    //        UIImage *image0 = [UIImage imageNamed:@"fs_icon_wave_0"];
    //        image0 = [image0 setImageColorWithColor:GRAY90];
    //        UIImage *image1 = [UIImage imageNamed:@"fs_icon_wave_1"];
    //        image1 = [image1 setImageColorWithColor:GRAY90];
    //        UIImage *image2 = [UIImage imageNamed:@"fs_icon_wave_2"];
    //        image2 = [image2 setImageColorWithColor:GRAY90];
    //        NSArray *animationImages = @[image0, image1, image2];
    //
    //        cell.voiceImage.animationImages = animationImages;
    //        cell.voiceImage.animationDuration = animationImages.count * 0.7;
    //        [cell.voiceImage startAnimating];
    //
    //        self.oldImageV = cell.voiceImage;
    //    } else {
    //        CRMVoiceTwoTableViewCell *cell = [self.voiceTable cellForRowAtIndexPath:indexPath];
    //        UIImage *image0 = [UIImage imageNamed:@"fs_icon_wave_0"];
    //        image0 = [image0 setImageColorWithColor:MYWhite];
    //        UIImage *image1 = [UIImage imageNamed:@"fs_icon_wave_1"];
    //        image1 = [image1 setImageColorWithColor:MYWhite];
    //        UIImage *image2 = [UIImage imageNamed:@"fs_icon_wave_2"];
    //        image2 = [image2 setImageColorWithColor:MYWhite];
    //        NSArray *animationImages = @[image0, image1, image2];
    //
    //        cell.voiceImage.animationImages = animationImages;
    //        cell.voiceImage.animationDuration = animationImages.count * 0.7;
    //        [cell.voiceImage startAnimating];
    //
    //        self.oldImageV = cell.voiceImage;
    //    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            
        } else if (status == AVPlayerStatusFailed) {
            
        } else {
            
        }
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _loadingProgressView.progress = [change[@"new"] floatValue];
        if (_loadingProgressView.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _loadingProgressView.hidden = YES;
            });
        }
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
