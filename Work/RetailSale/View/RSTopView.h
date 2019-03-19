//
//  RSTopView.h
//  Financeteam
//
//  Created by 张正飞 on 16/8/22.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSTopViewDelegate <NSObject>

-(void)clickButton:(NSInteger)page;

@end

@interface RSTopView : UIView

@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,strong)UIView * lineView;

@property(nonatomic,assign) id<RSTopViewDelegate> delegate;

//更新的按钮的颜色,传按钮的tag值
-(void)resetBtnStatus:(NSInteger )btnTag;
@end
