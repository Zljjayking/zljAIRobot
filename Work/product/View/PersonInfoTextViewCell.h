//
//  PersonInfoTextViewCell.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPITreeViewNode.h"

@interface PersonInfoTextViewCell : UITableViewCell<UITextViewDelegate>


@property(retain,strong,nonatomic)CPITreeViewNode * node;
@property (weak, nonatomic) IBOutlet UILabel *personInfoLabel;
@property (weak, nonatomic) IBOutlet UITextView *personInfoTextView;

@end
