//
//  NCDateTimeSelectView.m
//  iMoccaLite
//
//  Created by 菜酱 on 15/12/23.
//  Copyright © 2015年 菜酱. All rights reserved.
//

#import "DateTimeSelectView.h"

#define yearPicker 0
#define monthPicker 1
#define dayPicker 2
#define hourPicker 3
#define minutePicker 4
#define width self.frame.size.width
#define height self.frame.size.height
#define defSCALE_VIEW 1
#define defCOLOR_TEXT [UIColor colorWithRed:.4f green:.4f blue:.4f alpha:1]
#define defCOLOR_SHADOW [UIColor colorWithRed:.8f green:.8f blue:.8f alpha:.8f]
#define defCOLOR_BUTTON [UIColor colorWithRed:.2f green:.6f blue:1.0f alpha:1]

@implementation DateTimeSelectView

- (void)clickCommit {
    [self setDict];
    // NSLog(@"提交日期 %@", _dictDate);
    [_delegateGetDate getDate:_dictDate];
}

- (void)clickCancel {
    [_delegateGetDate cancelDate];
}

#pragma mark 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.type == 1) {
        switch (component) {
            case yearPicker:
                [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
                                  Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
                [_pickerView reloadComponent:yearPicker];
                //            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
                break;
            case monthPicker:
                [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
                                  Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
                [_pickerView reloadComponent:monthPicker];
                //            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
                break;
            default:
                break;
        }
    } else if (self.type == 0)  {
        if (self.rowCount == 2) {
            switch (component) {
                case 0:
                    break;
                case 1:
                    break;
                default:
                    break;
            }
        }else {
            switch (component) {
                case yearPicker:
                    [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
                                      Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
                    [_pickerView reloadComponent:dayPicker];
                    //            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
                    break;
                case monthPicker:
                    [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
                                      Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
                    [_pickerView reloadComponent:dayPicker];
                    //            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
                    break;
                case dayPicker:
                    break;
                case hourPicker:
                    break;
                case minutePicker:
                    break;
                default:
                    break;
            }
        }
        
    } else {
        switch (component) {
//            case yearPicker:
//                [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
//                                  Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
//                [_pickerView reloadComponent:yearPicker];
//                //            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
//                break;
            case monthPicker:
                [self getDayArrayAtYear:[_pickerView selectedRowInComponent:yearPicker] + 1900
                                  Month:[_pickerView selectedRowInComponent:monthPicker] + 1];
                [_pickerView reloadComponent:monthPicker];
                //            [_pickerView selectRow:14 inComponent:dayPicker animated:YES];
                break;
            default:
                break;
        }
    }
    
}

# pragma mark 设置返回字典
- (void)setDict {
    
    if (self.rowCount == 3) {
        NSInteger year = [_pickerView selectedRowInComponent:yearPicker] + 1900;
        NSInteger month = [_pickerView selectedRowInComponent:monthPicker] + 1;
        NSInteger day = [_pickerView selectedRowInComponent:dayPicker] + 1;
        
        [_dictDate setObject:[NSString stringWithFormat:@"%ld", year] forKey:@"year"];
        [_dictDate setObject:[NSString stringWithFormat:@"%02ld", month] forKey:@"month"];
        [_dictDate setObject:[NSString stringWithFormat:@"%02ld", day] forKey:@"day"];
        NSString * strDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
        [_dictDate setObject:strDate forKey:@"date"];
    }
    
    if (self.rowCount == 5) {
        NSInteger year = [_pickerView selectedRowInComponent:yearPicker] + 1900;
        NSInteger month = [_pickerView selectedRowInComponent:monthPicker] + 1;
        NSInteger day = [_pickerView selectedRowInComponent:dayPicker] + 1;
        
        [_dictDate setObject:[NSString stringWithFormat:@"%ld", year] forKey:@"year"];
        [_dictDate setObject:[NSString stringWithFormat:@"%02ld", month] forKey:@"month"];
        [_dictDate setObject:[NSString stringWithFormat:@"%02ld", day] forKey:@"day"];
        NSString * strDate = [NSString stringWithFormat:@"%ld-%02ld-%02ld", year, month, day];
        [_dictDate setObject:strDate forKey:@"date"];
        
        NSInteger hour = [_pickerView selectedRowInComponent:hourPicker];
        NSInteger minute = [_pickerView selectedRowInComponent:minutePicker];
        [_dictDate setObject:[NSString stringWithFormat:@"%ld", hour] forKey:@"hour"];
        [_dictDate setObject:[NSString stringWithFormat:@"%ld", minute] forKey:@"minute"];
#pragma mark == 从自定义进来 formatter 为 yyyyMMddHHmm
        if (self.style == 1) {
            if (minute == 1) {
                minute = 30;
            }
        } else {
            switch (minute) {
                case 1:
                    minute = 10;
                    break;
                case 2:
                    minute = 20;
                    break;
                case 3:
                    minute = 30;
                    break;
                case 4:
                    minute = 40;
                    break;
                case 5:
                    minute = 50;
                    break;
                default:
                    break;
            }
        }
        
        NSString * strTime = [NSString stringWithFormat:@" %02ld:%02ld", hour, minute];
        [_dictDate setObject:strTime forKey:@"time"];
    }
    if (self.type == 0) {
        if (self.rowCount == 2) {
            NSInteger hour = [_pickerView selectedRowInComponent:0];
            NSInteger minute = [_pickerView selectedRowInComponent:1];
            [_dictDate setObject:[NSString stringWithFormat:@"%ld", hour] forKey:@"hour"];
            [_dictDate setObject:[NSString stringWithFormat:@"%ld", minute] forKey:@"minute"];
            NSString * strTime = [NSString stringWithFormat:@" %02ld:%02ld", hour, minute];
            [_dictDate setObject:strTime forKey:@"time"];
        }
        
    } else if (self.type == 1) {
        
        NSInteger year = [_pickerView selectedRowInComponent:yearPicker] + 1900;
        NSInteger month = [_pickerView selectedRowInComponent:monthPicker] + 1;
        
        [_dictDate setObject:[NSString stringWithFormat:@"%ld", year] forKey:@"year"];
        [_dictDate setObject:[NSString stringWithFormat:@"%02ld", month] forKey:@"month"];
        NSString * strDate = [NSString stringWithFormat:@"%ld-%02ld", year, month];
        [_dictDate setObject:strDate forKey:@"date"];
    } else {
        NSInteger month = [_pickerView selectedRowInComponent:monthPicker] + 1;
        [_dictDate setObject:[NSString stringWithFormat:@"%02ld", month] forKey:@"month"];
        NSString * strDate = [NSString stringWithFormat:@"%@-%02ld", [Utils dateToString:[NSDate date] withDateFormat:@"YYYY"], month];
        [_dictDate setObject:strDate forKey:@"date"];
    }
    
    
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
    if (self.type == 1) {
        switch (component) {
            case yearPicker:
                return [_arrayYear objectAtIndex:row];
            case monthPicker:
                return [_arrayMonth objectAtIndex:row];
            default:
                return @"-";
        }
    } else {
        if (self.rowCount == 2) {
            switch (component) {
                case 0:
                    return [_arrayHour objectAtIndex:row];
                case 1:
                    return [_arrayMinute objectAtIndex:row];
                default:
                    return @"-";
            }
        }else {
            switch (component) {
                case yearPicker:
                    return [_arrayYear objectAtIndex:row];
                case monthPicker:
                    return [_arrayMonth objectAtIndex:row];
                case dayPicker:
                    return [_arrayDay objectAtIndex:row];
                case hourPicker:
                    return [_arrayHour objectAtIndex:row];
                case minutePicker:
                    return [_arrayMinute objectAtIndex:row];
                default:
                    return @"-";
            }
        }
        
    }
}

#pragma mark 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case yearPicker:
            return self.width / (self.rowCount+1);
        case monthPicker:
            return self.width / (self.rowCount+1);
        case dayPicker:
            return self.width / (self.rowCount+1);
        case hourPicker:
            return self.width / (self.rowCount+1);
        case minutePicker:
            return self.width / (self.rowCount+1);
        default:
            return 0;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}
#pragma mark 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.rowCount;
}

