//
//  ExeResultFoldCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/9/13.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ExeResultFoldCell.h"

@implementation ExeResultFoldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setView];
    }
    return self;
}

-(void)setView{
    
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        
    }];
    
    self.rightLabel = [[UILabel alloc]init];
  //  self.rightLabel.backgroundColor = [UIColor yellowColor];
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = TABBAR_BASE_COLOR;
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-35);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        
    }];
    
    self.foldImage = [[UIImageView alloc]init];
    self.foldImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.foldImage];
    [self.foldImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(10);
        
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
