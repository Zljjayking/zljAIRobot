//
//  ItemViewCell.m
//  MyDemo
//
//  Created by 张帅 on 16/11/28.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import "ItemViewCell.h"
#import "UIView+GoodView.h"
#import "ScoreView.h"
#import "ChildCellModels.h"
#import "MPublicManager.h"
#define SCREEN [UIScreen mainScreen].bounds.size
@interface ItemViewCell()
@property (nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation ItemViewCell {
    NSMutableArray * itemArray;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withItem:(CompoundViewModel*)compoundModel indexPath:(NSIndexPath *)indexPath  {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _CompoundViewModel=compoundModel;
        _row=indexPath.row;
        [self uiConfigure];
    }
    return self;
}
- (void)uiConfigure {
    itemArray=[[NSMutableArray alloc] init];
    CGRect rightFrame=CGRectZero;
    for (int i=0; i<_CompoundViewModel.ColumnNamesList.count; i++) {///根据杂草试材个数来循环
        RowModels *model =_CompoundViewModel.RowModels[_row];//药剂
        ChildCellModels*ChildCellModels=  model.ChildCellModels[i];
        CGFloat itemWidth=[self ietmWidth:ChildCellModels.CellContents.count Index:i];//每个item的宽
        NSString * labelNumber = [NSString stringWithFormat:@"%@",ChildCellModels.count];//每个item里面有几个评分
        self.scoreview = [[ScoreView alloc] initWithFrame:CGRectMake(rightFrame.origin.x+rightFrame.size.width, 0, itemWidth, 35) withLabelNumber:labelNumber Count:(int)ChildCellModels.CellContents.count];
        ///记录上一个view的frame
        rightFrame=_scoreview.frame;
        _scoreview.transverseRow=i;
        
        _scoreview.numberLB.text = [NSString stringWithFormat:@"%@",labelNumber];
        
        [self.contentView addSubview:_scoreview];
        ///添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapClick:)];
        [_scoreview addGestureRecognizer:tap];
        [itemArray addObject:_scoreview];
    }
}
- (void)reloadItemWithModel:(CompoundViewModel *)model {
    for (int i=0; i<_CompoundViewModel.ColumnNamesList.count; i++) {///根据杂草试材个数来循环
        RowModels *model =_CompoundViewModel.RowModels[_row];//药剂
        ChildCellModels*ChildCellModels =  model.ChildCellModels[i];
//        CGFloat itemWidth=[self ietmWidth:ChildCellModels.CellContents.count Index:i];//每个item的宽
        NSInteger labelNumber = [ChildCellModels.count integerValue];//每个item里面有几个评分
        
        _scoreview.numberLB.text = [NSString stringWithFormat:@"%ld",labelNumber];
        
    }
}
- (void)setRow:(NSInteger)row {
    _row=row;
}
- (void)setType:(CellSelectType)type {
    _type=CellDefaultType;
    for (UIView * sView in self.contentView.subviews) {
        if ([sView isKindOfClass:[ScoreView class]]) {
            ScoreView * _scoreView =(ScoreView *)sView;
            if (_type==CellDefaultType) {
                _scoreView.type=DefaultType;
            } else {
               _scoreView.type=SelectedType;
            }
            ///标记竖排
            if (_scoreView.frame.origin.x==_selectedItemFrame.origin.x) {
                _scoreView.type=VerticalSelectedType;
            }
          
          }
    }
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
    
    ColumnNamesList *model = _CompoundViewModel.ColumnNamesList[index];
     CGSize RowNameSize = [MPublicManager workOutSizeWithStr:model.ColumnName andFont:[UIFont systemFontOfSize:13] value:[NSValue valueWithCGSize:CGSizeMake(MAXFLOAT, MAXFLOAT)]];
    
    int totalWidth=SCREEN.width-70;
    if (MAX(RowNameSize.width, with)<totalWidth && _CompoundViewModel.ColumnNamesList.count==1) {
        return totalWidth;
    } else {
      CGFloat dataWidth = [self getTotalWidth];
        if (dataWidth<totalWidth) { //数据的宽度小于UI的宽度
            int count =(int)_CompoundViewModel.ColumnNamesList.count;
            CGFloat average =totalWidth/count;//平均宽
            return MAX(average, MAX((RowNameSize.width+10), with));
        }
    }
    return MAX((RowNameSize.width+10), with);
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
- (void)viewTapClick:(UITapGestureRecognizer *)tap {
    ScoreView * _scoreView = (ScoreView *)tap.view;
    NSLog(@"_scoreView--横向列数(%d)",_scoreView.transverseRow);
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapClickItemFrame:withIndexPath:TransverseRow:)]) {
        [self.delegate tapClickItemFrame:tap.view.frame withIndexPath:_indexPath TransverseRow:_scoreView.transverseRow];
    }
}
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath=indexPath;
}
- (void)setSelectedItemFrame:(CGRect)selectedItemFrame {
    _selectedItemFrame=selectedItemFrame;
}
- (void)setCompoundViewModel:(CompoundViewModel *)CompoundViewModel {
    _CompoundViewModel=CompoundViewModel;
     RowModels *model =_CompoundViewModel.RowModels[_indexPath.row];//药剂
    int _i=0;
    for (ScoreView * _scoreView in itemArray) {
        ChildCellModels*ChildCellModels=  model.ChildCellModels[_i];
         _scoreView.contentArray=ChildCellModels.CellContents;
        _i++;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
