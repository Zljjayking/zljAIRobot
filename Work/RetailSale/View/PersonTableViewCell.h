//
//  PersonTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/9/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDFInitialsAvatar;
#import "PersonModel.h"
@interface PersonTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *tximg;
@property (nonatomic, strong) UILabel *phoneNum;
@property (nonatomic, strong) UILabel *txtName;
@property (nonatomic, strong) UILabel *stateLB;
@property(strong,nonatomic)UIImageView *txImage;
@property(strong,nonatomic)CDFInitialsAvatar *topAvatar;
-(void)setData:(PersonModel*)personDel;
@end
