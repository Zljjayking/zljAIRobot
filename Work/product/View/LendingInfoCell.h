//
//  LendingInfoCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LendingInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *LendingLabel;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeAndMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLB;

@end
