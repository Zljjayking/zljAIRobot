//
//  DatePickerOneView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmDateOneBlock)(NSString *choseDate,NSString *restDate);
typedef void(^CannelDateOneBlock)();
@interface DatePickerOneView : UIView
@property (nonatomic,strong) UIDatePicker *datePickerView;

@property (nonatomic,copy) ConfirmDateOneBlock confirmBlock;

@property (nonatomic,copy) CannelDateOneBlock cannelBlock;

- (DatePickerOneView *)initWithCustomeHeight:(CGFloat)height;
@end
