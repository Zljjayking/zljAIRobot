//
//  setHideTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/8/4.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "setHideTableViewCell.h"

@implementation setHideTableViewCell

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
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:16];
    self.leftLabel.textColor = [UIColor grayColor];
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
//        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    self.rightSwitch = [[UISwitch alloc]init];
    self.rightSwitch.onTintColor = TABBAR_BASE_COLOR;
    self.rightSwitch.tintColor = VIEW_BASE_COLOR;
    //    [self.rightSwitch setOn:NO animated:YES];
    [self addSubview:self.rightSwitch];
    [self.rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        //  make.centerY.mas_equalTo(self.mas_centerY);
        make.top.equalTo(self.mas_top).offset(8);
        //        make.width.mas_equalTo(50);
        //        make.height.mas_equalTo(20);
        
    }];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
