//
//  ProductShowCell.m
//  365FinanceCircle
//
//  Created by kpkj-ios on 15/8/27.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import "ProdOneCell.h"
//64
@implementation ProdOneCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {self.selectionStyle = UITableViewCellSelectionStyleNone;
        _icon = [[UIImageView alloc] init];
        _icon.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:_icon];
        
        _prodName = [[UILabel alloc] init];
        _prodName.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(83, 10, 240, 21)];
        _prodName.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:15]];
        _prodName.textColor = MYGRAY;
        [self.contentView addSubview:_prodName];
        
        
        UIImageView * littleIcon1 = [[UIImageView alloc] initWithFrame:[UIAdaption getAdaptiveRectWith5SRect:CGRectMake(65, 40, 10, 10)]];
        littleIcon1.image = [UIImage imageNamed:@"对号"];
        [self.contentView addSubview:littleIcon1];
        
        _prodGoods = [[UILabel alloc] init];
        _prodGoods.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(83, 38, 220, 15)];
        _prodGoods.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:13]];
        _prodGoods.textColor = MYGRAY;
        [self.contentView addSubview:_prodGoods];
        
        UIImageView * littleIcon2 = [[UIImageView alloc] initWithFrame:[UIAdaption getAdaptiveRectWith5SRect:CGRectMake(65, 60, 10, 10)]];
        littleIcon2.image = [UIImage imageNamed:@"clock-icon"];
        [self.contentView addSubview:littleIcon2];
        
        _prodTime = [[UILabel alloc] init];
        _prodTime.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(83, 58, 220, 15)];
        _prodTime.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:13]];
        _prodTime.textColor = MYGRAY;
        [self.contentView addSubview:_prodTime];
        
        UIImageView * littleIcon3 = [[UIImageView alloc] initWithFrame:[UIAdaption getAdaptiveRectWith5SRect:CGRectMake(65, 80, 10, 10)]];
        littleIcon3.image = [UIImage imageNamed:@"clock-icon"];
        [self.contentView addSubview:littleIcon3];
        
        _rate = [[UILabel alloc] init];
        _rate.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(83, 78, 220, 15)];
        _rate.font = [UIFont systemFontOfSize:[UIAdaption getAdaptiveWidthWith5SWidth:13]];
        _rate.textColor = MYGRAY;
        [self.contentView addSubview:_rate];

        
        UIView * separatorView = [[UIView alloc] init];
        separatorView.frame = [UIAdaption getAdaptiveRectWith5SRect:CGRectMake(0, 100, 320, 3)];
        separatorView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        [self.contentView addSubview:separatorView];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
