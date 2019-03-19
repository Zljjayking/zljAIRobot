//
//  MemberButtonCell.m
//  Financeteam
//
//  Created by 张正飞 on 16/7/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "MemberButtonCell.h"

@implementation MemberButtonCell

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
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:[UIImage imageNamed:@"单选框"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"单选框（亮）"] forState:UIControlStateSelected];
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.leftButton.mas_right).offset(5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        
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
