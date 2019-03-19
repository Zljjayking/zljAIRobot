//
//  ItemViewCell.h
//  MyDemo
//
//  Created by 张帅 on 16/11/28.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompoundViewModel.h"
#import "ScoreView.h"
typedef NS_ENUM(NSInteger, CellSelectType) {
    CellDefaultType,          // 默认 灰色
    CellSelectedType,         // 选中 红色
};
@protocol ItemViewCellDelegate <NSObject>
/**
 @param ItemFrameframe <#ItemFrameframe description#>
 @param indexPath <#indexPath description#>
 @param transverseRow 横向列数
 */
- (void)tapClickItemFrame:(CGRect )ItemFrameframe withIndexPath:(NSIndexPath *)indexPath TransverseRow:(int)transverseRow;

@end
@interface ItemViewCell : UITableViewCell
@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,assign)CellSelectType type;
@property (nonatomic,assign)CGRect selectedItemFrame;
@property (nonatomic,assign)id<ItemViewCellDelegate>delegate;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) CompoundViewModel* CompoundViewModel;

@property (nonatomic,strong) ScoreView *scoreview;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withItem:(CompoundViewModel*)compoundModel indexPath:(NSIndexPath *)indexPath;
- (void)reloadItemWithModel:(CompoundViewModel*)model;
@end
