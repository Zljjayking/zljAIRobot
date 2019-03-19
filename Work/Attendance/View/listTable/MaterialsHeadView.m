//
//  MaterialsHeadView.m
//  MyDemo
//
//  Created by 张帅 on 16/11/29.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import "MaterialsHeadView.h"
#import "CompoundViewModel.h"
#import "MPublicManager.h"
#define SCREEN  [UIScreen mainScreen].bounds.size
@interface MaterialsHeadView (){
    UIScrollView * _scrollView;
    UIView * _redLine;
    
    
}
@property (nonatomic,strong)CompoundViewModel * CompoundViewModel;

@end

@implementation MaterialsHeadView

- (id)initWithFrame:(CGRect)frame withCompoundViewModel:(CompoundViewModel *)CompoundViewModel {
    self=[super initWithFrame:frame];
    if (self) {
        _CompoundViewModel=CompoundViewModel;
        [self uiConfigure];
    }
    return self;
}
- (void)uiConfigure {
    self.backgroundColor = [UIColor lightGrayColor];
    UILabel * titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, self.frame.size.height)];
    titleLabel.text=@"姓名";
    titleLabel.numberOfLines=2;
    titleLabel.textColor=GRAY70;
    titleLabel.font=[UIFont systemFontOfSize:13];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    [self addSubview:titleLabel];
    
    UIView * spacingLine=[[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
    spacingLine.backgroundColor=[UIColor whiteColor];
    spacingLine.alpha=0.7;
    [self addSubview:spacingLine];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, 0, self.frame.size.width-titleLabel.frame.size.width, self.frame.size.height)];
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator=NO;
    CGFloat scrollViewWidth =[self tableViewWidthWithCompoundListModel:_CompoundViewModel];
    _scrollView.contentSize=CGSizeMake(scrollViewWidth, self.frame.size.height);
    _scrollView.bounces=NO;
    [self addSubview:_scrollView];
    
    CGRect rightFrame=CGRectZero;
    for (int i=0; i<_CompoundViewModel.ColumnNamesList.count; i++) {
        ColumnNamesList *ColumnNamesList =_CompoundViewModel.ColumnNamesList[i];
        CGFloat itemWidth=[self ietmWidth:ColumnNamesList.ChildList.count Index:i];
        MaterialsView *  _scoreview =[self viewWithTag:10000+i];
        if (!_scoreview) {
            _scoreview = [[MaterialsView alloc] initWithFrame:CGRectMake(rightFrame.origin.x+rightFrame.size.width, 0, itemWidth, self.frame.size.height) MaterialsName:ColumnNamesList.ColumnName doseArray:ColumnNamesList.ChildList];
        } else {
            _scoreview.frame=CGRectMake(rightFrame.origin.x+rightFrame.size.width, 0, itemWidth, 50);
        }
        if (i==0) {
            _scoreview.type=MaterialsDefaultType;
        }
        _scoreview.tag=10000+i;
        ///记录上一个view的frame
        rightFrame=_scoreview.frame;
        [_scrollView addSubview:_scoreview];
        ///添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
        [_scoreview addGestureRecognizer:tap];
    }
    
    ColumnNamesList *ColumnNamesList =[_CompoundViewModel.ColumnNamesList firstObject];
    CGFloat lineWidth = [self ietmWidth:ColumnNamesList.ChildList.count Index:0];
    ///添加红线
    _redLine=[[UIView alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height-2, lineWidth, 2)];
    _redLine.backgroundColor= [UIColor colorWithRed:63/255.0f green:143/255.0f blue:255/255.0f alpha:1];
