//
//  AvilableTableViewCell.h
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "avilableBtn.h"
@interface AvilableTableViewCell : UITableViewCell
@property (nonatomic, strong) UICollectionView *AvailableCollection;
@property (nonatomic, strong) AppDelegate *MyDelegate;
@property (nonatomic, strong) NSMutableArray *avilablePersonNameArr;
@property (nonatomic, strong) NSMutableArray *avilablePersonImageArr;
@property (nonatomic, strong) avilableBtn *Btn;
@end
