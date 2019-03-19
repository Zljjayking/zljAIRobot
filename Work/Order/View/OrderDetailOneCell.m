//
//  OrderDetailOneCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/21.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "OrderDetailOneCell.h"

@implementation OrderDetailOneCell
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
//    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width - 10, 1));
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    self.iconImageView.layer.cornerRadius = 5;
    //裁剪一个角
    self.speedLabel.layer.cornerRadius = 3;
    self.speedLabel.layer.masksToBounds = YES;
    
    self.pushBtn.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
