    //
//  BianjiProductTableViewCell.m
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/27.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BianjiProductTableViewCell.h"

@implementation BianjiProductTableViewCell

@synthesize nameLb;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // nameLb
        nameLb = [[UILabel alloc]init];
        nameLb.center   = CGPointMake([UIAdaption getAdaptiveWidthWith6Width:40], self.frame.size.height/2.0);
        nameLb.bounds   = [UIAdaption getAdaptiveRectWith6Rect:CGRectMake(0, 0, 80, 50)];
        nameLb.font     = [UIFont systemFontOfSize:[UIAdaption getAdaptiveHeightWith6Height:15]];
        nameLb.textColor=MYGRAY;
        nameLb.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:nameLb];
        
        // 输入框
        _longTV = [[UITextView alloc] init];
        _longTV.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(95, 8, 220, 30)];
        _longTV.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:13]];
        _longTV.textColor = MYGRAY;
        _longTV.tag = 100;
        _longTV.scrollEnabled = NO;
        _longTV.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:_longTV];
        
        self.placeholderLb = [[UILabel alloc]init];
        self.placeholderLb.font = [UIFont systemFontOfSize:14];
        self.placeholderLb.frame =CGRectMake(5, 5, kScreenWidth - 4, 20);
        self.placeholderLb.text = @"";
        self.placeholderLb.enabled = NO;//lable必须设置为不可用
        self.placeholderLb.textColor = [UIColor lightGrayColor];
        //uilabel.backgroundColor = [UIColor clearColor];
        [_longTV addSubview:self.placeholderLb];
        


    }
    
    return self;

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect longTvRect = _longTV.frame;
    longTvRect.size.height = self.frame.size.height - [UIAdaption getAdaptiveHeightWith5SHeight:14];
    _longTV.frame = longTvRect;
}

@end
