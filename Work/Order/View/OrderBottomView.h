//
//  OrderBottomView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderBottomViewDelegate <NSObject>

-(void)clickButton:(NSInteger)page;

@end

@interface OrderBottomView : UIView

@property(nonatomic,strong)NSArray * titleArray;

@property(nonatomic,assign) id<OrderBottomViewDelegate> delegate;

@property(nonatomic,strong)UIView * backgroundView;
//更新的按钮的颜色,传按钮的tag值
-(void)resetBtnStatus:(NSInteger )btnTag;
-(void)BtnONClick:(UIButton *)btn;
@end
