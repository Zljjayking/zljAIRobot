//
//  hourPickerView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/22.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmHourBlock)(NSString *chooseOneState);
typedef void(^CanncelHourBlock)();
@interface hourPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView * siftingOnePicker;

@property(nonatomic,strong)NSArray * siftingOneArr;

@property(nonatomic,strong)NSString * siftingOneName;

@property (nonatomic,copy) ConfirmHourBlock confirmOneBlock;

@property (nonatomic,copy) CanncelHourBlock cannelOneBlock;

-(hourPickerView *)initWithCustomeHeight:(CGFloat)height;

@end
