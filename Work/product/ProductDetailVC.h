//
//  ProductDetailVC.h
//  365FinanceCircle
//
//  Created by kpkj-ios on 15/8/24.
//  Copyright (c) 2015年 kpkj-ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productModel.h"
#import "BaseViewController.h"
typedef void (^refreshProductBlock) ();
@interface ProductDetailVC : BaseViewController
@property (nonatomic,retain) productModel * product;
@property (nonatomic) NSInteger setype;
@property (nonatomic) BOOL isUpdatePro;
@property (nonatomic) BOOL isPushPro;
@property (nonatomic) BOOL isFromMessage;//是否从消息点进来
@property (nonatomic) refreshProductBlock refreshBlock;
@property (nonatomic, strong) NSString *publicity_mech_id;
@property (nonatomic, strong) NSString *jrq_mechanism_id;
@end
