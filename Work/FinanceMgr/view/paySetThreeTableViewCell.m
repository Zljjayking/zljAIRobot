//
//  paySetThreeTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/5/2.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "paySetThreeTableViewCell.h"

@implementation paySetThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(7*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-7*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
    UIView *bgViewTwo = [[UIView alloc] init];
    bgViewTwo.backgroundColor = kMyColor(249, 249, 249);
    [self addSubview: bgViewTwo];
    [bgViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(19*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-19*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIView *bgViewThree = [[UIView alloc] init];
    bgViewThree.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgViewThree];
    [bgViewThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(22*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(-22*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    self.ll = [[UILabel alloc] init];
    self.ll.backgroundColor = kMyColor(234, 234, 234);
    self.ll.textAlignment = NSTextAlignmentCenter;
    self.ll.textColor = GRAY90;
    [self addSubview:self.ll];
    [self.ll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(22*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5*KAdaptiveRateWidth);
        make.width.mas_equalTo(30);
    }];
    self.ll.text = @"1";
    
    
    self.minTF = [[UITextField alloc]init];
    self.minTF.placeholder = @"最小值";
    self.minTF.textAlignment = NSTextAlignmentCenter;
    self.minTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.minTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.minTF];
    self.minTF.delegate = self;
    self.minTF.font = [UIFont systemFontOfSize:14];
    [self.minTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ll.mas_right).offset(2*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        //make.width.mas_equalTo(35);
    }];
    
    UILabel *leftLB = [[UILabel alloc]init];
    leftLB.text = @"万 -";
    leftLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:leftLB];
    [leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minTF.mas_right).offset(2*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    self.maxTF = [[UITextField alloc]init];
    self.maxTF.placeholder = @"最大值";
    [self.maxTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.maxTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.maxTF.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.maxTF];
    self.maxTF.delegate = self;
    self.maxTF.font = [UIFont systemFontOfSize:14];
    [self.maxTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftLB.mas_right).offset(2*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        //make.width.mas_equalTo(35);
    }];
    
    UILabel *centerLB = [[UILabel alloc]init];
    centerLB.text = @"万元";
    centerLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:centerLB];
    [centerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maxTF.mas_right).offset(2*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    self.percentTF = [[UITextField alloc]init];
    self.percentTF.placeholder = @"百分比";
    self.percentTF.textColor = TABBAR_BASE_COLOR;
    self.percentTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.percentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.percentTF.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.percentTF];
    self.percentTF.delegate = self;
    self.percentTF.font = [UIFont systemFontOfSize:14];
    [self.percentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgViewThree.mas_right).offset(-5*KAdaptiveRateWidth-20*KAdaptiveRateWidth - 14);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        //make.width.mas_equalTo(70*KAdaptiveRateWidth);
    }];
    
    UILabel *rightLB = [[UILabel alloc]init];
    rightLB.text = @"%";
    rightLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:rightLB];
    [rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgViewThree.mas_right).offset(-5*KAdaptiveRateWidth-20*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];

    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(bgViewThree.mas_right).offset(-2*KAdaptiveRateWidth);
        make.width.mas_equalTo(20*KAdaptiveRateWidth);
        make.height.mas_equalTo(20*KAdaptiveRateWidth);
    }];
    
}
- (void)textFieldDidChange:(UITextField*)textField {
    if (textField == self.minTF || textField == self.maxTF ) {
        if (textField.text.length > 5) {
            textField.text = [textField.text substringToIndex:5];
        }
    } else {
        if (textField.text.length > 4) {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.percentTF) {
        if ([textField.text floatValue]>100) {
            textField.text = @"100";
        }
        if ([Utils isBlankString:textField.text]) {
            textField.text = @"0";
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
