//
//  productTableViewCell.m
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "productTableViewCell.h"

@implementation productTableViewCell

static NSString *identifier = @"cell";
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)cellWithTableView:(UITableView *)tableView {
    
    // 1.缓存中取
    productTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[productTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setupView {
    self.mechProIcon = [[UIImageView alloc]init];
    [self addSubview:self.mechProIcon];
    self.mechProIcon.layer.masksToBounds = YES;
    [self.mechProIcon.layer setCornerRadius:5];
    self.mechProIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.mechProIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    self.mechProNameLB = [[UILabel alloc]init];
    [self addSubview:self.mechProNameLB];
    self.mechProNameLB.font = [UIFont systemFontOfSize:17];
    [self.mechProNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mechProIcon.mas_right).offset(15);
        //        make.right.equalTo(self.applyBtn.mas_left).offset(-2);
        make.height.mas_equalTo(17);
        
    }];
    
    self.signImageView = [[UIImageView alloc]init];
    [self addSubview:self.signImageView];
    self.signImageView.hidden = YES;
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    
    self.officalProImage = [[UIImageView alloc]init];
    [self addSubview:self.officalProImage];
    self.officalProImage.hidden = YES;
    [self.officalProImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(14);
    }];
    /**
     UIView *separatorLine = [[UIView alloc]init];
     separatorLine.backgroundColor = VIEW_BASE_COLOR;
     [self addSubview:separatorLine];
     [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.mechProIcon.mas_right).offset(15*KAdaptiveRateWidth);
     make.top.equalTo(self.mechProNameLB.mas_bottom).offset(6*KAdaptiveRateHeight);
     make.right.equalTo(self.mas_right).offset(0);
     make.height.mas_equalTo(1);
     }];
     */
    
    
    // 创建一个imageView 高度是你想要的虚线的高度 一般设为2
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(75, 35, kScreenWidth-75, 2)];
    // 调用方法 返回的iamge就是虚线
    lineImg.image = [self drawLineOfDashByImageView:lineImg];
    // 添加到控制器的view上
    [self addSubview:lineImg];
    
    UIImageView *point_Type = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小红点"]];
    point_Type.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:point_Type];
    [point_Type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mechProIcon.mas_right).offset(15);
        make.top.equalTo(lineImg.mas_bottom).offset(11);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(3);
    }];
    
    self.mechProTypeLB = [[UILabel alloc]init];
    [self addSubview:self.mechProTypeLB];
    self.mechProTypeLB.font = [UIFont systemFontOfSize:15];
    self.mechProTypeLB.textColor = MYGRAY;
    [self.mechProTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point_Type.mas_right).offset(6);
        make.centerY.mas_equalTo(point_Type.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *point_day = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小红点"]];
    point_day.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:point_day];
    [point_day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mechProIcon.mas_right).offset(15);
        make.top.equalTo(self.mechProTypeLB.mas_bottom).offset(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(3);
    }];
    
    self.dayLB = [[UILabel alloc]init];
    [self addSubview:self.dayLB];
    self.dayLB.font = [UIFont systemFontOfSize:15];
    self.dayLB.textColor = MYGRAY;
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point_day.mas_right).offset(6);
        make.centerY.mas_equalTo(point_day.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *point_method = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小红点"]];
    point_method.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:point_method];
    [point_method mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mechProIcon.mas_right).offset(15);
        make.top.equalTo(self.dayLB.mas_bottom).offset(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(3);
    }];
    
    self.methodLB = [[UILabel alloc]init];
    [self addSubview:self.methodLB];
    self.methodLB.font = [UIFont systemFontOfSize:15];
    self.methodLB.textColor = MYGRAY;
    [self.methodLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point_method.mas_right).offset(6);
        make.centerY.mas_equalTo(point_method.mas_centerY);
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *point_Goodness = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小红点"]];
    point_Goodness.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:point_Goodness];
    [point_Goodness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLB.mas_right).offset(33*KAdaptiveRateWidth);
        make.top.equalTo(lineImg.mas_bottom).offset(11);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(3);
    }];
    
    self.tabInterestRateLB = [[UILabel alloc]init];
    [self addSubview:self.tabInterestRateLB];
    self.tabInterestRateLB.font = [UIFont systemFontOfSize:15];
    self.tabInterestRateLB.textColor = MYGRAY;
    [self.tabInterestRateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point_Goodness.mas_right).offset(6*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(point_Goodness.mas_centerY);
        
        make.height.mas_equalTo(15);
    }];
    
    UIImageView *point_cash = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小红点"]];
    point_cash.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:point_cash];
    [point_cash mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLB.mas_right).offset(33*KAdaptiveRateWidth);
        make.top.equalTo(self.mechProTypeLB.mas_bottom).offset(10);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(3);
    }];
    
    self.cashLB = [[UILabel alloc]init];
    [self addSubview:self.cashLB];
    self.cashLB.font = [UIFont systemFontOfSize:15];
    self.cashLB.textColor = MYGRAY;
    [self.cashLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(point_cash.mas_right).offset(6*KAdaptiveRateWidth);
        make.centerY.mas_equalTo(point_cash.mas_centerY);
        make.height.mas_equalTo(15);

    }];
    
    
    
}

