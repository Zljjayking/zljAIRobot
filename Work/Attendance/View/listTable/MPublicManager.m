//
//  MPublicManager.m
//  ZSListTableView
//
//  Created by 张帅 on 17/3/30.
//  Copyright © 2017年 张帅. All rights reserved.
//

#import "MPublicManager.h"
#import <UIKit/UIKit.h>
@implementation MPublicManager
//动态计算高度
+ (CGSize)workOutSizeWithStr:(NSString *)str andFont:(UIFont*)font value:(NSValue *)value{
    CGSize size;
    if (str == nil) {
        str = @"";
    }
    if (str) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size=[str boundingRectWithSize:[value CGSizeValue] options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    }
    
    return size;
}
@end
