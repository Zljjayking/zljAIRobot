//
//  siftingOnePickerView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmTwoBlock)(NSString *chooseOneState);
typedef void(^CanncelTwoBlock)();
@interface siftingTwoPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView * siftingTwoPicker;

@property(nonatomic,strong)NSArray * siftingTwoArr;

@property(nonatomic,strong)NSString * siftingTwoName;

@property (nonatomic,copy) ConfirmTwoBlock confirmTwoBlock;

@property (nonatomic,copy) CanncelTwoBlock cannelTwoBlock;

-(siftingTwoPickerView *)initWithCustomeHeight:(CGFloat)height;

@end
