//
//  versionAlertView.h
//  Financeteam
//
//  Created by Zccf on 2017/7/4.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^updateBlock)();
@interface versionAlertView : UIView
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *versionLB;
@property (nonatomic, strong) updateBlock block;
- (id)initWithFrame:(CGRect)frame version:(NSString *)version title:(NSString *)title;
@end
