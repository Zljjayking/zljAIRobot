//
//  approvalViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/5/5.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^refreshDBlock)();
@interface approvalViewController : BaseViewController
@property (nonatomic, strong) refreshDBlock refreshBlock;
@end
