//
//  ContentView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/23.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyBlock)();

@interface ContentView : UIView

-(void)ContentViewWithMessage:(NSAttributedString *)message andBlock:(MyBlock) block;

@end
