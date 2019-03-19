//
//  MDOneTableViewCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/25.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MDOneTableViewCell.h"

@implementation MDOneTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textColor = [UIColor grayColor];
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(180);
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
        make.width.mas_equalTo(50);
//        make.height.mas_equalTo(20);
        
    }];
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
