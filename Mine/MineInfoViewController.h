//
//  MineInfoViewController.h
//  Financeteam
//
//  Created by Zccf on 16/5/17.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ReturnStrBlock)(NSString *returnStr);
@interface MineInfoViewController : BaseViewController
@property (nonatomic,copy) ReturnStrBlock returnStrBlock;
- (void)returnStr:(ReturnStrBlock)block;
@end
