//
//  OngoingView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)();
typedef void(^SendBlock)();

@interface OngoingView : UIView

@property(nonatomic,strong)UITextView * textView;

-(void)OngoingViewWithClickBlock:(ClickBlock)clickBlock andSendBlock:(SendBlock)sendBlock;

@end
