//
//  PotionCell.m
//  MyDemo
//
//  Created by Macx on 16/11/28.
//  Copyright © 2016年 张帅. All rights reserved.
//

#import "PotionCell.h"

@implementation PotionCell {
    UILabel * contentLabel;
    UIView * selectLine;
    UIView * bottomLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self uiConfigure];
    }
    return self;
}
- (void)uiConfigure {
    contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 35)];
    contentLabel.textAlignment=NSTextAlignmentCenter;
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.textColor = GRAY100;
    [self.contentView addSubview:contentLabel];
    
    bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, 35-0.5, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor=[UIColor whiteColor];
    
    [self.contentView addSubview:bottomLine];
    
    selectLine=[[UIView alloc] initWithFrame:CGRectMake(68, 0, 2, 35)];
//    [self.contentView addSubview:selectLine];
}
- (void)setContentStr:(NSString *)contentStr {
    _contentStr=contentStr;
    contentLabel.text=_contentStr;
}
- (void)setIsSelected:(BOOL)isSelected {
    _isSelected=isSelected;
    if (_isSelected) {
        contentLabel.textColor= [UIColor colorWithRed:63/255.0f green:143/255.0f blue:255/255.0f alpha:1];
       
        selectLine.backgroundColor=[UIColor colorWithRed:63/255.0f green:143/255.0f blue:255/255.0f alpha:1];
    } else {
//        contentLabel.textColor=[UIColor blackColor];
        selectLine.backgroundColor=[UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
