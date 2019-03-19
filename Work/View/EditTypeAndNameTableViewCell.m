//
//  EditTypeAndNameTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "EditTypeAndNameTableViewCell.h"

@implementation EditTypeAndNameTableViewCell

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
- (void) setupView {
    
    self.TypeLb = [[UILabel alloc]init];
    self.TypeLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.TypeLb];
    self.TypeLb.textColor = [UIColor grayColor];
    [self.TypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
//        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(17*KAdaptiveRateWidth);
        make.width.mas_equalTo(70*KAdaptiveRateWidth);

    }];
    
    self.contentTv = [[UITextView alloc]init];
    self.contentTv.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.contentTv];
    self.contentTv.delegate = self;
    self.contentTv.returnKeyType = UIReturnKeyDone;
    [self.contentTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        //        make.centerY.mas_equalTo(self.mas_centerY);
        make.top.equalTo(self.TypeLb.mas_bottom).offset(5*KAdaptiveRateWidth);
        make.width.mas_equalTo(kScreenWidth - 24*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-5*KAdaptiveRateWidth);
    }];
    
    self.placeholderLb = [[UILabel alloc]init];
    self.placeholderLb.font = [UIFont systemFontOfSize:15];
    self.placeholderLb.frame =CGRectMake(5, 5, kScreenWidth - 4, 20);
    self.placeholderLb.text = @"输入任务内容";
    self.placeholderLb.enabled = NO;//lable必须设置为不可用
    self.placeholderLb.textColor = [UIColor lightGrayColor];
    //uilabel.backgroundColor = [UIColor clearColor];
    [self.contentTv addSubview:self.placeholderLb];
    
    
//    self.uibutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentTv addSubview:self.uibutton];
////    self.uibutton.hidden = YES;
//    self.uibutton.frame = CGRectMake(kScreenWidth-50*KAdaptiveRateWidth,32.5*KAdaptiveRateHeight,25*KAdaptiveRateWidth,25*KAdaptiveRateWidth);
//    [self.uibutton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
//    [self.uibutton addTarget:self action:@selector(clearButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    self.separetor = [[UIView alloc] init];
    self.separetor.backgroundColor = GRAY229;
    [self addSubview:self.separetor];
    [self.separetor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
}
#pragma mark -------------- textView Delegate ------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.contentTv resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
//    self.uibutton.hidden = NO;
//    self.placeholderLb.hidden = YES;
//    CGRect frame = textView.frame;
//    NSLog(@"textField.frame.origin.y == %f",frame.origin.y);
//    double offset = frame.origin.y+20 - (400.5*KAdaptiveRateHeight - self.KeyBoardHeight);//键盘高度216
//    NSLog(@"offset == %f",offset);
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0) {
//        self.ChuangJianHuoDong.frame = CGRectMake(0.0f,kScreenHeight-400.5*self.MyDelegate.autoSizeScaleY -self.KeyBoardHeight, kScreenWidth, 400.5*self.MyDelegate.autoSizeScaleY);
//    }
//    [UIView commitAnimations];
//    NSLog(@"开始编辑%f",offset);
    
}
-(void)clearButtonSelected:(UIButton *)btn{
    self.contentTv.text=@"";
    self.placeholderLb.hidden = NO;
//    self.uibutton.hidden = YES;
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
