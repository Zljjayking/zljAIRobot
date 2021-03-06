//
//  ExeOrderListCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/9/14.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExeOrderListCell.h"

@implementation ExeOrderListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView{
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.textColor = [UIColor grayColor];
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
        
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = TABBAR_BASE_COLOR;
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
        
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
