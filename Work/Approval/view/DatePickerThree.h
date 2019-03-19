//
//  DatePickerThree.h
//  Financeteam
//
//  Created by Zccf on 2017/5/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmDateThreeBlock)(NSString *choseDate,NSString *restDate);
typedef void(^CannelDateThreeBlock)();
@interface DatePickerThree : UIView
@property (nonatomic,strong) UIDatePicker *datePickerView;

@property (nonatomic,copy) ConfirmDateThreeBlock confirmBlock;

@property (nonatomic,copy) CannelDateThreeBlock cannelBlock;

- (DatePickerThree *)initWithCustomeHeight:(CGFloat)height;
@end
