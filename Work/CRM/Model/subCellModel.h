//
//  subCellModel.h
//  Financeteam
//
//  Created by Zccf on 16/6/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface subCellModel : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *BtnArr;//按钮的个数和数据
@property (nonatomic) NSInteger type;//类型为1时 显示button 为2时 显示textfield 3：显示textfield加单位 4:显示按钮点击进入下一页  5:显示范围
@property (nonatomic) NSInteger index;//点击的按钮
@property (nonatomic) NSString *UnitType;
@property (nonatomic) NSString *TFText;//textfield中的数据
@property (nonatomic) NSString *identification;
@property (nonatomic, assign) CGFloat rowHeight;//行高
@property (nonatomic) NSInteger KeyType;//弹出键盘类型1.数字加英文2.纯数字3.中文4.
//1.UIKeyboardTypeNumbersAndPunctuation
//2.UIKeyboardTypeNumberPad
//3.UIKeyboardTypeDefault
@end