#pragma mark 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.type == 1 || self.type == 2) {
        switch (component) {
            case yearPicker:
                return [_arrayYear count];
            case monthPicker:
                return [_arrayMonth count];
            default:
                return 1;
        }
    } else {
        if (self.rowCount == 2 ) {
            switch (component) {
                case 0:
                    return [_arrayHour count];
                case 1:
                    return [_arrayMinute count];
                default:
                    return 1;
            }
        } else {
            switch (component) {
                case yearPicker:
                    return [_arrayYear count];
                case monthPicker:
                    return [_arrayMonth count];
                case dayPicker:
                    return [_arrayDay count];
                case hourPicker:
                    return [_arrayHour count];
                case minutePicker:
                    return [_arrayMinute count];
                default:
                    return 1;
            }
        }
  }
    
}

#pragma mark 每行字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * labRow = nil;
    labRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 22)];
    labRow.textAlignment = NSTextAlignmentCenter;
    labRow.font = [UIFont systemFontOfSize:21];
//    labRow.textColor = defCOLOR_TEXT;
    labRow.backgroundColor = [UIColor clearColor];
    labRow.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return labRow;
}

#pragma mark - 生成数组数据
- (void)getYearArray {
    [_arrayDay removeAllObjects];
    for (NSInteger i = 1900; i < 2200; i ++) {
        [_arrayYear addObject:[NSString stringWithFormat:@"%ld年", i]];
    }
}

