//
//  DetailViewController.h
//  UI-Lesson-2-work
//
//  Created by archerzz on 15/4/27.
//  Copyright (c) 2015年 archerzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pjsip.h"
typedef void (^ReturnCallCountBlock)(NSDictionary *callCountDic);
@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic,strong)Pjsip * pjSip;
@property (nonatomic, strong) NSString *domain;//服务器地址
@property (nonatomic, strong) NSString * callCount;
@property (nonatomic, copy) ReturnCallCountBlock callCountBlock;
- (void)returnCallCountBlock:(ReturnCallCountBlock)block;

@end
