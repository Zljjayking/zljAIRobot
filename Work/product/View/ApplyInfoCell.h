//
//  ApplyInfoCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/7/5.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyInfoCell : UITableViewCell

@property(nonatomic,strong)UILabel * applyInfoLabel;
@property(nonatomic,strong)UITextView * applyInfoTextView;
@property(nonatomic,strong)UILabel * placeholderLabel;
@property(nonatomic,strong)UIButton * deleteBtn;

@end
