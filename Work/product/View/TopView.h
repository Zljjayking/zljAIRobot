//
//  TopView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopViewDelegate <NSObject>

-(void)clickBtn:(NSInteger)page;

@end


@interface TopView : UIView

@property(nonatomic,strong)NSArray* titleArray;

@property(nonatomic,assign)id<TopViewDelegate> delegate;

//更新的按钮的颜色,传按钮的tag值
-(void)resetBtnStatus:(NSInteger )btnTag;

@end
