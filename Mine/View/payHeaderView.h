//
//  payHeaderView.h
//  Financeteam
//
//  Created by Zccf on 2017/7/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define PI 3.14159265358979323846
@interface payHeaderView : UIView
@property (nonatomic) CAShapeLayer *maskLayer;
@property (nonatomic) CALayer *contentLayer;
//- (void)setImage:(UIImage*)image;
//@property (nonatomic) UIImage *image;
//@property (nonatomic)
@property (nonatomic ,assign) CGFloat ssheight;
@end
