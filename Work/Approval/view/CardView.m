//
//  CardView.m
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(void)loadCardViewWithDictionary:(NSDictionary *)dictionary
{
    for (UIView *vv in [self subviews]) {
        [vv removeFromSuperview];
    }
    self.backgroundColor = [UIColor clearColor];
    NSString *svgName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"imageName"]];
    UIImageView *svgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:svgName]];
    svgView.backgroundColor = [UIColor clearColor];
    svgView.frame = CGRectMake(0, 0, self.frame.size.width, 280*KAdaptiveRateWidth);
//    SVGKImage *svgImg=[SVGKImage imageWithContentsOfFile:svgName];
//    
//    SVGKLayeredImageView *svgView = [[SVGKLayeredImageView alloc] initWithSVGKImage:svgImg];
//    
//    svgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    
    [self addSubview:svgView];
//    self.backgroundColor = RGBCOLOR([[dictionary objectForKey:@"red"] floatValue], [[dictionary objectForKey:@"green"] floatValue], [[dictionary objectForKey:@"blue"] floatValue]);
    
}

@end
