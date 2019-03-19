//
//  PersonalServiceVC.h
//  Financeteam
//
//  Created by 张正飞 on 16/6/12.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^myBlock)(NSString *returnString);

@interface PersonalServiceVC : BaseViewController

@property(nonatomic,copy) myBlock returnBlock ;

-(void)returnText:(myBlock)block;

@end
