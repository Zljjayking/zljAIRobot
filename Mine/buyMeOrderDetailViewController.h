//
//  buyMeOrderDetailViewController.h
//  Financeteam
//
//  Created by Zccf on 2017/8/10.
//  Copyright © 2017年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "buyMeOrderModel.h"
@interface buyMeOrderDetailViewController : BaseViewController
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) buyMeOrderModel *model;
@end
