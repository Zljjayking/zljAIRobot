//
//  DatePickerTwoView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmDateTwoBlock)(NSString *choseDate,NSString *restDate);
typedef void(^CannelDateTwoBlock)();
@interface DatePickerTwoView : UIView
@property (nonatomic,strong) UIDatePicker *datePickerView;

@property (nonatomic,copy) ConfirmDateTwoBlock confirmBlock;

@property (nonatomic,copy) CannelDateTwoBlock cannelBlock;

- (DatePickerTwoView *)initWithCustomeHeight:(CGFloat)height;
@end
