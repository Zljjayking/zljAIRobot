//
//  CRMVoiceTwoTableViewCell.m
//  Financeteam
//
//  Created by hchl on 2018/5/7.
//  Copyright © 2018年 xzy. All rights reserved.
//

#import "CRMVoiceTwoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
@implementation CRMVoiceTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.headerImage = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:customBlueColor]];
    self.headerImage.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 22.5;
    [self addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.width.height.mas_equalTo(45);
    }];
    
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceBtn setBackgroundImage:[UIImage imageNamed:@"abubbleo"] forState:UIControlStateNormal];
    [self addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImage.mas_left).offset(-5);
//        make.top.equalTo(self).offset(5);
        make.centerY.equalTo(self.headerImage.mas_centerY);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(45);
//        make.bottom.equalTo(self).offset(-5);
    }];
    
    
    UIImage *image = [UIImage imageNamed:@"fs_icon_wave_2"];
    self.voiceImage = [[UIImageView alloc] initWithImage:[image setImageColorWithColor:MYWhite]];
    [self.voiceBtn addSubview:self.voiceImage];
    [self.voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voiceBtn);
        make.right.equalTo(self.voiceBtn).offset(-12);
        make.width.height.mas_equalTo(30);
    }];
    self.voiceImage.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);

    self.timeLB = [[UILabel alloc] init];
    [self addSubview:self.timeLB];
    self.timeLB.font = [UIFont systemFontOfSize:14];
    self.timeLB.textColor = GRAY100;
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voiceBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.voiceBtn);
        make.height.mas_equalTo(15);
    }];
    
    
}



- (void)setModel:(CRMVoiceModel *)model {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

//        NSURL *fileURL = [NSURL URLWithString:model.voiceUrl];
//        AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:fileURL];
//        CMTime duration = playerItem.asset.duration;
//        NSTimeInterval total = CMTimeGetSeconds(duration);
//        NSUInteger second = 0;
//        second = total;
        
//        NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:model.voiceUrl] options:opts]; // 初始化视频媒体文件
//        NSUInteger second = 0;
//        second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.isPlaying) {
                UIImage *image0 = [UIImage imageNamed:@"fs_icon_wave_0"];
                image0 = [image0 setImageColorWithColor:MYWhite];
                UIImage *image1 = [UIImage imageNamed:@"fs_icon_wave_1"];
                image1 = [image1 setImageColorWithColor:MYWhite];
                UIImage *image2 = [UIImage imageNamed:@"fs_icon_wave_2"];
                image2 = [image2 setImageColorWithColor:MYWhite];
                NSArray *animationImages = @[image0, image1, image2];
                
                self.voiceImage.animationImages = animationImages;
                self.voiceImage.animationDuration = animationImages.count * 0.7;
                [self.voiceImage startAnimating];
            } else {
                if (self.voiceImage.isAnimating) {
                    [self.voiceImage stopAnimating];
                }
            }
            self.timeLB.text = model.time;
        });
    
    });
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
