//
//  RecordTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/8/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDFInitialsAvatar;
#import "PersonModel.h"
@interface RecordTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *tximg;
@property (nonatomic, strong) UILabel *phoneNum;
@property (nonatomic, strong) UILabel *txtName;
@property (nonatomic, strong) UILabel *dateName;
@property(strong,nonatomic)UIImageView *txImage;
@property(strong,nonatomic)CDFInitialsAvatar *topAvatar;
-(void)setData:(PersonModel*)personDel;
@end
