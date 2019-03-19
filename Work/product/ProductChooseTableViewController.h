//
//  ProductChooseTableViewController.h
//  Financeteam
//
//  Created by 徐兆阳 on 16/5/30.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef void (^myBlock)(NSString *returnStr);

@interface ProductChooseTableViewController : BaseViewController
@property(nonatomic,copy) myBlock returnBlock ;
@property(nonatomic,retain)NSArray *dataArr;
@property (nonatomic,assign) NSInteger type;
-(void)makeTableviewFrame;

-(void)returnText:(myBlock)block;

@end
