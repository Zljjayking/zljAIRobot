//
//  OrderViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/20.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderViewController : BaseViewController
@property (nonatomic, strong) NSString *isScroll;
@property(nonatomic)BOOL isAssignedApprover;
@property (nonatomic) NSInteger page;
@property (nonatomic) BOOL ispush;
@end
