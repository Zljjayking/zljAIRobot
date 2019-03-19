//
//  attendanceMachineSetTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/21.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceMachineSetTableViewCell.h"

@implementation attendanceMachineSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = VIEW_BASE_COLOR;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    
    UIView *bgview = [[UIView alloc]init];
    [self addSubview:bgview];
    bgview.backgroundColor = [UIColor whiteColor];
    [bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-7*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.markLabel = [[UILabel alloc]init];
    self.markLabel.text = @"设备备注";
    [self addSubview:self.markLabel];
    self.markLabel.textColor = GRAY110;
    self.markLabel.font = [UIFont systemFontOfSize:15];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY).offset(-20);
        make.height.mas_equalTo(17);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"设备序列号";
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = GRAY110;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY).offset(-20);
        make.height.mas_equalTo(17);
    }];
    
    self.markTF = [[UITextField alloc]init];
    self.markTF.placeholder = @"输入设备备注";
    self.markTF.delegate = self;
    self.markTF.textAlignment = NSTextAlignmentLeft;
    [self.markTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_markTF];
    self.markTF.font = [UIFont systemFontOfSize:16];
    self.markTF.textAlignment = NSTextAlignmentRight;
    [_markTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.mas_equalTo((kScreenWidth-40)/2.0);
    }];
    
    self.chooseTF = [[UITextField alloc]init];
    self.chooseTF.placeholder = @"设备序列号";
    self.chooseTF.textAlignment = NSTextAlignmentRight;
    [self addSubview:_chooseTF];
    self.chooseTF.delegate = self;
    [self.chooseTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.chooseTF.font = [UIFont systemFontOfSize:16];
    self.chooseTF.textAlignment = NSTextAlignmentRight;
    [_chooseTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.width.mas_equalTo((kScreenWidth-40)/2.0);
    }];
    
    
    UIView *seperator1 = [[UIView alloc]init];
    [self addSubview:seperator1];
    seperator1.backgroundColor = GRAY229;
    [seperator1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(0.3);
        make.left.equalTo(self.mas_left).offset(20);
        make.width.mas_equalTo(kScreenWidth-30);
    }];
}
- (void) textFieldDidChange:(UITextField *)textField
{
    NSInteger kMaxLength = 5;
    if (textField == self.chooseTF) {
        kMaxLength = 13;
    }
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
