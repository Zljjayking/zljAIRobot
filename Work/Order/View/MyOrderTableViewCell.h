//
//  MyOrderTableViewCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UIImageView *signImage;
@end
