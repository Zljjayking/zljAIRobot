//
//  buyMe_signView.h
//  Financeteam
//
//  Created by Zccf on 2017/8/17.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^buyMeTopCancel)();
typedef void (^buyMeTopSure)();
@interface buyMe_signView : UIView
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) buyMeTopCancel buyMeTopCancelBlock;
@property (nonatomic, strong) buyMeTopSure buyMeTopSureBlock;
//- (instancetype)initWithFrame:(CGRect)frame;
@end
