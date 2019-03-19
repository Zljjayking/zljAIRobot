//
//  employeeTwoTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface employeeTwoTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UITextView *textField;
@property (nonatomic, strong) UIImageView *starImage;
@property(nonatomic,strong)UILabel * placeholderLabel;
@property(nonatomic,strong)UIButton * deleteBtn;
@end
