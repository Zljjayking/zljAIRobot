//
//  CRMVoiceOneTableViewCell.h
//  Financeteam
//
//  Created by hchl on 2018/5/7.
//  Copyright © 2018年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRMVoiceModel.h"
@interface CRMVoiceOneTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UIImageView *voiceImage;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) CRMVoiceModel *model;
@property (nonatomic, strong) UILabel *timeLB;
@end