//    [_scrollView addSubview:_redLine];
}
-(CGFloat)tableViewWidthWithCompoundListModel:(CompoundViewModel *)CompoundViewModel {
    CGFloat with=0;
    for (ColumnNamesList *model in CompoundViewModel.ColumnNamesList) {
        CGSize RowNameSize = [MPublicManager workOutSizeWithStr:model.ColumnName andFont:[UIFont systemFontOfSize:13] value:[NSValue valueWithCGSize:CGSizeMake(MAXFLOAT, MAXFLOAT)]];
        //评分label宽度
        CGFloat scoreLabelWith=15;
        CGFloat tiemWidth=0;
        ///label个数
        NSInteger labelNumber =model.ChildList.count;
        tiemWidth=(scoreLabelWith*labelNumber)+((labelNumber-1)*2)+10;
        with+=MAX(RowNameSize.width+10, tiemWidth);
    }
    int totalWidth=-70;
    if (with<totalWidth && CompoundViewModel.ColumnNamesList.count==1) {
        return totalWidth;
    }
    return with;
}
- (void)setIsRolling:(BOOL)isRolling {
    _isRolling=isRolling;
}
/**
 计算每个view的宽度
 */
-(CGFloat)ietmWidth:(NSInteger )count Index:(int)index{
    CGFloat with=0;
    //评分label宽度
    CGFloat scoreLabelWith=15;
    NSInteger labelNumber =count;
    with=(scoreLabelWith*labelNumber)+((labelNumber*2)-2)+10;
    //计算杂草药剂名称宽度
    ColumnNamesList *model = _CompoundViewModel.ColumnNamesList[index];
    CGSize RowNameSize = [MPublicManager workOutSizeWithStr:model.ColumnName andFont:[UIFont systemFontOfSize:13] value:[NSValue valueWithCGSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)]];
    
    int totalWidth=SCREEN.width-70;
    if (MAX(RowNameSize.width, with)<totalWidth && _CompoundViewModel.ColumnNamesList.count==1) {//如果 UI 的宽度 或者数据的宽度 小于 tableview的宽度 切 杂草试材只有一个item的宽度 为 铺满状态
        return totalWidth;
    } else {
        CGFloat dataWidth = [self getTotalWidth];
        if (dataWidth<totalWidth) { //数据的宽度小于UI的宽度
            int count =(int)_CompoundViewModel.ColumnNamesList.count;
            CGFloat average =totalWidth/count;//平均宽
            return MAX(MAX(RowNameSize.width+10, with), average);
        }
    }
    return MAX(RowNameSize.width+10, with);//两者取其大
}
- (CGFloat )getTotalWidth {
    CGFloat with=0;
    CGFloat scoreLabelWith=15;
    for (ColumnNamesList * ColumnNamesList in _CompoundViewModel.ColumnNamesList) {
        ///label个数
        NSInteger labelNumber =ColumnNamesList.ChildList.count;
        with +=(scoreLabelWith*labelNumber)+((labelNumber*2)-2)+10;
    }
    return with;
}

- (void)setHeaderScrollViewContentOffset:(CGPoint)Offset {
    [_scrollView setContentOffset:Offset animated:NO];
}
#pragma mark 手势
- (void)viewTapClick:(UITapGestureRecognizer *)tap {
    CGRect selectFrame =tap.view.frame;
    _redLine.frame=CGRectMake(selectFrame.origin.x, _scrollView.frame.size.height-2, selectFrame.size.width, 3);
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewClick:)]) {
        [self.delegate  topViewClick:selectFrame];
    }
    for (UIView * sView in _scrollView.subviews) {
        if ([sView isKindOfClass:[MaterialsView class]]) {
            MaterialsView * myView =(MaterialsView *)sView;
            if (myView.frame.origin.x == tap.view.frame.origin.x) {
                myView.type=MaterialsSelectedType;
               
            } else {
                myView.type=MaterialsDefaultType;
            }
        }
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isRolling=YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topScrollViewContentOffset:IsRolling:)]) {
        [self.delegate topScrollViewContentOffset:scrollView.contentOffset IsRolling:_isRolling];
    }
}
- (void)setSelectedFrame:(CGRect)selectedFrame {
    _selectedFrame=selectedFrame;
     _redLine.frame=CGRectMake(_selectedFrame.origin.x, _scrollView.frame.size.height-2, _selectedFrame.size.width, 2);
    for (UIView *view in _scrollView.subviews) {
        if ([view  isKindOfClass:[MaterialsView class]]) {
            MaterialsView * materialsView =(MaterialsView *)view;
            if (_selectedFrame.origin.x==view.frame.origin.x) {
                materialsView.type=MaterialsSelectedType;
            } else {
                materialsView.type=MaterialsDefaultType;
            }
        }
    }
}
@end







