//
//  FunModel.h
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunModel : NSObject
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *funId;
@property (nonatomic, strong) NSString *funName;
@property (nonatomic, strong) NSString *superiorId;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) long int tag;
@end
