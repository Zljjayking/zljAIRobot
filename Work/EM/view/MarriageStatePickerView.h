//
//  MarriageStatePickerView.h
//  365ChengRongWang
//
//  Created by Zccf on 17/1/6.
//  Copyright © 2017年 Zccf. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
typedef void(^ConfirmMBlock)(NSString *chooseMarriageState);
typedef void(^CanncelMBlock)();
@interface MarriageStatePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView * MarriageStatePicker;

@property(nonatomic,strong)NSArray * MarriageStateArr;

@property(nonatomic,strong)NSString * MarriageStateName;

@property (nonatomic,copy) ConfirmMBlock confirmBlock;

@property (nonatomic,copy) CanncelMBlock cannelBlock;

-(MarriageStatePickerView *)initWithCustomeHeight:(CGFloat)height;

@end
