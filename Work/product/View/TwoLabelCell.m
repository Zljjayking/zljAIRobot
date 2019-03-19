//
//  TwoLabelCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/13.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "TwoLabelCell.h"

@implementation TwoLabelCell
- (void)textViewDidChange:(UITextView *)textView
{
    //    if (textView.text.length==0) {
    //        self.placeholderLabel.hidden = NO;
    //    } else {
    //        self.placeholderLabel.hidden = YES;
    //    }
    
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
//

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = GRAY90;
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(18);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.height.mas_equalTo(17);
//    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
