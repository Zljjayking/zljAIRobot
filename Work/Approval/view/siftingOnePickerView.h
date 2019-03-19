//
//  siftingOnePickerView.h
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmOneBlock)(NSString *chooseOneState);
typedef void(^CanncelOneBlock)();

@interface siftingOnePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView * siftingOnePicker;

@property(nonatomic,strong)NSArray * siftingOneArr;

@property(nonatomic,strong)NSString * siftingOneName;

@property (nonatomic,copy) ConfirmOneBlock confirmOneBlock;

@property (nonatomic,copy) CanncelOneBlock cannelOneBlock;

-(siftingOnePickerView *)initWithCustomeHeight:(CGFloat)height;
@end
