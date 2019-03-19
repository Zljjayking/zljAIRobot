//
//  BottomView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

-(void)clickButton:(NSInteger)page;

@end

@interface BottomView : UIView

@property(nonatomic,strong)NSArray * titleArray;

@property(nonatomic,assign) id<BottomViewDelegate> delegate;

//更新的按钮的颜色,传按钮的tag值
-(void)resetBtnStatus:(NSInteger )btnTag;
@end
