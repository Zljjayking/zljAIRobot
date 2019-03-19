//
//  FunctionNameOneTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionNameOneTableViewCell : UITableViewCell
@property (nonatomic, strong) AppDelegate *MyDelegate;
@property (nonatomic, strong) UIButton *DaGou;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic) NSInteger index;
@property (nonatomic, assign) BOOL isAdd;
@end
