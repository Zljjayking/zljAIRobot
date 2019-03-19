//
//  ChooseButton.m
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "ChooseButton.h"

@implementation ChooseButton

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.showsTouchWhenHighlighted = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setTintColor:TABBAR_BASE_COLOR];
        self.btnImage = [[UIImageView alloc] init];
        self.btnImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.btnImage];
        [self.btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.mas_top).offset(20);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        self.label = [[UILabel alloc]init];
        [self addSubview:self.label];
        self.label.font = [UIFont systemFontOfSize:12];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.centerY.mas_equalTo(self.mas_centerY).offset(15);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(12);
        }];
        
    }
    return self;
}


@end
