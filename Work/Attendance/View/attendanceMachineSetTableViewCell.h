//
//  attendanceMachineSetTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 2017/6/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface attendanceMachineSetTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *star;
@property (nonatomic, strong) UITextField *chooseTF;
@property (nonatomic, strong) UITextField *markTF;
@end
