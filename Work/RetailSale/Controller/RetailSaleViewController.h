//
//  RetailSaleViewController.h
//  Financeteam
//
//  Created by Zccf on 16/8/8.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

@interface RetailSaleViewController : BaseViewController

@property (strong, nonatomic) UISearchController *searchController;

@property (nonatomic,copy)NSString * testStr;

@property (nonatomic,strong)NSMutableArray * excelArray;

@end
