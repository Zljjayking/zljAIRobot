//
//  CRMTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "CRMTableViewCell.h"

@implementation CRMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
//    UIView *separatorLine = [[UIView alloc] init];
//    separatorLine.backgroundColor = VIEW_BASE_COLOR;
//    [self addSubview:separatorLine];
//    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.realNameLB.mas_left).offset(-10);
//        make.left.equalTo(self.mas_left).offset(20*KAdaptiveRateWidth);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.height.mas_equalTo(1);
//    }];
    
//    [self drawLineOfDashByCAShapeLayer:separatorLine lineLength:200*KAdaptiveRateWidth lineSpacing:3 lineColor:GRAY240];
    
    self.headerImage = [[UIImageView alloc] init];
    [self addSubview:self.headerImage];
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(5*KAdaptiveRateWidth);
    }];
    
    self.nameLB = [[UILabel alloc] init];
    self.nameLB.font = [UIFont systemFontOfSize:17];
//    self.nameLB.textColor = GRAY90;
    [self addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    self.systemAllocationLB = [[UILabel alloc]init];
    self.systemAllocationLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.systemAllocationLB];
    self.systemAllocationLB.textColor = MYGRAY;
    [self.systemAllocationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB.mas_right).offset(5*KAdaptiveRateWidth);
        make.centerY.equalTo(self.nameLB.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    self.signLB = [[UILabel alloc]init];
    self.signLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.signLB];
    self.signLB.textColor = [UIColor redColor];
    [self.signLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.systemAllocationLB.mas_right).offset(5);
        make.centerY.equalTo(self.nameLB.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *signImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CRMSign"]];
    [self addSubview:signImage];
    [signImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(30);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    
    self.statusLB = [[UILabel alloc] init];
    self.statusLB.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.statusLB];
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5*KAdaptiveRateWidth);
        make.centerY.equalTo(signImage.mas_centerY);
        make.height.mas_equalTo(16);
    }];
    
    
    self.mobilLB = [[UILabel alloc] init];
    self.mobilLB.font = [UIFont systemFontOfSize:14];
    self.mobilLB.textColor = MYGRAY;
    [self addSubview:self.mobilLB];
    [self.mobilLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(15*KAdaptiveRateWidth);
        make.top.equalTo(self.nameLB.mas_bottom).offset(7);
        make.height.mas_equalTo(20);
    }];
    
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(20*KAdaptiveRateWidth, 63, 1000-20*KAdaptiveRateWidth, 2)];
    // 调用方法 返回的iamge就是虚线
    lineImg.image = [self drawLineOfDashByImageView:lineImg];
    // 添加到控制器的view上
    [self addSubview:lineImg];
    
    self.realNameLB = [[UILabel alloc] init];
    self.realNameLB.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.realNameLB];
    self.realNameLB.textColor = MYGRAY;
    [self.realNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(15*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.createTimeLB = [[UILabel alloc] init];
    self.createTimeLB.font = [UIFont systemFontOfSize:13];
    self.createTimeLB.textColor = MYGRAY;
    [self addSubview:self.createTimeLB];
    [self.createTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-13);
        make.height.mas_equalTo(14);
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
    
    CGContextSetStrokeColorWithColor(line, GRAY210.CGColor);
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
