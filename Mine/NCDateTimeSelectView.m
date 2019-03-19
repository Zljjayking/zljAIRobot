//
//  NCDateTimeSelectView.m
//  iMoccaLite
//
//  Created by 菜酱 on 15/12/23.
//  Copyright © 2015年 菜酱. All rights reserved.
//

#import "NCDateTimeSelectView.h"

#define yearPicker 0
#define monthPicker 1
#define dayPicker 2
#define hourPicker 0
#define minutePicker 1
#define width self.frame.size.width
#define height self.frame.size.height
#define defSCALE_VIEW (self.width / 375)
#define defCOLOR_TEXT [UIColor colorWithRed:.4f green:.4f blue:.4f alpha:1]
#define defCOLOR_SHADOW [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:.8f]
#define defCOLOR_BUTTON [UIColor colorWithRed:.2f green:.6f blue:1.0f alpha:1]

@implementation NCDateTimeSelectView

- (void)clickCommit {
    [self setDict];
    // NSLog(@"提交日期 %@", _dictDate);
    [_delegateGetDate getNSDate:_dictDate];
}

- (void)clickCancel {
    [_delegateGetDate cancelNSDate];
}

#pragma mark 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case hourPicker:
//            [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
//                              Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
//            [_pickerView reloadComponent:dayPicker];
//            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
            break;
        case minutePicker:
//            [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
//                              Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
//            [_pickerView reloadComponent:dayPicker];
//            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
            break;
//        case dayPicker:
//            break;
//        case hourPicker:
//            break;
//        case minutePicker:
//            break;
        default:
            break;
    }
}

# pragma mark 设置返回字典
- (void)setDict {
//    NSInteger year = [_pickerView selectedRowInComponent:yearPicker] + 1900;
//    NSInteger month = [_pickerView selectedRowInComponent:monthPicker] + 1;
//    NSInteger day = [_pickerView selectedRowInComponent:dayPicker] + 1;
    NSInteger hour = [_pickerView selectedRowInComponent:hourPicker];
    NSInteger minute = [_pickerView selectedRowInComponent:minutePicker];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", year] forKey:@"year"];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", month] forKey:@"month"];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", day] forKey:@"day"];
    [_dictDate setObject:[NSString stringWithFormat:@"%ld", hour] forKey:@"hour"];
    [_dictDate setObject:[NSString stringWithFormat:@"%ld", minute] forKey:@"minute"];
//    NSString * strDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
    NSString * strTime = [NSString stringWithFormat:@"%02ld:%02ld:00", hour, minute];
//    [_dictDate setObject:strDate forKey:@"date"];
    [_dictDate setObject:strTime forKey:@"time"];
}
//- (void)setDict {
//    NSInteger year = [_pickerView selectedRowInComponent:yearPicker] + 1900;
//    NSInteger month = [_pickerView selectedRowInComponent:monthPicker] + 1;
//    NSInteger day = [_pickerView selectedRowInComponent:dayPicker] + 1;
//    NSInteger hour = [_pickerView selectedRowInComponent:hourPicker];
//    NSInteger minute = [_pickerView selectedRowInComponent:minutePicker];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", year] forKey:@"year"];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", month] forKey:@"month"];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", day] forKey:@"day"];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", hour] forKey:@"hour"];
//    [_dictDate setObject:[NSString stringWithFormat:@"%ld", minute] forKey:@"minute"];
//    NSString * strDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
//    NSString * strTime = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld", year, month, day, hour, minute];
//    [_dictDate setObject:strDate forKey:@"date"];
//    [_dictDate setObject:strTime forKey:@"time"];
//}
#pragma mark 返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case hourPicker:
            return [_arrayHour objectAtIndex:row];
        case minutePicker:
            return [_arrayMinute objectAtIndex:row];
//        case dayPicker:
//            return [_arrayDay objectAtIndex:row];
//        case hourPicker:
//            return [_arrayHour objectAtIndex:row];
//        case minutePicker:
//            return [_arrayMinute objectAtIndex:row];
        default:
            return @"-";
    }
}

#pragma mark 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case hourPicker:
            return self.width / 3;
        case minutePicker:
            return self.width / 3;
//        case dayPicker:
//            return self.width / 6;
//        case hourPicker:
//            return self.width / 6;
//        case minutePicker:
//            return self.width / 6;
        default:
            return 0;
    }
}

#pragma mark 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

#pragma mark 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case hourPicker:
            return [_arrayHour count];
        case minutePicker:
            return [_arrayMinute count];
//        case dayPicker:
//            return [_arrayDay count];
//        case hourPicker:
//            return [_arrayHour count];
//        case minutePicker:
//            return [_arrayMinute count];
        default:
            return 1;
    }
}

