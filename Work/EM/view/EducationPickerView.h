//
//  WorkMoneyPickerView.h
//  365ChengRongWang
//
//  Created by 张正飞 on 16/12/19.
//  Copyright © 2016年 Zccf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


typedef void(^ConfirmzBlock)(NSString *chooseWorkType);
typedef void(^CannelzBlock)();

@interface EducationPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView * educationPicker;

@property(nonatomic,strong)NSArray * educationArray;

@property(nonatomic,strong)NSString * educationName;

@property (nonatomic,copy) ConfirmzBlock confirmBlock;

@property (nonatomic,copy) CannelzBlock cannelBlock;

-(EducationPickerView *)initWithCustomeHeight:(CGFloat)height;

@end
