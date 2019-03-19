//
//  CommonCell.m
//  365FinanceCircle
//
//  Created by kpkj-ios on 16/1/13.
//  Copyright © 2016年 kpkj-ios. All rights reserved.
//

#import "CommonCell.h"
//cell 200 40
@implementation CommonCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // 209 209 209
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = MYGRAY;
        self.textLabel.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:13]];
        
        _whiteView = [[UIView alloc] init];
        _whiteView.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(200-41, 9, 26, 26)];
        _whiteView.layer.cornerRadius = [UIAdaption getAdaptiveWidthWith5SWidth:13];
        _whiteView.layer.borderColor = [[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1] CGColor];
        _whiteView.layer.borderWidth = 1.5;
        _whiteView.layer.masksToBounds = YES;
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whiteView];
        
        _blackView = [[UIView alloc] init];
        _blackView.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(200-33, 17, 10, 10)];
        _blackView.layer.cornerRadius = [UIAdaption getAdaptiveWidthWith5SWidth:5];
        _blackView.layer.masksToBounds = YES;
        _blackView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0  blue:241/255.0  alpha:1] ;
        [self.contentView addSubview:_blackView];
        
        _cusLine = [[UIView alloc] init];
        _cusLine.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(0, 43.6, 200, 0.35)];
        _cusLine.backgroundColor = MYGRAY;
        [self.contentView addSubview:_cusLine];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
