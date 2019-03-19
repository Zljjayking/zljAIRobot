//
//  NoticeDetailsTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeDetailsTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic) UITextView *contentTV;
@property (nonatomic,strong) UILabel *placeholderLb;
@end
