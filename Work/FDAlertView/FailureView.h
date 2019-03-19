//
//  FailureView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickBlock)();
typedef void(^SendBlock)();

@interface FailureView : UIView

@property(nonatomic,strong)UITextView * textView;

-(void)FailureViewWithClickBlock:(ClickBlock)clickBlock andSendBlock:(SendBlock)sendBlock;

@end
