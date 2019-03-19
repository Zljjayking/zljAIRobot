//
//  MaterialsHeadView.h
//  MyDemo
//
//  Created by 张帅 on 16/11/29.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompoundViewModel.h"
@protocol MaterialsHeadViewDelegate <NSObject>
- (void)topViewClick:(CGRect)selectedFrame;
- (void)topScrollViewContentOffset:(CGPoint)Offset IsRolling:(BOOL)isRolling;
@end
@interface MaterialsHeadView : UIView<UIScrollViewDelegate>
@property (nonatomic,assign)id<MaterialsHeadViewDelegate>delegate;
@property (nonatomic,assign)CGRect selectedFrame;
@property (nonatomic,assign) BOOL isRolling;
- (id)initWithFrame:(CGRect)frame withCompoundViewModel:(CompoundViewModel *)CompoundViewModel;
- (void)setHeaderScrollViewContentOffset:(CGPoint)Offset;
@end


typedef NS_ENUM(NSInteger, MaterialsSelectType) {
    MaterialsDefaultType,          // 默认 灰色
    MaterialsSelectedType,         // 选中 红色
};
@interface MaterialsView : UIView
@property(nonatomic,assign)MaterialsSelectType type;
@property (nonatomic,assign) CGFloat viewWidth;
- (id)initWithFrame:(CGRect)frame MaterialsName:(NSString *)materialsName doseArray:(NSArray* )doseS;
@end
