//
//  dailyClickView.m
//  Financeteam
//
//  Created by Zccf on 2017/6/22.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "dailyClickView.h"
#import "FDAlertView.h"
#import "dailyOneTableViewCell.h"
#import "dailyTwoTableViewCell.h"
#import "HttpRequestEngine.h"
#import "dailyDetailModel.h"
#define topDistance 20
@implementation dailyClickView
- (id)initWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr mech_id:(NSString *)mech_id user_id:(NSString *)user_id dept_id:(NSString *)dept_id type:(NSString *)type time:(NSString *)time title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = customBackColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5*KAdaptiveRateWidth;
        
//        self.dataArr = modelArr;
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        UIView *yuan = [[UIView alloc]initWithFrame:CGRectMake(45, topDistance, 30, 30)];
        yuan.layer.masksToBounds = YES;
        yuan.layer.cornerRadius = 15;
        yuan.backgroundColor = [UIColor whiteColor];
        [self addSubview:yuan];
        
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, topDistance, 60, 30)];
        bg.backgroundColor = [UIColor whiteColor];
        [self addSubview:bg];
        
        
        UILabel *hehe = [[UILabel alloc]init];
        hehe.text = title;
        [self addSubview:hehe];
        hehe.textColor = GRAY70;
        hehe.font = [UIFont systemFontOfSize:14];
        hehe.textAlignment = NSTextAlignmentCenter;
        [hehe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(yuan.mas_centerX);
            make.top.equalTo(self.mas_top).offset(topDistance);
            make.height.mas_equalTo(30);
        }];
        
        self.type = type;
        
        [self requestDataWithMech_id:mech_id user_id:user_id dept_id:dept_id type:type time:time];
        
        [self setupView];
    }
    return self;
}
- (void)requestDataWithMech_id:(NSString *)mech_id user_id:(NSString *)user_id dept_id:(NSString *)dept_id type:(NSString *)type time:(NSString *)time  {
    [MBProgressHUD showMessage:@"2" toView:self];
    [HttpRequestEngine getDailyStatisticsDetailWithMech_id:mech_id user_id:user_id dept_id:dept_id time:time type:type completion:^(id obj, NSString *errorStr) {
        if ([Utils isBlankString:errorStr]) {
            NSArray *dataArr = obj;
            for (int i = 0; i<dataArr.count; i++) {
                NSDictionary *dic = dataArr[i];
                dailyDetailModel *model = [dailyDetailModel requestWithDic:dic];
                [self.dataArr addObject:model];
            }
            [MBProgressHUD hideHUDForView:self];
            [self.listView reloadData];
        } else {
            [MBProgressHUD hideHUDForView:self];
            [MBProgressHUD showError:errorStr];
        }
    }];
}
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc]initWithFrame:CGRectMake(5, 70, self.frame.size.width-10, self.frame.size.height-130) style:UITableViewStylePlain];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.tableFooterView = [UIView new];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}
- (void)setupView {
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self addSubview:self.listView];
    
    [self.listView registerClass:[dailyOneTableViewCell class] forCellReuseIdentifier:@"dailyOne"];
    [self.listView registerClass:[dailyTwoTableViewCell class] forCellReuseIdentifier:@"dailyTwo"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55*KAdaptiveRateWidth;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    dailyDetailModel *model = self.dataArr[indexPath.row];
    if ([self.type integerValue] == 4 || [self.type integerValue] == 7 ) {
        dailyTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyTwo"];
        if (cell == nil) {
            cell = [[dailyTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dailyTwo"];
        }
        [cell.headerImage sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        cell.titleLb.text = model.real_name;
        cell.contentLb.text = [NSString stringWithFormat:@"目的地:%@",model.businessAddress];
        cell.contentLbTwo.text = [NSString stringWithFormat:@"行程说明:%@",model.leave_reason];
        
        return cell;
    } else if ([self.type integerValue] == 6){
        dailyTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyTwo"];
        if (cell == nil) {
            cell = [[dailyTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dailyTwo"];
        }
        [cell.headerImage sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        cell.titleLb.text = model.real_name;
        cell.contentLb.text = model.leave_type_name;
        cell.contentLbTwo.text = [NSString stringWithFormat:@"请假原因:%@",model.leave_reason];
        return cell;
    } else {
        dailyOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dailyOne"];
        if (cell == nil) {
            cell = [[dailyOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dailyOne"];
        }
        [cell.headerImage sd_setImageWithURL:[model.icon convertHostUrl] placeholderImage:[UIImage imageNamed:@"聊天头像"]];
        cell.titleLb.text = model.real_name;
        return cell;
    }

}
- (void)closeClick:(UIButton *)sender {
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
    [self setupView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
