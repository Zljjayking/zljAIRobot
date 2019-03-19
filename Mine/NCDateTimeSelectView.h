//
//  NCDateTimeSelectView.h
//  iMoccaLite
//
//  Created by 菜酱 on 15/12/23.
//  Copyright © 2015年 菜酱. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSSelectDateTimeDelegate <NSObject>

- (void)getNSDate:(NSMutableDictionary *)dictDate;
- (void)cancelNSDate;

@end

@interface NCDateTimeSelectView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) NSMutableArray * arrayYear;
@property (nonatomic, strong) NSMutableArray * arrayMonth;
@property (nonatomic, strong) NSMutableArray * arrayDay;
@property (nonatomic, strong) NSMutableArray * arrayHour;
@property (nonatomic, strong) NSMutableArray * arrayMinute;

@property (nonatomic, strong) NSMutableDictionary * dictDate;

@property (nonatomic, strong) UIButton * btnConfirm;
@property (nonatomic, strong) UIButton * btnCancel;

@property (nonatomic, strong) UILabel * labTips;

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) id <NSSelectDateTimeDelegate> delegateGetDate;

@end
