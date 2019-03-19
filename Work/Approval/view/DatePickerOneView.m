//
//  DatePickerOneView.m
//  Financeteam
//
//  Created by Zccf on 2017/5/11.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "DatePickerOneView.h"

@implementation DatePickerOneView
//- (UIDatePicker *)datePicker {
//    if (!_datePicker) {
//        
//    }
//    return _datePicker;
//}
- (DatePickerOneView *)initWithCustomeHeight:(CGFloat)height
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, height=height<200?200:height)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.05].CGColor;
        
        //创建取消 确定按钮
        UIButton *cannel = [UIButton buttonWithType:UIButtonTypeCustom];
        cannel.frame = CGRectMake(20, 0, 50, 40);
        [cannel setTitle:@"取消" forState:0];
        [cannel setTitleColor:MYORANGE forState:0];
        cannel.tag = 1;
        [cannel addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cannel];
        
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        confirm.frame = CGRectMake(kScreenWidth-70, 0, 50, 40);
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:MYORANGE forState:0];
        confirm.tag = 2;
        [confirm addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        
        
        // 创建datapikcer
        self.datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 250-40)];
        self.datePickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        // 本地化
        self.datePickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        
        // 日期控件格式
        
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
        
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *defaultDateStr = [dateformatter stringFromDate:[NSDate date]];
        
        NSDate *defaultDate = [dateformatter dateFromString:defaultDateStr];
        
        self.datePickerView.date = defaultDate;
        
        [self addSubview:self.datePickerView];
        
        
        
    }
    return self;
}


//计算某个时间与此刻的时间间隔（天）
- (NSString *)dayIntervalFromNowtoDate:(NSString *)dateString
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d=[date dateFromString:dateString];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate *dat = [NSDate date];
    NSString *nowStr = [date stringFromDate:dat];
    NSDate *nowDate = [date dateFromString:nowStr];
    
    NSTimeInterval now=[nowDate timeIntervalSince1970]*1;
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    
    if ([timeString intValue] < 0) {
        
        timeString = [NSString stringWithFormat:@"%d",-[timeString intValue]];
    }
    
    return timeString;
    
}

//选择确定或者取消
- (void)cannelOrConfirm:(UIButton *)sender
{
    if (sender.tag==2) {
        
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *choseDateString = [dateformatter stringFromDate:self.datePickerView.date];
        
        //如果选择的日期是未来
        if ([[[NSDate date] laterDate:self.datePickerView.date] isEqualToDate:self.datePickerView.date]) {
            
            [MBProgressHUD showError:@"不得大于当前时间"];
            
            return;
        }
        
        //计算出剩余多久生日
        //拿到生日中的 月&日 年份为今年 拼接起来 转化为时间 与今天相减
        NSArray *tempArr = [choseDateString componentsSeparatedByString:@"-"];
        
        NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init];
        [currentFormatter setDateFormat:@"yyyy"];
        NSString *currentYear = [currentFormatter stringFromDate:[NSDate date]];
        
        NSString *appendString = [NSString stringWithFormat:@"%@-%@-%@",currentYear,tempArr[1],tempArr[2]];
        
        
        NSDate *appendDate = [dateformatter dateFromString:appendString];
        
        //将此刻时间转换为与选择时间格式一致
        NSDate *now = [NSDate date];
        NSString *nowStr = [dateformatter stringFromDate:now];
        NSDate *nowDate = [dateformatter dateFromString:nowStr];
        
        
        //判断拼接后的时间与此刻时间对比
        if ([[nowDate earlierDate:appendDate] isEqualToDate:appendDate]) {
            //拼接后在当前时间之前 重新拼接 年份+1
            if (![nowDate isEqualToDate:appendDate]) {
                
                appendString = [NSString stringWithFormat:@"%d-%@-%@",[currentYear intValue]+1,tempArr[1],tempArr[2]];
            }
            
        }
        
        NSString *intercalStr = [self dayIntervalFromNowtoDate:appendString];
        
        self.confirmBlock(choseDateString,intercalStr);
        
        NSLog(@"intercalStr==%@",intercalStr);
        
    } else {
        self.cannelBlock();
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
