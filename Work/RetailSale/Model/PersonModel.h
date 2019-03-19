//
//  PersonModel.h
//  BeautyAddressBook
//
//  Created by 余华俊 on 15/10/22.
//  Copyright © 2015年 hackxhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,copy) NSString *phoneStr;
@property (nonatomic,copy) NSString *callStateStr;//0.呼叫失败 1.已呼叫 2.未接通 3.未拨打
@end
