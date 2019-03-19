//
//  scoreView.m
//  MyDemo
//
//  Created by 张帅 on 16/11/28.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import "ScoreView.h"
#import "CellContents.h"
#import "ChildCellModels.h"
#define viewBackgounerColor [UIColor colorWithRed:61/255.0f green:143/255.0f blue:225/255.0f alpha:0.1]
#define lineColor [UIColor colorWithRed:61/255.0f green:143/255.0f blue:225/255.0f alpha:0.8]
#define centerSelectColor  [UIColor colorWithRed:61/255.0f green:143/255.0f blue:225/255.0f alpha:0.2]
@implementation ScoreView {
    UIImage * _defaultImage;
    UIImage * _selectedImage;
    UIView  * _topLine, *_bottmLine, *_leftLine, *_rightLine;
    UIColor * _clearColor;
}
- (id)initWithFrame:(CGRect)frame withLabelNumber:(NSString *)number Count:(int)count  {
    self=[super initWithFrame:frame];
    if (self) {
        _labelS=[[NSMutableArray alloc] init];
        [self addLine];
//        self.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
//        CGFloat labelWidth=15;///每个label的宽度
//        CGFloat labelSpacing=2;//label之间的间距
////        int count =(int)scoreArray.count;
//        CGFloat theleftSpacing=(self.frame.size.width/2)-(count*(labelWidth+labelSpacing)/2);
        
        self.numberLB = [[UILabel alloc]init];
        [self addSubview:self.numberLB];
        self.numberLB.textAlignment = NSTextAlignmentCenter;
        self.numberLB.textColor = GRAY70;
        self.numberLB.text = [NSString stringWithFormat:@"%@",number];
        self.numberLB.frame = CGRectMake(0, 0, self.frame.size.width, 35);
        
        
//        for (int i = 0; i<number ; i++) {
//        UILabel *  label = [[UILabel alloc] initWithFrame:CGRectMake((i*(labelWidth+labelSpacing))+theleftSpacing, (self.frame.size.height/2)-(labelWidth/2), labelWidth, labelWidth)];
//            label.textAlignment=NSTextAlignmentCenter;
//            label.font=[UIFont systemFontOfSize:10];
//            label.backgroundColor=[UIColor colorWithPatternImage:_defaultImage];
//            //分值
////            CellContents *model=scoreArray[i];
////            label.text=model.Content;
//            label.adjustsFontSizeToFitWidth=YES;
//            [self addSubview:label];
//            [_labelS addObject:label];
//        }
    }
    return self;
}
- (void)addLine {
    _clearColor    = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
    _defaultImage  = [UIImage imageNamed:@"bg_rec_noselected"];//默认label背景
    _selectedImage = [UIImage imageNamed:@"bg_rec_selected"]; //选中label背景
    _topLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.8)];
//    [self addSubview:_topLine];
    _bottmLine=[[UIView alloc] initWithFrame:CGRectMake(0, 35-0.5, self.frame.size.width, 0.5)];
    [self addSubview:_bottmLine];
    _leftLine=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
//    [self addSubview:_leftLine];
    _rightLine=[[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, 0.5, 35)];
    [self addSubview:_rightLine];
}
- (void)setType:(ScoreSelectType)type {
    _type=DefaultType;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *scorelabel = (UILabel *)view;
            if (_type==DefaultType) {
                _leftLine.backgroundColor  = _clearColor;
                _rightLine.backgroundColor = _clearColor;
                _topLine.backgroundColor   = _clearColor;
                _bottmLine.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
                self.backgroundColor       = [UIColor whiteColor];
//                scorelabel.backgroundColor = [UIColor colorWithPatternImage:_defaultImage];
//                scorelabel.textColor       = [UIColor blackColor];
                //取消横向标记
                self.isTransverseSelected=NO;
            }else if (_type==VerticalSelectedType) {
                //竖向选择
                 _leftLine.backgroundColor  = lineColor;
                 _rightLine.backgroundColor = lineColor;
                 self.backgroundColor       = viewBackgounerColor;
//                 scorelabel.backgroundColor = [UIColor colorWithPatternImage:_selectedImage];
                 scorelabel.textColor       = lineColor;
                //判断self当前颜色是否是选中颜色 且 已横向标记的 就为选中的交叉点 view 再修改颜色
                if ([self.backgroundColor isEqual:viewBackgounerColor] && self.isTransverseSelected) {
                    self.backgroundColor    =centerSelectColor;
                }
            } else {
                //横向选择
                _leftLine.backgroundColor  = _clearColor;
                _rightLine.backgroundColor = _clearColor;
                _topLine.backgroundColor   = lineColor;
                _bottmLine.backgroundColor = lineColor;
                self.backgroundColor       = viewBackgounerColor;
                scorelabel.textColor       = lineColor;
//                scorelabel.backgroundColor = [UIColor colorWithPatternImage:_selectedImage];
                //标记横向
                self.isTransverseSelected  = YES;
            }
        }
    }
}
- (void)setContentArray:(NSArray *)contentArray {
    _contentArray=contentArray;
    for (int i=0; i<self.labelS.count; i++) {
        CellContents * model =_contentArray[i];
        UILabel * label =self.labelS[i];
        label.text=model.Content;
    }
}
@end
