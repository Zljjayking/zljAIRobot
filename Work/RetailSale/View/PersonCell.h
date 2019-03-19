//
//  PersonCell.h
//  BM
//
//  Created by yuhuajun on 15/7/13.
//  Copyright (c) 2015年 yuhuajun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPersonInfo.h"
@class CDFInitialsAvatar;
@interface PersonCell : UITableViewCell
{
    UIImageView *_tximg;
    UILabel  *_txtName;
    UILabel  *_nickName;
    UILabel  *_phoneNum;
}
@property(strong,nonatomic)JXPersonInfo *personDel;
@property(strong,nonatomic)UILabel *youlable;
@property(strong,nonatomic)CDFInitialsAvatar *topAvatar;
@property(strong,nonatomic)UIImageView *txImage;
-(void)setData:(JXPersonInfo*)personDel;

@end
