//
//  attendanceCollectionViewCell.m
//  Financeteam
//
//  Created by Zccf on 2017/6/1.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "attendanceCollectionViewCell.h"
#import "LoginPeopleModel.h"
#import "HttpRequestEngine.h"
#import "attendanceTableViewCell.h"
@interface attendanceCollectionViewCell ()
@property (nonatomic, strong) UIView *BGView;
@property (weak, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGPoint imageCenter;
@property (strong, nonatomic) UIImage *gifImage;
@property (nonatomic, strong) LoginPeopleModel *MyloginModel;
@property (nonatomic, strong) NSString *dateStr;
@end
@implementation attendanceCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)requestDataWithTime:(NSString *)time type:(NSString *)type{
    self.dateStr = time;
    [self setupWithTime:time type:type];
    
}
- (void)setupWithTime:(NSString *)time type:(NSString *)type
{
    
    
    self.BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 190*KAdaptiveRateWidth)];
    self.BGView.backgroundColor = kMyColor(29, 46, 55);
    [self addSubview:self.BGView];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 190*KAdaptiveRateWidth)];
    [self.BGView addSubview:bgView];
    bgView.image = [UIImage imageNamed:@"工作日"];
    if ([type isEqualToString:@"1"]) {
        bgView.image = [UIImage imageNamed:@"休息"];
    } else {
        bgView.image = [UIImage imageNamed:@"工作日"];
    }
    
    //用来获取本地年月日星期
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期六",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    
    NSDate *date = [Utils stringToDate:time withDateFormat:@"YYYY-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    long int week = [comps weekday];
    
    UILabel *weakLB = [[UILabel alloc] init];
    weakLB.font = [UIFont systemFontOfSize:26];
    weakLB.textColor = [UIColor whiteColor];
    [bgView addSubview:weakLB];
    weakLB.text = [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]];
    [weakLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.top.equalTo(bgView.mas_top).offset(70);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *dateLB = [[UILabel alloc] init];
    [bgView addSubview:dateLB];
    dateLB.textColor = [UIColor whiteColor];
    dateLB.textAlignment = NSTextAlignmentRight;
    dateLB.font = [UIFont systemFontOfSize:15];
    [dateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-14);
        make.top.equalTo(bgView.mas_top).offset(105);
        make.height.mas_equalTo(20);
    }];
    dateLB.text = [Utils dateToString:date withDateFormat:@"YYYY-MM-dd"];
    
//    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(30, 120*KAdaptiveRateWidth-10, 2, 10)];
//    [self.BGView addSubview:lineV];
//    lineV.backgroundColor = [UIColor whiteColor];
    
//    [self.attendanceTableView setContentOffset:CGPointMake(0,0) animated:NO];
    
}


@end
