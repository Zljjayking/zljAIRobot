//
//  SelectProductCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/7.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SelectProductCell.h"

@implementation SelectProductCell

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, rect);
//    
//    //上分割线，
//    //  CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    //  CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
//    
//    //下分割线
//    CGContextSetStrokeColorWithColor(context, VIEW_BASE_COLOR.CGColor);
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width - 10, 0.8));
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectProLabel.font = [UIFont systemFontOfSize:15];
    self.selectProLabel.textColor = MYGRAY;
    self.selectProButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
//    [self.selectProLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.mas_centerY);
//    }];
//    [self.selectProButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.selectProLabel.mas_right).offset(10);
//    }];
    UIView *separator = [[UIView alloc]init];
    separator.backgroundColor = VIEW_BASE_COLOR;
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-0.4);
        make.height.mas_equalTo(0.4);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