- (void)getMonthArray {
    [_arrayMonth removeAllObjects];
    for (NSInteger i = 1; i < 13; i ++) {
        [_arrayMonth addObject:[NSString stringWithFormat:@"%ld月", i]];
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
        [_arrayDay addObject:[NSString stringWithFormat:@"%ld日", i]];
    }
}

- (void)getHourArray {
    [_arrayHour removeAllObjects];
    for (NSInteger i = 0; i < 24; i ++) {
        [_arrayHour addObject:[NSString stringWithFormat:@"%ld时", i]];
    }
}

- (void)getMinuteArray {
    [_arrayMinute removeAllObjects];
    for (NSInteger i = 0; i < 60; i ++) {
        [_arrayMinute addObject:[NSString stringWithFormat:@"%ld分", i]];
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
        self.type = 0;
        [self initData];
        // 提交按钮
        _btnConfirm = [[UIButton alloc] init];
        _btnConfirm.frame = CGRectMake(width - 90 , 7 , 80 , 30 );
//        [_btnConfirm setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_btnConfirm setTitleColor:MYORANGE forState:UIControlStateNormal];
        [_btnConfirm.layer setCornerRadius:2];
        [_btnConfirm addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnConfirm];
        // 取消按钮
        _btnCancel = [[UIButton alloc] init];
        _btnCancel.frame = CGRectMake(10 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
//        [_btnCancel setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_btnCancel setTitleColor:MYORANGE forState:UIControlStateNormal];
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
//        _labTips.text = @"请选择日期";
        [self addSubview:_labTips];
        self.rowCount = 5;
        // 选择器
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0 * defSCALE_VIEW, _btnConfirm.frame.origin.y + _btnConfirm.height + 3 * defSCALE_VIEW, self.width - 0 * defSCALE_VIEW, self.height - 40*defSCALE_VIEW);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
//        _pickerView.layer.borderWidth = 0.5f;
//        _pickerView.layer.borderColor = [defCOLOR_SHADOW CGColor];
        _pickerView.backgroundColor = kMyColor(239, 239, 244);
        [self addSubview:_pickerView];
        // 默认时间 2016-08-15-12-30
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:now];
        
        NSRange YearRange = NSMakeRange(0, 4);
        NSInteger year = [[dateString substringWithRange:YearRange] integerValue];
        
        NSRange MonthRange = NSMakeRange(4, 2);
        NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
        [self getDayArrayAtYear:year Month:month];
        NSRange DayRange = NSMakeRange(6, 2);
        NSInteger day = [[dateString substringWithRange:DayRange] integerValue];
        
        NSRange HourRange = NSMakeRange(8, 2);
        NSInteger hour = [[dateString substringWithRange:HourRange] integerValue];
        
        NSRange MinuteRange = NSMakeRange(10, 2);
        NSInteger minute = [[dateString substringWithRange:MinuteRange] integerValue];
        
        [_pickerView selectRow:year - 1900 inComponent:yearPicker animated:NO];
        [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
        [_pickerView selectRow:day-1 inComponent:dayPicker animated:NO];
        [_pickerView selectRow:hour inComponent:hourPicker animated:NO];
        [_pickerView selectRow:minute inComponent:minutePicker animated:NO];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame formatter:(NSString *)formatter {
    
    //[Utils dateToString:[NSDate date] withDateFormat:@"YYYY-MM"]
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 初始化数据
        _dictDate = [[NSMutableDictionary alloc] init];
        [self initData];
        // 提交按钮
        _btnConfirm = [[UIButton alloc] init];
        _btnConfirm.frame = CGRectMake(width - 90 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
//        [_btnConfirm setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_btnConfirm setTitleColor:MYORANGE forState:UIControlStateNormal];
        [_btnConfirm.layer setCornerRadius:2];
        [_btnConfirm addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnConfirm];
        // 取消按钮
        _btnCancel = [[UIButton alloc] init];
        _btnCancel.frame = CGRectMake(10 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
//        [_btnCancel setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_btnCancel setTitleColor:MYORANGE forState:UIControlStateNormal];
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
//        _labTips.text = @"请选择日期";
        [self addSubview:_labTips];
        self.rowCount = 3;
        self.type = 0;
        if ([formatter isEqualToString:@"yyyyMMdd"]) {
            self.rowCount = 3;
        }
        if ([formatter isEqualToString:@"HH:mm"]) {
            self.rowCount = 2;
        }
        
        if ([formatter isEqualToString:@"yyyyMM"]) {
            self.type = 1;
            self.rowCount = 2;
        }
        if ([formatter isEqualToString:@"yyyyMMddHHmm"]) {
            _arrayMinute = [NSMutableArray arrayWithObjects:@"00分",@"30分", nil];
            self.rowCount = 5;
            self.style = 1;
        }
        if ([formatter isEqualToString:@"yyyyMMddHHmmss"]) {
            _arrayMinute = [NSMutableArray arrayWithObjects:@"00分",@"10分",@"20分",@"30分",@"40分",@"50分", nil];
            self.rowCount = 5;
            self.style = 2;
        }
        // 选择器
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0 * defSCALE_VIEW, _btnConfirm.frame.origin.y + _btnConfirm.height + 5 * defSCALE_VIEW, self.width - 0 * defSCALE_VIEW, self.height - 42 * defSCALE_VIEW);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
//        _pickerView.layer.borderWidth = 0.5f;
//        _pickerView.layer.borderColor = [defCOLOR_SHADOW CGColor];
        _pickerView.backgroundColor = kMyColor(239, 239, 244);
        [self addSubview:_pickerView];
        // 默认时间 2016-08-15-12-30
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:now];
        
        if (self.type == 0) {
            if (self.rowCount == 3) {
                NSRange YearRange = NSMakeRange(0, 4);
                NSInteger year = [[dateString substringWithRange:YearRange] integerValue];
                
                NSRange MonthRange = NSMakeRange(4, 2);
                NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
                
                NSRange DayRange = NSMakeRange(6, 2);
                NSInteger day = [[dateString substringWithRange:DayRange] integerValue];
                [self getDayArrayAtYear:year Month:month];
                [_pickerView selectRow:year - 1900 inComponent:yearPicker animated:NO];
                [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
                [_pickerView selectRow:day-1 inComponent:dayPicker animated:NO];
            } else if (self.rowCount == 2) {
                NSRange HourRange = NSMakeRange(8, 2);
                NSInteger hour = [[dateString substringWithRange:HourRange] integerValue];
                
                NSRange MinuteRange = NSMakeRange(10, 2);
                NSInteger minute = [[dateString substringWithRange:MinuteRange] integerValue];
                
                [_pickerView selectRow:hour inComponent:0 animated:NO];
                [_pickerView selectRow:minute inComponent:1 animated:NO];
                
            } else if (self.rowCount == 5) {
                
                NSRange YearRange = NSMakeRange(0, 4);
                NSInteger year = [[dateString substringWithRange:YearRange] integerValue];
                
                NSRange MonthRange = NSMakeRange(4, 2);
                NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
                
                NSRange DayRange = NSMakeRange(6, 2);
                NSInteger day = [[dateString substringWithRange:DayRange] integerValue];
                [self getDayArrayAtYear:year Month:month];
                [_pickerView selectRow:year - 1900 inComponent:yearPicker animated:NO];
                [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
                [_pickerView selectRow:day-1 inComponent:dayPicker animated:NO];
                
                NSRange HourRange = NSMakeRange(8, 2);
                NSInteger hour = [[dateString substringWithRange:HourRange] integerValue];
                
//                NSRange MinuteRange = NSMakeRange(10, 2);
//                NSInteger minute = [[dateString substringWithRange:MinuteRange] integerValue];
                
                [_pickerView selectRow:hour inComponent:3 animated:NO];
                [_pickerView selectRow:0 inComponent:4 animated:NO];
            }

        } else {
            NSRange YearRange = NSMakeRange(0, 4);
            NSInteger year = [[dateString substringWithRange:YearRange] integerValue];
            
            NSRange MonthRange = NSMakeRange(4, 2);
            NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
            
            [_pickerView selectRow:year - 1900 inComponent:yearPicker animated:NO];
            [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
        }
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame formatter:(NSString *)formatter year:(NSString *)year{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 初始化数据
        _dictDate = [[NSMutableDictionary alloc] init];
        [self initData];
        // 提交按钮
        _btnConfirm = [[UIButton alloc] init];
        _btnConfirm.frame = CGRectMake(width - 90 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
        //        [_btnConfirm setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnConfirm setTitle:@"确定" forState:UIControlStateNormal];
        [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_btnConfirm setTitleColor:MYORANGE forState:UIControlStateNormal];
        [_btnConfirm.layer setCornerRadius:2];
        [_btnConfirm addTarget:self action:@selector(clickCommit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnConfirm];
        // 取消按钮
        _btnCancel = [[UIButton alloc] init];
        _btnCancel.frame = CGRectMake(10 * defSCALE_VIEW, 7 * defSCALE_VIEW, 80 * defSCALE_VIEW, 30 * defSCALE_VIEW);
        //        [_btnCancel setBackgroundColor:TABBAR_BASE_COLOR];
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_btnCancel setTitleColor:MYORANGE forState:UIControlStateNormal];
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
        //        _labTips.text = @"请选择日期";
        [self addSubview:_labTips];
        self.rowCount = 3;
        self.type = 0;
        if ([formatter isEqualToString:@"yyyyMMdd"]) {
            self.rowCount = 3;
        }
        if ([formatter isEqualToString:@"HH:mm"]) {
            self.rowCount = 2;
        }
        
        if ([formatter isEqualToString:@"yyyyMM"]) {
            self.type = 1;
            self.rowCount = 2;
        }
        if ([formatter isEqualToString:@"yyyyMMddHHmm"]) {
            _arrayMinute = [NSMutableArray arrayWithObjects:@"00分",@"30分", nil];
            self.rowCount = 5;
            self.style = 1;
        }
        if ([formatter isEqualToString:@"MM"]) {
            self.rowCount = 2;
            self.type = 2;
            NSString *year = [NSString stringWithFormat:@"%@年",[Utils dateToString:[NSDate date] withDateFormat:@"YYYY"]];
            _arrayYear = [NSMutableArray arrayWithObjects:year,nil];
        }
        // 选择器
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0 * defSCALE_VIEW, _btnConfirm.frame.origin.y + _btnConfirm.height + 5 * defSCALE_VIEW, self.width - 0 * defSCALE_VIEW, self.height - 42 * defSCALE_VIEW);
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        //        _pickerView.layer.borderWidth = 0.5f;
        //        _pickerView.layer.borderColor = [defCOLOR_SHADOW CGColor];
        _pickerView.backgroundColor = kMyColor(239, 239, 244);
        [self addSubview:_pickerView];
        // 默认时间 2016-08-15-12-30
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:now];
        
        if (self.type == 0) {
            if (self.rowCount == 3) {
                NSRange YearRange = NSMakeRange(0, 4);
                NSInteger year = [[dateString substringWithRange:YearRange] integerValue];
                
                NSRange MonthRange = NSMakeRange(4, 2);
                NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
                [self getDayArrayAtYear:year Month:month];
                NSRange DayRange = NSMakeRange(6, 2);
                NSInteger day = [[dateString substringWithRange:DayRange] integerValue];
                
                [_pickerView selectRow:year - 1900 inComponent:yearPicker animated:NO];
                [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
                [_pickerView selectRow:day-1 inComponent:dayPicker animated:NO];
            } else if (self.rowCount == 2) {
                NSRange HourRange = NSMakeRange(8, 2);
                NSInteger hour = [[dateString substringWithRange:HourRange] integerValue];
                
                NSRange MinuteRange = NSMakeRange(10, 2);
                NSInteger minute = [[dateString substringWithRange:MinuteRange] integerValue];
                
                [_pickerView selectRow:hour inComponent:0 animated:NO];
                [_pickerView selectRow:minute inComponent:1 animated:NO];
                
            } else if (self.rowCount == 5) {
                
                NSRange YearRange = NSMakeRange(0, 4);
                NSInteger year = [[dateString substringWithRange:YearRange] integerValue];
                
                NSRange MonthRange = NSMakeRange(4, 2);
                NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
                
                NSRange DayRange = NSMakeRange(6, 2);
                NSInteger day = [[dateString substringWithRange:DayRange] integerValue];
                [self getDayArrayAtYear:year Month:month];
                [_pickerView selectRow:year - 1900 inComponent:yearPicker animated:NO];
                [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
                [_pickerView selectRow:day-1 inComponent:dayPicker animated:NO];
                
                NSRange HourRange = NSMakeRange(8, 2);
                NSInteger hour = [[dateString substringWithRange:HourRange] integerValue];
                
                //                NSRange MinuteRange = NSMakeRange(10, 2);
                //                NSInteger minute = [[dateString substringWithRange:MinuteRange] integerValue];
                
                [_pickerView selectRow:hour inComponent:3 animated:NO];
                [_pickerView selectRow:0 inComponent:4 animated:NO];
            }
            
        } else {
            
            NSRange MonthRange = NSMakeRange(4, 2);
            NSInteger month = [[dateString substringWithRange:MonthRange] integerValue];
            
            [_pickerView selectRow:0 inComponent:yearPicker animated:NO];
            [_pickerView selectRow:month-1 inComponent:monthPicker animated:NO];
        }
        
    }
    return self;
}
@end
