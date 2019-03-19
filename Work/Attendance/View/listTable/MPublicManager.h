//
//  MPublicManager.h
//  ZSListTableView
//
//  Created by 张帅 on 17/3/30.
//  Copyright © 2017年 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MPublicManager : NSObject
//动态计算高度
+ (CGSize)workOutSizeWithStr:(NSString *)str andFont:(UIFont*)font value:(NSValue *)value;
@end
