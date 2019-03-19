//
//  EditTypeAndNameTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTypeAndNameTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) UILabel *TypeLb;
@property (nonatomic, strong) UITextView *contentTv;
@property (nonatomic, strong) UILabel *placeholderLb;
@property (nonatomic, strong) UIButton *uibutton;
@property (nonatomic, strong) UIView *separetor;
@end
