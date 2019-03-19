//
//  employeePayTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 17/4/27.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "employeePayTableViewCell.h"

@implementation employeePayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.backgroundColor = VIEW_BASE_COLOR;
    self.signView = [[UIView alloc]init];
    self.signView.layer.cornerRadius = 7;
    [self addSubview:self.signView];
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    self.signView.layer.borderColor = VIEW_BASE_COLOR.CGColor;
    self.signView.layer.borderWidth = 0.3;
    
    self.signView.layer.shadowOpacity = 0.5f;// 阴影透明度
    
    self.signView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    
    self.signView.layer.shadowRadius = 2;// 阴影扩散的范围控制
    
    self.signView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    
    
    UIView *bgViewOne = [[UIView alloc]init];
    bgViewOne.layer.cornerRadius = 7;
    bgViewOne.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgViewOne];
    [bgViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    UIView *bgViewTwo = [[UIView alloc]init];
    [self addSubview:bgViewTwo];
    bgViewTwo.backgroundColor = [UIColor whiteColor];
    [bgViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.left.equalTo(self.mas_left).offset(17);
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    
    self.nameLB = [[UILabel alloc]init];
    self.nameLB.textColor = GRAY70;
    self.nameLB.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(35);
        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    self.perNumLB = [[UILabel alloc]init];
    [self addSubview:self.perNumLB];
    self.perNumLB.font = [UIFont systemFontOfSize:16];
    self.perNumLB.textColor = GRAY90;
    [self.perNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *people = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renShu"]];
    [self addSubview:people];
    [people mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.perNumLB.mas_left).offset(-5);
        make.top.equalTo(self.mas_top).offset(15*KAdaptiveRateWidth);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    UIView *seperator = [[UIView alloc] init];
    seperator.backgroundColor = GRAY229;
    [self addSubview:seperator];
    [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.left.equalTo(self.mas_left).offset(35);
        make.height.mas_equalTo(0.3);
        make.width.mas_equalTo(kScreenWidth-60);
    }];
    
    
    self.basePayLB = [[UILabel alloc]init];
    [self addSubview:self.basePayLB];
    self.basePayLB.font = [UIFont systemFontOfSize:16];
    self.basePayLB.textColor = GRAY120;
    [self.basePayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(35);
        make.top.equalTo(seperator.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(kScreenWidth-60);
        make.height.mas_equalTo(20);
    }];
    
    self.TiChengLB = [[UILabel alloc]init];
    [self addSubview:self.TiChengLB];
    self.TiChengLB.font = [UIFont systemFontOfSize:16];
    self.TiChengLB.textColor = GRAY120;
    [self.TiChengLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(35);
        make.top.equalTo(self.basePayLB.mas_bottom).offset(10*KAdaptiveRateWidth);
        make.width.mas_equalTo(kScreenWidth-60);
        make.height.mas_equalTo(20);
    }];
}

- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, 1000, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,3};
    
    CGContextSetStrokeColorWithColor(line, GRAY190.CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 1000, 2.0);
    
    CGContextStrokePath(line);
    
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
