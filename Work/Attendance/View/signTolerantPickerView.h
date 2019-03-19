//
//  signTolerantPickerView.h
//  Financeteam
//
//  Created by Zccf on 2017/6/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmSignTolerantBlock)(NSString *choseDate,NSString *restDate);
typedef void(^CannelSignTolerantBlock)();
@interface signTolerantPickerView : UIView
@property (nonatomic,copy) ConfirmSignTolerantBlock confirmBlock;

@property (nonatomic,copy) CannelSignTolerantBlock cannelBlock;

- (signTolerantPickerView *)initWithCustomeHeight:(CGFloat)height;
@end
