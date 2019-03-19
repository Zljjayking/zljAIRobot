//
//  dept_idModel.h
//  Financeteam
//
//  Created by Zccf on 16/6/1.
//  Copyright © 2016年 xzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dept_idModel : NSObject
@property (nonatomic) BOOL isSelected;
@property (nonatomic, strong) NSMutableArray *avilableArr;
@property (nonatomic) NSInteger dept_tag;
@property (nonatomic, strong) NSString *dept_Name;
@end
