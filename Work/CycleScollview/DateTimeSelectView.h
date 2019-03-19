//
//  NCDateTimeSelectView.h
//  iMoccaLite
//
//  Created by 菜酱 on 15/12/23.
//  Copyright © 2015年 菜酱. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectDateTimeDelegate <NSObject>

- (void)getDate:(NSMutableDictionary *)dictDate;
- (void)cancelDate;

@end

@interface DateTimeSelectView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

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
- (id)initWithFrame:(CGRect)frame formatter:(NSString *)formatter;
- (id)initWithFrame:(CGRect)frame formatter:(NSString *)formatter year:(NSString *)year;

@property (nonatomic, assign) NSInteger rowCount;

@property (nonatomic, assign) id <SelectDateTimeDelegate> delegateGetDate;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger style;//从自定义进来 formatter 为 yyyyMMddHHmm
@end
