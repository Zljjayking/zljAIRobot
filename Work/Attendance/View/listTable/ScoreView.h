//
//  scoreView.h
//  MyDemo
//
//  Created by 张帅 on 16/11/28.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ScoreSelectType) {
    DefaultType,          // 默认 灰色
    SelectedType,         // 选中 红色
    VerticalSelectedType, // 竖排 选中
};
@interface ScoreView : UIView
@property (nonatomic,assign)ScoreSelectType type;
@property (nonatomic,assign)BOOL isTransverseSelected;
@property (nonatomic,strong) NSArray * contentArray;
@property (nonatomic,strong)NSMutableArray * labelS;
@property (nonatomic, strong) UILabel *numberLB;
///横向第几行
@property (nonatomic,assign) int transverseRow;
- (id)initWithFrame:(CGRect)frame withLabelNumber:(NSString *)number Count:(int)count;

@end
