//
//  ExeTopCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/9/23.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExeTopCell.h"

@implementation ExeTopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView{
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:13];
   // self.leftLabel.backgroundColor = [UIColor yellowColor];
    self.leftLabel.textColor = [UIColor grayColor];
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(23);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:13];
  //  self.rightLabel.backgroundColor = [UIColor yellowColor];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-1);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        
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
