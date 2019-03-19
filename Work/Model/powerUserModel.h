//
//  powerUserModel.h
//  Financeteam
//
//  Created by Zccf on 16/5/18.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface powerUserModel : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSMutableArray *avilablePersonNameArr;
@property (nonatomic, strong) NSMutableArray *avilablePersonImageArr;
@end
