//
//  JohnTopTitleView.h
//  TopTitle
//
//  Created by aspilin on 2017/4/11.
//  Copyright © 2017年 aspilin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^indexBlock)(NSInteger index);
@interface JohnTopTitleView : UIView

//传入title数组
@property (nonatomic,strong) NSArray *title;
@property (nonatomic,strong) UIScrollView *pageScrollView;
/**
 *传入父控制器和子控制器数组即可
 **/
- (void)setupViewControllerWithFatherVC:(UIViewController *)fatherVC childVC:(NSArray<UIViewController *>*)childVC;
@property (nonatomic ,strong) indexBlock selectBlock;
@end
