//
//  MemberTextFieldCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/19.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MemberTextFieldCell.h"

@implementation MemberTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.backgroundImage  = [[UIImageView alloc]init];
    self.backgroundImage.image = [UIImage imageNamed:@"自定义输入框"];
    [self addSubview:self.backgroundImage];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
    
    self.customTextField = [[UITextField alloc]init];
    self.customTextField.borderStyle = UITextBorderStyleNone;
    self.customTextField.tintColor = TABBAR_BASE_COLOR;
  //  self.customTextField.placeholder = @"请输入时长";
    self.customTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.customTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.customTextField.returnKeyType = UIReturnKeyDone;
    self.customTextField.font = [UIFont systemFontOfSize:14];
    self.customTextField.delegate = self;
    [self addSubview:self.customTextField];
    [self.customTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
