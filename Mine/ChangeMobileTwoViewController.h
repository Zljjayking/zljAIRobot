//
//  ChangeMobileTwoViewController.h
//  Financeteam
//
//  Created by Zccf on 17/4/14.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^refreshBlockee)();
@interface ChangeMobileTwoViewController : BaseViewController
@property (nonatomic, strong) refreshBlockee block;
@end
