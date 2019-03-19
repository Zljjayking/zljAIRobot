//
//  ProductOtherCell.m
//  365FinanceCircle
//
//  Created by kpkj-ios on 15/8/27.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import "ProdTwoCell.h"
//77 cell
@implementation ProdTwoCell
{
    UIView * _separatorView;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
            make.top.equalTo(self.mas_top).offset(10);
            make.height.mas_equalTo(17);
        }];
        
        _label = [[UILabel alloc]init];
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:13];
        _label.textColor = GRAY120;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
            make.right.equalTo(self.mas_right).offset(-15*KAdaptiveRateWidth);
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = GRAY240;
        [self addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15*KAdaptiveRateWidth);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    CGRect rect = _label.frame;
//    rect.size.height = self.contentView.bounds.size.height - [UIAdaption getAdaptiveHeightWith5SHeight:47];
//    _label.frame = rect;
    
//    CGRect rect1 = _separatorView.frame;
//    rect1.origin.y = self.contentView.bounds.size.height-[UIAdaption getAdaptiveHeightWith5SHeight:1];
//    _separatorView.frame = rect1;
    
}

@end
