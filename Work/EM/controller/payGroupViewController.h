//
//  payGroupViewController.h
//  Financeteam
//
//  Created by Zccf on 17/4/27.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^frshTopView) ();
@interface payGroupViewController : BaseViewController
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *Id;
@property (nonatomic) frshTopView Block;
@end
