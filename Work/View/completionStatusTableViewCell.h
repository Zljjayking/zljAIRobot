//
//  completionStatusTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/6/3.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface completionStatusTableViewCell : UITableViewCell
@property (nonatomic, retain) UIView *topSeparatoerLine;
@property (nonatomic, retain) UIView *leftSeparatoerLine;
@property (nonatomic, retain) UIView *rightSeparatoerLine;
@property (nonatomic, retain) UIView *bottomSeparatoerLine;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, retain) UILabel *nameLb;
@property (nonatomic, strong) UILabel *statusLb;
@property (nonatomic, strong) UILabel *statusLb1;
@property (nonatomic, strong) UILabel *countLb;
@end