@interface MaterialsView ()
@property (nonatomic,strong)NSArray * doseArray;//剂量
@property (nonatomic,strong)NSString *materialsName;//试材名
@end
#define _color [UIColor colorWithRed:250/255.0f green:230/255.0f blue:230/255.0f alpha:1]
//试材view
@implementation MaterialsView {
    UILabel * materialsLabel;
}


- (id)initWithFrame:(CGRect)frame MaterialsName:(NSString *)materialsName doseArray:(NSArray * )doseS {
    self=[super initWithFrame:frame];
    if (self) {
        _viewWidth=frame.size.width;
        _materialsName=materialsName;
        _doseArray=doseS;
        [self uiConfigure];
        self.type=MaterialsDefaultType;
    }
    return self;
}
- (void)uiConfigure {
    materialsLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    materialsLabel.text=_materialsName;
    materialsLabel.textAlignment=NSTextAlignmentCenter;
    materialsLabel.font=[UIFont systemFontOfSize:13];
    materialsLabel.textColor=GRAY70;
    [self addSubview:materialsLabel];
   
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
//    line1.backgroundColor = [UIColor whiteColor];
//    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, 0.5, self.frame.size.height)];
    line2.backgroundColor = [UIColor whiteColor];
    [self addSubview:line2];
    
//    CGFloat labelWidth=15;///每个label的宽度
//    CGFloat labelSpacing=2;//label之间的间距
//    int count =(int)_doseArray.count;
//    CGFloat theleftSpacing=(_viewWidth/2)-(count*(labelWidth+labelSpacing)/2);
//    for (int i=0; i<_doseArray.count; i++) {
//        UILabel * label =[self viewWithTag:20+i];
//        if (!label) {
//            label = [[UILabel alloc] initWithFrame:CGRectMake((i*(labelWidth+labelSpacing))+theleftSpacing,self.frame.size.height/2, labelWidth, labelWidth)];
//        } else {
//            label.frame=CGRectMake((i*(labelWidth+labelSpacing))+theleftSpacing, self.frame.size.height/2, labelWidth, labelWidth);
//        }
//        label.text=_doseArray[i];
//        label.textAlignment=NSTextAlignmentCenter;
//        label.font=[UIFont systemFontOfSize:10];
//        label.tag=20+i;
//        [self addSubview:label];
//    }
}
- (void)setType:(MaterialsSelectType)type {
    _type=MaterialsDefaultType;
    if (_type==MaterialsSelectedType) {
       
        for (UIView * view in self.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel * myLabel =(UILabel *)view;
                if (myLabel.frame.size.width==15) {
                    myLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_rec_selected"]];
                    myLabel.textColor=[UIColor colorWithRed:63/255.0f green:143/255.0f blue:255/255.0f alpha:1];
                }
            }
        }
        materialsLabel.textColor=[UIColor colorWithRed:63/255.0f green:143/255.0f blue:255/255.0f alpha:1];
    } else {
        for (UIView * view in self.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel * myLabel =(UILabel *)view;
                if (myLabel.frame.size.width==15) {
                    myLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_rec_noselected"]];
                    myLabel.textColor=[UIColor blackColor];
                }
            }
        }
        materialsLabel.textColor=GRAY70;
    }
}








@end
