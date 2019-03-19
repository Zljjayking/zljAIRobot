//
//  monthlyViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/6/19.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^clickBangBlock)(NSArray *modelArr);
typedef void (^showMonthBlock)();
@interface monthlyViewController :UIViewController
//@property (nonatomic) monthlyBlock monthlyblock;
@property (nonatomic) showMonthBlock showDate;
@property (nonatomic) clickBangBlock clickBangOne;
@property (nonatomic) clickBangBlock clickBangTwo;
@property (nonatomic, strong) UIButton *dateChooseBtn;
- (void)requestData;
- (void)reloadData;
@end
