//
//  MemberLabelCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MemberLabelCell.h"

@implementation MemberLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
    self.memberLabel = [[UILabel alloc]init];
    self.memberLabel.font = [UIFont systemFontOfSize:15 weight:1];
    self.memberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.memberLabel];
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        
    }];

}

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
    CGContextStrokeRect(context, CGRectMake(10, rect.size.height, rect.size.width - 10, 1));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
