//
//  CRMVoiceViewController.h
//  Financeteam
//
//  Created by hchl on 2018/5/7.
//  Copyright © 2018年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@interface CRMVoiceViewController : BaseViewController
@property (nonatomic, strong) NSString *cusID;
@property (nonatomic, strong) NSString *type;//1.只有一个大的语音  2.有分开的语音
@property (nonatomic, strong) NSString *audio_url;

@property (nonatomic, copy) NSString *urlStr;
/**是否支持web下拉刷新 default is NO*/
@property (nonatomic, assign) BOOL isPullRefresh;
@end
