//
//  LocationVC.h
//  365FinanceCircle
//
//  Created by kpkj-ios on 15/11/12.
//  Copyright © 2015年 kpkj-ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Province.h"
#import "City.h"
#import "Area.h"

typedef void(^locaBlock)(NSInteger num1,NSInteger num2,NSInteger num3,NSString * str);

@interface LocationView : UIView

@property (nonatomic) BOOL firstPage;
@property (nonatomic,copy) locaBlock locaBlock;

-(void)reloadData;


@end
