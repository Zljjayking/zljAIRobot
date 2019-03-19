//
//  signTimePickerView.h
//  Financeteam
//
//  Created by Zccf on 2017/6/8.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmSignTimeBlock)(NSString *choseDate,NSString *restDate);
typedef void(^CannelSignTimeBlock)();
@interface signTimePickerView : UIView

@property (nonatomic,strong) UIDatePicker *datePickerView;

@property (nonatomic,copy) ConfirmSignTimeBlock confirmBlock;

@property (nonatomic,copy) CannelSignTimeBlock cannelBlock;

- (signTimePickerView *)initWithCustomeHeight:(CGFloat)height;
@end
