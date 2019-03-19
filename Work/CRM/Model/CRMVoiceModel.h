//
//  CRMVoiceModel.h
//  Financeteam
//
//  Created by hchl on 2018/5/11.
//  Copyright © 2018年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRMVoiceModel : NSObject
@property (nonatomic, strong) NSString *text;//语音的内容
@property (nonatomic, strong) NSString *voiceUrl;//语音的链接
@property (nonatomic, assign) BOOL isMechine;//判断是不是机器人的
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) BOOL isPlaying;//是否正在播放
@property (nonatomic, strong) NSString *time;
@end
