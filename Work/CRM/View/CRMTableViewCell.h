//
//  CRMTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/6/6.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRMTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *mobilLB;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *systemAllocationLB;
@property (nonatomic, strong) UILabel *signLB;
@property (nonatomic, strong) UILabel *realNameLB;
@property (nonatomic, strong) UILabel *statusLB;
@property (nonatomic, strong) UILabel *createTimeLB;
@end
