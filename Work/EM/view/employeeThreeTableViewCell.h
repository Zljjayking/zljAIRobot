//
//  employeeThreeTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface employeeThreeTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *starImage;
@end
