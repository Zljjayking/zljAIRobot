//
//  dailyClickView.h
//  Financeteam
//
//  Created by Zccf on 2017/6/22.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dailyClickView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *type;
- (id)initWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr mech_id:(NSString *)mech_id user_id:(NSString *)user_id dept_id:(NSString *)dept_id type:(NSString *)type  time:(NSString *)time title:(NSString *)title;

@end
