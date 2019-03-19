//
//  payGroupOneTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/28.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "payGroupOneTableViewCell.h"

@implementation payGroupOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = VIEW_BASE_COLOR;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview: bgView];
    bgView.layer.cornerRadius = 5*KAdaptiveRateWidth;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(7*KAdaptiveRateWidth);
        make.right.equalTo(self.mas_right).offset(-10*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-7*KAdaptiveRateWidth);
    }];
    
    UIView *hehe = [[UIView alloc] init];
    hehe.backgroundColor = kMyColor(44, 244, 243);
    [self addSubview:hehe];
    [hehe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateWidth);
        make.left.equalTo(self.mas_left).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(5*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
    
    UILabel *heheLB = [[UILabel alloc]init];
    [self addSubview:heheLB];
    heheLB.text = @"基础设置";
    heheLB.textColor = GRAY138;
    heheLB.font = [UIFont systemFontOfSize:14];
    [heheLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(hehe.mas_centerY);
        make.left.equalTo(hehe.mas_right).offset(5*KAdaptiveRateWidth);
        make.height.mas_equalTo(14*KAdaptiveRateWidth);
    }];
    
    UILabel *nameLB = [[UILabel alloc] init];
    nameLB.text = @"薪资组名称";
    nameLB.textColor = GRAY100;
    [self addSubview:nameLB];
    nameLB.font = [UIFont systemFontOfSize:16];
    [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
        make.top.equalTo(heheLB.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
    UILabel *salaryLB = [[UILabel alloc]init];
    salaryLB.text = @"基础薪资(元/月)";
    salaryLB.textColor = GRAY100;
    salaryLB.font = [UIFont systemFontOfSize:16];
    [self addSubview:salaryLB];
    [salaryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
        make.top.equalTo(nameLB.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
    self.nameTF = [[UITextField alloc] init];
    self.nameTF.placeholder = @"输入薪资组名";
    self.nameTF.delegate = self;
    self.nameTF.textColor = GRAY70;
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameTF.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.nameTF];
    self.nameTF.font = [UIFont systemFontOfSize:16];
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
        make.bottom.equalTo(nameLB.mas_bottom);
        make.left.equalTo(nameLB.mas_right).offset(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
//    UIView *nameBottom = [[UIView alloc] init];
//    [self addSubview:nameBottom];
//    nameBottom.backgroundColor = VIEW_BASE_COLOR;
//    [nameBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameTF.mas_bottom).offset(0);
//        make.right.equalTo(self.nameTF.mas_right);
//        make.left.equalTo(self.nameTF.mas_left);
//        make.height.mas_equalTo(0.3);
//    }];
    
    UIImageView *starImageOne = [[UIImageView alloc] init];
    starImageOne.image = [UIImage imageNamed:@"星号"];
    [self addSubview:starImageOne];
    [starImageOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameTF.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(5);
    }];
    
    self.salaryTF = [[UITextField alloc] init];
    self.salaryTF.placeholder = @"输入基础薪资";
    self.salaryTF.delegate = self;
    self.salaryTF.textColor = GRAY70;
    self.salaryTF.keyboardType = UIKeyboardTypeNumberPad;
    self.salaryTF.textAlignment = NSTextAlignmentRight;
    [self.salaryTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.salaryTF];
    self.salaryTF.font = [UIFont systemFontOfSize:16];
    [self.salaryTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25*KAdaptiveRateWidth);
        make.bottom.equalTo(salaryLB.mas_bottom);
        make.left.equalTo(nameLB.mas_right).offset(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
//    UIView *salaryBottom = [[UIView alloc] init];
//    [self addSubview:salaryBottom];
//    salaryBottom.backgroundColor = VIEW_BASE_COLOR;
//    [salaryBottom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.salaryTF.mas_bottom).offset(0);
//        make.right.equalTo(self.salaryTF.mas_right);
//        make.left.equalTo(self.salaryTF.mas_left);
//        make.height.mas_equalTo(0.3);
//    }];
    
    UIImageView *starImageTwo = [[UIImageView alloc] init];
    starImageTwo.image = [UIImage imageNamed:@"星号"];
    [self addSubview:starImageTwo];
    [starImageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.salaryTF.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(5);
    }];
    
}
- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger kMaxLength ;
    if (textField == self.nameTF) {
        kMaxLength = 10;
        
    } else {
        kMaxLength = 8;
        
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
