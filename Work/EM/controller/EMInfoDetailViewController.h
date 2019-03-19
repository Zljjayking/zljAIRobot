//
//  EMInfoDetailViewController.h
//  Financeteam
//
//  Created by Zccf on 17/4/25.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "RootTwoViewController.h"
#import "BaseViewController.h"
typedef void (^refreshTop) ();
@interface EMInfoDetailViewController : RootTwoViewController
@property (nonatomic) NSString *userId;
@property (nonatomic) refreshTop block;
@end
