//
//  productTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface productTableViewCell : UITableViewCell
@property (nonatomic, strong) AppDelegate *MyDelegate;
@property (nonatomic, strong) UIImageView *mechProIcon;
@property (nonatomic, strong) UILabel *mechProNameLB;
@property (nonatomic, strong) UILabel *mechProTypeLB;
@property (nonatomic, strong) UILabel *tabInterestRateLB;
@property (nonatomic, strong) UILabel *dayLB;
@property (nonatomic, strong) UILabel *cashLB;
@property (nonatomic, strong) UILabel *methodLB;

@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UIImageView *officalProImage;
@end
