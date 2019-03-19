//
//  SettingTableViewCell.m
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        _iconImageV          = [[UIImageView alloc]init];
        [self addSubview:_iconImageV];
        [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        //_iconImageV.frame    = [UIAdaption getAdaptiveRectWith6Rect:CGRectMake(15, 10, 30, 30)];
        _iconImageV.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageV.layer.masksToBounds = YES;
        //_iconImageV.layer.cornerRadius  = [UIAdaption getAdaptiveHeightWith6Height:10];
        
        
        _titleLb             = [[UILabel alloc]init];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.iconImageV.mas_right).offset(15);
            make.height.mas_equalTo(30);
        }];
        _titleLb.textColor   = GRAY90;
        _titleLb.font        = [UIFont systemFontOfSize:16];
        
        
        UIView *seperator = [[UIView alloc]init];
        [self addSubview:seperator];
        seperator.backgroundColor = GRAY240;
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    //  CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //  CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, VIEW_BASE_COLOR.CGColor);
    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width - 10, 0.8));
}
 */

@end