- (void)initView {
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectedBackgroundView.backgroundColor = kMyColor(240, 240, 240);
    
    
    self.mechProIcon = [[UIImageView alloc]init];
    [self addSubview:self.mechProIcon];
    self.mechProIcon.layer.masksToBounds = YES;
    [self.mechProIcon.layer setCornerRadius:6.5];
    [self.mechProIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];

    self.mechProNameLB = [[UILabel alloc]init];
    [self addSubview:self.mechProNameLB];
    self.mechProNameLB.textColor = GRAY50;
    self.mechProNameLB.font = [UIFont systemFontOfSize:16];
    [self.mechProNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mechProIcon.mas_centerY);
        make.left.equalTo(self.mechProIcon.mas_right).offset(10*KAdaptiveRateWidth);
        make.height.mas_equalTo(16);
    }];
    
    self.signImageView = [[UIImageView alloc]init];
    [self addSubview:self.signImageView];
    self.signImageView.hidden = YES;
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *RateLB = [[UILabel alloc]init];
    [self addSubview:RateLB];
    RateLB.font = [UIFont systemFontOfSize:12];
    RateLB.text = @"月利率：";
    RateLB.textColor = MYGRAY;
    [RateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13*KAdaptiveRateWidth);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        make.height.mas_equalTo(12);
    }];
    
    self.tabInterestRateLB = [[UILabel alloc]init];
    [self addSubview:self.tabInterestRateLB];
    self.tabInterestRateLB.font = [UIFont systemFontOfSize:34];
    self.tabInterestRateLB.textColor = kMyColor(140, 215, 206);
    [self.tabInterestRateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(RateLB.mas_right).offset(0*KAdaptiveRateWidth);
        make.bottom.equalTo(RateLB.mas_bottom).offset(4);
        make.height.mas_equalTo(34);
    }];
    
    UILabel *persantLB = [[UILabel alloc]init];
    [self addSubview:persantLB];
    persantLB.font = [UIFont systemFontOfSize:12];
    persantLB.text = @"%";
    persantLB.textColor = MYGRAY;
    [persantLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tabInterestRateLB.mas_right).offset(5*KAdaptiveRateWidth);
        make.bottom.equalTo(RateLB.mas_bottom).offset(0);
        make.height.mas_equalTo(12);
    }];

    self.mechProTypeLB = [[UILabel alloc]init];
    [self addSubview:self.mechProTypeLB];
    self.mechProTypeLB.font = [UIFont systemFontOfSize:10];
    self.mechProTypeLB.textColor = customBlue;
    [self.mechProTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-125);
        make.bottom.equalTo(RateLB.mas_bottom).offset(-30);
        make.height.mas_equalTo(10);
    }];
    
    self.dayLB = [[UILabel alloc]init];
    [self addSubview:self.dayLB];
    self.dayLB.font = [UIFont systemFontOfSize:10];
    self.dayLB.textColor = MYGRAY;
    [self.dayLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-125);
        make.top.equalTo(self.mechProTypeLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *dLB = [[UILabel alloc]init];
    [self addSubview:dLB];
    dLB.font = [UIFont systemFontOfSize:10];
    dLB.text = @"（天）";
    dLB.textColor = GRAY180;
    [dLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLB.mas_right).offset(0*KAdaptiveRateWidth);
        make.top.equalTo(self.mechProTypeLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];

    self.cashLB = [[UILabel alloc]init];
    [self addSubview:self.cashLB];
    self.cashLB.font = [UIFont systemFontOfSize:10];
    self.cashLB.textColor = MYGRAY;
    [self.cashLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-125);
        make.top.equalTo(self.dayLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *cLB = [[UILabel alloc]init];
    [self addSubview:cLB];
    cLB.font = [UIFont systemFontOfSize:10];
    cLB.text = @"（万元）";
    cLB.textColor = GRAY180;
    [cLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cashLB.mas_right).offset(0*KAdaptiveRateWidth);
        make.top.equalTo(self.dayLB.mas_bottom).offset(5);
        make.height.mas_equalTo(10);
    }];
    
//    self.methodLB = [[UILabel alloc]init];
//    [self addSubview:self.methodLB];
//    self.methodLB.font = [UIFont systemFontOfSize:11];
//    self.methodLB.textColor = MYGRAY;
//    [self.methodLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_right).offset(-140);
//        make.top.equalTo(self.cashLB.mas_bottom).offset(5);
//        make.height.mas_equalTo(11);
//    }];
    
    UIView *seperator = [[UIView alloc]init];
    [self addSubview:seperator];
    seperator.backgroundColor = GRAY240;
    [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12*KAdaptiveRateWidth);
        make.top.equalTo(self.mas_bottom).offset(-0.4);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(0.5);
    }];
}
- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
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
