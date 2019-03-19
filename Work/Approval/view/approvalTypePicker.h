//
//  approvalTypePicker.h
//  Financeteam
//
//  Created by Zccf on 2017/5/16.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ConfirmApprovalTypeBlock)(NSString *chooseOneState);
typedef void(^CanncelApprovalTypeBlock)();
@interface approvalTypePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView * siftingOnePicker;

@property(nonatomic,strong)NSArray * siftingOneArr;

@property(nonatomic,strong)NSString * siftingOneName;

@property (nonatomic,copy) ConfirmApprovalTypeBlock confirmOneBlock;

@property (nonatomic,copy) CanncelApprovalTypeBlock cannelOneBlock;

-(approvalTypePicker *)initWithCustomeHeight:(CGFloat)height titleArray:(NSArray *)titleArray;

@end
