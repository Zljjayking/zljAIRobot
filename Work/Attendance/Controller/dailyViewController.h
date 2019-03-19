//
//  dailyViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/6/19.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "DemoBaseViewController.h"
typedef void (^dailyBlock)(NSDictionary *modelDic,NSString *time);
typedef void (^showDateBlock)();
typedef void (^clickBlock)(NSString *date,NSString *type);
@interface dailyViewController : DemoBaseViewController
@property (nonatomic) dailyBlock dailyblock;
@property (nonatomic) showDateBlock showDate;
@property (nonatomic) clickBlock clickbock;
@property (nonatomic, strong) UIButton *dateChooseBtn;

@property (nonatomic, strong) PieChartView *chartView;

- (void)reloadData;
@end
