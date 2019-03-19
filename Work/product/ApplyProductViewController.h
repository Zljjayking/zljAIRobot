//
//  ApplyProductViewController.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"
#import "LocationView.h"
#import "productModel.h"


@interface ApplyProductViewController : BaseViewController

@property(nonatomic,strong)LocationView * locaView;

@property (nonatomic,retain) productModel * product;


@end
