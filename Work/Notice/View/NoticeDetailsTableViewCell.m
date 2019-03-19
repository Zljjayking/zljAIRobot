//
//  NoticeDetailsTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "NoticeDetailsTableViewCell.h"

@implementation NoticeDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.contentTV = [[UITextView alloc] init];
    [self addSubview:self.contentTV];
    self.contentTV.font = [UIFont systemFontOfSize:14];
    self.contentTV.delegate = self;
    self.contentTV.returnKeyType = UIReturnKeyDone;
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    self.placeholderLb = [[UILabel alloc]init];
    self.placeholderLb.font = [UIFont systemFontOfSize:14];
    self.placeholderLb.frame =CGRectMake(5, 5, kScreenWidth - 4, 20);
    self.placeholderLb.enabled = NO;//lable必须设置为不可用
    self.placeholderLb.textColor = GRAY229;
    [self.contentTV addSubview:self.placeholderLb];

}

#pragma mark -------------- textView Delegate ------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.contentTV resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)clearButtonSelected:(UIButton *)btn{
    
    self.contentTV.text=@"";
    self.placeholderLb.hidden = NO;

}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length==0) {
        self.placeholderLb.hidden = NO;
    } else {
        self.placeholderLb.hidden = YES;
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length==0) {
        self.placeholderLb.hidden = NO;
    }else {
        self.placeholderLb.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
