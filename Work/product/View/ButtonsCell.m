//
//  ButtonsCell.m
//
//
//  Created by 张正飞 on 16/6/15.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ButtonsCell.h"

@implementation ButtonsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.titleLabel.textColor = GRAY90;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
//        UIView *line = [[UIView alloc]init];
//        line.backgroundColor = VIEW_BASE_COLOR;
//        [self addSubview:line];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(18);
//            make.bottom.equalTo(self.mas_bottom);
//            make.right.equalTo(self.mas_right);
//            make.height.mas_equalTo(0.5);
//        }];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
//
//  //  上分割线，
//     CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//     CGContextStrokeRect(context, CGRectMake(15, -1, rect.size.width - 15, 0.1));
//    
//    //下分割线
    CGContextSetStrokeColorWithColor(context, GRAY229.CGColor);
    CGContextStrokeRect(context, CGRectMake(18, rect.size.height-0.1, rect.size.width - 18, 0.0));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
