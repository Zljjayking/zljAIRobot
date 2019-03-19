//
//  paySetFourTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface paySetFourTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *ll;
@property (nonatomic, strong) UITextField *minTF;
@property (nonatomic, strong) UITextField *maxTF;
@property (nonatomic, strong) UITextField *percentTF;
@end
