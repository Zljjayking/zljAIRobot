//
//  ChooseResultView.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/24.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OngoingBlock)();
typedef void (^SuccessBlock)();
typedef void (^FailureBlock)();

typedef void (^SendBlock)();

@interface ChooseResultView : UIView

-(void)ChooseResultViewWithOngoingBlock:(OngoingBlock)ongoingBlock SuccessBlock:(SuccessBlock)successBlock FailureBlock:(FailureBlock)failureBlock andSendBlock:(SendBlock)sendBlock;

@end
