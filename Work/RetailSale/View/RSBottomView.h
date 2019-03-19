//
//  RSBottomView.h
//  Financeteam
//
//  Created by 张正飞 on 16/8/16.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSBottomViewDelegate <NSObject>

-(void)clickButton:(NSInteger)page;

@end

@interface RSBottomView : UIView

@property(nonatomic,strong)NSArray * titleArray;

@property(nonatomic,assign) id<RSBottomViewDelegate> delegate;

@end
