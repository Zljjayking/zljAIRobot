//
//  EditNameTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/5/26.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditNameTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *TypeLb;
@property (nonatomic, strong) UITextField *NameTF;
@property (nonatomic, strong) UIView *separetor;
@end
