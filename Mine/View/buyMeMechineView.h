//
//  buyMeMechineView.h
//  Financeteam
//
//  Created by Zccf on 2017/8/9.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buyMeMechineView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *topScroll;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) UILabel *contentLB;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) UIPageControl *page;
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;
@end
