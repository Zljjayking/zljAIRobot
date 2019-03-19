//
//  SuccessView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)();
typedef void(^SendBlock)();

@interface SuccessView : UIView

@property (nonatomic,strong)UITextField * quotaTextField;

-(void)SuccessViewWithClickBlock:(ClickBlock)clickBlock andSendBlock:(SendBlock)sendBlock;

@end