#pragma mark 每行字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * labRow = nil;
    labRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    labRow.textAlignment = NSTextAlignmentCenter;
    labRow.font = [UIFont systemFontOfSize:16];
    labRow.textColor = defCOLOR_TEXT;
    labRow.backgroundColor = [UIColor clearColor];
    labRow.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return labRow;
}

#pragma mark - 生成数组数据
- (void)getYearArray {
    [_arrayDay removeAllObjects];
    for (NSInteger i = 1900; i < 2200; i ++) {
        [_arrayYear addObject:[NSString stringWithFormat:@"%ld 年", i]];
    }
}

- (void)getMonthArray {
    [_arrayMonth removeAllObjects];
    for (NSInteger i = 1; i < 13; i ++) {
        [_arrayMonth addObject:[NSString stringWithFormat:@"%ld 月", i]];
    }
}

- (void)getDayArrayAtYear:(NSInteger)year Month:(NSInteger)month {
    // 准备所选月份
    NSString * strYearMonth = [NSString stringWithFormat:@"%ld-%ld-1", year, month];
    NSDateFormatter * dmYearMonth = [[NSDateFormatter alloc] init];
    [dmYearMonth setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateYearMonth = [dmYearMonth dateFromString:strYearMonth];
    // 获得当月日期
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:dateYearMonth];
    // 写入日期数组
    [_arrayDay removeAllObjects];
    for (NSInteger i = 1; i < days.length + 1; i ++) {
        [_arrayDay addObject:[NSString stringWithFormat:@"%ld 日", i]];
    }
}

- (void)getHourArray {
    [_arrayHour removeAllObjects];
    for (NSInteger i = 0; i < 24; i ++) {
        [_arrayHour addObject:[NSString stringWithFormat:@"%ld 时", i]];
    }
}

- (void)getMinuteArray {
    [_arrayMinute removeAllObjects];
    for (NSInteger i = 0; i < 60; i ++) {
        [_arrayMinute addObject:[NSString stringWithFormat:@"%ld 分", i]];
    }
}

#pragma mark - 初始化数据
- (void)initData {
    // 默认时间 1990-06-15-12-30
    _arrayYear = [[NSMutableArray alloc] init];
    _arrayMonth = [[NSMutableArray alloc] init];
    _arrayDay = [[NSMutableArray alloc] init];
    _arrayHour = [[NSMutableArray alloc] init];
    _arrayMinute = [[NSMutableArray alloc] init];
    [self getYearArray];
    [self getMonthArray];
    [self getDayArrayAtYear:1990 Month:6];
    [self getHourArray];
    [self getMinuteArray];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 初始化数据
        _dictDate = [[NSMutableDictionary alloc] init];
        [self initData];
        // 提交按钮
        _btnConfirm = [[UIButton alloc] init];
        _btnConfirm.frame = CGRectMake(width - 90 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
        [_btnConfirm setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnConfirm.layer setCornerRadius:2];
        [_btnConfirm addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnConfirm];
        // 取消按钮
        _btnCancel = [[UIButton alloc] init];
        _btnCancel.frame = CGRectMake(10 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
        [_btnCancel setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_btnCancel.layer setCornerRadius:2];
        [_btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCancel];
        // 提示文字
        CGFloat cancelRight = (_btnCancel.frame.origin.x + _btnCancel.width);
        _labTips = [[UILabel alloc] init];
        _labTips.frame = CGRectMake(cancelRight + 5 * defSCALE_VIEW, _btnCancel.frame.origin.y, _btnConfirm.frame.origin.x - cancelRight - 10 * defSCALE_VIEW, _btnCancel.height);
        _labTips.textColor = defCOLOR_TEXT;
        _labTips.font = [UIFont systemFontOfSize:15];
        _labTips.textAlignment = NSTextAlignmentCenter;
        _labTips.text = @"请选择时间";
        [self addSubview:_labTips];
        // 选择器
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(10 * defSCALE_VIEW, _btnConfirm.frame.origin.y + _btnConfirm.height + 8 * defSCALE_VIEW, self.width - 20 * defSCALE_VIEW, self.height - 50 * defSCALE_VIEW);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.layer.borderWidth = 0.5f;
        _pickerView.layer.borderColor = [defCOLOR_SHADOW CGColor];
        [self addSubview:_pickerView];
        // 默认时间 1990-06-15-12-30
//        [_pickerView selectRow:90 inComponent:yearPicker animated:NO];
//        [_pickerView selectRow:5 inComponent:monthPicker animated:NO];
//        [_pickerView selectRow:14 inComponent:dayPicker animated:NO];
        [_pickerView selectRow:0 inComponent:hourPicker animated:NO];
        [_pickerView selectRow:0 inComponent:minutePicker animated:NO];
    }
    return self;
}

@end
