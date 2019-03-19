//
//  OrderDetailThreeCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/22.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OrderDetailThreeCell.h"

@implementation OrderDetailThreeCell
- (void)drawRect:(CGRect)rect
{
    self.phoneLabel.textColor = GRAY90;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    //  CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //  CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, VIEW_BASE_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width - 10, 1));
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
